# MUC2 Long PTS — Molecular Dynamics Analysis

Computational analysis of the MUC2 mucin long PTS (Pro-Thr-Ser) domain under three glycosylation states, using all-atom molecular dynamics simulations. The project investigates how O-glycosylation shapes the backbone conformation, local mechanics, and global chain properties of this intrinsically disordered region.

---

## Systems

| Label | Description | Colour |
|-------|-------------|--------|
| Non-glycosylated | Naked PTS backbone, no O-glycans | `#A23B72` |
| Mid-level Glycosylated | Partial O-glycosylation | `#2E86AB` |
| Ext. Glycosylated | Full / dense O-glycosylation | `#F18F01` |

Each system was simulated across three independent runs of 1200 ns each (3 × 1200 ns = 3600 ns total per system, 2381 frames per system at 1.2 ns/frame).

---

## Repository Structure

```
.
├── radius_of_curvature.ipynb        # Cα virtual bond-angle curvature + pre-glycan analysis
├── rmsf_comparison.ipynb            # Per-residue RMSF comparison across systems
├── plot_physical_vars.ipynb         # PCA coloured by Rg, ETE, FES, curvature, Lp
├── phi_psi_bend_analysis.ipynb      # Ramachandran scatter + bend redistribution + twist
├── persistence_length.ipynb         # Worm-like chain persistence length
├── hbond_analysis.ipynb             # Hydrogen bond analysis
├── dihedral_distribution.ipynb      # Backbone dihedral distributions
├── secondary_structure.ipynb        # DSSP secondary structure analysis
├── dccm_glyc_noglyc.ipynb           # Dynamic cross-correlation matrices
├── dccm_comparison.ipynb            # DCCM comparison across systems
├── dccm_crossnorm.ipynb             # Cross-normalised DCCM
├── pca_dccm_noglyc_domains.ipynb    # PCA + DCCM for non-glycosylated domains
├── pca_dccm_normal_domains.ipynb    # PCA + DCCM for glycosylated domains
├── pca_last400_comparison.ipynb     # PCA of last 400 ns per run
├── muc2_newsystem.ipynb             # Main PCA analysis (glyc + non-glyc)
├── muc2_noglycans.ipynb             # PCA analysis — non-glycosylated system
├── pmf_ref_formula.ipynb            # PMF (potential of mean force) — reference formula
├── pmf_corrected_formula.ipynb      # PMF — corrected formula
└── scripts/
    ├── radius_of_curvature.py       # Cα interior bond-angle curvature computation
    ├── curvature_xglyc.py           # Same — ext. glycosylated system
    ├── persistence_length_windows.py
    ├── persistence_windows_xglyc.py
    ├── fes_3sys.py                  # Free energy surface — 3 systems
    └── analysis_hbonds_3sys.py      # H-bond analysis
```

---

## Analysis Modules

### 1. Radius of Curvature & Pre-Glycan Bending
**Notebook:** `radius_of_curvature.ipynb`

Computes the **Cα interior virtual bond angle** at every internal residue position:

```
For three consecutive Cα atoms A → B → C:
  deflection = arccos( t_AB · t_BC )       [0 = straight]
  interior angle θ = 180° − deflection      [180° = straight]

  kappa_rms(site)  = sqrt( mean_frames( θ² ) )   per-residue profile
  kappa_rms(frame) = sqrt( mean_sites( θ² ) )     per-frame scalar
```

Key findings:
- 25 / 30 pre-glycan positions already show a local angle rise in the non-glycosylated chain — the sequence encodes structural hotspots at glycan sites
- The 5 non-rising sites are all **Glycine**, which acts as a conformational hinge (every 6th glycan site, matching the 6-residue tandem repeat)
- Glycosylation rescues Glycine-site kinks; Ext. glycosylation produces the largest backbone extension (+15.6° at one site)
- A subset of sites shows **bend redistribution** — some positions kink while others extend, rather than uniform stiffening

---

### 2. RMSF Comparison
**Notebook:** `rmsf_comparison.ipynb`

Per-residue root-mean-square fluctuation (RMSF) comparing all three glycosylation states. Identifies which regions of the PTS domain are stiffened or mobilised by O-glycan attachment.

---

### 3. PCA Coloured by Physical Variables
**Notebook:** `plot_physical_vars.ipynb`

Projects MD conformations onto principal components (PC1, PC2) and colours each frame by:
- Radius of gyration (Rg)
- End-to-end distance (ETE)
- RMS curvature (κ)
- Persistence length (Lp)
- Free energy surface (FES = −kT ln P)

Pearson correlations quantify which structural variables drive each PC axis.

---

### 4. Phi-Psi & Bend Redistribution Analysis
**Notebook:** `phi_psi_bend_analysis.ipynb`

Five-part analysis:
- **Part A** — Ramachandran scatter from mean PDB structures (φ/ψ per residue)
- **Part B** — Per-residue Cα bend profile with ±SE shading across systems
- **Part C** — Total summed bend comparison (tests global stiffening vs redistribution)
- **Part D** — Bend redistribution: Δbend(glyc − noglyc) along the sequence
- **Part E** — Virtual Cα dihedral (twist) profile and Δtwist

---

### 5. Persistence Length
**Notebook:** `persistence_length.ipynb`

Worm-like chain (WLC) model fit to the tangent correlation decay:
```
⟨t(0) · t(s)⟩ = exp(−s / Lp)
```
Lp computed in sliding windows along the chain and compared across glycosylation states.

---

### 6. Hydrogen Bond Analysis
**Notebook:** `hbond_analysis.ipynb`

Intra-chain and chain–water hydrogen bond occupancy as a function of glycosylation. Identifies which backbone NH / CO pairs gain or lose H-bonds upon glycan attachment.

---

### 7. Dynamic Cross-Correlation Matrices (DCCM)
**Notebooks:** `dccm_glyc_noglyc.ipynb`, `dccm_comparison.ipynb`, `dccm_crossnorm.ipynb`

Normalised covariance of Cα displacement fluctuations:
```
Cij = ⟨ΔRi · ΔRj⟩ / sqrt(⟨ΔRi²⟩⟨ΔRj²⟩)
```
Cross-normalised DCCM removes system-specific mean fluctuation magnitude, isolating correlated motion patterns.

---

### 8. Free Energy & PMF
**Notebooks:** `pmf_ref_formula.ipynb`, `pmf_corrected_formula.ipynb`

Potential of mean force along PC1/PC2 computed as:
```
F(x) = −kT ln P(x),   shifted so min(F) = 0
```
Reference and corrected versions compared to validate the FES estimate.

---

## Key Results Summary

| Property | Non-glyc | Mid-glyc | Ext. glyc |
|----------|----------|----------|-----------|
| Mean Cα bend angle (°) | ~116–120 | ~119–124 | ~122–128 |
| Pre-glycan Gly sites: Δ from non-glyc (°) | — | up to +10 | up to +16 |
| Bend redistribution | baseline | partial | strong |
| KDE distribution shape | unimodal | bimodal | bimodal / broad |

---

## Dependencies

```
Python 3.10+ (Anaconda)
numpy
scipy
matplotlib
pandas
mdanalysis (for trajectory-dependent cells)
```

Notebooks are designed to run with the **Python 3.10 (Anaconda)** kernel via Jupyter:
```bash
jupyter nbconvert --to notebook --execute \
  --ExecutePreprocessor.kernel_name=anaconda-base \
  --inplace <notebook>.ipynb
```

---

## Author

**Joshua Mantey**  
Northeastern University  
MD simulation analysis — MUC2 mucin glycobiology
