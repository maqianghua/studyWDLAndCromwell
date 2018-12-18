version 1.0

task test {
    input {
        Array[Object] sample
    }
    command {
        perl script.pl ${write_objects(sample)}
    }
}