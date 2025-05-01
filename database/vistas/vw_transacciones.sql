--Vistas relacionadas con transacciones
--Todas las transacciones de un cliente
CREATE OR REPLACE VIEW v_transacciones_clientes AS
SELECT 
    t.id_transaccion,
    t.id_cliente,
    c.nombre || ' ' || c.apellido AS nombre_cliente,
    tt.nombre AS tipo_transaccion,
    t.fecha_transaccion,
    t.valor,
    t.id_cuenta,
    t.id_tarjeta,
    tj.numero_tarjeta,
    t.id_cuenta_origen,
    t.id_cuenta_destino,
    t.otros_detalles,
    t.created_at
FROM 
    TRANSACCION t
    JOIN CLIENTE c ON t.id_cliente = c.id_cliente
    JOIN TIPO_TRANSACCION tt ON t.id_tipo_transaccion = tt.id_tipo_transaccion
    LEFT JOIN TARJETA tj ON t.id_tarjeta = tj.id_tarjeta
    LEFT JOIN CUENTA co ON t.id_cuenta_origen = co.id_cuenta
    LEFT JOIN CUENTA cd ON t.id_cuenta_destino = cd.id_cuenta;
    
CREATE OR REPLACE VIEW vw_transactions AS
SELECT 
    t.id_transaccion,
    tt.nombre AS tipo_transaccion,
    t.fecha_transaccion,
    t.valor,
    c.nombre || ' ' || c.apellido AS cliente,
    tc.nombre AS tipo_cuenta,
    CASE 
        WHEN t.id_cuenta_origen IS NOT NULL AND t.id_cuenta_destino IS NOT NULL 
            THEN 'Transferencia entre cuentas'
        WHEN t.id_cuenta_origen IS NOT NULL 
            THEN 'Débito desde cuenta'
        WHEN t.id_cuenta_destino IS NOT NULL 
            THEN 'Crédito a cuenta'
        ELSE 'Transacción directa'
    END AS descripcion_operacion,
    t.otros_detalles,
    t.id_cuenta_origen,
    t.id_cuenta_destino,
    t.id_tarjeta,
    t.id_cuenta
FROM 
    TRANSACCION t
JOIN 
    TIPO_TRANSACCION tt ON t.id_tipo_transaccion = tt.id_tipo_transaccion
JOIN 
    CLIENTE c ON t.id_cliente = c.id_cliente
LEFT JOIN 
    CUENTA cu ON t.id_cuenta = cu.id_cuenta
LEFT JOIN 
    TIPO_CUENTA tc ON cu.tipo_cuenta = tc.id_tipo_cuenta
WHERE 
    tt.nombre IN ('Débito', 'Crédito')
ORDER BY 
    t.fecha_transaccion DESC;

CREATE OR REPLACE VIEW vw_card_transactions AS
SELECT 
    -- Información de la tarjeta
    tar.id_tarjeta,
    tar.numero_tarjeta,
    CASE tar.id_tipo 
        WHEN 'C' THEN 'Crédito' 
        WHEN 'D' THEN 'Débito' 
    END AS tipo_tarjeta,
    tt.nombre AS categoria_tarjeta,
    
    -- Información de la transacción
    t.id_transaccion,
    ttran.nombre AS tipo_transaccion,
    t.fecha_transaccion,
    t.valor,
    CASE 
        WHEN mt.tipo = 'C' THEN 'Pago'
        WHEN mt.tipo = 'D' THEN 'Consumo'
        ELSE 'Otro'
    END AS naturaleza_operacion,
    
    -- Información del cliente
    c.nombre || ' ' || c.apellido AS cliente,
    c.numero_telefono,
    
    -- Información adicional
    t.otros_detalles,
    mt.descripcion AS detalle_movimiento,
    TO_CHAR(t.fecha_transaccion, 'DD/MM/YYYY HH24:MI') AS fecha_formateada
FROM 
    TRANSACCION t
JOIN 
    TARJETA tar ON t.id_tarjeta = tar.id_tarjeta
JOIN 
    TIPO_TARJETA tt ON tar.id_tipo_tarjeta = tt.id_tipo_tarjeta
JOIN 
    TIPO_TRANSACCION ttran ON t.id_tipo_transaccion = ttran.id_tipo_transaccion
JOIN 
    CLIENTE c ON t.id_cliente = c.id_cliente
LEFT JOIN 
    MOVIMIENTO_TARJETA mt ON t.id_transaccion = mt.id_movimiento
WHERE 
    t.id_tarjeta IS NOT NULL  -- Filtro clave para solo transacciones con tarjetas
ORDER BY 
    t.fecha_transaccion DESC;

--vw_card_transactions
--vw_transactions
