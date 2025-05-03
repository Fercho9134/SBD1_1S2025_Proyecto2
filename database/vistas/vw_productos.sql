--Vistas relacionadas con productos/servicios
--vw_products

--Mostrar todos los productos/servicios de un cliente


CREATE OR REPLACE VIEW v_productos_cliente AS
SELECT 
    p.id_pago_producto_servicio,
    p.id_cliente,
    c.nombre || ' ' || c.apellido AS nombre_cliente,
    tp.nombre AS tipo_producto,
    CASE 
        WHEN p.tipo_pago = 1 THEN 'Pago de servicio'
        WHEN p.tipo_pago = 2 THEN 'Producto bancario'
        ELSE 'Otro'
    END AS categoria,
    p.monto,
    CASE 
        WHEN p.id_cuenta IS NOT NULL THEN 'Cuenta: ' || p.id_cuenta
        WHEN p.id_tarjeta IS NOT NULL THEN 'Tarjeta: ' || t.numero_tarjeta
        WHEN p.id_prestamo IS NOT NULL THEN 'Préstamo: ' || pr.id_prestamo
        WHEN p.id_seguro IS NOT NULL THEN 'Seguro: ' || s.id_seguro
        ELSE 'N/A'
    END AS producto_asociado,
    p.descripcion,
    TO_CHAR(p.created_at, 'DD/MM/YYYY HH24:MI') AS fecha_creacion,
    -- Campos específicos por tipo de producto
    tp.monto_quetzales,
    tp.monto_dolares,
    p.id_tipo_pago,
    p.tipo_pago
FROM 
    PAGO_PRODUCTO_SERVICIO p
    JOIN CLIENTE c ON p.id_cliente = c.id_cliente
    JOIN TIPO_PAGO tp ON p.id_tipo_pago = tp.id_tipo_producto
    LEFT JOIN CUENTA cu ON p.id_cuenta = cu.id_cuenta
    LEFT JOIN TARJETA t ON p.id_tarjeta = t.id_tarjeta OR p.id_pago_tarjeta = t.id_tarjeta
    LEFT JOIN PRESTAMO pr ON p.id_prestamo = pr.id_prestamo
    LEFT JOIN SEGURO s ON p.id_seguro = s.id_seguro;

CREATE OR REPLACE VIEW vw_products AS
SELECT 
    -- Información del tipo de producto/servicio
    tp.nombre AS tipo_producto,
    CASE 
        WHEN tp.tipo = 1 THEN 'Pago de servicio'
        WHEN tp.tipo = 2 THEN 'Servicio bancario'
        ELSE 'Otro'
    END AS categoria,
    
    -- Información del producto/servicio específico
    pps.id_pago_producto_servicio,
    pps.descripcion,
    pps.monto,
    TO_CHAR(pps.created_at, 'DD/MM/YYYY HH24:MI') AS fecha_adquisicion,
    
    -- Información del medio de pago (cuenta/tarjeta)
    CASE 
        WHEN pps.id_tarjeta IS NOT NULL THEN 'Tarjeta ' || tar.numero_tarjeta
        WHEN pps.id_cuenta IS NOT NULL THEN 'Cuenta ' || pps.id_cuenta
        ELSE 'Efectivo/otro'
    END AS medio_pago,
    
    CASE 
        WHEN pps.id_tarjeta IS NOT NULL THEN 
            CASE tar.id_tipo 
                WHEN 'C' THEN 'Crédito' 
                WHEN 'D' THEN 'Débito' 
            END
        WHEN pps.id_cuenta IS NOT NULL THEN tcu.nombre
        ELSE 'N/A'
    END AS tipo_medio_pago,
    
    -- Información del cliente
    c.nombre || ' ' || c.apellido AS cliente,
    c.numero_telefono,
    c.email,
    
    -- Información del producto asociado (si aplica)
    CASE 
        WHEN pps.id_prestamo IS NOT NULL THEN 'Préstamo #' || pps.id_prestamo
        WHEN pps.id_seguro IS NOT NULL THEN 'Seguro #' || pps.id_seguro
        WHEN pps.id_pago_tarjeta IS NOT NULL THEN 'Tarjeta #' || tar_pago.numero_tarjeta
        ELSE 'N/A'
    END AS producto_asociado
FROM 
    PAGO_PRODUCTO_SERVICIO pps
JOIN 
    TIPO_PAGO tp ON pps.id_tipo_pago = tp.id_tipo_producto
JOIN 
    CLIENTE c ON pps.id_cliente = c.id_cliente
LEFT JOIN 
    TARJETA tar ON pps.id_tarjeta = tar.id_tarjeta
LEFT JOIN 
    CUENTA cu ON pps.id_cuenta = cu.id_cuenta
LEFT JOIN 
    TIPO_CUENTA tcu ON cu.tipo_cuenta = tcu.id_tipo_cuenta
LEFT JOIN 
    PRESTAMO pr ON pps.id_prestamo = pr.id_prestamo
LEFT JOIN 
    SEGURO s ON pps.id_seguro = s.id_seguro
LEFT JOIN 
    TARJETA tar_pago ON pps.id_pago_tarjeta = tar_pago.id_tarjeta;