-- òàáåëüí³ 
declare @orgCode varchar(16) = ''/*orgCode*/ -- 'ªÄÐÏÎÓ', '' - óñ³ îðãàí³çàö³¿
declare @orgID bigint = (case when @orgCode = '' then null else coalesce((select ID from HR_FIRM where OKPO = @orgCode), -1) end)

select people.Num_Tab as ID ,
people.Auto_Card as employeeID,
people.Num_Tab as tabNum,
case when INN is not null then INN  else ( case when Passp_ser is null then ' ' else Passp_ser end )+ Passp_num  end  taxCode, 
--CONVERT(nvarchar,min(PR_CURRENT.date_trans),104) as dateFrom
cast(cast(min(PR_CURRENT.date_trans) as date) as varchar)  as dateFrom
from Appointments
join PR_CURRENT on Appointments.Code_Appoint=PR_CURRENT.Code_Appoint
Join people on PR_CURRENT.pId = people.pId
join card on PR_CURRENT.Auto_Card = card.Auto_Card
where PR_CURRENT.Flag_last = '*'  
and Date_depart > =  GETDATE()  
and people.out_date = '1900-01-01 00:00:00.000'
and (@orgID is null or @orgID = PR_CURRENT.id_Firm)
group by people.Num_Tab, pr_current.id_Firm, people.Auto_Card, INN, Passp_ser, Passp_num