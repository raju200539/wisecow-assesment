#!/bin/bash

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEM=$(free | awk '/Mem/ {print $3/$2 * 100.0}')
DISK=$(df / | awk 'END{print $5}' | sed 's/%//')

if (( $(echo "$CPU > 80" | bc -l) )); then
  echo "High CPU usage: $CPU%" >> system_health.log
fi

if (( $(echo "$MEM > 80" | bc -l) )); then
  echo "High Memory usage: $MEM%" >> system_health.log
fi

if [ $DISK -gt 80 ]; then
  echo "High Disk usage: $DISK%" >> system_health.log
fi

ps -e > running_processes.log
