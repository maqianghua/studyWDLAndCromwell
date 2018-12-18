version 1.0

Array[String] env =["key1=value1","key2=value2","key3=value3"]
Array[String] env_param = prefix("-e",env) #["-e key1=value1","-e key2=value2","-e key3=value3"]

Array[Integer] env2=[1,2,3]
Array[String] env2_param = prefix("-f", env) #["-f 1","-f 2","-f 3"]