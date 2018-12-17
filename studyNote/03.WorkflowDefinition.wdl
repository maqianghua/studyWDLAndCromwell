03WorkflowDefinition{
    工作流是使用关键字workflow声明的，后面跟着工作流程名称和工作流程主体，使用大括号。03.01.WorkflowDefinition.wdl
}
Workflow Elements{
    工作流可能具有以下元素{
        输入部分(如果工作流需要输入，则需要)
        中间声明(尽可能多，可选)
        对任务或子工作流的调用(尽可能多，可选)
        Scatter blocks (尽可能多，可选)
        If blocks  (尽可能多，可选)
        输出部分(如果工作流需要输入，则需要)
        一个meta部分（可选)
        一个Parameter_meta部分（可选）
    }
}
Workflow Inputs{
    与任务一样，工作流必须在输入部分声明其输入，如下所示。
    Optional Inputs指定一个可选输入{
        workflow foo {
            input {
                Int? x
                File? y
            }
            # remain workflow content
        }
        在这些情况下，可能为该输入提供值，也可能不提供值。以下都是上述工作流的有效输入文件{
            情况1：{}
            情况2：{"x":100}
            情况3：{"x":null,"y":"/path/to/file"}
            情况4：{"x":100,"y":"/path/to/file"}
        }
    }
    Declared Inputs: Defaults and Overrides{
        任务和工作流可以通过表达式内置默认值
        在这种情况下，x应该被视为任务或工作流的可选输入，但与没有缺省值的可选输入不同，类型可以是Int，而不是Int?如果提供了输入，应该使用该值。如果没有提供x的输入值，则计算并使用默认表达式。
        注意，要将其视为可选输入，必须在输入部分中提供默认值.如果声明位于工作流的主体中，则认为它是一个中间值，不可重写.input中的变量值会被重写，但是不在input中的变量，属于工作流的中间值，那么就不不会被重写。
    }
}