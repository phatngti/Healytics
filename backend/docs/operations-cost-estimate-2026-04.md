# Healytics Operations Cost Estimate

Pricing date: 2026-04-16

This estimate supersedes the earlier managed-PostgreSQL assumption. PostgreSQL is treated as self-hosted on VPS per the latest clarification. Because the infrastructure baseline is derived from [dockers/docker-compose.yml](/Volumes/WD850X/Users/workspace/datn/Healytics/dockers/docker-compose.yml) and the backend runtime in [backend/Dockerfile](/Volumes/WD850X/Users/workspace/datn/Healytics/backend/Dockerfile), Redis is also costed as self-hosted on VPS.

## Scope

- Included: backend/API compute, Kong OSS gateway compute, HAProxy, RabbitMQ cluster compute, PostgreSQL VPS, Redis VPS, Cloudflare R2, Mapbox.
- Excluded: AI services, MoMo fees, observability SaaS, staff/on-call, Kong Enterprise licensing, optional VPS backups/snapshots, excess Hetzner traffic over included quota.
- Self-hosted compute baseline: Hetzner Cloud shared cost-optimized plans.
- Region assumption: single region, budget VPS baseline, no premium support.

## Monthly Cost Model

| Component | Hosting model | Sizing assumption | Pricing source | Fixed monthly cost | Variable monthly cost | Notes |
| --- | --- | --- | --- | ---: | ---: | --- |
| Backend/API compute | Self-hosted VPS | `2 x CX33` (`4 vCPU / 8 GB / 80 GB`) | [Hetzner Cloud pricing](https://www.hetzner.com/cloud/volumes/) | $13.18 | $0.00 | `2 x $6.59`; sized for two app instances behind Kong. |
| Edge gateway | Self-hosted VPS | `1 x CX23` (`2 vCPU / 4 GB / 40 GB`) | [Hetzner Cloud pricing](https://www.hetzner.com/cloud/volumes/) | $4.09 | $0.00 | Runs Kong OSS plus HAProxy on one edge node. |
| RabbitMQ cluster | Self-hosted VPS | `3 x CX23` (`2 vCPU / 4 GB / 40 GB`) | [Hetzner Cloud pricing](https://www.hetzner.com/cloud/volumes/) | $12.27 | $0.00 | One broker per node; matches 3-node compose cluster. |
| PostgreSQL | Self-hosted VPS | `1 x CX33` (`4 vCPU / 8 GB / 80 GB`) | [Hetzner Cloud pricing](https://www.hetzner.com/cloud/volumes/) | $6.59 | $0.00 | Dedicated VPS for DB to avoid contention with API and brokers. |
| Redis | Self-hosted VPS | `1 x CX23` (`2 vCPU / 4 GB / 40 GB`) | [Hetzner Cloud pricing](https://www.hetzner.com/cloud/volumes/) | $4.09 | $0.00 | Dedicated VPS for cache, locks, and Socket.IO Redis adapter. |
| Cloudflare R2 storage | Managed SaaS | `500 GB-month` standard storage | [Cloudflare R2 pricing](https://developers.cloudflare.com/r2/pricing/) | $0.00 | $7.35 | `(500 - 10 free) x $0.015`. |
| Cloudflare R2 Class A ops | Managed SaaS | `200k requests / month` | [Cloudflare R2 pricing](https://developers.cloudflare.com/r2/pricing/) | $0.00 | $0.00 | Under free tier of `1M` Class A ops. |
| Cloudflare R2 Class B ops | Managed SaaS | `20M requests / month` | [Cloudflare R2 pricing](https://developers.cloudflare.com/r2/pricing/) | $0.00 | $3.60 | `(20M - 10M free) x $0.36 / 1M`. |
| Mapbox Temporary Geocoding | Managed SaaS | `50k requests / month` | [Mapbox pricing](https://www.mapbox.com/pricing) | $0.00 | $0.00 | Under free tier of `100k` monthly requests. |
| Mapbox Matrix API | Managed SaaS | `1M matrix elements / month` | [Mapbox pricing](https://www.mapbox.com/pricing) | $0.00 | $1,600.00 | `400k x $2.00 / 1k + 500k x $1.60 / 1k`; first `100k` free. |
| **Total** |  |  |  | **$40.22** | **$1,610.95** | **Base monthly total: $1,651.17** |

## Traffic Bands

Variable usage scales only the usage-based SaaS line items. Fixed VPS cost stays unchanged.

| Scenario | Fixed subtotal | Variable subtotal | Total monthly cost |
| --- | ---: | ---: | ---: |
| Low (`0.5x` variable usage) | $40.22 | $805.48 | $845.70 |
| Base (`1.0x` variable usage) | $40.22 | $1,610.95 | $1,651.17 |
| High (`2.0x` variable usage) | $40.22 | $3,221.90 | $3,262.12 |

## Notes

- Biggest cost driver by far is Mapbox Matrix API. At the current `1M` element assumption, it accounts for about `96.9%` of the variable spend.
- R2 is inexpensive at this workload because storage is modest and the write volume stays inside the free Class A tier.
- This estimate does not include optional Hetzner backups. If enabled on all six VPS instances, Hetzner lists backups at `20% of instance price`, which would add about `$8.04/month`.
- This estimate also does not include optional Hetzner block volumes. If PostgreSQL later needs dedicated block storage, Hetzner lists Volumes at `$0.0484 / GB-month`.

## Source Notes

- Hetzner current shared cost-optimized monthly caps used here: `CX23 = $4.09 max/month`, `CX33 = $6.59 max/month`, Volumes `= $0.0484 / GB-month`, Backups `= 20% of instance price`.
- Cloudflare R2 current standard pricing used here: storage `$0.015 / GB-month`, Class A `$4.50 / million`, Class B `$0.36 / million`, free tier `10 GB-month`, `1M` Class A, `10M` Class B.
- Mapbox current pricing used here: Temporary Geocoding free up to `100k` monthly requests, then `$0.75 / 1,000`; Matrix API free up to `100k` monthly elements, then `$2.00 / 1,000` for `100,001-500,000` and `$1.60 / 1,000` for `500,001-1,000,000`.
