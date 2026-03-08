# Option A: Using .env + envsubst

This project uses environment variables for secrets management instead of hardcoding them in YAML files.

## Setup

### 1. Create/configure `.env` file (never commit this!)
```env
SMTP_HOST=smtp.gmail.com
SMTP_FROM=your-email@gmail.com
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
ALERT_EMAIL_TO=recipient@example.com
```

### 2. YAML Templates
- `alertmanager.yml.template` contains placeholders like `${SMTP_HOST}`
- These are NOT committed to git
- Generated files (`.yml`) are gitignored

## Usage

### On Windows (PowerShell)
```powershell
.\entrypoint.ps1
```

### On Linux/Mac (bash)
```bash
chmod +x entrypoint.sh
./entrypoint.sh
```

### Manual method (if scripts fail)
```bash
export $(cat .env | xargs)
envsubst < alertmanager.yml.template > alertmanager.yml
docker compose up -d
```

## How it works

1. **entrypoint script** reads `.env` file
2. Sets environment variables from `.env`
3. Uses `envsubst` to replace `${VAR}` in templates
4. Generates actual `.yml` files with real values
5. Docker Compose uses the generated files

## Security benefits

✅ Secrets never in git commit history  
✅ Templates show config structure without revealing values  
✅ Easy to rotate secrets (just update `.env`)  
✅ Different `.env` files for different environments  

## .gitignore entries

Make sure these are in your `.gitignore`:
```
# Generated from templates
alertmanager.yml

# Environment files
.env
.env.local
.env.*.local
```

## Workflow summary

```
.env (secrets - gitignored)
  ↓
entrypoint.ps1/sh (envsubst)
  ↓
alertmanager.yml (generated - gitignored)
  ↓
docker compose up -d
```
