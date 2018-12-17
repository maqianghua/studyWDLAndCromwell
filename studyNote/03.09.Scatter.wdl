version 1.0

scatter(i in intergers) {
    call task1 {
        input :
            num=i
    }
    call task2 {
        input :
            num = task1.output
    }
}