-- Creación Tipos de Clientes
/*
    sp_register_new_type_client(nombre, descripcion)
    Pueden omitir los primeros 4 si ya existen en la base de datos
*/
sp_register_new_type_client('Individual Nacional', 'Este tipo de cliente es una persona individual de nacionalidad guatemalteca.'); -- id debe ser 1
sp_register_new_type_client('Individual Extranjero', 'Este tipo de cliente es una persona individual de nacionalidad extranjera.'); -- id debe ser 2
sp_register_new_type_client('Empresa Pyme', 'Este tipo de cliente es una empresa de tipo pequeña o mediana.'); -- -- id debe ser 3
sp_register_new_type_client('Empresa S.C', 'Este tipo de cliente corresponde a las empresa grandes que tienen una sociedad colectiva.'); -- -- id debe ser 4
sp_register_new_type_client('Cuenta del banco', 'Este tipo de cliente corresponde a una cuenta del banco.'); -- -- id debe ser 5

-- Creación de clientes
-- sp_register_new_client(nombre, apellido, telefono, correo, fecha_nacimiento, usuario, contrasena, tipoCliente)
sp_register_new_client('Juan', 'Pérez', '+50212345678','perezjuan@google.com', '24-04-1997', 'juanito', ' segura1234', 1); -- id debe ser 1
sp_register_new_client('María', 'García', '+50287654321', 'margarcia@google.com', '15-08-1995', 'mariagarcia', ' segura1234', 2); -- id debe ser 2
sp_register_new_client('Carlos', 'López', '+50223456789', 'calopes@microsoft.com', '10-12-1988', 'carlitos', ' segura1234', 1); -- id debe ser 3
sp_register_new_client('Ana', 'Martínez', '+50234567890', 'amartine@apple.com', '05-03-1990', 'anita', ' segura1234', 2); -- id debe ser 4
sp_register_new_client('Pedro', 'Ramírez', '+50245678901', 'perami@google.com', '20-07-1985', 'pedrito', ' segura1234', 3); -- id debe ser 5
sp_register_new_client('Laura', 'Hernández', '+50256789012', 'laudez@microsoft.com', '30-11-1992', 'laurita', ' segura1234', 3); -- id debe ser 6
sp_register_new_client('Empresa ', 'Banco', '+50267890123', 'banco@banco.com', '01-01-1980', 'banco', ' segura1234', 5); -- id debe ser 7
sp_register_new_client('Empresa ', 'EEGSA', '+50278901234', 'eggsa@eggsa.com', '24-04-1990', 'eggsa', ' segura1234', 4); -- id debe ser 8
sp_register_new_client('Empresa ', 'Empagua', '+50278901234', 'empagua@empagua.com', '24-04-1990', 'empagua', ' segura1234', 4); -- id debe ser 9
sp_register_new_client('Universidad ', 'USAC', '+50278901234', 'usac@usac.com', '24-04-1990', 'usac', ' segura1234', 4); -- id debe ser 10

-- Creación Tipos de Cuentas
/*
    sp_register_new_type_account(nombre, descripcion)
    Pueden omitir los primeros 4 si ya existen en la base de datos
*/
sp_register_new_type_account('Cuenta Ahorro', 'Esta cuenta genera un interés anual de dos porciento'); -- id debe ser 1
sp_register_new_type_account('Cuenta Ahorro Plus', 'Esta cuenta genera un interés anual del tres punto cinco porciento'); -- id debe ser 2
sp_register_new_type_account('Cuenta Monetaria', 'Diseñada para recibir depósitos de sueldo y realizar pagos.'); -- id debe ser 3
sp_register_new_type_account('Cuenta Ahorro Empresarial', 'Esta cuenta genera un interés anual de tres porciento'); -- id debe ser 4
sp_register_new_type_account('Cuenta Ahorro Empresarial Plus', 'Esta cuenta genera un interés anual de cinco porciento'); -- id debe ser 5

-- Creación de cuentas
-- sp_register_new_account(montoApertura, saldoCuenta, Descripcion, FechaApertura, TipoCuenta, idCliente, otrosDetalles)
sp_register_new_account(1000, 1000, 'Cuenta', SYSDATE, 1, 1, 'Cuenta de ahorro personal de Juan Pérez'); -- id debe ser 1
sp_register_new_account(2000, 2000, 'Cuenta', SYSDATE, 2, 2, 'Cuenta de ahorro personal de María García'); -- id debe ser 2
sp_register_new_account(3000, 3000, 'Cuenta', SYSDATE, 3, 3, 'Cuenta de ahorro personal de Carlos López'); -- id debe ser 3
sp_register_new_account(4000, 4000, 'Cuenta', SYSDATE, 4, 4, 'Cuenta de ahorro personal de Ana Martínez'); -- id debe ser 4
sp_register_new_account(5000, 5000, 'Cuenta', SYSDATE, 5, 7, 'Cuenta de ahorro personal de Banco'); -- id debe ser 5
sp_register_new_account(6000, 6000, 'Cuenta', SYSDATE, 1, 5, 'Cuenta de ahorro personal de Laura Hernández'); -- id debe ser 6
sp_register_new_account(8000, 8000, 'Cuenta', SYSDATE, 3, 1, 'Cuenta de ahorro personal de Juan Pérez'); -- id debe ser 7
sp_register_new_account(9000, 9000, 'Cuenta', SYSDATE, 4, 2, 'Cuenta de ahorro personal de María García'); -- id debe ser 8
sp_register_new_account(10000, 10000, 'Cuenta', SYSDATE, 4, 3, 'Cuenta de ahorro personal de Carlos López'); -- id debe ser 9
sp_register_new_account(11000, 11000, 'Cuenta', SYSDATE, 1, 4, 'Cuenta de ahorro personal de Ana Martínez'); -- id debe ser 10
sp_register_new_account(12000, 12000, 'Cuenta', SYSDATE, 2, 5, 'Cuenta de ahorro personal de Pedro Ramírez'); -- id debe ser 11
sp_register_new_account(13000, 13000, 'Cuenta', SYSDATE, 5, 8, 'Cuenta de ahorro personal de EEGSA'); -- id debe ser 12
sp_register_new_account(14000, 14000, 'Cuenta', SYSDATE, 5, 9, 'Cuenta de ahorro personal de Empagua'); -- id debe ser 13
sp_register_new_account(15000, 15000, 'Cuenta', SYSDATE, 5, 10, 'Cuenta de ahorro personal de USAC'); -- id debe ser 14

-- Creación de tarjetas
-- sp_register_new_card(idCliente, idTipoTarjeta, idTipo, NumeroTarjeta, Moneda, MontoLimite, DiaCorte, DiaPago, TasaInteres, FechaExpiracion)
sp_register_new_card(1, 1, 'C', 1234567823458765, 'Q', 10000, 17, 12, 5, '24-04-2029'); -- id debe ser 1
sp_register_new_card(2, 1, 'C', 1234567823458766, 'Q', 20000, 19, 14, 4, '15-08-2028'); -- id debe ser 2
sp_register_new_card(3, 1, 'C', 1234567823458767, 'Q', 30000, 21, 16, 3, '10-12-2027'); -- id debe ser 3
sp_register_new_card(4, 2, 'C', 1234567823458768, 'Q', 40000, 23, 18, 2, '05-03-2026'); -- id debe ser 4
sp_register_new_card(8, 2, 'C', 1234567823458769, 'Q', 50000, 25, 20, 1, '20-07-2025'); -- id debe ser 5
sp_register_new_card(6, 3, 'C', 1234567823458770, 'Q', 60000, 27, 22, 5, '30-11-2024'); -- id debe ser 6
sp_register_new_card(1, 3, 'D', 1234567823458771, 'Q', 70000, 29, 24, 0, '01-01-2023'); -- id debe ser 7 y relacionar con una cuenta
sp_register_new_card(2, 1, 'D', 1234567823458772, 'Q', 80000, 31, 26, 0, '24-04-2022'); -- id debe ser 8 y relacionar con una cuenta
sp_register_new_card(3, 1, 'D', 1234567823458773, 'Q', 90000, 2, 28, 0, '15-08-2021'); -- id debe ser 9 y relacionar con una cuenta
sp_register_new_card(4, 2, 'D', 1234567823458774, 'Q', 100000, 4, 30, 0, '10-12-2020'); -- id debe ser 10 y relacionar con una cuenta
sp_register_new_card(8, 2, 'D', 1234567823458775, 'Q', 110000, 6, 1, 0, '05-03-2019'); -- id debe ser 11 y relacionar con una cuenta
sp_register_new_card(6, 3, 'D', 1234567823458776, 'Q', 120000, 8, 3, 0, '20-07-2018'); -- id debe ser 12 y relacionar con una cuenta

-- Creación de Seguros
-- sp_get_insurance(IdTipoSeguro, ValorSeguro, CantidadPagos, MesesAsegurados, idCliente);
sp_get_insurance(1, 10000, 12, 24, 1); -- id debe ser 1
sp_get_insurance(2, 20000, 24, 36, 2); -- id debe ser 2
sp_get_insurance(3, 30000, 36, 48, 3); -- id debe ser 3
sp_get_insurance(4, 40000, 48, 60, 4); -- id debe ser 4
sp_get_insurance(1, 50000, 60, 72, 5); -- id debe ser 5
sp_get_insurance(2, 60000, 72, 84, 6); -- id debe ser 6
sp_get_insurance(3, 70000, 84, 96, 1); -- id debe ser 7
sp_get_insurance(4, 80000, 96, 108, 2); -- id debe ser 8
sp_get_insurance(1, 90000, 108, 120, 3); -- id debe ser 9
sp_get_insurance(2, 100000, 120, 132, 4); -- id debe ser 10
sp_get_insurance(3, 110000, 132, 144, 5); -- id debe ser 11

-- Creación de Prestamos
-- sp_get_loan(MontoPrestado, TasaInteres, Meses, idCliente);
sp_get_loan(10000, 5, 12, 1); -- id debe ser 1
sp_get_loan(20000, 4, 24, 2); -- id debe ser 2
sp_get_loan(30000, 3, 36, 3); -- id debe ser 3
sp_get_loan(40000, 2, 48, 4); -- id debe ser 4
sp_get_loan(50000, 1, 60, 5); -- id debe ser 5
sp_get_loan(60000, 5, 72, 6); -- id debe ser 6
sp_get_loan(70000, 4, 84, 1); -- id debe ser 7
sp_get_loan(80000, 3, 96, 2); -- id debe ser 8
sp_get_loan(90000, 2, 108, 3); -- id debe ser 9
sp_get_loan(100000, 1, 120, 4); -- id debe ser 10
sp_get_loan(110000, 5, 132, 5); -- id debe ser 11

-- Creación de Transacciones y Servicio
/*
    sp_transaction(IdTipoTransacción, Fecha, OtrosDetalles, idCliente, IdCuenta/idTarjeta, Valor, idCuentaOrigen, idCuentaDestino)
    Cada uno de las transacciones se pueden hacer desde una cuenta o tarjeta. Tener en cuenta todas las posibles variantes

    sp_get_product_service(IdTipoProducto, Tipo, PagadoCon , Descripcion, Monto);
*/

-- PAGOS DESDE CUENTA
sp_get_product_service(1, 1, 1 , 'Pago de energía Eléctrica (EEGSA)', 1000);
sp_transaction(5, SYSDATE, 'Tipo 1', 1, 1, 1000, 1, 12);

sp_get_product_service(2, 1, 'Pago de agua potable (Empagua)', 2, 2000);
sp_transaction(5, SYSDATE, 'Tipo 2', 2, 2, 2000, 2, 13);

sp_get_product_service(3, 1, 'ago de Matrícula USAC', 3, 3000);
sp_transaction(5, SYSDATE, 'Tipo 3', 3, 3, 3000, 3, 14);

sp_get_product_service(5, 1, 'Pago de seguro', 1234567823458765, 833.33);
sp_transaction(5, SYSDATE, 'Tipo 5', 1, 1234567823458765, 833.33);
/*
    - Tipo 5: Pago de seguro con tarjeta

        + TARJETA CREDITO
            Debe sumar el monto a la tarjeta de crédito
            Debe restar la cantidad de pagos pendientes
            Debe sumar a la cuenta del banco

        + TARJETA DEBITOS
            Debe restar el monto a la cuenta relacionada con la tarjeta
            Debe restar la cantidad de pagos pendientes
            Debe sumar a la cuenta del banco
*/

sp_get_product_service(6, 1, 'Pago tarjeta', 1234567823458766, 1500);
sp_transaction(5, SYSDATE, 'Tipo 6', 2, 1234567823458766, 1500, 2, 5);
/*
    - Tipo 6: Pago de tarjeta de crédito


        + DESDE CUENTA
            Debe restar el monto de la cuenta de origen
            Debe restar el monto de la tarjeta de crédito
            Debe sumar el monto a la cuenta de destino (banco)

        + DESDE TARJETA DE DEBITO
            Debe restar el monto a la cuenta relacionada con la tarjeta
            Debe sumar el monto a la cuenta de destino (banco)
*/

sp_get_product_service(7, 1, 'Pago Préstamo', 1234567823458766, 833.33);
sp_transaction(5, SYSDATE, 'Tipo 7', 3, 1234567823458766, 833.33);

-- SERVICIOS TIPO 8,9 y 10 deben sumar a la cuenta del banco
sp_get_product_service(8, 2, 9, 'Servicio de tarjeta de débito', 10);
sp_transaction(5, SYSDATE, 'Tipo 8', 3, 9, 10, 9, 5);
sp_get_product_service(9, 2, 4, 'Servicio de tarjeta de crédito', 40);
sp_transaction(5, SYSDATE, 'Tipo 9', 4, 4, 40, 4, 5);
sp_get_product_service(10, 2, 2, 'Servicio de chequera', 50);
sp_transaction(5, SYSDATE, 'Tipo 10', 2, 2, 50, 2, 5);