#!/bin/bash
set -e

# Colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

API_URL="http://localhost:5125"
CREATED_IDS=()

echo -e "${CYAN}Starting TodoAPI activity generator...${NC}"
echo "This script will create, read, update, and delete todo items to generate telemetry data."
echo ""

# Function to display the response
show_response() {
  status=$1
  response=$2
  if [ $status -ge 200 ] && [ $status -lt 300 ]; then
    echo -e "${GREEN}Success (HTTP $status):${NC} $response"
  elif [ $status -ge 400 ]; then
    echo -e "${RED}Error (HTTP $status):${NC} $response"
  else
    echo -e "${YELLOW}Response (HTTP $status):${NC} $response"
  fi
  echo ""
}

# Create a few todo items
echo -e "${BLUE}Creating todo items...${NC}"
for i in {1..5}; do
  title="Task #$i - $(date +%H:%M:%S)"
  response=$(curl -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" \
    -d "{\"name\":\"$title\",\"isComplete\":false}" \
    $API_URL/todoitems)
  
  status=${response##*$'\n'}
  body=${response%$'\n'*}
  
  show_response $status "$body"
  
  # Extract the ID if successful
  if [ $status -eq 201 ]; then
    id=$(echo $body | grep -o '"id":[0-9]*' | grep -o '[0-9]*')
    if [ ! -z "$id" ]; then
      CREATED_IDS+=($id)
    fi
  fi
  
  sleep 1
done

# Get all todo items
echo -e "${BLUE}Retrieving all todo items...${NC}"
response=$(curl -s -w "\n%{http_code}" -X GET $API_URL/todoitems)
status=${response##*$'\n'}
body=${response%$'\n'*}
show_response $status "$body"

# Get individual todo items
echo -e "${BLUE}Retrieving individual todo items...${NC}"
for id in "${CREATED_IDS[@]}"; do
  response=$(curl -s -w "\n%{http_code}" -X GET $API_URL/todoitems/$id)
  status=${response##*$'\n'}
  body=${response%$'\n'*}
  show_response $status "$body"
  sleep 0.5
done

# Update some todo items
echo -e "${BLUE}Updating todo items...${NC}"
for id in "${CREATED_IDS[@]}"; do
  if [ $(( RANDOM % 2 )) -eq 0 ]; then
    title="Updated Task #$id - $(date +%H:%M:%S)"
    response=$(curl -s -w "\n%{http_code}" -X PUT -H "Content-Type: application/json" \
      -d "{\"id\":$id,\"name\":\"$title\",\"isComplete\":true}" \
      $API_URL/todoitems/$id)
    status=${response##*$'\n'}
    body=${response%$'\n'*}
    show_response $status "$body"
  fi
  sleep 0.5
done

# Get a non-existent todo item to generate a 404
echo -e "${BLUE}Testing error handling - retrieving non-existent item...${NC}"
response=$(curl -s -w "\n%{http_code}" -X GET $API_URL/todoitems/999)
status=${response##*$'\n'}
body=${response%$'\n'*}
show_response $status "$body"

# Call the error endpoint to generate an exception
echo -e "${BLUE}Testing error endpoint...${NC}"
response=$(curl -s -w "\n%{http_code}" -X GET $API_URL/error || echo "Error occurred")
status=${response##*$'\n'}
body=${response%$'\n'*}
show_response $status "$body"

# Call the load generation endpoint
echo -e "${BLUE}Generating additional load...${NC}"
response=$(curl -s -w "\n%{http_code}" -X GET $API_URL/generate-load)
status=${response##*$'\n'}
body=${response%$'\n'*}
show_response $status "$body"

# Delete some todo items
echo -e "${BLUE}Deleting some todo items...${NC}"
for id in "${CREATED_IDS[@]}"; do
  if [ $(( RANDOM % 3 )) -eq 0 ]; then
    response=$(curl -s -w "\n%{http_code}" -X DELETE $API_URL/todoitems/$id)
    status=${response##*$'\n'}
    body=${response%$'\n'*}
    show_response $status "$body"
  fi
  sleep 0.5
done

# Call the load generation endpoint a few more times to create more data
echo -e "${BLUE}Generating more load...${NC}"
for i in {1..3}; do
  response=$(curl -s -w "\n%{http_code}" -X GET $API_URL/generate-load)
  status=${response##*$'\n'}
  body=${response%$'\n'*}
  show_response $status "$body"
  sleep 2
done

echo -e "${CYAN}Activity generation complete!${NC}"
echo "You should now see telemetry data in Grafana Cloud Application Observability."
echo "The script created, read, updated, and deleted various todo items to generate traces, metrics, and logs."
