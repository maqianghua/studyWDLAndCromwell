version 1.0

workflow wf {
    input {
        Array[File] files
        Int threshold
        Map[String, String] my_map
    }
    call analysis_job{
        input :
            search_paths=files,threshold=threshold,gender_lookup=my_map
    }
}