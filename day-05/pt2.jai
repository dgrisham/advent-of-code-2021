#import "Basic";
#import "File";
#import "String";

LineSegment :: struct { start, end : Point; };
Point :: struct {
    x, y : int;
};

main :: () {

    infile :: "input";
    input, success := read_entire_file(infile);
    if !success {
        print("Failed to read file '%'\n", infile);
        exit(1);
    }

    lines: [..] LineSegment;

    line_number := 0;
    board_x_min, board_x_max, board_y_min, board_y_max := 0;
    while true {
        if input.count == 0 break;
        line_segment, success, err := read_line(*input);
        if !success { print("Error parsing line %: %", line_number + 1, err); exit(1); }
        array_add(*lines, line_segment);
        line_number += 1;

        using line_segment;
        board_x_min = min(min(start.x, end.x), board_x_min);
        board_x_max = max(max(start.x, end.x), board_x_max);

        board_y_min = min(min(start.y, end.y), board_y_min);
        board_y_max = max(max(start.y, end.y), board_y_max);
    }

    board: [] [] int;
    board = NewArray(board_x_max - board_x_min + 1, [] int, initialized=false);
    for *board {
        <<it = NewArray(board_y_max - board_y_min + 1, int);
    }

    for line: lines {
        using line;

        x_min := min(start.x, end.x);
        x_max := max(start.x, end.x);
        y_min := min(start.y, end.y);
        y_max := max(start.y, end.y);

        if start.x == end.x {
            for y: y_min..y_max board[start.x][y] += 1;
            continue;
        }

        m := (end.y - start.y) / (end.x - start.x);
        b := start.y - m * start.x;

        // calculate y-intercept
        for x: x_min..x_max {
            y := m * x + b;
            if y >= y_min && y <= y_max
                board[x][y] += 1;
        }
    }

    total := 0;
    for row: board {
        for row if it > 1 total += 1;
    }
    print("total: %\n", total);
}


read_line :: inline (text: *string) -> LineSegment, bool, string {
    line_segment, success, err := read_line_segment(text);
    if !success return line_segment, false, tprint("Failed to parse line segment: %", err);

    if !is_newline((<<text)[0]) return line_segment, false, "Failed to parse newline after line segment";
    advance(text, 1);

    return line_segment, true, "";
}

read_line_segment :: (text: *string) -> LineSegment, bool, string {
    segment: LineSegment;
    success: bool;
    err: string;

    segment.start, success, err = read_point(text);
    if !success return segment, false, tprint("Failed to parse start of line segment: %", err);

    <<text = eat_spaces(<<text);

    if (<<text)[0] != #char "-" || (<<text)[1] != #char ">"
        return segment, false, "Expected -> after point";
    advance(text, 2);

    <<text = eat_spaces(<<text);

    segment.end, success, err = read_point(text);
    if !success return segment, false, tprint("Failed to parse start of line segment: %", err);

    return segment, true, "";
}

read_point :: (text: *string) -> Point, bool, string {
    point: Point;
    success: bool;

    point.x, success, <<text = string_to_int(<<text);
    if !success return point, false, "Failed to parse x value";

    if (<<text)[0] != #char "," return point, false, "Expected comma after x value";
    advance(text, 1);

    point.y, success, <<text = string_to_int(<<text);
    if !success return point, false, "Failed to parse y value";

    return point, true, "";
}

is_newline :: inline (c : u8) -> bool {
    return c == #char "\r" || c == #char "\n";
}
