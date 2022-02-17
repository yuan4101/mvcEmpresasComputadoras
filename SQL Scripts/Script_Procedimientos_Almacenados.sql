--STORED PRECEDURE FOR POINT 1 ----------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE prcRegistrarEmpresa (P_NIT IN EMPRESA.EM_NIT%TYPE, 
P_NOMBRE IN EMPRESA.EM_NOMBRE%TYPE, P_FECHA_CREACION IN EMPRESA.EM_FECHA_CREACION%TYPE)
IS
BEGIN
    INSERT 
    INTO EMPRESA 
    VALUES(P_NIT, P_NOMBRE, P_FECHA_CREACION);
END prcRegistrarEmpresa;

-----------------------------------------------------------------------------------------------------------------------------------
--STORED PRECEDURE FOR POINT 2 ----------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE prcRegistrarPortatil (P_NRO_SERIAL IN COMPUTADOR.COM_NRO_SERIAL%TYPE, 
    P_NIT IN EMPRESA.EM_NIT%TYPE, P_MARCA IN COMPUTADOR.COM_MARCA%TYPE, 
    P_CAP_DISCO_DURO_GB IN COMPUTADOR.COM_CAP_DISCO_DURO_GB%TYPE, 
    P_TIPO_DISCO_DURO IN COMPUTADOR.COM_TIPO_DISCO_DURO%TYPE,
    P_CAP_MEMORIA_RAM_GB IN COMPUTADOR.COM_CAP_MEMORIA_RAM_GB%TYPE,
    P_FECHA_ENSAMBLE IN COMPUTADOR.COM_FECHA_ENSAMBLE%TYPE)
IS
BEGIN
    INSERT 
    INTO COMPUTADOR
    VALUES(P_NRO_SERIAL, P_NIT, P_MARCA, P_CAP_DISCO_DURO_GB, P_TIPO_DISCO_DURO, P_CAP_MEMORIA_RAM_GB, P_FECHA_ENSAMBLE);
END prcRegistrarPortatil;

-----------------------------------------------------------------------------------------------------------------------------------
--STORED PRECEDURE FOR POINT 3 ----------------------------------------------------------------------------------------------------

-- FIRST PROCEDURE VARIANT --------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE prcConsPortatilesMarca(P_NOMBRE IN EMPRESA.EM_NOMBRE%TYPE, P_MARCA IN COMPUTADOR.COM_MARCA%TYPE, P_CURSOR_DATOS IN OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN P_CURSOR_DATOS FOR 
        SELECT COM_NRO_SERIAL, COM_CAP_DISCO_DURO_GB, COM_CAP_MEMORIA_RAM_GB
        FROM EMPRESA 
        INNER JOIN COMPUTADOR 
        ON EMPRESA.EM_NIT = COMPUTADOR.EM_NIT
        WHERE (P_NOMBRE LIKE EMPRESA.EM_NOMBRE AND P_MARCA LIKE COMPUTADOR.COM_MARCA);
END prcConsPortatilesMarca;

SET SERVEROUTPUT ON

-- TEST prcConsPortatilesMarca ----------------------------------------------------------------------------------------------------

DECLARE
    V_CURSOR SYS_REFCURSOR;
    v_serial COMPUTADOR.COM_NRO_SERIAL%TYPE;
    v_cap_disco_duro_gb COMPUTADOR.COM_CAP_DISCO_DURO_GB%TYPE;
    v_cap_memoria_ram_gb COMPUTADOR.COM_CAP_MEMORIA_RAM_GB%TYPE;
BEGIN
    prcConsPortatilesMarca('SpeedLogic', 'Asus', V_CURSOR);
        LOOP
            FETCH V_CURSOR 
            INTO v_serial, v_cap_disco_duro_gb, v_cap_memoria_ram_gb;
            EXIT WHEN V_CURSOR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_serial || ', ' || v_cap_disco_duro_gb || ', ' || v_cap_memoria_ram_gb);
        END LOOP;
END;

-- SECOND PROCEDURE VARIANT ------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pkgPortatilesMarca AS
    TYPE V_CURSOR_TYPE IS REF CURSOR;
    PROCEDURE ConsPortatilesMarca(P_NOMBRE IN EMPRESA.EM_NOMBRE%TYPE, P_MARCA IN COMPUTADOR.COM_MARCA%TYPE, P_CURSOR_DATOS IN OUT SYS_REFCURSOR);
END pkgPortatilesMarca;

CREATE OR REPLACE PACKAGE BODY pkgPortatilesMarca AS
    PROCEDURE ConsPortatilesMarca(P_NOMBRE IN EMPRESA.EM_NOMBRE%TYPE, P_MARCA IN COMPUTADOR.COM_MARCA%TYPE, P_CURSOR_DATOS IN OUT SYS_REFCURSOR)
    IS
        V_CURSOR V_CURSOR_TYPE;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT COM_NRO_SERIAL, COM_CAP_DISCO_DURO_GB, COM_CAP_MEMORIA_RAM_GB
            FROM EMPRESA
            INNER JOIN COMPUTADOR
            ON EMPRESA.EM_NIT = COMPUTADOR.EM_NIT
            WHERE (P_NOMBRE LIKE EMPRESA.EM_NOMBRE AND P_MARCA LIKE COMPUTADOR.COM_MARCA);
        P_CURSOR_DATOS := V_CURSOR;
    END ConsPortatilesMarca;
END pkgPortatilesMarca;

-----------------------------------------------------------------------------------------------------------------------------------

