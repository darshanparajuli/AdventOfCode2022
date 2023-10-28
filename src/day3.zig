const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 3:\n", .{});
    const input = try util.read_input_of_day(allocator, 3);
    try part_1(allocator, try input.clone());
    try part_2(allocator, input);
}

fn part_1(allocator: Allocator, input: ArrayList([]u8)) !void {
    var shared = ArrayList(u8).init(allocator);
    defer shared.deinit();

    for (input.items) |item| {
        var hashSet = std.AutoHashMap(u8, void).init(allocator);
        defer hashSet.deinit();

        for (item[0 .. item.len / 2]) |c| {
            try hashSet.put(c, {});
        }

        for (item[item.len / 2 ..]) |c| {
            if (hashSet.contains(c)) {
                try shared.append(c);
                break;
            }
        }
    }

    var sum: u32 = 0;
    for (shared.items) |item| {
        const p = switch (item) {
            'a'...'z' => item - 96,
            'A'...'Z' => item - 65 + 27,
            else => unreachable,
        };
        sum += p;
    }

    try util.print_stdout("  part 1: {}\n", .{sum});
}

fn part_2(allocator: Allocator, input: ArrayList([]u8)) !void {
    var shared = ArrayList(u8).init(allocator);
    defer shared.deinit();

    var index: usize = 0;
    while (index < input.items.len) : (index += 3) {
        var sets = std.ArrayList(std.AutoHashMap(u8, void)).init(allocator);
        for (0..3) |_| {
            const set = std.AutoHashMap(u8, void).init(allocator);
            try sets.append(set);
        }
        for (input.items[index .. index + 3], 0..) |item, i| {
            for (item) |c| {
                try sets.items[i].put(c, {});
            }
        }

        outer: for (input.items[index .. index + 3]) |item| {
            for (item) |c| {
                var foundInAllThree = true;
                for (sets.items) |set| {
                    if (!set.contains(c)) {
                        foundInAllThree = false;
                        break;
                    }
                }
                if (foundInAllThree) {
                    try shared.append(c);
                    break :outer;
                }
            }
        }
    }

    var sum: u32 = 0;
    for (shared.items) |item| {
        const p = switch (item) {
            'a'...'z' => item - 96,
            'A'...'Z' => item - 65 + 27,
            else => unreachable,
        };
        sum += p;
    }
    try util.print_stdout("  part 2: {}\n", .{sum});
}
