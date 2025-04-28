-- Archivo para crear tablas relacionadas con transacciones
CREATE TABLE TIPO_TRANSACCION (
    id_tipo_transaccion INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL
);

INSERT INTO TIPO_TRANSACCION (nombre) VALUES ('Débito');
INSERT INTO TIPO_TRANSACCION (nombre) VALUES ('Crédito');
INSERT INTO TIPO_TRANSACCION (nombre) VALUES ('Consumo con tarjeta');
INSERT INTO TIPO_TRANSACCION (nombre) VALUES ('Remesa');
INSERT INTO TIPO_TRANSACCION (nombre) VALUES ('Pago de servicio/producto');
commit;

CREATE TABLE TRANSACCION (
    id_transaccion INTEGER 
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)  
        PRIMARY KEY
        NOT NULL,
    id_tipo_transaccion INTEGER NOT NULL,
    fecha_transaccion TIMESTAMP NOT NULL,
    otros_detalles VARCHAR2(100),
    id_cliente INTEGER NOT NULL,
    id_cuenta INTEGER,
    id_tarjeta INTEGER,
    valor NUMBER(12,2) NOT NULL
        CONSTRAINT chk_monto_positivo_transaccion
        CHECK (valor > 0),
    id_cuenta_origen INTEGER,
    id_cuenta_destino INTEGER,
    CONSTRAINT fk_id_tipo_transaccion_transaccion
        FOREIGN KEY (id_tipo_transaccion) 
        REFERENCES TIPO_TRANSACCION(id_tipo_transaccion),
    CONSTRAINT chk_cuenta_o_tarjeta CHECK (id_cuenta IS NOT NULL OR id_tarjeta IS NOT NULL),
    CONSTRAINT fk_id_cliente_transaccion
        FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente),
    CONSTRAINT fk_id_cuenta_transaccion
        FOREIGN KEY (id_cuenta) 
        REFERENCES CUENTA(id_cuenta),
    CONSTRAINT fk_id_tarjeta_transaccion
        FOREIGN KEY (id_tarjeta) 
        REFERENCES TARJETA(id_tarjeta),
    CONSTRAINT fk_id_cuenta_origen_transaccion
        FOREIGN KEY (id_cuenta_origen) 
        REFERENCES CUENTA(id_cuenta),
    CONSTRAINT fk_id_cuenta_destino_transaccion
        FOREIGN KEY (id_cuenta_destino) 
        REFERENCES CUENTA(id_cuenta),
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL
);
