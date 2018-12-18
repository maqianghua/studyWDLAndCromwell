version 1.0

task my_task {
    input {
        Array[String] strings
    }
    command {
        python analysis.py --strings-file=${write_lines(strings)}
    }
}