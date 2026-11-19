# Hackathon setup check

Run this at home, before the day. It confirms your laptop has what the hackathon needs, and downloads every library in advance so you are not waiting on the venue Wi-Fi.

You need:

- **JDK 21** (or later), for example Eclipse Temurin 21
- **Node 20** (or later)
- **Git**
- The **AI coding tools** you plan to use, installed and signed in
- A free **Gemini API key** from https://aistudio.google.com/apikey (sign in with a Google account, then "Create API key"). Some tasks call an LLM, and the free tier is enough.

Then:

```
git clone <this repo>
cd setup-check
LLM_API_KEY=<your key> ./check.sh          # macOS / Linux
set LLM_API_KEY=<your key> && check.cmd    # Windows
```

The first run takes a few minutes. It ends with **SETUP CHECK PASSED** and a short block of details: paste that block into the registration form.

If it fails, the last lines say why. Most failures are an old Java (`java -version` must say 21 or later) or an old Node (`node -v` must say v20 or later).

Run it again the evening before the hackathon if you change anything on your laptop.
