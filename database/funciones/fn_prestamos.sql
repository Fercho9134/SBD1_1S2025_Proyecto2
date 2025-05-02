--Funciones relacionadas con prestamos
--fn_next_payment
CREATE OR REPLACE FUNCTION fn_next_payment(
    p_id_cliente IN CLIENTE.id_cliente%TYPE,
    p_id_prestamo IN PRESTAMO.id_prestamo%TYPE
) RETURN NUMBER IS
    v_cliente_existe NUMBER;
    v_prestamo_existe NUMBER;
    v_proxima_cuota NUMBER;
BEGIN
    -- Validar que el cliente existe
    SELECT COUNT(*) INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;
    
    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20040, 'Error: El cliente especificado no existe');
    END IF;
    
    -- Validar que el préstamo existe y pertenece al cliente
    SELECT COUNT(*) INTO v_prestamo_existe
    FROM PRESTAMO
    WHERE id_prestamo = p_id_prestamo
    AND id_cliente = p_id_cliente;
    
    IF v_prestamo_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20041, 'Error: El préstamo no existe o no pertenece al cliente');
    END IF;
    
    -- Obtener el monto de la próxima cuota pendiente
    SELECT monto_cuota
    INTO v_proxima_cuota
    FROM CUOTA_PRESTAMO
    WHERE id_prestamo = p_id_prestamo
    AND estado = 'PENDIENTE'
    AND fecha_vencimiento = (
        SELECT MIN(fecha_vencimiento)
        FROM CUOTA_PRESTAMO
        WHERE id_prestamo = p_id_prestamo
        AND estado = 'PENDIENTE'
    )
    AND ROWNUM = 1; -- Para asegurar solo un resultado
    
    RETURN v_proxima_cuota;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- No hay cuotas pendientes
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20042, 'Error: Múltiples cuotas encontradas para la misma fecha');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20043, 'Error al consultar próxima cuota: ' || SQLERRM);
END fn_next_payment;
/
