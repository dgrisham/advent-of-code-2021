#import "Basic";
#import "File";
#import "String";

main :: () {

    infile :: "input";
    input, success := read_entire_file(infile);
    if !success {
        print("Failed to read file '%'\n", infile);
        exit(1);
    }

    lanternfish: [..] int;

    // parse the list of lanternfish
    while true {
        n: int;
        success: bool;
        n, success, input = string_to_int(input);
        array_add(*lanternfish, n);
        if !success { print("expected int, got %\n", input[0]); exit(1); }

        if input[0] == {

            case #char ",";
                advance(*input, 1);
                continue;

            case #char "\r"; #through;
            case #char "\n";
                advance(*input, 1);
                break;

            case;
                print("oh no\n");
                exit(1);
        }
    }

    print("lanternfish: %\n", lanternfish);
}
