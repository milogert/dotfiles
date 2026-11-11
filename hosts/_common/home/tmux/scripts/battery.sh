#!/usr/bin/env zsh

SYSTEM=$(uname -s)
ICON_AC="🔌"
ICON_CHARGING="⚡"
ICON_BATTERY="🔋"

ACCUMULATOR="| #[fg=green,bg=default,bright]${ICON_BATTERY} "

# Return empty if we don't have a battery.

if [[ ${SYSTEM} == 'Darwin' ]]; then

  # : << 'COMMENT'
  # STABLE="-InternalBattery-0 (id=25231459)	80%; AC attached; not charging present: true"
  # echo "${STABLE}" | tail -1 | awk -F '\t' '{sub(/ present: true/, ""); $1=""; sub(/^ +/, ""); print}'
  # CHARGING="-InternalBattery-0 (id=25231459)	83%; charging; 0:50 remaining present: true"
  # echo "${CHARGING}" | tail -1 | awk -F '\t' '{sub(/ present: true/, ""); $1=""; sub(/^ +/, ""); print}'
  # COMMENT

  BATTERY_STATS=$(pmset -g batt | tail -1 | awk -F '\t' '{sub(/ present: true/, ""); $1=""; sub(/^ +/, ""); print}')

  # This could save awk calls.
  # read -r PERCENT AC CHARGE_TIME <<< $(awk -F '; ' '')

  PERCENT=$(echo ${BATTERY_STATS} | awk -F '; ' '{print $1}')
  ACCUMULATOR="${ACCUMULATOR}${PERCENT}"

  AC=$(echo ${BATTERY_STATS} | awk -F '; ' '{print $2}')

  if [[ ${AC} == 'AC attached' ]]; then
    ACCUMULATOR="${ACCUMULATOR}${ICON_AC} "
  fi

  if [[ ${AC} == 'charging' ]]; then
    CHARGE_TIME=$(echo ${BATTERY_STATS} | awk -F '; ' '{sub(/ remaining/, ""); print $3}')
    ACCUMULATOR="${ACCUMULATOR}${ICON_CHARGING} ${CHARGE_TIME}"
  fi
else
  BATTERIES=$(ls /sys/class/power_supply/)

  if [[ -z ${BATTERIES} ]]; then
    echo ""
  fi

  # This is busted but a placeholder
  cat /sys/class/power_supply/BAT1/capacity
fi

echo "${ACCUMULATOR} #[default]"
