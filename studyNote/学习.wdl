

1. WDL目前对于array不支持反向索引,即array[-1]:不会返回最后一个元素值。

2. 正则表达式：Regular Expression
grep：
egrep： egrep使用格式与grep基本相同(可使用grep -E command实现同样效果)，不过egrep只支持扩展的正则表达式，不支持基本正则表达式
fgrep： fgrep不支持正则表达式，只能实现全部关键字匹配，个人感觉实际工作中不太常用

type:数据类型：
Int i = 0                  # An integer value
Float f = 27.3             # A floating point number
Boolean b = true           # A boolean true/false
String s = "hello, world"  # A string value
File f = "path/to/file"    # A file
Array[X] xs = [x1, x2, x3]                    # An array of Xs
Map[P,Y] p_to_y = { p1: y1, p2: y2, p3: y3 }  # A map from Ps to Ys
Pair[X,Y] x_and_y = (x, y)                    # A pair of one X and one Y
Object o = { "field1": f1, "field2": f2 }     # Object keys are always `String`s
Object f = object {
  a: 10,
  b: 11
}
File
Array[File]
Pair[Int, Array[String]]
Map[String, String]

类型后面可以跟量词（?或+）后缀
？ 意味着值是可选的，仅在调用和函数中被使用，接受可选的值。
+ 仅应用于数组类型，它表示请求的数组不能为空
? means that the value is optional. It can only be used in calls or functions that accept optional values.
+ can only be applied to Array types, and it signifies that the array is required to be non-empty.

用户自定义类型：
WDL支持用户自定义类型，叫Structs

ns.ns2.task等价于(ns.ns2).task,ns.ns2是命名空间，但是当ns2是ns的一个task命名时，那ns.ns2将会非法
WDL的语法：x.y涉及到成员被获取，x必须是一个Object或者workflow的task，task是object对象，task的输出都是属性

所有的WDL文件被一个workflow调用，必须是相同版本的（same version）


