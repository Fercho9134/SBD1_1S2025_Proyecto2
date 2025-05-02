--Vistas relacionadas con prestamos
--vw_active_loans
--vw_inactive_loans
CREATE OR REPLACE VIEW vw_active_loans AS
SELECT 
    p.id_prestamo,
    p.monto_prestamo,
    p.tasa_interes,
    p.meses AS plazo_total_meses,
    p.meses_restantes,
    p.monto_restante,
    p.fecha_contratacion,
    p.fecha_vencimiento,
    c.nombre || ' ' || c.apellido AS cliente,
    CASE 
        WHEN p.fecha_vencimiento >= SYSDATE AND p.monto_restante > 0 THEN 'ACTIVO'
        WHEN p.fecha_vencimiento < SYSDATE AND p.monto_restante > 0 THEN 'VENCIDO'
        ELSE 'INACTIVO'
    END AS estado_prestamo,
    (SELECT COUNT(*) 
     FROM CUOTA_PRESTAMO cp 
     WHERE cp.id_prestamo = p.id_prestamo 
     AND cp.estado = 'PENDIENTE') AS cuotas_pendientes,
    (SELECT NVL(SUM(monto_cuota), 0)
     FROM CUOTA_PRESTAMO cp 
     WHERE cp.id_prestamo = p.id_prestamo 
     AND cp.estado = 'PENDIENTE') AS total_pendiente
FROM 
    PRESTAMO p
JOIN 
    CLIENTE c ON p.id_cliente = c.id_cliente
WHERE 
    p.monto_restante > 0
    AND p.fecha_vencimiento >= SYSDATE
ORDER BY 
    p.fecha_vencimiento;


CREATE OR REPLACE VIEW vw_inactive_loans AS
SELECT 
    p.id_prestamo,
    p.monto_prestamo,
    p.tasa_interes,
    p.meses AS plazo_total_meses,
    p.monto_restante,
    p.fecha_contratacion,
    p.fecha_vencimiento,
    c.nombre || ' ' || c.apellido AS cliente,
    CASE 
        WHEN p.monto_restante <= 0 THEN 'PAGADO COMPLETO'
        WHEN p.fecha_vencimiento < SYSDATE AND p.monto_restante > 0 THEN 'VENCIDO CON SALDO'
        ELSE 'INACTIVO'
    END AS estado_prestamo,
    (SELECT MAX(fecha_pago) 
     FROM CUOTA_PRESTAMO cp 
     WHERE cp.id_prestamo = p.id_prestamo) AS ultima_fecha_pago,
    (SELECT COUNT(*) 
     FROM CUOTA_PRESTAMO cp 
     WHERE cp.id_prestamo = p.id_prestamo 
     AND cp.estado = 'PAGADA') AS cuotas_pagadas
FROM 
    PRESTAMO p
JOIN 
    CLIENTE c ON p.id_cliente = c.id_cliente
WHERE 
    p.monto_restante <= 0
    OR p.fecha_vencimiento < SYSDATE
ORDER BY 
    CASE 
        WHEN p.monto_restante <= 0 THEN 1
        ELSE 2
    END,
    p.fecha_vencimiento DESC;