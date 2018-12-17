version 1.0

task heredoc {
    input {
        File in
    }
    command<<<
    python <<CODE
        with open("${in}") as fp:
            for line in fp:
                if not line.startswith('#'):
                    print (line.strip())
    CODE
    >>>
}