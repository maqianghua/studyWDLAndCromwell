version 1.0

workflow foo {
    input {
        #这个输入' my_task_int_in '通常基于任务输出，除非它在输入集中被覆盖
        Int my_task_int_in = some_preliminary_task.int_out
    }
    call some_preliminary_task
    call my_task {
        input :
            my_task_int_in = x
    }
}