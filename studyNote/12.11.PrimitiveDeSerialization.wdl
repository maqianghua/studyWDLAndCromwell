version 1.0

task output_example {
    input {
        String param1
        String param2
    }
    command {
        python do_work.py ${param1} ${param2} --out1=int_file --out2=str_file
    }
    output {
        Int my_int = read_int(int_file)
        String my_str = read_string("str_file")
    }
}