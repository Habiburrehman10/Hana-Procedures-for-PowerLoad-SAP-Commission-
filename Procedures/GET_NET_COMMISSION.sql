CREATE PROCEDURE HABIB.GET_NET_COMMISSION (
    IN p_retailerid NVARCHAR(50), 
    IN p_dim1 VARCHAR(127),
    IN p_retailer_msisdn NVARCHAR(50),
    IN p_consumer_msisdn NVARCHAR(50),
    IN p_franchise_id NVARCHAR(50),
    IN p_date NVARCHAR(50),
    IN p_comments NVARCHAR(50),
    IN p_orderid NVARCHAR(50),
    IN p_eventtype NVARCHAR(50),
    IN p_linenumber NVARCHAR(50),
    IN p_sublinenumber NVARCHAR(50),
    OUT result_table TABLE (
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
        LINENUMBER NVARCHAR(50),
        SUBLINENUMBER NVARCHAR(50),
        MDLTCELLSEQ NVARCHAR(127)
    ),
    OUT o_message NVARCHAR(255)
)
LANGUAGE SQLSCRIPT
AS
BEGIN
    DECLARE lv_retailerid NVARCHAR(50);
    DECLARE lv_effectivestartdate DATE;
    DECLARE lv_effectiveenddate DATE;
    DECLARE lv_islast SMALLINT;
    DECLARE lv_createdate DATE;
    DECLARE lv_genericboolean1 SMALLINT;
    DECLARE lv_genericboolean2 SMALLINT;
    DECLARE lv_genericattribute5 NVARCHAR(50);
    DECLARE lv_genericattribute6 NVARCHAR(200);  --M
    DECLARE lv_genericattribute7 NVARCHAR(200);   --M
	DECLARE lv_genericattribute10 NVARCHAR(200);   --M
    DECLARE lv_genericnumber1 DECIMAL(18,2);
    DECLARE lv_genericnumber2 DECIMAL(18,2);
    DECLARE lv_genericnumber3 DECIMAL(18,2);
    DECLARE lv_genericnumber4 DECIMAL(18,2);  --M
    DECLARE lv_value DECIMAL(18,2);
    DECLARE lv_DIM0 VARCHAR(127);
    DECLARE lv_MDLTCELLSEQ NVARCHAR(127);
    declare o_check smallint;
    
   
   
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        IF o_check = 0 THEN
            o_message := 'No data found in RETAILER Table for the given retailerid.';
        ELSEIF o_check = 1 THEN
            o_message := 'No data found in MDLT Table for the given dimensions.';
        ELSE
            SELECT ::SQL_ERROR_MESSAGE INTO o_message FROM DUMMY;
        END IF;
    END;
    
     o_check := 0;

	
    SELECT cg.retailerid, cg.effectivestartdate, cg.effectiveenddate, cg.islast, cg.createdate,
           cg.genericboolean1, cg.genericboolean2, cg.genericattribute5,cg.genericattribute6,
           cg.genericattribute7,cg.genericattribute10,cg.genericnumber1, cg.genericnumber2, cg.genericnumber3,cg.genericnumber4
    INTO lv_retailerid, lv_effectivestartdate, lv_effectiveenddate, lv_islast, lv_createdate,
         lv_genericboolean1, lv_genericboolean2, lv_genericattribute5,lv_genericattribute6,
         lv_genericattribute7,lv_genericattribute10,lv_genericnumber1, lv_genericnumber2, lv_genericnumber3,lv_genericnumber4
    FROM HABIB."ZRETAILER" AS cg 
    WHERE cg.retailerid = p_retailerid 
    ORDER BY cg.createdate DESC
    LIMIT 1;

   
	
	o_check := 1;
    -- Fetch the latest record based on franchiseid
    SELECT value, DIM0,MDLTCELLSEQ
    INTO lv_value, lv_DIM0,lv_MDLTCELLSEQ
    FROM HABIB."ZMDLT" 
    WHERE DIM0 = lv_genericattribute5
    AND DIM1 = :p_dim1
    AND EVENTTYPE = :p_eventtype 
    AND to_date(:p_date) BETWEEN to_date(effectivestartdate) AND to_date(effectiveenddate) --M
    ORDER BY effectivestartdate DESC
    LIMIT 1;
    
    
    -- Fetch the latest record based on city
    
    -- SELECT value, DIM2 ,MDLTCELLSEQ
    --INTO lv_value, lv_DIM0,lv_MDLTCELLSEQ
    --FROM HABIB."ZMDLT" 
    --WHERE DIM2 = lv_genericattribute6 --M
    --AND DIM1 = :p_dim1
	--AND EVENTTYPE = :p_eventtype
    --AND :p_date BETWEEN effectivestartdate AND effectiveenddate --M
    --ORDER BY effectivestartdate DESC
    --LIMIT 1;
    
    
     -- Fetch the latest record based on region
    
    -- SELECT value, DIM3 ,MDLTCELLSEQ
    --INTO lv_value, lv_DIM0,lv_MDLTCELLSEQ
    --FROM HABIB."ZMDLT" 
    --WHERE DIM3 = lv_genericattribute7 --M
    --AND DIM1 = :p_dim1
	--AND EVENTTYPE = :p_eventtype
    --AND :p_date BETWEEN effectivestartdate AND effectiveenddate --M
    --ORDER BY effectivestartdate DESC
    --LIMIT 1;
   

 
   o_check := 2;

    -- Populate the result_table with the calculated values
    result_table = 
    SELECT 
        lv_retailerid AS retailerid,
        lv_effectivestartdate AS effectivestartdate, 
        lv_effectiveenddate AS effectiveenddate, 
        CASE WHEN lv_islast = 1 THEN TRUE ELSE FALSE END AS islast, 
        lv_createdate AS createdate, 
        CASE WHEN lv_genericboolean1 = 1 THEN TRUE ELSE FALSE END AS genericboolean1,
        CASE WHEN lv_genericboolean2 = 1 THEN TRUE ELSE FALSE END AS genericboolean2,
        lv_genericattribute5 AS genericattribute5, 
        lv_genericattribute6 AS genericattribute6, 
        lv_genericattribute7 AS genericattribute7, 
        lv_genericattribute10 AS genericattribute10,
        lv_genericnumber4 AS aggt,  
        lv_genericnumber1 AS wht, 
        lv_genericnumber2 AS gst, 
        lv_genericnumber3 AS stw, 
        lv_value AS value,
        CASE 
            WHEN lv_genericboolean1 = 1 THEN 0 
            ELSE ((lv_genericnumber2/100) * lv_value)  
        END AS gstresult,
        CASE 
            WHEN lv_genericboolean1 = 1 THEN 0 
            ELSE ((lv_genericnumber3/100) * lv_value)
        END AS stwresult,
        ROUND(
            CASE 
                WHEN lv_genericboolean1 = 1 THEN 0 
                ELSE ((lv_value + (lv_value * (lv_genericnumber2/100) )) * (lv_genericnumber1/100)) 
            END, 2) AS whtresult, 
        ROUND(
            lv_value + 
            CASE 
                WHEN lv_genericboolean1 = 1 THEN 0 
                ELSE ((lv_genericnumber2/100) * lv_value) 
            END - 
            CASE 
                WHEN lv_genericboolean1 = 1 THEN 0 
                ELSE ((lv_genericnumber3/100) * lv_value) 
            END - 
            ROUND(
                CASE 
                    WHEN lv_genericboolean1 = 1 THEN 0 
                    ELSE ((lv_value + (lv_value * (lv_genericnumber2/100) )) * (lv_genericnumber1/100)) 
                END, 2), 3
        ) AS netcommission,
        p_orderid AS ORDERID,
        p_eventtype AS EVENTTYPE,
        p_linenumber AS LINENUMBER,
        p_sublinenumber AS SUBLINENUMBER,
        lv_MDLTCELLSEQ AS MDLTCELLSEQ
    FROM DUMMY;

END;