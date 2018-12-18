task do_stuff {
    input {
        File file
    }
    command {
        python do_stuff.py ${file}
    }
    output {
        Array[Array[String]] output_table=read_tsv("./results/file_list.tsv")
    }
}