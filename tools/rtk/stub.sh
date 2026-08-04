#!/usr/bin/env bash
# rtk stub — binary not found in PATH
# rtk is a required build-time tool. hub init will fail if rtk is absent.
# Use --no-strip flag on hub init/update to bypass rtk for debugging.
echo "[hub:tools/rtk] rtk is not installed. hub init requires rtk or --no-strip flag." >&2
exit 1
