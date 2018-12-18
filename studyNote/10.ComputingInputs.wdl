Computing Inputs {
    任务和工作流都有必须满足的类型化输入才能运行。下面几节描述如何计算任务和工作流声明的输入.
}
Computing Task Inputs {
    任务将其所有输入定义为输入部分中的声明。任何非输入声明都不是任务的输入，因此不能重写.10.01.ComputingTaskInputs.wdl{
        在这个例子中，i和f是这个任务的输入，尽管在命令部分中没有直接使用i。相比之下，s是一个输入，尽管命令行引用它.
    }
}
Computing Workflow Inputs{
    工作流有运行它们必须满足的输入，就像任务一样。工作流的输入是作为键/值映射提供的，其中键的形式是workflow_name.input_name{
        1 如果要将工作流用作子工作流，它必须确保其调用的所有输入都得到满足。
        2 如果一个工作流只会作为顶级工作流提交，那么它可能会选择不满足其任务的输入。这就迫使引擎在运行时额外提供这些输入。在这种情况下，输入的名称必须在输入中限定为workflow_name.task_name.input_name。
    }
    出现在输入部分之外的任何声明都被视为中间值，而不是工作流输入。任何声明都可以在移动到输入块中，以使其可覆盖。案例：10.02.ComputingWorkflowInputs.wdl{
        注意，由于一些调用输入没有得到满足，因此不能将此工作流用作子工作流。为了解决这个问题，可以通过t1.s和t2.s添加额外的工作流输入。
    }
}
Specifying Workflow Inputs in JSON{
    一旦计算了工作流输入(请参阅前一节)，就需要在每次调用工作流时指定每个全限定名的值.工作流输入被指定为键/值对。从JSON或YAML值到WDL值的映射在任务输入的序列化部分中进行了编码。
    10.03.SpecifyingWorkflowInputsInJSON.wdl{
        需要注意的是JSON中的类型必须强制转换为WDL类型。例如，wf.int_val需要一个整数，但是如果我们在JSON中指定它为“wf.int_val”:“three”，那么这种从字符串到整数的强制转换是无效的，并且会导致强制错误。有关类型强制的详细信息，请参阅有关类型强制的部分
    }
    Type Coercion{
        可以从JSON值或本地语言值创建WDL值。下表引用类字符串、类整数等来引用特定编程语言中的值。例如，“String-like”可能意味着java.io。Java上下文中的字符串或Python中的str。类数组可以在Scala中引用Seq，也可以在Python中引用list.
    }
}