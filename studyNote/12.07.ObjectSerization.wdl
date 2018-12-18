version 1.0

task test {
    input {
        Object sample
    }
    command {
        perl script.pl ${write_object(sample)}
    }
}