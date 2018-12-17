version 1.0

workflow foo {
    input {
        Boolean b
        Boolean c
    }
    if (b) {
        if (c) {
            call x
            Int x_out =x.out
        }
    }
    Int? x_out_maybe=x_out #虽然变量x_out在两层if中，也没有必要用Int??
    #调用y,需要一个Int 输入值
    call y {
        input :
            int_input = select_first([x_out_maybe,5]) #select_first产生的是一个Int而不是Int?
    }
}
Parameter Metadata