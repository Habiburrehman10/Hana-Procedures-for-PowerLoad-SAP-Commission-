CREATE PROCEDURE MOVE_ERROR_RECORDS_TO_ARCHIVE ()
LANGUAGE SQLSCRIPT
AS
BEGIN
    -- Declare variables
    DECLARE lv_COMPENSATIONDATE TIMESTAMP;
    DECLARE lv_MDLTCELLSEQ BIGINT;
    
    -- Cursor to iterate over the ERROR table records
     DECLARE CURSOR cur FOR 
        SELECT *
        FROM HABIB.ZSALESTRANSACTION_ERROR;
        
     open cur;
    FOR error_row AS cur DO
        -- Check if a matching record exists in ZMDLT with a COMPENSATIONDATE above the current date
        SELECT EFFECTIVEENDDATE,MDLTCELLSEQ
        INTO lv_COMPENSATIONDATE,lv_MDLTCELLSEQ
        FROM ZMDLT
        WHERE EVENTTYPE = error_row.EVENTTYPE
          AND EFFECTIVEENDDATE < CURRENT_DATE
        LIMIT 1;
        
        -- If a matching record is found, move the error record to the archive table
        IF :lv_COMPENSATIONDATE IS NOT NULL THEN
            -- Insert the record into the archive table
            INSERT INTO HABIB.ZARCHIVEDCAMPAIGN_ERROR
            SELECT * FROM HABIB.ZSALESTRANSACTION_ERROR WHERE SALESTRANSACTIONSEQ = error_row.SALESTRANSACTIONSEQ AND GENERICATTRIBUTE25 = lv_MDLTCELLSEQ; 
            
            -- Delete the record from the ERROR table
            DELETE FROM HABIB.ZSALESTRANSACTION_ERROR WHERE SALESTRANSACTIONSEQ = error_row.SALESTRANSACTIONSEQ AND GENERICATTRIBUTE25 = lv_MDLTCELLSEQ;
        END IF;
    END FOR;
    close cur;
END;