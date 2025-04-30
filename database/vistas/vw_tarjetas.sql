--Vistas relacionadas con tarjetas
-- --vw_active_credit_cards
-- --vw_active_debit_cards
CREATE OR REPLACE VIEW vw_active_credit_cards AS
SELECT 
    tt.nombre AS tipo_tarjeta,
    t.id_tarjeta,
    t.numero_tarjeta,
    t.moneda,
    t.monto_limite,
    t.saldo_tarjeta,
    t.dia_corte,
    t.dia_pago,
    t.tasa_interes,
    t.fecha_vencimiento,
    c.nombre || ' ' || c.apellido AS cliente,
    CASE 
        WHEN t.fecha_vencimiento < SYSDATE THEN 'VENCIDA'
        WHEN t.saldo_tarjeta >= t.monto_limite THEN 'LÍMITE ALCANZADO'
        ELSE 'ACTIVA'
    END AS estado_tarjeta,
    (t.monto_limite - t.saldo_tarjeta) AS credito_disponible,
    TO_CHAR(ADD_MONTHS(t.fecha_vencimiento, -1), 'DD/MM/YYYY') AS fecha_proximo_corte,
    TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, 1)), 'DD/MM/YYYY') AS fecha_proximo_pago
FROM 
    TARJETA t
JOIN 
    TIPO_TARJETA tt ON t.id_tipo_tarjeta = tt.id_tipo_tarjeta
JOIN 
    CLIENTE c ON t.id_cliente = c.id_cliente
WHERE 
    t.fecha_vencimiento >= SYSDATE
    AND t.id_tipo = 'C' -- Filtra solo tarjetas de crédito
ORDER BY 
    t.fecha_vencimiento, c.apellido, c.nombre;


CREATE OR REPLACE VIEW vw_active_debit_cards AS
SELECT 
    tt.nombre AS tipo_tarjeta,
    t.id_tarjeta,
    t.numero_tarjeta,
    t.moneda,
    c.nombre || ' ' || c.apellido AS cliente,
    t.id_cuenta,
    cu.saldo AS saldo_cuenta_asociada,
    t.fecha_vencimiento,
    CASE 
        WHEN t.fecha_vencimiento < SYSDATE THEN 'VENCIDA'
        WHEN cu.estado = 'INACTIVA' THEN 'CUENTA INACTIVA'
        ELSE 'ACTIVA'
    END AS estado_tarjeta,
    TO_CHAR(t.created_at, 'DD/MM/YYYY') AS fecha_emision,
    (SELECT COUNT(*) 
     FROM MOVIMIENTO_TARJETA mt 
     WHERE mt.id_tarjeta = t.id_tarjeta
     AND mt.fecha_movimiento >= ADD_MONTHS(SYSDATE, -1)) AS movimientos_ultimo_mes
FROM 
    TARJETA t
JOIN 
    TIPO_TARJETA tt ON t.id_tipo_tarjeta = tt.id_tipo_tarjeta
JOIN 
    CLIENTE c ON t.id_cliente = c.id_cliente
LEFT JOIN 
    CUENTA cu ON t.id_cuenta = cu.id_cuenta
WHERE 
    t.fecha_vencimiento >= SYSDATE
    AND t.id_tipo = 'D' -- Filtra solo tarjetas de débito
ORDER BY 
    t.fecha_vencimiento, c.apellido, c.nombre;