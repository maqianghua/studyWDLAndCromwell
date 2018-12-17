Task Definition {
	task是一种声明性的构造，从一个模板构造一个命令。命令规范解析与引擎和后端无关，command是一个UNIX bash命令行式的运行。(理想状态在一个Docker镜像中)
	tasks分别定义他们的输入和输出，在任务之间构建依赖关系的关键是定义输入和输出
	定义一个task，用task name{...}在花括号中是以下部分
}
Task Section{
 	Task也许有以下组成部分
 		输入部分：input（task有inputs比必须有input）
 		无输入部分声明（很多情况是可选的）
 		command部分（必须的）
 		runtime部分（可选的）
 		output部分（假如有输出就是必须的）
 		meta部分（可选的）
 		parameter_meta部分(可选的)
}
Task Inputs {
	任务输入声明：应该在task块内申明inputs
	任务输入本地化：{
		文件输入必须特别处理，因为它们需要本地化到执行目录中
		在任务执行开始之前，文件被本地化到执行目录中
		当本地化文件时，引擎可以选择将文件放置在它喜欢的任何地方，只要它符合这些规则{
			原始文件名必须保留，即使它的路径已经更改
			两个名称相同的输入文件必须分开放置，以避免名称冲突
			出于相同存储目录的两个输入文件也必须本地化到相同的目录中，以便执行任务(请参阅下面版本控制文件系统的特殊情况处理)。
		}
		当WDL作者在命令部分中使用文件输入时，文件的完全限定的本地化路径将被替换到命令字符串中。		
	}
	特殊情况：文件系统版本{
		版本控制文件系统中一个文件的两个或多个版本可能具有相同的名称并来自相同的目录。在这种情况下，必须采用下列特别程序避免冲突
			第一个文件总是按照通常的规则正常放置。
			否则将覆盖此文件的后续文件将被放置在以版本命名的子目录中
		例如，假设文件有两个版本fs://path/to/A。txt正在本地化(标记版本1.0和1.1)。第一个可以本地化为/execution_dir/path/to/A.txt。然后必须将第二个文件放在/execution_dir/path/to/1.1/A.txt中
	}
	非输入声明{
		任务可以有声明，声明的目的是作为中间值，而不是作为输入，这些声明可以基于输入值，并且可以在命令部分中使用。例如，此任务接受单个输入对象，但将其写入JSON文件，然后该命令可以使用该JSON文件。02.01.Non-InputDeclarations.wdl
	}
}
Command Section{
	命令部分是任务部分，以关键字'command'开头，并包含在大括号{…}或三角括号<<<…> > >。它定义了一个shell命令，该命令将在所有输入分阶段执行和输出计算之前在执行环境中运行。命令体还允许占位符用于需要填充的命令行部分。表达式占位符用${…~ }或{…}取决于它们是出现在命令{}中还是出现在命令<< >>> body样式中
	这些占位符包含一个表达式，该表达式将使用任务中可用的输入或声明进行计算。然后在命令脚本中替换占位符，并给出计算结果。
	表达式结果最终必须转换为字符串，以便在命令脚本中取代占位符。这对于WDL基本类型(例如，不是数组、映射或对象)是立即可能的。要将数组放入命令块，必须使用sep指定分隔符(例如${sep="， " int_array})。
	Expression Placeholder Options{		
		sep - eg ${sep=", " array_value}
		sep{
			'sep'被解释为用于将多个参数连接在一起的分隔符字符串。sep只在表达式计算结果为数组时有效.
			比如：Array[Int] ints = [1,2,3]
				python script.py ${sep=',' numbers}	#python script.py 1,2,3
				python script.py ${sep=' ' numbers} #python script.py 1 2 3
			附加需求：sep必须只接受一个字符串作为它的值
		}
		true and false - eg ${true="--yes" false="--no" boolean_value}
		true and false{
			“true”和“false”可用于计算布尔值的表达式。当结果分别为真或假时，它们指定一个字符串文本插入命令块。
			${true='--enable-foo' false='--disable-foo' allow_foo} #假如allow_foo为true：插入--enable-foo，false：插入--disable-foo
			真实和虚假的情况都是必需的。如果一个case不插入任何值，那么应该使用一个空字符串文字，例如${true='——enable-foo' false= " allow_foo}{
				1 真值条件或假条件的值必须是字符串
				2 true或false必须是Boolean类型
				3 需要true和false两种情况
				4 考虑使用表达式${if allow_foo then "--enable-foo" else "--disable-foo"}作为一种更具可读性的替代，它允许对真和假情况使用完整的表达式(而不是字符串文本)
			}
		}
		default - eg ${default="foo" optional_value} 
		default {
			如果没有为该参数指定其他值，则指定默认值
			附加需求：{
				表达式的类型必须与参数的类型匹配
				如果指定'default'，变量类型的$type_postfix_quantifier必须是?
			}
		}
	}	
	Alternative heredoc syntax{
		有时一个命令足够长，或者可能使用{字符，使用不同的分隔符会使它更清晰。在本例中，将命令封装在<<<…>>>中：也就是说命令中有{},就将command块封装在<<<...>>>中：案例：02.02heredoc.wdl;这个命令的解析应该与前面{...}描述的相同
	}
	Stripping Leading Whitespace{
		在实例化之后，命令部分中的任何文本都应该删除所有常见的前导空格。在上一节的任务02.02heredoc.wdl示例中，如果用户指定/path/to/file的值作为In文件的值，那么命令应该是{
			python <<CODE
			  with open("/path/to/file") as fp:
			    for line in fp:
			      if not line.startswith('#'):
			        print(line.strip())
			CODE
		}
		删除每行前两个空格；如果用户混合了制表符和空格，则行为是未定义的。建议使用一个警告，可能是每个选项卡4个空格的约定。在这种情况下，其他实现可能返回错误。实际就是禁用tab键，每行要是有空格，仅有两个空格
	}
}
Outputs Section{
	输出部分定义了哪些值应该在任务成功运行后作为输出公开。输出的声明就像工作流中的任务输入或声明一样。不同之处在于，只有在命令行执行之后才能计算它们，并且可以使用命令生成的文件来确定值。注意，输出需要一个值表达式(不像输入，表达式是可选的)
	output {
		Int threshold = read_int("thresdhold.txt")
		该任务期望有一个名为“threshold”的文件。命令执行后，txt"将存在于当前工作目录中
		该文件中必须有一行只包含整数和空格.有关更多详细信息，请参见数据类型和序列化部分
	}
	与任务定义中的其他字符串文字一样，输出部分中的字符串可能包含插值.(有关更多细节，请参见下面的字符串插值部分)。这里有一个例子
	output {
		Array[String] quality_scores= read_lines("${sample_id}.scores.txt")
		注意，要使其工作，必须将sample_id声明为任务的输入.与输入一样，输出可以引用同一块中的前一个输出。唯一的要求是引用的输出必须在使用它的输出之前指定。如下：{
			output {
				String a = "a"
				String ab = a+"b"
			}
		}
	}
	Globs{
		Globs可用于定义可能包含0、1或多个文件的输出。因此，glob函数返回一个文件输出数组:{
			output {
				Array[File] output_bams = glob("*.bam")
			}
			返回的文件数组是glob字符串的bash扩展相对于任务执行目录找到的文件集，其顺序相同.它是在运行任务的docker映像中安装的bash shell上下文中计算的.换句话说，您可以将glob()看作是按照从任务的执行目录在bash中运行echo 所匹配的顺序查找所有文件(而不是目录)。注意，这通常不包括嵌套目录中的文件。比如下面的例子：{
				execution_directory
				├── a1.txt
				├── ab.txt
				├── a_dir
				│   ├── a_inner.txt
				├── az.txt
			}该例子中a_dir是一个目录，虽然echo a*可以展示a_dir，但是WDL中的glob()会将a_dir舍去，只输出["a1.txt","ab.txt","az.txt"].
		}
		Task portability and non-standard BaSH{
			请注意，一些特殊的docker映像可能包含一个支持更复杂的glob字符串的非标准bash shell。这些复杂的glob字符串可能允许包含a_inner.txt的扩展。因此，为了确保在使用glob()时WDL是可移植的，应该提供docker映像，并且WDL作者应该记住，glob()结果取决于与安装在该docker映像上的bash实现的协调.
		}
	}
}
String Interpolation{
	在任务中，任何字符串文字都可以使用字符串插值来访问任务任何输入的值.最明显的例子是能够定义一个输出文件，它被命名为输入的函数。例如:02.03StringInterpolation.wdl.字符串文字中的任何${identifier}都必须替换为该标识符的值,如果prefix指定为foobar，则"${prefix}.out"将被评估为"foobar.out"。
}
Runtime Section{
	运行时部分为该任务所需的运行时信息定义键/值对。单个后端将定义它们将检查哪些键，因此键/值对可能被授予，也可能不被授予，这取决于任务是如何运行的.值可以是任何表达式，引擎可以拒绝在该上下文中没有意义的键和/或值。例如，考虑以下WDL:02.04.RuntimeSection.wdl.在这种情况下，docker runtime属性的值是一个值数组。解析器应该接受这一点。一些引擎可能会将其解释为“要么这个图像要么那个图像”，或者干脆拒绝它。
	因为值是表达式，所以它们也可以引用任务中的变量,案例：02.05.RuntimeSection.wdl.大多数键/值对是任意的。但是，下面的键推荐使用约定
	docker {
		应该为其运行此任务的Docker映像的位置。它的格式可以是ubuntu:lastest或者broadinstitute/scala-baseimage，在这种情况下，它应该被解释为DockerHub上的映像(也就是说，在docker pull命令中使用它是有效的).02.06.RuntimeSectionDocker.wdl
	}
	memory {
		此任务的内存需求。该属性支持两种值：{
			Int：被解析为字节数
			String：这应该是一个带有如下后缀的十进制值 B， kB MB或二进制后缀KiB,MiB：比如:6.2GB.5MB,2GiB
			案例:02.07.RuntimeSectionMemory.wdl
		}
	}
}
Parameter Metadata Section{
	这个纯可选部分包含键/值对，其中键是参数名，值是JSON格式的表达式，描述这些参数.引擎可以忽略此部分，但不会丢失正确性。例如，可以使用额外的信息生成用户界面。
	附加需求：本节中的任何键必须与任务输入或输出相对应。02.08.ParameterMetadataSection.wdl
}
Metadata Section {
	这个纯可选部分包含用于任何应该与任务一起存储的额外元数据的键/值对。例如，作者、联系人电子邮件或引擎授权策略。
}
Examples{
	02.09.RuntimeMetadata.wdl
	02.10.BWAMem.wdl {
		本例中值得注意的部分是${sep='，' min_std_max_min+}，它指定min_std_max_min可以是一个或多个整数(变量名后面的+表示它可以是一个或多个整数).如果一个数组Array[Int]被传递到这个参数中，那么通过将元素与分隔符(sep='，')组合在一起，它就会扁平化。这个任务还定义了它导出一个名为“sam”的文件，它是bwa mem执行的标准输出。该任务定义的“docker”部分指定该任务只能在指定的docker映像上运行
	}
	02.11.WordCount.wdl {
		在本例中，除了一些类似于语言y的特性，如firstline(stdout)和append(list_of_count, wc2-tool.count)之外，它都是非常漂亮的样板式声明式代码。如果我们允许自定义函数定义，这两种方法都可以相当容易地实现.解析它们不是问题。实现将非常简单，添加新函数也不难，或者可以是我们运行的JavaScript或Python代码片段
	}
	02.12.tmap.wdl{
		对于这种命令行本身就是小型DSL的特殊情况,此时最好的选项是允许用户输入命令行其余部分，这就是${sep=' ' stage +}的用途,这允许用户指定一个字符串数组作为stage的值，然后将它们与一个空格字符连接在一起
	}
}