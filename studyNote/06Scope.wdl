Scope{
    Scopes定义：
        workflow {...} blocks
        call blocks
        while(expr) {...} blocks
        if(expr) {...} blocks
        scatter(x in y) {...} blocks
        在任何范围内，都可以声明变量。在该范围中声明的变量对任何子范围都是可见的，递归地06.01.Scope.wdl{
            my_task将使用x=4在其命令行中设置var的值。但是，my_task还需要一个在任务级别定义的x值.由于my_task有两个输入(x和var)，并且只有一个输入是在调用my_task声明中设置的，即my_task的值。当工作流运行时，用户仍然需要提供x.
        }
}