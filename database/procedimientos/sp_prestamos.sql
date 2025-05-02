--Procedimientos relacionados con prestamos
CREATE OR REPLACE PROCEDURE sp_get_loan(
    p_id_cliente IN INTEGER,
    p_monto_prestamo IN NUMBER,
    p_tasa_interes IN NUMBER,
    p_meses IN INTEGER
) IS
    v_id_prestamo INTEGER;
    v_fecha_vencimiento DATE;
    v_monto_cuota NUMBER(12,2);
    v_interes_mensual NUMBER;
    v_tasa_mensual NUMBER;
    v_saldo_restante NUMBER;
    v_capital_cuota NUMBER;
    v_interes_cuota NUMBER;
    v_cliente_existe INTEGER;
BEGIN

    --Validar que el cliente existe
    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;


    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El cliente no existe');
    END IF;

    -- Validaciones básicas
    IF p_monto_prestamo <= 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'El monto del préstamo debe ser positivo');
    END IF;
    
    IF p_tasa_interes < 0 THEN
        RAISE_APPLICATION_ERROR(-20021, 'La tasa de interés no puede ser negativa');
    END IF;
    
    IF p_meses <= 0 THEN
        RAISE_APPLICATION_ERROR(-20022, 'El plazo en meses debe ser positivo');
    END IF;
    
    -- Calcular fecha de vencimiento
    v_fecha_vencimiento := ADD_MONTHS(TRUNC(SYSDATE), p_meses);
    
    -- Insertar el préstamo principal
    INSERT INTO PRESTAMO (
        id_cliente,
        monto_prestamo,
        tasa_interes,
        meses,
        monto_restante,
        meses_restantes,
        fecha_vencimiento
    ) VALUES (
        p_id_cliente,
        p_monto_prestamo,
        p_tasa_interes,
        p_meses,
        p_monto_prestamo, -- Inicialmente igual al monto total
        p_meses,          -- Todos los meses pendientes al inicio
        v_fecha_vencimiento
    ) RETURNING id_prestamo INTO v_id_prestamo;
    
    -- Calcular tasa mensual (convertimos tasa anual a mensual)
    v_tasa_mensual := p_tasa_interes / 12 / 100;
    
    -- Calcular cuota mensual
    v_monto_cuota := p_monto_prestamo * (v_tasa_mensual * POWER(1 + v_tasa_mensual, p_meses)) / 
                    (POWER(1 + v_tasa_mensual, p_meses) - 1);
    
    v_saldo_restante := p_monto_prestamo;
    
    -- Generar todas las cuotas
    FOR i IN 1..p_meses LOOP
        v_interes_cuota := v_saldo_restante * v_tasa_mensual;
        v_capital_cuota := v_monto_cuota - v_interes_cuota;
        v_saldo_restante := v_saldo_restante - v_capital_cuota;
        
        -- Insertar la cuota
        INSERT INTO CUOTA_PRESTAMO (
            id_prestamo,
            numero_cuota,
            fecha_vencimiento,
            monto_cuota,
            capital,
            interes,
            saldo_restante
        ) VALUES (
            v_id_prestamo,
            i,
            ADD_MONTHS(TRUNC(SYSDATE), i),
            v_monto_cuota,
            v_capital_cuota,
            v_interes_cuota,
            v_saldo_restante
        );
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Préstamo creado exitosamente. ID: ' || v_id_prestamo);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al crear préstamo: ' || SQLERRM);
        RAISE;
END sp_get_loan;
/

CREATE OR REPLACE FUNCTION fn_pagar_proxima_cuota(
    p_id_prestamo IN INTEGER,
    p_fecha_pago IN DATE DEFAULT SYSDATE,
    p_monto_pagado IN NUMBER DEFAULT NULL
) RETURN VARCHAR2 IS
    v_cuota CUOTA_PRESTAMO%ROWTYPE;
    v_prestamo PRESTAMO%ROWTYPE;
    v_resultado VARCHAR2(200);
    
    -- Definimos excepciones personalizadas
    e_prestamo_no_encontrado EXCEPTION;
    e_no_cuotas_pendientes EXCEPTION;
    e_monto_insuficiente EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_prestamo_no_encontrado, -20001);
    PRAGMA EXCEPTION_INIT(e_no_cuotas_pendientes, -20002);
    PRAGMA EXCEPTION_INIT(e_monto_insuficiente, -20003);
BEGIN
    -- Validar que el préstamo existe
    BEGIN
        SELECT * INTO v_prestamo
        FROM PRESTAMO
        WHERE id_prestamo = p_id_prestamo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_prestamo_no_encontrado;
    END;
    
    -- Buscar la próxima cuota pendiente
    BEGIN
        SELECT * INTO v_cuota
        FROM (
            SELECT *
            FROM CUOTA_PRESTAMO
            WHERE id_prestamo = p_id_prestamo
            AND estado = 'PENDIENTE'
            ORDER BY numero_cuota ASC
        )
        WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_no_cuotas_pendientes;
    END;
    
    -- Validar monto si se especificó
    IF p_monto_pagado IS NOT NULL AND p_monto_pagado < v_cuota.monto_cuota THEN
        RAISE e_monto_insuficiente;
    END IF;
    
    -- Realizar el pago
    UPDATE CUOTA_PRESTAMO
    SET estado = 'PAGADA',
        fecha_pago = p_fecha_pago
    WHERE id_prestamo = p_id_prestamo
    AND numero_cuota = v_cuota.numero_cuota;
    
    UPDATE PRESTAMO
    SET monto_restante = monto_restante - v_cuota.capital,
        meses_restantes = meses_restantes - 1
    WHERE id_prestamo = p_id_prestamo;
    
    COMMIT;
    
    -- Construir mensaje de éxito
    v_resultado := 'EXITO: Cuota #' || v_cuota.numero_cuota || ' pagada. ' ||
                  'Capital: ' || TO_CHAR(v_cuota.capital, 'L999G990D00') || 
                  ' | Interés: ' || TO_CHAR(v_cuota.interes, 'L999G990D00');
    
    -- Verificar si es la última cuota
    IF v_prestamo.meses_restantes - 1 = 0 THEN
        v_resultado := v_resultado || ' | ¡Préstamo completado!';
    END IF;
    
    RETURN v_resultado;
EXCEPTION
    WHEN e_prestamo_no_encontrado THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Préstamo no encontrado');
    WHEN e_no_cuotas_pendientes THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'No hay cuotas pendientes para este préstamo');
    WHEN e_monto_insuficiente THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Monto insuficiente para pagar la cuota completa');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20099, 'Error al procesar pago: ' || SUBSTR(SQLERRM, 1, 200));
END fn_pagar_proxima_cuota;
/

CREATE OR REPLACE PROCEDURE sp_verificar_moras IS
BEGIN
    -- Marcar cuotas vencidas no pagadas
    UPDATE CUOTA_PRESTAMO
    SET estado = 'VENCIDA'
    WHERE estado = 'PENDIENTE'
    AND fecha_vencimiento < TRUNC(SYSDATE);

    -- Marcar cuotas con mora mayor a 30 días
    UPDATE CUOTA_PRESTAMO
    SET estado = 'MORA'
    WHERE estado = 'VENCIDA'
    AND fecha_vencimiento < ADD_MONTHS(TRUNC(SYSDATE), -1);

    --Agregar notificacion al cliente con el procedimiento de notificaciones
    FOR r IN (
    SELECT DISTINCT p.id_cliente, c.estado, c.id_prestamo
    FROM PRESTAMO p
    JOIN CUOTA_PRESTAMO c ON p.id_prestamo = c.id_prestamo
    WHERE c.estado IN ('VENCIDA', 'MORA')
    ) LOOP
        IF r.estado = 'MORA' THEN
            sp_register_notification(
                r.id_cliente,
                'La cuota del préstamo ' || r.id_prestamo || ' está en mora',
                SYSDATE
            );
        ELSIF r.estado = 'VENCIDA' THEN
            sp_register_notification(
                r.id_cliente,
                'La cuota del préstamo ' || r.id_prestamo || ' está vencida',
                SYSDATE
            );
        END IF;
    END LOOP;

    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Verificación de moras completada: ' || SQL%ROWCOUNT || ' cuotas actualizadas');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al verificar moras: ' || SQLERRM);
END sp_verificar_moras;
/

CREATE OR REPLACE PROCEDURE sp_consultar_cuotas_pendientes(
    p_id_prestamo IN INTEGER
) IS
    CURSOR c_cuotas IS
        SELECT numero_cuota, fecha_vencimiento, monto_cuota
        FROM CUOTA_PRESTAMO
        WHERE id_prestamo = p_id_prestamo
        AND estado = 'PENDIENTE'
        ORDER BY numero_cuota;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Cuotas pendientes para el préstamo ' || p_id_prestamo);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------');
    
    FOR cuota IN c_cuotas LOOP
        DBMS_OUTPUT.PUT_LINE('Cuota #' || cuota.numero_cuota || 
                            ' - Vence: ' || TO_CHAR(cuota.fecha_vencimiento, 'DD/MM/YYYY') || 
                            ' - Monto: ' || TO_CHAR(cuota.monto_cuota, 'L999G990D00'));
    END LOOP;
END sp_consultar_cuotas_pendientes;
/