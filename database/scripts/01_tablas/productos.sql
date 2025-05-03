CREATE TABLE TIPO_PAGO (
    id_tipo_producto INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    nombre VARCHAR2(50) UNIQUE NOT NULL,
    tipo INTEGER NOT NULL,
    monto_quetzales NUMBER(12,2) 
        CONSTRAINT chk_monto_positivo_quetzales_producto
        CHECK (monto_quetzales > 0),
    monto_dolares NUMBER(12,2) 
        CONSTRAINT chk_monto_positivo_dolares_producto
        CHECK (monto_dolares > 0),
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL
); 

--Insertar tipos de productos
INSERT INTO TIPO_PAGO (nombre, tipo) VALUES ('Pago de energía eléctrica (EEGSA)', 1);
INSERT INTO TIPO_PAGO (nombre, tipo) VALUES ('Pago de agua potable (EMPAGUA)', 1);
INSERT INTO TIPO_PAGO (nombre, tipo) VALUES ('Pago de Matrícula USAC', 1);
INSERT INTO TIPO_PAGO (nombre, tipo) VALUES ('Pago de curso de vacaciones USAC', 1);
INSERT INTO TIPO_PAGO (nombre, tipo) VALUES ('Pago de seguro', 1);
INSERT INTO TIPO_PAGO (nombre, tipo) VALUES ('Pago de tarjeta', 1);
INSERT INTO TIPO_PAGO (nombre, tipo) VALUES ('Pago de préstamo', 1);
INSERT INTO TIPO_PAGO (nombre, tipo, monto_quetzales, monto_dolares) VALUES ('Servicio de tarjeta de débito', 2, 10.00, 1.50);
INSERT INTO TIPO_PAGO (nombre, tipo, monto_quetzales, monto_dolares) VALUES ('Servicio de tarjeta de crédito', 2, 40.00, 5.00);
INSERT INTO TIPO_PAGO (nombre, tipo, monto_quetzales, monto_dolares) VALUES ('Servicio de cuenta de chequera', 2, 50.00, 6.25); 
commit;


CREATE TABLE PAGO_PRODUCTO_SERVICIO(
    id_pago_producto_servicio INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    id_tipo_pago INTEGER NOT NULL,
    tipo_pago INTEGER NOT NULL,
    id_tarjeta INTEGER,
    id_cliente INTEGER,
    id_cuenta INTEGER,
    id_prestamo INTEGER,
    id_seguro INTEGER,
    id_pago_tarjeta INTEGER,
    descripcion VARCHAR2(100) NOT NULL,
    monto NUMBER(12,2) NOT NULL 
        CONSTRAINT chk_monto_positivo_pago
        CHECK (monto > 0),
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    CONSTRAINT fk_id_tipo_pago_pago
        FOREIGN KEY (id_tipo_pago) 
        REFERENCES TIPO_PAGO(id_tipo_producto),
    CONSTRAINT fk_id_tarjeta_pago
        FOREIGN KEY (id_tarjeta) 
        REFERENCES TARJETA(id_tarjeta),
    CONSTRAINT fk_id_cuenta_pago
        FOREIGN KEY (id_cuenta) 
        REFERENCES CUENTA(id_cuenta),
    CONSTRAINT fk_id_prestamo_pago
        FOREIGN KEY (id_prestamo) 
        REFERENCES PRESTAMO(id_prestamo),
    CONSTRAINT fk_id_seguro_pago
        FOREIGN KEY (id_seguro) 
        REFERENCES SEGURO(id_seguro),
    CONSTRAINT fk_id_pago_tarjeta_pago
        FOREIGN KEY (id_pago_tarjeta) 
        REFERENCES TARJETA(id_tarjeta),
    CONSTRAINT fk_id_cliente_pago
        FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente)
);
