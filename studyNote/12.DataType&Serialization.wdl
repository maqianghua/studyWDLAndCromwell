Data Types & Serialization {
    任务和工作流为它们的输入参数指定了值，以便运行。这些输入参数的类型是任务或工作流上的声明。这些输入参数可以是任何有效类型
    基本类型{
        String Int Float File Boolean
    }
    组合类型{
        Array Map Object Pair
    }
    当WDL工作流引擎实例化任务命令部分中指定的命令时，它必须序列化所有${…}将命令中的标签转换为基本类型。
    例如，如果我正在编写一个对FASTQ文件列表进行操作的工具，那么可以通过多种方式将该列表传递给该任务.{
        每行包含一个文件路径的文件(举例：RScript analysis.R --files=fastq_list.txt)
        一个包含JSON列表的文件:(举例：RScript analysis.R --files=fastq_list.json)
        在命令行中枚举：(举例：RScript analysis.R 1.fastq 2.fastq 3.fastq )
    }
    每种方法都有其优点，一种方法可能更适合一种工具，而另一种方法可能更适合另一种工具。
    另一方面，任务需要能够将数据结构传回工作流引擎.举例：假设这个工具获取FASTQ列表，它想返回一个Map[File, Int]，表示每个FASTQ中的reads数目。工具可能选择将其输出为两列TSV或JSON对象，而WDL需要知道如何将其转换为适当的数据类型。
    WDL提供了一些标准的库函数，用于将数组等复合类型转换为文件等基本类型
    任务完成后，输出部分定义如何将文件和stdout/stderr转换为WDL类型。举例：12.01.DataTypeSerialization.wdl{
        在这里，表达式read_lines(stdout())表示“从stdout获取输出，分成几行，并以Array[String]的形式返回结果”。有关详细信息，请参见read_lines和stdout的定义
    }
}
Serialization of Task Inputs {
    Primitive Types{
        将原始输入序列化为字符串，直观上很容易，因为值只是转换为字符串并插入到命令行中。
        案例：12.01.SerializationOfTaskInputs.wdl{
            如果我为任务中的声明提供值为:{
                var     value 
                s       "str"
                i       2
                f       1.3
            }
        }
        命令会实例化为：python do_work.py str 2 1.3
    }
    Compound Types {
        复合类型(如数组和映射)必须转换为基本类型才能在命令中使用。有许多方法可以将复合类型转换为基本类型,如下文所述:
        Array serialization {
            两种方式序列化数组
                数组扩展：列表中的元素被平展为带有分隔符的字符串{
                    如果参数指定为${sep=' ' my_param}，则可以使用数组扁平化方法。必须将my_param声明为基本类型数组。当指定my_param的值时，这些值与分隔符连接在一起。如下是通过空格分隔符连接一起。12.02.ArraySerialization.wdl{
                        给bams变量传递一个数组{
                            Element
                            /path/to/1.bam
                            /path/to/2.bam
                            /path/to/3.bam
                        }
                        会产生如下的命令：python script.py --bams=/path/to/1.bam,/path/to/2.bam,/path/to/3.bam
                    }
                }
                文件创建：创建一个包含数组元素的文件，并将该文件作为命令行上的参数传递。可以将数组转换为文件，数组中的每个元素都占据文件中的一行12.03.ArraySerializationWrite_lines.wdl{
                    给bams变脸如下数组{
                        Element
                        /path/to/1.bam
                        /path/to/2.bam
                        /path/to/3.bam
                    }
                    命令行的结果如下：
                    sh script.sh /jobs/564758/bams
                    文件、jobs/564758/bams包含:
                        /path/to/1.bam
                        /path/to/2.bam
                        /path/to/3.bam
                }
            使用write_json()数组序列化{
                可以将数组转换为JSON文档，其中JSON文件的文件路径作为参数传入12.04.ArraySerializationWrite_json.wdl{
                    给bams变脸如下数组{
                        Element
                        /path/to/1.bam
                        /path/to/2.bam
                        /path/to/3.bam
                    }
                    命令行的结果如下：
                    sh script.sh /jobs/564758/bams.json
                    文件/jobs/564758/bams.json包含：
                    {
                        "/path/to/1.bam",
                        "/path/to/2.bam",
                    }
                }
            }
        }
        Map serialization {
            映射类型不能在命令行上直接序列化，必须通过文件序列化.
            Map serialization using write_map(){
                映射类型可以序列化为一个两列TSV文件，命令行上的参数使用write_map()函数给出该文件的路径:12.05.MapSerializationWrite_map.wdl
                假如sample_quality_scores给定这样的Map[String,Float]{
                    Key     Value
                    sample1 98
                    sample2 95
                    sample3 75
                }
                命令行的结果如下：
                sh script.sh /jobs/564757/sample_quality_score.tsv
                文件/jobs/564757/sample_quality_score.tsv包含：{
                    sample1 98
                    sample2 95
                    sample3 75
            }
            Map serialization using write_json() {
                映射类型也可以序列化为JSON文件，命令行上的参数使用write_json()函数给出该文件的路径：12.06.MapSerializationWrite_json.wdl
                 假如sample_quality_scores给定这样的Map{
                    Key     Value
                    sample1 98
                    sample2 95
                    sample3 75
                 }
                 结果命令行将会如下所示：
                 sh script.sh /jobs/564757/sample_quality_score.json
                 文件/jobs/564757/sample_quality_scores.json包含如下：{
                    "sample1": 98,
                    "sample2": 95,
                    "sample3": 75
                 }
            }
        }
        Object serialization{
            对象是映射的更一般的情况，其中键是字符串，值是任意类型的，并作为字符串处理。对象可以使用write_object()或write_json()函数序列化
            Object serialization using write_object(){
                12.07.ObjectSerization.wdl
                假如sample提供值如下：{
                    Attribute   Value
                    attr1       value1
                    attr2       value2
                    attr3       value3
                    attr4       value4
                }
                命令行的结果如下：
                perl script.pl /jobs/564759/sample.tsv
                文件/jobs/564759/sample.tsv包含：{
                    attr1\tattr2\tattr3\tattr4
                    value1\tvalue2\tvalue3\tvalue4
                }
            }
            Object serialization using write_json() {
                案例：12.08.ObjectSerizationWrite_json.wdl
                假如sample提供值如下：{
                    Attribute   Value
                    attr1       value1
                    attr2       value2
                    attr3       value3
                    attr4       value4
                }
                命令行的结果如下：
                perl script.pl /jobs/564759/sample.json
                文件/jobs/564759/sample.json包含：{
                    "attr1":"value1",
                    "attr2":"value2",
                    "attr3":"value3",
                    "attr4":"value4"
                }
            }
        }
        Array[Object] serialization {
            Array[Object]必须保证数组中的所有对象具有相同的属性集。可以使用write_objects()或write_json()函数序列化这些函数，如下面的部分所述
            Array[Object] serialization using write_objects(){
                Array[Object]可以使用write_objects()序列化成一个TSV文件：12.09.ArraySerializationWrite_objects.wdl
                变量名sample提供如下：{
                    index   Attribute   value
                    0       attr1       value1
                            attr2       value2
                            attr3       value3
                            attr4       value4
                    1       attr5       value5
                            attr6       value6
                            attr7       value7
                            attr8       value8
                }
                命令行的结果如下：
                perl script.pl /jobs/564759/sample.tsv
                文件/jobs/564759/sample.tsv将包含：{
                    attr1\tattr2\tattr3\tattr4
                    value1\tvalue2\tvalue3\tvalue4
                    value5\tvalue6\tvalue7\tvalue8
                }
            }
            Array[Object] serialization using write_json() {
                Array[Object]可以使用write_json()序列化为JSON文件12.10.ArraySerializationWrite_json.wdl
                变量名sample提供如下：{
                    index   Attribute   value
                    0       attr1       value1
                            attr2       value2
                            attr3       value3
                            attr4       value4
                    1       attr5       value5
                            attr6       value6
                            attr7       value7
                            attr8       value8
                }
                命令行的结果如下：
                perl script.pl /jobs/564759/sample.json
                文件/jobs/564759/sample.json包含{
                    [
                      {
                        "attr1": "value1",
                        "attr2": "value2",
                        "attr3": "value3",
                        "attr4": "value4"
                      },
                      {
                        "attr1": "value5",
                        "attr2": "value6",
                        "attr3": "value7",
                        "attr4": "value8"
                      }
                    ]
                }
            }
        }
    }
}
De-serialization of Task Outputs{
    任务的命令只能输出文件形式的数据。因此，WDL中的每个反序列化函数都接受一个文件输入并返回一个WDL类型
    Primitive Types{
        原始基本类型的反序列化是通过read_*函数完成的。例如，read_int(“file/path”)和read_string(“file/path”)
        案例：12.11.PrimitiveDeSerialization.wdl
        file_with_int和file_with_uri文件都应该包含一行值.然后根据变量的类型验证该值.然后根据变量的类型验证该值.如果file_with_int包含一行文本“foobar”，则工作流必须以错误的方式使该任务失败。
    }
    Compound Types{
        任务还可以将数组、映射或对象数据结构以两种主要格式输出到文件或stdout/stderr{
            JSON:因为它很自然地适合WDL中的类型
            基于文本或TSV：这些通常是简单的表和基于文本的编码(例如，Array[String]可以通过将每个元素作为文件中的一行来序列化)
        }
        Array deserialization{
            Arrays从以下格式反序列化{
                包含JSON数组作为顶级元素的文件。
                需要将每一行解释为数组元素的任何文件
            }
            Array deserialization using read_lines() {
                read_lines()将返回一个Array[String]，其中数组中的每个元素都是文件中的一行。这个返回值可以自动转换为其他数组类型。12.12.ArrayDeserialization.wdl:my_int将包含10个从0到10的随机整数
            }
            Array deserialization using read_json(){
                read_json()将返回JSON文件中驻留的任何数据类型.12.13.ArrayDeserializationread_json.wdl:这个任务将把元素“foo”和“bar”的数组分配给my_array.如果echo语句是echo '{"foo": "bar"}'，则引擎必须因类型不匹配而使任务失败
            }
        }
        Map deserialization {
            Maps从以下文件格式反序列化：{
                包含JSON对象作为顶级元素的文件。
                包含两列TSV文件的文件
            }
            Map deserialization using read_map(){
                read_map()将返回一个Map[String, String]，其中键是TSV输入文件中的第一列，对应的值是第二列。这个返回值可以自动转换为其他Map类型，案例：12.14.MapDeserializationRead_map.wdl:这将把包含三个键(key_0、key_1和key_2)的映射和三个分别的值(0,1和2)作为my_int的值
            }
            Map deserialization using read_json() {
                read_json()将返回JSON文件中驻留的任何数据类型。：如果该文件包含具有同类键/值对类型(例如String -> int对)的JSON对象，那么read_json()函数将返回一个映射。案例：12.15.MapDeserializationRead_json.wdl:这个任务将把echo语句中的一个键-值对映射分配给my_map如果echo语句是echo '["foo"， "bar"]'，则引擎必须因类型不匹配而使任务失败
            }
        }
        Object deserialization{
            对象从包含两行n列TSV文件的文件中反序列化。第一行是对象属性名，第二行对应的条目是值。
            Object deserialization using read_object(){
                read_object()将返回一个对象，其中键是TSV输入文件中的第一行，对应的值是第二行(对应的列)。12.16.ObjectDeserializationRead_object.wdl:这将把一个包含三个属性(key_0、key_1和key_2)的对象和三个分别的值(value_0、value_1和value_2)作为my_obj的值
            }
        }
        Array[Object] deserialization {
            Array[Object]必须假设数组中的所有对象都是同构的(它们具有相同的属性，但是属性不必具有相同的值)
            Array[Object]从包含至少2行和统一的n列TSV文件的文件中反序列化。第一行是对象属性名，后续行的相应条目是值
            Object deserialization using read_objects(){
                read_object()将返回一个对象，其中键是TSV输入文件中的第一行，对应的值是第二行(对应的列)。案例：12.17.ArraryObjectDeserializationRead_objects.wdl:这将创建一个由三个相同的对象组成的数组，其中包含三个属性(key_0、key_1和key_2)和三个值(value_0、value_1和value_2)作为my_obj的值
            }
        }
    }
}