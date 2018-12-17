version 1.0

workflow foo {
    # 调用'x',输出一个Boolean类型的值
    call x
    Boolean x_out = x.out
    # 调用'y'，产生一个Int类型的输出，在一个情况框中
    if (x_out) {
        call y
        Int y_out = y.out
    }
    # if框之外，我们必须处理该输出为可选输出
    Int? y_out_maybe = y.out
    # 调用Z，将可选类型Int作为输入
    call z {
        input :
            optional_int = y_out_maybe
    }
}