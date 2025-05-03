--Archivo para crear tablas relacionadas con seguros

CREATE TABLE TIPO_SEGURO (
    id_tipo_seguro INTEGER
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

INSERT INTO TIPO_SEGURO (nombre) VALUES ('Seguro de vida');
INSERT INTO TIPO_SEGURO (nombre) VALUES ('Seguro de automóvil');
INSERT INTO TIPO_SEGURO (nombre) VALUES ('Tarjeta medico');
INSERT INTO TIPO_SEGURO (nombre) VALUES ('Seguro de moto');
commit;

CREATE TABLE SEGURO (
    id_seguro INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    id_tipo_seguro INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    monto_asegurado NUMBER(12,2) NOT NULL
        CONSTRAINT chk_monto_positivo_segurom
        CHECK (monto_asegurado > 0),
    valor_seguro NUMBER(12,2) NOT NULL
        CONSTRAINT chk_monto_positivo_segurov
        CHECK (valor_seguro > 0),
    cantidad_pagos INTEGER NOT NULL
        CONSTRAINT chk_cantidad_pagos_positivo_seguro
        CHECK (cantidad_pagos > 0),
    meses_asegurados INTEGER NOT NULL
        CONSTRAINT chk_meses_asegurados_positivo_seguro
        CHECK (meses_asegurados > 0),
    fecha_contratacion TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    fecha_vencimiento TIMESTAMP NOT NULL,
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    CONSTRAINT fk_id_tipo_seguro_seguro
        FOREIGN KEY (id_tipo_seguro) 
        REFERENCES TIPO_SEGURO(id_tipo_seguro),
    CONSTRAINT fk_id_cliente_seguro
        FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente)
);