### Finds or creates iteractive job
JOB_NAME="👋-dhei-interact"

# Fast path: if the job is already running, print its node with a single squeue call.
node=$(squeue -h -u "$USER" -n "$JOB_NAME" -t R -o "%N" | head -1)
if [[ -n "$node" && "$node" != "(null)" ]]; then
    echo "$node"
    exit 0
fi

# Check for an existing running job.
job_id=$(squeue -h -u "$USER" -n "$JOB_NAME" -t R -o "%i" | head -1)

# If no running job exists, check for a pending one.
if [[ -z "$job_id" ]]; then
    job_id=$(squeue -h -u "$USER" -n "$JOB_NAME" -t PD -o "%i" | head -1)
fi

# If neither exists, submit a new job.
if [[ -z "$job_id" ]]; then
    job_id=$(sbatch --parsable \
        --account=nlp \
        --partition=sc-loprio \
        --job-name="$JOB_NAME" \
        --wrap="sleep infinity")

    echo "Submitted Slurm job $job_id" >&2
fi

# Wait until the job is running.
while true; do
    hostname=$(squeue -h -j "$job_id" -t R -o "%N")

    if [[ -n "$hostname" && "$hostname" != "(null)" ]]; then
        echo "$hostname"
        break
    fi

    if ! squeue -h -j "$job_id" | grep -q .; then
        echo "Job $job_id is no longer queued." >&2
        exit 1
    fi

    sleep 2
done