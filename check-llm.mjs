#!/usr/bin/env node
// Checks that your Gemini API key works and lists the models it can use. Usage: LLM_API_KEY=... node check-llm.mjs
const key = process.env.LLM_API_KEY
if (!key) {
  console.log('LLM key: not checked (set LLM_API_KEY to your Gemini API key, then run this again)')
  process.exit(2)
}
const res = await fetch('https://generativelanguage.googleapis.com/v1beta/models?pageSize=1000', {
  headers: { 'x-goog-api-key': key },
})
if (!res.ok) {
  console.log(`LLM key: FAILED (${res.status}). Check the key at https://aistudio.google.com/apikey`)
  process.exit(1)
}
const { models = [] } = await res.json()
const names = models.map((m) => m.name.replace('models/', ''))
const notable = names.filter((n) => /gemma|flash-lite|decision/i.test(n))
console.log(`LLM key: ok (${names.length} models available)`)
console.log(`  for example: ${notable.slice(0, 8).join(', ') || names.slice(0, 8).join(', ')}`)
