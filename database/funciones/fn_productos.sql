--Funciones relacionadas con productos/servicios
--fn_amount_services_by_client
--fn_avg_services
--fn_total_amount_services_by_client
--fn_max_amount_products
--fn_max_value_products
CREATE OR REPLACE FUNCTION fn_amount_services_by_client(
    p_id_cliente IN CLIENTE.id_cliente%TYPE,
    p_fecha_inicial IN DATE,
    p_fecha_final IN DATE
) RETURN NUMBER IS
    v_cliente_existe NUMBER;
    v_cantidad_servicios NUMBER := 0;
BEGIN
    -- Validar que el cliente existe
    SELECT COUNT(*) INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;
    
    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Error: El cliente especificado no existe');
    END IF;
    
    -- Validar fechas
    IF p_fecha_inicial > p_fecha_final THEN
        RAISE_APPLICATION_ERROR(-20011, 'Error: La fecha inicial no puede ser mayor a la fecha final');
    END IF;
    
    -- Validar que las fechas no sean futuras
    IF p_fecha_inicial > TRUNC(SYSDATE) OR p_fecha_final > TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20012, 'Error: Las fechas no pueden ser futuras');
    END IF;
    
    -- Contar productos/servicios del cliente en el rango de fechas
    SELECT COUNT(*)
    INTO v_cantidad_servicios
    FROM PAGO_PRODUCTO_SERVICIO pps
    JOIN TIPO_PAGO tp ON pps.id_tipo_pago = tp.id_tipo_pago
    WHERE pps.id_cliente = p_id_cliente
    AND TRUNC(pps.created_at) BETWEEN TRUNC(p_fecha_inicial) AND TRUNC(p_fecha_final);
    
    RETURN v_cantidad_servicios;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20013, 'Error al contar servicios: ' || SQLERRM);
END fn_amount_services_by_client;
/



CREATE OR REPLACE FUNCTION fn_avg_services(
    p_fecha_inicial IN DATE,
    p_fecha_final IN DATE
) RETURN NUMBER IS
    v_promedio NUMBER := 0;
    v_clientes_con_servicios NUMBER := 0;
    v_total_servicios NUMBER := 0;
BEGIN
    -- Validar fechas
    IF p_fecha_inicial > p_fecha_final THEN
        RAISE_APPLICATION_ERROR(-20020, 'Error: La fecha inicial no puede ser mayor a la fecha final');
    END IF;
    
    IF p_fecha_inicial > TRUNC(SYSDATE) OR p_fecha_final > TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20021, 'Error: Las fechas no pueden ser futuras');
    END IF;
    
    -- Calcular el promedio de servicios por cliente
    SELECT 
        AVG(servicios_por_cliente)
    INTO 
        v_promedio
    FROM (
        SELECT 
            id_cliente, 
            COUNT(*) as servicios_por_cliente
        FROM 
            PAGO_PRODUCTO_SERVICIO
        WHERE 
            TRUNC(created_at) BETWEEN TRUNC(p_fecha_inicial) AND TRUNC(p_fecha_final)
        GROUP BY 
            id_cliente
    );
    
    -- Si no hay datos, devolver 0 en lugar de NULL
    RETURN NVL(v_promedio, 0);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20022, 'Error calculando promedio de servicios: ' || SQLERRM);
END fn_avg_services;
/

CREATE OR REPLACE FUNCTION fn_total_amount_services_by_client(
    p_id_cliente IN CLIENTE.id_cliente%TYPE,
    p_fecha_inicial IN DATE,
    p_fecha_final IN DATE
) RETURN NUMBER IS
    v_cliente_existe NUMBER;
    v_total_servicios NUMBER := 0;
BEGIN
    -- Validar que el cliente existe
    SELECT COUNT(*) INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;
    
    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20030, 'Error: El cliente especificado no existe');
    END IF;
    
    -- Validar fechas
    IF p_fecha_inicial > p_fecha_final THEN
        RAISE_APPLICATION_ERROR(-20031, 'Error: La fecha inicial no puede ser mayor a la fecha final');
    END IF;
    
    IF p_fecha_inicial > TRUNC(SYSDATE) OR p_fecha_final > TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20032, 'Error: Las fechas no pueden ser futuras');
    END IF;
    
    -- Calcular el total de servicios del cliente en el rango de fechas
    SELECT NVL(SUM(monto), 0)
    INTO v_total_servicios
    FROM PAGO_PRODUCTO_SERVICIO
    WHERE id_cliente = p_id_cliente
    AND TRUNC(created_at) BETWEEN TRUNC(p_fecha_inicial) AND TRUNC(p_fecha_final);
    
    RETURN v_total_servicios;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20033, 'Error calculando total de servicios: ' || SQLERRM);
END fn_total_amount_services_by_client;
/


CREATE OR REPLACE FUNCTION fn_max_amount_products(
    p_fecha IN DATE
) RETURN NUMBER IS
    v_max_cantidad NUMBER := 0;
BEGIN
    -- Validar que la fecha no sea futura
    IF p_fecha > TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20060, 'Error: La fecha no puede ser futura');
    END IF;
    
    -- Obtener la máxima cantidad de productos/servicios en la fecha
    SELECT MAX(contador)
    INTO v_max_cantidad
    FROM (
        SELECT COUNT(*) AS contador
        FROM PAGO_PRODUCTO_SERVICIO
        WHERE TRUNC(created_at) = TRUNC(p_fecha)
        GROUP BY id_cliente
    );
    
    -- Si no hay registros, devolver 0
    RETURN NVL(v_max_cantidad, 0);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20061, 'Error calculando máxima cantidad de productos: ' || SQLERRM);
END fn_max_amount_products;
/

CREATE OR REPLACE FUNCTION fn_max_value_products(
    p_fecha IN DATE
) RETURN NUMBER IS
    v_max_monto NUMBER := 0;
BEGIN
    -- Validar que la fecha no sea futura
    IF p_fecha > TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20070, 'Error: La fecha no puede ser futura');
    END IF;
    
    -- Obtener el máximo monto total de pagos por cliente en la fecha
    SELECT MAX(total_monto)
    INTO v_max_monto
    FROM (
        SELECT SUM(monto) AS total_monto
        FROM PAGO_PRODUCTO_SERVICIO
        WHERE TRUNC(created_at) = TRUNC(p_fecha)
        GROUP BY id_cliente
    );
    
    -- Si no hay registros, devolver 0
    RETURN NVL(v_max_monto, 0);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20071, 'Error calculando máximo monto de productos: ' || SQLERRM);
END fn_max_value_products;
/