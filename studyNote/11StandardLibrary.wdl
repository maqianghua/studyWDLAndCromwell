Standard Library

File stdout():返回此任务生成的标准输出的文件引用。
File stderr():返回此任务生成的stderr的文件引用。
Array[String] read_lines(String|File){
    给定一个类似文件的对象(字符串，文件)作为参数，它将读取每一行作为字符串，并返回文件中行的Array[String]表示。
    返回Array[String]中的行顺序必须是类文件对象中的行出现的顺序
    这个任务将通过一个文件grep并返回与模式匹配的所有字符串.11.01.Read_lines.wdl{
        如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败.失败的例子包括但不限于无法访问文件、读取文件时资源限制(例如内存)以及实现强加的文件大小限制
    }
}
Array[Array[String]] read_tsv(String|File){
    read_tsv()函数接受一个参数，该参数是一个类似文件的对象(String, File)，并返回一个Array[Array[String]]，表示来自TSV文件的表.
    如果参数是字符串，则假定它是相对于任务当前工作目录的本地文件路径
    例如，如果我写一个任务输出一个文件到。/results/file_list。，我的任务定义为:11.02.read_tsv.wdl{
        然后当任务完成时，全名称outputs_table变量./results/file_list.tsv必须是有效的tsv文件，否则将报告错误。
        如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败。失败的例子包括但不限于无法访问文件、读取文件时资源限制(例如内存)和实现强加的文件大小限制。
    }
}
Map[String, String] read_map(String|File) {
    给定一个类似文件的object(String、File)作为参数，它将从文件中读取每一行，并期望这一行具有col1\tcol2格式。换句话说，类文件的对象必须是一个两列的TSV文件.
    这个任务将通过一个文件grep并返回与模式匹配的所有字符串.下面的任务将把一个两列的TSV写到标准输出，它将被解释为Map[String, String]:11.03.read_map.wdl{
        如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败。失败的例子包括但不限于无法访问文件、读取文件时资源限制(例如内存)和实现强加的文件大小限制。
    }
}
Object read_object(String|File) {
    给定一个包含2行和n列TSV文件的类文件对象，该函数将把它转换为一个Object:11.04.read_object.wdl{
        该命令行将会输出以下值{
            key_1\tkey_2\tkey_3
            value_1\tvalue_2\tvalue_3
        }
        在WDL中以上值会变成这样的对象{
            Attribute   value
            key_1       "value_1"
            key_2       "value_2"
            key_3       "value_3"
        }
        如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败。失败的例子包括但不限于无法访问文件、读取文件时资源限制(例如内存)和实现强加的文件大小限制。
    }
}
Array[Object] read_objects(String|File){
     给定一个包含2行和n列TSV文件的类文件对象，该函数将把它转换为一个Object:11.05.read_object.wdl{
        该命令行将会输出以下值{
            key_1\tkey_2\tkey_3
            value_1\tvalue_2\tvalue_3
        }
        在WDL中以上值会变成这样的对象{
            index   Attribute   Value
            0       key_1       "value_1"
                    key_2       "value_2"
                    key_3       "value_3"
            1       key_1       "value_1"
                    key_2       "value_2"
                    key_3       "value_3"
            2       key_1       "value_1"
                    key_2       "value_2"
                    key_3       "value_3"
        }
        如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败。失败的例子包括但不限于无法访问文件、读取文件时资源限制(例如内存)和实现强加的文件大小限制。
     }
}
mixed read_json(String|File) {
    read_json()函数接受一个参数，这是一个类似文件的对象(字符串、文件)，并返回与JSON文件中的数据结构匹配的数据类型。JSON类型到WDL类型的映射为:{
        JOSN Type   WDL Type
        Object      Map[String,?]
        array       Array[?]
        number      Int or Float
        string      String
        boolean     boolean
        null        ???
    }
    如果参数是字符串，则假定它是相对于任务当前工作目录的本地文件路径。例如，如果我写一个任务输出一个文件到./results/file_list.json，我的任务定义为:11.06.read_json.wdl{
        然后当任务完成时，填充output_table变量./results/file_list.json必须是有效的TSV文件，否则将报告错误.
        如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败。失败的例子包括但不限于无法访问文件、读取文件时资源限制(例如内存)和实现强加的文件大小限制。
    }
}
Int read_int(String|File){
    函数read_int()的作用是:获取一个文件路径，该文件包含一行，其中包含一个整数。这个函数返回那个整数
    如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败。
}
String read_string(String|File){
    函数的作用是:获取一个文件路径，该文件包含一行，其中包含一个字符串。这个函数返回那个字符串。
    不应该包含尾随换行字符
    如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败。失败的例子包括但不限于无法访问文件、读取文件时资源限制(例如内存)和实现强加的文件大小限制。
}
Float read_float(String|File) {
    函数的作用是:获取一个文件路径，该文件包含一行，上面有一个浮点数。这个函数返回那个浮点数。
    如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败。失败的例子包括但不限于无法访问文件、读取文件时资源限制(例如内存)和实现强加的文件大小限制。
}
Boolean read_boolean(String|File) {
    函数的作用是:获取一个文件路径，该文件包含一行一个布尔值(值为true或false)。这个函数返回那个布尔值。
    如果由于任何原因无法读取文件的全部内容，调用任务或工作流将被视为失败。失败的例子包括但不限于无法访问文件、读取文件时资源限制(例如内存)和实现强加的文件大小限制。
}
File write_lines(Array[String]) {
    给定一个与Array[String]兼容的元素，它将每个元素写入文件中它自己的行。用换行符\n字符作为行分隔符。
    案例：11.07.write_lines.wdl{
        该任务的执行的命令行代码如下：
        ./script --file-list=/local/fs/tmp/array.txt
        那么/local/fs/tmp/array.txt包含：
            first
            second
            third
    }
}
File write_tsv(Array[Array[String]]) {
    给定一个与Array[Array[String]]兼容的东西，它将写入数据结构的TSV文件
    案例：11.08.write_tsv.wdl{
        任务运行的命令如下：
        ./script --tsv=/local/fs/tmp/array.tsv
        并且/local/fs/tmp/array.tsv包含：
        one\ttwo\tthree
        un\tdeux\ttrois
    }
}
File write_map(Map[String, String]) {
    给定一些与Map[String, String]兼容的东西，这将写入数据结构的TSV文件
    案例：11.09.write_map.wdl{
        任务运行的命令如下：
        ./script --map=/local/fs/tmp/map.tsv
        并且/local/fs/tmp/map.tsv将包含
        key1\tvalue1
        key2\tvalue2
    }
}
File write_object(Object) {
    给定任何对象，这将写出一个包含该对象的属性和值的2行n列TSV文件.
    案例：11.10.write_object.wdl{
        假如输入有值：{
            Attribute       value
            key_1           "value_1"
            key_2           "value_2"
            key_3           "value_3"
        }
        命令初始化为：
        /bin/do_work --obj=/path/to/input.tsv
        /path/to/input.tsv包含：
        key_1\tkey_2\tkey_3
        value_1\tvalue_2\tvalue_3
    }
}
File write_objects(Array[Object]){
    给定任何Array[Object]，这将写出包含每个对象的属性和值的2+行、n列TSV文件。
    案例：11.11.write_objects.wdl{
        假如in输入值是：{
            index   Attribute   Value
            0       key_1       "value_1"
                    key_2       "value_2"
                    key_3       "value_3"
            1       key_1       "value_4"
                    key_2       "value_5"
                    key_3       "value_6"
            2       key_1       "value_7"
                    key_2       "value_8"
                    key_3       "value_9"
        }
        命令初始化为：
        /bin/do_work --obj=/path/to/input.tsv
        文件/path/to/input.tsv包含：
        key_1\tkey_2\tkey_3
        value_1\tvalue_2\tvalue_3
        value_4\tvalue_5\tvalue_6
        value_7\tvalue_8\tvalue_9
    }
}
File write_json(mixed) {
    对于任何类型的内容，这都将JSON等效于文件。请参见read_json()定义中的表.
    案例：11.12.write_json.wdl{
        任务运行的命令如下：
        ./script --tsv=/local/fs/tmp/map.json
        文件/local/fs/tmp/map.json包含：
        {
            "key1":"value1",
            "key2":"value2"
        }
    }
}
Float size(File,[String]) {
    给定一个文件和一个字符串(可选)，返回文件的大小(以字节为单位)或以第二个参数指定的单元为单位。
    案例：11.13.FloatSize.wdl{
        支持单位是KiloByte(“K”、“KB”),MegaByte(“M”,“MB”), GigaByte (“G”、“GB”), TeraByte (“T”,“TB”)以及他们的二进制版本的“Ki”(“KiB”),“Mi”(MiB)、“Gi”(“GiB”),“Ti”(“TiB”)。默认单位是Byte(“B”)
    }
    Acceptable compound input types{
        品种的大小函数也存在以下复合类型。字符串单元始终被视为如上所述。注意，为了避免数字溢出，很长的文件数组可能更适合较大的单元{
            Float size(File?, [String]):返回文件的大小(如果指定)，否则返回0.0。
            Float size(Array[File], [String]):返回数组中文件大小的总和。
            Float size(Array[File?], [String]):返回数组中所有指定文件的大小和。
        }
    }
}
String sub(String, String, String){
    给定3个字符串参数输入、模式、替换，本函数将替换输入中出现的任何匹配模式。模式应该是正则表达式。regex评估的细节将取决于运行WDL的执行引擎。案例：11.14.StringSub.wdl
    子函数还将接受输入并替换可以强制到字符串(例如文件)的参数。例如，这可以用来交换文件名的扩展名:案例：11.15.StringSub.wdl
}
Array[Int] range(Int) {
    给定一个整数参数，range函数创建一个长度等于给定参数的整数数组。例如range(3)提供的数组为:(0,1,2).元素值从0开始
}
Array[Array[X]] transpose(Array[Array[X]]){
    给定一个二维数组参数，转置函数根据标准矩阵转置规则对二维数组进行转置。例如转置((0,1,2)，(3,4,5)))将返回旋转后的二维数组:((0,3)，(1,4)，(2,5))。
}
Array[Pair[X,Y]] zip(Array[X], Array[Y]) {
    给定任意两种对象类型，zip函数以对对象的形式返回这些对象类型的点积。
    案例：11.16.ArrayZip.wdl
}
Array[Pair[X,Y]] cross(Array[X], Array[Y]) {
    给定任意两种对象类型，cross函数以对对象的形式返回这些对象类型的叉乘。案例：11.17.ArrayCross.wdl
}
Integer length(Array[X]) {
    给定一个数组，length函数以整数形式返回数组中的元素数
    案例：11.18.IntegerLength.wdl
}
Array[X] flatten(Array[Array[X]]) {
    给定一个数组数组，flatten函数将所有成员数组连接起来，以便显示结果。它不去重复元素。嵌套深度大于2的数组必须平铺两次(或更多)才能得到未嵌套的Array[X]。案例11.19.ArrayFlatten.wdl:{
        最后一个例子(aap2D)很有用，因为Map[X, Y]可以强制转化到Array[Pair[X, Y]]
    }
}
Array[String] prefix(String, Array[X]) {
    给定一个字符串和一个数组[X]，其中X是一个基本类型，prefix函数返回一个字符串数组，该字符串由输入数组的每个元素组成，每个元素以指定的前缀字符串作为前缀。案例：11.20.ArrayPrefix.wdl
}
X select_first(Array[X?]) {
    给定一个可选值数组，select_first将选择第一个定义的值并返回它。注意，这是一个运行时检查，并且要求至少存在一个定义值:如果在计算select_first时没有找到定义值，那么工作流将失败
}
Array[X] select_all(Array[X?]) {
    给定一个可选值数组，select_all将只选择那些定义的元素.
}
Boolean defined(X?) {
    如果参数是未设置的可选值，该函数将返回false。在其他情况下，它将返回true。
}
String basename(String){
    这个函数返回传递给它的文件路径的基名:basename("/path/to/file.txt")返回："file.txt"
    还支持一个可选参数，后缀删除:basename("/path/to/file.txt",".txt") 返回"file"
}
Int floor(Float), Int ceil(Float) and Int round(Float){
    将浮点数转化为整形数{
        floor:向下取整
        ceil:向上取整
        round:根据四舍五入法向最近的整数取整
    }
}
