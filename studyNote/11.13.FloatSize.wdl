version 1.0

task example {
    input {
        File input_file
    }
    command {
        echo "this file id 22 bytes" >created_file
    }
    output {
        Float input_file_size = size(input_file)
        Float created_file_size = size("created_file") #22.0
        Float created_file_size_in_KB = size("created_file","K") #0.022
    }
}