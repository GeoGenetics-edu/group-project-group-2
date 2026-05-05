#!/bin/bash
#SBATCH --job-name=gtdbtk
#SBATCH --output=/maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/"%x_%j".out   # stdout log. Make sure to create your logs folder
#SBATCH --error=/maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/"%x_%j".err    # stderr log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem-per-cpu=6G         # GTDB-Tk R232 requires ≥140 GB RAM (30*6=180 GB)
#SBATCH --time=00:30:00
#SBATCH --mail-type=end                                          # email me when it finishes
#SBATCH --mail-type=fail                                         # email me if it fails
#SBATCH --mail-user=rsc270@alumni.ku.dk                          # your KU email
#SBATCH --reservation=NBIB25004U                                 # class reservation. Specific for this course. Bent reserved a node for us.
#SBATCH --account=teaching                                       # class billing account

touch /maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/test.txt

echo "hello world" > /maps/projects/course_1/scratch/group2/group-project-group-2/week19-mags/logs/test.txt