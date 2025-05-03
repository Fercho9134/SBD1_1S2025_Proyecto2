--Vistas relacionadas con seguros
--vw_active_insurances
--vw_inactive_insurances
CREATE OR REPLACE VIEW vw_active_insurances AS
SELECT 
    ts.nombre AS tipo_seguro,
    s.id_seguro,
    s.monto_asegurado,
    s.valor_seguro,
    s.cantidad_pagos,
    s.meses_asegurados,
    s.fecha_contratacion,
    s.fecha_vencimiento,
    c.nombre || ' ' || c.apellido AS cliente
FROM 
    SEGURO s
JOIN 
    TIPO_SEGURO ts ON s.id_tipo_seguro = ts.id_tipo_seguro
JOIN 
    CLIENTE c ON s.id_cliente = c.id_cliente
WHERE 
    s.fecha_vencimiento > SYSTIMESTAMP
ORDER BY 
    s.fecha_vencimiento;

CREATE OR REPLACE VIEW vw_inactive_insurances AS
SELECT 
    ts.nombre AS tipo_seguro,
    s.id_seguro,
    s.monto_asegurado,
    s.valor_seguro,
    s.cantidad_pagos,
    s.meses_asegurados,
    s.fecha_contratacion,
    s.fecha_vencimiento,
    c.nombre || ' ' || c.apellido AS cliente,
    CASE 
        WHEN s.fecha_vencimiento < SYSTIMESTAMP THEN 'Vencido'
        ELSE 'Inactivo por otro motivo'
    END AS estado
FROM 
    SEGURO s
JOIN 
    TIPO_SEGURO ts ON s.id_tipo_seguro = ts.id_tipo_seguro
JOIN 
    CLIENTE c ON s.id_cliente = c.id_cliente
WHERE 
    s.fecha_vencimiento <= SYSTIMESTAMP
ORDER BY 
    s.fecha_vencimiento DESC;
