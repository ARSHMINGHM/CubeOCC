---
project: CubeOCC
type: ecc-metrics
status: draft
last_reviewed: 2026-08-22
---
# ECC and Metrics

## 8×8 coded capacity
- 59 coded cells.
- 3 bits/cell.
- **177 coded bits/DATA frame.**

Useful payload depends on ECC + any headers/sequence/CRC/padding.

## ECC experiment matrix
| Strength | Candidate | Exact parameters | Payload/frame | Status |
|---|---|---|---:|---|
| Baseline | none | — | TBD | planned |
| Low | Hamming | TBD | TBD | planned |
| Medium | BCH | TBD | TBD | planned |
| Strong | BCH | TBD | TBD | planned |

Do not lock numeric payload sizes until exact codewords and 177-bit packing are selected.

## Metrics
- raw BER before ECC
- post-ECC BER
- RGB symbol error rate
- frame error rate
- throughput
- goodput
- latency
- classification confidence
- ECC corrected/uncorrectable count

## Dataset condition fields
Distance, viewing angle, ambient light, glare, blur, exposure, display brightness, camera, grid size, symbol rate, ECC mode, denoise mode, warp mode.
