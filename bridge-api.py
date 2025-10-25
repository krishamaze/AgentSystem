from flask import Flask, request, jsonify
from flask_cors import CORS
import subprocess

app = Flask(__name__)
CORS(app)  # Allow browser console to call

@app.route('/execute', methods=['POST'])
def execute():
    try:
        data = request.json
        cmd = data['command']
        
        print(f'\n🔧 Executing: {cmd[:80]}...')
        
        result = subprocess.run(
            ['C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe', '-Command', cmd],
            capture_output=True,
            text=True,
            timeout=30,
            cwd='D:\\AgentSystem'
        )
        
        output = result.stdout.strip() or result.stderr.strip()
        
        print(f'✓ Output ({len(output)} chars)')
        
        return jsonify({
            'success': True,
            'output': output,
            'error': result.stderr if result.returncode != 0 else None
        })
        
    except Exception as e:
        print(f'❌ Error: {e}')
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

if __name__ == '__main__':
    print('🚀 Bridge API Server starting on http://localhost:5000')
    print('   Waiting for commands from browser...\n')
    app.run(port=5000, debug=True)
