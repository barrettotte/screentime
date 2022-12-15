-- Explore knowledge database

/*
# Find knowledge sqlite database

find / -name 'knowledgeC*' 2>&1 | grep -v "Operation not permitted" | grep -v "Permission denied"

# ~/Library/Application\ Support/Knowledge/
# /System/Volumes/Data/Users/$USER/Library/Application Support/Knowledge/knowledgeC.db

*/

-- get streams
select distinct ZOBJECT.ZSTREAMNAME from ZOBJECT order by ZSTREAMNAME;

-- get sample app usage data
select datetime(ZOBJECT.ZCREATIONDATE + 978307200,'UNIXEPOCH', 'LOCALTIME') as "ENTRY CREATION", 
  case ZOBJECT.ZSTARTDAYOFWEEK 
    when "1" then "Sunday"
    when "2" then "Monday"
    when "3" then "Tuesday"
    when "4" then "Wednesday"
    when "5" then "Thursday"
    when "6" then "Friday"
    when "7" then "Saturday"
  end "DAY OF WEEK",
  ZOBJECT.ZSECONDSFROMGMT / 3600 as "GMT OFFSET",
  datetime(ZOBJECT.ZSTARTDATE + 978307200,'UNIXEPOCH', 'LOCALTIME') as "START", 
  datetime(ZOBJECT.ZENDDATE + 978307200,'UNIXEPOCH', 'LOCALTIME') as "END", 
  (ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE) as "USAGE IN SECONDS",
  ZOBJECT.ZSTREAMNAME, 
  ZOBJECT.ZVALUESTRING
from ZOBJECT
where ZSTREAMNAME is "/app/usage" 
order by "START"
limit 10;

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
where date(entry_creation) = date('now');
