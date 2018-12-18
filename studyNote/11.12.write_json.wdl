version 1.0

task example {
    input {
        Map[String,String] map = {"key1":"value1","key2":"value2"}
    }
    command {
        ./script --map=${write_json(map)}
    }
}