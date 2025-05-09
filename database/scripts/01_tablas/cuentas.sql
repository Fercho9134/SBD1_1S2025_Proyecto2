CREATE TABLE TIPO_CUENTA (
    id_tipo_cuenta INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    nombre VARCHAR2(50)
        UNIQUE
        NOT NULL,
    descripcion VARCHAR2(100)
        CONSTRAINT chk_descripcion_tipo_cuenta CHECK (REGEXP_LIKE(descripcion, '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü ]+$'))
        NOT NULL,
    interes NUMBER(5,2)
        CONSTRAINT chk_interes_positivo CHECK (interes >= 0)
        NOT NULL,
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL
);

CREATE TABLE CUENTA (
    id_cuenta INTEGER 
        GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1)  
        PRIMARY KEY
        NOT NULL,
    id_cliente INTEGER NOT NULL,
    monto_apertura NUMBER(12,2)
        CONSTRAINT chk_monto_positivo_cuenta CHECK (monto_apertura > 0)
        NOT NULL,
    saldo_cuenta NUMBER(12,2)
        CONSTRAINT chk_saldo_no_negativo_cuenta CHECK (saldo_cuenta >= 0)
        NOT NULL,
    fecha_apertura DATE
        DEFAULT SYSDATE
        NOT NULL,
    fecha_ultimo_interes DATE,
    tipo_cuenta INTEGER NOT NULL,
    descripcion VARCHAR2(75),
    otros_detalles VARCHAR2(100),
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    CONSTRAINT fk_id_cliente
        FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente),
    CONSTRAINT fk_tipo_cuenta
        FOREIGN KEY (tipo_cuenta)
        REFERENCES TIPO_CUENTA(id_tipo_cuenta)
);


CREATE TABLE INTERES_CUENTA (
    id_interes INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    id_cuenta INTEGER NOT NULL,
    fecha_calculo DATE NOT NULL,
    monto_interes NUMBER(12,2) NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fin DATE NOT NULL,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_interes_cuenta
        FOREIGN KEY (id_cuenta)
        REFERENCES CUENTA(id_cuenta),
        updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);