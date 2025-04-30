CREATE OR REPLACE PROCEDURE sp_transaction(
    p_id_tipo_transaccion IN INTEGER,
    p_fecha_transaccion IN TIMESTAMP,
    p_otros_detalles IN VARCHAR2 DEFAULT NULL,
    p_id_cliente IN INTEGER,
    p_id_cuenta IN INTEGER DEFAULT NULL,
    p_id_tarjeta IN INTEGER DEFAULT NULL,
    p_valor IN NUMBER,
    p_id_cuenta_origen IN INTEGER DEFAULT NULL,
    p_id_cuenta_destino IN INTEGER DEFAULT NULL
)
IS
    v_cliente_existe INTEGER;
    v_cuenta_existe INTEGER;
    v_tarjeta_existe INTEGER;
    v_tipo_transaccion_existe INTEGER;
    v_monto_suficiente INTEGER;

BEGIN


/*
Tipos de transacciones
Tipo 1: Débito, se quita dinero de la cuenta y se agrega a otra cuenta
campos obligatorios:
id_tipo_transacción
fecha_transacción
id_cliente
id_cuenta_origen
id_cuenta_destino
valor (monto a transferir)

Tipo 2: Crédito, se agrega dinero a la cuenta, el dinero se supone que viene de fuera
campos obligatorios:
id_tipo_transacción
fecha_transacción
id_cliente
id_cuenta
valor (monto a agregar)

Tipo 3: Consumo con tarjeta, se resta del saldo de la tarjeta (pago con tarjeta de crédito o débito)
campos obligatorios:
id_tipo_transacción
fecha_transacción
id_cliente
id_tarjeta
valor (monto a consumir restar de la tarjeta)

Tipo 4: Remesa, se agrega dinero a la cuenta, el dinero se supone que viene de fuera
campos obligatorios
id_tipo_transacción
fecha_transacción
id_cliente
id_cuenta
valor (monto a agregar)

tipo 5: Pago de servicio/producto, se resta del saldo de la tarjeta o de la cuenta (puede ser cualquiera de las dos)
campos obligatorios:
id_tipo_transacción
fecha_transacción
id_cliente
id_cuenta o id_tarjeta (uno de los dos)
valor (monto a pagar)
cuenta_destino (cuenta a la que se le va a pagar el servicio)
*/


/*
Validaciones:
En débito verificar que la cuenta origen pertenezca al cliente
En crédito verificar que la cuenta pertenezca al cliente
En consumo verificar que la tarjeta pertenezca al cliente
En remesa verificar que la cuenta pertenezca al cliente
En pago de servicio verificar que la cuenta o tarjeta pertenezca al cliente

Siempre verificar que el monto a pagar sea positivo y que la cuenta origen tenga suficiente saldo

*/

/*Validaciones obligatorias
1. que el cliente exista
2. Que las cuentas involucradas existan
3. Que la tarjeta exista
4. Que el tipo de transacción exista
5. Que el monto a pagar sea positivo
6. Que la cuenta origen tenga suficiente saldo (si aplica)
7. Que la cuenta destino exista (si aplica)
9. Fecha valida (no puede ser mayor a la fecha actual)
*/

   --Validaciones globales, iguales en todos los casos. id_cliente, fecha_transaccion, id_tipo_transaccion, valor. Siempre obligatorios y deben cumplir con las validaciones

    --Validar que el cliente exista
    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;
    
    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El cliente no existe');
    END IF;


    --Validar que el tipo de transacción exista
    SELECT COUNT(*)
    INTO v_tipo_transaccion_existe
    FROM TIPO_TRANSACCION
    WHERE id_tipo_transaccion = p_id_tipo_transaccion;

    IF v_tipo_transaccion_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: El tipo de transacción no existe');
    END IF;


    --Validar que el monto a pagar sea positivo
    IF p_valor <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error: El monto a pagar debe ser positivo');
    END IF;


    --Validar que la fecha de transacción no sea mayor a la fecha actual
    IF p_fecha_transaccion > SYSTIMESTAMP THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error: La fecha de transacción no puede ser mayor a la fecha actual');
    END IF;

    --Iniciamos con el tipo de transacción en especifco. Usamos una estructura CASE

    CASE p_id_tipo_transaccion
        --Tipo 1: Débito, se quita dinero de la cuenta y se agrega a otra cuenta
        WHEN 1 THEN
            --Validar que la cuenta origen pertenezca al cliente
            SELECT COUNT(*)
            INTO v_cuenta_existe
            FROM CUENTA
            WHERE id_cuenta = p_id_cuenta_origen AND id_cliente = p_id_cliente;
            
            IF v_cuenta_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20005, 'Error: La cuenta origen no pertenece al cliente');
            END IF;

            --No se requiere que la cuenta destino pertenezca al cliente, ya que puede ser una cuenta de otra persona
            --Validar que la cuenta destino exista
            SELECT COUNT(*)
            INTO v_cuenta_existe
            FROM CUENTA
            WHERE id_cuenta = p_id_cuenta_destino;

            IF v_cuenta_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20006, 'Error: La cuenta destino no existe');
            END IF;

            --Validar que la cuenta origen tenga suficiente saldo
            SELECT COUNT(*)
            INTO v_monto_suficiente
            FROM CUENTA
            WHERE id_cuenta = p_id_cuenta_origen AND saldo_cuenta >= p_valor;


            IF v_monto_suficiente = 0 THEN
                RAISE_APPLICATION_ERROR(-20007, 'Error: La cuenta origen no tiene suficiente saldo');
            END IF;


            --Insertar la transacción
            INSERT INTO TRANSACCION (
                id_tipo_transaccion,
                fecha_transaccion,
                otros_detalles,
                id_cliente,
                id_cuenta_origen,
                id_cuenta_destino,
                valor
            ) VALUES (
                p_id_tipo_transaccion,
                p_fecha_transaccion,
                p_otros_detalles,
                p_id_cliente,
                p_id_cuenta_origen,
                p_id_cuenta_destino,
                p_valor
            );

            --Actualizar el saldo de la cuenta origen y destino
            UPDATE CUENTA
            SET saldo_cuenta = saldo_cuenta - p_valor
            WHERE id_cuenta = p_id_cuenta_origen;

            UPDATE CUENTA
            SET saldo_cuenta = saldo_cuenta + p_valor
            WHERE id_cuenta = p_id_cuenta_destino;

            --Finalizar y mostrar mensaje OK
            COMMIT;

        WHEN 2 THEN
            --Tipo 2: Crédito, se agrega dinero a la cuenta, el dinero se supone que viene de fuera
            --Validar que la cuenta pertenezca al cliente
            SELECT COUNT(*)
            INTO v_cuenta_existe
            FROM CUENTA
            WHERE id_cuenta = p_id_cuenta AND id_cliente = p_id_cliente;
            
            IF v_cuenta_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20008, 'Error: La cuenta no pertenece al cliente');
            END IF;

            --Insertar la transacción
            INSERT INTO TRANSACCION (
                id_tipo_transaccion,
                fecha_transaccion,
                otros_detalles,
                id_cliente,
                id_cuenta,
                valor
            ) VALUES (
                p_id_tipo_transaccion,
                p_fecha_transaccion,
                p_otros_detalles,
                p_id_cliente,
                p_id_cuenta,
                p_valor
            );

            --Actualizar el saldo de la cuenta
            UPDATE CUENTA
            SET saldo_cuenta = saldo_cuenta + p_valor
            WHERE id_cuenta = p_id_cuenta;


            --Finalizar y mostrar mensaje OK
            COMMIT;

        WHEN 3 THEN
            --Tipo 3: Consumo con tarjeta, se resta del saldo de la tarjeta (pago con tarjeta de crédito o débito)
            --Validar que la tarjeta pertenezca al cliente
            SELECT COUNT(*)
            INTO v_tarjeta_existe
            FROM TARJETA
            WHERE id_tarjeta = p_id_tarjeta AND id_cliente = p_id_cliente;
            
            IF v_tarjeta_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20009, 'Error: La tarjeta no pertenece al cliente');
            END IF;

            --Validar que la tarjeta tenga suficiente saldo
            SELECT COUNT(*)
            INTO v_monto_suficiente
            FROM TARJETA
            WHERE id_tarjeta = p_id_tarjeta AND saldo_tarjeta >= p_valor;


            IF v_monto_suficiente = 0 THEN
                RAISE_APPLICATION_ERROR(-20010, 'Error: La tarjeta no tiene suficiente saldo');
            END IF;

            --Insertar la transacción
            INSERT INTO TRANSACCION (
                id_tipo_transaccion,
                fecha_transaccion,
                otros_detalles,
                id_cliente,
                id_tarjeta,
                valor
            ) VALUES (
                p_id_tipo_transaccion,
                p_fecha_transaccion,
                p_otros_detalles,
                p_id_cliente,
                p_id_tarjeta,
                p_valor
            );


            --Actualizar el saldo de la tarjeta
            UPDATE TARJETA
            SET saldo_tarjeta = saldo_tarjeta - p_valor
            WHERE id_tarjeta = p_id_tarjeta;

            --Si la tarjeta es de debito, actualizar el saldo de la cuenta asociada a la tarjeta
            


            --Finalizar y mostrar mensaje OK
            COMMIT;

        WHEN 4 THEN
            --Tipo 4: Remesa, se agrega dinero a la cuenta, el dinero se supone que viene de fuera
            --Validar que la cuenta pertenezca al cliente
            SELECT COUNT(*)
            INTO v_cuenta_existe
            FROM CUENTA
            WHERE id_cuenta = p_id_cuenta AND id_cliente = p_id_cliente;
            
            IF v_cuenta_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20011, 'Error: La cuenta no pertenece al cliente');
            END IF;

            --Insertar la transacción
            INSERT INTO TRANSACCION (
                id_tipo_transaccion,
                fecha_transaccion,
                otros_detalles,
                id_cliente,
                id_cuenta,
                valor
            ) VALUES (
                p_id_tipo_transaccion,
                p_fecha_transaccion,
                p_otros_detalles,
                p_id_cliente,
                p_id_cuenta,
                p_valor
            );

            --Actualizar el saldo de la cuenta
            UPDATE CUENTA
            SET saldo_cuenta = saldo_cuenta + p_valor
            WHERE id_cuenta = p_id_cuenta;


            --Finalizar y mostrar mensaje OK
            COMMIT;


        WHEN 5 THEN
            --Tipo 5: Pago de servicio/producto, se resta del saldo de la tarjeta o de la cuenta (puede ser cualquiera de las dos)
            --Validar que la cuenta o tarjeta pertenezca al cliente
            --Solo debe haber 1 de los dos, si hay los dos, damos error
            IF p_id_cuenta IS NOT NULL AND p_id_tarjeta IS NOT NULL THEN
                RAISE_APPLICATION_ERROR(-20012, 'Error: Solo se puede usar una cuenta o una tarjeta para el pago');
            END IF;

            --Cuenta destino es obligatoria, no puede ser nula
            IF p_id_cuenta_destino IS NULL THEN
                RAISE_APPLICATION_ERROR(-20012, 'Error: La cuenta destino es obligatoria');
            END IF;

            -- Opcion 1: Pago con tarjeta
            IF p_id_tarjeta IS NOT NULL THEN
                --Validar que la tarjeta pertenezca al cliente
                SELECT COUNT(*)
                INTO v_tarjeta_existe
                FROM TARJETA
                WHERE id_tarjeta = p_id_tarjeta AND id_cliente = p_id_cliente;
                
                IF v_tarjeta_existe = 0 THEN
                    RAISE_APPLICATION_ERROR(-20013, 'Error: La tarjeta no pertenece al cliente');
                END IF;

                --Validar que la tarjeta tenga suficiente saldo
                SELECT COUNT(*)
                INTO v_monto_suficiente
                FROM TARJETA
                WHERE id_tarjeta = p_id_tarjeta AND saldo_tarjeta >= p_valor;


                IF v_monto_suficiente = 0 THEN
                    RAISE_APPLICATION_ERROR(-20014, 'Error: La tarjeta no tiene suficiente saldo');
                END IF;

                -- Veriificar que la cuenta destino exista
                SELECT COUNT(*)
                INTO v_cuenta_existe
                FROM CUENTA
                WHERE id_cuenta = p_id_cuenta_destino;

                IF v_cuenta_existe = 0 THEN
                    RAISE_APPLICATION_ERROR(-20015, 'Error: La cuenta destino no existe');
                END IF;

                --Realizar la transacción
                INSERT INTO TRANSACCION (
                    id_tipo_transaccion,
                    fecha_transaccion,
                    otros_detalles,
                    id_cliente,
                    id_tarjeta,
                    valor,
                    id_cuenta_destino
                ) VALUES (
                    p_id_tipo_transaccion,
                    p_fecha_transaccion,
                    p_otros_detalles,
                    p_id_cliente,
                    p_id_tarjeta,
                    p_valor,
                    p_id_cuenta_destino
                );

                --Actualizar el saldo de la tarjeta
                UPDATE TARJETA
                SET saldo_tarjeta = saldo_tarjeta - p_valor
                WHERE id_tarjeta = p_id_tarjeta;

                --Actualizar el saldo de la cuenta destino
                UPDATE CUENTA
                SET saldo_cuenta = saldo_cuenta + p_valor
                WHERE id_cuenta = p_id_cuenta_destino;


                --Finalizar y mostrar mensaje OK
                COMMIT;
            END IF;

            -- Opcion 2: Pago con cuenta

            IF p_id_cuenta IS NOT NULL THEN
                --Validar que la cuenta pertenezca al cliente
                SELECT COUNT(*)
                INTO v_cuenta_existe
                FROM CUENTA
                WHERE id_cuenta = p_id_cuenta AND id_cliente = p_id_cliente;
                
                IF v_cuenta_existe = 0 THEN
                    RAISE_APPLICATION_ERROR(-20016, 'Error: La cuenta no pertenece al cliente');
                END IF;

                --Validar que la cuenta tenga suficiente saldo
                SELECT COUNT(*)
                INTO v_monto_suficiente
                FROM CUENTA
                WHERE id_cuenta = p_id_cuenta AND saldo_cuenta >= p_valor;


                IF v_monto_suficiente = 0 THEN
                    RAISE_APPLICATION_ERROR(-20017, 'Error: La cuenta no tiene suficiente saldo');
                END IF;

                -- Veriificar que la cuenta destino exista
                SELECT COUNT(*)
                INTO v_cuenta_existe
                FROM CUENTA
                WHERE id_cuenta = p_id_cuenta_destino;

                IF v_cuenta_existe = 0 THEN
                    RAISE_APPLICATION_ERROR(-20018, 'Error: La cuenta destino no existe');
                END IF;

                --Realizar la transacción
                INSERT INTO TRANSACCION (
                    id_tipo_transaccion,
                    fecha_transaccion,
                    otros_detalles,
                    id_cliente,
                    id_cuenta,
                    valor,
                    id_cuenta_destino
                ) VALUES (
                    p_id_tipo_transaccion,
                    p_fecha_transaccion,
                    p_otros_detalles,
                    p_id_cliente,
                    p_id_cuenta,
                    p_valor,
                    p_id_cuenta_destino
                );

                --Actualizar el saldo de la cuenta
                UPDATE CUENTA
                SET saldo_cuenta = saldo_cuenta - p_valor
                WHERE id_cuenta = p_id_cuenta;

                --Actualizar el saldo de la cuenta destino
                UPDATE CUENTA
                SET saldo_cuenta = saldo_cuenta + p_valor
                WHERE id_cuenta = p_id_cuenta_destino;

                --Finalizar y mostrar mensaje OK
                COMMIT;
            END IF;

        ELSE
            RAISE_APPLICATION_ERROR(-20019, 'Error: Tipo de transacción no válida');
        END CASE;


    DBMS_OUTPUT.PUT_LINE('Transaccion realizada con exito');

EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error al crear la transacción: ' || SQLERRM);
    END sp_transaction;
/


CREATE OR REPLACE PROCEDURE sp_transactions_by_client(
    p_id_cliente IN INTEGER,
    p_fecha_inicial IN DATE,
    p_fecha_final IN DATE
) IS
    v_cliente_existe INTEGER;
    v_transacciones_count INTEGER := 0;
BEGIN
    -- Validar que el cliente existe
    SELECT COUNT(*) INTO v_cliente_existe
    FROM CLIENTE
    WHERE id_cliente = p_id_cliente;
    
    IF v_cliente_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El cliente especificado no existe');
    END IF;
    
    -- Validar fechas
    IF p_fecha_inicial > p_fecha_final THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: La fecha inicial no puede ser mayor a la fecha final');
    END IF;
    
    -- Validar que las fechas no sean futuras
    IF p_fecha_inicial > TRUNC(SYSDATE) OR p_fecha_final > TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Error: Las fechas no pueden ser futuras');
    END IF;
    
    -- Encabezado del reporte
    DBMS_OUTPUT.PUT_LINE('TRANSACCIONES DEL CLIENTE ID: ' || p_id_cliente);
    DBMS_OUTPUT.PUT_LINE('Periodo: ' || TO_CHAR(p_fecha_inicial, 'DD/MM/YYYY') || 
                        ' al ' || TO_CHAR(p_fecha_final, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('ID', 10) || 
        RPAD('FECHA', 20) || 
        RPAD('TIPO', 20) || 
        RPAD('VALOR', 15) || 
        RPAD('ORIGEN', 20) || 
        RPAD('DESTINO', 20) || 
        'DETALLES'
    );
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');
    
    -- Mostrar transacciones
    FOR r IN (
        SELECT 
            id_transaccion,
            tipo_transaccion,
            TO_CHAR(fecha_transaccion, 'DD/MM/YYYY HH24:MI') AS fecha_formateada,
            valor,
            NVL(numero_cuenta_origen, numero_tarjeta) AS origen,
            numero_cuenta_destino,
            otros_detalles
        FROM 
            v_transacciones_clientes
        WHERE 
            id_cliente = p_id_cliente
            AND fecha_transaccion BETWEEN TRUNC(p_fecha_inicial) AND TRUNC(p_fecha_final) + 0.99999
        ORDER BY 
            fecha_transaccion DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(r.id_transaccion, 10) || 
            RPAD(r.fecha_formateada, 20) || 
            RPAD(r.tipo_transaccion, 20) || 
            RPAD(TO_CHAR(r.valor, 'L999G999D99'), 15) || 
            RPAD(NVL(r.origen, 'N/A'), 20) || 
            RPAD(NVL(r.numero_cuenta_destino, 'N/A'), 20) || 
            NVL(r.otros_detalles, '')
        );
        v_transacciones_count := v_transacciones_count + 1;
    END LOOP;
    
    -- Pie del reporte
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');
    IF v_transacciones_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron transacciones en el periodo especificado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total transacciones: ' || v_transacciones_count);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END sp_transactions_by_client;
/