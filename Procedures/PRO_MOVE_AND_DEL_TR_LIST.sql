CREATE PROCEDURE "HABIB".pro_MOVE_and_DEL_TR_LIST(
IN salestransaction BIGINT
    )
LANGUAGE SQLSCRIPT
AS
BEGIN

         INSERT INTO ZSALESTRANSACTION_LIST (
            "BUSINESSUNITNAME", "CHANNEL", "COMMENTS", "COMPENSATIONDATE", "EVENTTYPE", "GENERICATTRIBUTE1", 
              "GENERICATTRIBUTE12", "GENERICATTRIBUTE2",  "GENERICATTRIBUTE27", "GENERICATTRIBUTE28", 
            "GENERICATTRIBUTE29", "GENERICATTRIBUTE3", "GENERICATTRIBUTE30","GENERICATTRIBUTE6",
            "GENERICNUMBER1", "GENERICNUMBER2", "GENERICNUMBER3", "GENERICNUMBER4", "GENERICNUMBER5",  "ISRUNNABLE", "LINENUMBER", "MODIFICATIONDATE", "ORDERID", "ORIGINTYPEID", "PREADJUSTEDVALUE", 
             "PRODUCTID",  "SALESTRANSACTIONSEQ", "SUBLINENUMBER", "TENANTID", 
             "UNITTYPEFORLINENUMBER", 
            "UNITTYPEFORPREADJUSTEDVALUE", "UNITTYPEFORSUBLINENUMBER", "UNITTYPEFORVALUE", "VALUE","UNITTYPEFORGENERICNUMBER1","UNITTYPEFORGENERICNUMBER2","UNITTYPEFORGENERICNUMBER3","UNITTYPEFORGENERICNUMBER4","UNITTYPEFORGENERICNUMBER5",
            "GENERICATTRIBUTE22","GENERICATTRIBUTE23","GENERICATTRIBUTE24","GENERICATTRIBUTE25","GENERICATTRIBUTE31","GENERICBOOLEAN1","GENERICBOOLEAN2"
        )
       select
            zt.BUSINESSUNITNAME,
    zt.CHANNEL,
    zt.COMMENTS,
    zt.COMPENSATIONDATE, 
            zters.eventtype,
           zt.GENERICATTRIBUTE1, 
    zt.GENERICATTRIBUTE12,
    zt.GENERICATTRIBUTE2,
            'MOVED', 
            ztcalc.genericattribute28,
    ztcalc.genericattribute29,
    zt.GENERICATTRIBUTE3,
    ztcalc.genericattribute30,
            zters.genericattribute6,
            ztcalc.genericnumber1,
    ztcalc.genericnumber2,
    ztcalc.genericnumber3,
    ztcalc.genericnumber4,
    ztcalc.genericnumber5, 
            zt.ISRUNNABLE, 
            zters.linenumber, 
           zt.MODIFICATIONDATE,
             zters.orderid, 
           zt.ORIGINTYPEID, 
    zt.PREADJUSTEDVALUE, 
    zt.PRODUCTID, 
            zters.salestransactionseq, 
           zters.sublinenumber,
            zt.TENANTID, 
    zt.UNITTYPEFORLINENUMBER,
    zt.UNITTYPEFORPREADJUSTEDVALUE,
    zt.UNITTYPEFORSUBLINENUMBER, 
    zt.UNITTYPEFORVALUE,
    zt.VALUE,
           ztcalc.unittypeforgenericnumber1,
    ztcalc.unittypeforgenericnumber2,
    ztcalc.unittypeforgenericnumber3,
    ztcalc.unittypeforgenericnumber4,
    ztcalc.unittypeforgenericnumber5,
    ztcalc.genericattribute22,
    ztcalc.genericattribute23,
    ztcalc.genericattribute24,
    ztcalc.genericattribute25,
    ztcalc.genericattribute31,
    ztcalc.genericboolean1,
    ztcalc.genericboolean2
    
FROM 
    zsalestransaction_ers zters
JOIN 
    zsalestransaction zt ON zters.salestransactionseq = zt.salestransactionseq
JOIN 
    zsalestransaction_calc ztcalc ON zters.salestransactionseq = ztcalc.salestransactionseq
WHERE 
    zters.genericattribute27 = 'SERS' and zters.salestransactionseq = salestransaction;

            
      
   
    
     

END;