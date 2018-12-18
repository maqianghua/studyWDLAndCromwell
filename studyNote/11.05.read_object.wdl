version 1.0

task test {
    command <<<
        python <<CODE
            print ('\t'.join(["key_{}".format(i) for i in range(3)]))
            print ('\t'.join(["value_{}".format(i) for i in range(3)]))
            print ('\t'.join(["value_{}".format(i) for i in range(3)]))
            print ('\t'.join(["value_{}".format(i) for i in range(3)]))
        CODE
    >>>
    output {
        Array[Object] my_obj=read_objects(stdout())
    }
}