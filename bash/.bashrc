# ~/.bashrc (gestionado desde dot_files/bash/.bashrc)

# Cargar alias personalizados
if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

# Inicializar Starship si está instalado
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
