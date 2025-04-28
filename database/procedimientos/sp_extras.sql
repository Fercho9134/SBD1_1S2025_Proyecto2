--Archivo para crear procedimientos extras, premios y notificaciones
--sp_notifications_by_client
--sp_register_notification (Extra no mencionado en el enunciado, crear notificacion)
--sp_register_award (Extra no mencionado en el enunciado, crear premio)
--sp_awards_by_client
/*
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
        NOT NULL
        DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP
        NOT NULL
        DEFAULT SYSTIMESTAMP,
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
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);
*/

CREATE OR REPLACE PROCEDURE sp_register_notification(
    p_id_cliente IN CLIENTE.id_cliente%TYPE,
    p_mensaje IN NOTIFICACION.mensaje%TYPE,
    p_fecha IN NOTIFICACION.fecha%TYPE
) AS
    v_id_notificacion NOTIFICACION.id_notificacion%TYPE;
    v_cliente_existe INTEGER;
BEGIN
    -- Verificar si el cliente existe
    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El cliente no existe.');
    END IF;

    -- Insertar la notificación
    INSERT INTO NOTIFICACION (id_cliente, mensaje, fecha)
    VALUES (p_id_cliente, p_mensaje, p_fecha)
    RETURNING id_notificacion INTO v_id_notificacion;

    DBMS_OUTPUT.PUT_LINE('Notificación registrada con ID: ' || v_id_notificacion);
    COMMIT; -- Confirmar la transacción

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK; -- Deshacer la transacción en caso de error
            DBMS_OUTPUT.PUT_LINE('Error al registrar la notificación: ' || SQLERRM);
END sp_register_notification;
/

--Procedimiento para registrar un premio
CREATE OR REPLACE PROCEDURE sp_register_award(
    p_id_cliente IN CLIENTE.id_cliente%TYPE,
    p_id_tarjeta IN TARJETA.id_tarjeta%TYPE,
    p_premio IN PREMIO.premio%TYPE,
    p_fecha IN PREMIO.fecha%TYPE
) AS
    v_id_premio PREMIO.id_premio%TYPE;
    v_cliente_existe INTEGER;
    v_tarjeta_existe INTEGER;
BEGIN
    -- Verificar si el cliente existe
    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El cliente no existe.');
    END IF;

    -- Verificar si la tarjeta existe
    SELECT COUNT(*)
    INTO v_tarjeta_existe
    FROM TARJETA
    WHERE id_tarjeta = p_id_tarjeta;

    IF v_tarjeta_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La tarjeta no existe.');
    END IF;

    -- Insertar el premio
    INSERT INTO PREMIO (id_cliente, id_tarjeta, premio, fecha)
    VALUES (p_id_cliente, p_id_tarjeta, p_premio, p_fecha)
    RETURNING id_premio INTO v_id_premio;

    DBMS_OUTPUT.PUT_LINE('Premio registrado con ID: ' || v_id_premio);
    COMMIT; -- Confirmar la transacción


    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK; -- Deshacer la transacción en caso de error

            DBMS_OUTPUT.PUT_LINE('Error al registrar el premio: ' || SQLERRM);
END sp_register_award;
/

--Creamos vista de notificaciones por cliente, creamos un procedimiento para mostrar las notificaciones por cliente

CREATE OR REPLACE VIEW v_notificaciones_cliente AS
SELECT 
    n.id_notificacion,
    n.mensaje,
    n.fecha,
    n.id_cliente,
    c.nombre || ' ' || c.apellido AS nombre_cliente
FROM 
    NOTIFICACION n
JOIN 
    CLIENTE c ON n.id_cliente = c.id_cliente;


CREATE OR REPLACE PROCEDURE sp_notifications_by_client(
    p_id_cliente IN CLIENTE.id_cliente%TYPE
) AS
    v_cliente_existe INTEGER;
    v_notificaciones_count INTEGER := 0;
BEGIN
    -- Verificar si el cliente existe
    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El cliente con ID ' || p_id_cliente || ' no existe.');
    END IF;

    -- Mostrar las notificaciones del cliente
    DBMS_OUTPUT.PUT_LINE('Notificaciones para el cliente ID: ' || p_id_cliente);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    FOR r IN (
        SELECT id_notificacion, mensaje, TO_CHAR(fecha, 'DD/MM/YYYY HH24:MI:SS') AS fecha_formateada 
        FROM v_notificaciones_cliente 
        WHERE id_cliente = p_id_cliente
        ORDER BY fecha DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || RPAD(r.id_notificacion, 10) || 
            ' | Fecha: ' || RPAD(r.fecha_formateada, 20) || 
            ' | Mensaje: ' || r.mensaje
        );
        v_notificaciones_count := v_notificaciones_count + 1;
    END LOOP;
    
    -- Mostrar mensaje si no hay notificaciones
    IF v_notificaciones_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no tiene notificaciones.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Total notificaciones: ' || v_notificaciones_count);
    END IF;
END sp_notifications_by_client;
/

--Vista para ver premios por cliente, creamos un procedimiento para mostrar los premios por cliente
-- Se debe listar Se debe listar: Premio Tarjeta Tipo Tarjeta Cliente
CREATE OR REPLACE VIEW v_premios_cliente AS
SELECT 
    p.id_premio,
    p.id_cliente,
    p.premio,
    t.numero_tarjeta,
    tt.nombre AS tipo_tarjeta,
    c.nombre || ' ' || c.apellido AS nombre_cliente
FROM
    PREMIO p
JOIN 
    TARJETA t ON p.id_tarjeta = t.id_tarjeta
JOIN
    CLIENTE c ON p.id_cliente = c.id_cliente
JOIN
    TIPO_TARJETA tt ON t.id_tipo_tarjeta = tt.id_tipo_tarjeta;


CREATE OR REPLACE PROCEDURE sp_awards_by_client(
    p_id_cliente IN CLIENTE.id_cliente%TYPE
) AS
    v_cliente_existe INTEGER;
    v_premios_count INTEGER := 0;
BEGIN
    -- Verificar si el cliente existe
    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El cliente con ID ' || p_id_cliente || ' no existe.');
    END IF;

    -- Mostrar los premios del cliente
    DBMS_OUTPUT.PUT_LINE('Premios para el cliente ID: ' || p_id_cliente);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    FOR r IN (
        SELECT id_premio, premio, numero_tarjeta, tipo_tarjeta, nombre_cliente 
        FROM v_premios_cliente 
        WHERE id_cliente = p_id_cliente
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || RPAD(r.id_premio, 10) || 
            ' | Premio: ' || RPAD(r.premio, 10) || 
            ' | Tarjeta: ' || RPAD(r.numero_tarjeta, 20) ||
            ' | Tipo Tarjeta: ' || RPAD(r.tipo_tarjeta, 20) ||
            ' | Cliente: ' || r.nombre_cliente
        );
        v_premios_count := v_premios_count + 1;
    END LOOP;
    
    -- Mostrar mensaje si no hay premios
    IF v_premios_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no tiene premios.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Total premios: ' || v_premios_count);
    END IF;
END sp_awards_by_client;
/
