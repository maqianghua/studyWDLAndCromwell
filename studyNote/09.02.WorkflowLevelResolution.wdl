version 1.0

workflow wf {
    input {
        String s = "wf_s"
        String t = "t"
    }
    call my_task {
        String s = "my_task"
        input :
            in0=s+"-suffix",
            in1=t+"-suffix"
    }
}