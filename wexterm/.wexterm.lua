local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()

--  ========= Imagen de Fondo ==========
config.window_background_image = wezterm.config_dir .. '/guardian.png'
-- Ligero desenfoque de fondo
config.window_background_image_hsb = {
  brightness = 0.995,
  hue = 1.0,
  saturation = 1.0,
}
-- Cantidad de Scroll que se puede retroceder
config.scrollback_lines = 50000
-- capa de fondo para que la imagen no se vea tan fuerte y se pueda leer el texto
config.window_background_opacity = 0.989

-- ========== Apariencia y Tema ==========
config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font",
  "Cascadia Mono PL",
  "FiraCode Nerd Font",
  "JetBrainsMonoNL",
})
config.font_size = 8
config.line_height = 0.9

config.colors = {
  foreground = "#D9E0EE",
  background = "#061C2E",
  cursor_bg = "#00E091",
  cursor_border = "#00E091",
  cursor_fg = "#061C2E",
  selection_bg = "#26324a", -- azul oscuro grisáceo, poco saturado
  selection_fg = "#e0e6ee",

  ansi =   { "#181A21", "#FF5454", "#52FFA0", "#FFF273", "#4169e1", "#A277FF", "#1e90ff", "#F1F1F1" },
  brights={ "#232634", "#FF5454", "#52FFA0", "#FFF273", "#3b5b84", "#A277FF", "#4a7bb7", "#eaeaea" },



  split = "#2381A9",

  tab_bar = {
    background = "#01203A",
    active_tab = {
      bg_color = "#0EA7A7",
      fg_color = "#002733",
      intensity = "Bold",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = "#091B2B",
      fg_color = "#80C8FF",
    },
    inactive_tab_hover = {
      bg_color = "#17395C",
      fg_color = "#FFE48B",
      italic = true,
    },
    new_tab = {
      bg_color = "#233554",
      fg_color = "#33FFE4",
    },
    new_tab_hover = {
      bg_color = "#235D65",
      fg_color = "#C1E9F7",
      italic = true,
    },
  },
}

config.window_decorations = "RESIZE"
config.window_frame = {
  border_left_width = 1,
  border_right_width = 1,
  border_bottom_height = 1,
  border_top_height = 1,
  border_left_color = "#0EA7A7",
  border_right_color = "#0EA7A7",
  border_bottom_color = "#233554",
  border_top_color = "#0EA7A7",
  font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "Cascadia Mono PL" }),
  font_size = 8,
}
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500
config.initial_cols = 120
config.initial_rows = 28
config.macos_window_background_blur = 10

-- ========== Shells ==========
if wezterm.target_triple:find("windows") then
  config.default_prog = { 'pwsh.exe', '-NoLogo' }
  config.launch_menu = { ... }
else
  config.default_prog = { 'bash' }
  config.launch_menu = { { label = 'bash', args = { 'bash' } } }
end
-- ========== Mouse ==========
config.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = "Left" } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor 'SemanticZone',
  },

}


-- ========== Keybindings estilo tmux ==========
config.disable_default_key_bindings = true
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 3000 }

config.keys = {
  -- Copy mode
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },

  -- Nueva pestaña
  { key = 't', mods = 'LEADER|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 't', mods = 'CTRL', action = act.SpawnTab 'DefaultDomain' },

  -- Cerrar pestaña
  { key = 'w', mods = 'LEADER|CTRL', action = act.CloseCurrentTab { confirm = true } },
  { key = 'w', mods = 'CTRL', action = act.CloseCurrentTab { confirm = true } },
  { key = '&', mods = 'LEADER|SHIFT', action = act.CloseCurrentTab{ confirm = true }, description = 'Cerrar pestaña' },

  -- Navegar pestañas
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },

  -- Dividir ventanas
  { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Zoom pane
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- Rotar paneles
  { key = 'Space', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
  { key = 'Backspace', mods = 'LEADER', action = act.RotatePanes 'CounterClockwise' },

  -- Moverse entre paneles
  { key = 'LeftArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },

  -- Mostrar navegador de pestañas
  { key = 'w', mods = 'LEADER', action = act.ShowTabNavigator, description = 'Mostrar el navegador de pestañas' },

  -- Renombrar pestaña
  { key = ',', mods = 'LEADER', action = act.PromptInputLine {
      description = 'Introduce el nuevo nombre para la pestaña',
      action = wezterm.action_callback(function(window, pane, line)
        if line then window:active_tab():set_title(line) end
      end)
    }
  },

  -- Copiar y pegar
  {
    key = 'c',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      if sel and #sel > 0 then
        window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
      end
    end),
  },
  {
    key = 'v',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(act.PasteFrom 'Clipboard', pane)
    end),
  },

  -- Buscar texto
  { key = 'f', mods = 'LEADER', action = act.ActivateCommandPalette, description = 'Buscar texto' },
  { key = 'P', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette, description = 'Buscar texto' },

  -- Cambiar tamaño de panel con Alt + flechas
{ key = "LeftArrow",  mods = "ALT", action = act.AdjustPaneSize { "Left", 5 } },
{ key = "RightArrow", mods = "ALT", action = act.AdjustPaneSize { "Right", 5 } },
{ key = "UpArrow",    mods = "ALT", action = act.AdjustPaneSize { "Up", 3 } },
{ key = "DownArrow",  mods = "ALT", action = act.AdjustPaneSize { "Down", 3 } },

-- atajos para zoom de fuente
{ key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
{ key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
{ key = '0', mods = 'CTRL', action = act.ResetFontSize },


}

-- Enviar comando a todos los panes
table.insert(config.keys, {
  key = '.', mods = 'LEADER',
  action = act.PromptInputLine {
    description = 'Enviar comando a todos los panes:',
    action = wezterm.action_callback(function(window, pane, line)
      if line and #line > 0 then
        local cmd = line .. "\r"
        for _, p in ipairs(pane:tab():panes()) do
          p:send_text(cmd)
        end
      end
    end),
  },
})

config.switch_to_last_active_tab_when_closing_tab = true


-- Limpiar pegado automáticamente
wezterm.on("paste", function(window, pane, text)
  text = text:gsub("\r", ""):gsub("\0", "")
  pane:send_text(text)
end)

-- ========== Status Bar Powerline Style ==========
local function segments_for_right_status(window)
  return {
    window:active_workspace(),
    wezterm.strftime('%a %b %-d %H:%M'),
    wezterm.hostname(),
    "🗂️  " .. window:active_workspace(),
    "🕒 " .. wezterm.strftime('%a %b %-d %H:%M'),
    "💻 " .. wezterm.hostname(),
  }
end

wezterm.on('update-status', function(window, _)
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  local segments = segments_for_right_status(window)

  local color_scheme = window:effective_config().resolved_palette
  local bg = wezterm.color.parse(color_scheme.background)
  local fg = color_scheme.foreground

  local is_dark = bg:lightness() < 0.5
  local gradient_to = bg
  local gradient_from = is_dark and gradient_to:lighten(0.2) or gradient_to:darken(0.2)

  local function lerp_color(from, to, t)
    return from:lerp(to, t)
  end

  local n = #segments
  local gradient = {}
  for i = 1, n do
    gradient[i] = lerp_color(gradient_from, gradient_to, (i-1)/(n-1))
  end

  local elements = {}

  for i, seg in ipairs(segments) do
    if i == 1 then
      table.insert(elements, { Background = { Color = 'none' } })
    end
    table.insert(elements, { Foreground = { Color = gradient[i]:to_hex() } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })
    table.insert(elements, { Foreground = { Color = fg } })
    table.insert(elements, { Background = { Color = gradient[i]:to_hex() } })
    table.insert(elements, { Text = ' ' .. seg .. ' ' })
  end

  window:set_right_status(wezterm.format(elements))
end)

-- ========== Maximizar al Inicio ==========
wezterm.on('gui-startup', function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

return config
