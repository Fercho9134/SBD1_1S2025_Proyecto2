--Archivo para crear tablas extras mencionadas en el enunciado
--Premios, notificaciones

CREATE TABLE NOTIFICACION (
    id_notificacion INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    id_cliente INTEGER NOT NULL,
    mensaje VARCHAR2(255) NOT NULL,
    fecha TIMESTAMP NOT NULL,
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    CONSTRAINT fk_id_cliente_notificacion
        FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);


CREATE TABLE PREMIO (
    id_premio INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_tarjeta INTEGER NOT NULL,
    premio NUMBER(12,2) NOT NULL
        CONSTRAINT chk_monto_positivo
        CHECK (premio > 0),
    fecha TIMESTAMP NOT NULL,
    created_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_id_cliente
        FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
    CONSTRAINT fk_id_tarjeta
        FOREIGN KEY (id_tarjeta) REFERENCES TARJETA(id_tarjeta)
);