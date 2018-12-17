version 1.0

task t {
    input {
        Int i
    }
    command {
        # do something
    }
    output {
        String out = "out"
    }
}

workflow w {
    input {
        String w_input="some input"
    }
    call t
    call t as u

    output {
        String t_out=t.out
        String u_out=u.out
        String input_as_output=w_input
        String previous_output=u_out
    }
}