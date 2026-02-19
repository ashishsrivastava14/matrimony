import json, codecs

def fix_lists_to_dicts(v):
    """Recursively convert [[k,v],...] or [(k,v),...] style lists/tuples back to dicts."""
    if isinstance(v, (list, tuple)) and v and all(isinstance(item, (list, tuple)) and len(item) == 2 for item in v):
        return {item[0]: fix_lists_to_dicts(item[1]) for item in v}
    elif isinstance(v, dict):
        return {k: fix_lists_to_dicts(val) for k, val in v.items()}
    return v

def fix_arb(path):
    with codecs.open(path, "r", "utf-8") as f:
        raw = f.read()
    
    # Parse with pairs hook to handle duplicates
    decoder = json.JSONDecoder(object_pairs_hook=lambda pairs: pairs)
    pairs, _ = decoder.raw_decode(raw)
    
    # Convert to ordered dict keeping last occurrence, and fix all nested metadata
    result = {}
    for k, v in pairs:
        result[k] = fix_lists_to_dicts(v)
    
    with codecs.open(path, "w", "utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=2)
    
    print("Fixed " + path + ": " + str(len(result)) + " keys")

fix_arb(r"d:\Projects\InHouseWebsites\MobileApp\Matrimony\lib\l10n\app_en.arb")
fix_arb(r"d:\Projects\InHouseWebsites\MobileApp\Matrimony\lib\l10n\app_hi.arb")
