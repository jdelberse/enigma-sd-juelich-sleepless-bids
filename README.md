# Juelich Dataset (`juelich-sleepless-bids`)

## Overview

This dataset contains MRI data from a sleep manipulation study conducted at the Forschungszentrum Juelich (Germany). It is part of the ENIGMA-Sleep Working Group collection used to study the effects of sleep loss on glymphatic MRI indices. The data are organized according to the Brain Imaging Data Structure (BIDS) and managed with DataLad (git-annex).

## Sample

| Item | Value |
|---|---|
| Site | Juelich |
| Affiliation | Forschungszentrum Juelich |
| Country | Germany |
| Participants (N) | 39 |
| Age, mean (SD), years | 27.9 (6.2) |
| Male (%) | 33.3 |

## Sleep protocol

- **BL**: baseline (habitual) sleep
- **SD**: total sleep deprivation, 24 h
- **CL**: control, habitual sleep

## Imaging data

### T1-weighted (`anat/`)

| Parameter | Value |
|---|---|
| Scanner | Siemens TrioTim |
| Sequence | MPRAGE |
| TR (ms) | 2000 |
| TE (ms) | 3.03 |
| TI (ms) | 900 |
| Flip angle (°) | 9 |

### Diffusion-weighted (`dwi/`)

| Parameter | Value |
|---|---|
| Scanner | Siemens TrioTim |
| Sequence | DTI EPI |
| Resolution (mm³) | 2.4 x 2.4 x 2.4 |
| TR (ms) | 8300 |
| TE (ms) | 111 |
| b-values (s/mm²) | 0, 700, 1000, 2850 |
| Phase-encoding direction | AP |

## Data organization

- `sub-<ID>/ses-<label>/`: raw BIDS data (`anat/`, `dwi/`)
- `participants.tsv`: participant-level information
- `sub-<ID>/sub-<ID>_sessions.tsv`: session-level information (condition, visit, date, time)
- `derivatives/`: processed outputs, if present

File contents are tracked with git-annex. After cloning, retrieve data with `datalad get <path>`.

## Original publication

Elmenhorst, D. et al. Sleep deprivation increases levels of the synaptic density marker SV2A in the human brain. PLOS Biology 24, e3003816 (2026).[https://doi.org/10.1371/journal.pbio.3003816](https://doi.org/10.1371/journal.pbio.3003816)

## Contact

- Jorik D. Elberse: [j.elberse@fz-juelich.de](mailto:j.elberse@fz-juelich.de)
- Masoud Tahmasian: [m.tahmasian@fz-juelich.de](mailto:m.tahmasian@fz-juelich.de)
