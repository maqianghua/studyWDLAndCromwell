version 1.0

task do_stuff {
    input {
        String pattern
        File file
    }
    command {
        grep '${pattern}' ${file}
    }
    output {
        Array[String] matches = read_lines(stdout())
    }
}