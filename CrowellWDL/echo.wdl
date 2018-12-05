version 1.0

task echo{
  input {
    String out
    Int cpu
    Int mem
  }
  
  command {
    echo Hell World > ${out}
  }

  runtime {
    backend: "SGE"
    cpu:cpu
    memory:"${mem} GB"
  }

  output {
    File outFile="${out}"
    Array[String] content = read_lines(outFile)
  }
}

workflow wf_echo{
  call echo 

  output {
    echo.outFile
    echo.content
  }
}
