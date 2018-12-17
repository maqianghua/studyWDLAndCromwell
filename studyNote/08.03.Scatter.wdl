version 1.0

workflow wf {
    input {
        Array[Int] integers =[1,2,3,4,5]
    }
    scatter (i in integers) {
        call inc{
            input :
                i=i
        }
        call inc as inc2 {
            input :
                i=inc.incremented
        }
    }
    call sum {
        input :
            ints=inc2.incremented
    }
}