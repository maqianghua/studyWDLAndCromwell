version 1.0

Array[Array[Integer]] ai2D = [[1,2,3],[1],[21,22]]
Array[Integer] ai = flatten(ai2D) #结果[1,2,3,1,21,22]

Array[Array[File]] af2D=[["/tmp/x.txt"],["/tmp/y.txt","/tmp/z.txt"],[]]
Array[File] af = flatten(af2D) # ["/tmp/x.txt","/tmp/y.txt","/tmp/z.txt"]

Array[Array[Pair[Float,String]]] aap2D = [[(0.1,"mouse")],[(3,'cat'),(15,"dog")]]
Array[Pair[Float,String]] ap=flatten(aap2D) #[(0.1,"mouse"),(3,"cat"),(15,"dog")]
