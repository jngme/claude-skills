# Word choice

## Contents
- Padding to delete outright
- Hedges and softeners
- Long word → short word
- Jargon → plain English
- Jargon worth keeping
- Vague words that need a number

## Padding to delete outright

These phrases can be removed with no loss of meaning:

- "It's important to note that…"
- "It's worth mentioning that…"
- "As you may know…"
- "Great question!" / "Good catch!" / "Absolutely!"
- "Let me explain…" / "Let's dive in…" / "I'll walk you through…"
- "In summary, what we did here was…" (when the reader just read it)
- "I hope this helps!" / "Let me know if you'd like me to…"
- "Basically" / "Essentially" / "At the end of the day"
- "The reason for this is that…" → "Because"
- "In order to" → "to"
- "At this point in time" / "currently" → "now", or cut
- "Due to the fact that" → "because"
- "In the event that" → "if"
- "Has the ability to" → "can"
- "Make a decision" → "decide"
- "Take action" → "act"
- "Provide assistance" → "help"
- "A number of" → the number
- "Advance planning" → "planning"

## Hedges and softeners

Cut these unless the uncertainty is real and load-bearing. When it is real, name it precisely instead: "I didn't run this" beats "this should probably work".

- "I think maybe" → "I think", or state it flat
- "It seems like it might" → "it does" or "I'm not sure whether it does"
- "sort of" / "kind of" / "somewhat" / "fairly" / "rather"
- "arguably" / "generally speaking" / "in most cases" (unless you know the cases)
- "just" ("I just wanted to check…") → cut
- "should work" → "works — I ran it" or "untested"

## Long word → short word

| Long | Short |
|---|---|
| utilize | use |
| leverage (verb) | use |
| facilitate | help, make easier |
| implement (in prose) | build, add, write |
| demonstrate | show |
| approximately | about |
| subsequently | then, after |
| prior to | before |
| additional | more, extra |
| numerous | many |
| initiate | start |
| terminate | end, stop, kill |
| endeavour | try |
| ascertain | find out |
| necessitate | need, require |
| sufficient | enough |
| commence | begin |
| methodology | method |
| functionality | features, what it does |
| capabilities | what it can do |

## Jargon → plain English

Business and consulting jargon. Roman & Raphaelson's list, updated for tech.

| Jargon | Say instead |
|---|---|
| interface with | talk to, work with |
| impact (verb) | affect |
| surface (verb) | show, raise |
| socialize (an idea) | share, discuss |
| bandwidth | time, capacity |
| delta | difference |
| orthogonal | unrelated |
| non-trivial | hard — and say how hard |
| holistic | whole, complete |
| granular | detailed |
| robust | say what it survives |
| seamless | say what the user doesn't have to do |
| scalable | say to what scale |
| performant | fast — and give the number |
| best-in-class | cut |
| paradigm / paradigm shift | approach / big change |
| synergy | cut, or say what fits with what |
| circle back | follow up |
| deep dive | look closely |
| move the needle | make a difference |
| push the envelope | test the limits |
| low-hanging fruit | easy wins |
| ideate | think of ideas |
| incentivize | motivate, pay for |
| operationalize | put into practice |
| skill set | skills |
| learnings | what we learned |
| ask (noun) | request |
| spend (noun) | cost, budget |
| resource constrained | not enough people or money |
| suboptimal | worse, not ideal |

## Jargon worth keeping

These are precise names, not fancy synonyms. The plain-English version would be longer *and* less exact. Keep them.

- **Concurrency:** race condition, deadlock, mutex, backpressure, idempotent
- **Performance:** tail latency, p99, cold start, N+1 query, cache invalidation
- **Types & structure:** nullable, discriminated union, invariant, side effect, pure function
- **Systems:** eventual consistency, TLS handshake, CORS preflight, connection pool
- **Version control:** rebase, cherry-pick, fast-forward, detached HEAD
- **Framework terms:** hydration, `useEffect`, middleware, migration, hook

If the reader may not know one, define it in a clause the first time: "an N+1 query — one query per row instead of one query total — is what's making this slow." Then use it freely.

## Vague words that need a number

When one of these appears, replace it with a measurement, a count, a name, or a file reference.

| Vague | Fix by giving |
|---|---|
| slow / fast | milliseconds |
| some / a few / several | the count |
| large / small | the size |
| often / sometimes / rarely | the frequency, or the condition |
| recently | the date |
| better / worse | the axis and the amount |
| most / many | the proportion |
| the code / that part | `file.ts:line` |
| significantly | the percentage |
| soon | when |
