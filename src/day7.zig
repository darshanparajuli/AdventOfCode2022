const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const StringHashMap = std.StringHashMap;

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 7:\n", .{});
    const input = try parse_input(allocator, (try util.read_input_of_day(allocator, 7)).items);
    try part_1(allocator, input.items);
    try part_2(allocator, input.items);
}

fn part_1(allocator: Allocator, input: []const Line) !void {
    var sizeMap = StringHashMap(u64).init(allocator);
    const totalSize = try calc_sizes(allocator, 0, &sizeMap, input);
    _ = totalSize;
    var sum: u64 = 0;
    var iterator = sizeMap.iterator();
    while (iterator.next()) |entry| {
        const size = entry.value_ptr.*;
        if (size <= 100000) {
            sum += size;
        }
    }
    try util.print_stdout("  part 1: {}\n", .{sum});
}

fn part_2(allocator: Allocator, input: []const Line) !void {
    var sizeMap = StringHashMap(u64).init(allocator);
    const totalSpace = 70000000;
    const neededUnusedSpace = 30000000;
    const totalSize = try calc_sizes(allocator, 0, &sizeMap, input);
    const unusedSpace = totalSpace - totalSize;
    var iterator = sizeMap.iterator();
    var sizes = ArrayList(u64).init(allocator);
    while (iterator.next()) |entry| {
        const size = entry.value_ptr.*;
        try sizes.append(size);
    }
    var sizesSlice = try sizes.toOwnedSlice();
    std.sort.heap(u64, sizesSlice, {}, cmpSize);

    for (sizesSlice) |size| {
        if (unusedSpace + size >= neededUnusedSpace) {
            try util.print_stdout("  part 2: {}\n", .{size});
            break;
        }
    }
}

fn calc_sizes(allocator: Allocator, index: usize, sizeMap: *StringHashMap(u64), input: []const Line) !u64 {
    var size: u64 = 0;

    switch (input[index]) {
        .cd => {
            try std.testing.expect(input[index + 1].ls == {});
            for (input[index + 2 ..]) |line| {
                switch (line) {
                    .ls => {
                        unreachable;
                    },
                    .file => {
                        size += line.file.size;
                    },
                    .dir => {
                        var nextIndex: usize = index + 2;
                        while (nextIndex < input.len) : (nextIndex += 1) {
                            switch (input[nextIndex]) {
                                .cd => {
                                    if (std.mem.eql(u8, input[nextIndex].cd.arg, "..")) {
                                        // Skip "..".
                                    } else {
                                        const name = try std.fmt.allocPrint(allocator, "{s}-{}", .{ input[nextIndex].cd.arg, nextIndex });
                                        if (sizeMap.contains(name)) {
                                            // Skip!
                                        } else {
                                            break;
                                        }
                                    }
                                },
                                else => {},
                            }
                        }

                        for (input[nextIndex..], nextIndex..) |l, j| {
                            switch (l) {
                                .cd => {
                                    if (std.mem.eql(u8, l.cd.arg, line.dir.name)) {
                                        size += try calc_sizes(allocator, j, sizeMap, input);
                                        break;
                                    }
                                },
                                else => {},
                            }
                        }
                    },
                    .cd => {
                        break;
                    },
                }
            }
            const name = try std.fmt.allocPrint(allocator, "{s}-{}", .{ input[index].cd.arg, index });
            try sizeMap.put(name, size);
        },
        else => {
            unreachable;
        },
    }
    return size;
}

fn parse_input(allocator: Allocator, input: [][]u8) !ArrayList(Line) {
    var result = ArrayList(Line).init(allocator);
    for (input) |line| {
        if (std.mem.startsWith(u8, line, "$")) {
            if (std.mem.startsWith(u8, line[2..], "cd")) {
                const arg = line[5..];
                try result.append(.{
                    .cd = .{ .arg = arg },
                });
            } else if (std.mem.startsWith(u8, line[2..], "ls")) {
                try result.append(.{
                    .ls = {},
                });
            } else {
                unreachable;
            }
        } else {
            if (std.mem.startsWith(u8, line, "dir")) {
                // Dir
                try result.append(.{
                    .dir = .{
                        .name = line[4..],
                    },
                });
            } else {
                // File
                var iter = std.mem.splitSequence(u8, line, " ");
                const size = try std.fmt.parseInt(u64, iter.next().?, 10);
                const name = iter.next().?;
                try result.append(.{
                    .file = .{
                        .name = name,
                        .size = size,
                    },
                });
            }
        }
    }
    return result;
}

const LineType = enum {
    cd,
    ls,
    dir,
    file,
};

const Line = union(LineType) {
    cd: struct {
        arg: []const u8,
    },
    ls: void,
    dir: struct {
        name: []const u8,
    },
    file: struct {
        name: []const u8,
        size: u64,
    },
};

fn cmpSize(context: void, a: u64, b: u64) bool {
    return std.sort.asc(u64)(context, a, b);
}
