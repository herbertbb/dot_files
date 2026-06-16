# ~/.bash_aliases (gestionado desde dot_files/bash/.bash_aliases)

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Selector inteligente de editor
if command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim'
    export VISUAL='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR='vim'
    export VISUAL='vim'
else
    export EDITOR='nano'
    export VISUAL='nano'
fi

alias fd='fdfind'

# Alias rápido para no escribir nvim o vim cada vez
alias v='$EDITOR'


alias ch-on='sudo systemctl start clickhouse-server && sleep 5 && clickhouse-client --query "SELECT version()"'
alias ch-off='sudo systemctl stop clickhouse-server'

alias z='zellij'

alias gemma='ollama launch opencode --model gemma4:31b-cloud'
