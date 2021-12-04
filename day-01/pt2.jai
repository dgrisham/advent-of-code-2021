#import "Basic";
#import "File";

main :: () {

    infile :: "input";
    str, read_success := read_entire_file(infile);
    if !read_success {
        print("Failed to read file '%'\n", infile);
        exit(1);
    }

    prev, next : [3] int;

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

        for next  prev[it_index] = it;

        next[0] = prev[1];
        next[1] = prev[2];
        next[2] = n;

        if numbers_read > 3 && sum(next) > sum(prev)  total += 1;

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

sum :: (arr : [$N] int) -> int {
    sum := 0;
    for arr  sum += it;
    return sum;
}
