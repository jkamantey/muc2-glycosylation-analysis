# MUC2 Long PTS — Biophysical & Ligand Interaction Analysis

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/)
[![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-red.svg)]()

Open-source computational pipeline for analysing the **MUC2 mucin long PTS (Pro-Thr-Ser) domain** — covering its intrinsic biophysical and polymer properties, and how those properties change upon **O-glycosylation** and **ligand interactions**.

---

## Overview

MUC2 is the primary gel-forming mucin of the intestinal mucus layer. Its long PTS domain is a tandem-repeat intrinsically disordered region (IDR) densely decorated with O-linked glycans. Understanding how glycosylation reshapes the backbone mechanics of MUC2 — and how those structural changes affect how the chain interacts with ligands (e.g. bile salts, lectins, pathogens) — is central to understanding mucus barrier function.

This repository provides a complete, reproducible analysis workflow structured in two stages:

### Stage 1 — Biophysical characterisation of MUC2
Establish the intrinsic structural and dynamical properties of the MUC2 PTS backbone across three glycosylation states. This includes chain dimensions, local flexibility, curvature, backbone dihedral distributions, correlated motions, and the free energy landscape.

### Stage 2 — How polymer properties change with glycosylation and ligand interaction
Quantify how O-glycosylation progressively reshapes those properties — stiffening the chain, redistributing local bends, altering correlated motions — and sets the stage for probing how the glycosylated chain interacts with ligands differently from the naked backbone.

---

## Systems

| Label | Description | Colour code |
|-------|-------------|-------------|
| Non-glycosylated | Naked PTS backbone — no O-glycans | `#A23B72` |
| Mid-level Glycosylated | Partial O-glycosylation | `#2E86AB` |
| Ext. Glycosylated | Full / dense O-glycosylation | `#F18F01` |

Each system: **3 independent MD runs × 1200 ns = 3600 ns total**, 2381 frames per system at 1.2 ns/frame. Simulations performed with the AMBER force field in explicit solvent.

---

## Repository Structure

```
.
├── README.md
│
├── ── Stage 1: Biophysical Properties ──────────────────────────────
│
├── radius_of_curvature.ipynb        # Cα virtual bond-angle curvature analysis
├── rmsf_comparison.ipynb            # Per-residue flexibility (RMSF)
├── plot_physical_vars.ipynb         # PCA coloured by Rg, ETE, curvature, Lp, FES
├── persistence_length.ipynb         # Worm-like chain persistence length
├── secondary_structure.ipynb        # DSSP secondary structure across systems
├── dihedral_distribution.ipynb      # Backbone φ/ψ dihedral distributions
├── phi_psi_bend_analysis.ipynb      # Ramachandran + bend redistribution + twist
│
├── ── Stage 2: Dynamics, Correlations & Interactions ───────────────
│
├── dccm_glyc_noglyc.ipynb           # Dynamic cross-correlation matrices (DCCM)
├── dccm_comparison.ipynb            # DCCM comparison across all three systems
├── dccm_crossnorm.ipynb             # Cross-normalised DCCM
├── hbond_analysis.ipynb             # Hydrogen bond analysis (chain + solvent)
├── pmf_ref_formula.ipynb            # Potential of mean force — reference formula
├── pmf_corrected_formula.ipynb      # PMF — corrected formula
│
├── ── PCA & Conformational Sampling ────────────────────────────────
│
├── muc2_newsystem.ipynb             # Main PCA (glyc + non-glyc combined)
├── muc2_noglycans.ipynb             # PCA — non-glycosylated system
├── pca_dccm_noglyc_domains.ipynb    # PCA + DCCM per domain (non-glyc)
├── pca_dccm_normal_domains.ipynb    # PCA + DCCM per domain (glyc)
├── pca_last400_comparison.ipynb     # PCA of last 400 ns — convergence check
│
└── ── Analysis Scripts ─────────────────────────────────────────────
    ├── radius_of_curvature/radius_of_curvature.py
    ├── curvature_xglyc/curvature_xglyc.py
    ├── persistence_length/persistence_length_windows.py
    ├── persistence_length_xglyc/persistence_windows_xglyc.py
    ├── free_energy_surface/fes_3sys.py
    ├── hbond_analysis/analysis_hbonds_3sys.py
    └── run_physical_vars.sh
```

---

## Stage 1 — Biophysical Properties

### Radius of Curvature & Pre-Glycan Bending
**Notebook:** `radius_of_curvature.ipynb`

The core structural analysis. Computes the **Cα interior virtual bond angle** at every internal residue — a direct measure of local backbone bending:

```
For three consecutive Cα atoms A → B → C:
  deflection    = arccos( t_AB · t_BC )      [0° = straight, 180° = folded back]
  interior angle θ = 180° − deflection        [180° = straight, ~0° = sharp kink]

  kappa_rms(site)  = sqrt( mean_frames( θ² ) )   per-residue bending profile
  kappa_rms(frame) = sqrt( mean_sites( θ² ) )     per-frame scalar
```

**Key findings:**
- 25 / 30 pre-glycan positions already form a local bending peak in the **non-glycosylated** chain — the amino acid sequence encodes structural hotspots at glycan attachment sites before any glycan is added
- The 5 non-rising sites are all **Glycine (GLY)**, the only amino acid with no side chain, acting as a conformational hinge — each falling at position 6 of the 6-residue tandem repeat unit
- Glycosylation rescues Glycine-site kinks; extensive glycosylation produces the largest backbone extension (up to **+15.6°** at a single site)
- Bimodal angle distributions emerge with glycosylation, indicating **conformational switching** between two distinct backbone states rather than a simple global stiffening
- A subset of sites shows **bend redistribution**: some positions become more extended while others become more kinked, confirming that glycosylation reorganises rather than uniformly stiffens the chain

---

### RMSF — Per-Residue Flexibility
**Notebook:** `rmsf_comparison.ipynb`

Root-mean-square fluctuation (RMSF) of each Cα position, comparing all three glycosylation states. Identifies which regions of the PTS domain are dynamically stiffened or mobilised by O-glycan attachment and highlights sequence-position dependence of the glycan effect on local dynamics.

---

### PCA Coloured by Physical Variables
**Notebook:** `plot_physical_vars.ipynb`

Projects all MD conformations onto principal components (PC1, PC2) and colours each frame by:

| Variable | Physical meaning |
|----------|-----------------|
| Radius of gyration (Rg) | Overall chain compactness |
| End-to-end distance (ETE) | Global chain extension |
| RMS curvature (κ) | Mean local bending |
| Persistence length (Lp) | Chain stiffness |
| Free energy (FES) | Conformational stability |

Pearson correlations quantify which variables drive each PC axis. PC1 is strongly correlated with Rg and ETE — it encodes the extension/compaction axis. PC2 captures internal redistribution of bending without changing overall dimensions.

---

### Persistence Length — Chain Stiffness
**Notebook:** `persistence_length.ipynb`

Fits the worm-like chain (WLC) tangent correlation decay:
```
⟨t(0) · t(s)⟩ = exp(−s / Lp)
```
Lp computed in sliding windows along the chain. Increasing glycosylation increases Lp, confirming the bottlebrush stiffening mechanism. Comparison across systems quantifies how much each level of glycosylation contributes to chain rigidity.

---

### Secondary Structure
**Notebook:** `secondary_structure.ipynb`

DSSP-based secondary structure classification per residue per frame. MUC2 PTS is predominantly unstructured (coil/PPII) — this analysis tracks whether glycosylation shifts the secondary structure content, particularly at proline-rich repeat positions.

---

### Backbone Dihedral Distribution
**Notebook:** `dihedral_distribution.ipynb`

φ/ψ backbone dihedral distributions across the full trajectory. Identifies the dominant conformational basins and how glycosylation shifts the population between extended (PPII/β) and other states.

---

### Phi-Psi & Bend Redistribution Analysis
**Notebook:** `phi_psi_bend_analysis.ipynb`

Five-part analysis combining backbone angles and curvature data:

| Part | Analysis | Output |
|------|----------|--------|
| A | Ramachandran scatter from mean PDB structures | φ/ψ per residue, all systems |
| B | Per-residue Cα bend profile with ±SE | Bend profile comparison |
| C | Total summed bend — tests global vs redistributed stiffening | Bar chart |
| D | Δbend(glyc − noglyc) along sequence — redistribution map | Signed bar profile |
| E | Virtual Cα dihedral (twist) profile and Δtwist | Twist comparison |

---

## Stage 2 — Dynamics, Correlations & Ligand Interactions

### Hydrogen Bond Analysis
**Notebook:** `hbond_analysis.ipynb`

Intra-chain and chain–solvent hydrogen bond occupancy as a function of glycosylation. Identifies backbone NH/CO pairs that gain or lose H-bonds when glycans are attached. This provides a direct molecular-level view of how glycosylation rewires the local interaction network — relevant to how accessible backbone donors/acceptors are for ligand binding.

---

### Dynamic Cross-Correlation Matrices (DCCM)
**Notebooks:** `dccm_glyc_noglyc.ipynb`, `dccm_comparison.ipynb`, `dccm_crossnorm.ipynb`

Normalised covariance of Cα displacement fluctuations:
```
Cij = ⟨ΔRi · ΔRj⟩ / sqrt( ⟨ΔRi²⟩ ⟨ΔRj²⟩ )
```
Values range from −1 (perfectly anti-correlated) to +1 (perfectly correlated). Cross-normalised DCCM removes system-specific fluctuation magnitude, isolating changes in correlated motion patterns caused by glycosylation. Long-range correlated motions have direct implications for allosteric ligand effects — a ligand binding at one site can propagate its effect along the chain through these correlations.

---

### Free Energy Surface & PMF
**Notebooks:** `pmf_ref_formula.ipynb`, `pmf_corrected_formula.ipynb`

Potential of mean force along PC1/PC2:
```
F(x) = −kT ln P(x),   shifted so min(F) = 0
```
Identifies the most thermodynamically stable conformations and the barriers between them. For ligand interaction studies, low free energy states represent the most likely conformations a ligand will encounter — making this a prerequisite for understanding binding geometry.

---

### PCA & Conformational Sampling
**Notebooks:** `muc2_newsystem.ipynb`, `muc2_noglycans.ipynb`, `pca_dccm_noglyc_domains.ipynb`, `pca_dccm_normal_domains.ipynb`, `pca_last400_comparison.ipynb`

Principal component analysis of combined trajectories. The shared PCA space allows direct comparison of which conformations are sampled by each glycosylation state, and whether the systems converge to the same free energy minima.

---

## Key Results Summary

| Property | Non-glyc | Mid-glyc | Ext. glyc |
|----------|----------|----------|-----------|
| Mean Cα bend (°) | ~116–120 | ~119–124 | ~122–128 |
| Gly-site Δ angle (°) | baseline | up to +10 | up to +16 |
| Angle distribution | unimodal, narrow | bimodal, broader | bimodal, broad |
| Bend pattern | uniform | partial redistribution | strong redistribution |
| Chain stiffness (Lp) | lowest | intermediate | highest |

---

## Installation & Dependencies

```bash
# Clone the repository
git clone https://github.com/jkamantey/muc2-pts-md-analysis.git
cd muc2-pts-md-analysis

# Create environment (Anaconda recommended)
conda create -n muc2_analysis python=3.10
conda activate muc2_analysis

# Install dependencies
pip install numpy scipy matplotlib pandas jupyter mdanalysis
```

Run any notebook with:
```bash
jupyter nbconvert --to notebook --execute \
  --ExecutePreprocessor.kernel_name=anaconda-base \
  --inplace <notebook>.ipynb
```

Or open interactively:
```bash
jupyter notebook
```

---

## Data

Trajectory data (`.xtc`, `.dat`, `.prmtop`) are not included in this repository due to file size. The notebooks are structured to load data from relative paths — update the `BASE` path variable at the top of each notebook to point to your local data directory.

---

## Citation

If you use this code or analysis pipeline in your work, please cite:

```
Mantey, J. (2026). MUC2 Long PTS MD Analysis Pipeline.
GitHub: https://github.com/jkamantey/muc2-pts-md-analysis
Northeastern University.
```

---

## License

This project is licensed under the **MIT License** — free to use, modify, and distribute with attribution. See [LICENSE](LICENSE) for details.

---

## Author

**Joshua Mantey**
Northeastern University
[mantey.j@northeastern.edu](mailto:mantey.j@northeastern.edu)

Computational biophysics — MUC2 mucin glycobiology, intrinsically disordered proteins, molecular dynamics simulation analysis.
