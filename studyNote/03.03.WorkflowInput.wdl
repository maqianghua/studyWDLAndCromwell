version 1.0

workflow foo {
    input {
        Int x= 10
        Int y=my_task.out
    }
    call my_task as t1 {input: int_in=x}
    call my_task as t2 {input:int_in=y}
}