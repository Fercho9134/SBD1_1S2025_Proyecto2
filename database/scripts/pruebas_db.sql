/*Sección de pruebas varias, ejemplos de uso*/
--Creación de cliente
BEGIN sp_register_new_client(
    p_nombre => 'Pablo',
    p_apellido => 'Ramirez',
    p_numero_telefono => '55456000',
    p_email => 'fercho.asensio@gmail.com',
    p_usuario => 'fernando',
    p_contrasena => '1234',
    p_fecha_nacimiento => TO_DATE('25/03/2004', 'DD/MM/YYYY'),
    p_tipo_cliente => 1
    );
END;
/
BEGIN sp_register_new_client(
    p_nombre => 'Rene',
    p_apellido => 'Perez',
    p_numero_telefono => '12345678',
    p_email => 'fercho.asensio2@gmail.com',
    p_usuario => 'fernando2',
    p_contrasena => '1234',
    p_fecha_nacimiento => TO_DATE('25/03/2004', 'DD/MM/YYYY'),
    p_tipo_cliente => 1
    );
END;
/

--Creación de cuentas
BEGIN sp_register_new_account(
    p_id_cliente => 1,
    p_tipo_cuenta => 1,
    p_monto_apertura => 1500.50,
    p_fecha_apertura => '25/03/2004',
    p_saldo_cuenta => 100
    );
END;
/
BEGIN sp_register_new_account(
    p_id_cliente => 1,
    p_tipo_cuenta => 1,
    p_monto_apertura => 100,
    p_fecha_apertura => '25/03/2004',
    p_saldo_cuenta => 25
    );
END;
/

--Calcular intereses cuentas
BEGIN 
    sp_calcular_intereses_cuentas();
END;
/

--Registrar notificaciones
BEGIN 
    sp_register_notification(
        p_id_cliente => 2,
        p_mensaje => 'Primera notificacion segundo cliente',
        p_fecha => '18/04/2023'
    );
END;
/

BEGIN 
    sp_register_notification(
        p_id_cliente => 1,
        p_mensaje => 'Primera notificacion primer cliente',
        p_fecha => '18/04/2023'
    );
END;
/

--Creacion de prestamos

BEGIN 
    sp_get_loan(
        p_id_cliente => 1,
        p_monto_prestamo => 100000,
        p_tasa_interes => 8,
        p_meses => 240
    );
END;
/

BEGIN 
    sp_get_loan(
        p_id_cliente => 2,
        p_monto_prestamo => 150000,
        p_tasa_interes => 5,
        p_meses => 48
    );
END;
/

--Extras de prestamos
--Consultar cuotas pendientes
BEGIN 
    sp_consultar_cuotas_pendientes(
        p_id_prestamo => 3
    );
END;
/

--Actualizar estado de las cuotas, verificar si hay cuotas que no se han pagado en todos los prestamos
BEGIN 
    sp_verificar_moras();
END;
/

--Pagar la proxima cuota de un prestamo, es una función, unicamente se puede llamar desde el pago de prestamos en productos/servicio
   /* fn_pagar_proxima_cuota(
        p_id_prestamo => 1,
        p_fecha_pago => '30/04/2025',
        p_monto_pagado => 500
    );*/

--Remesas
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 1,
        p_fecha => '30/04/2025',
        p_pais => 'EEUU',
        p_id_cliente => 1,
        p_id_cuenta => 2,
        p_monto => 2000
    );
END;
/
--IMPORTANTE las responsabilidades estan separadas
--Procedimientos como el de remesas o el de pagos de servicios unicamente
--hacen transacciones en el registro de los productos, es decir por ejemplo en este caso
--La remesa solo se registra en la tabla remesa, no se le suma el dinero a ningun lugar
--Para manjear dinero siempre se debe hacer uso del procedimiento de transacción, justo depsues
--De cualquier movimiento en los servicios, /pago de prestamos/tarjetas/remesas etc


--En este caso, tras reguistrar la remesa, se hace una transacción de tipo crédito
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 2,
        p_fecha_transaccion => '30/04/2025',
        p_id_cliente => 1,
        p_id_cuenta => 2,
        p_valor => 2000
    );
END;
/


--Ver remesas
BEGIN 
    sp_comming_money_by_client(
        p_id_cliente => 1
    );
END;
/


--Ver transacciones por cliente en un rango de fechas
BEGIN 
    sp_transactions_by_client(
        p_id_cliente => 1,
        p_fecha_inicio => '29/04/2025',
        p_fecha_fin => '30/04/2025'
    );
END;
/


--Tarjetas
--Crear tarjeta de débito
BEGIN 
    sp_register_new_card(
        p_id_cliente => 1,
        p_id_cuenta => 3,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 1245119685457874,
        p_moneda => 'Q',
        p_dia_corte => 2,
        p_dia_pago => 3
    );
END;
/
--Crear tarjeta de credito
BEGIN 
    sp_register_new_card(
        p_id_cliente => 1,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1245789685457875,
        p_moneda => 'Q',
        p_monto_limite => 10000,
        p_dia_corte => 2,
        p_dia_pago => 3
    );
END;
/

--Procedimiento extra para calcular intereses de las tarjetas se trabaja internamente al momento de pagar
--El de pagar la tarjeta de credito, tambien se trabaja internamente al pagar un servicio/producto

--Seguros

BEGIN 
    sp_get_insurance(
        p_id_tipo_seguro => 1,
        p_monto_asegurado => 25000,
        p_valor_seguro => 1500,
        p_cantidad_pagos => 1,
        p_meses_asegurados => 12,
        p_id_cliente => 1
    );
END;
/


--Pago de productos/servicios RECORDAR SIEMPRE ACOMPAÑADO DE UNA TRANSACCIÓN

-- Pago de energía electrica con id de cuenta
BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 1,
        p_tipo_pago => 1,
        p_id_cuenta => 2, --nuestra cuenta de ahí  nos van a descontar el monto
        p_monto => 150,
        pd_id_cliente => 1,
        p_descripcion => 'Pago de enrgia electrica del cliente 2'
    );
END;
/
--Transacción para pagar un servicio producto --tipo 5

BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => '30/04/2025',
        p_id_cliente => 1,
        p_id_cuenta => 2,
        p_valor => 150,
        p_id_cuenta_destino => 3 --Id de la cuenta de la empresa de energía electrica
        );
END;
/

BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 2,
        p_tipo_pago => 1,
        p_id_tarjeta => 3, --En este caso pagamos con tarjeta
        p_monto => 350,
        pd_id_cliente => 1,
        p_descripcion => 'Pago de agua del cliente 2'
    );
END;
/
--Transacción para pagar un servicio producto --tipo 5

BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => '30/04/2025',
        p_id_cliente => 1,
        p_id_tarjeta => 3,
        p_valor => 350,
        p_id_cuenta_destino => 3 --Id de la cuenta de la empresa de agua
        );
END;
/
--Para todos los productos con id de 1 a 4 el proceso es el mismo que el anterior.


--Pago de tarjeta
BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 6,
        p_id_pago_tarjeta => 3, --ID de la tarjeta que estamos pagando
        p_tipo_pago => 1,
        p_id_cuenta => 3, --nuestra cuenta de ahí  nos van a descontar el monto
        p_monto => 350,
        pd_id_cliente => 1,
        p_descripcion => 'Pago de tarjeta del cliente'
    );
END;
/
--Se hace la respectiva transaccion

BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => '30/04/2025',
        p_id_cliente => 1,
        p_id_cuenta => 2,
        p_valor => 350,
        p_id_cuenta_destino => 3 --Id de la cuenta del banco
        );
END;
/

--Para pago de seguros y prestamos el procedimiento es el mismo, solo se debe indicar
--el id del prestamo o el id del seguro segun corresponda, con el campo p_id_seguro y p_id_prestamo


--Servicios
BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 8,
        p_tipo_pago => 2,
        p_id_cuenta => 3, --nuestra cuenta de ahí  nos van a descontar el monto
        pd_id_cliente => 1,
        p_descripcion => 'Pago de seervicio de tarjeta debito Q10 default'
    );
END;
/
--Se hace la respectiva transaccion pagando al banco

BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => '30/04/2025',
        p_id_cliente => 1,
        p_id_tarjeta => 2,
        p_valor => 10,
        p_id_cuenta_destino => 3 --Id de la cuenta del banco
        );
END;
/

--PAra los demás servicios mismo proceso, que el anterior. Se pueden colocar precios personalizados usando el campo p_monto

--Tipos de transacciones
--Tipo 1, entre cuentas
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 1,
        p_fecha_transaccion => '30/04/2025',
        p_id_cliente => 1,
        p_valor => 800,
        p_id_cuenta_origen => 2,
        p_id_cuenta_destino => 3 
        );
END;
/

BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 1,
        p_fecha_transaccion => '30/04/2025',
        p_id_cliente => 1,
        p_valor => 800,
        p_id_cuenta_origen => 2,
        p_id_cuenta_destino => 3 
        );
END;
/
--Tipo 2 crédito, se agrega dinero a una cuenta el dinero viene de fuera, por ejemplo un deposito.
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 2,
        p_fecha_transaccion => '30/04/2025',
        p_id_cliente => 1,
        p_valor => 1000,
        p_id_cuenta => 2
        );
END;
/
--Tipo 3 consumo con tarjeta, gastas dinero con tu tarjeta
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 3,
        p_fecha_transaccion => '30/04/2025',
        p_id_cliente => 1,
        p_valor => 1000,
        p_id_tarjeta => 2
        );
END;
/

--Tranferencia tipo 4, igual que la tipo 2
--Transferencia tipo 5, ejemplos arriba


--Funciones
SELECT fn_current_money_by_client(1,2) AS saldo FROM dual;
SELECT fn_amount_services_by_client(1,'29/04/2025','30/04/2025') AS total FROM dual;
SELECT fn_avg_services('29/04/2025','30/04/2025') AS promedio FROM dual;
SELECT fn_total_amount_services_by_client(1,'29/04/2025','30/04/2025') AS suma FROM dual;
SELECT fn_next_payment(1,2) AS proximo_pago FROM dual;
SELECT fn_max_amount_products('30/04/2025') AS maxima_cantidad FROM dual;
SELECT fn_max_value_products('30/04/2025') AS maximo_pago FROM dual;

--Vistas
SELECT * from vw_active_insurances;
SELECT * from vw_inactive_insurances;
SELECT * from vw_active_loans;
SELECT * from vw_inactive_loans;
SELECT * from vw_active_credit_cards;
SELECT * from vw_active_debit_cards;
SELECT * from vw_transactions;
SELECT * from vw_card_transactions;
SELECT * from vw_products;