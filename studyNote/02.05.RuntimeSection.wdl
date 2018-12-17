version 1.0

task test {
    input {
        String ubuntu_version
    }
    command {
        python script.py
    }
    runtime {
        docker:"ubuntu:"+ubuntu_version
    }
}