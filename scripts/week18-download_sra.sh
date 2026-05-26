
#!/bin/bash
#SBATCH --job-name=download_SRA                                       # name shown in squeue. It can be anything.
#SBATCH --output=/maps/projects/course_1/scratch/group2/group-project-group-2/logs/%x_%j.out   # stdout log. Make sure to create your logs folder
#SBATCH --error=/maps/projects/course_1/people/rsc270/logs/%x_%j.err    # stderr log
#SBATCH --ntasks=1                                               # one task (one process group)
#SBATCH --cpus-per-task=10                                       # CPUs available to that task
#SBATCH --mem-per-cpu=10G                                        # RAM per CPU (total = cpus * mem-per-cpu)
#SBATCH --time=03:00:00                                          # HH:MM:SS wall-clock limit
#SBATCH --mail-type=end                                          # email me when it finishes
#SBATCH --mail-type=fail                                         # email me if it fails
#SBATCH --mail-user=rsc270@ku.dk                        # your KU email
#SBATCH --reservation=NBIB25004U                                 # class reservation. Specific for this course. Bent reserved a node for us.
#SBATCH --account=teaching                                       # class billing account


#We will work with the following samples: 

# gut_adult: ERR2641635 ERR2641677 ERR2641733

# gut_infant: SRR8692206 SRR8692207 SRR8692213

# vaginal: SRR059458 SRR059459 SRR513791

module load sratoolkit

ACCESSION='ERR2641635'

BODYSITE='gut_adult'

THREADS='6'

RAW_DIR="/maps/projects/course_1/scratch/group2/group-project-group-2/week18-preprocessing/data"

VALIDATION_LOG=${ACCESSION}/validate.log

# 1. Download the .sra archive
prefetch ${ACCESSION} --max-size 1t -p -O ${RAW_DIR}/${BODYSITE}

# 2. Validate the download
vdb-validate ${RAW_DIR}/${BODYSITE}/${ACCESSION}/${ACCESSION}.sra > "${VALIDATION_LOG}" 2>&1

# 3. Extract to paired-end FASTQ
fasterq-dump ${RAW_DIR}/${BODYSITE}/${ACCESSION}/${ACCESSION}.sra \
    -e ${THREADS} \
    -O ${RAW_DIR}/${BODYSITE}/${ACCESSION} \
    -p