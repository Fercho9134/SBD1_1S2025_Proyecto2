CREATE TABLE TIPO_CUENTA (
    id_tipo_cuenta INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    nombre VARCHAR2(50) NOT NULL
        CONSTRAINT chk_nombre
        CHECK (REGEXP_LIKE(nombre, '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\s]+$')),
    descripcion VARCHAR2(100) NOT NULL,
    created_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP
);

CREATE TABLE CUENTA (
    id_cuenta INTEGER 
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) 
        PRIMARY KEY
        NOT NULL,
    numero_cuenta INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    monto_apertura NUMBER(12,2)
        NOT NULL
        CONSTRAINT chk_monto_positivo
        CHECK (monto_apertura > 0),
    saldo_cuenta NUMBER(12,2)
        NOT NULL
        CONSTRAINT chk_saldo_no_negativo
        CHECK (saldo_cuenta >= 0),
    fecha_apertura DATE
        NOT NULL
        DEFAULT SYSDATE,
    tipo_cuenta INTEGER NOT NULL,
    descripcion Varchar2(75) NOT NULL,
    otros_detalles VARCHAR2(100),
    created_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_id_cliente
        FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente),
    CONSTRAINT fk_tipo_cuenta
        FOREIGN KEY (tipo_cuenta)
        REFERENCES TIPO_CUENTA(id_tipo_cuenta)
);

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

-- Trigger para evitar modificacion de monto_apertura
CREATE OR REPLACE TRIGGER trg_proteger_monto_apertura
BEFORE UPDATE OF monto_apertura ON CUENTA
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20003, 'El monto de apertura no puede ser modificado');
END;
/