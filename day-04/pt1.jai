#import "Basic";
#import "File";
#import "String";

Board :: [5] [5] int;

main :: () {

    infile :: "input";
    input, success := read_entire_file(infile);
    if !success {
        print("Failed to read file '%'\n", infile);
        exit(1);
    }

    numbers: [..] int;
    boards: [..] Board;

    // read the list of numbers
    while true {
        n: int;
        success: bool;
        n, success, input = string_to_int(input);
        array_add(*numbers, n);
        if !success { print("not an int: %\n", input[0]); exit(1); }
        print("n: %\n", n);

        if input[0] == {

            case #char ",";
                advance(*input, 1);
                continue;

            case #char "\r"; #through;
            case #char "\n";
                advance(*input, 1);
                break;

            case;
                print("oh  no");
                exit(1);
        }
    }

    print("numbers: %\n", numbers);
}

is_newline :: inline (c : u8) -> bool {
    return c == #char "\r" || c == #char "\n";
}
