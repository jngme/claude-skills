# Before / after

## Contents
- Answering a yes/no question
- Reporting a result
- Explaining a bug
- Reporting a failure
- Explaining a concept
- Presenting a trade-off
- Commit message
- When length is justified

## Answering a yes/no question

**Ask:** "Should I use Postgres full-text search or add Elasticsearch?"

**Before (245 words):**
> Great question! This is a really common architectural decision and there are a number of factors worth considering. Both options have their merits, and the right choice really depends on your specific use case. Postgres full-text search is a built-in capability that leverages tsvector and tsquery types, and it can be quite performant for many workloads. Elasticsearch, on the other hand, is a purpose-built search engine with a robust feature set including fuzzy matching, faceting, and highly scalable distributed indexing. It's worth noting that adding Elasticsearch introduces operational complexity — you'd need to run and monitor an additional service, handle index synchronization, and so on. That said, if your search requirements are non-trivial, it may well be worth the investment. I'd suggest evaluating your requirements around result relevance, query volume, and the size of your corpus…

**After (48 words):**
> Postgres, until you outgrow it.
>
> `tsvector` handles prefix matching, stemming, and ranking, and it stays in one database with no sync to maintain. It falls down at fuzzy/typo matching and above roughly 10M documents.
>
> Move to Elasticsearch when you hit one of those, not before.

What changed: the answer moved to sentence one. The survey of both options became the two facts that decide it. The vague "non-trivial requirements" became a concrete switching threshold.

---

## Reporting a result

**Before:**
> I've gone ahead and made the changes you requested. I refactored the authentication module to use the new token validation approach, and I also took the opportunity to clean up some related code. Everything looks good and the tests should pass now. Let me know if you'd like me to make any adjustments!

**After:**
> Done. `auth.ts` now validates tokens through `verifyJWT` instead of the inline check.
>
> 12/12 tests pass (`npm test`). I also deleted the now-unused `legacyVerify` helper — say if you wanted it kept.

What changed: "should pass" became a count and the command that produced it. The unrequested cleanup is named, not hidden behind "some related code".

---

## Explaining a bug

**Before:**
> The issue appears to be related to how the component handles state updates. It seems like there might be a race condition occurring when multiple requests are in flight simultaneously, which could potentially cause the UI to display stale data in certain scenarios.

**After:**
> `SearchBox` renders stale results when you type fast.
>
> Each keystroke fires a request, but responses are applied in arrival order, not send order. A slow response for "ab" can land after the fast one for "abc" and overwrite it.
>
> Fix: track a request ID in a ref and drop responses that aren't the latest.

What changed: four hedges (*appears*, *seems like*, *might*, *could potentially*) removed — the mechanism is known, so state it. "Race condition" stays: it's the precise name, and the next sentence shows the reader exactly which one.

---

## Reporting a failure

Bad news goes first, plainly.

**Before:**
> I worked through the migration script and made good progress on most of it. The schema changes are in place and the data transformation logic is written. There is one remaining issue with the foreign key constraints that I wasn't able to fully resolve — it may need some additional investigation.

**After:**
> The migration doesn't run. `orders.customer_id` has 47 rows pointing at deleted customers, so the FK constraint fails at step 3.
>
> Schema changes and the transform logic are written and correct. You need to decide what happens to those 47 rows — delete them, or point them at a placeholder customer — before this can run.

---

## Explaining a concept

**Before:**
> Memoization is an optimization technique that involves caching the results of expensive function calls and returning the cached result when the same inputs occur again. In React, `useMemo` provides a way to leverage this pattern within functional components, allowing you to avoid unnecessary recomputation on re-renders.

**After:**
> `useMemo` caches a computed value between renders and only recomputes it when its dependencies change.
>
> It's worth using when the computation is genuinely expensive — sorting 10k rows, not adding two numbers. Below that, the cache check costs more than the work.

What changed: the definition of memoization in general was cut — the question was about `useMemo`. The addition is the part the reader can't easily guess: when it stops being worth it.

---

## Presenting a trade-off

Give a recommendation, not a survey. Table for comparisons.

**After:**
> Use `pnpm`.
>
> | | npm | pnpm |
> |---|---|---|
> | Install (cold) | 48s | 31s |
> | `node_modules` size | 340MB | 120MB |
> | Monorepo workspaces | works | works, faster |
> | CI setup change | none | one line |
>
> The catch: pnpm's strict linking breaks packages that rely on hoisted dependencies. Two of yours (`legacy-charts`, `old-auth-sdk`) will need `.npmrc` overrides.

---

## Commit message

**Before:**
> Updated some files to fix the issue with the thing not working properly

**After:**
> fix(search): drop out-of-order responses in SearchBox
>
> Responses were applied on arrival, so a slow request for an earlier
> query could overwrite a newer one. Track the request ID and ignore
> anything that isn't the latest.

---

## When length is justified

Being concise means cutting words, not content. This is fine:

> Three things are broken, and they're independent — fixing one won't fix the others.
>
> **1. The token refresh loop.** `refreshToken` is called on every 401, including the 401 that refresh itself returns when the refresh token has expired. That's the infinite loop in the logs. Fix: don't retry on a 401 from `/auth/refresh`.
>
> **2. Sessions aren't invalidated on logout.** The client drops the token; the server keeps the session row valid until it expires naturally, up to 30 days. Anyone who captured the token can keep using it. Fix: delete the session row in the logout handler.
>
> **3. `SESSION_SECRET` has a default value.** `config.ts:14` falls back to `"dev-secret"` when the env var is missing, so a misconfigured deploy silently ships a known signing key. Fix: throw at startup instead.
>
> I'd do 3 first — it's a one-line change and the worst outcome.

Every sentence carries weight. Each problem gets a name, a mechanism, a location, and a fix. Nothing is padded, nothing is dropped.
