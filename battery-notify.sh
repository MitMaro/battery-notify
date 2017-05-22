#!/usr/bin/env bash

export DISPLAY="$(w -h $USER | awk '$3 ~ /:[0-9.]*/{print $3}')"
XAUTHORITY="$HOME/.Xauthority"

SOUND_COMMAND="${SOUND_COMMAND:-paplay}"
CRITICAL_LEVEL="${CRITICAL_LEVEL:-5}"
CRITICAL_ICON="${CRITICAL_ICON:-"battery-empty"}"
CRITICAL_SOUND="${CRITICAL_SOUND:-"/usr/share/sounds/purple/alert.wav"}"
LOW_LEVEL="${LOW_LEVEL:-10}"
LOW_ICON="${LOW_ICON:-"battery-caution"}"
LOW_SOUND="${LOW_SOUND:-""}"

if [[ -r "$HOME/.dbus/Xdbus" ]]; then
	source "$HOME/.dbus/Xdbus"
fi

battery_level="$(acpi -b | grep -v "Charging" | grep -P -o '([0-9]+(?=%))')"

if [[ -z "$battery_level" ]]; then
	exit 0
fi

if [[ "$battery_level" -le "$CRITICAL_LEVEL" ]]; then
	notify-send -i "$CRITICAL_ICON" -t 15000 -u normal "Battery Critical" "Battery level is ${battery_level}%"
	if [[ ! -z "$CRITICAL_SOUND" ]]; then
		$SOUND_COMMAND "$CRITICAL_SOUND"
	fi
	exit 0
fi

if [[ "$battery_level" -le "$LOW_LEVEL" ]]; then
	notify-send -i "$LOW_LEVEL" -t 15000 -u normal "Battery Low" "Battery level is ${battery_level}%"
	if [[ ! -z "$LOW_SOUND" ]]; then
		$SOUND_COMMAND "$LOW_SOUND"
	fi
	exit 0
fi
