version 1.0

task task1 {
    command {
        python do_stuff.py
    }
    output {
        File results =stdout()
    }
}

task task2 {
    input {
        File foobar
    }
    command {
        python do_stuff2.py ${foobar}
    }
    output {
        File results=stdout()
    }
}

workflow wf {
    call task1
    call task2 {
        input :
            foobar=task1.results
    }
}