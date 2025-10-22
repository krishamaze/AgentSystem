# -*- coding: utf-8 -*-
import os
import re

print("=== PYTHON SCRIPT SANITIZER ===\n")

py_files = [f for f in os.listdir('.') if f.endswith('.py') and f != 'fix_python_scripts.py']

for filename in py_files:
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Remove emoji characters
        cleaned = re.sub(r'[\U0001F000-\U0001FFFF]+', '', content)
        
        # Add encoding declaration
        if '# -*- coding: utf-8 -*-' not in cleaned:
            cleaned = '# -*- coding: utf-8 -*-\n' + cleaned
        
        # Add sys import and UTF-8 reconfigure if missing
        if 'sys.stdout.reconfigure' not in cleaned:
            if 'import sys' not in cleaned:
                # Add after first line (encoding declaration)
                lines = cleaned.split('\n')
                lines.insert(1, 'import sys')
                lines.insert(2, 'sys.stdout.reconfigure(encoding="utf-8")')
                cleaned = '\n'.join(lines)
            else:
                # Add after existing sys import
                cleaned = cleaned.replace('import sys', 'import sys\nsys.stdout.reconfigure(encoding="utf-8")')
        
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(cleaned)
        
        print(f"Fixed: {filename}")
    
    except Exception as e:
        print(f"Error fixing {filename}: {e}")

print("\nAll Python scripts sanitized!")