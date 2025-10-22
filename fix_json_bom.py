import os
import json
import glob

def remove_bom_from_json(file_path):
    """Remove UTF-8 BOM from JSON files"""
    try:
        with open(file_path, 'r', encoding='utf-8-sig') as f:
            data = json.load(f)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        
        print(f"✓ Fixed: {file_path}")
        return True
    except Exception as e:
        print(f"✗ Error in {file_path}: {e}")
        return False

# Fix all JSON files in .meta directory recursively
print("=== Removing BOM from all JSON files ===\n")
json_files = glob.glob(".meta/**/*.json", recursive=True)

fixed = 0
for json_file in json_files:
    if remove_bom_from_json(json_file):
        fixed += 1

print(f"\n✓ Fixed {fixed}/{len(json_files)} JSON files")
