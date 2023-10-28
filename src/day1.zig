const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 1:\n", .{});
    const input = try util.read_input(allocator, 1);
    try part_1(try input.clone());
    try part_2(allocator, input);
}

fn part_1(input: ArrayList([]u8)) !void {
    var max: u32 = 0;
    var i: u32 = 0;
    while (i < input.items.len) {
        var sum: u32 = 0;
        while (i < input.items.len and input.items[i].len != 0) {
            sum += try std.fmt.parseInt(u32, input.items[i], 10);
            i += 1;
        }

        if (sum > max) {
            max = sum;
        }

        i += 1;
    }
    try util.print_stdout("  part 1: {}\n", .{max});
}

fn cmpSums(context: void, a: u32, b: u32) bool {
    return std.sort.desc(u32)(context, a, b);
}

fn part_2(allocator: Allocator, input: ArrayList([]u8)) !void {
    var max = ArrayList(u32).init(allocator);
    var i: u32 = 0;
    while (i < input.items.len) {
        var sum: u32 = 0;
        while (i < input.items.len and input.items[i].len != 0) {
            sum += try std.fmt.parseInt(u32, input.items[i], 10);
            i += 1;
        }

        try max.append(sum);
        i += 1;
    }
    var maxSlice = try max.toOwnedSlice();
    std.sort.heap(u32, maxSlice, {}, cmpSums);
    var finalSum: u32 = 0;
    for (maxSlice[0..3]) |value| {
        finalSum += value;
    }
    try util.print_stdout("  part 2: {}\n", .{finalSum});
}
