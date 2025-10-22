# Enhanced Project Registration Script
# Usage: .\register-project.ps1 -ProjectPath "D:\my-project"

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
)

function Register-ProjectWithBestPractices {
    param([string]$Path)
    
    Write-Host "=== PROJECT REGISTRATION WITH BEST PRACTICES ===" -ForegroundColor Cyan
    
    # Phase 1: Validation
    Write-Host "`n[PHASE 1: VALIDATION]" -ForegroundColor Yellow
    
    if (-not (Test-Path $Path)) {
        Write-Host "? Project directory does not exist: $Path" -ForegroundColor Red
        return
    }
    Write-Host "? Project directory exists" -ForegroundColor Green
    
    $projectName = Split-Path $Path -Leaf
    $agentProjectDir = "D:\AgentSystem\Projects\$projectName"
    
    if (Test-Path $agentProjectDir) {
        Write-Host "? Project already registered: $projectName" -ForegroundColor Yellow
        return
    }
    Write-Host "? No duplicate project name" -ForegroundColor Green
    
    # Phase 2: Git Detection
    Write-Host "`n[PHASE 2: GIT DETECTION]" -ForegroundColor Yellow
    
    $gitPath = Join-Path $Path ".git"
    $hasGit = Test-Path $gitPath
    
    if ($hasGit) {
        Write-Host "? Git repository detected" -ForegroundColor Green
        Push-Location $Path
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        $trackedFiles = (git ls-files | Measure-Object).Count
        Pop-Location
        Write-Host "  Branch: $branch" -ForegroundColor Gray
        Write-Host "  Tracked files: $trackedFiles" -ForegroundColor Gray
    } else {
        Write-Host "? No Git repository (recommend: git init)" -ForegroundColor Yellow
        $branch = "main"
        $trackedFiles = 0
    }
    
    # Phase 3: Project Type Detection
    Write-Host "`n[PHASE 3: PROJECT TYPE DETECTION]" -ForegroundColor Yellow
    
    $projectType = "Unknown"
    $runtime = "TBD"
    $dependencies = @()
    
    if (Test-Path "$Path\package.json") {
        $projectType = "Node.js/JavaScript"
        $runtime = "Node.js"
        $pkg = Get-Content "$Path\package.json" | ConvertFrom-Json
        $dependencies = $pkg.dependencies.PSObject.Properties.Name
        Write-Host "? Detected: Node.js project" -ForegroundColor Green
    } elseif (Test-Path "$Path\requirements.txt") {
        $projectType = "Python"
        $runtime = "Python"
        $dependencies = Get-Content "$Path\requirements.txt" | Where-Object { $_ -notmatch '^#' }
        Write-Host "? Detected: Python project" -ForegroundColor Green
    } elseif (Test-Path "$Path\deno.json") {
        $projectType = "Deno/TypeScript"
        $runtime = "Deno"
        Write-Host "? Detected: Deno project" -ForegroundColor Green
    } elseif (Test-Path "$Path\Cargo.toml") {
        $projectType = "Rust"
        $runtime = "Rust"
        Write-Host "? Detected: Rust project" -ForegroundColor Green
    } else {
        Write-Host "? Could not auto-detect project type" -ForegroundColor Yellow
    }
    
    # Phase 4: Check Best Practice Files
    Write-Host "`n[PHASE 4: BEST PRACTICE FILES CHECK]" -ForegroundColor Yellow
    
    $hasReadme = Test-Path "$Path\README.md"
    $hasGitignore = Test-Path "$Path\.gitignore"
    
    Write-Host "  README.md: $(if($hasReadme){'? Exists'}else{'? Missing'})" -ForegroundColor $(if($hasReadme){'Green'}else{'Red'})
    Write-Host "  .gitignore: $(if($hasGitignore){'? Exists'}else{'? Missing'})" -ForegroundColor $(if($hasGitignore){'Green'}else{'Red'})
    
    # Phase 5: Create Context
    Write-Host "`n[PHASE 5: CREATING CONTEXT]" -ForegroundColor Yellow
    
    New-Item -Path $agentProjectDir -ItemType Directory -Force | Out-Null
    
    $contextContent = @"
# Project: $projectName
**Path:** $Path
**Type:** $projectType
**Current Branch:** $branch

## Stack
- Runtime: $runtime
- Framework: [Add if applicable]
- Database: [Add if applicable]
- Key Libraries: $(if($dependencies.Count -gt 0){($dependencies | Select-Object -First 5) -join ', '}else{'TBD'})

## Project Health
- Git Repository: $(if($hasGit){'? Initialized'}else{'? Not initialized'})
- README.md: $(if($hasReadme){'? Exists'}else{'? Missing'})
- .gitignore: $(if($hasGitignore){'? Exists'}else{'? Missing'})
- Tracked Files: $trackedFiles

## Active Work
- Project registration completed
- [Add current work items here]

## Context Last Updated
$(Get-Date -Format "yyyy-MM-dd HH:mm")

## Pending Work
- $(if(-not $hasReadme){'Create README.md with project documentation'})
- $(if(-not $hasGitignore){'Create .gitignore file'})
- $(if(-not $hasGit){'Initialize Git repository (git init)'})
- [Add development tasks]

## Notes
- Registered with best practices validation
- Auto-detected: $projectType
"@
    
    Set-Content -Path "$agentProjectDir\context.md" -Value $contextContent
    Write-Host "? Context file created with auto-detected information" -ForegroundColor Green
    
    # Phase 6: Summary Report
    Write-Host "`n[REGISTRATION SUMMARY]" -ForegroundColor Cyan
    Write-Host "  Project: $projectName" -ForegroundColor White
    Write-Host "  Type: $projectType" -ForegroundColor White
    Write-Host "  Runtime: $runtime" -ForegroundColor White
    Write-Host "  Branch: $branch" -ForegroundColor White
    Write-Host "  Best Practices Score: $(if($hasGit -and $hasReadme -and $hasGitignore){' 3/3 ?'}elseif($hasGit -and ($hasReadme -or $hasGitignore)){'2/3 ?'}else{'1/3 ?'})" -ForegroundColor $(if($hasGit -and $hasReadme -and $hasGitignore){'Green'}else{'Yellow'})
    
    Write-Host "`n? Project registered successfully!" -ForegroundColor Green
}

Register-ProjectWithBestPractices -Path $ProjectPath
