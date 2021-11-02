-- Довідник Види оплати
select base.uuid_bigint(id::text) "ID",
	coalesce(code, left(name, 100)) code,
	name,
	case when code is not null then concat(code, ' ', name) else name end description,
	case when code is not null then concat(name, ' [', code, ']') else name end caption,
	coalesce(comment, ''),
	'2010-01-01' "dateFrom",
	'9999-12-01' "dateTo"
from salary.ctlg_salary_article a1
where deleted_at is null
and (
	exists ( select null from salary.reg_salary_income i1 where i1.income_article_id = a1.id)
	-- or
	-- exists ( select null from salary.reg_salary_deduct d1 where d1.deduct_article_id = a1.id)
	-- or 
	-- exists ( select null from salary.reg_payment p1 where p1.payment_article_id = a1.id)
);
