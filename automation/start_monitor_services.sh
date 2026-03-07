#!/bin/bash

# Array of services in start order
services=(
  "node_exporter"
  "prometheus"
  "loki"
  "promtail"
  "grafana-server"
)

echo "==================== Starting Monitoring Services ===================="

for service in "${services[@]}"; do
    echo ""
    echo ">>> Starting $service ..."
    sudo systemctl start "$service"

    # Wait a few seconds for service to start (adjust if needed)
    sleep 3

    # Check if service is active
    status=$(systemctl is-active "$service")
    if [ "$status" = "active" ]; then
        echo -e "$service: \e[32mRUNNING\e[0m"
    else
        echo -e "$service: \e[31mFAILED\e[0m"
    fi
done

echo ""
echo "==================== All Monitoring Services Startup Complete ===================="