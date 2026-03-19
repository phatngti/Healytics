# Hybrid Plan: District Constraint with Proximity Query

## Goal
Preserve semantic flexibility while fixing the practical issue where a query like "massage gần tôi ở quận 3 hcm" should still constrain results to the named district when intent score is borderline.

## Current Behavior
- `LOCATION` is only converted to `query.locationCode` when `location_intent is True`.
- `location_intent` is decided by semantic score threshold (`LOCATION_INTENT_THRESHOLD = 0.58`).
- In the sample, `location_intent_score = 0.5733` so `locationCode` is omitted.
- Result: query runs with radius search (`gần tôi`) but without district hard filter.

## Chosen Strategy (Hybrid)
Use semantic intent as primary signal, but add a controlled fallback for borderline cases with explicit administrative cues.

### Decision Rule
Apply `locationCode` when either:
1. `location_intent == True` (existing behavior), or
2. Borderline semantic score AND explicit district/province cue in text.

### Borderline Band (initial)
- Lower bound: `0.55`
- Upper bound: `< LOCATION_INTENT_THRESHOLD` (currently `0.58`)

### Explicit Cue Heuristic (initial)
At least one strong admin marker in query near location mention:
- Vietnamese: `ở`, `tại`, `quận`, `huyện`, `phường`, `thành phố`, `tp`, `tỉnh`
- English: `in`, `district`, `city`, `province`

## Implementation Scope

### 1) Config
File: `app/core/config.py`
- Add borderline config knobs:
  - `LOCATION_INTENT_BORDERLINE_MIN`
  - `LOCATION_INTENT_BORDERLINE_MAX` (optional, defaults to threshold)
  - `LOCATION_EXPLICIT_CUE_ENABLED`

### 2) Query Builder Gate
File: `app/utils/query_builder.py`
- Replace strict gate:
  - from: `e.location_intent is True`
  - to: hybrid decision helper using:
    - `location_intent`
    - `location_intent_score`
    - explicit cue flag from entity (or recompute from source query)

### 3) Normalization Metadata
File: `app/ner/normalizer.py`
- Extend location normalization output with:
  - `location_explicit_cue: bool`
- Keep existing semantic fields:
  - `location_intent`, `location_intent_score`

### 4) Schema Compatibility
File: `app/schemas/ner_schema.py`
- Add optional field `location_explicit_cue` to preserve typed pipeline.

### 5) Observability
File: `app/api/prefilter_routes.py`
- Extend location intent logs with:
  - `explicit_cue`
  - `hybrid_applied`
  - `hybrid_reason`

## Expected Outcome on Sample
Input: "massage gần tôi ở quận 3 hcm"
- `location_intent_score = 0.5733` (borderline)
- Explicit admin cue present (`ở quận 3`)
- Hybrid fallback applies `locationCode = 770`
- Final query uses both:
  - spatial radius around user
  - district constraint (Quận 3)

## Tradeoffs
- Pros:
  - Fixes user expectation in practical mixed-intent queries.
  - Preserves semantic model as primary decision maker.
  - Limits over-filtering to explicit-cue, borderline cases.
- Cons:
  - Adds rules layer that needs tuning.
  - Requires calibration if query style shifts.

## Calibration Plan
- Start with `0.55 <= score < 0.58`.
- Log and review false positives/false negatives for 1-2 weeks.
- Adjust borderline band and cue list based on production traces.

## Rollout
1. Ship behind config flags (default enabled for staging).
2. Validate on a replay set of location+distance queries.
3. Promote to production after acceptance criteria:
   - Reduced district-miss cases in mixed proximity queries.
   - No significant increase in over-constrained results.
