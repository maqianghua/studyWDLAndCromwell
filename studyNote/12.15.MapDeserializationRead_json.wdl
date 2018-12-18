version 1.0

task test {
    command <<<
        echo '{"foo":"bar"}'
    >>>
    output {
        Map[String,String] my_map = read_json(stdout())
    }
}