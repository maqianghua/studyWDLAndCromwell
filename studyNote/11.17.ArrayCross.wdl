version 1.0

Pair[Int, String] p=(0,"Z")
Array[Int] xs = [1,2,3]
Array[String] ys = ["a","b","c"]
Array[String] zs = ["d","e"]

Array[Pair[Int,String]] crossed = cross(xs,zs) #等价于crossed=[(1,"d"),(1,"e"),(2,"d"),(2,"e"),(3,"d"),(3,"e")]