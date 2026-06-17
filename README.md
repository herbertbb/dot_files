# dot_files

Configuraciones personales para mis entornos Linux (viper, goose, ubu, maverick).

## Herramientas incluidas

| Herramienta | Archivo | Destino |
|-------------|---------|---------|
| **Neovim** | `nvim/init.lua` + `nvim/lazy-lock.json` | `~/.config/nvim/` |
| **Zellij** | `zellij/config.kdl` | `~/.config/zellij/` |
| **tmux** | `tmux/.tmux.conf` | `~/.tmux.conf` |
| **WezTerm** | `wezterm/wezterm.lua` | `~/.wezterm.lua` |
| **Starship** | `starship/starship.toml` | `~/.config/starship.toml` |
| **Bash** | `bash/.bash_aliases` | `~/.bash_aliases` |

## Instalación

```bash
git clone <url-del-repo> ~/dot_files
cd ~/dot_files
bash install.sh
```

Esto:
1. Descarga e instala **JetBrainsMono Nerd Font** en `~/.local/share/fonts/`
2. Crea enlaces simbólicos de cada configuración a su ubicación correspondiente

## Requisitos

- **Nerd Font**: Necesaria para ver iconos en Neovim (nvim-web-devicons), tmux status bar y Zellij. El `install.sh` la descarga automáticamente, pero tu terminal debe estar configurada para usarla (WezTerm ya lo está).

### Por herramienta

- **Neovim 0.12+**: Los plugins se instalan automáticamente con lazy.nvim al abrir Neovim por primera vez.
- **Zellij 0.40+**: La configuración incluye keybindings personalizados.
- **tmux**: Requiere tmux 3.3+ para los terminal-overrides.
- **WezTerm**: Configuración pensada para el cliente principal (maverick/Windows).

## Estructura

```
dot_files/
├── bash/
│   └── .bash_aliases
├── nvim/
│   ├── init.lua
│   └── lazy-lock.json
├── starship/
│   └── starship.toml
├── tmux/
│   └── .tmux.conf
├── wezterm/
│   └── wezterm.lua
├── zellij/
│   └── config.kdl
├── install.sh
└── README.md
```

## Notas

- Los archivos originales se reemplazan por symlinks. Si ya tenías configuraciones previas, el `install.sh` las elimina antes de crear el enlace.
- Para agregar una nueva herramienta: crear su carpeta en `dot_files/`, colocar la configuración, agregar `link_file` en `install.sh` y commit.
