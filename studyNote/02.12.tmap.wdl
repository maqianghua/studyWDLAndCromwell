version 1.0

task tmap_tool {
    input {
        Array[String] stages
        File reads
    }
    command {
        tmap mapall ${sep=' ' stage+} <${reads} >otuput.sam
    }
    output {
        File sam = "output.sam"
    }
}