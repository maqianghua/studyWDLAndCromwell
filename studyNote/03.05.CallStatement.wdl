version 1.0

import "lib.wdl" as lib
workflow wf {
    call my_task
    call my_task as my_task_alias
    call my_task as my_task_alias2 {
        input : 
            threshold=2
    }
    call lib.other_task
}