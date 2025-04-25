CREATE TABLE TIPO_CLIENTE (
    id_tipo_cliente INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY,
    nombre VARCHAR2(50)
        CONSTRAINT chk_nombre
        CHECK (REGEXP_LIKE(nombre, '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\s]+$')),
    descripcion VARCHAR2(100),
    created_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
);

CREATE TABLE CLIENTE (
    id_cliente INTEGER
        NOT NULL
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) 
        PRIMARY KEY,
    nombre VARCHAR2(50)
        NOT NULL
        CONSTRAINT chk_nombre
        CHECK (REGEXP_LIKE(nombre, '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\s]+$')),
    apellido VARCHAR2(50)
        NOT NULL
        CONSTRAINT chk_apellido 
        CHECK (REGEXP_LIKE(apellido, '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\s]+$')),
    numero_telefono VARCHAR2(12) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    usuario VARCHAR2(50) NOT NULL,
    contrasena VARCHAR2(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    tipo_cliente INTEGER NOT NULL,
    created_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_tipo_cliente 
        FOREIGN KEY (tipo_cliente) 
        REFERENCES TIPO_CLIENTE(id_tipo_cliente)
);

-- Trigger para actualizar updated_at de TIPO_CLIENTE
CREATE OR REPLACE TRIGGER trg_tipo_cliente_updated
BEFORE UPDATE ON TIPO_CLIENTE
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/

-- Trigger para actualizar updated_at de CLIENTE
CREATE OR REPLACE TRIGGER trg_cliente_updated
BEFORE UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSTIMESTAMP;
END;
/