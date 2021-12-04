#import "Basic";
#import "File";
#import "String";

main :: () {

    infile :: "input";
    str, read_success := read_entire_file(infile);
    if !read_success {
        print("Failed to read file '%'\n", infile);
        exit(1);
    }

    prev : int;
    next : int;

    total := 0;
    done := false;
    numbers_read := 0;
    while !done {

        n : int;
        parse_success : bool;
        n, parse_success, str = string_to_int(str); // parse an int from the string, and shift string pointer accordingly
        if !parse_success {
            done = true;
            break;
        }
        numbers_read += 1;

        prev = next;
        next = n;

        if numbers_read > 1 && next > prev  total += 1;

        if !is_newline(str.data[0]) {
            print("Error: Missing newline after integer");
            break;
        }
        advance(*str, 1);
    }

    print("total: %\n", total);
}

is_newline :: inline (c : u8) -> bool {
    return c == #char "\r" || c == #char "\n";
}
