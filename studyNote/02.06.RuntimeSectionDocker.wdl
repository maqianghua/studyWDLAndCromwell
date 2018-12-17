version 1.0

task docker_test {
    input {
        String arg
    }
    command {
        python process.py ${arg}
    }
    runtime {
        docker:"ubuntu:latest"
    }
}