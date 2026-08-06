# Session candidates

Scratch buffer. `/learning-session` appends here; `/learning-commit` reads it and clears it.

Exists because long sessions get compacted — this file survives, the transcript may not.

Format: `concept · depth · evidence`

```
middleware · @read · playback correct: "a chain where each link can stop it"
event-loop · @model→@read? · recognized it in app.ts:14, no playback yet
di-factory · — · parked, blocked on middleware
async-await · MISMATCH · map says @read, Q1 probe failed
```

Only append after a playback or a probe result, never after an explanation.

---
