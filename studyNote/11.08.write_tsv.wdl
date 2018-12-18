version 1.0

task example {
    Array[String] array = [["one","two","three"],["un","deux","trois"]]
    command {
        ./script --tsv=${write_tsv(array)}
    }
}