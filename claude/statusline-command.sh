#!/bin/bash
# Claude Code statusLine - agnoster-inspired segments
# Segments: shortened cwd | model | context usage | git branch + dirty/clean | plan usage limits (5h, 7d)

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
rl_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# --- path segment: shorten like agnoster (last two components, ~ for home) ---
home="$HOME"
disp_path=$(printf '%s' "$cwd" | sed "s|^$home|~|")
short_path=$(printf '%s' "$disp_path" | awk -F'/' '{
  if (NF <= 2) { print $0 }
  else { print $(NF-1) "/" $NF }
}')

# --- git segment ---
branch=""
dirty=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -z "$branch" ]; then
    branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  fi
  status_output=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
  if [ -n "$status_output" ]; then
    dirty=1
  fi
fi

# --- colors (dimmed ANSI, agnoster-style palette) ---
RESET=$(printf '\033[0m')
MODEL_COLOR=$(printf '\033[2;38;5;73m')     # dim teal
DIR_COLOR=$(printf '\033[2;38;5;33m')       # dim blue
SEP_COLOR=$(printf '\033[2;38;5;240m')      # dim gray separator
GIT_COLOR=$(printf '\033[2;38;5;141m')      # dim purple
TOK_COLOR=$(printf '\033[2;38;5;110m')      # dim light blue
CLEAN_COLOR=$(printf '\033[2;38;5;35m')     # dim green
DIRTY_COLOR=$(printf '\033[2;38;5;178m')    # dim yellow/orange
CTX_LOW_COLOR=$(printf '\033[2;38;5;35m')   # dim green  (<50% used)
CTX_MID_COLOR=$(printf '\033[2;38;5;178m')  # dim yellow (50-79% used)
CTX_HIGH_COLOR=$(printf '\033[2;38;5;167m') # dim red    (>=80% used)

# --- dir segment ---
out="${DIR_COLOR} ${short_path} ${RESET}"

# --- model segment ---
out="${out}${SEP_COLOR}❯${RESET}${MODEL_COLOR} ◆ ${model} ${RESET}"

# --- context usage segment ---
if [ -n "$used_pct" ]; then
  pct=$(printf '%.0f' "$used_pct")
  if [ "$pct" -ge 80 ]; then
    ctx_color="$CTX_HIGH_COLOR"
  elif [ "$pct" -ge 50 ]; then
    ctx_color="$CTX_MID_COLOR"
  else
    ctx_color="$CTX_LOW_COLOR"
  fi
  out="${out}${SEP_COLOR}❯${RESET}${ctx_color} ctx ${pct}% ${RESET}"
fi

# --- git segment ---
if [ -n "$branch" ]; then
  if [ -n "$dirty" ]; then
    status_color="$DIRTY_COLOR"
    status_icon="✗"
  else
    status_color="$CLEAN_COLOR"
    status_icon="✓"
  fi
  out="${out}${SEP_COLOR}❯${RESET}${GIT_COLOR} ⎇ ${branch} ${status_color}${status_icon}${RESET}"
fi

# --- plan usage-limit segment: "5h 23% · 7d 41%" (omitted if both missing) ---
lim() { # label, raw pct -> colored "label N%" (same thresholds as ctx)
  local p c
  p=$(printf '%.0f' "$2")
  if [ "$p" -ge 80 ]; then c="$CTX_HIGH_COLOR"; elif [ "$p" -ge 50 ]; then c="$CTX_MID_COLOR"; else c="$CTX_LOW_COLOR"; fi
  printf '%s%s %s%%%s' "$c" "$1" "$p" "$RESET"
}
lim_out=""
[ -n "$rl_5h" ] && lim_out=$(lim 5h "$rl_5h")
if [ -n "$rl_7d" ]; then
  [ -n "$lim_out" ] && lim_out="${lim_out}${SEP_COLOR} · ${RESET}"
  lim_out="${lim_out}$(lim 7d "$rl_7d")"
fi
[ -n "$lim_out" ] && out="${out}
 ${lim_out} "
printf '%s' "$out"
