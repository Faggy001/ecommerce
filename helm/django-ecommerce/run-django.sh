#!/bin/bash

# Find a free port
PORT=$(comm -23 <(seq 3000 3999 | sort) <(ss -tulpn | awk '{print $5}' | cut -d':' -f2 | sort -u) | head -n1)

echo "Using local port: $PORT"

# Start port-forward in background
kubectl port-forward svc/django-ecommerce $PORT:80 >/dev/null 2>&1 &

# Get the PID to stop later if needed
PF_PID=$!

# Wait a few seconds for the port-forward to start
sleep 3

# Open in default browser (Linux/WSL)
if command -v xdg-open >/dev/null; then
  xdg-open http://localhost:$PORT
elif command -v open >/dev/null; then
  open http://localhost:$PORT
else
  echo "Open your browser and go to: http://localhost:$PORT"
fi

# Keep script running to maintain port-forward
echo "Port-forward running with PID $PF_PID. Press Ctrl+C to stop."
wait $PF_PID

