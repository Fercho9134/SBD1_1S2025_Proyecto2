CREATE OR REPLACE PROCEDURE sp_register_new_account(
    p_numero_cuenta IN INTEGER,
    p_id_cliente IN INTEGER,
    p_monto_apertura IN NUMBER(12,2),
    p_saldo_cuenta IN NUMBER(12,2),
    p_tipo_cuenta IN INTEGER,
    p_descripcion IN VARCHAR2(75),
    p_otros_detalles IN VARCHAR2(100) DEFAULT NULL
)
IS
    v_cliente_existe NUMBER;
    v_tipo_cuenta_existe NUMBER;
    v_cuenta_existe NUMBER;
BEGIN
    -- Validar que el número de cuenta no esté duplicado
    SELECT COUNT(*) INTO v_cuenta_existe FROM CUENTA WHERE numero_cuenta = p_numero_cuenta;
    IF v_cuenta_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Error: El número de cuenta ya está registrado');
    END IF;

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

    -- Insertar la nueva cuenta
    INSERT INTO CUENTA (
        numero_cuenta,
        id_cliente,
        monto_apertura,
        saldo_cuenta,
        tipo_cuenta,
        descripcion,
        otros_detalles
    ) VALUES (
        p_numero_cuenta,
        p_id_cliente,
        p_monto_apertura,
        p_saldo_cuenta,
        p_tipo_cuenta,
        p_descripcion,
        p_otros_detalles
    );

    -- Finalizar y mostrar mensaje OK
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cuenta creada exitosamente. Número de cuenta: ' || p_numero_cuenta);

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
    p_nombre IN VARCHAR2(50),
    p_descripcion IN VARCHAR2(100)
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

    -- Insertar el nuevo tipo de cuenta
    INSERT INTO TIPO_CUENTA (
        nombre,
        descripcion
    ) VALUES (
        p_nombre,
        p_descripcion
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

-- Ejemplo de llamada
-- BEGIN
--     sp_register_new_type_account(
--         p_nombre => 'Cuenta Ahorro',
--         p_descripcion => 'Esta cuenta genera un interés anual del 2%, lo que la hace ideal para guardar fondos a largo plazo.'
--     );
-- END;
-- /