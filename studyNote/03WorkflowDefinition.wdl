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
        注意，要将其视为可选输入，必须在输入部分中提供默认值.如果声明位于工作流的主体中，则认为它是一个中间值，不可重写.input中的变量值会被重写，但是不在input中的变量，属于工作流的中间值，那么就不不会被重写。03.02.WorkflowInput.wdl
        请注意，如果中间表达式对工作流作者很重要，仍然可以通过可选的输入覆盖它。上述工作流的修改版本演示了这一点。03.03.WorkflowInput.wdl{
            注意，工作流的控制流取决于是否提供了Int y值{
                1 如果为y提供了一个输入值，那么它将立即接收该值，并且t2可能在工作流启动时立即开始运行。
                2 在没有为y提供输入值的情况下，它需要等待t1完成后才会被赋值
            }
        }
        Optional inputs with defaults{
            因为表达式是静态的，被解析为可选的字符串String?值，并赋予默认值，但是可是被输入文件覆盖。请注意，如果您给一个值提供这样的可选类型，那么您只能在调用或表达式中使用该值。03.04.WorkflowInputs.wdl.(不能将Stirng?值作为String类型的输入量)
            这样做的原因是，用户可能希望提供以下输入文件来更改调用的有效性，而这样的输入将使对invalid的调用无效，因为它无法接受可选值
        }
    }
}
Call Statement{
    1 工作流可以通过call关键字调用其他任务/工作流。$namespaced_identifier是要运行哪个任务的引用。最常见的情况是，它只是一个任务的名称(参见下面的示例)，但它也可以使用。作为名称空间解析器
    2 所有调用语句必须是唯一可识别的。默认情况下，调用的唯一标识符是任务名(例如，调用foo将由名称foo引用)。但是，如果在工作流中调用foo两次，则后续的每个调用语句都需要使用as子句将自己别名为惟一名称:将foo调用起别名为bar。
    3 调用语句也可以引用工作流(例如调用other_workflow)。在这种情况下，$input部分指定工作流输入的子集，并且必须指定完全限定的名称。03.05.CallStatement.wdl}{
        $call_body是可选的，用于指定如何满足任务或工作流输入参数的子集，以及如何将任务输出映射到可见范围中定义的变量
        $input部分中的$variable_mapping将任务中的参数映射到表达式.这些表达式通常引用其他任务的输出，但它们可以是任意表达式。
        03.06.CallStatement.wdl
    }
    Call Input Blocks{
        如上所述，调用输入应该通过调用输入(调用my_task {input: x = 5})提供，否则它们将成为工作流输入(“my_workflow.my_task”)。x”:5)并防止工作流被组合成子工作流.在这两种情况下(即工作流指定调用输入，用户试图通过输入文件提供相同的输入)，工作流提交应该被拒绝，因为用户提供了一个意外的输入。
        这样做的原因是输入值是工作流控制流的固有部分，通过输入更改输入值对工作流的正确工作具有固有的危险。
        一如既往，如果作者选择允许，如果在输入块中声明作为输入的值，则可以重写这些值(即就是假如上一个任务的输出作为下一个任务的输入时，用户直接对下一个任务的输入会覆盖掉上一个任务的输出情况):03.07.CallInputBlocks.wdl
    }
    Sub Workflows{
        在工作流中调用工作流 03.08.SubWorkflows.wdl:注意，因为wdl文件只能包含一个工作流，所以子工作流只能通过导入来使用。否则，调用工作流或任务在语法上是等价的.指定输入和检索输出的方式与任务调用相同。
    }
}
Scatter {
    一个“scatter”子句定义了主体($scatter_body)中的所有内容都可以并行运行。圆括号中的子句($scatter_iteration_statement)声明要分散哪个集合，以及要调用哪个元素.$scatter_iteration_statement有两部分:“item”和“collection”。例如，scatter(x in y)将x定义为项，y定义为集合{
        例如：Array[String] y
        x:必须是标识符。例如:所以x是String
        y：必须是数组类型。例如：y就是Array[String]
    }
    $scatter_body定义了一组作用域，这些作用域将在这个分散块的上下文中执行
    例如，如果$expression是一个大小为3的整数数组，那么散点子句的主体可以并行执行3次。$identifier将引用数组中的每个整数
    03.09.Scatter.wdl{
        在这个例子中，task2依赖于task1。变量i有一个隐式索引属性，以确保我们可以访问task1的正确输出。由于task1和task2都运行N次，其中N是数组整数的长度，所以这些任务的任何标量输出现在都是数组。
    }
}
Conditionals{
    条件语句仅在表达式计算结果为true时执行主体;
    当调用的输出被引用到相同的包含之外时，如果需要将其作为可选类型处理.03.10.Conditionals.wdl
    可选类型可以通过使用select_all和select_first数组函数进行合并.03.11.Conditionals.wdl
    当嵌套条件块时，引用的输出仅仅是单层的条件(也就是说，我们从不产生Int??)或更深的):03.12.Conditionals.wdl
}