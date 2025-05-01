CREATE OR REPLACE TRIGGER trg_tarjeta_debito
BEFORE INSERT ON TARJETA
FOR EACH ROW
DECLARE
    v_saldo_cuenta CUENTA.saldo_cuenta%TYPE;
    v_cuenta_existe NUMBER;
BEGIN
    IF :NEW.id_tipo = 'D' THEN
        -- Verificar primero si existe la cuenta
        SELECT COUNT(*) INTO v_cuenta_existe
        FROM CUENTA
        WHERE id_cuenta = :NEW.id_cuenta;
        
        IF v_cuenta_existe = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'No existe la cuenta asociada para esta tarjeta de débito.');
        END IF;
        
        -- Obtener saldo solo si la cuenta existe
        SELECT saldo_cuenta INTO v_saldo_cuenta
        FROM CUENTA
        WHERE id_cuenta = :NEW.id_cuenta
        FOR UPDATE; -- Bloquea el registro para evitar cambios concurrentes
        
        -- Validar que el saldo no sea negativo
        IF v_saldo_cuenta < 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'La cuenta asociada tiene saldo negativo. No se puede crear tarjeta.');
        END IF;
        
        -- Asignar valores
        :NEW.saldo_tarjeta := v_saldo_cuenta;
        :NEW.monto_limite := v_saldo_cuenta;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejo adicional de errores
        RAISE_APPLICATION_ERROR(-20003, 'Error en trg_tarjeta_debito: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE p_actualizar_cuenta_por_tarjeta(
    p_id_tarjeta IN TARJETA.id_tarjeta%TYPE,
    p_monto_consumo IN NUMBER
) IS
    v_id_cuenta TARJETA.id_cuenta%TYPE;
    v_tipo_tarjeta TARJETA.id_tipo%TYPE;
BEGIN
    -- Verificar que sea tarjeta de débito con cuenta asociada
    SELECT id_cuenta, id_tipo INTO v_id_cuenta, v_tipo_tarjeta
    FROM TARJETA
    WHERE id_tarjeta = p_id_tarjeta;
    
    IF v_tipo_tarjeta != 'D' OR v_id_cuenta IS NULL THEN
        RAISE_APPLICATION_ERROR(-20020, 'Solo tarjetas de débito con cuenta asociada');
    END IF;
    
    -- Actualizar saldo de la cuenta
    UPDATE CUENTA
    SET saldo_cuenta = saldo_cuenta - p_monto_consumo,
        updated_at = SYSTIMESTAMP
    WHERE id_cuenta = v_id_cuenta
    RETURNING saldo_cuenta INTO v_saldo_cuenta;
    
    -- Validar que no quede saldo negativo
    IF v_saldo_cuenta < 0 THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20021, 'Saldo insuficiente en la cuenta');
    END IF;
    
    -- Actualizar la tarjeta con el nuevo saldo
    UPDATE TARJETA
    SET saldo_tarjeta = v_saldo_cuenta,
        monto_limite = v_saldo_cuenta,
        updated_at = SYSTIMESTAMP
    WHERE id_tarjeta = p_id_tarjeta;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Cuenta y tarjeta actualizadas. Nuevo saldo: ' || v_saldo_cuenta);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20022, 'La tarjeta especificada no existe');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20023, 'Error actualizando cuenta: ' || SQLERRM);
END p_actualizar_cuenta_por_tarjeta;
/
CREATE OR REPLACE PROCEDURE p_actualizar_tarjetas_por_cuenta(
    p_id_cuenta IN CUENTA.id_cuenta%TYPE
) IS
    v_saldo_cuenta CUENTA.saldo_cuenta%TYPE;
BEGIN
    -- Obtener saldo actual de la cuenta con bloqueo
    SELECT saldo_cuenta INTO v_saldo_cuenta
    FROM CUENTA
    WHERE id_cuenta = p_id_cuenta
    FOR UPDATE;
    
    -- Validar saldo no negativo
    IF v_saldo_cuenta < 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'El saldo de la cuenta no puede ser negativo');
    END IF;
    
    -- Actualizar todas las tarjetas de débito asociadas
    UPDATE TARJETA
    SET saldo_tarjeta = v_saldo_cuenta,
        monto_limite = v_saldo_cuenta,
        updated_at = SYSTIMESTAMP
    WHERE id_cuenta = p_id_cuenta
    AND id_tipo = 'D';
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Actualizadas ' || SQL%ROWCOUNT || ' tarjetas de débito');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20011, 'La cuenta especificada no existe');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20012, 'Error actualizando tarjetas: ' || SQLERRM);
END p_actualizar_tarjetas_por_cuenta;
/

BEGIN
    FOR rec IN (SELECT table_name
                FROM all_tab_columns
                WHERE column_name = 'UPDATED_AT'
                  AND owner = 'pruebas') -- Cambia el esquema si es necesario
    LOOP
        EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER trg_update_' || rec.table_name || '
                           BEFORE UPDATE ON ' || rec.table_name || '
                           FOR EACH ROW
                           BEGIN
                               :NEW.updated_at := CURRENT_TIMESTAMP;
                           END;';
    END LOOP;
END;
/