-- Trigger para actualizar updated_at de TIPO_CLIENTE
CREATE OR REPLACE TRIGGER trg_tipo_cliente_updated
BEFORE UPDATE ON TIPO_CLIENTE
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

-- Trigger para actualizar updated_at de CLIENTE
CREATE OR REPLACE TRIGGER trg_cliente_updated
BEFORE UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

-- Trigger para actualizar updated_at de TIPO_CUENTA
CREATE OR REPLACE TRIGGER trg_tipo_cuenta_updated
BEFORE UPDATE ON TIPO_CUENTA
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

-- Trigger para actualizar updated_at de CUENTA
CREATE OR REPLACE TRIGGER trg_cuenta_updated
BEFORE UPDATE ON CUENTA
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

-- Trigger para evitar modificacion de monto_apertura en CUENTA
CREATE OR REPLACE TRIGGER trg_proteger_monto_apertura
BEFORE UPDATE OF monto_apertura ON CUENTA
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20003, 'El monto de apertura no puede ser modificado');
END;
/