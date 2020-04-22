-- Довідник Види робочого часу (hr_dictTimeCost)
/*BEGIN-OF-HEAD*/
select 
	'ID' ID	
	,'code' code	
	,'name' name	
	,'timeCostType' timeCostType
union all	
/*END-OF-HEAD*/
select 
	'1' ID	
	,'Вих' code	
	,'Вихідний' name	
	,'FREE' timeCostType
union all	
select 
	'2' ID	
	,'РбДн' code	
	,'Робочий' name	
	,'WORK' timeCostType
