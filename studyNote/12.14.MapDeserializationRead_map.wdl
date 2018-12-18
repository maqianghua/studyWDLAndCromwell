version 1.0

task test {
    command <<<
        python <<CODE
            for i in range(3):
                print("key_{idx}\t{idx}".format(idx=i))
        CODE
    >>>
    output {
        Map[String, Int] my_ints = read_map(stdout())
    }
}