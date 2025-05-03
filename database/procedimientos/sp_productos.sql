CREATE OR REPLACE PROCEDURE sp_get_product_service(
    p_id_tipo_producto IN INTEGER,
    p_tipo_pago IN INTEGER,
    p_id_tarjeta IN INTEGER DEFAULT NULL,
    p_id_cuenta IN INTEGER DEFAULT NULL,
    p_id_prestamo IN INTEGER DEFAULT NULL,
    p_id_seguro IN INTEGER DEFAULT NULL,
    p_id_pago_tarjeta IN INTEGER DEFAULT NULL,
    p_descripcion IN VARCHAR2,
    p_monto IN NUMBER DEFAULT NULL,
    pd_id_cliente IN INTEGER
)
IS
    v_tipo_pago_existe NUMBER;
    v_tarjeta_existe NUMBER;
    v_cuenta_existe NUMBER;
    v_prestamo_existe NUMBER;
    v_seguro_existe NUMBER;
    v_pago_tarjeta_existe NUMBER;
    v_resultado Varchar2(200);
    v_monto NUMBER;

BEGIN
    --Consideraciones para el procedimiento:
    /*
        Existen 2 servicios de pago de servicios y de productos:
        1. Pago de servicios (tipo_pago = 1): Se refiere a pagos de servicios como agua, luz, pago de tarrjeta, seguro o prestamos
        2. Pago de productos (tipo_pago = 2): Se refiere a pagos de productos como tarjeta de debito, tarjeta de credito o cuenta de chequera

        Ambos se pueden pagar con tarjeta o cuenta, verificar que el id_tarjeta o id_cuenta no sean nulos, debe haber al menos uno de los dos

        No puedo pagar una tarjeta con la misma tarjeta, por lo que el id_pago_tarjeta no puede ser igual al id_tarjeta

        Si pago un prestamo, debo de modiicar la tabla de prestamos, si pago un seguro, debo de modificar la tabla de seguros, si pago una tarjeta, debo de modificar la tabla de tarjetas.

        EN NINGUN CASO MODIFICARE LA TABLA CUENTAS, PARA ELLO DEBO DE HACER UNA TRANSACCIÓN
    */

    --Paso 1, validar datos

    --Si monto es nulo para el tipo de pago 2, asignar el monto del tipo de pago
    IF p_tipo_pago = 2 AND p_monto IS NULL THEN
        SELECT monto_quetzales INTO v_monto FROM TIPO_PAGO WHERE id_tipo_producto = p_id_tipo_producto;
    ELSE
        v_monto := p_monto;
    END IF;

    --Si el tipo_pago es 1, monto es obligatorio, si es 2, monto es opcional
    IF p_tipo_pago = 1 AND p_monto IS NULL THEN
        RAISE_APPLICATION_ERROR(-20045, 'Error: El monto es obligatorio para el pago de productos');
    END IF;

    --Si p_monto no es nulo, verificar que el monto sea mayor a 0
    IF p_monto IS NOT NULL AND p_monto <= 0 THEN
        RAISE_APPLICATION_ERROR(-20046, 'Error: El monto debe ser mayor a 0');
    END IF;


    -- Validar que el tipo de pago exista
    SELECT COUNT(*) INTO v_tipo_pago_existe FROM TIPO_PAGO WHERE id_tipo_producto = p_id_tipo_producto;
    IF v_tipo_pago_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20040, 'Error: El tipo de pago especificado no existe');
    END IF;

    -- Validar que el id_tarjeta no sea igual al id_pago_tarjeta
    IF p_id_tarjeta = p_id_pago_tarjeta THEN
        RAISE_APPLICATION_ERROR(-20041, 'Error: No se puede pagar una tarjeta con la misma tarjeta');
    END IF;

    --Verificar si el pago se va a realizar con tarjeta o cuenta, al menos uno de los dos debe ser diferente de nulo
    IF p_id_tarjeta IS NULL AND p_id_cuenta IS NULL THEN
        RAISE_APPLICATION_ERROR(-20042, 'Error: Debe especificar al menos una tarjeta o cuenta para el pago');
    END IF;

    -- Validar que el id_tarjeta exista y sea del cliente
    IF p_id_tarjeta IS NOT NULL THEN
        SELECT COUNT(*) INTO v_tarjeta_existe FROM TARJETA WHERE id_tarjeta = p_id_tarjeta AND id_cliente = pd_id_cliente;
        IF v_tarjeta_existe = 0 THEN
            RAISE_APPLICATION_ERROR(-20042, 'Error: La tarjeta especificada no existe o no pertenece al cliente');
        END IF;
    END IF;

    -- Validar que el id_cuenta exista y sea del cliente
    IF p_id_cuenta IS NOT NULL THEN
        SELECT COUNT(*) INTO v_cuenta_existe FROM CUENTA WHERE id_cuenta = p_id_cuenta AND id_cliente = pd_id_cliente;
        IF v_cuenta_existe = 0 THEN
            RAISE_APPLICATION_ERROR(-20042, 'Error: La cuenta especificada no existe o no pertenece al cliente');
        END IF;
    END IF;

    --Validar que solo se haya ingresado uno de los dos, tarjeta o cuenta
    IF p_id_tarjeta IS NOT NULL AND p_id_cuenta IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20042, 'Error: Solo se puede especificar una tarjeta o cuenta para el pago');
    END IF;

    -- Verificar que el metodo usado tenga el saldo suficiente para realizar el pago
    IF p_id_tarjeta IS NOT NULL THEN
        SELECT saldo_tarjeta INTO v_pago_tarjeta_existe FROM TARJETA WHERE id_tarjeta = p_id_tarjeta;
        IF v_pago_tarjeta_existe < v_monto THEN
            RAISE_APPLICATION_ERROR(-20043, 'Error: La tarjeta no tiene saldo suficiente para realizar el pago');
        END IF;
    ELSIF p_id_cuenta IS NOT NULL THEN
        SELECT saldo_cuenta INTO v_pago_tarjeta_existe FROM CUENTA WHERE id_cuenta = p_id_cuenta;
        IF v_pago_tarjeta_existe < v_monto THEN
            RAISE_APPLICATION_ERROR(-20044, 'Error: La cuenta no tiene saldo suficiente para realizar el pago');
        END IF;
    END IF;



    


    -- Caso 1: Pago de productos (tipo_pago = 1)
    IF p_tipo_pago = 1 THEN
        -- Dentro del caso de pago de productos, id_tipo_pago puede ser 1 pago de energía eléctrica, 2 pago de agua potable, 3 pago de matrícula USAC, 4 pago de curso de vacaciones USAC, 5 pago de seguro, 6 pago de tarjeta, 7 pago de préstamo
        -- En cada caso, validar que el id_pago_tarjeta, id_prestamo o id_seguro no sean nulos, dependiendo del tipo de pago
        -- Caso 1.5: Pago de seguro (id_seguro)
        IF p_id_tipo_producto = 5 THEN

            IF p_id_seguro IS NULL THEN
                RAISE_APPLICATION_ERROR(-20045, 'Error: El id_seguro no puede ser nulo para el pago de seguro');
            END IF;

            --Los demás campos que se podrían pagar deben ser nulos
            IF  p_id_prestamo IS NOT NULL OR p_id_pago_tarjeta IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20052, 'Error: Para el pago de productos, los campos id_prestamo, id_pago_tarjeta y id_seguro deben ser nulos');
            END IF;
            

            -- Validar que el id_seguro exista
            SELECT COUNT(*) INTO v_seguro_existe FROM SEGURO WHERE id_seguro = p_id_seguro;
            IF v_seguro_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20046, 'Error: El seguro especificado no existe');
            END IF;

            -- Verificamos que el monto a pagar sea igual al valor_seguro de la tabla seguro
            SELECT COUNT(*) INTO v_seguro_existe FROM SEGURO WHERE id_seguro = p_id_seguro AND valor_seguro = p_monto;
            IF v_seguro_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20047, 'Error: El monto a pagar no es igual al valor del seguro');
            END IF;

            -- Actualizar el saldo del seguro
            UPDATE SEGURO SET cantidad_pagos = cantidad_pagos + 1, meses_asegurados = meses_asegurados + 12 WHERE id_seguro = p_id_seguro;

        ELSIF p_id_tipo_producto = 6 THEN
            -- Caso 1.6: Pago de tarjeta (id_pago_tarjeta)
            IF p_id_pago_tarjeta IS NULL THEN
                RAISE_APPLICATION_ERROR(-20048, 'Error: El id_pago_tarjeta no puede ser nulo para el pago de tarjeta');
            END IF;

            IF  p_id_prestamo IS NOT NULL OR p_id_seguro IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20052, 'Error: Para el pago de productos, los campos id_prestamo, id_pago_tarjeta y id_seguro deben ser nulos');
            END IF;

            -- Validar que el id_pago_tarjeta exista
            SELECT COUNT(*) INTO v_pago_tarjeta_existe FROM TARJETA WHERE id_tarjeta = p_id_pago_tarjeta;
            IF v_pago_tarjeta_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20049, 'Error: La tarjeta especificada no existe');
            END IF;

            --Si la tarjeta es de debito, damos un error
            SELECT COUNT(*) INTO v_pago_tarjeta_existe FROM TARJETA WHERE id_tarjeta = p_id_pago_tarjeta AND id_tipo = 'D';
            IF v_pago_tarjeta_existe > 0 THEN
                RAISE_APPLICATION_ERROR(-20050, 'Error: No se puede pagar una tarjeta de debito');
            END IF;

            -- Si la tarjeta existe, entonces actualizamos el saldo de la tarjeta
            sp_pagar_tarjeta(
                p_id_tarjeta => p_id_pago_tarjeta,
                p_monto => p_monto
            );

        ELSIF p_id_tipo_producto = 7 THEN
            -- Caso 1.7: Pago de préstamo (id_prestamo)
            IF p_id_prestamo IS NULL THEN
                RAISE_APPLICATION_ERROR(-20050, 'Error: El id_prestamo no puede ser nulo para el pago de préstamo');
            END IF;

            IF  p_id_seguro IS NOT NULL OR p_id_pago_tarjeta IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20052, 'Error: Para el pago de productos, los campos id_prestamo, id_pago_tarjeta y id_seguro deben ser nulos');
            END IF;
            -- Validar que el id_prestamo exista
            SELECT COUNT(*) INTO v_prestamo_existe FROM PRESTAMO WHERE id_prestamo = p_id_prestamo;
            IF v_prestamo_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20051, 'Error: El préstamo especificado no existe');
            END IF;

            --LLamamos a la función de pago de préstamo fn_pagar_proxima_cuota(p_id_prestamo, fecha, p_monto)
            v_resultado := fn_pagar_proxima_cuota(p_id_prestamo, SYSDATE, p_monto);
            DBMS_OUTPUT.PUT_LINE(v_resultado);
            

        ELSE

        --Para todos los demás casos, validar que el id_pago_tarjeta, id_prestamo o id_seguro sean nulos
            IF  p_id_pago_tarjeta IS NOT NULL OR p_id_prestamo IS NOT NULL OR p_id_seguro IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20052, 'Error: Para el tipo de producto ingresado, los campos id_prestamo, id_pago_tarjeta y id_seguro deben ser nulos');
            END IF;

        END IF;
    -- Caso 2: Pago de productos (tipo_pago = 2)
        -- En este caso se le pagar al banco por lo que no hay que hacer ninguna operación adicional. Unicamente verificar que los demas campos sean nulos
    ELSIF p_tipo_pago = 2 THEN
        -- Validar que el id_tarjeta, id_cuenta, id_prestamo y id_seguro sean nulos
        IF  p_id_prestamo IS NOT NULL OR p_id_seguro IS NOT NULL OR p_id_pago_tarjeta IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20052, 'Error: Para el pago de productos, los campos id_prestamo, id_pago_tarjeta y id_seguro deben ser nulos');
        END IF;

    END IF;

    -- Paso 2: Insertar el pago en la tabla PAGO_PRODUCTO_SERVICIO
    INSERT INTO PAGO_PRODUCTO_SERVICIO (
        id_tipo_pago,
        tipo_pago,
        id_tarjeta,
        id_cliente,
        id_cuenta,
        id_prestamo,
        id_seguro,
        id_pago_tarjeta,
        descripcion,
        monto
    ) VALUES (
        p_id_tipo_producto,
        p_tipo_pago,
        p_id_tarjeta,
        pd_id_cliente,
        p_id_cuenta,
        p_id_prestamo,
        p_id_seguro,
        p_id_pago_tarjeta,
        p_descripcion,
        v_monto
    );


    COMMIT; -- Confirmar la transacción


    DBMS_OUTPUT.PUT_LINE('Pago realizado con éxito. Realice la transaccion correspondiente para el pago de productos.');


EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- Deshacer la transacción en caso de error
        RAISE_APPLICATION_ERROR(-20053, 'Error: Ocurrió un error al procesar el pago: ' || SQLERRM);
END sp_get_product_service;
/

CREATE OR REPLACE PROCEDURE sp_products_by_client(
   p_id_cliente IN CLIENTE.id_cliente%TYPE
) AS
    v_cliente_existe INTEGER;
    v_productos_count INTEGER := 0;
BEGIN
    -- Verificar si el cliente existe
    SELECT COUNT(*) INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;

    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El cliente con ID ' || p_id_cliente || ' no existe.');
    END IF;

    -- Activar salida de datos
    DBMS_OUTPUT.PUT_LINE('PRODUCTOS Y SERVICIOS DEL CLIENTE ID: ' || p_id_cliente);
    DBMS_OUTPUT.PUT_LINE('===================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('ID', 8) || 
        RPAD('TIPO PRODUCTO', 30) || 
        RPAD('CATEGORIA', 20) || 
        RPAD('MONTO', 15) || 
        RPAD('PRODUCTO ASOCIADO', 25) || 
        'DESCRIPCION'
    );
    DBMS_OUTPUT.PUT_LINE('===================================================');
    
    -- Mostrar productos del cliente
    FOR r IN (
        SELECT 
            id_pago_producto_servicio,
            tipo_producto,
            categoria,
            TO_CHAR(monto, 'L999G999D99') AS monto_formateado,
            producto_asociado,
            descripcion
        FROM 
            v_productos_cliente
        WHERE 
            id_cliente = p_id_cliente
        ORDER BY 
            fecha_creacion DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(r.id_pago_producto_servicio, 8) || 
            RPAD(r.tipo_producto, 30) || 
            RPAD(r.categoria, 20) || 
            RPAD(r.monto_formateado, 15) || 
            RPAD(NVL(r.producto_asociado, 'N/A'), 25) || 
            NVL(r.descripcion, '')
        );
        v_productos_count := v_productos_count + 1;
    END LOOP;
    
    -- Mostrar resumen
    DBMS_OUTPUT.PUT_LINE('===================================================');
    IF v_productos_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El cliente no tiene productos o servicios asociados.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total productos/servicios: ' || v_productos_count);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RAISE;
END sp_products_by_client;
/

