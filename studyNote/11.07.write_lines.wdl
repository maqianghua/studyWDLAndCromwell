version 1.0

task example {
    Array[String] array=["first","second","third"]
    command {
        ./script --file-list=${write_lines(array)}
    }
}