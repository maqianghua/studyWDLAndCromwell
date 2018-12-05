version 1.0

workflow timingWorkflow {
  scatter(i in range(15)){
    call sleep {input: sleep_time = i}
  }
}

task sleep {
  Int sleepTime
  command {
    echo "I slept for %{sleepTime}"
    sleep ${sleepTime}
  }

  output {
    String out = read_string(stdout())
  }
}