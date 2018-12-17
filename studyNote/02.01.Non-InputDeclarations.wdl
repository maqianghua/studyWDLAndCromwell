version 1.0

task t {
    input {
        Object inputs
    }
    File objects_json = write_json(inputs)

    # [... other task sections]
}