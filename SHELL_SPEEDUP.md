# Shell Startup Speedup Plan

**Current startup time: ~6 seconds**
**Target: <300ms**

## Profiling Summary

| Component | Time | % of total |
|-----------|------|-----------|
| NVM (load + auto-use) | ~1,322ms | 88% |
| oh-my-zsh framework | ~1,268ms | 21% |
| compinit (called twice!) | ~1,065ms | 18% |
| brew shellenv | ~106ms | 2% |
| brew --prefix rustup (subshell) | ~83ms | 1% |
| Everything else | ~160ms | — |

---

## Action Items (priority order)

### 1. Replace NVM with fnm ✅

NVM is **88% of your startup** — it's the single biggest win. `fnm` (Fast Node Manager) is a Rust-based drop-in replacement that loads in <5ms.

```bash
brew install fnm
# Replace the 3 nvm lines in .zshrc with:
eval "$(fnm env --use-on-cd)"
```

fnm supports `.nvmrc` and `.node-version` files automatically.

### 2. Fix duplicate compinit calls

You call `compinit` twice:
1. oh-my-zsh calls it internally
2. Line 97 of `.zshrc` calls it again for AWS completion

After removing oh-my-zsh, consolidate to a single `compinit` with dump caching:

```zsh
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C  # skip security check, use cache
fi
```

### 3. Remove stale zcompdump files

You have 8 zcompdump files accumulating. Clean them up after fixing compinit:

```bash
rm -f ~/.zcompdump*
```

Then let compinit regenerate a single fresh one.

### 4. Hardcode `brew --prefix rustup`

Line 110 shells out to `brew --prefix rustup` on every startup (~83ms). Replace with the hardcoded result:

```zsh
# Before (forks a process every shell launch):
RUSTUP_PATH=$(brew --prefix rustup)
export PATH="$RUSTUP_PATH/bin:$PATH"

# After:
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
```

### 5. Lazy-load bashcompinit + AWS completer

`bashcompinit` is only needed for `aws` tab-completion. Defer it until first use:

```zsh
aws() {
  unfunction aws
  autoload bashcompinit && bashcompinit
  complete -C "$HOMEBREW_PATH/bin/aws_completer" aws
  aws "$@"
}
```

### 6. Move brew shellenv to .zshenv (or hardcode)

`eval "$(brew shellenv)"` forks a process. The output is static — hardcode it:

```zsh
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export MANPATH="/opt/homebrew/share/man:$MANPATH"
export INFOPATH="/opt/homebrew/share/info:$INFOPATH"
```

### 8. Source order: move HOMEBREW_NO_AUTO_UPDATE earlier

Line 49 sets `HOMEBREW_NO_AUTO_UPDATE=1` but brew is already loaded on line 24. Move it before any brew interaction (doesn't affect speed much but prevents accidental brew updates if the var is ever needed earlier).

---

## Expected Result

| After changes | Estimated time |
|---------------|---------------|
| fnm instead of nvm | -1,300ms |
| Drop oh-my-zsh | -1,100ms |
| Single compinit with cache | -900ms |
| Hardcode brew paths | -180ms |
| Lazy AWS completer | -50ms |
| **Total saved** | **~3,500ms** |
| **New startup** | **~200–300ms** |

---

## Bonus: validate your fix

After making changes, benchmark with:

```bash
# Quick timing
time zsh -i -c exit

# Detailed profile
zmodload zsh/zprof
# (put at top of .zshrc, then `zprof` at bottom)
```
