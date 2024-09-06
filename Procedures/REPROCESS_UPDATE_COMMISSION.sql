CREATE PROCEDURE HABIB.REPROCESS_UPDATE_COMMISSION(
    IN SALESTRANSEQ BIGINT,
    IN LV_DEALER_CODE NVARCHAR(50),
    IN LV_PRODUCT_ID NVARCHAR(50),
    IN p_retailer_msisdn NVARCHAR(50),
    IN p_consumer_msisdn NVARCHAR(50),
    IN p_franchise_id NVARCHAR(50),
    IN p_date NVARCHAR(50),
    IN p_comments NVARCHAR(50),
    IN p_order_id VARCHAR(40),
    IN p_event_type VARCHAR(40),
    IN p_linenumber BIGINT,
    IN p_sublinenumber BIGINT,
    OUT netcommission1 DECIMAL(18,2),
    OUT genericboolean_2 BOOLEAN,
    OUT isError BOOLEAN
   
)
LANGUAGE SQLSCRIPT
AS
BEGIN
	
	
 declare  zresult_table_count smallint;
 declare  error_comm nvarchar(255);
 declare o_check smallint;


 DECLARE result_table1 TABLE (
        retailerid NVARCHAR(50),
        effectivestartdate DATE,
        effectiveenddate DATE,
        islast BOOLEAN,
        createdate DATE,
        genericboolean1 BOOLEAN,
        genericboolean2 BOOLEAN,
        genericattribute5 NVARCHAR(50),
        genericattribute6 NVARCHAR(200),
        genericattribute7 NVARCHAR(200),
        genericattribute10 NVARCHAR(200),
       	aggt DECIMAL(18,2),
        wht DECIMAL(18,2),
        gst DECIMAL(18,2),
        stw DECIMAL(18,2),
        value DECIMAL(18,2),
        gstresult DECIMAL(18,2),
        stwresult DECIMAL(18,2),
        whtresult DECIMAL(18,2),
        netcommission DECIMAL(18,2),
        ORDERID NVARCHAR(50),
        EVENTTYPE NVARCHAR(50),
        LINENUMBER bigint,
        SUBLINENUMBER bigint,
        MDLTCELLSEQ NVARCHAR(127)
    );
    


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	
    	 DECLARE error_msg NVARCHAR(500);
    	  DECLARE error_msg1 NVARCHAR(500);
        
           isError := TRUE;
        IF o_check = 0 THEN
            error_msg := error_comm;
        ELSE
            SELECT ::SQL_ERROR_MESSAGE INTO error_msg FROM DUMMY;
        END IF;
        
        error_msg1 := error_msg;
         
         DELETE FROM ZSALESTRANSACTION_ERROR WHERE "SALESTRANSACTIONSEQ" = SALESTRANSEQ;
        
          -- Insert into the error log table
        INSERT INTO ZSALESTRANSACTION_ERROR
    (
       SALESTRANSACTIONSEQ, BUSINESSUNITNAME, CHANNEL, COMMENTS, COMPENSATIONDATE, EVENTTYPE, GENERICATTRIBUTE1, 
        GENERICATTRIBUTE12, GENERICATTRIBUTE2, GENERICATTRIBUTE27, GENERICATTRIBUTE3, ISRUNNABLE, 
        LINENUMBER, ORDERID, ORIGINTYPEID, PREADJUSTEDVALUE, PRODUCTID, SUBLINENUMBER, TENANTID, 
        UNITTYPEFORLINENUMBER, UNITTYPEFORPREADJUSTEDVALUE, UNITTYPEFORSUBLINENUMBER, UNITTYPEFORVALUE,
         VALUE,MODIFICATIONDATE,ERROR_MSG
    )
    SELECT
    	SALESTRANSEQ,
        T."BUSINESSUNITNAME",
         T."CHANNEL",
          T."COMMENTS",
           T."COMPENSATIONDATE",
            T."EVENTTYPE", 
            T."GENERICATTRIBUTE1",
             T."GENERICATTRIBUTE12",
              T."GENERICATTRIBUTE2",
               'NOT CALCULATED',
                T."GENERICATTRIBUTE3",
                 T."ISRUNNABLE", 
        T."LINENUMBER",
         T."ORDERID",
          T."ORIGINTYPEID",
           T."PREADJUSTEDVALUE", 
           T."PRODUCTID",
            T."SUBLINENUMBER",
             T."TENANTID", 
       T."UNITTYPEFORLINENUMBER",
         T."UNITTYPEFORPREADJUSTEDVALUE",
          T."UNITTYPEFORSUBLINENUMBER",
           T."UNITTYPEFORVALUE",
         T."VALUE",
         CURRENT_DATE,
         error_msg1
         
    FROM ZSALESTRANSACTION AS T  
   
    WHERE  T.SALESTRANSACTIONSEQ = SALESTRANSEQ ;
        
        
        
        
        
       -- DELETE FROM HABIB.ZSALESTRANSACTION
       -- WHERE 
        --	"SALESTRANSACTIONSEQ" = SALESTRANSACTIONSEQ
          --  and "ORDERID" = p_order_id
         --   AND "EVENTTYPE" = p_event_type
         --   AND "LINENUMBER" = p_linenumber
          --  AND "SUBLINENUMBER" = p_sublinenumber;
    END;



	


o_check := 0;
    -- Assuming GET_NET_COMMISSION is a procedure that takes these parameters
    CALL HABIB.GET_NET_COMMISSION(
        LV_DEALER_CODE, LV_PRODUCT_ID, p_retailer_msisdn, 
        p_consumer_msisdn, p_franchise_id, p_date, p_comments, 
        p_order_id, p_event_type, p_linenumber, p_sublinenumber, result_table1 ,error_comm
    );
    
IF error_comm IS NOT NULL THEN
        SIGNAL SQL_ERROR_CODE 10000 SET MESSAGE_TEXT = error_comm;
    END IF;


    Select count(*) into zresult_table_count from :result_table1;
    
    if zresult_table_count > 0 then 
    o_check := 1;
    

    SELECT netcommission into netcommission1 from :result_table1 ;
    SELECT genericboolean2 into genericboolean_2 from :result_table1 ;

        -- The MERGE statement will be executed for each row processed by the cursor
        INSERT INTO HABIB.ZSALESTRANSACTION_CALC (SALESTRANSACTIONSEQ,ORDERID,EVENTTYPE,LINENUMBER,SUBLINENUMBER,GENERICATTRIBUTE22,GENERICATTRIBUTE23,GENERICATTRIBUTE24,GENERICATTRIBUTE25,GENERICBOOLEAN1,GENERICBOOLEAN2,GENERICATTRIBUTE27,GENERICATTRIBUTE28,GENERICATTRIBUTE29,GENERICATTRIBUTE30,GENERICATTRIBUTE31,
       	GENERICNUMBER1,GENERICNUMBER2,GENERICNUMBER3,GENERICNUMBER4,GENERICNUMBER5,UNITTYPEFORGENERICNUMBER1,UNITTYPEFORGENERICNUMBER2,UNITTYPEFORGENERICNUMBER3,UNITTYPEFORGENERICNUMBER4,UNITTYPEFORGENERICNUMBER5)
         
            SELECT
            SALESTRANSEQ,
             S.ORDERID,
             S.EVENTTYPE,
             S.LINENUMBER,
             S.SUBLINENUMBER, 
             S.genericattribute6, 
             S.genericattribute7,  
             S.genericattribute10,
             S.MDLTCELLSEQ, 
             CASE 
		     WHEN S.GENERICBOOLEAN1 = TRUE THEN 1 
		     WHEN S.GENERICBOOLEAN1 = FALSE THEN 0 
		     ELSE NULL 
			 END,
             CASE 
		     WHEN S.GENERICBOOLEAN2 = TRUE THEN 1 
		     WHEN S.GENERICBOOLEAN2 = FALSE THEN 0 
		     ELSE NULL 
		   	 END,     
             'CALCULATED',
               S.stw,
               S.gst,
               S.wht,
               S.aggt,
               S.value,
               S.gstresult,
               S.stwresult,
               S.whtresult,
               S.netcommission,
               'percent',
               'percent',
               'percent',
               'percent',
               'percent'
               
               FROM :result_table1 as S;

    	END IF;
    	
    	isError := FALSE;
    END;