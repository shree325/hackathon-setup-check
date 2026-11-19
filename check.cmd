@echo off
rem Setup check for Windows. Run from this folder: check.cmd
setlocal

echo == Tools
where git >nul 2>nul || (echo SETUP CHECK FAILED: git is not installed & exit /b 1)
where java >nul 2>nul || (echo SETUP CHECK FAILED: java is not installed, install JDK 21 & exit /b 1)
where node >nul 2>nul || (echo SETUP CHECK FAILED: node is not installed, install Node 20 or later & exit /b 1)
git --version
java -version
node -v

echo.
echo == Backend (downloads Maven dependencies and Postgres; a few minutes the first time)
call mvnw.cmd -B -q verify || (echo SETUP CHECK FAILED: the backend build or test failed. JDK 21 or later is required. & exit /b 1)

echo.
echo == LLM key
node check-llm.mjs
if errorlevel 2 (echo Set LLM_API_KEY to your Gemini API key and run again to check it.) else if errorlevel 1 (echo SETUP CHECK FAILED: your Gemini API key does not work & exit /b 1)

echo.
echo == Frontend
pushd web
call npm ci --no-audit --no-fund || (popd & echo SETUP CHECK FAILED: npm install failed & exit /b 1)
call npm run build || (popd & echo SETUP CHECK FAILED: the frontend build failed. Node 20 or later is required. & exit /b 1)
popd

echo.
echo == AI transcripts (your AI tool's sessions in this folder)
node export-transcripts.mjs --dry-run > "%TEMP%\slotbook-tx.txt"
type "%TEMP%\slotbook-tx.txt"
set TX=Found: none
for /f "tokens=*" %%L in ('findstr /b "Found:" "%TEMP%\slotbook-tx.txt"') do set TX=%%L
if "%TX%"=="Found: none" echo No AI session found for this folder. Open your AI tool here, ask it anything, then run the check again.

echo.
echo ============================================================
echo SETUP CHECK PASSED
echo date: %DATE% %TIME%
ver
java -version 2>&1 | findstr /i "version"
node -v
echo transcripts: %TX:Found: =%
echo ============================================================
echo Copy the block above into the registration form.
echo.
echo If "transcripts" says none: open your AI tool in this folder, ask it
echo anything, and run the check again. At the hackathon, export-transcripts.mjs
echo hands in your sessions; it reads Codex, Antigravity, Gemini CLI and Claude
echo Code. Using another tool? Say so in the registration form.
endlocal
