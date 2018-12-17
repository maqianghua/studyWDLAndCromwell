version 1.0

import "http://example.com/lib/analysis_tasks" as analysis
import "http://example.com/lib/stdlib"

workflow wf {
    input {
        File bam_file
    }
    #file_size if from "http://example.com/lib/stdlib"
    call stdlib.file_size {
        input :
            file = bam_file
    }
    call analysis.my_analysis_task {
        input :
            size=file_size.bytes,
            file=bam_file
    }
}