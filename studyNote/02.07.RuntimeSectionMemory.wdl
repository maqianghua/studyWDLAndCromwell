version 1.0

task memory_test {
    input {
        String arg
    }
    command {
        python process.py ${arg}
    }
    runtime {
        memory:"2GB"
    }
}