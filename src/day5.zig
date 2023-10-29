const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const ParsedInput = std.meta.Tuple(&.{ ArrayList(ArrayList(u8)), ArrayList(Move) });

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 5:\n", .{});
    const input = try parse_input(allocator, try util.read_input_of_day(allocator, 5));
    try part_1(allocator, input);
    try part_2(allocator, input);
}

fn part_1(allocator: Allocator, input: ParsedInput) !void {
    var stacks = try input[0].clone();
    for (0..stacks.items.len) |i| {
        stacks.items[i] = try stacks.items[i].clone();
    }
    const moves = input[1];

    for (moves.items) |move| {
        var fromStack = &stacks.items[move.from - 1];
        var toStack = &stacks.items[move.to - 1];
        for (0..move.count) |_| {
            try toStack.append(fromStack.pop());
        }
    }

    const topChars: []u8 = try allocator.alloc(u8, stacks.items.len);
    for (stacks.items, 0..) |stack, i| {
        topChars[i] = stack.items[stack.items.len - 1];
    }

    try util.print_stdout("  part 1: {s}\n", .{topChars});
}

fn part_2(allocator: Allocator, input: ParsedInput) !void {
    var stacks = input[0];
    const moves = input[1];

    for (moves.items) |move| {
        var fromStack = &stacks.items[move.from - 1];
        var toStack = &stacks.items[move.to - 1];
        const fromStackLen = fromStack.items.len;
        try toStack.appendSlice(fromStack.items[fromStackLen - move.count ..]);
        for (move.count) |_| {
            _ = fromStack.pop();
        }
    }

    const topChars: []u8 = try allocator.alloc(u8, stacks.items.len);
    for (stacks.items, 0..) |stack, i| {
        topChars[i] = stack.items[stack.items.len - 1];
    }

    try util.print_stdout("  part 2: {s}\n", .{topChars});
}

const Move = struct {
    count: u32,
    from: u32,
    to: u32,
};

fn parse_input(allocator: Allocator, input: ArrayList([]u8)) !ParsedInput {
    var moveIndex: usize = 0;
    for (input.items, 0..) |item, i| {
        if (std.mem.startsWith(u8, item, "move")) {
            moveIndex = i;
            break;
        }
    }

    var stackCountIter = std.mem.splitBackwardsAny(u8, input.items[moveIndex - 2], " ");
    const stackCount = try std.fmt.parseInt(u32, stackCountIter.first(), 10);

    var stacks = ArrayList(ArrayList(u8)).init(allocator);
    for (0..stackCount) |_| {
        try stacks.append(ArrayList(u8).init(allocator));
    }
    for (input.items[0 .. moveIndex - 2]) |item| {
        var i: usize = 1;
        while (i < item.len) : (i += 4) {
            const c = item[i];
            if (c != ' ') {
                try stacks.items[(i - 1) / 4].insert(0, c);
            }
        }
    }

    var moves = ArrayList(Move).init(allocator);
    for (input.items[moveIndex..]) |item| {
        var iter = std.mem.splitSequence(u8, item, " ");
        _ = iter.next().?; // skip "move".
        const count = try std.fmt.parseInt(u32, iter.next().?, 10);
        _ = iter.next().?; // skip "from".
        const from = try std.fmt.parseInt(u32, iter.next().?, 10);
        _ = iter.next().?; // skip "to".
        const to = try std.fmt.parseInt(u32, iter.next().?, 10);
        const move = Move{
            .count = count,
            .from = from,
            .to = to,
        };
        try moves.append(move);
    }

    return .{ stacks, moves };
}
