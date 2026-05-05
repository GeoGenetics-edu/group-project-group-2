#!/bin/bash
#SBATCH --job-name=Bakta
#SBATCH --output=/maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/"%x_%j".out   # stdout log. Make sure to create your logs folder
#SBATCH --error=/maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/"%x_%j".err    # stderr log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=6G
#SBATCH --time=10:00:00
#SBATCH --mail-type=end                                          # email me when it finishes
#SBATCH --mail-type=fail                                         # email me if it fails
#SBATCH --mail-user=rsc270@alumni.ku.dk                          # your KU email
#SBATCH --reservation=NBIB25004U                                 # class reservation. Specific for this course. Bent reserved a node for us.
#SBATCH --account=teaching                                       # class billing account

# In class: run on the three shared reference genomes.
# After class: swap to your HQ MAGs and drop the _ref suffix:
#   INPUT_DIR="/maps/projects/course_1/scratch/<group_#>/<group-project-group-#>/07_1_hq_mags/"
#   OUT_DIR="/maps/projects/course_1/scratch/<group_#>/<group-project-group-#>/09_annotation_bakta/"

INPUT_DIR="/maps/projects/course_1/data/ref_genomes"
OUT_DIR="/maps/projects/course_1/scratch/group2/09_annotation_bakta_ref/"
DB="/maps/projects/course_1/data/bakta_db_light"

export PATH=/opt/shared_software/shared_envmodules/conda/bakta-1.11.3/bin:$PATH

bakta --version
command -v bakta >/dev/null 2>&1 || {
    echo "ERROR: 'bakta' not found in PATH." >&2
    exit 1
}

echo "Checking inputs..."
[[ -d "$INPUT_DIR" ]] || { echo "❌ Missing directory: $INPUT_DIR"; exit 1; }
[[ -d "$DB" ]]        || { echo "❌ Missing directory: $DB"; exit 1; }
echo "✅ Inputs look good"

# Create output directory
mkdir -p "$OUT_DIR"

#Collect input genomes
mapfile -t BINS < <(ls "$INPUT_DIR"/*.fa 2>/dev/null | sort)
[[ "${#BINS[@]}" -gt 0 ]] || { echo "❌ No .fa genome files found in $INPUT_DIR"; exit 1; }

# Print run summary
echo "=========================================="
echo "Running Bakta..."
echo "Input:    $INPUT_DIR"
echo "Output:   $OUT_DIR"
echo "Database: $DB"
echo "Genomes:  ${#BINS[@]}"
echo "=========================================="

# Loop over genomes and run Bakta
for bin in "${BINS[@]}"; do
    sample=$(basename "$bin" .fa)
    sample_out="$OUT_DIR/$sample"

    # Skip if already annotated
    if [[ -s "$sample_out/$sample.gff3" ]]; then
        echo "[$sample] Already annotated — skipping."
        continue
    fi

    mkdir -p "$sample_out"
    echo "[$sample] Annotating..."

    bakta \
        --threads 6 \
        --db "$DB" \
        --compliant \
        --verbose \
        --force \
        --prefix "$sample" \
        --output "$sample_out" \
        "$bin"

    echo "[$sample] Done"
done

echo "Done."