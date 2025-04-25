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