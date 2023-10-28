const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 4:\n", .{});
    const input = try parse_input(allocator, try util.read_input_of_day(allocator, 4));
    try part_1(try input.clone());
    try part_2(input);
}

fn part_1(input: ArrayList(util.Pair(util.Pair(u32)))) !void {
    var count: u32 = 0;
    for (input.items) |item| {
        const p1 = item.v1;
        const p2 = item.v2;

        if ((p1.v1 <= p2.v1 and p1.v2 >= p2.v2) or (p1.v1 >= p2.v1 and p1.v2 <= p2.v2)) {
            count += 1;
        }
    }
    try util.print_stdout("  part 1: {}\n", .{count});
}

fn part_2(input: ArrayList(util.Pair(util.Pair(u32)))) !void {
    var count: u32 = 0;
    for (input.items) |item| {
        const p1 = item.v1;
        const p2 = item.v2;

        if ((p1.v1 <= p2.v1 and p1.v2 >= p2.v2) or (p1.v1 >= p2.v1 and p1.v2 <= p2.v2)) {
            count += 1;
        } else if ((p1.v1 >= p2.v1 and p1.v1 <= p2.v2) or (p1.v2 >= p2.v1 and p1.v2 <= p2.v2)) {
            count += 1;
        } else if ((p2.v1 >= p1.v1 and p2.v1 <= p1.v2) or (p2.v2 >= p1.v1 and p2.v2 <= p1.v2)) {
            count += 1;
        }
    }
    try util.print_stdout("  part 2: {}\n", .{count});
}

fn parse_input(allocator: Allocator, input: ArrayList([]u8)) !ArrayList(util.Pair(util.Pair(u32))) {
    var pairs = ArrayList(util.Pair(util.Pair(u32))).init(allocator);
    for (input.items) |item| {
        var iter = std.mem.splitAny(u8, item, "-,");
        var pair1a = try std.fmt.parseInt(u32, iter.next().?, 10);
        var pair1b = try std.fmt.parseInt(u32, iter.next().?, 10);
        var pair2a = try std.fmt.parseInt(u32, iter.next().?, 10);
        var pair2b = try std.fmt.parseInt(u32, iter.next().?, 10);

        const pair1 = util.Pair(u32){
            .v1 = pair1a,
            .v2 = pair1b,
        };
        const pair2 = util.Pair(u32){
            .v1 = pair2a,
            .v2 = pair2b,
        };
        const pair = util.Pair(util.Pair(u32)){
            .v1 = pair1,
            .v2 = pair2,
        };
        try pairs.append(pair);
    }
    return pairs;
}
