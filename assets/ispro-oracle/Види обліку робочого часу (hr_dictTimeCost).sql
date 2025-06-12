-- Види обліку робочого часу (hr_dictTimeCost)
select
	'1' "ID"
	,'РбДн' "code"
	,'Години роботи, передбачені Правилами внутрішнього трудового розпорядку' "name"
	,'Р' "nameShort"
	,'WORK' "timeCostType"
	,'null' "orderClassID"
	,'0' "isClose"
	,'РбДн Години роботи, передбачені Правилами внутрішнього трудового розпорядку Р' "description"
	,'Робочий' "nameSmall"
	,'null' "dictTimePrintID"
FROM DUAL
union all
select
	'2' "ID"
	,'Вих' "code"
	,'Вихідний' "name"
	,'Вих' "nameShort"
	,'FREE' "timeCostType"
	,'null' "orderClassID"
	,'0' "isClose"
	,'Вих Вихідний Вих' "description"
	,'Вихідний' "nameSmall"
	,'null' "dictTimePrintID"
FROM DUAL