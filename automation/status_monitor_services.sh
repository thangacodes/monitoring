#!/bin/bash

# Array of services in logical order
services=(
  "grafana-server"
  "promtail"
  "loki"
  "prometheus"
  "node_exporter"
)

echo "==================== Monitoring Services Status ===================="

for service in "${services[@]}"; do
    echo ""
    echo ">>> Checking $service ..."
    # Show only the Active: line for clarity
    systemctl status "$service" | grep -E "Active:|Loaded:"
done

echo ""
echo "==================== End of Status ===================="