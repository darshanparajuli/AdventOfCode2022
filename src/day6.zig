const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 6:\n", .{});
    const input = try util.read_input_of_day(allocator, 6);
    try part_1(input.items[0]);
    try part_2(input.items[0]);
}

fn part_1(input: []u8) !void {
    var marker: usize = 0;
    for (0..input.len - 4) |index| {
        var foundRepeat = false;
        outer: for (index..index + 4) |i| {
            const a = input[i];
            for (index..index + 4) |j| {
                if (i == j) {
                    continue;
                }
                const b = input[j];
                if (a == b) {
                    foundRepeat = true;
                    break :outer;
                }
            }
        }
        if (!foundRepeat) {
            marker = index + 4;
            break;
        }
    }
    try util.print_stdout("  part 1: {}\n", .{marker});
}

fn part_2(input: []u8) !void {
    var marker: usize = 0;
    for (0..input.len - 14) |index| {
        var foundRepeat = false;
        outer: for (index..index + 14) |i| {
            const a = input[i];
            for (index..index + 14) |j| {
                if (i == j) {
                    continue;
                }
                const b = input[j];
                if (a == b) {
                    foundRepeat = true;
                    break :outer;
                }
            }
        }
        if (!foundRepeat) {
            marker = index + 14;
            break;
        }
    }
    try util.print_stdout("  part 2: {}\n", .{marker});
}
