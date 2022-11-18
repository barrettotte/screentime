/*
  https://www.mac4n6.com/blog/2018/8/5/knowledge-is-power-using-the-knowledgecdb-database-on-macos-and-ios-to-determine-precise-user-and-application-usage
  find / -name 'knowledgeC*' 2>&1 | grep -v "Operation not permitted"
  ~/Library/Application\ Support/Knowledge/
  /System/Volumes/Data/Users/$USER/Library/Application Support/Knowledge/knowledgeC.db
*/

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
