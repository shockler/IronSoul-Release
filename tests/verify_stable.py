from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parents[1]
m=json.loads((root/'STABLE_ENDLESS_FIX.json').read_text())
assert hashlib.sha256((root/m['source']).read_bytes()).hexdigest()==m['sha256']
p=root/'IronSoul_Launcher_Stall_V5.lua'
if p.exists():
 s=p.read_text()
 assert m['pinned_url'] in s
 assert 'https://gist.githubusercontent.com/shockler/e5c91e83aa50c3ae26817319c25d153d/raw/IronSoul_DEV.lua' in s
 assert 'https://raw.githubusercontent.com/shockler/IronSoul-Release/main/Stall.lua' in s
print('Stable artifact hash and launcher destinations PASS')
