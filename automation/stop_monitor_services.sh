#!/bin/bash

# Array of services in stop order (reverse of startup)
services=(
  "grafana-server"
  "promtail"
  "loki"
  "prometheus"
  "node_exporter"
  "flask-app"
)

echo "==================== Stopping Monitoring Services ===================="

for service in "${services[@]}"; do
    echo ""
    echo ">>> Stopping $service ..."
    sudo systemctl stop "$service"

    # Wait a couple of seconds for service to stop
    sleep 2

    # Check if service is inactive
    status=$(systemctl is-active "$service")
    if [ "$status" = "inactive" ]; then
        echo -e "$service: \e[32mSTOPPED\e[0m"
    else
        echo -e "$service: \e[31mFAILED TO STOP\e[0m"
    fi
done

echo ""
echo "==================== All Monitoring Services Stopped ===================="
