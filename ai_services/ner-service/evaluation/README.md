# NER Evaluation (Simplified)

## Files

```
evaluation/
├── gold_simple.csv         # 160 test queries (editable in Excel)
├── evaluate_ner.py      # Evaluation script
└── README.md               # This file
```

## Dataset Summary

**Total: 160 queries**

| Category | Count |
|----------|-------|
| Atomic (1 entity) | 52 |
| Compound (2 entities) | 45 |
| Compound (3 entities) | 38 |
| Compound (4 entities) | 25 |

### Entity Coverage
- BUSINESS_TYPE: 109 queries
- LOCATION: 85 queries
- PRICE: 86 queries
- DISTANCE: 76 queries

### Edge Cases Covered
- **Location aliases**: Q1, Q.1, quận một, TPHCM, HCM
- **Price formats**: 500k, 2tr, 2 triệu, 500 nghìn, từ X đến Y
- **Distance**: gần đây, xung quanh, lân cận, trong vòng Xkm, cách X cây số

## Usage

```bash
# Test 20 queries (quick validation)
python evaluate_ner.py --limit 20

# Resume from checkpoint (if interrupted)
python evaluate_ner.py --resume

# View report only
python evaluate_ner.py --report-only

# Run all 160 queries
python evaluate_ner.py

# Reset and run from scratch
python evaluate_ner.py --reset
```

## CSV Format

```csv
text,business_type,location_code,price_op,price_amount,price_max,distance_meters,distance_implicit
"Spa ở Q1 dưới 500k",SPA_BEAUTY,760,lte,500000,,,
"Gym gần đây",FITNESS,,,,,5000,true
```

## Output

```
NER EVALUATION REPORT
============================================================
Queries tested: 160
Avg latency: 215ms

ACCURACY BY FIELD
----------------------------------------
  business_type   ████████████████████ 95.0%
  location_code   ████████████████░░░░ 82.0%
  price           ██████████████████░░ 90.0%
  distance        ████████████████████ 92.0%
----------------------------------------
  OVERALL         ██████████████████░░ 89.7%

ERROR BREAKDOWN
----------------------------------------
  location_miss: 9 errors
    - Ở Q.1
    - Ở quận một
```
