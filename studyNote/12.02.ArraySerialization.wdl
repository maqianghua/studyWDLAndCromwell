version 1.0

task test {
    input {
        Array[File] bams
    }
    command {
        python script.py --bam=${sep="," bams}
    }
}