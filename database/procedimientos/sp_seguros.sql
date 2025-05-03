--Procedimientos relacionados con seguros
--sp_get_insurance

CREATE OR REPLACE PROCEDURE sp_get_insurance(
    p_id_tipo_seguro IN INTEGER,
    p_monto_asegurado IN NUMBER,
    p_valor_seguro IN NUMBER,
    p_cantidad_pagos IN INTEGER,
    p_meses_asegurados IN INTEGER,
    p_id_cliente IN INTEGER
)
IS
    v_fecha_vencimiento TIMESTAMP;
    v_fecha_contratacion TIMESTAMP;
    v_cliente_existente INTEGER;

BEGIN
    -- Paso 1 verificaciones de valores posuivos y existencias de cliente y tipo de seguro
    IF p_monto_asegurado <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El monto asegurado debe ser mayor a 0.');
    END IF;

    IF p_valor_seguro <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El valor del seguro debe ser mayor a 0.');
    END IF;

    IF p_cantidad_pagos < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'La cantidad de pagos debe ser mayor a 0.');
    END IF;

    IF p_meses_asegurados <= 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Los meses asegurados deben ser mayor a 0.');
    END IF;

    -- Verificar si el cliente existe
    SELECT COUNT(*)
    INTO v_cliente_existente
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;


    IF v_cliente_existente = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El cliente no existe.');
    END IF;

    --Si se pasaron todas las validaciones, se procede a insertar el seguro
    -- Paso 2 calcular la fecha de vencimiento y la fecha de contratacion
    -- a La fecha actual se le suma la cantidad de meses asegurados
    v_fecha_contratacion := SYSTIMESTAMP;
    v_fecha_vencimiento := ADD_MONTHS(v_fecha_contratacion, p_meses_asegurados);

    -- Paso 3 insertar el seguro
    INSERT INTO SEGURO (id_tipo_seguro, id_cliente, monto_asegurado, valor_seguro, cantidad_pagos, meses_asegurados, fecha_contratacion, fecha_vencimiento)
    VALUES (p_id_tipo_seguro, p_id_cliente, p_monto_asegurado, p_valor_seguro, p_cantidad_pagos, p_meses_asegurados, v_fecha_contratacion, v_fecha_vencimiento);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Seguro creado con éxito. ID del seguro: ' || SQL%ROWCOUNT);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al crear el seguro: ' || SQLERRM);
END sp_get_insurance;
/
