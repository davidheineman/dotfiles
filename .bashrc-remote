# Note: this is my .bashrc for remote SSH servers

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/srv/nlprx-lab/share6/dheineman3/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/srv/nlprx-lab/share6/dheineman3/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/srv/nlprx-lab/share6/dheineman3/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/srv/nlprx-lab/share6/dheineman3/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Add NVCC to path
export PATH=/usr/local/cuda/bin:$PATH

# CLI color coding
PS1_RESET='\[\e[0m\]'
PS1_BOLD='\[\e[1m\]'
PS1_DIM='\[\e[2m\]'
PS1_UNDERLINE='\[\e[4m\]'
PS1_BLACK_WHITE='\[\e[0;30m\]'
PS1_WHITE_BLACK='\[\e[97m\]'
PS1_CYAN_BLACK='\[\e[36m\]'
PS1_GREEN_BLACK='\[\e[32m\]'
export PS1="${PS1_CYAN_BLACK}${PS1_BOLD}\u${PS1_DIM}@${PS1_BOLD}\h ${PS1_RESET}${PS1_GREEN_BLACK}${PS1_BOLD}\w${PS1_RESET}$ ${PS1_RESET}"
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export force_color_prompt=yes

# Change HF caches
export HF_DATASETS_CACHE="/srv/nlprx-lab/share6/dheineman3/.cache/huggingface/datasets"
# export TRANSFORMERS_CACHE="/srv/nlprx-lab/share6/dheineman3/.cache/huggingface/hub"
export HUGGINGFACE_HUB_CACHE="/srv/nlprx-lab/share6/dheineman3/.cache/huggingface/hub"
export HF_HOME="/srv/nlprx-lab/share6/dheineman3/.cache/huggingface/hub"

# Secrets (shhhh)
export HF_TOKEN="..." # <- Read/Write Token
export OPENAI_API_KEY="..."

# Change terminal formatting to UTF-8 for Python
export PYTHONIOENCODING=utf8

# Make shared drive my default directory
cd /nethome/dheineman3/nlprx

# Fix for multiple torchrun processes
export NCCL_P2P_DISABLE=1

# Custom aliases
alias sq="squeue | grep dhei"
alias sqnlp="squeue | grep nlprx"
alias gu="gpu_usage -l"
alias rgpu="srun --gpus-per-node=1 -p debug -J bash --pty bash"
alias ra40="srun --constraint=a40 --gpus-per-node=8 -p long -t 72:00:00 -J train --pty bash"
alias vgpu="gpus_users -v"
alias pskill="ps aux | grep dheine | grep nlprx | awk '{print $2}' | xargs kill"
alias psall="ps aux | grep dheine | grep nlprx"

# Add slurm utils
if [ -f ~/slurm_usage_utils/gpus_users.bashrc ]; then
    . ~/slurm_usage_utils/gpus_users.bashrc
fi