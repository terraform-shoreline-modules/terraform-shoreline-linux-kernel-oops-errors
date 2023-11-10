#!/bin/bash

# Check if CPU frequency scaling is enabled
if [[ "$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | uniq)" != "userspace" ]]; then
    echo "Error: CPU frequency scaling is not set to 'userspace'. Overclocking may cause instability and Kernel Oops errors."
fi

# Check if CPU temperature is within safe limits
if [[ "$(cat /sys/class/thermal/thermal_zone*/temp | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }')" -gt "${MAX_TEMPERATURE}" ]]; then
    echo "Error: CPU temperature is too high. Overclocking may cause instability and Kernel Oops errors."
fi

# Check if system stability test passes
if ! stress-ng --cpu "${NUM_CPU_CORES}" --timeout "${STABILITY_TEST_TIMEOUT}" --metrics-brief | grep -q 'cpu: [0-9]*\.[0-9]*'; then
    echo "Error: System stability test failed. Overclocking may cause instability and Kernel Oops errors."
fi