19 Import Statements {
    一个WDL文件包含import声明，包含来自其他资源的WDL代码
    import 声明指定那个$string被解析为URL，指向一个WDL文件，engine负责解析URL并下载其内容，每一个URL的文档内容必须是WDL代码
    每一个Imported wdl文件需要一个命令空间，可以使用标识符指定（通过标示符语法）假如你没有分别执行一个命名空间的标识符，那么默认的命令空间标识符就是WDL的文件名（不包含.wdl扩展名),对于所有imported WDL文件，对于所有imported WDL文件，tasks和workflows来自导入的文件，仅能通过分配的命名空间来访问。import.wdl
    对于导入URL，引擎至少支持以下协议：
        http:// 和 https://
        file://
        无协议(将被解析为file://)
}
18 Version{
    对于可移植性目标，WDL文档版本的说明很重要，这样engine知道怎样去运行它，从draft-3开始，所有的WDL文件第一行必须有版本声明：比如：version draft-3
    任何没有version字段的WDL文件，被认为是draft-2，所有的WDL文件在一个workflow中必须有相同的version。
}
17 Document{
    $document是解析树的根部，它由一个或多个import 声明，task或workflow的定义
}
16 Pair Literals{
    Pair值在WDL中被指定，使用另一个Python语法，如下：Pair[Int, String] twenty_threes = (23, "twenty-three")
    也可以在workflow的输入json文件中指定Pair的值，使用"Left"和"Right"，给定一个workflow水平的变量twenty_threes，在json文件中应该如下定义：
    {
        "wf_hello.twenty_three" :{"Left":23, "Right":"twenty-three"}
    }
}
15 从Map来阈值Object{
    从map literals约制object，但是注意以下行为的不同：Object.wdl
    假如一个Object使用对象类型，Object map_syntax=object{a:...}这样的语法，那么它的key值去"a","b"和"c"
    假如一个Object使用map类型的Object map_coercion={a:..},那么它的key就是一个表达式，因此a将会是一个变量，引用到前面定义的一个变量String a = 'beware'
}
14 Objet Literals{
    Objects Literals定义和maps很类似，但是在{：之前间接需要object 关键字{
        Object f =Object{
            a:10,
            b:11
        }
    object 关键字允许键值字段被定义为标识符，而不是String Literals(eg:a:而不是"a":)
    }
}
13 map Literals{
    使用像Python语法那样定义Maps的值：
    Map[Int, Int] = {1:10,2:11}
    Map[String, Int] = {"a":1,"b"：2}
}
12 Array Literals{
    数组值可以像使用Python语法那样：Array[String] a= ["a", "b","c"]
    Array[Int] b= [0,1,2]
}
11 Function Calls{
    函数调用，刑辱func(p1,p2,p3...),要么是标准库函数或者是engine定义的函数，目前定义的迭代器，用户不会定义他们自己的函数。
}
10 Pair indexing{
    给定一个Pair x，那么该类型的左边的元素和右边的元素通过x.left和x.right获取。
}
9 Map and Array Indexing{
    x[y]是maps和arrays的索引语法，假如x是数组，那么y必须是整数，假如x是map，那么y就是map中的key。
}
8 Member Access{
    成员访问{
        语法x.y访问成员变量，x必须是Object或workflow中一个task。一个task被认为是一个对象，task的输出是它的属性。如MemberAccess.wdl
    }
}
7 Expressions{
    if then else：该操作需要三个参数，一个情况表达式，一个真值表达式，一个假值表达式。情况表达式总是被计算，假如情况为真那么真值表达式将会被计算并返回。假如情况表达式是假，假值表达式将会被计算并返回。不管真值表达式被计算还是假值表达式，返回值类型一致，或者运行错误会发生。
    案例：{
        Boolean morning =true
        String greeting = "good" + if moring then "moring" else "afternoon"
        Int array_length=length(array)
        runtime {
            memory:if array_length >100 then "16BG" else "8GB"
        }

    }
}
6 Declarations{
    变量声明在任意范围的顶部
    在task中定义，变量将被解析为task的输入，不是命令行的一部分。
    当一个变量没有被初始化，在workflow或task运行前期望该值被提供。
    一些声明变量的例子{        
        File x
        String y = "abc"
        Float pi = 3 + .14
        Map[String, String] m
    }
    一个变量可以是task的outputs元素，比如：test.wdl;在call test as x和call test as y成功完成之前，strs不会被定义。task x或y任意一个失败，strs的的值将会返回一个错误，也就意味着call test2 as z 操作将会被跳过。
}
5 Fully Qualified Names & Namespaced Identifiers{
    一个合格的独一无二的标识符，call，和call input 或call output例如：other.wdl和main.wdl
    名称空间标识符和完全限定名有相同的语法。左边的为空间标识符，右边的为workflow，task，空间名中的空间名。像如下workflow：
    import "other.wdl" as ns
    workflow wf {
      call ns.ns2.task
    }
    如上：ns.ns2.task是一个名称空间标识符(看Statement调用部分看更多细节)，名称空间标识符，全限定名在左边，即就是ns.ns2.task被解释为((ns.ns2).task)，接为止ns.ns2将被解析为名称空间标识，.task将会被应用。假如在ns内部ns2是一个task，那么名称空间的标识ns.ns2是不合法的。
}
4 Type{
    所有的输入和输出必须定义类型，以下类型在WDL中{
        Int i = 0                  # An integer value
        Float f = 27.3             # A floating point number
        Boolean b = true           # A boolean true/false
        String s = "hello, world"  # A string value
        File f = "path/to/file"    # A file
    }
    此外以下的复合类型也会被构建，由其它类型参数化，下面的P代表上面原始类型中的任意一个，x和y代表任何合法的类型（甚至是组合嵌套类型）{
        Array[X] xs = [x1, x2, x3]                    # An array of Xs
        Map[P,Y] p_to_y = { p1: y1, p2: y2, p3: y3 }  # A map from Ps to Ys
        Pair[X,Y] x_and_y = (x, y)                    # A pair of one X and one Y
        Object o = { "field1": f1, "field2": f2 }     # Object keys are always `String`s
    }
    类型也有一个量化的后缀（？或+）{
        ？意味着该值是可选值，在调用或函数中国被使用，接受可选值
        + 仅仅应用于数组类型，它表示那个数组不能为空        
    }
    可选参数和类型约束部分有更多关于后缀细节的介绍
    关于类型的更多信息和它们如何用来构建commands和定义tasks的输出，看Data Types和序列化部分
    自定义类型{
        WDL提供的构建自定义组合类型叫做Structs，可以直接在WDL中定义并像其他类型一样使用，关于更多它的用法信息，查看Structs部分
    }
}
3 Language Specification{
    全局语法规则{
        空格，字符串，标识符，和常量
        字符串可以接收在单引号和双引号之间的内容
            任何字符不在以下集合中：\\,"(或'对于单引字符串)，\n
            一个转义序列以\\开始，后面紧跟以下字符中的一个：\\,",',[nrbtfav],?'
            转义序列\\紧跟[0,7]中的三个数，指的是8进制数
            转移序列\\x,紧跟十六进制字符0-9a-fA-F.指的是16进制的转移码
            转义序列\\u或\\U，后面4个或8个16进制字符0-9a-fA-F，指的是一个Unicode码位
    }
}
2 State of the Specification{
    2015年8月17更新
    增加了全限定符的概念和名称标识符
    改变了task的定义，所有声明都是task的inputs
    改变了command参数（${}）接收表达式和更少的声明元素
        command参数也需要评估其原始类型
    workflow增加output部分
    增加很多标准的函数库序列化和反序列化WDL的值
    详细说明scope，namespace和变量解析语义
}
1 Introduction{
    WDL是一种易读易写表达tasks和workflow的语言，
    task 定义方式是将UNIX command和环境封装好，并表现为一种函数功能。
    执行WDL需要json格式的inputs文件作为输入。
    一个简单的工作流处理并行的任务将会如下所示：
    workflow example {
        input {
            Array[File] files
        }
        scatter (path ion files) {
            call hello {input: in = path}
        }
    }    
}