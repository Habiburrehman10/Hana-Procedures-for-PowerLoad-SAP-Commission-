CREATE PROCEDURE HABIB.pro_VALIDATE_USER(
    IN email VARCHAR(127),
    IN input_password VARCHAR(255),
    OUT login_success BOOLEAN
)
LANGUAGE SQLSCRIPT
AS
BEGIN
    DECLARE stored_password VARBINARY(256);

    -- Hash the input password
    DECLARE hashed_password VARBINARY(256) := HASH_SHA256 (TO_BINARY(input_password));

    -- Retrieve the stored hashed password
    SELECT "PASSWORD_ENCRYPT" INTO stored_password
    FROM USER_CREDENTIALS
    WHERE "EMAIL" = :email limit 1 ;

    -- Compare the hashed input password with the stored password
    IF hashed_password = stored_password THEN
        login_success := TRUE;
    ELSE
        login_success := FALSE;
    END IF;
END;