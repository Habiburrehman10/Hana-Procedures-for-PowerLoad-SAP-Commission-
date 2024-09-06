CREATE PROCEDURE HABIB.pro_RH()
LANGUAGE SQLSCRIPT
AS
BEGIN


   DECLARE CURSOR cur FOR
   SELECT * 
FROM (
    SELECT 
        T."Biz_Part_Code",
        T."Biz_Partner_Postal_Address",
        T."Biz_Part_Cat_Name",
        T."City_Name",
        T."Nic",
        T."Contact_Person",
        T."Contact_Number",
        T."Email_Address",
        T."End_Date",
        T."Msisdn",
        T."Latitude",
        T."Longitude",
        T."Ntn_Number",
        T."Biz_Part_Code2",
        T."Region_Name",
        T."Biz_Part_Code3",
        T."Creation_Date",
        T."Start_Date",
        T."Status_Name",
        T."PO_FBR_STATUS_COMBINATION",
        T."Tax_Exempted_Flag",
        T."Update_Date",
        T."Biz_Partner_Name",
        T."Zone_Name",
        COALESCE(NULLIF(T."RATE_WHT", ''), '0') AS "RATE_WHT",
        COALESCE(NULLIF(T."GST_RATE", ''), '0') AS "GST_RATE",
        COALESCE(NULLIF(T."GST_RATE_WHT", ''), '0') AS "GST_RATE_WHT",
        COALESCE(NULLIF(T."AGGRATE_RATE", ''), '0') AS "AGGRATE_RATE",
        COALESCE(NULLIF(T."Biz_Part_Type_Id", ''), '0') AS "Biz_Part_Type_Id",
        COALESCE(NULLIF(T."Biz_Part_Class_Id", ''), '0') AS "Biz_Part_Class_Id",
        T."Biz_Partner_Desc",
        ROW_NUMBER() OVER (PARTITION BY T."Biz_Part_Code" ORDER BY T."Biz_Part_Code") AS RowNum
    FROM "HABIB"."RETAILER_HIERARCHY" T
) AS subquery
WHERE RowNum = 1;

	
	TRUNCATE TABLE HABIB.ZRETAILER;
	
	OPEN cur;

    FOR T AS cur DO

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
    
     
     DECLARE v_error_message NVARCHAR(5000);
       DECLARE error_msg1 NVARCHAR(5000);
        
         SELECT ::SQL_ERROR_MESSAGE INTO v_error_message FROM DUMMY;
         
         error_msg1 = v_error_message;
    
    
       INSERT INTO HABIB.ZRETAILER_ERROR(
            "TENANTID", "RETAILERID", "GENERICATTRIBUTE9",
            "GENERICATTRIBUTE13", "GENERICATTRIBUTE6", "GENERICATTRIBUTE4", "GENERICATTRIBUTE8",
            "GENERICATTRIBUTE16", "GENERICATTRIBUTE12", "EFFECTIVEENDDATE", "GENERICDATE3", "GENERICATTRIBUTE2",
            "GENERICATTRIBUTE14", "GENERICATTRIBUTE15", "GENERICATTRIBUTE1", "GENERICATTRIBUTE5",
            "GENERICATTRIBUTE7", "GENERICATTRIBUTE10", "EFFECTIVESTARTDATE", "GENERICDATE1", "GENERICBOOLEAN2",
            "GENERICATTRIBUTE11", "GENERICBOOLEAN1", "GENERICDATE2", "GENERICATTRIBUTE3", 
             "GENERICNUMBER1", "GENERICNUMBER2", "GENERICNUMBER3", "GENERICNUMBER4",
            "GENERICNUMBER5", "GENERICNUMBER6", "UNITTYPEFORGENERICNUMBER1", "UNITTYPEFORGENERICNUMBER2",
            "UNITTYPEFORGENERICNUMBER3", "UNITTYPEFORGENERICNUMBER4", "UNITTYPEFORGENERICNUMBER5",
            "UNITTYPEFORGENERICNUMBER6","ISLAST","CREATEDATE","DESCRIPTION","NAME","ERROR"
        )
        values(  
        'G18E',
        T."Biz_Part_Code",
        T."Biz_Partner_Postal_Address",
        T."Biz_Part_Cat_Name",
        T."City_Name",
        T."Nic",
        T."Contact_Person",
        T."Contact_Number",
        T."Email_Address",
        '2200-01-01 00:00:00.000000000',
        T."End_Date",
        T."Msisdn",
        T."Latitude",
        T."Longitude",
        T."Ntn_Number",
        T."Biz_Part_Code2",
        T."Region_Name",
        T."Biz_Part_Code3",
        T."Creation_Date",
        T."Start_Date",
        CASE 
            WHEN T."Status_Name" = 'Active' THEN 1
            ELSE 0 
            END ,
        T."PO_FBR_STATUS_COMBINATION",
        CASE
        WHEN T."Tax_Exempted_Flag" = 'YES' THEN 1
        WHEN T."Tax_Exempted_Flag" = 'Yes' THEN 1
        ELSE 0 END,
        T."Update_Date",
        T."Zone_Name",
        T."RATE_WHT" , -- Handle non-numeric and NULL values
        T."GST_RATE",
        T."GST_RATE_WHT",
        T."AGGRATE_RATE" ,
        T."Biz_Part_Type_Id" , -- Handle non-numeric and NULL values
        T."Biz_Part_Class_Id",
        'percent',
        'percent',
        'percent',
        'percent',
        'percent',
        'percent',
        1,
        CURRENT_DATE,
        T."Biz_Partner_Desc",
        T."Biz_Partner_Name",
        error_msg1 );
        
        
    END;

    
        

        INSERT INTO HABIB.ZRETAILER(
            "TENANTID", "RETAILERID", "GENERICATTRIBUTE9",
            "GENERICATTRIBUTE13", "GENERICATTRIBUTE6", "GENERICATTRIBUTE4", "GENERICATTRIBUTE8",
            "GENERICATTRIBUTE16", "GENERICATTRIBUTE12", "EFFECTIVEENDDATE", "GENERICDATE3", "GENERICATTRIBUTE2",
            "GENERICATTRIBUTE14", "GENERICATTRIBUTE15", "GENERICATTRIBUTE1", "GENERICATTRIBUTE5",
            "GENERICATTRIBUTE7", "GENERICATTRIBUTE10", "EFFECTIVESTARTDATE", "GENERICDATE1", "GENERICBOOLEAN2",
            "GENERICATTRIBUTE11", "GENERICBOOLEAN1", "GENERICDATE2", "GENERICATTRIBUTE3",
             "GENERICNUMBER1", "GENERICNUMBER2", "GENERICNUMBER3", "GENERICNUMBER4",
            "GENERICNUMBER5", "GENERICNUMBER6", "UNITTYPEFORGENERICNUMBER1", "UNITTYPEFORGENERICNUMBER2",
            "UNITTYPEFORGENERICNUMBER3", "UNITTYPEFORGENERICNUMBER4", "UNITTYPEFORGENERICNUMBER5",
            "UNITTYPEFORGENERICNUMBER6","ISLAST","CREATEDATE","DESCRIPTION","NAME"
        )
        values(  
        'G18E',
            T."Biz_Part_Code",
            T."Biz_Partner_Postal_Address",
            T."Biz_Part_Cat_Name",
            T."City_Name",
            T."Nic",
            T."Contact_Person",
            T."Contact_Number",
            T."Email_Address",
            TO_TIMESTAMP('2200-01-01 00:00:00.000000000'),
            TO_TIMESTAMP(T."End_Date",'DD/MM/YYYY HH24:MI'),
            T."Msisdn",
            T."Latitude",
            T."Longitude",
            T."Ntn_Number",
            T."Biz_Part_Code2",
            T."Region_Name",
            T."Biz_Part_Code3",
            TO_TIMESTAMP(T."Creation_Date", 'DD/MM/YYYY HH24:MI'),
            TO_TIMESTAMP(T."Start_Date", 'DD/MM/YYYY HH24:MI'),
            CASE 
            WHEN T."Status_Name" = 'Active' THEN 1
            ELSE 0 
            END ,
            T."PO_FBR_STATUS_COMBINATION",
            CASE
     	    WHEN T."Tax_Exempted_Flag" = 'YES' THEN 1
    	    WHEN T."Tax_Exempted_Flag" = 'Yes' THEN 1
       		ELSE 0 END,
            TO_TIMESTAMP(T."Update_Date", 'DD/MM/YYYY HH24:MI'),
            T."Zone_Name",
            COALESCE(CAST(T."RATE_WHT" AS DECIMAL(25,10)), 0),
            COALESCE(CAST(T."GST_RATE" AS DECIMAL(25,10)), 0),
            COALESCE(CAST(T."GST_RATE_WHT" AS DECIMAL(25,10)), 0),
            COALESCE(CAST(T."AGGRATE_RATE" AS DECIMAL(25,10)), 0),
            COALESCE(CAST(T."Biz_Part_Type_Id" AS DECIMAL(25,10)), 0),
            COALESCE(CAST(T."Biz_Part_Class_Id" AS DECIMAL(25,10)), 0),
            'percent',
            'percent',
            'percent',
            'percent',
            'percent',
            'percent',
            1,
            CURRENT_DATE,
            T."Biz_Partner_Desc",
            T."Biz_Partner_Name");
      
       
  END FOR;

  CLOSE cur;
  drop table "HABIB"."RETAILER_HIERARCHY";
    
 
  END;