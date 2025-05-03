--Funciones relacionadas con clientes
--fn_current_money_by_client
CREATE OR REPLACE FUNCTION fn_current_money_by_client(
    p_id_cliente IN CLIENTE.id_cliente%TYPE,
    p_id_cuenta IN CUENTA.id_cuenta%TYPE
) RETURN NUMBER IS
    v_saldo NUMBER(12,2);
    v_cuenta_valida NUMBER;
BEGIN
    -- Validar que el cliente existe
    BEGIN
        SELECT COUNT(*) INTO v_cuenta_valida
        FROM CUENTA
        WHERE id_cuenta = p_id_cuenta
        AND id_cliente = p_id_cliente;
        
        IF v_cuenta_valida = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'La cuenta no existe o no pertenece al cliente');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error validando cuenta: ' || SQLERRM);
    END;
    
    -- Obtener el saldo actual
    SELECT saldo_cuenta INTO v_saldo
    FROM CUENTA
    WHERE id_cuenta = p_id_cuenta;
    
    RETURN v_saldo;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'No se pudo obtener el saldo de la cuenta');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error inesperado: ' || SQLERRM);
END fn_current_money_by_client;
/