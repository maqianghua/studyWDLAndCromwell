version 1.0

task my_task {
    input {
        Int x
        File f
    }
    command {
        my_cmd --integer=${var} ${f}
    }
}

workflow wf {
    input {
        Array[File] files
        Int x = 2
    }
    scatter(file in files) {
        Int x =3
        call my_task{
            int x=4
            input :
                var=x,
                f=file
        }
    }
}