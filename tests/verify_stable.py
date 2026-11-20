from pathlib import Path
import hashlib, json

root = Path(__file__).resolve().parents[1]
# Preserve original Stable v4.9.50f as a byte-verified rollback artifact.
legacy = json.loads((root / 'STABLE_ENDLESS_FIX.json').read_text())
assert hashlib.sha256((root / legacy['source']).read_bytes()).hexdigest() == legacy['sha256']

# Current Stable is the exact frozen Gist revision of the user-tested,
# completely rolled-back (pre PR132) DEV source.
new = json.loads((root / 'STABLE_CURRENT.json').read_text())
assert new['approved_source_sha'] == '23c7eb45c5bd7f66db6d57973d74333fb6ad82ef'
assert new['baseline_source_sha'] == 'df43eaa9d3a18b4d3f563a6cb76241f11909522a'
assert new['source_tree_sha'] == 'e30d02ae7f70cd76f6f8097ea8757ba044aef4f9'
assert new['sha256'] == '5b477fbceac5edc9d1e12dbfa01518a76b59af74b8f0000b17ef457711c439fe'
assert new['gist_revision'] == '245aa08b8ce9f4465bfbf045d9efec72009bbc46'
assert new['previous_stable_url'] == legacy['pinned_url']

launcher = (root / 'IronSoul_Launcher_Stall_V5.lua').read_text()
assert 'Stable = "' + new['pinned_url'] + '"' in launcher
assert launcher.count(new['pinned_url']) == 1
assert 'Dev = "https://gist.githubusercontent.com/shockler/e5c91e83aa50c3ae26817319c25d153d/raw/IronSoul_DEV.lua"' in launcher
assert 'https://raw.githubusercontent.com/shockler/IronSoul-Release/main/Stall.lua' in launcher
assert legacy['pinned_url'] not in launcher
print('Stable pinned snapshot, backup integrity, DEV/Stall destinations PASS')
