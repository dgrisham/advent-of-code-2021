#import "Basic";
#import "File";
#import "String";

Board :: [5] [5] Spot;

Spot :: struct {
    value: int;
    marked := false;
}

main :: () {

    infile :: "input";
    input, success := read_entire_file(infile);
    if !success {
        print("Failed to read file '%'\n", infile);
        exit(1);
    }

    numbers: [..] int;

    // parse the list of numbers
    while true {
        n: int;
        success: bool;
        n, success, input = string_to_int(input);
        array_add(*numbers, n);
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
                print("oh  no");
                exit(1);
        }
    }

    if !is_newline(input[0]) { print("expected newline, got %\n", input[0]); exit(1); }
    advance(*input, 1);

    boards: [..] Board;

    // parse the boards
    row, col := 0;
    while true {

        if row == 0 && col == 0 {
            board: Board;
            array_add(*boards, board);
        }

        input = eat_spaces(input);
        n: int;
        success: bool;
        n, success, input = string_to_int(input);
        if !success { print("expected int, got %\n", input[0]); exit(1); }

        spot: Spot;
        spot.value = n;
        boards[boards.count - 1][row][col] = spot;

        input = eat_spaces(input);
        if is_newline(input[0]) {
            advance(*input, 1);

            if input.count == 0 break; // end of input

            if is_newline(input[0]) { // two newlines, new board starting
                advance(*input, 1);
                row = 0;
            } else {
                row += 1;
            }

            col = 0;
            continue;
        }

        col += 1;
    }

    remaining_boards: [..] int;
    array_resize(*remaining_boards, boards.count);
    for i: 0..(boards.count - 1) remaining_boards[i] = i;

    for n: numbers {
        i := 0;
        while i < remaining_boards.count {
            board_index := remaining_boards[i];
            mark_board(*boards[board_index], n);

            if board_is_winner(boards[board_index]) {
                found := array_ordered_remove_by_value(*remaining_boards, board_index);
                if found {
                    if remaining_boards.count == 0 {
                        print("answer: %\n", score_board(boards[board_index], n));
                        break n;
                    }
                    continue;
                }
            }
            i += 1;
        }
    }
}

score_board :: (board: Board, n: int) -> int {
    total := 0;
    for row: board {
        for spot: row {
            if !spot.marked total += spot.value;
        }
    }
    return total * n;
}

mark_board :: inline (board: *Board, n: int) -> bool {
    for i: 0..4 {
        for j: 0..4 {
            if (<<board)[i][j].value == n {
                (<<board)[i][j].marked = true;
                return true;
            }
        }
    }
    return false;
}

board_is_winner :: inline (board: Board) -> bool {
    // horizontal
    for row: board {
        if row_is_winner(row) return true;
    }

    // vertical
    for j: 0..4 {
        is_winner := true;
        for i: 0..4 {
            is_winner = is_winner && board[i][j].marked;
        }
        if is_winner return true;
    }

    return false;
}

row_is_winner :: inline (row : [5] Spot) -> bool {
    is_winner := true;
    for row is_winner = is_winner && it.marked;
    return is_winner;
}

is_newline :: inline (c : u8) -> bool {
    return c == #char "\r" || c == #char "\n";
}
