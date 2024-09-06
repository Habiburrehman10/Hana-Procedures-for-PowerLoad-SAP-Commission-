CREATE PROCEDURE HABIB.pro_UPDATE_PASSWORD(
    IN p_email VARCHAR(127),
    IN p_new_password VARCHAR(255),
    OUT p_result_message NVARCHAR(500)
)
LANGUAGE SQLSCRIPT
AS
BEGIN
    -- Hash the new password using SHA-256
    DECLARE hashed_password VARBINARY(256) := HASH_SHA256 (TO_BINARY(p_new_password));
    
    -- Update the user's password and check how many rows were affected
    DECLARE affected_rows INT;
    
    UPDATE USER_CREDENTIALS
    SET "PASSWORD_ENCRYPT" = hashed_password,
        "MODIFIED_DATE" = CURRENT_TIMESTAMP
    WHERE "EMAIL" = p_email;

    -- Check the number of affected rows
    SELECT COUNT(*) INTO affected_rows
    FROM USER_CREDENTIALS
    WHERE "EMAIL" = p_email;

    -- Set the result message based on the affected rows
    IF affected_rows = 0 THEN
        -- If no rows were affected, the email might not exist in the table
        p_result_message := 'User not found or update failed';
    ELSE
        -- If update was successful
        p_result_message := 'Password updated successfully';
    END IF;
END;