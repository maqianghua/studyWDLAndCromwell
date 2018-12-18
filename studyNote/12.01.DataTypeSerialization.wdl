version 1.0

task test {
    input {
        Array[File] files
    }
    command {
        RScript analysis.R --files=${sep=',' files}
    }
    output {
        Array[String] strs = read_lines(stdout())
    }
}