CREATE PROCEDURE HABIB.pro_INSERT_USER(
    IN p_email VARCHAR(127),
    IN p_password VARCHAR(255),
    IN p_role VARCHAR(50)
)
LANGUAGE SQLSCRIPT
AS
BEGIN
    -- Hash the input password using SHA-256
    DECLARE hashed_password VARBINARY(256) := HASH_SHA256 (TO_BINARY(p_password));

    -- Insert the data into the table
    INSERT INTO USER_CREDENTIALS  (
        "EMAIL",
        "PASSWORD_ENCRYPT",
        "ROLE"
    )
    VALUES (
        p_email,
        hashed_password,
        p_role
    );
END;