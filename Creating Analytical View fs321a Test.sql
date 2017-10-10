Select *
from [dbo].[client_level_data_from_ctk_staging]

-- need to fix the tool to start out
update [dbo].[client_level_data_from_ctk_staging] set tool = 'fs321a' where submission = '_Analysis__FS321a__2024.csv'
update [dbo].[client_level_data_from_ctk_staging] set tool = 'hsg221' where submission = '_Analysis__HSG221__955.csv'

--  

-- we need to bring over the client_id
-- WE can do that in a later step
/*
Drop table if exists #a
select
  submission,
  ap_id,
  row_id,
  client_id = [value]
into #a
from [dbo].[client_level_data_from_ctk_staging]
where
  variable like 'client%id'
-- might be able to just add that to the update statement

alter table [dbo].[client_level_data_from_ctk_staging] add client_id varchar(255)


update [dbo].[client_level_data_from_ctk_staging] set client_id = z.client_id
from [dbo].[client_level_data_from_ctk_staging] as a
Left join #a as z on
  z.ap_id = a.ap_id and
  z.row_id = a.row_id and
  z.submission = a.submission

*/

/*  RBA Measures
	6. # of participants served
	23. % of participants placed in employment
	24. % of participants maintaining employment
*/

drop view if exists fs321a_test
Go
create view fs321a_test
AS
select 
  ap_id,
  row_id,
  submission,
  race =  max(case when variable like 'Client Race' then value else null end),
  client_id = max(case when variable like 'client%id' then value else null end),
  funding_year = max(case when variable = 'funding year' then value else null end),
  a_job = case 
	when max(case when variable = 'Acquired a Job?' then value else null end) = 'N' then 'N' 
	when  max(case when variable = 'Acquired a Job?' then value else null end) is null then null 
	else 'Y' end,
  ret3 = max(case when variable = 'Retention @ 3 months' then value else null end)
from [dbo].[client_level_data_from_ctk_staging] 
Where
  tool = 'fs321a'
group by   
  ap_id,
  row_id,
  submission
having 
  max(case when variable = 'funding year' then value else null end) < 2017
