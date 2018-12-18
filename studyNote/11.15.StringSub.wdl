version 1.0

task example {
    input {
        File input_file = "my_input_file.bam"
        String output_file_name=sub(input_file,"\\.bam$",".index") #结果是my_input_file.index
    }
    command {
        echo "I want an index instead" >${output_file_name}
    }
    output {
        File outputFile=output_file_name
    }
}