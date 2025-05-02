CREATE TABLE EMPRESA_REMESA(
    id_empresa_remesa INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    nombre VARCHAR2(50) UNIQUE NOT NULL,
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL
);


INSERT INTO EMPRESA_REMESA (nombre) VALUES ('MoneyGram');
INSERT INTO EMPRESA_REMESA (nombre) VALUES ('Intermex');
commit;

CREATE TABLE REMESA (
    id_remesa INTEGER 
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)  
        PRIMARY KEY
        NOT NULL,
    id_empresa_remesa INTEGER NOT NULL,
    monto NUMBER(12,2) NOT NULL
        CONSTRAINT chk_monto_positivo_remesa
        CHECK (monto > 0),
    fecha TIMESTAMP NOT NULL,
    pais VARCHAR2(5) NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_cuenta INTEGER NOT NULL,
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    CONSTRAINT fk_id_empresa_remesa
        FOREIGN KEY (id_empresa_remesa) 
        REFERENCES EMPRESA_REMESA(id_empresa_remesa),
    CONSTRAINT fk_id_cliente_remesa
        FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente),
    CONSTRAINT fk_id_cuenta_remesa
        FOREIGN KEY (id_cuenta) 
        REFERENCES CUENTA(id_cuenta)
);