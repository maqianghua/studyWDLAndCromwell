Configuration配置{
	总览{
		你可以通过配置文件或java命令行配置Cromwell设置
	}
	配置文件案例：https://github.com/broadinstitute/cromwell/blob/develop/cromwell.examples.conf
	定制配置文件{
			以HOCON方式写配置文件
			使用你的配置文件运行，复制cromwell.examples.conf到一个新文件，适当的修改，通过以下命令提交到Cromwell上：java -Dconfig.file=/path/to/yourOverrides.conf cromwell.jar ...
			创建你自己的配置文件，比如创建my.conf:
					在你文件的开头，包含application.conf在你定制配置文件的最上面。如下：
						# include the application.conf at the top
						include required(classpath("application"))
					然后从该行开始到以后，用你自己的定制复制或添加其他的配置值或章节比如：
						# include the application.conf at the top
						include required(classpath("application"))
						# Add customizations
						webservice.port = 58000
					你的配置文件应该定义成像JSON章节式，或点号分割式。以下两个案例相等{
							案例一：JSON章节式
								include required(classpath("application"))
								webservice {
								  port = 8000
								  interface = 0.0.0.0
								}
								案例二：点号分隔式
									include required(classpath("application"))
									webservice.port = 8000
									webservice.interface = 0.0.0.0
					}				
	}
		通过java命令，配置点号分割式的配置名称的值：例如：java -Dwebservice.port=8080 cromwell.jar ...
		高级配置{
			警告：这些高级配置值将严重影响Cromwell的性能
			服务配置：Cromwell服务默认绑定0.0.0.0在8000端口号上，可以通过浏览器http://localhost:8000进行获取。修改的配置如下{
				webservice {
				  port = 9000
				  interface = 0.0.0.0
				}
				以上修改将会使用9000端口号
				Cromwell使用akka-http做服务请求：举例：增加请求超时为30秒，可以使用以下章节到配置文件：akka.http.server.request-timeout = 30s
			}
			I/O {
					I/O 限流：确定backends暴露I/O流限制，举例：管道API应该每秒限制一定数量的查询限额
					你可以高效的控制和限制请求的数量，和分配给那些操作的资源，在system.io配置中：如下设置：
						system.io {
						  number-of-requests = 100000
						  per = 100 seconds
						}
					I/O 弹性：I/O操作可能失败因为网络到服务的原因，一部分错误不重要，可以重试，Cromwell将会对这些可重试的错误进行重试操作，在放弃或失败之前设置一定数量的重试次数。该参数（重试次数应该精确一点）可以通过以下方式配置：
						system.io {
						  number-of-attempts = 5
						}
			}
			Workflows{
				Cromwell对一次运行的工作流数量有一个可配置的上限，是可以调节的通过以下方式：system.max-concurrent-workflows = 5000
				新的工作流轮询率：Cromwell会定期开始寻找一个新的工作流，配置为多少秒。你可以改变轮询率从默认的2秒，通过编辑以下值：system.new-workflow-poll-rate = 2
				最大工作流启动计数：每一次轮询，Cromwell接收新的子任务数量受限，提供了将会有一些新的工作流加载，并且system.max-concurrent-workflows数量的工作流没有被加载，默认是50，可以通过以下方式重写：system.max-workflow-launch-count = 50
			}
			Database{
				使用MySQL数据库：Cromwell追踪工作流的执行，并存储任务的输出在SQL数据库，Cromwell支持外部的MySQL数据库和一个临时内存数据库，默认情况下，Cromwell使用一个内存数据库，该数据库只有在JVM运行期间有效。该模式提供一个快速方式本地执行工作流，没有必要连接MqSQL数据库，尽管它使工作流的执行比较短暂。配置Cromwell指向MySQL数据库，首先建立一个空的数据库，如下例子：数据库的名字是：cromwell，然后编辑你的配置文件，database章节：如下：
					database {
					  profile = "slick.jdbc.MySQLProfile$"
					  db {
					    driver = "com.mysql.jdbc.Driver"
					    url = "jdbc:mysql://host/cromwell?rewriteBatchedStatements=true"
					    user = "user"
					    password = "pass"
					    connectionTimeout = 5000
					  }
					}
				cromwell服务上的MySQL数据库：你可以使用docker-compose连接到一个Cromwell docker影像（使用sbt docker建立本地docker image，或在Dockerhub上可获得）利用MySQLdocker image，改变已使用的Cromwell版本：如：https://github.com/broadinstitute/cromwell/blob/develop/scripts/docker-compose-mysql/compose/cromwell/Dockerfile
				Local：docker-compose up从当前目录将会启动一个Cromwell 服务，在loacl背景下运行在一个MySQL实例，默认配置文件可以在compose/cromwell/app-config/application.conf找到，重写它，只是简单挂在一列包含你的定制，从application.conf到app-config
				Google 云：jes-cromwell目录是一个案例，怎么定制原始的组成文件，利用配置文件和环境变量。它使用应用程序默认凭证，确保你的谷歌云是最新的才能使用，并建立应用程序默认凭证。然后运行：docker-compose -f docker-compose.yml -f jes-cromwell/docker-compose.yml up利用谷歌云背景启动一个cromwell 服务在MySQL上。
				MySQL：在MySQL容器的数据目录挂在compose/mysql/data目录，将会允许数据存活在docker-compose down。不想使用该特征，仅需从docker-compose.yml上去除 ./compose/mysql/data:/var/lib/mysql这一行。在该案例中注意：数据将会通过docker-compose stop保存下来，然后停止container但是不会删除。
				注释：运行Cromwell在背后，只需在命令行后面加上docker-compose up -d.然后针对特定的服务查看logs，运行：docker-compose logs -f <service>举例：docker-compose logs -f cromwell
				插入批次大小：Cromewell先排好队，然后将批量的数据插入数据库以提高性能，可以调整插入批处理数据行数通过以下命令设置：{
					database {
					  insert-batch-size = 2000
					}
				}
				单独的元数据数据库：该特征属于实验阶段，以后有可能会变化。Cromwell存储关于每个job和工作流的元数据，元数据是为终端用户设计的，包含job的结果，开始和终止时间等。元数据的增长速度比剩余的内部引擎数据更快。使用单独的数据库给元数据，在数据库配置部分，配置一个子路径给元数据利用用户设置。
				database {
				  # Store metadata in a file on disk that can grow much larger than RAM limits.
				  metadata {
				    profile = "slick.jdbc.HsqldbProfile$"
				    db {
				      driver = "org.hsqldb.jdbcDriver"
				      url = "jdbc:hsqldb:file:metadata-db-file-path;shutdown=false;hsqldb.tx=mvcc"
				      connectionTimeout = 3000
				    }
				  }
				}
				没有重写元数据，Cromwell会使用根数据库的设置信息。
			}
			Abort{
				Control-C（标志）终止操作：针对backends支持终止jobs，Cromwell被配置为自动终止调用，当其接收到一个Control-C的标志。所有目前运行的调用将会设置状态为Aborted。明确关闭或打开该特征，设置配置选项如下：
					system {
					  abort-jobs-on-terminate=true
					}
					或者通过命令行选项：-Dsystem.abort-jobs-on-terminate=true
					默认该值是false通过运行：java -jar cromwell.jar server
									该值是true通过运行：java -jar cromwell.jar run <workflow source> <inputs>
			}
			Call caching{
				调用缓存允许Cromwell检测当一个job已经执行过了，因此没有必要重计算结果了。要使用调用缓存功能，添加下面的Cromwell配置：
					call-caching {
					  enabled = true
					  invalidate-bad-cache-results = true
					}
					当call-caching.enabled=true (default: false)，Cromwell将能引用或拷贝原先hob的结果（当正确的情况下），当invalidate-bad-cache-results=true (default: true)，任何缓存的结果包含的文件在一个缓存中不能被获取，Cromwell将会视任何的缓存结果为无效结果。这种情况是被期望的，但是不是想要的，假如该失败是因为外部原因，就比如，在用户身份鉴定中出现的差异。 Cromwell也接受工作流选项重写缓存读或写的行为
			}
			Local filesystem options{
				当运行一个job在配置文件（共享文件系统）下，Cromwell提供一些额外的选项在backend的配置选项
			}
			Workflow log directory{
				当Cromwell写工作流logs改变输出目录，通过以下方式：
					workflow-options {
					    workflow-log-dir = "cromwell-workflow-logs"
					}
			}
			Preserving Workflow logs {
				 默认情况下，当工作流完成后，Cromwell将会擦除每一个工作流日志，从而减少硬盘的使用，你可以改变这种策略行为，通过设置下面的值为false：
				 	workflow-options {
				 	    workflow-log-temporary = true
				 	}
			}
			Exception monitoring via Sentry{
				Cromwell支持Sentry用来在应用程序的logs中监控异常。在Cromwell中使用Sentry监控，输入DSN_URL使用系统属性。sentry.dsn=DSN_URL
			}
			job shell configuration{
					Cromwell允许对运行用户命令的整个系统或每个后端作业shell进行配置，而不是通常使用默认的/bin/bash.使用配置文件key system.job-shell设置全系统上的作业shell，或者在每个后端作业上用<config-key-for-backend>.job-shell.举例：
						# system-wide setting, all backends get this
						-Dsystem.job-shell=/bin/sh
						# override for just the Local backend
						-Dbackend.providers.Local.config.job-shell=/bin/sh
						对于job shell的配置backend值将会在${job_shell}变量中得到，查看Cromwell的reference.conf作为一个案例，对于默认的Local backed是如何进行修改。
			}
		}
}
重构重新运行之间保存数据{
	目标：Cromwell会记录任何信息
	让我们开始吧{
		利用下面的命令启动MySQL docker container：docker run -p 3306:3306 --name NameOfTheContainer -e MYSQL_ROOT_PASSWORD=YourPassword -e MYSQL_DATABASE=DatabaseName -e MYSQL_USER=ChooseAName -e MYSQL_PASSWORD=YourOtherPassword -d mysql/mysql-server:5.5
		更新你的application.conf文件
		利用更新的application.conf在你的服务上运行测试：java -Dconfig.file=/path/to/application.conf/ -jar cromwell-[version].jar ...
	}
}
时序图{
	对于正在运行的workflow如何查看时序图，并对于完成的workflow解释时序图的信息
	让我们开始吧{
		想看你的workflow中task的时序分布图，好消息，将要发生在你的身上。
		准备文件{
			我们将会制造一个workflow分散一个任务通过一些索引，并观察如何获得呈现。准备文件timingWorkflow.wdl		
		}
		提交到cromwell{
			java -jar cromwell-29.jar server
			提交workflow{
				curl -X POST --header "Accept:application/json" \
								-v "localhost:8000/api/workflows/v1" \
								-F workflowSource=@timingWorkflow.wdl
					curl 输出包含workflow ID eg：[...] Workflow 8d18b845-7143-4f35-9543-1977383b7d2f submitted.
				通过输入address在浏览器上，就可以看到各个task的运行时间，那个时间最长等信息
			}
		}
	}
}
服务模式{
	Cromwell在server模式下是最好的实践
	目标：在Server模式下运行Cromwell，允许你提交超过一个workflow并行运行。当workflow完成后可以查询。
	准备文件{
		复制文件hello2.wdl;hell02.json
		运行该服务：Run: java -jar cromwell-[version].jar server (用真实的版本进行替换)
	}
}
开始运行在亚马逊集群上{
	目标：你将运行第一个workflow在AWS集群上
	让我们开始吧{
		
	}
}
开始运行在阿里云上{
	目标：你讲学会在阿里云的批处理服务器上运行第一个workflow
	让我们开始吧{
		配置阿里云服务
		准备workflow源文件{
			复制echo.wdl;echo.inputs到Cromwell.jar相同的目录下，该workflow获取一个字符串值作为输出文件的名称，并将“Hello World!”写入到该文件
			复制bcs.conf文件复制到和WDL，inputs和Cromwell.jar相同的目录下，并在配置文件中将字段（。。。）用真实值替换
			Run workflow：java -Dconfig.file=bcs.conf -jar cromwell.jar run echo.wdl --inputs echo.inputs
			outputs{
				[info] SingleWorkflowRunnerActor workflow finished with status 'Succeeded'.
				{
				  "outputs": {
				    "wf_echo.echo.outFile": "oss://<test-bucket>/cromwell-dir/wf_echo/38b088b2-5131-4ea0-a161-4cf2ca8d15ac/call-echo/output",
				    "wf_echo.echo.content": ["Hello World!"]
				  },
				  "id": "38b088b2-5131-4ea0-a161-4cf2ca8d15ac"
				}
			}
		}
	}
}
开始使用谷歌流程的API{
	目标：你将运行第一个workflow在谷歌流程的API上
	让我们开始吧{
		配置一个谷歌项目
		复制hello.wdl,hello.inputs,google.conf
		Run workflow：java -Dconfig.file=google.conf -jar cromwell-29.jar run hello.wdl -i hello.inputs
		查看输出：{
			[info] SingleWorkflowRunnerActor workflow finished with status 'Succeeded'.
			{
			  "outputs": {
			    "wf_hello.hello.message": "Hello World! Welcome to Cromwell . . . on Google Cloud!"
			  },
			  "id": "08213b40-bcf5-470d-b8b7-1d1a9dccb10e"
			}
		}
	}
}
如何配置Cromwell{
	目标：建立一个配置文件，使用它修改Cromwell的行为
	让我们开始吧{
		利用配置文件定制Cromwell{
			比如运行在外部的MySQL database，自组织的计算集群，通过Pipelines API运行在云上，
		}
		配置文件语法{
			语法是HOCON语法规则（Human-Optimized Config Object Notation）：实际上就是人为容易可编辑json格式
		}
		利用你的配置文件运行Cromwell{
			java -Dconfig.file=/path/to/your.conf -jar cromwell-[VERSION].jar server			
		}
		设置一个配置值{
			在你的配置文件中指定一个新值，重写配置值，{
				案例：将cromwel的监听端口由8000改为8080，当运行Cromwell在更新的配置文件上，Cromwell的监听端口变成8080{
					# 在以前的包含行下面
					website {
						port = 8080
					}
				}
			}
		}
		获取更多的配置属性，请查看configuration页，同时也有很多案例。
	}
}
快速介绍{
	目标{
		下载Cromwell
		书写第一个workflow
		通过Cromwell执行
	}
}