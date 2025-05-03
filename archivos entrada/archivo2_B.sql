EXEC sp_register_new_client('Gabriela', 'Ruiz', '+502549831454', 'gabriela.ruiz@example.com', '03-10-1997', 'gabriela97', 'micontra123', 1);  --- FALLA - 13 DIGITOS EN TELEFONO

EXEC sp_register_new_account(250, -1, 'Cuenta tipo 1 para cliente 1', SYSDATE, 1, 1, 'Cuenta de ahorro personal de Gabriela Ruiz');  --- FALLA - SALDO NO PUEDE SER NEGATIVO

EXEC sp_comming_money(3, SYSDATE, 'US', 1, 1); --- FALLA NO EXISTE TIPO 3

EXEC sp_get_insurance(6, '600000', 13000, 12, 24, 6); --- FALLA CANTIDAD DEBE SER NUMERIC O DECIMAL