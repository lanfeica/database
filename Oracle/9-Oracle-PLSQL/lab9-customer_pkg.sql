-- Course: CST2355 Section??
-- Created by: Fei Lan
-- Due date: April 10, 2023
-- Lab 9 create a customer_pkg specification
CREATE OR REPLACE PACKAGE customer_pkg AS
    PROCEDURE change_telephone (
        idcustomer      customer.idcustomer%TYPE,
        telephonetype   VARCHAR2,
        telephonenumber VARCHAR2
    );

    PROCEDURE change_address (
        idcustomer customer.idcustomer%TYPE,
        street     VARCHAR2,
        city       VARCHAR2,
        province   VARCHAR2,
        postalcode VARCHAR2
    );

    PROCEDURE change_name (
        idcustomer customer.idcustomer%TYPE,
        firstname  VARCHAR2,
        lastname   VARCHAR2
    );

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
    ) RETURN INTEGER;

    FUNCTION get_age (
        idcustomer customer.idcustomer%TYPE
    ) RETURN INTEGER;

END customer_pkg;
/