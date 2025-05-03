--Archivo para crear tablas relacionadas con prestamos
CREATE TABLE PRESTAMO(
    id_prestamo INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    id_cliente INTEGER NOT NULL,
    monto_prestamo NUMBER(12,2) NOT NULL
        CONSTRAINT chk_monto_positivo_prestamo
        CHECK (monto_prestamo > 0),
    tasa_interes INTEGER NOT NULL
        CONSTRAINT chk_tasa_interes_positivo_prestamo
        CHECK (tasa_interes >= 0),
    meses INTEGER NOT NULL
        CONSTRAINT chk_meses_positivo
        CHECK (meses > 0),
    monto_restante NUMBER(12,2) NOT NULL
        CONSTRAINT chk_monto_restante_positivo_prestamo
        CHECK (monto_restante > 0),
    meses_restantes INTEGER NOT NULL
        CONSTRAINT chk_meses_restantes_positivo_prestamo
        CHECK (meses_restantes > 0),
    fecha_contratacion DATE DEFAULT SYSDATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    CONSTRAINT fk_cliente_prestamo
        FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE CUOTA_PRESTAMO (
    id_cuota INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    id_prestamo INTEGER NOT NULL,
    numero_cuota INTEGER NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    monto_cuota NUMBER(12,2) NOT NULL,
    capital NUMBER(12,2) NOT NULL,
    interes NUMBER(12,2) NOT NULL,
    saldo_restante NUMBER(12,2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'PENDIENTE' NOT NULL
        CONSTRAINT chk_estado_cuota_prestamo
        CHECK (estado IN ('PENDIENTE', 'PAGADA', 'VENCIDA', 'MORA')),
    fecha_pago DATE,
    CONSTRAINT fk_prestamo_cuota
        FOREIGN KEY (id_prestamo)
        REFERENCES PRESTAMO(id_prestamo)
);

