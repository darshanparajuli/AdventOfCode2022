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

fn part_1(input: ArrayList(util.Vec2(util.Vec2(u32)))) !void {
    var count: u32 = 0;
    for (input.items) |item| {
        const p1 = item.x;
        const p2 = item.y;

        if ((p1.x <= p2.x and p1.y >= p2.y) or (p1.x >= p2.x and p1.y <= p2.y)) {
            count += 1;
        }
    }
    try util.print_stdout("  part 1: {}\n", .{count});
}

fn part_2(input: ArrayList(util.Vec2(util.Vec2(u32)))) !void {
    var count: u32 = 0;
    for (input.items) |item| {
        const p1 = item.x;
        const p2 = item.y;

        if ((p1.x <= p2.x and p1.y >= p2.y) or (p1.x >= p2.x and p1.y <= p2.y)) {
            count += 1;
        } else if ((p1.x >= p2.x and p1.x <= p2.y) or (p1.y >= p2.x and p1.y <= p2.y)) {
            count += 1;
        } else if ((p2.x >= p1.x and p2.x <= p1.y) or (p2.y >= p1.x and p2.y <= p1.y)) {
            count += 1;
        }
    }
    try util.print_stdout("  part 2: {}\n", .{count});
}

fn parse_input(allocator: Allocator, input: ArrayList([]u8)) !ArrayList(util.Vec2(util.Vec2(u32))) {
    var pairs = ArrayList(util.Vec2(util.Vec2(u32))).init(allocator);
    for (input.items) |item| {
        var iter = std.mem.splitAny(u8, item, "-,");
        var pair1a = try std.fmt.parseInt(u32, iter.next().?, 10);
        var pair1b = try std.fmt.parseInt(u32, iter.next().?, 10);
        var pair2a = try std.fmt.parseInt(u32, iter.next().?, 10);
        var pair2b = try std.fmt.parseInt(u32, iter.next().?, 10);

        const pair1 = util.Vec2(u32){
            .x = pair1a,
            .y = pair1b,
        };
        const pair2 = util.Vec2(u32){
            .x = pair2a,
            .y = pair2b,
        };
        const pair = util.Vec2(util.Vec2(u32)){
            .x = pair1,
            .y = pair2,
        };
        try pairs.append(pair);
    }
    return pairs;
}
