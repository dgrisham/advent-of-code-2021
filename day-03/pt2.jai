#import "Basic";
#import "File";
#import "String";


infile :: "input";

ReportValue :: struct {
    line_number: int;
    data: [12] bool;
};

main :: () {

    file, success := file_open(infile);
    if !success {
        print("Failed to open file '%'\n", infile);
        exit(1);
    }

    all_values : [..] ReportValue;

    // read input file one byte at a time
    bytes_read := 0;
    bytes_in_file := file_length(file);
    buffer := cast(*u8) alloc(1);
    line_number: int = 0;
    position_in_line := 0;
    while bytes_read < bytes_in_file {

        reportValue : ReportValue;
        reportValue.line_number = line_number;
        reportValue.data = bool.[false, false, false, false, false, false, false, false, false, false, false, false];
        if position_in_line == 0 array_add(*all_values, reportValue);

        success = file_read(file, buffer, 1);
        if !success {
            print("Failed to read byte from file\n");
            exit(1);
        }
        bytes_read += 1;
        position_in_line += 1;

        byte := cast(u8)(<<buffer);
        if byte == 10 { // line feed
            line_number += 1;
            position_in_line = 0;
            continue;
        }

        // here, a 'bit' is now in the sense of the 'application' -- one of the values in a line, which is the 'byte' we just read in
        bit_index := position_in_line - 1;
        all_values[line_number].data[bit_index] = cast(bool) (byte - #char "0");
    }

    oxygen_values := array_copy(all_values);
    co2_values    := array_copy(all_values);

    bit_index := 0;
    while oxygen_values.count > 1 && bit_index < 12 {

        total: int;
        for oxygen_values total += cast(int) it.data[bit_index];
        bit_choice := total >= (oxygen_values.count + 1) / 2; // division by 2, rounded up

        i := 0;
        while i < oxygen_values.count {
            if oxygen_values[i].data[bit_index] != bit_choice {
                array_view_ordered_remove_by_index(*oxygen_values, i);
                if oxygen_values.count == 1 break;
                continue;
            }
            i += 1; // only increment if a value wasn't removed from the array
        }

        bit_index += 1;
    }
    oxygen_generator_rating_index := oxygen_values[0].line_number;

    bit_index = 0;
    while co2_values.count > 1 && bit_index < 12 {

        total: int;
        for co2_values total += cast(int) it.data[bit_index];
        bit_choice := total <= (co2_values.count - 1) / 2; // division by 2, rounded down

        i := 0;
        while i < co2_values.count {
            if co2_values[i].data[bit_index] != bit_choice {
                array_view_ordered_remove_by_index(*co2_values, i);
                if co2_values.count == 1 break;
                continue;
            }
            i += 1; // only increment if a value wasn't removed from the array
        }

        bit_index += 1;
    }
    co2_scrubber_rating_index := co2_values[0].line_number;

    oxygen_generator_rating , co2_scrubber_rating: int = 0;
    for all_values[oxygen_generator_rating_index].data oxygen_generator_rating += cast(int) it * pow(2, 12 - it_index - 1);
    for all_values[co2_scrubber_rating_index].data     co2_scrubber_rating     += cast(int) it * pow(2, 12 - it_index - 1);

    print("life support rating: %\n", oxygen_generator_rating * co2_scrubber_rating);
}

array_view_ordered_remove_by_value :: inline (array_pointer: *[] $T, item: T) -> bool {
    found, index := array_find(<<array_pointer, item);
    if found array_view_ordered_remove_by_index(array_pointer, index);
    return found;
}

array_view_ordered_remove_by_index :: inline (array_pointer: *[] $T, index: int) {
    assert(index >= 0);
    assert(index < array_pointer.count);

    array := <<array_pointer;

    for i : index..array.count-2
        array[i] = array[i+1];

    array_pointer.count -= 1;
}

pow :: (x: int, y: int) -> int {
    if y == 0 return 1;
    result := x;
    for 2..y result *= x;
    return result;
}
