version 1.0

task test {
    command <<<
        echo '["foo","bar"]'
    >>>
    output {
        Array[String] my_array =read_json(stdout())
    }
}