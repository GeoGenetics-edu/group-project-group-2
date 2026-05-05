#!/bin/bash
#SBATCH --job-name=gtdbtk
#SBATCH --output=/maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/"%x_%j".out   # stdout log. Make sure to create your logs folder
#SBATCH --error=/maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/"%x_%j".err    # stderr log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem-per-cpu=6G         # GTDB-Tk R232 requires ≥140 GB RAM (30*6=180 GB)
#SBATCH --time=10:00:00
#SBATCH --mail-type=end                                          # email me when it finishes
#SBATCH --mail-type=fail                                         # email me if it fails
#SBATCH --mail-user=rsc270@alumni.ku.dk                          # your KU email
#SBATCH --reservation=NBIB25004U                                 # class reservation. Specific for this course. Bent reserved a node for us.
#SBATCH --account=teaching                                       # class billing account

module purge
module load gtdbtk/2.7.1
gtdbtk --version
set -euo pipefail


# MAGS_DIR="/maps/projects/course_1/scratch/group2/07_all_hq_mags/"
# CHECKM2_file="/maps/projects/course_1/scratch/group2/06_quality_checkm2/quality_report.tsv"
# HQ_DIR="/maps/projects/course_1/scratch/group2/group-project-group-2/07_1_hq_mags/"
# EXTENSION="fa"

INPUT_DIR="/maps/projects/course_1/scratch/group2/07_1_hq_mags/"
OUT_DIR="/maps/projects/course_1/scratch/group2/08_gtdbtk/"
DB="/maps/projects/course_1/data/gtdb232/release232"

#Load GTDB-Tk environment
export PATH=/opt/shared_software/shared_envmodules/conda/gtdbtk-2.7.1/bin:$PATH
export GTDBTK_DATA_PATH="$DB"

#Check GTDB-Tk installation
command -v gtdbtk >/dev/null 2>&1 || {
    echo "ERROR: 'gtdbtk' not found in PATH." >&2
    exit 1
}
gtdbtk --version 

# Check inputs
echo "Check inputs"
[[ -d "$INPUT_DIR" ]] || { echo "❌ Missing input dir"; exit 1; }
[[ -d "$DB" ]] || { echo "❌ Missing GTDB database"; exit 1; }

# Make output dir
mkdir -p "$OUT_DIR"

# Print summary
echo "Running GTDB-Tk..."
echo "Input:  $INPUT_DIR"
echo "Output: $OUT_DIR"

# Run classification
gtdbtk classify_wf \
    --genome_dir "$INPUT_DIR" \
    --out_dir "$OUT_DIR" \
    --cpus 30 \
    --extension fa \
    --place_species
echo "Done."