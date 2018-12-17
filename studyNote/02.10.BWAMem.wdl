version 1.0

task bwa_mem_tool {
    input {
        Int threads
        Int min_seed_length
        Int min_std_max_min
        File reference
        File reads
    }
    command {
        bwa mem -t ${threads} \
            -k ${min_seed_length} \
            -I ${sep="," min_std_max_min+} \
            ${reference} \
            ${sep=' ' reads+} >output.sam
    }
    output {
        File sam = "output.sam"
    }
    runtime {
        docker:"broadinstitute/baseimg"
    }
}