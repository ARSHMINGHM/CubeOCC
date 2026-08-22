---
project: CubeOCC
type: ecc
status: experiment
last_reviewed: 2026-08-22
---

# ECC and Metrics

## Capacity reminder

8×8 DATA frame:

**59 cells × 3 bits/cell = 177 coded bits.**

ECC acts on the recovered binary stream after RGB-symbol classification. A wrong optical symbol may create one or more bit errors; the ECC decoder attempts to correct those bit flips.

## Baseline

Always include **No ECC** as the raw reliability/throughput reference.

## Hamming candidates

Standard Hamming codes are single-error-correcting (SEC). Extended Hamming variants add an overall parity bit and are commonly used as SECDED: correct 1 bit and detect 2-bit errors per codeword.

| Scheme           | Code `(n,k)` | Data bits/codeword | Redundancy bits/codeword | Correction capability | Detection note | Whole codewords in 177 bits | Useful data bits/frame | Used coded bits | Padding |
| ---------------- | -----------: | -----------------: | -----------------------: | --------------------- | -------------- | --------------------------: | ---------------------: | --------------: | ------: |
| Hamming          |        (7,4) |                  4 |                        3 | 1 bit                 | dmin=3         |                          25 |                    100 |             175 |       2 |
| Hamming          |      (15,11) |                 11 |                        4 | 1 bit                 | dmin=3         |                          11 |                    121 |             165 |      12 |
| Hamming          |      (31,26) |                 26 |                        5 | 1 bit                 | dmin=3         |                           5 |                    130 |             155 |      22 |
| Extended Hamming |        (8,4) |                  4 |                        4 | 1 bit                 | SECDED         |                          22 |                     88 |             176 |       1 |
| Extended Hamming |      (16,11) |                 11 |                        5 | 1 bit                 | SECDED         |                          11 |                    121 |             176 |       1 |
| Extended Hamming |      (32,26) |                 26 |                        6 | 1 bit                 | SECDED         |                           5 |                    130 |             160 |      17 |

### Example: Hamming (15,11)

- 11 information bits become a 15-bit codeword
- 4 bits are redundancy
- 11 complete codewords fit in 177 coded bits
- 121 information bits/frame
- 165 coded bits used
- 12 bits padding unless shortened/custom packing is introduced

## BCH candidates

For binary BCH candidates, correction capability is `t = floor((dmin-1)/2)`.

| Scheme | Code `(n,k,dmin)` | Data bits/codeword | Redundancy bits/codeword | Corrects up to | Whole codewords in 177 bits | Useful data bits/frame | Used coded bits | Padding |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| BCH | (15,7,5) | 7 | 8 | 2 bits/codeword | 11 | 77 | 165 | 12 |
| BCH | (15,5,7) | 5 | 10 | 3 bits/codeword | 11 | 55 | 165 | 12 |
| BCH | (31,21,5) | 21 | 10 | 2 bits/codeword | 5 | 105 | 155 | 22 |
| BCH | (31,16,7) | 16 | 15 | 3 bits/codeword | 5 | 80 | 155 | 22 |
| BCH | (31,11,11) | 11 | 20 | 5 bits/codeword | 5 | 55 | 155 | 22 |

> [!note]
> These are candidate standard block codes. Final implementation must lock and verify the exact generator polynomial/decoder configuration in the golden model.

## Possible shortened codes

177 is not divisible by many standard block lengths. A later experiment may use shortened codes to improve packing efficiency. Do not add this complexity until standard candidates are working.

## Experiment result table

| ECC mode | Grid | Raw BER | Post-ECC BER | Uncorrectable frames | Useful payload/frame | Goodput | Decoder latency | LUT | FF | BRAM | DSP |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| None | 8×8 |  |  |  | 177* |  |  |  |  |  |  |
| Hamming (7,4) | 8×8 |  |  |  | 100 |  |  |  |  |  |  |
| Hamming (15,11) | 8×8 |  |  |  | 121 |  |  |  |  |  |  |
| Hamming (31,26) | 8×8 |  |  |  | 130 |  |  |  |  |  |  |
| BCH (15,7,5) | 8×8 |  |  |  | 77 |  |  |  |  |  |  |
| BCH (15,5,7) | 8×8 |  |  |  | 55 |  |  |  |  |  |  |
| BCH (31,21,5) | 8×8 |  |  |  | 105 |  |  |  |  |  |  |
| BCH (31,16,7) | 8×8 |  |  |  | 80 |  |  |  |  |  |  |
| BCH (31,11,11) | 8×8 |  |  |  | 55 |  |  |  |  |  |  |

`*` No-ECC row assumes all 177 coded bits are available before packet/header overhead.

## Metrics

- Raw BER
- Post-ECC BER
- Symbol Error Rate
- Uncorrectable frame rate
- Goodput
- Decoder latency
- LUT / FF / BRAM / DSP usage
