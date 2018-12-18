version 1.0

task test {
    command <<<
        python <<CODE
            import random
            for i in range(10):
                print (random.randrange(10))
        CODE
    >>>
    output {
        Array[Int] my_ints = read_lines(stdout())
    }
}