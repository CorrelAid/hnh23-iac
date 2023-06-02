import requests
import psycopg2
import os
from dotenv import load_dotenv
from supabase import create_client, Client

load_dotenv()

key = os.getenv("SUPABASE_TOKEN")
db_pw = os.getenv("TF_VAR_supabase_db_pw")

url = 'https://api.supabase.com/v1/projects'
headers = {'Authorization': f'Bearer {key}'}
json = {'db_pass': db_pw, 
"name": os.getenv("SUPABASE_PROJECT_NAME"),
"organization_id": os.getenv("SUPABASE_ORG_ID"),
"region": "eu-central-1",
"plan": "free"
}

x = requests.post(url, json = json, headers=headers)

res = x.json()
print(res)

id_ = res["id"]

os.environ["TF_VAR_supabase_project_id"] = id_

host = f"db.{id_}.supabase.co"

conn = psycopg2.connect(user="postgres", password=db_pw, host=host , port="5432", 
    database="postgres")
cur = conn.cursor()

cur.execute("""

-- STORAGE -------------------
insert into storage.buckets (id, name)
values ('pictures', 'pictures');

""")

conn.commit()
cur.close()
conn.close()
