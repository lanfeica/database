-- Course: CST2355
-- Created by: Fei Lan
-- Due date: April 10, 2023
-- Lab 9 create a customer_pkg body
CREATE OR REPLACE PACKAGE BODY customer_pkg AS

    PROCEDURE change_telephone (
        idcustomer      IN customer.idcustomer%TYPE,
        telephonetype   IN VARCHAR2,
        telephonenumber IN VARCHAR2
    ) IS
        new_idcustomer_telephone NUMBER(38, 0);
        new_idtelephone          NUMBER(38, 0);
        row_count            NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO row_count
        FROM
            telephone
            RIGHT OUTER JOIN customer_telephone 
            ON telephone.idtelephone = customer_telephone.telephone_idtelephone
        WHERE
                customer_telephone.customer_idcustomer = idcustomer
            AND customer_telephone.enddate IS NULL;

        IF row_count != 0 THEN
            UPDATE customer_telephone
            SET
                enddate = sysdate
            WHERE
                    customer_idcustomer = idcustomer
                AND customer_telephone.enddate IS NULL;

        END IF;

        new_idtelephone := seq_num.nextval;
        INSERT INTO telephone VALUES (
            new_idtelephone,
            telephonetype,
            telephonenumber
        );

        new_idcustomer_telephone := seq_num.nextval;
        INSERT INTO customer_telephone VALUES (
            new_idcustomer_telephone,
            sysdate,
            NULL,
            idcustomer,
            new_idtelephone
        );

    END change_telephone;

    PROCEDURE change_address (
        idcustomer customer.idcustomer%TYPE,
        street     VARCHAR2,
        city       VARCHAR2,
        province   VARCHAR2,
        postalcode VARCHAR2
    ) IS
        new_idcustomer_address NUMBER(38, 0);
        new_idaddress          NUMBER(38, 0);
        row_count          NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO row_count
        FROM
            address
            RIGHT OUTER JOIN customer_address 
            ON address.idaddress = customer_address.address_idaddress
        WHERE
                customer_address.customer_idcustomer = idcustomer
            AND customer_address.enddate IS NULL;

        IF row_count != 0 THEN
            UPDATE customer_address
            SET
                enddate = sysdate
            WHERE
                    customer_idcustomer = idcustomer
                AND enddate IS NULL;

        END IF;

        new_idaddress := seq_num.nextval;
        INSERT INTO address VALUES (
            new_idaddress,
            street,
            city,
            province,
            postalcode
        );

        new_idcustomer_address := seq_num.nextval;
        INSERT INTO customer_address VALUES (
            new_idcustomer_address,
            sysdate,
            NULL,
            idcustomer,
            new_idaddress
        );

    END change_address;

    PROCEDURE change_name (
        idcustomer customer.idcustomer%TYPE,
        firstname  VARCHAR2,
        lastname   VARCHAR2
    ) IS
        new_idcustomer_name NUMBER(38, 0);
        new_idname          NUMBER(38, 0);
        row_count           NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO row_count
        FROM
            cname
            RIGHT OUTER JOIN customer_name ON cname.idname = customer_name.name_idname
        WHERE
                customer_name.customer_idcustomer = idcustomer
            AND customer_name.enddate IS NULL;

        IF row_count != 0 THEN
            UPDATE customer_name
            SET
                enddate = sysdate
            WHERE
                    customer_idcustomer = idcustomer
                AND enddate IS NULL;

        END IF;

        new_idname := seq_num.nextval;
        INSERT INTO cname VALUES (
            new_idname,
            firstname,
            lastname
        );

        new_idcustomer_name := seq_num.nextval;
        INSERT INTO customer_name VALUES (
            new_idcustomer_name,
            sysdate,
            NULL,
            idcustomer,
            new_idcustomer_name
        );

    END change_name;

    FUNCTION new_customer (
        birthdate       TIMESTAMP,
        password        VARCHAR2,
        telephonetype   VARCHAR2 DEFAULT NULL,
        telephonenumber VARCHAR2 DEFAULT NULL,
        street          VARCHAR2 DEFAULT NULL,
        city            VARCHAR2 DEFAULT NULL,
        province        VARCHAR2 DEFAULT NULL,
        postalcode      VARCHAR2 DEFAULT NULL,
        firstname       VARCHAR2 DEFAULT NULL,
        lastname        VARCHAR2 DEFAULT NULL
    ) RETURN INTEGER IS

        new_idcustomer           NUMBER(38, 0);
        new_idname               NUMBER(38, 0);
        new_idcustomer_name      NUMBER(38, 0);
        new_idaddress            NUMBER(38, 0);
        new_idcustomer_address   NUMBER(38, 0);
        new_idtelephone          NUMBER(38, 0);
        new_idcustomer_telephone NUMBER(38, 0);
    BEGIN
        IF
            telephonetype IS NULL
            AND telephonenumber IS NULL
            AND street IS NULL
            AND city IS NULL
            AND province IS NULL
            AND postalcode IS NULL
            AND firstname IS NULL
            AND lastname IS NULL
        THEN
            RETURN -1;
        ELSE
            new_idcustomer := seq_num.nextval;
            INSERT INTO customer VALUES (
                new_idcustomer,
                birthdate,
                password
            );

            IF firstname IS NOT NULL OR lastname IS NOT NULL THEN
                change_name(new_idcustomer, firstname, lastname);
            END IF;

            IF telephonetype IS NOT NULL OR telephonenumber IS NOT NULL THEN
                change_telephone(new_idcustomer, telephonetype, telephonenumber);
            END IF;

            IF street IS NOT NULL OR city IS NOT NULL OR province IS NOT NULL 
            OR postalcode IS NOT NULL THEN
                change_address(new_idcustomer, street, city, province, postalcode);
            END IF;

            RETURN new_idcustomer;
        END IF;
    END new_customer;

    FUNCTION get_age (
        idcustomer customer.idcustomer%TYPE
    ) RETURN INTEGER IS
        c_birthdate TIMESTAMP;
        age         NUMBER;
    BEGIN
        SELECT
            birthdate
        INTO c_birthdate
        FROM
            customer
        WHERE
            idcustomer = idcustomer;

        age := trunc(months_between(sysdate, c_birthdate) / 12);
        RETURN age;
    END get_age;

END customer_pkg;
/