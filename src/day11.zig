const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 11:\n", .{});
    const dayInput = try util.read_input_of_day(allocator, 11);
    const input0 = try parse_input(allocator, dayInput.items);
    const input1 = try parse_input(allocator, dayInput.items);
    try part_1(allocator, input0.items);
    try part_2(allocator, input1.items);
}

fn part_1(allocator: Allocator, input: []Monkey) !void {
    var inspectCount = ArrayList(u64).init(allocator);
    for (0..input.len) |_| {
        try inspectCount.append(0);
    }

    for (0..20) |_| {
        var index: usize = 0;
        var isAllEmpty = true;
        while (index < input.len) : (index += 1) {
            var m = &input[index];

            if (m.items.items.len == 0) {
                continue;
            }
            isAllEmpty = false;

            var i: usize = 0;
            while (i < m.items.items.len) : (i += 1) {
                inspectCount.items[index] += 1;
                const v = m.items.items[i];

                const operand = switch (m.op.value) {
                    .raw => m.op.value.raw.val,
                    .old => v,
                };

                var newValue = switch (m.op.opType) {
                    .mul => v * operand,
                    .add => v + operand,
                };

                newValue /= 3;

                if (newValue % m.testItem.divisibleBy == 0) {
                    try input[m.testItem.ifTrue].items.append(newValue);
                } else {
                    try input[m.testItem.ifFalse].items.append(newValue);
                }
            }
            m.items.clearAndFree();
        }

        if (isAllEmpty) {
            break;
        }
    }

    var maxSlice = try inspectCount.toOwnedSlice();
    std.sort.heap(u64, maxSlice, {}, cmpCount);

    try util.print_stdout("  part 1: {}\n", .{maxSlice[0] * maxSlice[1]});
}

fn cmpCount(context: void, a: u64, b: u64) bool {
    return std.sort.desc(u64)(context, a, b);
}

fn part_2(allocator: Allocator, input: []Monkey) !void {
    var inspectCount = ArrayList(u64).init(allocator);
    for (0..input.len) |_| {
        try inspectCount.append(0);
    }

    var commonMultiple: u64 = 1;
    for (input) |m| {
        commonMultiple *= m.testItem.divisibleBy;
    }

    for (0..10000) |_| {
        var index: usize = 0;
        var isAllEmpty = true;
        while (index < input.len) : (index += 1) {
            var m = &input[index];

            if (m.items.items.len == 0) {
                continue;
            }
            isAllEmpty = false;

            var i: usize = 0;

            while (i < m.items.items.len) : (i += 1) {
                inspectCount.items[index] += 1;
                const v = m.items.items[i];

                const operand = switch (m.op.value) {
                    .raw => m.op.value.raw.val,
                    .old => v,
                };

                var newValue = switch (m.op.opType) {
                    .mul => v * operand,
                    .add => v + operand,
                };

                newValue %= commonMultiple;

                if (newValue % m.testItem.divisibleBy == 0) {
                    try input[m.testItem.ifTrue].items.append(newValue);
                } else {
                    try input[m.testItem.ifFalse].items.append(newValue);
                }
            }
            m.items.clearAndFree();
        }

        if (isAllEmpty) {
            break;
        }
    }

    var maxSlice = try inspectCount.toOwnedSlice();
    std.sort.heap(u64, maxSlice, {}, cmpCount);

    try util.print_stdout("  part 2: {}\n", .{maxSlice[0] * maxSlice[1]});
}

fn parse_input(allocator: Allocator, input: [][]u8) !ArrayList(Monkey) {
    var result = ArrayList(Monkey).init(allocator);

    var index: usize = 0;
    while (index < input.len) : (index += 7) {
        const startingItemsLine = input[index + 1];
        var iter = std.mem.splitSequence(u8, startingItemsLine[18..], ", ");
        var startingItems = ArrayList(u64).init(allocator);
        while (iter.next()) |v| {
            const value = try std.fmt.parseInt(u64, v, 10);
            try startingItems.append(value);
        }

        const opLine = input[index + 2][23..];
        const opType = switch (opLine[0]) {
            '+' => OpType.add,
            '*' => OpType.mul,
            else => unreachable,
        };

        var operand: Operand = undefined;
        if (std.mem.eql(u8, opLine[2..], "old")) {
            operand = Operand{
                .old = {},
            };
        } else {
            const value = try std.fmt.parseInt(u64, opLine[2..], 10);
            operand = Operand{
                .raw = .{
                    .val = value,
                },
            };
        }

        const divisibleByLine = input[index + 3];
        const divisibleBy = try std.fmt.parseInt(u64, divisibleByLine[21..], 10);

        const ifTrueValue = try std.fmt.parseInt(usize, input[index + 4][29..], 10);
        const ifFalseValue = try std.fmt.parseInt(usize, input[index + 5][30..], 10);

        try result.append(.{
            .items = startingItems,
            .op = .{
                .opType = opType,
                .value = operand,
            },
            .testItem = .{
                .divisibleBy = divisibleBy,
                .ifTrue = ifTrueValue,
                .ifFalse = ifFalseValue,
            },
        });
    }

    return result;
}

const OpType = enum {
    add,
    mul,
};

const OperandType = enum {
    raw,
    old,
};

const Operand = union(OperandType) {
    raw: struct {
        val: u64,
    },
    old: void,
};

const Monkey = struct {
    items: ArrayList(u64),
    op: struct {
        opType: OpType,
        value: Operand,
    },
    testItem: struct {
        divisibleBy: u64,
        ifTrue: usize,
        ifFalse: usize,
    },
};
