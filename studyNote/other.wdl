version 1.0

task foobar {
    input {
        File in
    }
    command {
        sh setup.sh ${in}
    }
    output {
        File results = stdout()
    }
}