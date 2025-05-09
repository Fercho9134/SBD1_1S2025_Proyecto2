BEGIN
    sp_register_new_client(
        p_nombre => 'Gabriela',
        p_apellido => 'Ruiz',
        p_numero_telefono => '+502549831454',
        p_email => 'gabriela.ruiz@example.com',
        p_usuario => 'gabriela97',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('03/10/1997', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
--- FALLA - 13 DIGITOS EN TELEFONO

BEGIN
    sp_register_new_account(
        p_monto_apertura => 250,
        p_saldo_cuenta => -1,
        p_descripcion => 'Cuenta tipo 1 para cliente 1',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 1,
        p_id_cliente => 1,
        p_otros_detalles => 'Cuenta de ahorro personal de Gabriela Ruiz'
    );
END;
/
--- FALLA - SALDO NO PUEDE SER NEGATIVO

BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 3,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 1,
        p_id_cuenta         => 1,
        p_monto             => 2600
    );
END;
/
--- FALLA NO EXISTE TIPO 3

BEGIN
    sp_get_insurance(
        p_id_tipo_seguro    => 6,
        p_monto_asegurado   => '600000',
        p_valor_seguro      => 13000,
        p_cantidad_pagos    => 12,
        p_meses_asegurados  => 24,
        p_id_cliente        => 6
    );
END;
/
--- FALLA CANTIDAD DEBE SER NUMERIC O DECIMAL