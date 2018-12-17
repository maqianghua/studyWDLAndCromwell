version 1.0

#main.wdl

import "sub_wdl.wdl" as sub

workflow main_workflow {
    call sub.wf_hello {
        input :
            wf_hello_input = "sib world"
    }
    output {
        String main_output= wf_hello.salutation
    }
}

#wub_wdl.wdl
task hello {
    input {
        String addressee
    }
    command {
        echo "Hello ${addressee}"
    }
    runtime {
        docker:"ubuntu:latest"
    }
    output {
        String salutation = read_string(stdout())
    }
}

workflow wf_hello {
    input {
        String wf_hello_input
    }
    call hello {
        input :
            addressee = wf_hello_input
    }
    output {
        String salutation= hello.salutation
    }
}