EXEC sp_comming_money_by_client(15); -- NO EXISTE CLIENTE 15

EXEC sp_register_new_card(2, 2, 'C', 1234987654327895, 'Q', 6000, 17, 10, -10, '01-09-2029'); -- id debe ser 2

SELECT fn_next_payment(10,10) FROM DUAL;  --- FALLA NO EXISTE CLIENTE 10

EXEC sp_register_new_card(1, 1, 'D', 45673218945643213, 'Q', 0, 1, 1, 0, '01-06-2030'); --- FALLA TARJETA DEBE SER DE 16 DIGITOS