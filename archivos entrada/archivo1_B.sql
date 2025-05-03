-- Creación Tipos de Clientes
EXEC sp_register_new_type_client('Cliente tipo banco', 'Tipo de cliente para el banco');  -- id debe ser 5
EXEC sp_register_new_type_client('Cliente tipo pública', 'Tipo de cliente para entidad pública'); -- id debe ser 6

-- Creación de clientes
EXEC sp_register_new_client('Gabriela', 'Ruiz', '+50254983145', 'gabriela.ruiz@example.com', '03-10-1997', 'gabriela97', 'micontra123', 1);  -- id debe ser 1
EXEC sp_register_new_client('Daniel', 'Ortega', '+50255892135', 'daniel.ortega@example.com', '16-02-1995', 'daniel95', 'micontra123', 1); -- id debe ser 2
EXEC sp_register_new_client('Fernanda', 'Vargas', '+50254985623', 'fernanda.v@example.com', '29-09-1998', 'fernanda98', 'micontra123', 1); -- id debe ser 3
EXEC sp_register_new_client('Alejandro', 'Paredes', '+50255981234', 'alejandro.p@example.com', '12-12-1992', 'alejandro92', 'micontra123', 1); -- id debe ser 4
EXEC sp_register_new_client('Natalia', 'Guzmán', '+50254897812', 'natalia.guzman@example.com', '02-02-2000', 'natalia00', 'micontra123', 1); -- id debe ser 5
EXEC sp_register_new_client('Mauricio', 'Salazar', '+50255987634', 'mauricio.salazar@example.com', '05-05-1996', 'mauricio96', 'micontra123', 1); -- id debe ser 6
EXEC sp_register_new_client('Carolina', 'Ríos', '+50255893412', 'carolina.rios@example.com', '17-08-1999', 'carolina99', 'micontra123', 1);  -- id debe ser 7
EXEC sp_register_new_client('José', 'Navarro', '+50254987213', 'jose.navarro@example.com', '24-04-1994', 'jose94', 'micontra123', 1); -- id debe ser 8
EXEC sp_register_new_client('Camila', 'Flores', '+50255984123', 'camila.flores@example.com', '19-11-1997', 'camila97', 'micontra123', 1); -- id debe ser 9
EXEC sp_register_new_client('Pablo', 'Soto', '+50254894325', 'pablo.soto@example.com', '07-03-1993', 'pablo93', 'micontra123', 1); -- id debe ser 10

EXEC sp_register_new_client('Empresa', 'EEGSA', '+50217171818', 'eggsa@eggsa.com', '01-01-1980', 'eggsa', 'segurita1234', 4); -- id debe ser 11
EXEC sp_register_new_client('Empresa', 'EMPAGUA', '+50234353435', 'empagua@empagua.com', '01-01-1990', 'empagua', 'segurita1234', 4); -- id debe ser 12
EXEC sp_register_new_client('Empresa', 'USAC', '+50278796465', 'usac@usac.com', '01-01-1995', 'usac', 'segurita1234', 6); -- id debe ser 13
EXEC sp_register_new_client('Empresa', 'BANCO', '+50258762349', 'banco@banco.com', '01-01-1950', 'banco', 'segurita1234', 5); -- id debe ser 14

-- Creación Tipos de Cuentas
-- No se necesitan más tipos de cuentas, ya que los tipos de cuentas ya deberian de estar creados

-- Creación de cuentas
-- Cuenta Ahorro 
EXEC sp_register_new_account(250, 250, 'Cuenta tipo 1 para cliente 1', SYSDATE, 1, 1, 'Cuenta de ahorro personal de Gabriela Ruiz'); -- id debe ser 1
EXEC sp_register_new_account(500, 500, 'Cuenta tipo 1 para cliente 2', SYSDATE, 1, 2, 'Cuenta de ahorro personal de Daniel Ortega'); -- id debe ser 2
EXEC sp_register_new_account(750, 750, 'Cuenta tipo 1 para cliente 3', SYSDATE, 1, 3, 'Cuenta de ahorro personal de Fernanda Vargas'); -- id debe ser 3
EXEC sp_register_new_account(1000, 1000, 'Cuenta tipo 1 para cliente 4', SYSDATE, 1, 4, 'Cuenta de ahorro personal de Alejandro Paredes'); -- id debe ser 4
EXEC sp_register_new_account(1250, 1250, 'Cuenta tipo 1 para cliente 5', SYSDATE, 1, 5, 'Cuenta de ahorro personal de Natalia Guzmán'); -- id debe ser 5
-- Cuenta Ahorro Plus
EXEC sp_register_new_account(250, 250, 'Cuenta tipo 2 para cliente 6', SYSDATE, 2, 6, 'Cuenta de ahorro personal de Mauricio Salazar'); -- id debe ser 6
EXEC sp_register_new_account(500, 500, 'Cuenta tipo 2 para cliente 7', SYSDATE, 2, 7, 'Cuenta de ahorro personal de Carolina Ríos'); -- id debe ser 7
EXEC sp_register_new_account(750, 750, 'Cuenta tipo 2 para cliente 8', SYSDATE, 2, 8, 'Cuenta de ahorro personal de José Navarro'); -- id debe ser 8
EXEC sp_register_new_account(1000, 1000, 'Cuenta tipo 2 para cliente 9', SYSDATE, 2, 9, 'Cuenta de ahorro personal de Camila Flores'); -- id debe ser 9
EXEC sp_register_new_account(1250, 1250, 'Cuenta tipo 2 para cliente 10', SYSDATE, 2, 10, 'Cuenta de ahorro personal de Pablo Soto'); -- id debe ser 10
-- Cuenta Monetaria
sp_register_new_account(500, 500, 'Cuenta tipo 3 para cliente 2', SYSDATE, 3, 2, 'Cuenta de monetaria de Daniel Ortega'); -- id debe ser 12
EXEC sp_register_new_account(250, 250, 'Cuenta tipo 3 para cliente 1', SYSDATE, 3, 1, 'Cuenta de monetaria de Gabriela Ruiz'); -- id debe ser 11
EXEC sp_register_new_account(750, 750, 'Cuenta tipo 3 para cliente 3', SYSDATE, 3, 3, 'Cuenta de monetaria de Fernanda Vargas'); -- id debe ser 13
EXEC sp_register_new_account(1000, 1000, 'Cuenta tipo 3 para cliente 4', SYSDATE, 3, 4, 'Cuenta de monetaria de Alejandro Paredes'); -- id debe ser 14
EXEC sp_register_new_account(1250, 1250, 'Cuenta tipo 3 para cliente 5', SYSDATE, 3, 5, 'Cuenta de monetaria de Natalia Guzmán'); -- id debe ser 15
EXEC sp_register_new_account(1500, 1500, 'Cuenta tipo 3 para cliente 6', SYSDATE, 3, 6, 'Cuenta de monetaria de Mauricio Salazar'); -- id debe ser 16
EXEC sp_register_new_account(1750, 1750, 'Cuenta tipo 3 para cliente 7', SYSDATE, 3, 7, 'Cuenta de monetaria de Carolina Ríos'); -- id debe ser 17
EXEC sp_register_new_account(2000, 2000, 'Cuenta tipo 3 para cliente 8', SYSDATE, 3, 8, 'Cuenta de monetaria de José Navarro'); -- id debe ser 18
EXEC sp_register_new_account(2250, 2250, 'Cuenta tipo 3 para cliente 9', SYSDATE, 3, 9, 'Cuenta de monetaria de Camila Flores'); -- id debe ser 19
EXEC sp_register_new_account(2500, 2500, 'Cuenta tipo 3 para cliente 10', SYSDATE, 3, 10, 'Cuenta de monetaria de Pablo Soto'); -- id debe ser 20
-- Cuenta Ahorro Empresarial
EXEC sp_register_new_account(75000, 75000, 'Cuenta tipo 4 para EEGSA', SYSDATE, 4, 11, 'Cuenta de ahorro empresarial de EEGSA'); -- id debe ser 21
EXEC sp_register_new_account(100000, 100000, 'Cuenta tipo 4 para EMPAGUA', SYSDATE, 4, 12, 'Cuenta de ahorro empresarial de EMPAGUA'); -- id debe ser 22
-- Cuenta Ahorro Empresarial Plus
EXEC sp_register_new_account(750000, 750000, 'Cuenta tipo 4 para USAC', SYSDATE, 5, 13, 'Cuenta de ahorro empresarial de USAC'); -- id debe ser 23
EXEC sp_register_new_account(650000, 650000, 'Cuenta tipo 4 para BANCO', SYSDATE, 5, 14, 'Cuenta de ahorro empresarial de BANCO'); -- id debe ser 24

-- FUNCION VER SALDO DE CUENTA
SELECT fn_current_money_by_client(1,1) FROM DUAL; ---> 250
SELECT fn_current_money_by_client(5,5) FROM DUAL; ---> 1250
SELECT fn_current_money_by_client(10,10) FROM DUAL; ---> 2500
SELECT fn_current_money_by_client(5,15) FROM DUAL; ---> 1250
SELECT fn_current_money_by_client(13,23) FROM DUAL; ---> 750000

-- Tarjetas
EXEC sp_register_new_card(1, 2, 'C', 1234987654327894, 'Q', 5000, 17, 10, 6, '01-08-2029'); -- id debe ser 1
EXEC sp_register_new_card(2, 2, 'C', 1234987654327895, 'Q', 6000, 17, 10, 6, '01-09-2029'); -- id debe ser 2
EXEC sp_register_new_card(3, 2, 'C', 1234987654327896, 'Q', 7000, 17, 10, 6, '01-10-2029'); -- id debe ser 3
EXEC sp_register_new_card(4, 2, 'C', 1234987654327897, 'Q', 8000, 17, 10, 6, '01-11-2029'); -- id debe ser 4
EXEC sp_register_new_card(5, 2, 'C', 1234987654327898, 'Q', 9000, 17, 10, 6, '01-12-2029'); -- id debe ser 5
EXEC sp_register_new_card(6, 3, 'C', 1234987654327899, 'Q', 10000, 17, 10, 6, '01-01-2030'); -- id debe ser 6
EXEC sp_register_new_card(7, 3, 'C', 1234987654327890, 'Q', 11000, 17, 10, 6, '01-02-2030'); -- id debe ser 7
EXEC sp_register_new_card(8, 3, 'C', 1234987654327891, 'Q', 12000, 17, 10, 6, '01-03-2030'); -- id debe ser 8
EXEC sp_register_new_card(9, 3, 'C', 1234987654327892, 'Q', 13000, 17, 10, 6, '01-04-2030'); -- id debe ser 9
EXEC sp_register_new_card(10, 3, 'C', 1234987654327893, 'Q', 14000, 17, 10, 6, '01-05-2030'); -- id debe ser 10

EXEC sp_register_new_card(1, 1, 'D', 4567321894564321, 'Q', 0, 1, 1, 0, '01-06-2030'); -- id debe ser 11
EXEC sp_register_new_card(2, 1, 'D', 4563846392464738, 'Q', 0, 1, 1, 0, '01-07-2030'); -- id debe ser 12
EXEC sp_register_new_card(3, 1, 'D', 1245983746384632, 'Q', 0, 1, 1, 0, '01-08-2030'); -- id debe ser 13
EXEC sp_register_new_card(4, 1, 'D', 9843765812647593, 'Q', 0, 1, 1, 0, '01-09-2030'); -- id debe ser 14
EXEC sp_register_new_card(5, 1, 'D', 1234567890123456, 'Q', 0, 1, 1, 0, '01-10-2030'); -- id debe ser 15
EXEC sp_register_new_card(6, 1, 'D', 9876543210987654, 'Q', 0, 1, 1, 0, '01-11-2030'); -- id debe ser 16
EXEC sp_register_new_card(7, 1, 'D', 4567891234567890, 'Q', 0, 1, 1, 0, '01-12-2030'); -- id debe ser 17
EXEC sp_register_new_card(8, 1, 'D', 1234567890123457, 'Q', 0, 1, 1, 0, '01-01-2031'); -- id debe ser 18
EXEC sp_register_new_card(9, 1, 'D', 9876543210987655, 'Q', 0, 1, 1, 0, '01-02-2031'); -- id debe ser 19
EXEC sp_register_new_card(10, 1, 'D', 4567891234567891, 'Q', 0, 1, 1, 0, '01-03-2031'); -- id debe ser 20

-- Servicios
EXEC sp_get_product_service(1, 1, 1, 'Pago de energía Eléctrica (EEGSA)', 1050);
EXEC sp_transaction(5, SYSDATE, 'Pago de servicio/producto', 1, 1, 1050, 1, 21);

EXEC sp_get_product_service(1, 1, 2, 'Pago de energía Eléctrica (EEGSA)', 850);
EXEC sp_transaction(5, SYSDATE, 'Pago de servicio/producto', 2, 2, 850, 2, 21);

EXEC sp_get_product_service(2, 1, 3, 'Pago de agua potable (Empagua)', 360);
EXEC sp_transaction(5, SYSDATE, 'Pago de servicio/producto', 3, 3, 360, 3, 22);

EXEC sp_get_product_service(2, 1, 4, 'Pago de agua potable (Empagua)', 560);
EXEC sp_transaction(5, SYSDATE, 'Pago de servicio/producto', 4, 4, 560, 4, 22);

EXEC sp_get_product_service(3, 1, 5, 'Pago de Matrícula USAC', 91);
EXEC sp_transaction(5, SYSDATE, 'Pago de servicio/producto', 5, 5, 91, 5, 23);

EXEC sp_get_product_service(3, 1, 6, 'Pago de Matrícula USAC', 91);
EXEC sp_transaction(5, SYSDATE, 'Pago de servicio/producto', 6, 6, 91, 6, 23);

-- Transacciones
EXEC sp_transaction(1, SYSDATE, 'Débito', 7, 7, 450, 7, 8);
EXEC sp_transaction(1, SYSDATE, 'Débito', 8, 8, 450, 8, 7);
EXEC sp_transaction(1, SYSDATE, 'Débito', 10, 10, 1150, 10, 9);

-- Prestamos
EXEC sp_get_loan(50000, 5, 36, 1); -- id debe ser 1
EXEC sp_get_loan(100000, 6, 24, 2); -- id debe ser 2
EXEC sp_get_loan(150000, 7, 12, 3); -- id debe ser 3
EXEC sp_get_loan(200000, 8, 6, 4); -- id debe ser 4
EXEC sp_get_loan(250000, 9, 3, 5); -- id debe ser 5
EXEC sp_get_loan(300000, 10, 1, 6); -- id debe ser 6

-- Seguros
EXEC sp_get_insurance(1, 100000, 3500, 12, 24, 1); -- id debe ser 1
EXEC sp_get_insurance(2, 200000, 5000, 12, 24, 2); -- id debe ser 2
EXEC sp_get_insurance(3, 300000, 7000, 12, 24, 3); -- id debe ser 3
EXEC sp_get_insurance(4, 400000, 9000, 12, 24, 4); -- id debe ser 4
EXEC sp_get_insurance(5, 500000, 11000, 12, 24, 5); -- id debe ser 5
EXEC sp_get_insurance(6, 600000, 13000, 12, 24, 6); -- id debe ser 6

-- Remesas
EXEC sp_comming_money(1, SYSDATE, 'US', 1, 1); -- id debe ser 1
EXEC sp_comming_money(1, SYSDATE, 'US', 2, 2); -- id debe ser 2
EXEC sp_comming_money(1, SYSDATE, 'US', 3, 3); -- id debe ser 3
EXEC sp_comming_money(1, SYSDATE, 'US', 4, 4); -- id debe ser 4
EXEC sp_comming_money(1, SYSDATE, 'US', 5, 5); -- id debe ser 5
EXEC sp_comming_money(2, SYSDATE, 'US', 6, 6); -- id debe ser 6
EXEC sp_comming_money(2, SYSDATE, 'US', 7, 7); -- id debe ser 7
EXEC sp_comming_money(2, SYSDATE, 'US', 8, 8); -- id debe ser 8
EXEC sp_comming_money(2, SYSDATE, 'US', 9, 9); -- id debe ser 9
EXEC sp_comming_money(2, SYSDATE, 'US', 10, 10); -- id debe ser 10


-- 
EXEC sp_transactions_by_client(1, '01-01-1950', '08-08-2025'); -- id debe ser 1
EXEC sp_transactions_by_client(2, '01-01-1950', '08-08-2025'); -- id debe ser 1
EXEC sp_transactions_by_client(3, '01-01-1950', '08-08-2025'); -- id debe ser 1

EXEC sp_notifications_by_client(1);
EXEC sp_notifications_by_client(2);
EXEC sp_notifications_by_client(3);

EXEC sp_products_by_client(1);
EXEC sp_products_by_client(2);
EXEC sp_products_by_client(3);

EXEC sp_awards_by_client(1);
EXEC sp_awards_by_client(2);
EXEC sp_awards_by_client(3);

EXEC sp_comming_money_by_client(1);
EXEC sp_comming_money_by_client(2);
EXEC sp_comming_money_by_client(3);

-- FUNCIONES
SELECT fn_amount_servicies_by_client(1,'01-01-1950', '08-08-2025') FROM DUAL;
SELECT fn_amount_servicies_by_client(2,'01-01-1950', '08-08-2025') FROM DUAL;
SELECT fn_amount_servicies_by_client(3,'01-01-1950', '08-08-2025') FROM DUAL;
SELECT fn_amount_servicies_by_client(4,'01-01-1950', '08-08-2025') FROM DUAL;

SELECT fn_avg_servicies('01-01-1950', '08-08-2025') FROM DUAL;

SELECT fn_amount_servicies_by_client(1,'01-01-1950', '08-08-2025') FROM DUAL;
SELECT fn_amount_servicies_by_client(2,'01-01-1950', '08-08-2025') FROM DUAL;
SELECT fn_amount_servicies_by_client(3,'01-01-1950', '08-08-2025') FROM DUAL;
SELECT fn_amount_servicies_by_client(4,'01-01-1950', '08-08-2025') FROM DUAL;

SELECT fn_total_amount_servicies_by_client(1,'01-01-1950', '08-08-2025') FROM DUAL;
SELECT fn_total_amount_servicies_by_client(2,'01-01-1950', '08-08-2025') FROM DUAL;
SELECT fn_total_amount_servicies_by_client(3,'01-01-1950', '08-08-2025') FROM DUAL;
SELECT fn_total_amount_servicies_by_client(4,'01-01-1950', '08-08-2025') FROM DUAL;

SELECT fn_next_payment(1,1) FROM DUAL;
SELECT fn_next_payment(2,2) FROM DUAL;
SELECT fn_next_payment(3,3) FROM DUAL;
SELECT fn_next_payment(4,4) FROM DUAL;

SELECT fn_max_amount_products() FROM DUAL;
SELECT fn_max_value_products() FROM DUAL;

-- VISTAS

SELECT * FROM vw_active_insurances;
SELECT * FROM vw_inactive_insurances;
SELECT * FROM vw_active_loans;
SELECT * FROM vw_inactive_loans;
SELECT * FROM vw_active_credit_cards;
SELECT * FROM vw_active_debit_cards;
SELECT * FROM vw_transactions;
SELECT * FROM vw_card_transactions;
SELECT * FROM vw_products;