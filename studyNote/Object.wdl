version 1.0

task Myobject {
    String a = "beware"
    String b = "key"
    String c = "lookup"

    #what ate the keys to this object?
    Object object_syntax = object{
        a:10,
        b:11,
        c:12
    }

    # what are the keys to this object?
    Object map_coercion = {
        a:10,
        b:11,
        c:12
    }
}