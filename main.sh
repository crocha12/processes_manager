show_menu() {
  echo "Selection menu:"
  echo "1. List processes"
  echo "2. Pause process"
  echo "3. Resume process"
  echo "4. Kill process"
  echo "5. Exit"
}

pause_process() {
  kill -19 $pid
  echo "$(date +'%Y-%m-%d %H:%M:%S') - Process $pid paused" >> procman.log
  echo "Process with PID $pid has been paused."
}

resume_process() {
  kill -18 $pid
  echo "$(date +'%Y-%m-%d %H:%M:%S') - Process $pid resumed" >> procman.log
  echo "Process with PID $pid has been resumed."
}

kill_process() {
  kill -9 $pid
  echo "$(date +'%Y-%m-%d %H:%M:%S') - Process $pid closed" >> procman.log
  echo "Process with PID $pid has been terminated."
}

operations() {
  while read -p "Which PID do you want to ${1}? " pid
  do
    if [ -z "$pid" ]; then
      echo "PID cannot be empty. Please try again."
      return
    fi
    if ! ps -p $pid > /dev/null; then
      echo "Process with PID $pid not found."
      return
    fi
    read -p "Are you sure you want to ${1} the process with PID $pid? (y/n) " confirm
    if [ "$confirm" = "y" ]; then
      if [ $2 -eq 1 ]; then
        pause_process
        return
      elif [ $2 -eq 2 ]; then
        resume_process
        return
      else
        kill_process
        return
      fi
    else
      echo "Operation cancelled."
    fi
    return
  done  
}

show_menu
while read -p "Which option do you want? " input
do
  echo "\n"
  if [ $input -eq 1 ]; then
    processes=$(ps -e -o pid,user="User",%cpu="CPU",%mem="Memory",etime="Time",comm="Command",stat="State" | column -t)
    echo "$processes"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - Process listing" >> procman.log
  elif [ $input -eq 2 ]; then
    operations "pause" 1
  elif [ $input -eq 3 ]; then
    operations "resume" 2
  elif [ $input -eq 4 ]; then
    operations "kill" 3
  elif [ $input -eq 5 ]; then
    echo "Closing the application."
    break
  else
    echo "Invalid option. Please try again."
  fi
  echo "\n"
  show_menu
done