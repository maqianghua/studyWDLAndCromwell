version 1.0

task wc {
    File f
    Boolean l=fasle
    String? region

    parameter_meta {
        f:{help:"Count the number of lines in this file"},
        l:{help:"Count only lines"}
        region:{help:"Could region",suggestions:["us-west","us-east","asia-pacific","euope-central"]}
    }
    command {
        wc ${true="-1",false='' l} ${f}
    }
    output {
        String retval = stdout()
    }
}