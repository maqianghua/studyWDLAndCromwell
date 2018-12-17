version 1.0

task test {
    command {
        python script.py
    }
    runtime {
        docker:["ubuntu:latest","broadinstitute/scala-baseimage"]
    }
}