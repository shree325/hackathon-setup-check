#!/usr/bin/env bash
# Setup check for macOS and Linux. Run from this folder: ./check.sh
set -u
fail() { echo; echo "SETUP CHECK FAILED: $1"; exit 1; }

echo "== Tools"
command -v git >/dev/null || fail "git is not installed"
command -v java >/dev/null || fail "java is not installed (install JDK 21)"
command -v node >/dev/null || fail "node is not installed (install Node 20 or later)"
java_line=$(java -version 2>&1 | head -1)
java_major=$(echo "$java_line" | sed -E 's/.*version "([0-9]+).*/\1/')
node_major=$(node -v | sed -E 's/v([0-9]+).*/\1/')
echo "git:  $(git --version)"
echo "java: $java_line"
echo "node: $(node -v), npm $(npm -v)"
[ "$java_major" -ge 21 ] 2>/dev/null || fail "Java $java_major found; JDK 21 or later is required"
[ "$node_major" -ge 20 ] 2>/dev/null || fail "Node $node_major found; Node 20 or later is required"

echo; echo "== Backend (downloads Maven dependencies and Postgres; a few minutes the first time)"
./mvnw -B -q verify || fail "the backend build or test failed (scroll up for the error)"

echo; echo "== LLM key"
llm_line=$(node check-llm.mjs) ; llm_status=$?
echo "$llm_line"
[ "$llm_status" -eq 1 ] && fail "your Gemini API key does not work"

echo; echo "== Frontend"
(cd web && npm ci --no-audit --no-fund && npm run build) || fail "the frontend install or build failed"

echo; echo "== AI transcripts (your AI tool's sessions in this folder)"
node export-transcripts.mjs --dry-run
tx_line=$(node export-transcripts.mjs --dry-run 2>/dev/null | grep '^Found:')
case "$tx_line" in
  "Found: none") echo "No AI session found for this folder. Open your AI tool here, ask it anything, then run the check again." ;;
esac

cat <<DONE

============================================================
SETUP CHECK PASSED
date:   $(date -u +%Y-%m-%dT%H:%M:%SZ)
os:     $(uname -sm)
java:   $java_line
node:   $(node -v)
$(echo "$llm_line" | head -1)
transcripts: ${tx_line#Found: }
============================================================
Copy the block above into the registration form.

If "transcripts" says none: open your AI tool in this folder, ask it
anything, and run the check again. At the hackathon, export-transcripts.mjs
hands in your sessions; it reads Codex, Antigravity, Gemini CLI and Claude
Code. Using another tool? Say so in the registration form.
DONE
