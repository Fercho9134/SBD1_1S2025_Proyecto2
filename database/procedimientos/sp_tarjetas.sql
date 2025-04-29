CREATE OR REPLACE PROCEDURE sp_register_new_card(
    p_id_cliente IN INTEGER,
    p_id_cuenta IN INTEGER DEFAULT NULL,
    p_id_tipo_tarjeta IN INTEGER,
    p_id_tipo IN VARCHAR2,
    p_numero_tarjeta IN NUMBER,
    p_moneda IN VARCHAR2,
    p_monto_limite IN NUMBER DEFAULT 0,
    p_dia_corte IN INTEGER,
    p_dia_pago IN INTEGER,
    p_tasa_interes IN INTEGER DEFAULT 0
)
IS
    v_cliente_existe NUMBER;
    v_cuenta_existe NUMBER;
    v_tipo_tarjeta_existe NUMBER;
    v_tarjeta_existe NUMBER;
    v_fecha_vencimiento DATE;
    v_fecha_actual DATE := SYSDATE;
    p_saldo_tarjeta NUMBER(12,2) := p_monto_limite;
BEGIN
    -- Validar que el número de tarjeta no esté duplicado
    SELECT COUNT(*) INTO v_tarjeta_existe FROM TARJETA WHERE numero_tarjeta = p_numero_tarjeta;
    IF v_tarjeta_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20030, 'Error: El número de tarjeta ya está registrado');
    END IF;

    --Validar que el número de tarjeta tenga 16 dígitos y sean solo numeros
    IF LENGTH(p_numero_tarjeta) != 16 OR NOT REGEXP_LIKE(p_numero_tarjeta, '^[0-9]+$') THEN
        RAISE_APPLICATION_ERROR(-20032, 'Error: El número de tarjeta debe tener 16 dígitos y ser solo números');
    END IF;

    -- Validar que el cliente exista
    SELECT COUNT(*) INTO v_cliente_existe FROM CLIENTE WHERE id_cliente = p_id_cliente;
    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20031, 'Error: El ID de cliente no existe');
    END IF;

    -- Validar que el tipo de tarjeta exista
    SELECT COUNT(*) INTO v_tipo_tarjeta_existe FROM TIPO_TARJETA WHERE id_tipo_tarjeta = p_id_tipo_tarjeta;
    IF v_tipo_tarjeta_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20033, 'Error: El tipo de tarjeta especificado no existe');
    END IF;

    -- Validar monto_limite positivo
    IF p_monto_limite <= 0 THEN
        RAISE_APPLICATION_ERROR(-20034, 'Error: El monto límite debe ser positivo');
    END IF;

    -- Validar saldo_tarjeta no negativo
    IF p_saldo_tarjeta < 0 THEN
        RAISE_APPLICATION_ERROR(-20035, 'Error: El saldo no puede ser negativo');
    END IF; 

    IF p_dia_corte < 1 OR p_dia_corte > 31 THEN
        RAISE_APPLICATION_ERROR(-20036, 'Error: El día de corte debe estar entre 1 y 31');
    END IF;

    IF p_dia_pago < 1 OR p_dia_pago > 31 THEN
        RAISE_APPLICATION_ERROR(-20037, 'Error: El día de pago debe estar entre 1 y 31');
    END IF; 

    IF p_tasa_interes < 0 OR p_tasa_interes > 100 THEN
        RAISE_APPLICATION_ERROR(-20038, 'Error: La tasa de interés debe estar entre 0 y 100');
    END IF;

    IF p_id_tipo NOT IN ('C', 'D') THEN
        RAISE_APPLICATION_ERROR(-20039, 'Error: El tipo de tarjeta debe ser "C" o "D"');
    END IF;

    IF p_moneda NOT IN ('Q', '$') THEN
        RAISE_APPLICATION_ERROR(-20040, 'Error: La moneda debe ser "Q" o "$"');
    END IF;

    -- El campo id_cuenta es opcional, solo si p_id_tipo es 'D', debe tener una cuenta asociada
    IF p_id_tipo = 'D' AND p_id_cuenta IS NULL THEN
        RAISE_APPLICATION_ERROR(-20041, 'Error: Para el tipo de tarjeta "D" se requiere una cuenta asociada');
    END IF;

    -- Si se proporciona una cuenta y la tarjeta es de tipo 'C', daros un error
    IF p_id_tipo = 'C' AND p_id_cuenta IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20042, 'Error: Para el tipo de tarjeta "C" no se debe asociar una cuenta');
    END IF;

    -- Si es de tipo 'D', verificar que la cuenta exista
    IF p_id_tipo = 'D' THEN
        SELECT COUNT(*) INTO v_cuenta_existe FROM CUENTA WHERE id_cuenta = p_id_cuenta;
        IF v_cuenta_existe = 0 THEN
            RAISE_APPLICATION_ERROR(-20043, 'Error: La cuenta especificada no existe');
        END IF;
    END IF;


    -- Calcular la fecha de vencimiento (5 años a partir de la fecha actual)
    v_fecha_vencimiento := ADD_MONTHS(v_fecha_actual, 60); -- 5 años = 60 meses


    -- Insertar la nueva tarjeta
    INSERT INTO TARJETA (
        id_cliente,
        id_cuenta,
        id_tipo_tarjeta,
        id_tipo,
        numero_tarjeta,
        moneda,
        monto_limite,
        saldo_tarjeta,
        dia_corte,
        dia_pago,
        tasa_interes,
        fecha_vencimiento
    ) VALUES (
        p_id_cliente,
        p_id_cuenta,
        p_id_tipo_tarjeta,
        p_id_tipo,
        p_numero_tarjeta,
        p_moneda,
        p_monto_limite,
        p_monto_limite, -- Inicialmente el saldo es igual al monto límite
        p_dia_corte,
        p_dia_pago,
        p_tasa_interes,
        v_fecha_vencimiento
    );

    COMMIT; -- Confirmar la transacción

    DBMS_OUTPUT.PUT_LINE('Tarjeta registrada exitosamente con número: ' || p_numero_tarjeta);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- Deshacer la transacción en caso de error
        RAISE_APPLICATION_ERROR(-20044, 'Error al registrar la tarjeta: ' || SQLERRM);
END sp_register_new_card;
/

CREATE OR REPLACE PROCEDURE sp_calcular_intereses_tarjeta(
    p_id_tarjeta IN INTEGER
) IS
    v_tarjeta TARJETA%ROWTYPE;
    v_dias_transcurridos INTEGER;
    v_intereses NUMBER := 0;
    v_fecha_actual DATE := TRUNC(SYSDATE);
BEGIN
    -- Obtener datos de la tarjeta
    SELECT * INTO v_tarjeta
    FROM TARJETA
    WHERE id_tarjeta = p_id_tarjeta;
    
    -- Solo para tarjetas de crédito
    IF v_tarjeta.id_tipo = 'D' THEN
        RETURN; -- Tarjetas de débito no generan intereses
    END IF;
    
    -- Calcular días desde el último cálculo (o desde creación)
    v_dias_transcurridos := v_fecha_actual - NVL(v_tarjeta.fecha_ultimo_interes, v_tarjeta.created_at);
    
    -- Solo calcular si hay saldo pendiente y han pasado días
    IF (v_tarjeta.monto_limite - v_tarjeta.saldo_tarjeta) > 0 AND v_dias_transcurridos > 0 THEN
        -- Calcular intereses (tasa anual → diaria)
        v_intereses := (v_tarjeta.monto_limite - v_tarjeta.saldo_tarjeta) * (v_tarjeta.tasa_interes/365/100) * v_dias_transcurridos;
        
        -- Actualizar saldo y fecha
        UPDATE TARJETA
        SET saldo_tarjeta = saldo_tarjeta - v_intereses,
            fecha_ultimo_interes = v_fecha_actual
        WHERE id_tarjeta = p_id_tarjeta;
        
        -- Registrar movimiento
        INSERT INTO MOVIMIENTO_TARJETA (
            id_tarjeta,
            fecha_movimiento,
            monto,
            descripcion,
            tipo
        ) VALUES (
            p_id_tarjeta,
            SYSTIMESTAMP,
            v_intereses,
            'Intereses generados',
            'D'
        );
        
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error calculando intereses: ' || SQLERRM);
        RAISE;
END sp_calcular_intereses_tarjeta;
/

CREATE OR REPLACE PROCEDURE sp_pagar_tarjeta(
    p_id_tarjeta IN INTEGER,
    p_monto IN NUMBER
) IS
    v_saldo_actual NUMBER;
    v_tarjeta TARJETA%ROWTYPE;
BEGIN
    -- Calcular intereses acumulados hasta hoy
    sp_calcular_intereses_tarjeta(p_id_tarjeta);
    
    -- Obtener saldo actualizado
    SELECT saldo_tarjeta INTO v_saldo_actual
    FROM TARJETA
    WHERE id_tarjeta = p_id_tarjeta;

    SELECT * INTO v_tarjeta
    FROM TARJETA
    WHERE id_tarjeta = p_id_tarjeta;
    
    -- Validar que el pago no exceda el saldo (para tarjetas de crédito)
    DECLARE
        v_tipo_tarjeta VARCHAR2(1);
    BEGIN
        SELECT id_tipo INTO v_tipo_tarjeta
        FROM TARJETA
        WHERE id_tarjeta = p_id_tarjeta;
        
        IF v_tipo_tarjeta = 'C' AND p_monto > (v_tarjeta.monto_limite - v_tarjeta.saldo_tarjeta) THEN
            RAISE_APPLICATION_ERROR(-20002, 'No puede pagar más que el saldo actual');
        END IF;
    END;
    
    -- Aplicar el pago
    UPDATE TARJETA
    SET saldo_tarjeta = saldo_tarjeta + p_monto
    WHERE id_tarjeta = p_id_tarjeta;
    
    INSERT INTO MOVIMIENTO_TARJETA (
        id_tarjeta,
        fecha_movimiento,
        monto,
        descripcion,
        tipo
    ) VALUES (
        p_id_tarjeta,
        SYSTIMESTAMP,
        p_monto,
        'Pago realizado',
        'C'
    );
    
    -- Si el saldo queda en cero, resetear fecha de últimos intereses
    IF ((v_tarjeta.monto_limite - v_tarjeta.saldo_tarjeta) - p_monto) <= 0 THEN
        UPDATE TARJETA
        SET fecha_ultimo_interes = NULL
        WHERE id_tarjeta = p_id_tarjeta;
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pago aplicado. Nuevo saldo: ' || (v_saldo_actual - p_monto));
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en pago: ' || SQLERRM);
        RAISE;
END sp_pagar_tarjeta;
/

-- Ejemplo de llamada para tarjeta de crédito
-- BEGIN
--     sp_register_new_card(
--         p_id_cliente => 1,
--         p_id_tipo_tarjeta => 1,
--         p_id_tipo => 'C',
--         p_numero_tarjeta => 1234567812345678,
--         p_moneda => 'Q',
--         p_monto_limite => 10000,
--         p_saldo_tarjeta => 5000,
--         p_dia_corte => 15,
--         p_dia_pago => 5,
--         p_tasa_interes => 15
--     );
-- END;
-- /

-- Ejemplo de llamada para tarjeta de débito
-- BEGIN
--     sp_register_new_card(
--         p_id_cliente => 1,
--         p_id_cuenta => 1,
--         p_id_tipo_tarjeta => 2,
--         p_id_tipo => 'D',
--         p_numero_tarjeta => 8765432187654321,
--         p_moneda => 'Q',
--         p_monto_limite => 5000,
--         p_saldo_tarjeta => 2000,
--         p_dia_corte => 10,
--         p_dia_pago => 20,
--         p_tasa_interes => 10
--     );
-- END;
