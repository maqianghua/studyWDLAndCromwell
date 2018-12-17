version 1.0

task runtime_meta{
    input {
        String memory_mb
        String sample_id
        String param
        String sample_id
    }
    command {
        java -Xmx${memory_mb}M -jar task.jar -id ${sample_id} -param ${param} -out ${sample_id}.out
    }
    output {
        File results = "${sample_id}.out"
    }
    runtime {
        docker:"broadinstitute/bseimg"
    }
    parameter_meta {
        memory_mb:"Amount of memory to allocate to the JVM"
        param: "Some arbitrary parameter"
        sample_id: "The ID of the sample in format foo_bar_baz"
    }
    meta {
        author:"Joe Somebody"
        email:"joe@company.org"
    }
}