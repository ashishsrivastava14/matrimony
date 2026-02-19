"""
Sync missing keys from app_en.arb to app_ta.arb and app_te.arb.
Uses English values as placeholders for untranslated keys.
Preserves existing translations intact.
"""
import json, codecs, os

BASE = r"d:\Projects\InHouseWebsites\MobileApp\Matrimony\lib\l10n"

def load_arb(path):
    with codecs.open(path, "r", "utf-8") as f:
        return json.load(f)

def save_arb(path, data, locale):
    # Ensure @@locale is correct
    ordered = {"@@locale": locale}
    for k, v in data.items():
        if k != "@@locale":
            ordered[k] = v
    with codecs.open(path, "w", "utf-8") as f:
        json.dump(ordered, f, ensure_ascii=False, indent=2)
    print(f"Updated {path}: {len(ordered)} keys")

def sync_arb(en_data, target_path, locale):
    target = load_arb(target_path)
    added = 0
    for key, value in en_data.items():
        if key not in target:
            target[key] = value
            added += 1
    save_arb(target_path, target, locale)
    print(f"  Added {added} missing keys")

en_path = os.path.join(BASE, "app_en.arb")
ta_path = os.path.join(BASE, "app_ta.arb")
te_path = os.path.join(BASE, "app_te.arb")

en_data = load_arb(en_path)

print("Syncing Tamil ARB...")
sync_arb(en_data, ta_path, "ta")

print("Syncing Telugu ARB...")
sync_arb(en_data, te_path, "te")

print("Done!")
