param([int]$Command = 1)

switch ($Command) {
    1 { # Full brain
        Get-Content ".\Agent_Primary\brain\learned-knowledge.md" -Raw | Set-Clipboard
        Write-Output "Full brain copied to clipboard"
    }
    2 { # Recent learnings from Supabase
        python -c "from supabase import create_client; from dotenv import load_dotenv; import os; load_dotenv(); client = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_ANON_KEY')); result = client.table('learnings').select('*').order('created_at', desc=True).limit(10).execute(); [print(f'{i+1}. {r[\"content\"][:150]}') for i, r in enumerate(result.data)]"
    }
    3 { # Mem0
        python list_memories.py
    }
    4 { # System status
        python system_status.py
    }
}
