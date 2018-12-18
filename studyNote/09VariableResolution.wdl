Variable Resolution{
    在表达式内部，根据表达式是在任务声明中还是在工作流声明中，对变量进行不同的解析
}
Task-Level Resolution{
    在任务内部，解析非常简单:引用的变量必须是任务的声明.案例：09.01.TaskLevelResolution.wdl{
        在这个任务中，只有一个表达式:write_lines(strings),在这里，当表达式求值器尝试解析字符串时，字符串必须是任务的声明(在本例中是).
    }
}
Workflow-Level Resolution{
    在工作流中，解决方案从引用变量的表达式开始，遍历范围层次结构.09.02.WorkflowLevelResolution.wdl{
        在这个例子中，有两个表达式:s+“-后缀”和t+“-后缀”。s解析为“my_task_s”，t解析为“t”
    }
}