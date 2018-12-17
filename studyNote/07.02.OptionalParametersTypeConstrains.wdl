version 1.0

task test {
    input {
        String? val
    }
    command {
        python script.py --val=${val}
    }
}