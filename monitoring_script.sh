#!/bin/bash
services=("prometheus" "node_exporter" "grafana-server")
action=$1
case $action in
start)
    echo "Starting monitoring stack..."
    for service in "${services[@]}"; do
        sudo systemctl start $service
        echo "$service started."
    done
    ;;
stop)
    echo "Stopping monitoring stack..."
    for service in "${services[@]}"; do
        sudo systemctl stop $service
        echo "$service stopped."
    done
    ;;
restart)
    echo "Restarting monitoring stack..."
    for service in "${services[@]}"; do
        sudo systemctl restart $service
        echo "$service restarted."
    done
    ;;
status)
    echo "Checking service status..."
    for service in "${services[@]}"; do
        echo "--------------------------------"
        systemctl status $service --no-pager
    done
    ;;
*)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac
