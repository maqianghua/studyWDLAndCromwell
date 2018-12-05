version 1.0

task hello2 {
  input {
    String name
    Int cpu
    Int mem
  }
  
  command {
    echo "Hello ${name}! Welcome to Cromwell ... on Google Cloud!"
  }
  
  runtime {
    backend: "SGE"
    cpu:cpu
    memory:"${mem} GB"
  }

  output {
    File response =stdout()
  }

}

workflow wf_hello2 {
  call hello

  output {
    File outputResponse=hello.response
  }
}