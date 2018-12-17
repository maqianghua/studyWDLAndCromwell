version 1.0

task task_a {
    Person a 
    command {
        echo "hello my name is ${a.name} and I am ${a.age} years old"
    }
}

workflow myWorkflow {
    Person a 
    call task_a {
        input :
            a=a
    }
}