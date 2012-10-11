---------------------------------------------
-- Export file for user TSMS               --
-- Created by yanrui on 2011/2/28, 9:40:33 --
---------------------------------------------

spool tsms20110228fun.log

prompt
prompt Creating function CAL_ACCOUNTID_ORDERSUBTYPE
prompt ============================================
prompt
create or replace function tsms.cal_accountId_orderSubType(orderId integer,orderSubType integer)
  return integer is
  result integer;
  accountId integer:=0;
begin
    if orderSubType=10 or orderSubType=11  then
      select s.to_account_id into accountId from statement s
        where 1=1  and s.order_Id=orderId
		    and s.order_subtype=orderSubType
		    and rownum=1;
    end if;
    if orderSubType=20 or orderSubType=21 then
      select s.to_account_id into accountId from statement s
        where 1=1  and s.order_Id=orderId
		    and s.order_subtype=orderSubType
		    and rownum=1;
    end if;

    result :=accountId;
    return result;
end cal_accountId_orderSubType;
/

prompt
prompt Creating function CAL_NAME_ACCOUNTID
prompt ====================================
prompt
create or replace function tsms.cal_name_accountId(accountId long)
  return varchar2 is
  result varchar2(50);
  accountName varchar2(50):='';
begin
    select s.name into accountName  from account s
           where s.id =accountId
           and rownum=1;
    result :=accountName;
    return result;
end cal_name_accountId;
/

prompt
prompt Creating function CAL_ACCOUNTNAME_ORDERSUBTYPE
prompt ==============================================
prompt
create or replace function tsms.cal_accountName_orderSubType(orderId integer,orderSubType integer)
  return varchar2 is
  result varchar2(50);
  accountId integer;
  accountName varchar2(50):='';
begin
    if orderSubType=10 or orderSubType=11  then
      select s.to_account_id into accountId from statement s
        where 1=1  and s.order_Id=orderId
		    and s.order_subtype=orderSubType
		    and rownum=1;
    end if;
     if orderSubType=20 or orderSubType=21  then
      select s.to_account_id into accountId from statement s
        where 1=1  and s.order_Id=orderId
		    and s.order_subtype=orderSubType
		    and rownum=1;
    end if;
   select cal_name_accountId(accountId) into accountName  from dual;

    result :=accountName;
    return result;
end cal_accountName_orderSubType;
/

prompt
prompt Creating function CAL_DRAWAMOUNT_GROUPID
prompt ========================================
prompt
create or replace function tsms.cal_drawAmount_groupId(groupId integer,orderSubType integer)
  return number is
  result number(15,2);
  totalAmount number(15,2):=0;
begin
      select sum(s.total_amount) into totalAmount from statement s
             where 1=1  and s.order_Id=(select id from airticket_order where tran_type=2 and status=5 and group_id=groupId and rownum=1)
             and s.order_subtype=orderSubType
             and rownum=1;
      if totalAmount is null then
         totalAmount:=0;
      end if;

    result :=totalAmount;
    return result;
end cal_drawAmount_groupId;
/

prompt
prompt Creating function CAL_FLIGHTCARRIER_ORDERID
prompt ===========================================
prompt
create or replace function tsms.cal_flightcarrier_orderId(orderId integer) return varchar2 is
  myresult varchar2(100):='';
  resultlength integer:=0;
  temp varchar2(100):='';
  tempLength integer:=0;
begin
    for TempObj in (select p.flight_code from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.flight_code is not null then
        temp:=substr(TempObj.flight_code,0,2);
        myresult:=myresult||temp||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;
  return(myresult);
end cal_flightcarrier_orderId;
/

prompt
prompt Creating function CAL_FLIGHTCLASS_ORDERID
prompt =========================================
prompt
create or replace function tsms.cal_flightclass_orderId(orderId integer) return varchar2 is
  myresult varchar2(100):='';
  resultlength integer:=0;
begin
    for TempObj in (select p.flight_class from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.flight_class is not null then
       myresult:=myresult||TempObj.flight_class||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;
  return(myresult);
end cal_flightclass_orderId;
/

prompt
prompt Creating function CAL_FLIGHTCODE_ORDERID
prompt ========================================
prompt
create or replace function tsms.cal_flightcode_orderId(orderId integer) return varchar2 is
  myresult varchar2(1000):='';
  resultlength integer:=0;
begin
    for TempObj in (select p.flight_code from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.flight_code is not null then
       myresult:=myresult||TempObj.flight_code||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;

  return(myresult);
end cal_flightcode_orderId;
/

prompt
prompt Creating function CAL_FLIGHTEND_ORDERID
prompt =======================================
prompt
create or replace function tsms.cal_flightEnd_orderId(orderId integer) return varchar2 is
  myresult varchar2(100):='';
  --resultlength integer:=0;
begin

---返回单条 不能去指定排序的第一条
  --select p.end_point into myresult  from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId and rownum=1;     

--返回单条，可指定排序
 select end_point into myresult from (select p.id,p.end_point,ROW_NUMBER() over( order by p.id desc) m
         from flight p, airticket_order o where p.air_order_id = o.id and o.id = orderId )   where m<2;

--返回多航程的目的地
    /*    for TempObj in (select p.end_point  from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.end_point is not null then
       myresult:=myresult||TempObj.end_point||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;*/
  return(myresult);
end cal_flightEnd_orderId;
/

prompt
prompt Creating function CAL_FLIGHTSTART_ORDERID
prompt =========================================
prompt
create or replace function tsms.cal_flightStart_orderId(orderId integer) return varchar2 is
  myresult varchar2(100):='';
  --resultlength integer:=0;
begin
---返回单条 无法排序
 -- select p.start_point into myresult  from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId and rownum=1 order by p.id desc;     

--返回单条，可指定排序
 select start_point into myresult from (select p.id,p.start_point,ROW_NUMBER() over( order by p.id desc) m
         from flight p, airticket_order o where p.air_order_id = o.id and o.id = orderId )   where m<2;

--返回多航程的出发地
    /*for TempObj in (select p.start_point  from  flight p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempObj.start_point is not null then
       myresult:=myresult||TempObj.start_point||'/';
     end if;
    end loop;
   resultlength:=length(myresult);
   if resultlength>0 then
    myresult:=substr(myresult,0,resultlength-1);
   end if;*/
   
   
  return(myresult);
end cal_flightStart_orderId;
/

prompt
prompt Creating function CAL_INAMOUNT_GROUPID
prompt ======================================
prompt
create or replace function tsms.cal_inAmount_groupId(groupId integer,orderSubType integer)
  return number is
  result number(15,2);
  totalAmount number(15,2):=0;
begin
      select sum(s.total_amount) into totalAmount from statement s
             where 1=1  and s.order_Id=(select id from airticket_order where tran_type=1 and status=5 and group_id=groupId and rownum=1)
             and s.order_subtype=orderSubType
             and rownum=1;
      if totalAmount is null then
         totalAmount:=0;
      end if;

    result :=totalAmount;
    return result;
end cal_inAmount_groupId;
/

prompt
prompt Creating function CAL_MILLISECOND_TIME
prompt ======================================
prompt
create or replace function tsms.cal_millisecond_time(mytime varchar2)
  return integer is
  result integer;
  resulttime integer;
begin
    select
(to_date(mytime,'yyyy-mm-dd hh:mi:ss')-to_date('1970-1-1','yyyy-mm-dd'))
*24*60*60*1000 into resulttime
from dual;
    result :=resulttime;
    return result;
end cal_millisecond_time;
/

prompt
prompt Creating function CAL_NAME_PLATFORMID
prompt =====================================
prompt
create or replace function tsms.cal_name_platformId(platformId long)
  return varchar2 is
  result varchar2(50);
  platformName varchar2(50):='';
begin
    select s.name into platformName  from platform s
           where s.id =platformId
           and rownum=1;
    result :=platformName;
    return result;
end cal_name_platformId;
/

prompt
prompt Creating function CAL_NAME_USERNO
prompt =================================
prompt
create or replace function tsms.cal_name_userNo(userNo varchar2)
  return varchar2 is
  result varchar2(50);
  userName varchar2(50):='';
begin
    select s.user_name into userName  from sys_user s
           --where s.user_no like '%userNo%';
           where s.user_no =userNo
           and rownum=1;
    result :=userName;
    return result;
end cal_name_userNo;
/

prompt
prompt Creating function CAL_PASSCOUNT_ORDERID
prompt =======================================
prompt
create or replace function tsms.cal_passcount_orderId(orderId integer)
  return varchar2 is
  result varchar2(50);
  passengerCount integer:=1;
begin
    select count(p.id) into passengerCount from passenger p,airticket_order o
    where p.air_order_id=o.id
    and o.id=orderId;
    result :=passengerCount;
    return result;
end cal_passcount_orderId;
/

prompt
prompt Creating function CAL_PASSNAME_ORDERID
prompt ======================================
prompt
create or replace function tsms.cal_passname_orderId(orderId integer) return varchar2 is
  PassengerName varchar2(1000):='';
  PassengerLength integer:=0;
begin
    for TempName in (select p.name from  passenger p,airticket_order o where p.air_order_id=o.id and o.id=orderId) loop
     if TempName.name is not null then
       PassengerName:=PassengerName||TempName.name||'/';
     end if;
    end loop;
   PassengerLength:=length(PassengerName);
   if PassengerLength>0 then
      --PassengerName:=PassengerName;
    PassengerName:=substr(PassengerName,0,PassengerLength-1);
   end if;

  return(PassengerName);
end cal_passname_orderId;
/

prompt
prompt Creating function CAL_SAMOUNT_ORDERID
prompt =====================================
prompt
create or replace function tsms.cal_SAmount_orderId(orderId integer,orderSubType integer)
  return number is
  result number(15,2);
  totalAmount number(15,2):=0;
begin
      select sum(s.total_amount) into totalAmount from statement s
             where 1=1  and s.order_Id=orderId
             and s.order_subtype=orderSubType
             and rownum=1;
      if totalAmount is null then
         totalAmount:=0;
      end if;

    result :=totalAmount;
    return result;
end cal_SAmount_orderId;
/

prompt
prompt Creating function CAL_SAMOUNT_ORDERSUBTYPE
prompt ==========================================
prompt
create or replace function tsms.cal_sAmount_orderSubType(orderId integer,orderSubType integer)
  return number is
  result number(15,2);
  totalAmount number(15,2):=0;
begin
      select sum(s.total_amount) into totalAmount from statement s
             where 1=1  and s.order_Id=orderId
             and s.order_subtype=orderSubType
             and rownum=1;
      if totalAmount is null then
         totalAmount:=0;
      end if;

    result :=totalAmount;
    return result;
end cal_sAmount_orderSubType;
/

prompt
prompt Creating function CAL_TOTALTICKETPRICE_ORDERID
prompt ==============================================
prompt
create or replace function tsms.cal_totalTicketPrice_orderId(orderId integer,ticketPrice number)
  return number is
  result number(15,2);
  passcount integer:=1;
  totalTicketPrice number(15,2):=0;
begin
    select cal_passCount_orderId(orderId) into passcount  from dual;
    totalTicketPrice=ticketPrice*passcount;

    result :=totalTicketPrice;
    return result;
end cal_totalTicketPrice_orderId;
/

prompt
prompt Creating function MUL
prompt =====================
prompt
create or replace function tsms.mul
      return   varchar2
  is
      l_mul   number;
  begin
              for   x   in   (   select   value   from   mytab   )   loop
                      l_mul   :=   l_mul   *   x.value;
              end   loop;
              return   l_mul;
  end;
/

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
prompt Creating procedure UPDATE_MILLSSECOND
prompt =====================================
prompt
create or replace procedure tsms.update_millssecond(orderId in integer) is
 orderdate timestamp:=null;
 orderdateStr varchar2(50):=null;
 millsecond integer:=0;
begin
if orderId is not null then
   select o.entry_time into orderdate from airticket_order o where o.id=orderId;

  if orderdate is not null then
      select to_char(orderdate,'yyyy-mm-dd hh:mi:ss') into orderdateStr from dual;

      if orderdateStr is not null then
         select cal_millisecond_time(orderdateStr) into millsecond  from dual;

         if millsecond>0 then
                update airticket_order set LAST_DATE_SECOND=millsecond where id=orderId;
         end if;
      end if;
  end if;
 end if;
end update_millssecond;
/

prompt
prompt Creating procedure UPDATE_MILLSSECONDLOOP
prompt =========================================
prompt
create or replace procedure tsms.update_millssecondLoop(aa in integer) is
begin
   for TempObj in (select id from  airticket_order where 1=1  and ticket_type=1 /*and id=799*/ and entry_time is not null and last_date_second is null) loop
     if TempObj.id is not null then
              begin
                         update_millssecond(TempObj.id);
              end;
     end if;
    end loop;
end update_millssecondLoop;
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
