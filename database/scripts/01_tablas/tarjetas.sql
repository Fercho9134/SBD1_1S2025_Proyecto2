CREATE TABLE TIPO_TARJETA (
    id_tipo_tarjeta INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    descripcion VARCHAR2(100) NOT NULL
        CONSTRAINT chk_descripcion
        CHECK (REGEXP_LIKE(descripcion, '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\s]+$')),
    created_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP
);

--Insertamos datos del tipo de tarjeta
INSERT INTO TIPO_TARJETA (nombre, descripcion) VALUES ('Tarjeta básica', 'Tarjeta de uso general');
INSERT INTO TIPO_TARJETA (nombre, descripcion) VALUES ('Tarjeta premium', 'Tarjeta de uso premium');
INSERT INTO TIPO_TARJETA (nombre, descripcion) VALUES ('Tarjeta black', 'Tarjeta de uso exclusivo');
commit;

CREATE TABLE TARJETA (
    id_tarjeta INTEGER 
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) 
        PRIMARY KEY
        NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_cuenta INTEGER,
    id_tipo_tarjeta INTEGER NOT NULL,
    id_tipo VARCHAR2(1) NOT NULL
        CONSTRAINT chk_tipo_tarjeta_t
        CHECK (id_tipo IN ('C', 'D')),
    numero_tarjeta Number(16,0) UNIQUE NOT NULL ,
    moneda VARCHAR2(1) NOT NULL
        CONSTRAINT chk_moneda_tarjeta_t
        CHECK (Moneda IN ('Q', '$')),
    monto_limite NUMBER(12,2)
        NOT NULL
        CONSTRAINT chk_monto_positivo_tarjeta
        CHECK (monto_limite > 0),
    saldo_tarjeta NUMBER(12,2)
        NOT NULL
        CONSTRAINT chk_saldo_no_negativo_tarjeta
        CHECK (saldo_tarjeta >= 0),
    dia_corte INTEGER NOT NULL
        CONSTRAINT chk_dia_corte_tarjeta
        CHECK (dia_corte BETWEEN 1 AND 31),
    dia_pago INTEGER NOT NULL
        CONSTRAINT chk_dia_pago_tarjeta
        CHECK (dia_pago BETWEEN 1 AND 31),
    tasa_interes INTEGER NOT NULL
        CONSTRAINT chk_tasa_interes_tarjeta
        CHECK (tasa_interes BETWEEN 0 AND 100),
    fecha_vencimiento DATE NOT NULL,
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    fecha_ultimo_interes DATE,
    CONSTRAINT fk_id_cliente_tarjeta
        FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente),
    CONSTRAINT fk_id_cuenta_tarjeta
        FOREIGN KEY (id_cuenta) 
        REFERENCES CUENTA(id_cuenta),
    CONSTRAINT fk_id_tipo_tarjeta_tarjeta
        FOREIGN KEY (id_tipo_tarjeta) 
        REFERENCES TIPO_TARJETA(id_tipo_tarjeta)
);

CREATE TABLE MOVIMIENTO_TARJETA (
    id_movimiento INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    id_tarjeta INTEGER NOT NULL,
    fecha_movimiento TIMESTAMP NOT NULL,
    monto NUMBER(12,2) NOT NULL 
        CONSTRAINT chk_monto_positivo
        CHECK (monto > 0),
    descripcion VARCHAR2(100) NOT NULL,
    tipo VARCHAR2(1) NOT NULL
        CONSTRAINT chk_tipo_movimiento
        CHECK (tipo IN ('C', 'D')), -- C: Pago, D: Consumo/Interés
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_movimiento_tarjeta
        FOREIGN KEY (id_tarjeta)
        REFERENCES TARJETA(id_tarjeta)
);