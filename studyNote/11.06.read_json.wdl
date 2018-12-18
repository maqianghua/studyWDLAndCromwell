version 1.0

task do_stuff {
    input {
        File file
    }
    command {
        python do_stuff.py ${file}
    }
    output {
        Map[String,String] output_table =read_json("./result/file_list.json")
    }
}