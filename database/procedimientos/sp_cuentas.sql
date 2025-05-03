CREATE OR REPLACE PROCEDURE sp_register_new_account(
    p_id_cliente IN INTEGER,
    p_monto_apertura IN NUMBER,
    p_fecha_apertura IN DATE DEFAULT SYSDATE,
    p_saldo_cuenta IN NUMBER,
    p_tipo_cuenta IN INTEGER,
    p_descripcion IN VARCHAR2 DEFAULT 'Cuenta de banco',
    p_otros_detalles IN VARCHAR2 DEFAULT NULL
)
IS
    v_cliente_existe NUMBER;
    v_tipo_cuenta_existe NUMBER;
    v_cuenta_existe NUMBER;
BEGIN


    -- Validar que el cliente exista
    SELECT COUNT(*) INTO v_cliente_existe FROM CLIENTE WHERE id_cliente = p_id_cliente;
    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20021, 'Error: El ID de cliente no existe');
    END IF;

    -- Validar monto_apertura positivo
    IF p_monto_apertura <= 0 THEN
        RAISE_APPLICATION_ERROR(-20022, 'Error: El monto de apertura debe ser positivo');
    END IF;

    -- Validar saldo_cuenta no negativo
    IF p_saldo_cuenta < 0 THEN
        RAISE_APPLICATION_ERROR(-20023, 'Error: El saldo no puede ser negativo');
    END IF;
    
    -- Validar que el tipo de cuenta exista
    SELECT COUNT(*) INTO v_tipo_cuenta_existe FROM TIPO_CUENTA WHERE id_tipo_cuenta = p_tipo_cuenta;
    IF v_tipo_cuenta_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20025, 'Error: El tipo de cuenta especificado no existe');
    END IF;

    --Verificar fecha valida
    IF p_fecha_apertura IS NOT NULL THEN
        IF p_fecha_apertura > TRUNC(SYSDATE) THEN
            RAISE_APPLICATION_ERROR(-20024, 'Error: La fecha de apertura no puede ser futura');
        END IF;
    END IF;

    

   
    INSERT INTO CUENTA (
    id_cliente,
    monto_apertura,
    saldo_cuenta,
    fecha_apertura,
    tipo_cuenta, 
    descripcion,  
    otros_detalles
    ) VALUES (
        p_id_cliente,
        p_monto_apertura,
        p_saldo_cuenta,
        p_fecha_apertura,
        p_tipo_cuenta,  -- Corregido: estaba usando 'interes' sin prefijo
        p_descripcion,
        p_otros_detalles
    );

    -- Finalizar y mostrar mensaje OK
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cuenta creada exitosamente');

    -- Capturar excepciones
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al crear cuenta: ' || SQLERRM);
        RAISE;
END sp_register_new_account;
/

-- Ejemplo de llamada
-- BEGIN
--     agregar_cuenta(
--         p_numero_cuenta => 100001,
--         p_id_cliente => 1,
--         p_monto_apertura => 1000.00,
--         p_saldo_cuenta => 1000.00,
--         p_tipo_cuenta => 1,
--         p_descripcion => 'Cuenta de ahorros premium',
--         p_otros_detalles => 'Cuenta principal con intereses al 5%'
--     );
-- END;
-- /

CREATE OR REPLACE PROCEDURE sp_register_new_type_account(
    p_nombre IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_interes IN NUMBER DEFAULT 0.0
)
IS
    v_regex_letras VARCHAR2(100) := '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\s.,;:()''-]+$';
    v_count NUMBER;
BEGIN
    -- Validar descripción (letras y caracteres especiales comunes)
    IF NOT REGEXP_LIKE(p_descripcion, v_regex_letras) THEN
        RAISE_APPLICATION_ERROR(-20011, 'Error: La descripcion contiene caracteres no permitidos');
    END IF;

    -- Validar que el nombre no exista ya
    SELECT COUNT(*) INTO v_count FROM TIPO_CUENTA WHERE UPPER(nombre) = UPPER(p_nombre);
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Error: Ya existe un tipo de cuenta con ese nombre');
    END IF;

    -- Validar que el interés sea positivo
    IF p_interes < 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Error: El interés debe ser positivo');
    END IF;

    -- Insertar el nuevo tipo de cuenta
    INSERT INTO TIPO_CUENTA (
        nombre,
        descripcion,
        interes
    ) VALUES (
        p_nombre,
        p_descripcion,
        p_interes
    );

    -- Finalizar y mostrar mensaje OK
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Tipo de cuenta agregado exitosamente');

    -- Capturar excepciones
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al agregar tipo de cuenta: ' || SQLERRM);
        RAISE;
END sp_register_new_type_account;
/

CREATE OR REPLACE PROCEDURE sp_calcular_intereses_cuentas IS
    CURSOR c_cuentas IS
        SELECT c.id_cuenta, c.saldo_cuenta, c.fecha_ultimo_interes, 
               c.fecha_apertura, tc.interes, tc.nombre AS tipo_cuenta
        FROM CUENTA c
        JOIN TIPO_CUENTA tc ON c.tipo_cuenta = tc.id_tipo_cuenta
        WHERE c.saldo_cuenta > 0;
    
    v_fecha_actual DATE := TRUNC(SYSDATE);
    v_dias_periodo INTEGER;
    v_intereses NUMBER;
    v_periodo_inicio DATE;
    v_periodo_fin DATE;
BEGIN
    FOR r_cuenta IN c_cuentas LOOP
        -- Determinar fecha de inicio del período de cálculo
        v_periodo_inicio := NVL(r_cuenta.fecha_ultimo_interes, r_cuenta.fecha_apertura);
        v_periodo_fin := v_fecha_actual;
        
        -- Calcular días transcurridos
        v_dias_periodo := v_periodo_fin - v_periodo_inicio;
        
        -- Solo calcular si han pasado días desde el último cálculo
        IF v_dias_periodo > 0 THEN
            -- Calcular intereses (tasa anual → diaria)
            v_intereses := r_cuenta.saldo_cuenta * (r_cuenta.interes/365/100) * v_dias_periodo;
            
            -- Actualizar saldo y fecha de último interés
            UPDATE CUENTA
            SET saldo_cuenta = saldo_cuenta + v_intereses,
                fecha_ultimo_interes = v_fecha_actual
            WHERE id_cuenta = r_cuenta.id_cuenta;
            
            -- Registrar el interés generado (opcional)
            INSERT INTO INTERES_CUENTA (
                id_cuenta,
                fecha_calculo,
                monto_interes,
                periodo_inicio,
                periodo_fin
            ) VALUES (
                r_cuenta.id_cuenta,
                v_fecha_actual,
                v_intereses,
                v_periodo_inicio,
                v_periodo_fin
            );
            
            DBMS_OUTPUT.PUT_LINE('Cuenta ' || r_cuenta.id_cuenta || ' (' || r_cuenta.tipo_cuenta || 
                                '): Intereses calculados: ' || TO_CHAR(v_intereses, 'L999G990D00'));
        END IF;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso de cálculo de intereses completado');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al calcular intereses: ' || SQLERRM);
        RAISE;
END sp_calcular_intereses_cuentas;
/

-- Ejemplo de llamada
-- BEGIN
--     sp_register_new_type_account(
--         p_nombre => 'Cuenta Ahorro',
--         p_descripcion => 'Esta cuenta genera un interés anual del 2%, lo que la hace ideal para guardar fondos a largo plazo.'
--     );
-- END;
-- /