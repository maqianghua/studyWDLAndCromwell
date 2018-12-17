version 1.0

workflow foo {
    input {
        String? s = "hello"
    }
    call valid {
        input :
            s_maybe = s
    }
    #以下将会发生错误，不能将String？输入当做string
    call invalid {
        input :
            s_definitely=s
    }
}
task valid {
    input  {
        String? s_maybe
    }
    ...
}

task invalid {
    input {
        String s_definitely
    }
}