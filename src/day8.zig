const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const StringHashMap = std.StringHashMap;

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 8:\n", .{});
    const input = try util.read_input_of_day(allocator, 8);
    try part_1(input.items);
    try part_2(input.items);
}

fn part_1(input: [][]u8) !void {
    var visibleCount: u64 = input.len * 2 + (input[0].len - 2) * 2;

    for (1..input.len - 1) |y| {
        for (1..input[y].len - 1) |x| {
            const tree = input[y][x];

            // left
            var leftVisible = true;
            var k: i32 = @intCast(x - 1);
            while (k >= 0) : (k -= 1) {
                if (input[y][@intCast(k)] >= tree) {
                    leftVisible = false;
                    break;
                }
            }
            // right
            k = @intCast(x + 1);
            var rightVisible = true;
            while (k < input[y].len) : (k += 1) {
                if (input[y][@intCast(k)] >= tree) {
                    rightVisible = false;
                    break;
                }
            }
            // top
            k = @intCast(y - 1);
            var topVisible = true;
            while (k >= 0) : (k -= 1) {
                if (input[@intCast(k)][x] >= tree) {
                    topVisible = false;
                    break;
                }
            }
            // bottom
            k = @intCast(y + 1);
            var bottomVisible = true;
            while (k < input.len) : (k += 1) {
                if (input[@intCast(k)][x] >= tree) {
                    bottomVisible = false;
                    break;
                }
            }

            if (leftVisible or rightVisible or topVisible or bottomVisible) {
                visibleCount += 1;
            }
        }
    }

    try util.print_stdout("  part 1: {}\n", .{visibleCount});
}

fn part_2(input: [][]u8) !void {
    var maxScore: u64 = 0;

    for (1..input.len - 1) |y| {
        for (1..input[y].len - 1) |x| {
            const tree = input[y][x];

            // left
            var leftCount: u64 = 0;
            var k: i32 = @intCast(x - 1);
            while (k >= 0) : (k -= 1) {
                leftCount += 1;
                if (input[y][@intCast(k)] >= tree) {
                    break;
                }
            }
            // right
            k = @intCast(x + 1);
            var rightCount: u64 = 0;
            while (k < input[y].len) : (k += 1) {
                rightCount += 1;
                if (input[y][@intCast(k)] >= tree) {
                    break;
                }
            }
            // top
            k = @intCast(y - 1);
            var topCount: u64 = 0;
            while (k >= 0) : (k -= 1) {
                topCount += 1;
                if (input[@intCast(k)][x] >= tree) {
                    break;
                }
            }
            // bottom
            k = @intCast(y + 1);
            var bottomCount: u64 = 0;
            while (k < input.len) : (k += 1) {
                bottomCount += 1;
                if (input[@intCast(k)][x] >= tree) {
                    break;
                }
            }

            const score = leftCount * rightCount * topCount * bottomCount;
            maxScore = @max(maxScore, score);
        }
    }

    try util.print_stdout("  part 2: {}\n", .{maxScore});
}
