version 1.0

#tasks.wdl
task x {
    command {
        python script.py
    }
}

task y {
    command {
        python script2.py
    }
}

#workflow.wdl
import "tasks.wdl" as pyTasks
workflow wf {
    call pyTasks.x
    call pyTasks.y
}