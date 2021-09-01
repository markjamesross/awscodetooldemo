#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
VAR_NAME="$1"

var_global=$(awk -F= '
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }
/^'$VAR_NAME'[ =]/ { gsub(/"/,"",$2); print trim($2) }' "${SCRIPT_PATH}/global.tfvars")

if [ -n "$var_global" ]
then
  var_value="${var_global}"
fi

echo -n "$var_value"
