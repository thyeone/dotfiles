#!/bin/bash
# Claude Code statusLine - agnoster-inspired segments
# Segments: model | context usage | plan usage limits (5h, 7d) | git branch + dirty/clean | shortened cwd

# Single jq call; @sh quotes values so eval is safe.
eval "$(jq -r '@sh "cwd=\(.workspace.current_dir // .cwd // "")
model=\(.model.display_name // "Claude")
used_pct=\(.context_window.used_percentage // "")
rl_5h=\(.rate_limits.five_hour.used_percentage // "")
rl_7d=\(.rate_limits.seven_day.used_percentage // "")"')"

# --- path segment: shorten like agnoster (last two components, ~ for home) ---
home="$HOME"
tilde="~"
disp_path="${cwd/#"$home"/$tilde}"
short_path=$(printf '%s' "$disp_path" | awk -F'/' '{
  if (NF <= 2) { print $0 }
  else { print $(NF-1) "/" $NF }
}')

# --- git segment ---
branch=""
dirty=""
# One git call: branch name, detached oid, and dirty state.
if status_output=$(git -C "$cwd" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null); then
  branch=$(printf '%s\n' "$status_output" | awk '/^# branch.head /{print $3}')
  if [ "$branch" = "(detached)" ]; then
    branch=$(printf '%s\n' "$status_output" | awk '/^# branch.oid /{print substr($3,1,7)}')
  fi
  printf '%s\n' "$status_output" | grep -qv '^#' && dirty=1
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

# --- model segment ---
segs=("${MODEL_COLOR} ◆ ${model} ${RESET}")

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
  segs+=("${ctx_color} ctx ${pct}% ${RESET}")
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
[ -n "$lim_out" ] && segs+=(" ${lim_out} ")

# --- git segment ---
if [ -n "$branch" ]; then
  if [ -n "$dirty" ]; then
    status_color="$DIRTY_COLOR"
    status_icon="✗"
  else
    status_color="$CLEAN_COLOR"
    status_icon="✓"
  fi
  segs+=("${GIT_COLOR} ⎇ ${branch} ${status_color}${status_icon}${RESET} ")
fi

# --- dir segment ---
segs+=("${DIR_COLOR} ${short_path} ${RESET}")

out="${segs[0]}"
for seg in "${segs[@]:1}"; do
  out="${out}${SEP_COLOR}❯${RESET}${seg}"
done
printf '%s' "$out"
