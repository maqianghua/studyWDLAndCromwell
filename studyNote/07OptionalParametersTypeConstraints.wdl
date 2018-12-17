Optional Parameters & Type Constraints{
    在某些情况下,可选类型可以?或+为前缀{
        ？：表示参数是可选的。用户不需要为参数指定值，就可以满足工作流的所有输入。
        +：只适用于数组类型，它表示数组值必须包含一个或多个元素的约束。
    }
    案例：07.01.ptionalParametersTypeConstraints.wdl{
        假如提供的json输入值{
            wf.test.a=["1","2","3"]
            wf.test.b=[]
        }
        工作流引擎会拒绝它，因为wf.test.b至少有一个元素，假如改成下面的输入情况{
            wf.test.a=["1","2","3"]
            wf.test.b=["x"]
        }
        以上输入就是有效的合法的输入，wf.test.c不需要给定，给定以上值，命令就会实例化为{
            /bin/mycmd 1 2 3
            /bin/mycmd x
            /bin/mycmd
        }
        假如输入是如下所示{
            wf.test.a=["1","2","3"]
            wf.test.b=["x"，"y"]
            wf.test.c=["a"，"b","c","d"]
        }
        命令行就会解析为{
            /bin/mycmd 1 2 3
            /bin/mycmd x，y
            /bin/mycmd /path/to/c.txt
        }
    }
    Prepending a String to an Optional Parameter{
        有时，可选参数需要一个字符串前缀.
        07.02.OptionalParametersTypeConstrains.wdl{
            因为val是可选值，所以命令行会实例化成两种方式{
                1 python script.py --val=foobar
                2 python script.py --val=
                第二种情况很可能是一种错误情况，如果省略了val的值，那么应该去掉—val=这一部分，要解决这个问题，请按照以下方式修改模板标记中的表达式
                python script.py ${"--val=" + val}
            }
        }
    }
}