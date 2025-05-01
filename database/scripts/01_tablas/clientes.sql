CREATE TABLE TIPO_CLIENTE (
    id_tipo_cliente INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY,
    nombre VARCHAR2(50)
        UNIQUE
        NOT NULL,
    descripcion VARCHAR2(100)
        NOT NULL
    CONSTRAINT chk_descripcion CHECK (REGEXP_LIKE(descripcion, '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü ]+$')),
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL
);

CREATE TABLE CLIENTE (
    id_cliente INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    nombre VARCHAR2(50)
        CONSTRAINT chk_nombre CHECK (REGEXP_LIKE(nombre, '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü ]+$'))
        NOT NULL,
    apellido VARCHAR2(50)
        CONSTRAINT chk_apellido CHECK (REGEXP_LIKE(apellido, '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü ]+$'))
        NOT NULL,
    numero_telefono VARCHAR2(12) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    usuario VARCHAR2(50) NOT NULL UNIQUE,
    contrasena VARCHAR2(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    tipo_cliente INTEGER NOT NULL,
    created_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    updated_at TIMESTAMP
        DEFAULT SYSTIMESTAMP
        NOT NULL,
    CONSTRAINT fk_tipo_cliente 
        FOREIGN KEY (tipo_cliente) 
        REFERENCES TIPO_CLIENTE(id_tipo_cliente)
);