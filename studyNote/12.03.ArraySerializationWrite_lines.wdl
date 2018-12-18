version 1.0

task test {
    input {
        Array[File] bams
    }
    command {
        sh script.sh ${write_lines(bams)}
    }
}