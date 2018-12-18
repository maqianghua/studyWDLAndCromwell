version 1.0

task do_stuff {
    input {
        String flags
        File file
    }
    command {
        ./script --flags=${flags} ${file}
    }
    output {
        Map[String,String] mapping=read_map(stdout())
    }
}