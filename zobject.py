import os
import sqlite3

# find / -name 'knowledgeC*' 2>&1 | grep -v "Operation not permitted"
#   ~/Library/Application\ Support/Knowledge/
#   /System/Volumes/Data/Users/$USER/Library/Application Support/Knowledge/knowledgeC.db

user = os.environ['USER']
db_path = f'/System/Volumes/Data/Users/{user}/Library/Application Support/Knowledge/knowledgeC.db'
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

query = """
with app_usage as (
  select datetime(ZOBJECT.ZCREATIONDATE + 978307200, 'UNIXEPOCH', 'LOCALTIME') as entry_creation, 
    (ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE) as usage
  from ZOBJECT
  where ZSTREAMNAME is "/app/usage"
)
select time(sum(usage), 'unixepoch') as total_usage
from app_usage
where date(entry_creation)=date('now');
"""

for row in cursor.execute(query):
  print(row)
conn.close()
