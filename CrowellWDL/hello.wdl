version 1.0

task hello {
  input {
    String addressee
    Int cpu
    Int mem
  }
  
  command {
    echo "Hello ${addressee}! Welcome to Cromwell ... on Google Cloud!"
  }
  
  runtime {
    backend: "SGE"
    cpu:cpu
    memory:"${mem} GB"
  }

  output {
    String message = read_string(stdout())
  }

}

workflow wf_hello {
  call hello

  output {
    String outputMessage=hello.message
  }
}