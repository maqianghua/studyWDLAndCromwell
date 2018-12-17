version 1.0

task example {
    input {
        String prefix
        File bam
    }
    command {
        python analysis.py --prefix=${prefix} ${bam}
    }
    output {
        File analyzed= "${prefix}.put"
        File bam_sibling = "${bam}.suffix"
    }
}