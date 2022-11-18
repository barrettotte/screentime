-- get today's total app usage
with app_usage as (
  select datetime(ZOBJECT.ZCREATIONDATE + 978307200, 'UNIXEPOCH', 'LOCALTIME') as entry_creation, 
    (ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE) as usage, ZOBJECT.ZVALUESTRING as app
  from ZOBJECT
  where ZSTREAMNAME is "/app/usage"
)
select app, time(sum(usage), 'unixepoch') as total_usage
from app_usage
where date(entry_creation)=date('now')
group by app
order by sum(usage) desc
limit 10;

-- get today's total usage
with app_usage as (
  select datetime(ZOBJECT.ZCREATIONDATE + 978307200, 'UNIXEPOCH', 'LOCALTIME') as entry_creation, 
    (ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE) as usage
  from ZOBJECT
  where ZSTREAMNAME is "/app/usage"
)
select time(sum(usage), 'unixepoch') as total_usage
from app_usage
where date(entry_creation)=date('now');
