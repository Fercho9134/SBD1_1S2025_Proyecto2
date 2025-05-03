GRANT EXECUTE ON DBMS_CRYPTO TO nombre_usuario;

CREATE OR REPLACE PROCEDURE sp_register_new_client(
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_numero_telefono IN VARCHAR2,
    p_email IN VARCHAR2,
    p_usuario IN VARCHAR2,
    p_contrasena IN VARCHAR2,
    p_fecha_nacimiento IN DATE,
    p_tipo_cliente IN INTEGER
)
IS
    v_regex_email VARCHAR2(100) := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
    v_regex_letras VARCHAR2(100) := '^[A-Za-záéíóúÁÉÍÓÚÑñÜü\s]+$';
    v_count NUMBER;
    v_tipo_cliente_existe NUMBER;
    v_telefono_limpio VARCHAR2(20);
    v_contrasena_encriptada VARCHAR2(200);
BEGIN
    -- Validar nombre (solo letras)
    IF NOT REGEXP_LIKE(p_nombre, v_regex_letras) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El nombre solo puede contener letras y espacios');
    END IF;

    -- Validar apellido (solo letras)
    IF NOT REGEXP_LIKE(p_apellido, v_regex_letras) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: El apellido solo puede contener letras y espacios');
    END IF;

    -- Obviar codigo de pais en numero telefonico
    v_telefono_limpio := REGEXP_REPLACE(
        p_numero_telefono,
        '^\+\d{1,5}(?=\s|$)', ''
    );
    
    v_telefono_limpio := TRIM(v_telefono_limpio);

    IF NOT REGEXP_LIKE(v_telefono_limpio, '^[0-9\-]{7,12}$') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Formato telefonico invalido');
    END IF;

    -- Validar email
    IF NOT REGEXP_LIKE(p_email, v_regex_email, 'i') THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error: Formato de email invalido');
    END IF;

    -- Validar disponibilidad de usuario
    SELECT COUNT(*) INTO v_count FROM CLIENTE WHERE usuario = p_usuario;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Error: El nombre de usuario ya esta en uso');
    END IF;

    -- Validar fecha de nacimiento
    IF p_fecha_nacimiento >= TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20006, 'Error: La fecha de nacimiento no es valida');
    END IF;

    -- Validar que el tipo de cliente exista
    SELECT COUNT(*) INTO v_tipo_cliente_existe FROM TIPO_CLIENTE WHERE id_tipo_cliente = p_tipo_cliente;
    IF v_tipo_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Error: El tipo de cliente especificado no existe');
    END IF;

    -- Encriptar contraseña (DBMS_CRYPTO)
    v_contrasena_encriptada := DBMS_CRYPTO.HASH(
        UTL_I18N.STRING_TO_RAW(p_contrasena, 'AL32UTF8'),
        DBMS_CRYPTO.HASH_SH256
    );

    -- Insertar el nuevo cliente
    INSERT INTO CLIENTE (
        nombre,
        apellido,
        numero_telefono,
        email,
        usuario,
        contrasena,
        fecha_nacimiento,
        tipo_cliente
    ) VALUES (
        p_nombre,
        p_apellido,
        v_telefono_limpio,
        p_email,
        p_usuario,
        v_contrasena_encriptada,
        p_fecha_nacimiento,
        p_tipo_cliente
    );

    -- Finalizar y mostrar mensaje OK
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cliente agregado exitosamente');
    
    -- Capturar excepciones
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al agregar cliente: ' || SQLERRM);
        RAISE;
END sp_register_new_client;
/

-- Ejemplo de llamada
-- BEGIN
--     sp_register_new_client(
--         p_nombre => 'Juan',
--         p_apellido => 'Pérez',
--         p_numero_telefono => '+53 55512-34567',
--         p_email => 'juan.perez@email.com',
--         p_usuario => 'jperez',
--         p_contrasena => 'MiClaveSegura123',
--         p_fecha_nacimiento => TO_DATE('15-05-1990', 'DD-MM-YYYY'),
--         p_tipo_cliente => 1
--     );
-- END;
-- /

CREATE OR REPLACE PROCEDURE sp_register_new_type_client(
    p_nombre IN VARCHAR2,
    p_descripcion IN VARCHAR2
)
IS
    v_regex_letras VARCHAR2(100) := '^[A-Za-zÁÉÍÓÚáéíóúÑñÜü ]+$';
    v_count NUMBER;
BEGIN
    -- Validar descripción (letras y caracteres especiales comunes)
    IF NOT REGEXP_LIKE(p_descripcion, v_regex_letras) THEN
        RAISE_APPLICATION_ERROR(-20011, 'Error: La descripcion contiene caracteres no permitidos');
    END IF;

    -- Validar que el nombre no exista ya
    SELECT COUNT(*) INTO v_count FROM TIPO_CLIENTE WHERE UPPER(nombre) = UPPER(p_nombre);
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Error: Ya existe un tipo de cliente con ese nombre');
    END IF;

    -- Insertar el nuevo tipo de cliente
    INSERT INTO TIPO_CLIENTE (
        nombre,
        descripcion
    ) VALUES (
        p_nombre,
        p_descripcion
    );

    -- Finalizar y mostrar mensaje OK
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Tipo de cliente agregado exitosamente');

    -- Capturar excepciones
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error al agregar tipo de cliente: ' || SQLERRM);
        RAISE;
END sp_register_new_type_client;
/

-- Ejemplo de llamada
-- BEGIN
--     sp_register_new_type_client(
--         p_nombre => 'Individual Nacional',
--         p_descripcion => 'Este tipo de cliente es una persona individual de nacionalidad guatemalteca.'
--     );
-- END;
-- /