#!/bin/bash

# generate-activity.sh - A simple script to generate activity for the Todo API

echo "🚀 Starting Todo API activity generator!"
echo "📊 Generating telemetry data for your Grafana dashboards..."
echo ""

# Function to get a random emoji for tasks
get_random_emoji() {
  emojis=("🏃" "🧘" "🛒" "📚" "🍽️" "💻" "🧹" "📝" "📞" "💤" "🚶" "🎮")
  echo "${emojis[$RANDOM % ${#emojis[@]}]}"
}

# Function to get a random task
get_random_task() {
  tasks=(
    "Buy groceries" 
    "Complete project report" 
    "Call the dentist" 
    "Go for a run" 
    "Read a book chapter" 
    "Clean the kitchen" 
    "Update resume" 
    "Learn something new" 
    "Take a break" 
    "Schedule a meeting"
    "Pay the bills"
    "Plan weekend activities"
  )
  echo "${tasks[$RANDOM % ${#tasks[@]}]}"
}

# Keep track of created task IDs
task_ids=()

# Main loop to continuously generate activity
while true; do
  clear
  echo "🔄 Generating new activity cycle for Todo API..."
  
  # Add 2-3 random tasks
  num_tasks=$((RANDOM % 2 + 2))
  echo "📝 Adding $num_tasks new tasks..."
  
  for ((i=1; i<=num_tasks; i++)); do
    emoji=$(get_random_emoji)
    task=$(get_random_task)
    
    echo "⏳ Adding task $i: $emoji $task"
    
    response=$(curl -s -X 'POST' \
      "http://localhost:5125/api/todo/items" \
      -H 'accept: */*' \
      -H 'Content-Type: application/json' \
      -d "{\"text\": \"$emoji $task\"}")
    
    # Extract the task ID if possible
    if [[ $response =~ \"id\":\"([^\"]+)\" ]]; then
      new_id="${BASH_REMATCH[1]}"
      task_ids+=("$new_id")
      echo "✅ Task added with ID: ${new_id:0:8}..."
    else
      echo "❓ Couldn't extract task ID from response"
    fi
    
    sleep 1
  done
  
  echo ""
  
  # List all tasks
  echo "📋 Listing all tasks..."
  curl -s -X 'GET' \
    "http://localhost:5125/api/todo/items" \
    -H 'accept: application/json' | jq '.' || echo "⚠️  Error: jq not available, showing raw JSON:" && curl -s -X 'GET' "http://localhost:5125/api/todo/items" -H 'accept: application/json'
  
  echo ""
  sleep 2
  
  # If we have task IDs, get a specific task
  if [ ${#task_ids[@]} -gt 0 ]; then
    random_index=$((RANDOM % ${#task_ids[@]}))
    task_id=${task_ids[$random_index]}
    
    echo "🔍 Getting details for task ID: ${task_id:0:8}..."
    curl -s -X 'GET' \
      "http://localhost:5125/api/todo/items/$task_id" \
      -H 'accept: application/json' | jq '.' || echo "Task details: $(curl -s -X 'GET' "http://localhost:5125/api/todo/items/$task_id" -H 'accept: application/json')"
    
    echo ""
    sleep 2
    
    # Complete a task
    echo "✅ Marking task ID: ${task_id:0:8}... as complete"
    curl -s -X 'POST' \
      "http://localhost:5125/api/todo/items/$task_id/complete" \
      -H 'accept: */*' \
      -d ''
    
    echo ""
    echo "Task marked as complete!"
    sleep 2
    
    # Delete a task (occasionally)
    if [ $((RANDOM % 3)) -eq 0 ] && [ ${#task_ids[@]} -gt 2 ]; then
      delete_index=$((RANDOM % ${#task_ids[@]}))
      delete_id=${task_ids[$delete_index]}
      
      echo "🗑️  Deleting task ID: ${delete_id:0:8}..."
      curl -s -X 'DELETE' \
        "http://localhost:5125/api/todo/items/$delete_id" \
        -H 'accept: */*'
      
      # Remove the ID from our array
      unset 'task_ids[$delete_index]'
      task_ids=("${task_ids[@]}")
      
      echo ""
      echo "Task deleted!"
      sleep 1
    fi
  fi
  
  # Intentionally generate an error occasionally (1 in 4 cycles)
  if [ $((RANDOM % 4)) -eq 0 ]; then
    echo "🐞 Generating an error by requesting a non-existent task..."
    curl -s -X 'GET' \
      "http://localhost:5125/api/todo/items/not-a-valid-id" \
      -H 'accept: application/json'
    echo ""
    echo "Error generated!"
    sleep 2
  fi
  
  # Keep our task_ids array from growing too large
  if [ ${#task_ids[@]} -gt 10 ]; then
    task_ids=("${task_ids[@]:(-10)}")
  fi
  
  echo ""
  echo "🕒 Waiting 5 seconds before next activity cycle..."
  echo "Press Ctrl+C to stop the generator"
  sleep 5
done
