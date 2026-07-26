# System theme synchronization

This setup keeps WezTerm, tmux, and Codex synchronized with the macOS light or
dark appearance. No manual action is required when entering or leaving tmux.

## TL;DR: why Codex looks broken after a theme switch

There are three separate layers:

| Layer | What happens after macOS changes theme |
| --- | --- |
| WezTerm | Changes its palette immediately. |
| tmux | The watcher applies matching pane and status-bar colors. |
| Codex | Refreshes live UI, but cannot redraw completed output in terminal scrollback. |

Codex does not own a fully redrawable transcript. Once a message or diff is
printed, it becomes ordinary terminal scrollback. A dark-mode diff therefore
keeps its dark green RGB background if macOS changes to light mode afterward.
The composer can already be light while older output above it is still dark.

The refresh signals in this setup fix Codex's current color cache and all new
live UI. They cannot rewrite terminal history that has already been printed.
This is a Codex rendering limitation, not a remaining WezTerm or tmux theme
problem.

To make the complete transcript use the current appearance, exit Codex and
resume the conversation. Codex replays the history and renders it again:

```sh
# Make sure macOS is already using the desired appearance.
c resume
```

Launching `c` and then choosing `/resume` does the same thing. Merely
detaching from and reattaching to tmux does not help because tmux preserves the
existing scrollback.

It is possible to remove every background with `FORCE_COLOR=1`, but that also
removes useful Codex UI boxes. This configuration deliberately keeps the boxes
and accepts that already-printed output cannot change color in place.

## Signal flow

```text
macOS appearance
├── WezTerm config reload
│   ├── selects the matching WezTerm color scheme
│   └── tells a directly running Codex process to re-query terminal colors
└── dark-notify
    └── tmux-theme-watcher
        └── tmux-theme light|dark
            ├── applies the matching tmux status and pane colors
            └── tells every Codex pane to re-query terminal colors
```

## Why Codex needs a refresh

Codex queries the terminal's default foreground and background using OSC 10
and OSC 11. It caches the result and normally refreshes it on a focus-gained
event.

Changing the macOS appearance reloads WezTerm's colors without changing window
focus. Without an extra focus-gained event, an existing Codex session keeps
using its previous cached background. This produces a light composer on a dark
terminal, or a dark composer on a light terminal.

### Codex directly in WezTerm

`.config/wezterm/wezterm.lua` listens for `window-config-reloaded`. When Codex
is the foreground process, it sends `CSI I` after a short delay. Codex treats
that as focus gained and re-queries the updated WezTerm colors.

### Codex inside tmux

tmux answers OSC color queries using its pane style. The light and dark theme
files therefore set explicit `window-style` and `window-active-style`
foreground and background colors:

- Dark: background `#0D1117`, foreground `#abb2bf`
- Light: background `#ffffff`, foreground `#1f2328`

`bin/tmux-theme` applies the selected file and sends `CSI I` directly to every
pane whose foreground command starts with `codex`. Codex then re-queries tmux
after the pane colors have changed.

## tmux watcher

`.config/tmux/tmux.conf` starts `bin/tmux-theme-watcher` once per tmux server.
The watcher uses `dark-notify` to receive the current macOS appearance
immediately and all later changes.

The PID file under `${XDG_STATE_HOME:-$HOME/.local/state}/tmux` prevents
duplicate watchers when `tmux.conf` is sourced more than once.

`dark-notify` is installed through the `Brewfile`:

```sh
brew install dark-notify
```

## Codex syntax colors

Codex normally uses its own true-color syntax theme, which bypasses the
terminal's ANSI palette. The `c` alias starts Codex with its built-in `ansi`
theme so syntax highlighting uses the configured WezTerm colors:

```sh
alias c="codex --yolo --config 'tui.theme=\"ansi\"'"
```

For an existing Codex session, run `/theme` and select `ansi`, or restart it
through the `c` alias.

Do not launch Codex with `FORCE_COLOR=1`. Although that removes fixed RGB diff
backgrounds, it also downgrades the entire TUI to ANSI-16 and removes semantic
backgrounds such as the user-message and plan boxes.

If Codex was already launched with `FORCE_COLOR=1`, changing the alias does not
affect that process or the alias cached by its parent shell. Exit Codex, reload
the shell, and start it again:

```sh
s
c
```

The restarted session keeps Codex's semantic TUI backgrounds while syntax
highlighting continues to use the terminal's ANSI palette.

### Scrollback limitation

Codex renders diff backgrounds using true-color values selected for the
appearance active when the diff is printed. After those cells enter terminal
scrollback, neither a focus event nor an application redraw can recolor them.
Consequently, an old dark-mode diff can retain its dark green background after
switching to light mode. New diffs and live TUI elements use the refreshed
appearance.

Some semantic Codex UI accents are still controlled by Codex and cannot be
fully customized through the syntax theme.

## Relevant files

- `.config/wezterm/theme.lua`: light and dark WezTerm palettes
- `.config/wezterm/wezterm.lua`: WezTerm synchronization and Codex refresh
- `.config/tmux/themes/light.conf`: light tmux status and pane colors
- `.config/tmux/themes/dark.conf`: dark tmux status and pane colors
- `.config/tmux/tmux.conf`: starts the tmux theme watcher
- `bin/tmux-theme-watcher`: watches the macOS appearance
- `bin/tmux-theme`: applies a tmux theme and refreshes Codex panes
- `scripts/aliases.sh`: launches Codex with its ANSI syntax theme

## Validation

Apply either tmux theme manually:

```sh
~/bin/tmux-theme light
~/bin/tmux-theme dark
```

Check the active tmux values:

```sh
tmux show -gv @system-theme
tmux show -gv window-style
tmux show -gv window-active-style
```

Check the current macOS appearance and exercise the same callback used by the
watcher:

```sh
dark-notify --exit
dark-notify --exit -c "$HOME/bin/tmux-theme"
```

Validate the scripts and WezTerm configuration:

```sh
bash -n bin/tmux-theme bin/tmux-theme-watcher
shellcheck bin/tmux-theme bin/tmux-theme-watcher
wezterm --config-file .config/wezterm/wezterm.lua show-keys >/dev/null
```
