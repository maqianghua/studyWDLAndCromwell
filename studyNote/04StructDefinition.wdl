Struct Definition{
    1 struct是类似于c的结构，它允许用户创建由以前存在的类型组成的新的复合类型.然后，可以在任务或工作流定义中使用struct作为声明，替代任何其他常规类型.在许多情况下，结构体会取代对象类型，并支持对其成员进行适当的类型设置.
    2 结构是与任何其他结构分开声明的，不能在任何工作流或任务定义中声明。它们属于写入它们的WDL文件的名称空间，因此在该WDL中可以全局访问。此外，在任务、工作流或其他结构中使用之前，必须对所有结构进行评估
    3 结构可以使用struct关键字定义，并且只有一个由类型化声明组成的部分.
}
Struct Declarations{
    1. struct的唯一内容是一组声明.声明可以是任何基本类型或复合类型，也可以是其他结构，其定义方式与任何其他部分相同.需要注意的是，结构体中的声明不允许在初始成员声明之后使用表达式语句。一旦定义了所有结构，就会将它们添加到可从WDL中的任何其他构造访问的全局命名空间中。
    合法的struct定义：04.01.StructDeclarations.wdl
    不合法的struct定义：04.02.StructDeclarations.wdl
    复合类型还可以在结构中使用，以便轻松地将它们封装在单个对象中。04.03.StructDeclarations.wdl
    可选和非空结构值。Struct声明可以是可选的，也可以是非空的(如果它们是数组类型的话)。04.04.StructDeclarations.wdl
}
Using a Struct{
    在工作流、任务或输出部分的声明部分中使用struct时，您可以像定义任何其他类型一样定义它们
    举例：04.05.UsingAStruct.wdl
    在工作流中使用struct，举例：04.06.UsingAStruct.wdl
}
Struct Assignment from Object Literal{
    结构可以使用对象文字来赋值。在编写对象时，所有条目必须符合或强制进入它们被分配到的底层类型：Person a ={"name":"john","age":30}
}
Struct Member Access{
    为了访问结构中的成员，请使用对象表示法.等价于:myStruct.myName.如果基础成员是支持成员访问的复杂类型，则可以按照该特定类型定义的方式访问其元素.案例定义的struct如下：
    struct Experiment {
        Array[File] experimentFiles
        Map[String,String] experimentData
    }
    访问experimentFiles的第n个元素和experimentData的任何元素应该是这样的,情况1：
    workflow workflow_a{
        Experiment myExperiment
        File firstFile = myExperiment.experimentFiles[0]
        String experimentName = myExperiment.experimentData["Name"]
    }
    如果结构本身是数组或其他类型的成员,情况2：{
        workflow workflow_a {
            Array[Experiment] myExperiments
            File firstFileFromFirstExperiment = myExperiments[0].experimentFiles[0]
            File experimentNameFromFirstExperiment=bams[0].experimentData['name']
        }
    }
}
Importing Structs{
    导入的WDL中定义的任何结构都将被添加到全局名称空间中，而不是导入的WDL名称空间的一部分.如果两个结构名称相同，则需要解决名称冲突。为此，可以在import语句中定义的别名下导入一个或多个结构体。
    例如，如果您当前的WDL定义了一个名为实验的结构体，而导入的WDL还定义了另一个名为实验的结构体，那么您可以按照以下方式对它们进行别名:import http://example.com/example.wdl as ex alias Experiment as OtherExperiment
    为了解析多个结构体，只需添加额外的别名语句:{
        import http://example.com/another_exampl.wdl as ex2
            alias Parent as Parent2
            alias Child as Child2
            alias GrandChild as GrandChild2
    }
    需要注意的是，从文件2导入时，将导入文件2的全局命名空间中的所有结构。这包括来自文件2中另一个导入的WDL的结构，即使它们是别名的.如果结构体在文件2中别名，它将以别名的名称导入文件1。
    注意：即使没有遇到任何冲突，也可以使用别名惟一地标识任何结构
}