version 1.0

import "other.wdl" as other

task test{
    input {
        String my_var
    }
    command {
        ./script ${my_var}
    }
    output{
        File results = stdout()
    }
}

workflow wf {
    Array[String] arr = ["a", "b", "c"]
    call test
    call test as test2
    call other.foobar

    output {
        File testFile=test.results
        File foobarFile = foobar.results
    }
    scatter (x in arr){
        call test as scattered_test {
            input:my_var=x
        }
    }
}