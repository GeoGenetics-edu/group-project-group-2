#!/bin/bash
#SBATCH --job-name=antiSMASH
#SBATCH --output=/maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/"%x_%j".out
#SBATCH --error=/maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/"%x_%j".err
#SBATCH --nodelist=mjolnircomp16f
#SBATCH --reservation=NBIB25004U
#SBATCH --account=teaching
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=00:30:00
#SBATCH --mail-type=end                                          # email me when it finishes
#SBATCH --mail-type=fail                                         # email me if it fails
#SBATCH --mail-user=rsc270@ku.dk  


# Step 2 — Load the antiSMASH environment
module purge
module load antismash/8.0.1

# Loop
for sample in Lactobacillus_crispatus Bifidobacterium_infantis Bacteroides_thetaiotaomicron; do
    INPUT="/maps/projects/course_/scratch/group2/09_annotation_bakta_ref/${sample}/${sample}.gbff"
    OUTDIR="/maps/projects/course_1/scratch/group2/11_annotation_BGC_ref/${sample}"
    mkdir -p "${OUTDIR}"
    echo "Starting antiSMASH annotation for ${sample}"
    antismash --genefinding-tool none --cpus 8 --cb-knownclusters \
              --cb-subclusters --asf --rre --tfbs \
              --output-dir "${OUTDIR}" "${INPUT}"
    echo "Done with ${sample}"
done
