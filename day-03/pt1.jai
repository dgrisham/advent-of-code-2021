#import "Basic";
#import "File";
#import "String";


infile :: "input";

main :: () {

    file, success := file_open(infile);
    if !success {
        print("Failed to open file '%'\n", infile);
        exit(1);
    }

    totals := u64.[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    // read input file one byte at a time
    bytes_read := 0;
    bytes_in_file := file_length(file);
    buffer := cast(*u8) alloc(1);
    lines_in_file: u64 = 0;
    position_in_line := 0;
    while bytes_read < bytes_in_file {

        success = file_read(file, buffer, 1);
        if !success {
            print("Failed to read byte from file\n");
            exit(1);
        }
        bytes_read += 1;
        position_in_line += 1;

        byte := cast(u8)(<<buffer);
        if byte == 10 { // line feed
            lines_in_file += 1;
            position_in_line = 0;
            continue;
        }

        totals[totals.count - position_in_line] += byte - #char "0";
    }
    free(buffer);

    gamma_array: [12] bool;
    for totals {
        gamma_array[it_index] = it > lines_in_file / 2;
    }

    gamma, epsilon: u64 = 0;
    for gamma_array {
        gamma   |=  (cast(u64)  it) << it_index;
        epsilon |=  (cast(u64) !it) << it_index;
    }

    print("Answer: %\n", gamma * epsilon);
}
