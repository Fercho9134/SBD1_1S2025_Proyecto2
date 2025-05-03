--Procedimientos relacionados con remesas
/*
--Archivo para crear tablas relacionadas con remesas

CREATE TABLE EMPRESA_REMESA(
    id_empresa_remesa INTEGER
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)
        PRIMARY KEY
        NOT NULL,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    created_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP
);

INSERT INTO EMPRESA_REMESA (nombre) VALUES ('MoneyGram');
INSERT INTO EMPRESA_REMESA (nombre) VALUES ('Intermex');

CREATE TABLE REMESA (
    id_remesa INTEGER 
        GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1)  
        PRIMARY KEY
        NOT NULL,
    id_empresa_remesa INTEGER NOT NULL,
    fecha TIMESTAMP NOT NULL
        CONSTRAINT chk_fecha_transaccion
        CHECK (fecha <= SYSTIMESTAMP),
    pais VARCHAR2(5) NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_cuenta INTEGER NOT NULL,
    created_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_id_empresa_remesa
        FOREIGN KEY (id_empresa_remesa) 
        REFERENCES EMPRESA_REMESA(id_empresa_remesa),
    CONSTRAINT fk_id_cliente
        FOREIGN KEY (id_cliente) 
        REFERENCES CLIENTE(id_cliente),
    CONSTRAINT fk_id_cuenta
        FOREIGN KEY (id_cuenta) 
        REFERENCES CUENTA(id_cuenta)
);

*/

--sp_comming_money
CREATE OR REPLACE PROCEDURE sp_comming_money(
    p_id_empresa_remesa IN EMPRESA_REMESA.id_empresa_remesa%TYPE,
    p_fecha IN REMESA.fecha%TYPE,
    p_pais IN REMESA.pais%TYPE,
    p_id_cliente IN REMESA.id_cliente%TYPE,
    p_id_cuenta IN REMESA.id_cuenta%TYPE,
    p_monto IN REMESA.monto%TYPE
) AS
    v_cliente_existe INTEGER;
    v_cuenta_existe INTEGER;
    v_empresa_existe INTEGER;

BEGIN
    -- Verificar si el cliente existe
    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El cliente no existe.');
    END IF;

    --Verificar si el monto es positivo
    IF p_monto <= 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'El monto debe ser positivo.');
    END IF;

    -- Verificar si la cuenta existe
    SELECT COUNT(*)
    INTO v_cuenta_existe
    FROM CUENTA
    WHERE id_cuenta = p_id_cuenta;

    IF v_cuenta_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La cuenta no existe.');
    END IF;

    -- Verificar si la empresa de remesa existe
    SELECT COUNT(*)
    INTO v_empresa_existe
    FROM EMPRESA_REMESA
    WHERE id_empresa_remesa = p_id_empresa_remesa;

    IF v_empresa_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'La empresa de remesa no existe.');
    END IF;

    -- Insertar la remesa en la tabla REMESA
    INSERT INTO REMESA (id_empresa_remesa, fecha, pais, id_cliente, id_cuenta, monto)
    VALUES (p_id_empresa_remesa, p_fecha, p_pais, p_id_cliente, p_id_cuenta, p_monto);

    COMMIT; -- Confirmar la transacción
    DBMS_OUTPUT.PUT_LINE('Remesa registrada exitosamente.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al insertar remesa: ' || SQLERRM);
        RAISE;

END sp_comming_money;
/
-- /

CREATE OR REPLACE VIEW v_remesas_cliente AS
SELECT
    r.id_remesa,
    r.id_cliente,
    e.nombre AS empresa_remesa,
    r.monto,
    r.fecha,
    r.pais,
    c.nombre || ' ' || c.apellido AS nombre_cliente
FROM
    REMESA r
JOIN 
    EMPRESA_REMESA e ON r.id_empresa_remesa = e.id_empresa_remesa
JOIN
    CLIENTE c ON r.id_cliente = c.id_cliente;



CREATE OR REPLACE PROCEDURE sp_comming_money_by_client(
    p_id_cliente IN CLIENTE.id_cliente%TYPE
) AS
    v_cliente_existe INTEGER;
    v_remesas_count INTEGER := 0;
BEGIN
    -- Verificar si el cliente existe
    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El cliente con ID ' || p_id_cliente || ' no existe.');
    END IF;

    -- Mostrar las remesas del cliente
    DBMS_OUTPUT.PUT_LINE('Remesas para el cliente ID: ' || p_id_cliente);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    FOR r IN (
        SELECT id_remesa, empresa_remesa, monto, fecha, pais 
        FROM v_remesas_cliente 
        WHERE id_cliente = p_id_cliente
        ORDER BY fecha DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || RPAD(r.id_remesa, 10) || 
            ' | Empresa: ' || RPAD(r.empresa_remesa, 20) || 
            ' | Monto: ' || RPAD(r.monto, 10) ||
            ' | Fecha: ' || TO_CHAR(r.fecha, 'DD/MM/YYYY HH24:MI:SS') ||
            ' | País: ' || r.pais
        );
        v_remesas_count := v_remesas_count + 1;
    END LOOP;
    
    -- Mostrar mensaje si no hay remesas
    IF v_remesas_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no tiene remesas.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Total remesas: ' || v_remesas_count);
    END IF;
END sp_comming_money_by_client;
/


--sp_comming_money_by_client