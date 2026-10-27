#!/bin/bash
#SBATCH --job-name=physical_vars
#SBATCH --output=physical_vars.out
#SBATCH --error=physical_vars.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --partition=shared          # change to your cluster partition

# ── Load modules (adjust to what your cluster provides) ──────────────────────
module load anaconda3                # or: module load python

# ── Activate your environment if needed ──────────────────────────────────────
# conda activate myenv               # uncomment and set your env name

# ── Run ──────────────────────────────────────────────────────────────────────
python pca_color_physical.py
