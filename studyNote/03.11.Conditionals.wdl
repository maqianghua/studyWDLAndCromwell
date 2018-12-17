version 1.0

workflow foo {
    input {
        Array[Int] scatter_range =[1,2,3,4,5]
    }
    scatter (i in scatter_range) {
        call x {
            input : i=i
        }
        if (x.validOutput) {
            Int x_out = x.out
        }
    }
    # 在if和scatter中定义了x_out,此处的x_out类型就会不一样
    Array[Int?] x_out_maybes = x_out
    # 通过select_all挑选合法的元素
    Array[Int] x_out_valids = select_all(x_out_maybes)
    #或者我们选择第一个合法的元素
    Int x_out_first = select_first(x_out_maybes)
}