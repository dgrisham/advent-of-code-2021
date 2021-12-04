#import "Basic";
#import "File";
#import "String";

Position :: struct {
    horizontal, vertical: int = 0;
}

Move :: struct {
    direction: Direction;
    distance: int;
}

Direction :: enum {
    FORWARD;
    UP;
    DOWN;
}

main :: () {

    infile :: "input";
    input, read_success := read_entire_file(infile);
    if !read_success {
        print("Failed to read file '%'\n", infile);
        exit(1);
    }

    position: Position;

    line_number := 0;
    while true {

        if input.count == 0 break;

        move, parse_success, err := read_line(*input);
        if !parse_success {
            print("Error parsing line %: %\n", line_number, err);
            print("Failed line: %\n", stop_at_any(input, "\n"));
            exit(1);
        }
        line_number += 1;

        if #complete move.direction == {
            case .FORWARD;
                position.horizontal += move.distance;
            case .UP;
                position.vertical -= move.distance;
            case .DOWN;
                position.vertical += move.distance;
        }
    }

    print("Final position: %\n", position);
    print("Answer: %\n", position.horizontal * position.vertical);
}

read_line :: (text: *string) -> Move, bool, string {

    move, success, err := read_move(text);
    if !success  return move, false, tprint("Failed to parse move: %", err);

    if !is_newline((<<text)[0])  return move, false, "Failed to parse newline after move";
    advance(text, 1);

    return move, true, "";
}

read_move :: inline (text: *string) -> Move, bool, string {

    move: Move;
    success: bool;

    move.direction, success = read_direction(text);
    if !success return move, false, "Failed to parse direction";

    move.distance, success, <<text = string_to_int(<<text);
    if !success return move, false, "Failed to parse distance";

    return move, true, "";
}

read_direction :: (text: *string) -> Direction, bool {
    if begins_with(<<text, "forward") {
        advance(text, 7);
        return .FORWARD, true;
    }
    if begins_with(<<text, "up") {
        advance(text, 2);
        return .UP, true;
    }
    if begins_with(<<text, "down") {
        advance(text, 4);
        return .DOWN, true;
    }
    return 0, false;
}

is_newline :: inline (c : u8) -> bool {
    return c == #char "\r" || c == #char "\n";
}
