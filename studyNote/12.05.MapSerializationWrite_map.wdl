version 1.0

task test {
    input {
        Map[String,Float] sample_quality_scores
    }
    command {
        sh script.sh ${write_map(sample_quality_scores)}
    }
}