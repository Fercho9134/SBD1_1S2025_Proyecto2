BEGIN 
    sp_comming_money_by_client(
        p_id_cliente         => 15
    );
END;
/
-- NO EXISTE CLIENTE 15

BEGIN 
    sp_register_new_card(
        p_id_cliente => 2,
        p_id_tipo_tarjeta => 2,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327895,
        p_moneda => 'Q',
        p_monto_limite => 6000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => -10
    );
END;
/
-- FALLA LA TASA DE INTERES NO DEBE SER NEGATIVA

SELECT fn_next_payment(10,10) FROM DUAL;  --- FALLA NO EXISTE CLIENTE 10

BEGIN 
    sp_register_new_card(
        p_id_cliente => 1,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 45673218945643213,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0
    );
END;
/
--- FALLA TARJETA DEBE SER DE 16 DIGITOS