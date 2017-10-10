
/*  Take a look first
select *
from [dbo].[ind_data_staging]

*/
  
/*  Create unique id

*/

-- identify the tool -- How to best?
with tool_sub as
(
select
  submission,
  left(name_text,charindex(':',name_text)) as tool,
  count(*) as n,
  use_rank = DENSE_RANK() over (partition by submission order by count(*) desc)

from [dbo].[ind_data_staging]
group by
  submission,
  left(name_text, charindex(':',name_text))
)
select
  submission,
  tool = isnull(replace(tool, ':',''),'ERROR')
into #tool_sub
from tool_sub
Where
  use_rank = 1

-- add it back on to the original table
go

-- alter table [dbo].[ind_data_staging] add tool varchar(50)
go
update [ind_data_staging] set tool = b.tool
	from [dbo].[ind_data_staging] as i
	join #tool_sub as b on
	  b.submission = i.submission
	where
	  b.tool is not null


/*  IF WE NEED TO UPDATE THE HEADER INFO
-- pull out a list of the col info we need

select Distinct
  tool = isnull(replace(b.tool, ':',''),'ERROR'),
  col_id,
  name_text,
  name_text_alone = replace(name_text,b.tool,'')
from [dbo].[ind_data_staging] as a
left outer join #b as b on
  b.submission = a.submission and 
  b.use_rank = 1

*/

select *
from [ind_data_staging]

-- pull out a demographics view
Drop view if exists ind_demographics
go
create view ind_demographics as
select
  ap_id,
  row_id,
  a.tool,
  submission,
  client_id = max(case when new_name = 'client_id' then val else null end),
  gender = max(case when new_name = 'gender' then val else null end),
  income = max(case when new_name = 'income' then val else null end)
from [dbo].[ind_data_staging] as a
left outer join [dbo].[col_info_csv] as c on
  c.tool = a.tool and
  c.name_text = a.name_text
Group by
  ap_id,
  row_id,
  a.tool,
  submission

--
-- check row counts and other checks
--

select
  submission,
  agency,
  program,
  count(distinct client_id) as distinct_clients,
  count(*) as n,
  sum(cast(income as float)) as income
from ind_demographics as a
left outer join [dbo].[agency_program_id] as b on
  b.ap_id = a.ap_id
group by 
  submission,
  agency,
  program

