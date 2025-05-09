-- Creación Tipos de Clientes
BEGIN
    sp_register_new_type_client(
        p_nombre => 'Cliente tipo banco',
        p_descripcion => 'Tipo de cliente para el banco'
    );
END;
/
-- id debe ser 5
BEGIN
    sp_register_new_type_client(
        p_nombre => 'Cliente tipo pública',
        p_descripcion => 'Tipo de cliente para entidad pública'
    );
END;
/
-- id debe ser 6


-- Creación de clientes
BEGIN
    sp_register_new_client(
        p_nombre => 'Gabriela',
        p_apellido => 'Ruiz',
        p_numero_telefono => '+50254983145',
        p_email => 'gabriela.ruiz@example.com',
        p_usuario => 'gabriela97',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('03/10/1997', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 1
BEGIN
    sp_register_new_client(
        p_nombre => 'Daniel',
        p_apellido => 'Ortega',
        p_numero_telefono => '+50255892135',
        p_email => 'daniel.ortega@example.com',
        p_usuario => 'daniel95',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('16/02/1995', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 2
BEGIN
    sp_register_new_client(
        p_nombre => 'Fernanda',
        p_apellido => 'Vargas',
        p_numero_telefono => '+50254985623',
        p_email => 'fernanda.v@example.com',
        p_usuario => 'fernanda98',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('29/09/1998', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 3
BEGIN
    sp_register_new_client(
        p_nombre => 'Alejandro',
        p_apellido => 'Paredes',
        p_numero_telefono => '+50255981234',
        p_email => 'alejandro.p@example.com',
        p_usuario => 'alejandro92',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('12/12/1992', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 4
BEGIN
    sp_register_new_client(
        p_nombre => 'Natalia',
        p_apellido => 'Guzmán',
        p_numero_telefono => '+50254897812',
        p_email => 'natalia.guzman@example.com',
        p_usuario => 'natalia00',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('02/02/2000', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 5
BEGIN
    sp_register_new_client(
        p_nombre => 'Mauricio',
        p_apellido => 'Salazar',
        p_numero_telefono => '+50255987634',
        p_email => 'mauricio.salazar@example.com',
        p_usuario => 'mauricio96',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('05/05/1996', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 6
BEGIN
    sp_register_new_client(
        p_nombre => 'Carolina',
        p_apellido => 'Ríos',
        p_numero_telefono => '+50255893412',
        p_email => 'carolina.rios@example.com',
        p_usuario => 'carolina99',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('17/08/1999', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 7
BEGIN
    sp_register_new_client(
        p_nombre => 'José',
        p_apellido => 'Navarro',
        p_numero_telefono => '+50254987213',
        p_email => 'jose.navarro@example.com',
        p_usuario => 'jose94',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('24/04/1994', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 8
BEGIN
    sp_register_new_client(
        p_nombre => 'Camila',
        p_apellido => 'Flores',
        p_numero_telefono => '+50255984123',
        p_email => 'camila.flores@example.com',
        p_usuario => 'camila97',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('19/11/1997', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 9
BEGIN
    sp_register_new_client(
        p_nombre => 'Pablo',
        p_apellido => 'Soto',
        p_numero_telefono => '+50254894325',
        p_email => 'pablo.soto@example.com',
        p_usuario => 'pablo93',
        p_contrasena => 'micontra123',
        p_fecha_nacimiento => TO_DATE('07/03/1993', 'DD/MM/YYYY'),
        p_tipo_cliente => 1
    );
END;
/
-- id debe ser 10

BEGIN
    sp_register_new_client(
        p_nombre => 'Empresa',
        p_apellido => 'EEGSA',
        p_numero_telefono => '+50217171818',
        p_email => 'eggsa@eggsa.com',
        p_usuario => 'eggsa',
        p_contrasena => 'segurita1234',
        p_fecha_nacimiento => TO_DATE('01/01/1980', 'DD/MM/YYYY'),
        p_tipo_cliente => 4
    );
END;
/
-- id debe ser 11
BEGIN
    sp_register_new_client(
        p_nombre => 'Empresa',
        p_apellido => 'EMPAGUA',
        p_numero_telefono => '+50234353435',
        p_email => 'empagua@empagua.com',
        p_usuario => 'empagua',
        p_contrasena => 'segurita1234',
        p_fecha_nacimiento => TO_DATE('01/01/1990', 'DD/MM/YYYY'),
        p_tipo_cliente => 4
    );
END;
/
-- id debe ser 12
BEGIN
    sp_register_new_client(
        p_nombre => 'Empresa',
        p_apellido => 'USAC',
        p_numero_telefono => '+50278796465',
        p_email => 'usac@usac.com',
        p_usuario => 'usac',
        p_contrasena => 'segurita1234',
        p_fecha_nacimiento => TO_DATE('01/01/1995', 'DD/MM/YYYY'),
        p_tipo_cliente => 6
    );
END;
/
-- id debe ser 13
BEGIN
    sp_register_new_client(
        p_nombre => 'Empresa',
        p_apellido => 'BANCO',
        p_numero_telefono => '+50258762349',
        p_email => 'banco@banco.com',
        p_usuario => 'banco',
        p_contrasena => 'segurita1234',
        p_fecha_nacimiento => TO_DATE('01/01/1950', 'DD/MM/YYYY'),
        p_tipo_cliente => 5
    );
END;
/
-- id debe ser 14


-- Creación Tipos de Cuentas
-- No se necesitan más tipos de cuentas, ya que los tipos de cuentas ya deberian de estar creados

-- Creación de cuentas
-- Cuenta Ahorro
BEGIN
    sp_register_new_account(
        p_monto_apertura => 250,
        p_saldo_cuenta => 250,
        p_descripcion => 'Cuenta tipo 1 para cliente 1',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 1,
        p_id_cliente => 1,
        p_otros_detalles => 'Cuenta de ahorro personal de Gabriela Ruiz'
    );
END;
/
-- id debe ser 1

BEGIN
    sp_register_new_account(
        p_monto_apertura => 500,
        p_saldo_cuenta => 500,
        p_descripcion => 'Cuenta tipo 1 para cliente 2',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 1,
        p_id_cliente => 2,
        p_otros_detalles => 'Cuenta de ahorro personal de Daniel Ortega'
    );
END;
/
-- id debe ser 2

BEGIN
    sp_register_new_account(
        p_monto_apertura => 750,
        p_saldo_cuenta => 750,
        p_descripcion => 'Cuenta tipo 1 para cliente 3',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 1,
        p_id_cliente => 3,
        p_otros_detalles => 'Cuenta de ahorro personal de Fernanda Vargas'
    );
END;
/
-- id debe ser 3

BEGIN
    sp_register_new_account(
        p_monto_apertura => 1000,
        p_saldo_cuenta => 1000,
        p_descripcion => 'Cuenta tipo 1 para cliente 4',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 1,
        p_id_cliente => 4,
        p_otros_detalles => 'Cuenta de ahorro personal de Alejandro Paredes'
    );
END;
/
-- id debe ser 4

BEGIN
    sp_register_new_account(
        p_monto_apertura => 1250,
        p_saldo_cuenta => 1250,
        p_descripcion => 'Cuenta tipo 1 para cliente 5',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 1,
        p_id_cliente => 5,
        p_otros_detalles => 'Cuenta de ahorro personal de Natalia Guzmán'
    );
END;
/
-- id debe ser 5

-- Cuenta Ahorro Plus
BEGIN
    sp_register_new_account(
        p_monto_apertura => 250,
        p_saldo_cuenta => 250,
        p_descripcion => 'Cuenta tipo 2 para cliente 6',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 2,
        p_id_cliente => 6,
        p_otros_detalles => 'Cuenta de ahorro personal de Mauricio Salazar'
    );
END;
/
-- id debe ser 6

BEGIN
    sp_register_new_account(
        p_monto_apertura => 500,
        p_saldo_cuenta => 500,
        p_descripcion => 'Cuenta tipo 2 para cliente 7',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 2,
        p_id_cliente => 7,
        p_otros_detalles => 'Cuenta de ahorro personal de Carolina Ríos'
    );
END;
/
-- id debe ser 7

BEGIN
    sp_register_new_account(
        p_monto_apertura => 750,
        p_saldo_cuenta => 750,
        p_descripcion => 'Cuenta tipo 2 para cliente 8',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 2,
        p_id_cliente => 8,
        p_otros_detalles => 'Cuenta de ahorro personal de José Navarro'
    );
END;
/
-- id debe ser 8

BEGIN
    sp_register_new_account(
        p_monto_apertura => 1000,
        p_saldo_cuenta => 1000,
        p_descripcion => 'Cuenta tipo 2 para cliente 9',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 2,
        p_id_cliente => 9,
        p_otros_detalles => 'Cuenta de ahorro personal de Camila Flores'
    );
END;
/
-- id debe ser 9

BEGIN
    sp_register_new_account(
        p_monto_apertura => 1250,
        p_saldo_cuenta => 1250,
        p_descripcion => 'Cuenta tipo 2 para cliente 10',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 2,
        p_id_cliente => 10,
        p_otros_detalles => 'Cuenta de ahorro personal de Pablo Soto'
    );
END;
/
-- id debe ser 10

-- Cuenta Monetaria
BEGIN
    sp_register_new_account(
        p_monto_apertura => 250,
        p_saldo_cuenta => 250,
        p_descripcion => 'Cuenta tipo 3 para cliente 1',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 1,
        p_otros_detalles => 'Cuenta de monetaria de Gabriela Ruiz'
    );
END;
/
-- id debe ser 11

BEGIN
    sp_register_new_account(
        p_monto_apertura => 500,
        p_saldo_cuenta => 500,
        p_descripcion => 'Cuenta tipo 3 para cliente 2',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 2,
        p_otros_detalles => 'Cuenta de monetaria de Daniel Ortega'
    );
END;
/
-- id debe ser 12

BEGIN
    sp_register_new_account(
        p_monto_apertura => 750,
        p_saldo_cuenta => 750,
        p_descripcion => 'Cuenta tipo 3 para cliente 3',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 3,
        p_otros_detalles => 'Cuenta de monetaria de Fernanda Vargas'
    );
END;
/
-- id debe ser 13

BEGIN
    sp_register_new_account(
        p_monto_apertura => 1000,
        p_saldo_cuenta => 1000,
        p_descripcion => 'Cuenta tipo 3 para cliente 4',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 4,
        p_otros_detalles => 'Cuenta de monetaria de Alejandro Paredes'
    );
END;
/
-- id debe ser 14

BEGIN
    sp_register_new_account(
        p_monto_apertura => 1250,
        p_saldo_cuenta => 1250,
        p_descripcion => 'Cuenta tipo 3 para cliente 5',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 5,
        p_otros_detalles => 'Cuenta de monetaria de Natalia Guzmán'
    );
END;
/
-- id debe ser 15

BEGIN
    sp_register_new_account(
        p_monto_apertura => 1500,
        p_saldo_cuenta => 1500,
        p_descripcion => 'Cuenta tipo 3 para cliente 6',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 6,
        p_otros_detalles => 'Cuenta de monetaria de Mauricio Salazar'
    );
END;
/
-- id debe ser 16

BEGIN
    sp_register_new_account(
        p_monto_apertura => 1750,
        p_saldo_cuenta => 1750,
        p_descripcion => 'Cuenta tipo 3 para cliente 7',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 7,
        p_otros_detalles => 'Cuenta de monetaria de Carolina Ríos'
    );
END;
/
-- id debe ser 17

BEGIN
    sp_register_new_account(
        p_monto_apertura => 2000,
        p_saldo_cuenta => 2000,
        p_descripcion => 'Cuenta tipo 3 para cliente 8',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 8,
        p_otros_detalles => 'Cuenta de monetaria de José Navarro'
    );
END;
/
-- id debe ser 18

BEGIN
    sp_register_new_account(
        p_monto_apertura => 2250,
        p_saldo_cuenta => 2250,
        p_descripcion => 'Cuenta tipo 3 para cliente 9',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 9,
        p_otros_detalles => 'Cuenta de monetaria de Camila Flores'
    );
END;
/
-- id debe ser 19

BEGIN
    sp_register_new_account(
        p_monto_apertura => 2500,
        p_saldo_cuenta => 2500,
        p_descripcion => 'Cuenta tipo 3 para cliente 10',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 3,
        p_id_cliente => 10,
        p_otros_detalles => 'Cuenta de monetaria de Pablo Soto'
    );
END;
/
-- id debe ser 20

-- Cuenta Ahorro Empresarial
BEGIN
    sp_register_new_account(
        p_monto_apertura => 75000,
        p_saldo_cuenta => 75000,
        p_descripcion => 'Cuenta tipo 4 para EEGSA',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 4,
        p_id_cliente => 11,
        p_otros_detalles => 'Cuenta de ahorro empresarial de EEGSA'
    );
END;
/
-- id debe ser 21

BEGIN
    sp_register_new_account(
        p_monto_apertura => 100000,
        p_saldo_cuenta => 100000,
        p_descripcion => 'Cuenta tipo 4 para EMPAGUA',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 4,
        p_id_cliente => 12,
        p_otros_detalles => 'Cuenta de ahorro empresarial de EMPAGUA'
    );
END;
/
-- id debe ser 22

-- Cuenta Ahorro Empresarial Plus
BEGIN
    sp_register_new_account(
        p_monto_apertura => 750000,
        p_saldo_cuenta => 750000,
        p_descripcion => 'Cuenta tipo 4 para USAC',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 5,
        p_id_cliente => 13,
        p_otros_detalles => 'Cuenta de ahorro empresarial de USAC'
    );
END;
/
-- id debe ser 23

BEGIN
    sp_register_new_account(
        p_monto_apertura => 650000,
        p_saldo_cuenta => 650000,
        p_descripcion => 'Cuenta tipo 4 para BANCO',
        p_fecha_apertura => TRUNC(SYSDATE),
        p_tipo_cuenta => 5,
        p_id_cliente => 14,
        p_otros_detalles => 'Cuenta de ahorro empresarial de BANCO'
    );
END;
/
-- id debe ser 24


-- FUNCION VER SALDO DE CUENTA
SELECT fn_current_money_by_client(1,1) FROM DUAL; ---> 250
SELECT fn_current_money_by_client(5,5) FROM DUAL; ---> 1250
SELECT fn_current_money_by_client(10,10) FROM DUAL; ---> 2500
SELECT fn_current_money_by_client(5,15) FROM DUAL; ---> 1250
SELECT fn_current_money_by_client(13,23) FROM DUAL; ---> 750000


-- Tarjetas
BEGIN 
    sp_register_new_card(
        p_id_cliente => 1,
        p_id_tipo_tarjeta => 2,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327894,
        p_moneda => 'Q',
        p_monto_limite => 5000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 1
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
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 2
BEGIN 
    sp_register_new_card(
        p_id_cliente => 3,
        p_id_tipo_tarjeta => 2,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327896,
        p_moneda => 'Q',
        p_monto_limite => 7000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 3
BEGIN 
    sp_register_new_card(
        p_id_cliente => 4,
        p_id_tipo_tarjeta => 2,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327897,
        p_moneda => 'Q',
        p_monto_limite => 8000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 4
BEGIN 
    sp_register_new_card(
        p_id_cliente => 5,
        p_id_tipo_tarjeta => 2,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327898,
        p_moneda => 'Q',
        p_monto_limite => 9000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 5
BEGIN 
    sp_register_new_card(
        p_id_cliente => 6,
        p_id_tipo_tarjeta => 3,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327899,
        p_moneda => 'Q',
        p_monto_limite => 10000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 6
BEGIN 
    sp_register_new_card(
        p_id_cliente => 7,
        p_id_tipo_tarjeta => 3,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327890,
        p_moneda => 'Q',
        p_monto_limite => 11000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 7
BEGIN 
    sp_register_new_card(
        p_id_cliente => 8,
        p_id_tipo_tarjeta => 3,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327891,
        p_moneda => 'Q',
        p_monto_limite => 12000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 8
BEGIN 
    sp_register_new_card(
        p_id_cliente => 9,
        p_id_tipo_tarjeta => 3,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327892,
        p_moneda => 'Q',
        p_monto_limite => 13000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 9
BEGIN 
    sp_register_new_card(
        p_id_cliente => 10,
        p_id_tipo_tarjeta => 3,
        p_id_tipo => 'C',
        p_numero_tarjeta => 1234987654327893,
        p_moneda => 'Q',
        p_monto_limite => 14000,
        p_dia_corte => 17,
        p_dia_pago => 10,
        p_tasa_interes => 6
    );
END;
/
-- id debe ser 10

BEGIN 
    sp_register_new_card(
        p_id_cliente => 1,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 4567321894564321,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 11
    );
END;
/
-- id debe ser 11
BEGIN 
    sp_register_new_card(
        p_id_cliente => 2,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 4563846392464738,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 12
    );
END;
/
-- id debe ser 12
BEGIN 
    sp_register_new_card(
        p_id_cliente => 3,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 1245983746384632,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 13
    );
END;
/
-- id debe ser 13
BEGIN 
    sp_register_new_card(
        p_id_cliente => 4,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 9843765812647593,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 14
    );
END;
/
-- id debe ser 14
BEGIN 
    sp_register_new_card(
        p_id_cliente => 5,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 1234567890123456,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 15
    );
END;
/
-- id debe ser 15
BEGIN 
    sp_register_new_card(
        p_id_cliente => 6,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 9876543210987654,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 16
    );
END;
/
-- id debe ser 16
BEGIN 
    sp_register_new_card(
        p_id_cliente => 7,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 4567891234567890,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 17
    );
END;
/
-- id debe ser 17
BEGIN 
    sp_register_new_card(
        p_id_cliente => 8,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 1234567890123457,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 18
    );
END;
/
-- id debe ser 18
BEGIN 
    sp_register_new_card(
        p_id_cliente => 9,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 9876543210987655,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 19
    );
END;
/
-- id debe ser 19
BEGIN 
    sp_register_new_card(
        p_id_cliente => 10,
        p_id_tipo_tarjeta => 1,
        p_id_tipo => 'D',
        p_numero_tarjeta => 4567891234567891,
        p_moneda => 'Q',
        p_monto_limite => 0,
        p_dia_corte => 1,
        p_dia_pago => 1,
        p_tasa_interes => 0,
        p_id_cuenta => 20
    );
END;
/
-- id debe ser 20


-- Servicios
BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 1,
        p_tipo_pago => 1,
        p_id_cuenta => 1,
        p_descripcion => 'Pago de energía Eléctrica (EEGSA)',
        p_monto => 1050,
        pd_id_cliente => 1
    );
END;
/
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => TRUNC(SYSDATE),
        p_otros_detalles => 'Pago de servicio/producto',
        p_id_cliente => 1,
        p_id_cuenta => 1,
        p_valor => 1050,
        p_id_cuenta_destino => 21
        );
END;
/
BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 1,
        p_tipo_pago => 1,
        p_id_cuenta => 2,
        p_descripcion => 'Pago de energía Eléctrica (EEGSA)',
        p_monto => 850,
        pd_id_cliente => 2
    );
END;
/
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => TRUNC(SYSDATE),
        p_otros_detalles => 'Pago de servicio/producto',
        p_id_cliente => 2,
        p_id_cuenta => 2,
        p_valor => 850,
        p_id_cuenta_destino => 21
        );
END;
/
BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 2,
        p_tipo_pago => 1,
        p_id_cuenta => 3,
        p_descripcion => 'Pago de agua potable (Empagua)',
        p_monto => 360,
        pd_id_cliente => 3
    );
END;
/
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => TRUNC(SYSDATE),
        p_otros_detalles => 'Pago de servicio/producto',
        p_id_cliente => 3,
        p_id_cuenta => 3,
        p_valor => 360,
        p_id_cuenta_destino => 22
        );
END;
/
BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 2,
        p_tipo_pago => 1,
        p_id_cuenta => 4,
        p_descripcion => 'Pago de agua potable (Empagua)',
        p_monto => 560,
        pd_id_cliente => 4
    );
END;
/
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => TRUNC(SYSDATE),
        p_otros_detalles => 'Pago de servicio/producto',
        p_id_cliente => 4,
        p_id_cuenta => 4,
        p_valor => 560,
        p_id_cuenta_destino => 22
        );
END;
/
BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 3,
        p_tipo_pago => 1,
        p_id_cuenta => 5,
        p_descripcion => 'Pago de Matrícula USAC',
        p_monto => 91,
        pd_id_cliente => 5
    );
END;
/
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => TRUNC(SYSDATE),
        p_otros_detalles => 'Pago de servicio/producto',
        p_id_cliente => 5,
        p_id_cuenta => 5,
        p_valor => 91,
        p_id_cuenta_destino => 23
        );
END;
/
BEGIN 
    sp_get_product_service(
        p_id_tipo_producto => 3,
        p_tipo_pago => 1,
        p_id_cuenta => 6,
        p_descripcion => 'Pago de Matrícula USAC',
        p_monto => 91,
        pd_id_cliente => 6
    );
END;
/
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 5,
        p_fecha_transaccion => TRUNC(SYSDATE),
        p_otros_detalles => 'Pago de servicio/producto',
        p_id_cliente => 6,
        p_id_cuenta => 6,
        p_valor => 91,
        p_id_cuenta_destino => 23
        );
END;
/


-- Transacciones
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 1,
        p_fecha_transaccion => TRUNC(SYSDATE),
        p_otros_detalles => 'Débito',
        p_id_cliente => 7,
        p_id_cuenta_origen => 7,
        p_valor => 450,
        p_id_cuenta_destino => 8
        );
END;
/
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 1,
        p_fecha_transaccion => TRUNC(SYSDATE),
        p_otros_detalles => 'Débito',
        p_id_cliente => 8,
        p_id_cuenta_origen => 8,
        p_valor => 450,
        p_id_cuenta_destino => 7
        );
END;
/
BEGIN 
    sp_transaction(
        p_id_tipo_transaccion => 1,
        p_fecha_transaccion => TRUNC(SYSDATE),
        p_otros_detalles => 'Débito',
        p_id_cliente => 10,
        p_id_cuenta_origen => 10,
        p_valor => 1150,
        p_id_cuenta_destino => 9
        );
END;
/


-- Prestamos
BEGIN
    sp_get_loan(
        p_monto_prestamo => 50000,
        p_tasa_interes   => 5,
        p_meses          => 36,
        p_id_cliente     => 1
    );
END;
/
-- id debe ser 1
BEGIN
    sp_get_loan(
        p_monto_prestamo => 100000,
        p_tasa_interes   => 6,
        p_meses          => 24,
        p_id_cliente     => 2
    );
END;
/
-- id debe ser 2
BEGIN
    sp_get_loan(
        p_monto_prestamo => 150000,
        p_tasa_interes   => 7,
        p_meses          => 12,
        p_id_cliente     => 3
    );
END;
/
-- id debe ser 3
BEGIN
    sp_get_loan(
        p_monto_prestamo => 200000,
        p_tasa_interes   => 8,
        p_meses          => 6,
        p_id_cliente     => 4
    );
END;
/
-- id debe ser 4
BEGIN
    sp_get_loan(
        p_monto_prestamo => 250000,
        p_tasa_interes   => 9,
        p_meses          => 3,
        p_id_cliente     => 5
    );
END;
/
-- id debe ser 5
BEGIN
    sp_get_loan(
        p_monto_prestamo => 300000,
        p_tasa_interes   => 10,
        p_meses          => 1,
        p_id_cliente     => 6
    );
END;
/
-- id debe ser 6


-- Seguros
BEGIN
    sp_get_insurance(
        p_id_tipo_seguro    => 1,
        p_monto_asegurado   => 100000,
        p_valor_seguro      => 3500,
        p_cantidad_pagos    => 12,
        p_meses_asegurados  => 24,
        p_id_cliente        => 1
    );
END;
/
-- id debe ser 1
BEGIN
    sp_get_insurance(
        p_id_tipo_seguro    => 2,
        p_monto_asegurado   => 200000,
        p_valor_seguro      => 5000,
        p_cantidad_pagos    => 12,
        p_meses_asegurados  => 24,
        p_id_cliente        => 2
    );
END;
/
-- id debe ser 2
BEGIN
    sp_get_insurance(
        p_id_tipo_seguro    => 3,
        p_monto_asegurado   => 300000,
        p_valor_seguro      => 7000,
        p_cantidad_pagos    => 12,
        p_meses_asegurados  => 24,
        p_id_cliente        => 3
    );
END;
/
-- id debe ser 3
BEGIN
    sp_get_insurance(
        p_id_tipo_seguro    => 4,
        p_monto_asegurado   => 400000,
        p_valor_seguro      => 9000,
        p_cantidad_pagos    => 12,
        p_meses_asegurados  => 24,
        p_id_cliente        => 4
    );
END;
/
-- id debe ser 4
BEGIN
    sp_get_insurance(
        p_id_tipo_seguro    => 5,
        p_monto_asegurado   => 500000,
        p_valor_seguro      => 11000,
        p_cantidad_pagos    => 12,
        p_meses_asegurados  => 24,
        p_id_cliente        => 5
    );
END;
/
-- id debe ser 5
BEGIN
    sp_get_insurance(
        p_id_tipo_seguro    => 6,
        p_monto_asegurado   => 600000,
        p_valor_seguro      => 13000,
        p_cantidad_pagos    => 12,
        p_meses_asegurados  => 24,
        p_id_cliente        => 6
    );
END;
/
-- id debe ser 6


-- Remesas
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 1,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 1,
        p_id_cuenta         => 1,
        p_monto             => 2600
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 1,
--         p_id_cuenta           => 1,
--         p_valor               => 2600
--     );
-- END;
-- id debe ser 1
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 1,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 2,
        p_id_cuenta         => 2,
        p_monto             => 9100
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 2,
--         p_id_cuenta           => 2,
--         p_valor               => 9100
--     );
-- END;
-- id debe ser 2
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 1,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 3,
        p_id_cuenta         => 3,
        p_monto             => 1450
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 3,
--         p_id_cuenta           => 3,
--         p_valor               => 1450
--     );
-- END;
-- id debe ser 3
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 1,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 4,
        p_id_cuenta         => 4,
        p_monto             => 7800
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 4,
--         p_id_cuenta           => 4,
--         p_valor               => 7800
--     );
-- END;
-- id debe ser 4
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 1,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 5,
        p_id_cuenta         => 5,
        p_monto             => 3200
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 5,
--         p_id_cuenta           => 5,
--         p_valor               => 3200
--     );
-- END;
-- id debe ser 5
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 2,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 6,
        p_id_cuenta         => 6,
        p_monto             => 6200
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 6,
--         p_id_cuenta           => 6,
--         p_valor               => 6200
--     );
-- END;
-- id debe ser 6
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 2,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 7,
        p_id_cuenta         => 7,
        p_monto             => 1100
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 7,
--         p_id_cuenta           => 7,
--         p_valor               => 1100
--     );
-- END;
-- id debe ser 7
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 2,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 8,
        p_id_cuenta         => 8,
        p_monto             => 8500
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 8,
--         p_id_cuenta           => 8,
--         p_valor               => 8500
--     );
-- END;
-- id debe ser 8
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 2,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 9,
        p_id_cuenta         => 9,
        p_monto             => 4000
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 9,
--         p_id_cuenta           => 9,
--         p_valor               => 4000
--     );
-- END;
-- id debe ser 9
BEGIN 
    sp_comming_money(
        p_id_empresa_remesa => 2,
        p_fecha             => TRUNC(SYSDATE),
        p_pais              => 'US',
        p_id_cliente        => 10,
        p_id_cuenta         => 10,
        p_monto             => 9900
    );
END;
/
-- Transacción de Remesa (solo si se quiere ver el dinero depositado en la cuenta correspondiente)
-- BEGIN 
--     sp_transaction(
--         p_id_tipo_transaccion => 4,
--         p_fecha_transaccion   => TRUNC(SYSDATE),
--         p_id_cliente          => 10,
--         p_id_cuenta           => 10,
--         p_valor               => 9900
--     );
-- END;
-- id debe ser 10


---
BEGIN 
    sp_transactions_by_client(
        p_id_cliente         => 1,
        p_fecha_inicio       => TO_DATE('01/01/1950', 'DD/MM/YYYY'),
        p_fecha_fin          => TO_DATE('08/08/2025', 'DD/MM/YYYY'),
        p_tipo_transaccion   => 5
    );
END;
/
-- id debe ser 1
BEGIN 
    sp_transactions_by_client(
        p_id_cliente         => 2,
        p_fecha_inicio       => TO_DATE('01/01/1950', 'DD/MM/YYYY'),
        p_fecha_fin          => TO_DATE('08/08/2025', 'DD/MM/YYYY'),
        p_tipo_transaccion   => 5
    );
END;
/
-- id debe ser 1
BEGIN 
    sp_transactions_by_client(
        p_id_cliente         => 3,
        p_fecha_inicio       => TO_DATE('01/01/1950', 'DD/MM/YYYY'),
        p_fecha_fin          => TO_DATE('08/08/2025', 'DD/MM/YYYY'),
        p_tipo_transaccion   => 5
    );
END;
/
-- id debe ser 1

---
BEGIN 
    sp_notifications_by_client(
        p_id_cliente         => 1
    );
END;
/
BEGIN 
    sp_notifications_by_client(
        p_id_cliente         => 2
    );
END;
/
BEGIN 
    sp_notifications_by_client(
        p_id_cliente         => 3
    );
END;
/

---
BEGIN 
    sp_products_by_client(
        p_id_cliente         => 1
    );
END;
/
BEGIN 
    sp_products_by_client(
        p_id_cliente         => 2
    );
END;
/
BEGIN 
    sp_products_by_client(
        p_id_cliente         => 3
    );
END;
/

---
BEGIN 
    sp_awards_by_client(
        p_id_cliente         => 1
    );
END;
/
BEGIN 
    sp_awards_by_client(
        p_id_cliente         => 2
    );
END;
/
BEGIN 
    sp_awards_by_client(
        p_id_cliente         => 3
    );
END;
/

---
BEGIN 
    sp_comming_money_by_client(
        p_id_cliente         => 1
    );
END;
/
BEGIN 
    sp_comming_money_by_client(
        p_id_cliente         => 2
    );
END;
/
BEGIN 
    sp_comming_money_by_client(
        p_id_cliente         => 3
    );
END;
/


-- FUNCIONES
SELECT fn_amount_services_by_client(1, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_amount_services_by_client(2, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_amount_services_by_client(3, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_amount_services_by_client(4, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;

SELECT fn_avg_servicies(TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;

SELECT fn_amount_services_by_client(1, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_amount_services_by_client(2, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_amount_services_by_client(3, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_amount_services_by_client(4, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;

SELECT fn_total_amount_services_by_client(1, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_total_amount_services_by_client(2, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_total_amount_services_by_client(3, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_total_amount_services_by_client(4, TO_DATE('01/01/1950', 'DD/MM/YYYY'), TO_DATE('08/08/2025', 'DD/MM/YYYY')) FROM DUAL;

SELECT fn_next_payment(1,1) FROM DUAL;
SELECT fn_next_payment(2,2) FROM DUAL;
SELECT fn_next_payment(3,3) FROM DUAL;
SELECT fn_next_payment(4,4) FROM DUAL;

SELECT fn_max_amount_products(TO_DATE('02/05/2025', 'DD/MM/YYYY')) FROM DUAL;
SELECT fn_max_value_products(TO_DATE('02/05/2025', 'DD/MM/YYYY')) FROM DUAL;


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