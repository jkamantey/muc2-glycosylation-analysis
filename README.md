# MUC2 Glycosylation Analysis

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10+](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Jupyter](https://img.shields.io/badge/Jupyter-Notebooks-F37626?logo=jupyter&logoColor=white)](https://jupyter.org/)
[![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-red.svg)](https://github.com/jkamantey/muc2-glycosylation-analysis)
[![AMBER](https://img.shields.io/badge/Force%20Field-AMBER-green.svg)]()

**Open-source MD analysis pipeline for the MUC2 mucin long PTS domain**

*How O-glycosylation reshapes backbone mechanics, polymer properties, and ligand interaction capacity*

</div>

---

## Table of Contents

- [Overview](#overview)
- [Systems](#systems)
- [Analysis Pipeline](#analysis-pipeline)
- [Notebooks](#notebooks)
- [Key Findings](#key-findings)
- [Installation](#installation)
- [Data](#data)
- [Citation](#citation)
- [License](#license)
- [Author](#author)

---

## Overview

**MUC2** is the dominant gel-forming glycoprotein of the intestinal mucus layer. Its **long PTS (Pro-Thr-Ser) domain** — a tandem-repeat intrinsically disordered region carrying up to 30 O-linked glycan chains — is responsible for the mucus gel's unique mechanical properties: rigidity, hydration, and selective permeability.

This repository provides a complete, reproducible computational pipeline that answers two connected questions:

> **1.** What are the intrinsic biophysical and polymer properties of the MUC2 PTS backbone?
>
> **2.** How do O-glycosylation and ligand interactions progressively reshape those properties?

The pipeline moves from local backbone geometry (per-residue bending, dihedral angles) through global chain mechanics (persistence length, radius of gyration) to correlated dynamics and free energy landscapes — building a full structural picture of how glycosylation transforms a flexible disordered peptide into a stiff, rod-like mucin fibre.

---

## Systems

Three glycosylation states are compared across **~10,800 ns** of all-atom MD simulation:

| System | Description | Colour | Simulation |
|--------|-------------|--------|------------|
| **Non-glycosylated** | Naked PTS backbone, no O-glycans | ![#A23B72](https://placehold.co/12x12/A23B72/A23B72.png) `#A23B72` | 3 × 1200 ns |
| **Mid-level Glycosylated** | Partial O-glycosylation | ![#2E86AB](https://placehold.co/12x12/2E86AB/2E86AB.png) `#2E86AB` | 3 × 1200 ns |
| **Ext. Glycosylated** | Full / dense O-glycosylation | ![#F18F01](https://placehold.co/12x12/F18F01/F18F01.png) `#F18F01` | 3 × 1200 ns |

> 2381 frames per system · 1.2 ns/frame · AMBER force field · explicit solvent (TIP3P)

---

## Analysis Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                     STAGE 1 — Biophysical                       │
│                  Characterise the MUC2 backbone                 │
├──────────────────┬──────────────────┬───────────────────────────┤
│  Local geometry  │  Global polymer  │  Conformational sampling  │
│                  │   mechanics      │                           │
│  · Cα curvature  │  · Rg, ETE       │  · PCA (PC1, PC2)         │
│  · Pre-glycan    │  · Persistence   │  · Free energy surface    │
│    bending       │    length        │  · Dihedral distributions │
│  · φ/ψ angles   │  · RMSF          │  · Secondary structure    │
│  · Twist profile │                  │                           │
└──────────────────┴──────────────────┴───────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│               STAGE 2 — Dynamics & Interactions                 │
│         How glycosylation reshapes properties & binding         │
├──────────────────┬──────────────────┬───────────────────────────┤
│  Correlated      │  Interaction     │  Thermodynamics           │
│  motions         │  network         │                           │
│                  │                  │                           │
│  · DCCM          │  · H-bond        │  · PMF / FES              │
│  · Cross-norm    │    occupancy     │  · Conformational         │
│    DCCM          │  · Ligand        │    barriers               │
│                  │    accessibility │                           │
└──────────────────┴──────────────────┴───────────────────────────┘
```

---

## Notebooks

### Stage 1 — Biophysical Properties

| Notebook | Description |
|----------|-------------|
| [`radius_of_curvature.ipynb`](radius_of_curvature.ipynb) | Cα interior virtual bond-angle curvature · per-residue bending profiles · pre-glycan structural hotspot analysis · bimodal distribution characterisation |
| [`rmsf_comparison.ipynb`](rmsf_comparison.ipynb) | Per-residue RMSF across all three systems · identifies stiffened and mobilised regions |
| [`plot_physical_vars.ipynb`](plot_physical_vars.ipynb) | PCA coloured by Rg · ETE · curvature · persistence length · free energy surface · Pearson correlations with PC axes |
| [`persistence_length.ipynb`](persistence_length.ipynb) | Worm-like chain (WLC) fit · sliding-window Lp · stiffness comparison across glycosylation states |
| [`phi_psi_bend_analysis.ipynb`](phi_psi_bend_analysis.ipynb) | Ramachandran scatter from mean structures · bend redistribution profiles · Cα dihedral twist analysis |
| [`dihedral_distribution.ipynb`](dihedral_distribution.ipynb) | Backbone φ/ψ dihedral distributions · conformational basin populations |
| [`secondary_structure.ipynb`](secondary_structure.ipynb) | DSSP secondary structure per residue per frame · PPII / coil content vs glycosylation |

### Stage 2 — Dynamics, Correlations & Interactions

| Notebook | Description |
|----------|-------------|
| [`dccm_glyc_noglyc.ipynb`](dccm_glyc_noglyc.ipynb) | Dynamic cross-correlation matrix (DCCM) · glyc vs non-glyc |
| [`dccm_comparison.ipynb`](dccm_comparison.ipynb) | DCCM comparison across all three glycosylation states |
| [`dccm_crossnorm.ipynb`](dccm_crossnorm.ipynb) | Cross-normalised DCCM · isolates changes in correlation pattern independent of fluctuation magnitude |
| [`hbond_analysis.ipynb`](hbond_analysis.ipynb) | Intra-chain and chain–solvent H-bond occupancy · backbone donor/acceptor accessibility for ligand binding |
| [`pmf_ref_formula.ipynb`](pmf_ref_formula.ipynb) | Potential of mean force (PMF) along PC1/PC2 · reference formula |
| [`pmf_corrected_formula.ipynb`](pmf_corrected_formula.ipynb) | PMF · corrected formula · conformational stability comparison |

### PCA & Conformational Sampling

| Notebook | Description |
|----------|-------------|
| [`muc2_newsystem.ipynb`](muc2_newsystem.ipynb) | Combined PCA · glycosylated + non-glycosylated · shared conformational space |
| [`muc2_noglycans.ipynb`](muc2_noglycans.ipynb) | PCA · non-glycosylated system only |
| [`pca_dccm_noglyc_domains.ipynb`](pca_dccm_noglyc_domains.ipynb) | PCA + DCCM by domain · non-glycosylated |
| [`pca_dccm_normal_domains.ipynb`](pca_dccm_normal_domains.ipynb) | PCA + DCCM by domain · glycosylated |
| [`pca_last400_comparison.ipynb`](pca_last400_comparison.ipynb) | PCA of last 400 ns per run · convergence check |

---

## Key Findings

<details>
<summary><b>1. The sequence pre-encodes structural hotspots at glycan sites</b></summary>

25 out of 30 pre-glycan positions already form a local bending peak in the **non-glycosylated** chain — before any glycan is attached. The backbone geometry is shaped by the amino acid sequence to anticipate glycosylation. The 5 non-rising sites are all **Glycine**, falling at exactly position 6 of every 6-residue tandem repeat unit.

</details>

<details>
<summary><b>2. Glycine acts as the periodic conformational hinge</b></summary>

Glycine is the only amino acid with no side chain, giving it exceptional conformational freedom. It cannot hold the backbone in the extended geometry that Thr, Ile, Val, and Pro enforce — instead it dips into a more kinked state. This makes it the structurally weakest point in each repeat unit, and the site of the **largest glycan-driven conformational rescue** (up to +15.6° at a single Gly site under full glycosylation).

</details>

<details>
<summary><b>3. Glycosylation redistributes bending rather than uniformly stiffening</b></summary>

The total summed bending across the chain is similar between systems, but its spatial distribution changes: some residues become more extended while others become more kinked. This redistribution — not simple global stiffening — is the dominant mechanical effect of glycosylation.

</details>

<details>
<summary><b>4. Bimodal angle distributions signal conformational switching</b></summary>

Rather than shifting all pre-glycan residues to a new single preferred angle, glycosylation splits the population into two distinct peaks. The backbone switches between two energy minima — a behaviour that at the macroscopic scale underpins the viscoelastic (simultaneously solid-like and liquid-like) mechanics of mucus gels.

</details>

<details>
<summary><b>5. Long-range correlated motions increase with glycosylation</b></summary>

DCCM analysis shows that glycosylation introduces longer-range dynamic correlations along the chain. This has direct consequences for ligand interactions: a ligand binding at one region can propagate its structural effect further along the chain in the glycosylated system than in the naked backbone.

</details>

---

## Key Results Table

| Property | Non-glycosylated | Mid-glycosylated | Ext. glycosylated |
|----------|:---:|:---:|:---:|
| Mean Cα bend angle (°) | ~116–120 | ~119–124 | ~122–128 |
| Gly-site Δ angle from non-glyc (°) | — | up to +10 | up to **+16** |
| Pre-glycan angle distribution | unimodal · narrow | bimodal · broader | bimodal · broad |
| Bend redistribution | baseline | partial | strong |
| Chain stiffness (Lp) | lowest | intermediate | highest |
| Long-range DCCM correlations | weakest | intermediate | strongest |

---

## Installation

```bash
# Clone the repository
git clone https://github.com/jkamantey/muc2-glycosylation-analysis.git
cd muc2-glycosylation-analysis

# Create a conda environment
conda create -n muc2_analysis python=3.10
conda activate muc2_analysis

# Install dependencies
pip install numpy scipy matplotlib pandas jupyter mdanalysis
```

### Running a notebook interactively

```bash
jupyter notebook
```

### Running a notebook non-interactively

```bash
jupyter nbconvert --to notebook --execute \
  --ExecutePreprocessor.kernel_name=anaconda-base \
  --ExecutePreprocessor.timeout=600 \
  --inplace <notebook_name>.ipynb
```

### Setting your data path

Each notebook has a `BASE` variable near the top pointing to the local data directory. Update it to match your system before running:

```python
BASE = '/path/to/your/data/'
```

---

## Data

Trajectory files (`.xtc`), topology files (`.prmtop`), and raw data arrays (`.dat`, `.csv`) are **not included** in this repository due to file size. The notebooks load data via relative paths from the `BASE` variable.

To reproduce the analysis, you will need:
- AMBER topology (`.prmtop`) for each system
- Aligned trajectory files (`.xtc`) for each of the three independent runs
- Pre-computed curvature, PCA, and physical variable data files

Contact the author if you are interested in accessing the simulation data.

---

## Citation

If you use this code or analysis pipeline in your work, please cite:

```bibtex
@software{mantey2026muc2,
  author    = {Mantey, Joshua},
  title     = {MUC2 Glycosylation Analysis: MD Simulation Pipeline},
  year      = {2026},
  publisher = {GitHub},
  url       = {https://github.com/jkamantey/muc2-glycosylation-analysis},
  institution = {Northeastern University}
}
```

---

## License

This project is licensed under the **MIT License** — free to use, modify, and distribute with attribution.
See [LICENSE](LICENSE) for full details.

---

## Author

**Joshua Mantey**
Northeastern University
[mantey.j@northeastern.edu](mailto:mantey.j@northeastern.edu)

*Computational biophysics · MUC2 mucin glycobiology · Intrinsically disordered proteins · Molecular dynamics*
