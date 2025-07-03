-- Довідник Види робочого часу (hr_dictTimeCost)
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
