----------------------------------------------
-- Export file for user TSMS                --
-- Created by yanrui on 2011/1/27, 16:01:54 --
----------------------------------------------

spool tsms20110127´æ´¢¹ý³Ì.log

prompt
prompt Creating procedure CREATE_AIRTICKET_ORDER_REPORT
prompt ================================================
prompt
create or replace procedure tsms.create_airticket_order_report(orderId integer) is

begin
  --delete from airticket_order_report o /*where o.order_id=orderId*/;
  
  insert into airticket_order_report
    (
        ID,
        ORDER_ID,
       group_id,
       sub_group_mark_no,
        order_no,       
        PLATFORM_ID,
        PLATFORM_NAME,
        REBATE,
        SUB_PNR,
        DRAW_PNR,
        PASSENGER_NAME,
        PASSENGER_COUNT,
        START_POINT,
        END_POINT,
        CARRIER,
        FLIGHT_CODE,
        FLIGHT_CLASS,
        TICKET_PRICE,
        ENTRY_OPERATOR_NAME,
        PAY_OPERATOR_NAME,
        IN_ACCOUNT_NAME,
        OUT_ACCOUNT_NAME,
        IN_AMOUNT,
        OUT_AMOUNT,
        STATUS,
        ticket_type,
        tran_type,
        business_type,
        memo,
        entry_time  
)
   select
    SEQ_airticketorderreport.Nextval,
     o.id,
     o.group_id,
     o.sub_group_mark_no,
     o.order_no,
     o.platform_id,
     cal_name_platformid(o.platform_id),
     o.rebate,
     o.sub_pnr,
     o.draw_pnr,
     cal_passname_orderid(o.id),
     cal_passcount_orderId(o.id),
     cal_flightstart_orderId(o.id),
     cal_flightend_orderId(o.id),
     cal_flightcarrier_orderId(o.id),
     cal_flightcode_orderid(o.id),
     cal_flightclass_orderid(o.id),
     o.ticket_price,
     cal_name_userNo(o.entry_operator),
     cal_name_userNo(o.pay_operator),
     cal_accountName_ordersubtype(o.id,10),
     cal_accountName_ordersubtype(o.id,20),
     cal_sAmount_orderSubType(o.id,10),
     cal_sAmount_orderSubType(o.id,20),
     o.status,
     o.ticket_type,
     o.tran_type,
     o.business_type,
     o.memo,
     o.entry_time
     from airticket_order o     
     where 1=1
     and o.status not in(88)
   --and o.id=orderId;
    and  o.entry_Time  between to_date('2011-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
    and to_date('2011-01-01 12:59:59','yyyy-mm-dd hh24:mi:ss');
    
    update airticket_order_report set TOTAL_TICKET_PRICE=(TICKET_PRICE * PASSENGER_COUNT) where 1=1 ;
    commit;
end create_airticket_order_report;
/

prompt
prompt Creating procedure UPDATE_OLDSTATEMENTAMOUNT
prompt ============================================
prompt
create or replace procedure tsms.update_oldstatementAmount(orderId in integer) is

  groupId     integer := 0;
  oldamount  number(15,2) := 0;
  statementSubType  integer:=10;
  businessType  integer:=1;
begin

  select group_id into groupId from airticket_order where id = orderId;
  select business_type into businessType from airticket_order where id = orderId;


  if groupId is not null then
     if businessType is not null then
        if businessType=1 then
           select cal_inamount_groupid(groupId,10) into oldamount from dual;
        end if;
         if businessType=2 then
           select cal_drawamount_groupid(groupId,20) into oldamount from dual;
        end if;

         if oldamount is not null then
         select id into groupId from airticket_order where id=orderId;
            update airticket_order  set old_statement_amount = oldamount where id = orderId;
         end if;

      end if;

  end if;

end update_oldstatementAmount;
/

prompt
prompt Creating procedure UPDATE_OLDSTATEMENTAMOUNTLOOP
prompt ================================================
prompt
create or replace procedure tsms.update_oldStatementAmountLoop(aa integer) is
businessType  integer:=0;
begin
   for TempObj in (select o.id from  airticket_order o where 1=1 and o.tran_type in(3,4,5) and o.status not in(88)) loop
     if TempObj.id is not null then
        if businessType is not null then
          if businessType=1 then
            begin
                      update_oldstatementAmount(TempObj.id);
             end;
            end if;
            if businessType=2 then
             begin
                      update_oldstatementAmount(TempObj.id);
              end;
            end if;
        end if;
     end if;
    end loop;
end update_oldStatementAmountLoop;
/

prompt
prompt Creating procedure UPDATE_REFERENCE_ID
prompt ======================================
prompt
create or replace procedure tsms.update_reference_id(orderId in integer) is
  orderCount1    integer:=0;
  orderCount2    integer:=0;
  groupId     integer := 0;
  businessType integer:=0;
  referenceId integer := 0;
begin
if orderId is not null then
   select count(*) into orderCount1 from airticket_order o where o.id=orderId and tran_type in (3, 4, 5)  and group_id is not null;
 
  if orderCount1>0 then 
      select group_id into groupId  from airticket_order where id = orderId and tran_type in (3, 4, 5)  and group_id is not null;
      select business_type into businessType  from airticket_order where id = orderId and tran_type in (3, 4, 5)  and group_id is not null;

    if groupId is not null then
       if businessType=1 then 
        select count(*) into orderCount2 from airticket_order where tran_type = 1 and group_id = groupId;        
        if orderCount2>0 then
        select id  into referenceId from airticket_order where tran_type = 1 and status=5 and group_id = groupId and rownum=1;        
        if referenceId is not null then
          update airticket_order set reference_id = referenceId where id = orderId;
        end if;      
     end if;
     end if;
      if businessType=2 then 
        select count(*) into orderCount2 from airticket_order where tran_type = 2 and group_id = groupId;        
        if orderCount2>0 then
        select id  into referenceId from airticket_order where tran_type = 2 and status=5 and group_id = groupId and rownum=1;        
        if referenceId is not null then
          update airticket_order set reference_id = referenceId where id = orderId;
        end if;      
     end if;
     end if;
   
 end if;
 
 end if;
 end if;

end update_reference_id;
/

prompt
prompt Creating procedure UPDATE_REFERENCELOOP
prompt =======================================
prompt
create or replace procedure tsms.update_referenceLoop(aa in integer) is

begin
   for TempObj in (select id from  airticket_order where 1=1  and ticket_type=1 and group_id is not null and status not in(88)) loop
     if TempObj.id is not null then
              begin
                         update_reference_id(TempObj.id);
              end;
     end if;
    end loop;
end update_referenceLoop;
/

prompt
prompt Creating procedure UPDATE_STATEMENTAMOUNT
prompt =========================================
prompt
create or replace procedure tsms.update_statementAmount(orderId in integer) is

  businessType  integer := 0;
  tranType integer:=0;
  inAmount  number(15,2) := 0;
  outAmount  number(15,2) := 0;
  statementAmountStr varchar2(30):='';
begin

  select business_type into businessType from airticket_order where id = orderId;
  select tran_type into tranType from airticket_order where id = orderId;

     if businessType is not null and tranType is not null then
        if businessType=1 and tranType=1  then
           select cal_samount_orderid(orderId,10) into inAmount from dual;
          -- select cal_samount_orderid(orderId,21) into outAmount from dual;
          if inAmount is not null then
                statementAmountStr:=inAmount;
            end if;
        end if;
        if businessType=2 and tranType=2  then
          -- select cal_samount_orderid(orderId,11) into inAmount from dual;
           select cal_samount_orderid(orderId,20) into outAmount from dual;
           if outAmount is not null and outAmount>0 then
           statementAmountStr:=outAmount;
        end if;
        end if;
        if businessType=1 and tranType=3  then
           select cal_samount_orderid(orderId,21) into outAmount from dual;
           if outAmount is not null  then
              statementAmountStr:=outAmount;
           end if;
        end if;
        if businessType=2 and tranType=3  then
           select cal_samount_orderid(orderId,11) into inAmount from dual;
           if inAmount is not null then
                statementAmountStr:=inAmount;
            end if;
        end if;
        if businessType=1 and tranType=4  then
           select cal_samount_orderid(orderId,21) into outAmount from dual;
           if outAmount is not null and outAmount>0 then
           statementAmountStr:=outAmount;
        end if;
        end if;
        if businessType=2 and tranType=4  then
           select cal_samount_orderid(orderId,11) into inAmount from dual;
           if inAmount is not null then
                statementAmountStr:=inAmount;
            end if;
        end if;
        if businessType=1 and tranType=5  then
           select cal_samount_orderid(orderId,21) into outAmount from dual;
           if outAmount is not null and outAmount>0 then
              statementAmountStr:=outAmount;
           end if;
        end if;
        if businessType=2 and tranType=5 then
           select cal_samount_orderid(orderId,11) into inAmount from dual;
            if inAmount is not null then
                statementAmountStr:=inAmount;
            end if;
        end if;

        if statementAmountStr is  null then
           statementAmountStr:=0;
        end if;

        if statementAmountStr is not null then
           update airticket_order set statement_Amount = statementAmountStr where id = orderId;
        end if;

      end if;
end update_statementAmount;
/

prompt
prompt Creating procedure UPDATE_STATEMENTAMOUNTLOOP
prompt =============================================
prompt
create or replace procedure tsms.update_statementAmountLoop(aa integer) is

begin
   for TempObj in (select o.id from  airticket_order o where 1=1 and o.status not in(88)) loop
     if TempObj.id is not null then
              begin
                         update_statementAmount(TempObj.id);
              end;
     end if;
    end loop;
end update_statementAmountLoop;
/

prompt
prompt Creating procedure UPDATE_STATEMENTAMOUNTLOOPTEMP
prompt =================================================
prompt
create or replace procedure tsms.update_statementAmountLoopTemp(aa integer) is

begin
   for TempObj in (select o.id from  airticket_order o where 1=1 and o.status not in(88) and o.statement_amount<1) loop
     if TempObj.id is not null then
              begin
                         update_statementAmount(TempObj.id);
              end;
     end if;
    end loop;
end update_statementAmountLoopTemp;
/


spool off
