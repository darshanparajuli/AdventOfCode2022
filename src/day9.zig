const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;
const Pos = util.Vec2(i32);

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 9:\n", .{});
    const input = try parse_input(allocator, (try util.read_input_of_day(allocator, 9)).items);
    try part_1(allocator, input.items);
    try part_2(allocator, input.items);
}

fn part_1(allocator: Allocator, input: []Move) !void {
    var headPos = Pos{
        .x = 0,
        .y = 0,
    };
    var tailPos = headPos;
    var visited = AutoHashMap(Pos, void).init(allocator);
    try visited.put(tailPos, {});

    for (input) |move| {
        const deltaPos = switch (move.moveType) {
            .L => Pos{ .x = -1, .y = 0 },
            .R => Pos{ .x = 1, .y = 0 },
            .U => Pos{ .x = 0, .y = -1 },
            .D => Pos{ .x = 0, .y = 1 },
        };

        for (0..move.steps) |_| {
            headPos = Pos{
                .x = headPos.x + deltaPos.x,
                .y = headPos.y + deltaPos.y,
            };

            const dx = std.math.absCast(tailPos.x - headPos.x);
            const dy = std.math.absCast(tailPos.y - headPos.y);
            if (dx > 1 or dy > 1) {
                switch (move.moveType) {
                    .L => {
                        if (tailPos.x >= headPos.x) {
                            tailPos.x -= 1;
                            if (headPos.y != tailPos.y) {
                                tailPos.y = headPos.y;
                            }
                        }
                    },
                    .R => {
                        if (tailPos.x <= headPos.x) {
                            tailPos.x += 1;
                            if (headPos.y != tailPos.y) {
                                tailPos.y = headPos.y;
                            }
                        }
                    },
                    .U => {
                        if (tailPos.y >= headPos.y) {
                            tailPos.y -= 1;
                            if (headPos.x != tailPos.x) {
                                tailPos.x = headPos.x;
                            }
                        }
                    },
                    .D => {
                        if (tailPos.y <= headPos.y) {
                            tailPos.y += 1;
                            if (headPos.x != tailPos.x) {
                                tailPos.x = headPos.x;
                            }
                        }
                    },
                }

                tailPos = tailPos;
                try visited.put(tailPos, {});
            }
        }
    }

    try util.print_stdout("  part 1: {}\n", .{visited.count()});
}

fn part_2(allocator: Allocator, input: []Move) !void {
    var knots: [10]Pos = undefined;
    for (0..knots.len) |i| {
        knots[i] = Pos{ .x = 0, .y = 0 };
    }
    var visited = AutoHashMap(Pos, void).init(allocator);
    try visited.put(knots[knots.len - 1], {});

    for (input) |move| {
        const deltaPos = switch (move.moveType) {
            .L => Pos{ .x = -1, .y = 0 },
            .R => Pos{ .x = 1, .y = 0 },
            .U => Pos{ .x = 0, .y = -1 },
            .D => Pos{ .x = 0, .y = 1 },
        };

        for (0..move.steps) |_| {
            knots[0] = Pos{
                .x = knots[0].x + deltaPos.x,
                .y = knots[0].y + deltaPos.y,
            };

            for (1..knots.len) |i| {
                var currKnot = knots[i];
                const prevKnot = knots[i - 1];
                const dx = currKnot.x - prevKnot.x;
                const dy = currKnot.y - prevKnot.y;

                if (dx == -2 and dy == 0) {
                    currKnot.x += 1;
                } else if (dx == 2 and dy == 0) {
                    currKnot.x -= 1;
                } else if (dx == 0 and dy == -2) {
                    currKnot.y += 1;
                } else if (dx == 0 and dy == 2) {
                    currKnot.y -= 1;
                } else {
                    if (std.math.absCast(dx) > 1 or std.math.absCast(dy) > 1) {
                        if (prevKnot.x > currKnot.x and prevKnot.y < currKnot.y) {
                            currKnot.x += 1;
                            currKnot.y -= 1;
                        } else if (prevKnot.x > currKnot.x and prevKnot.y > currKnot.y) {
                            currKnot.x += 1;
                            currKnot.y += 1;
                        } else if (prevKnot.x < currKnot.x and prevKnot.y < currKnot.y) {
                            currKnot.x -= 1;
                            currKnot.y -= 1;
                        } else if (prevKnot.x < currKnot.x and prevKnot.y > currKnot.y) {
                            currKnot.x -= 1;
                            currKnot.y += 1;
                        }
                    }
                }
                knots[i] = currKnot;
                if (i == knots.len - 1) {
                    try visited.put(knots[i], {});
                }
            }
        }
    }

    try util.print_stdout("  part 2: {}\n", .{visited.count()});
}

fn parse_input(allocator: Allocator, input: [][]u8) !ArrayList(Move) {
    var result = ArrayList(Move).init(allocator);
    for (input) |line| {
        var iter = std.mem.splitSequence(u8, line, " ");
        const moveTypeChar = iter.next().?[0];
        const moveType = switch (moveTypeChar) {
            'L' => MoveType.L,
            'R' => MoveType.R,
            'U' => MoveType.U,
            'D' => MoveType.D,
            else => unreachable,
        };
        const steps = try std.fmt.parseInt(u32, iter.next().?, 10);
        try result.append(Move{
            .moveType = moveType,
            .steps = steps,
        });
    }
    return result;
}

const MoveType = enum { L, R, U, D };
const Move = struct {
    moveType: MoveType,
    steps: u32,
};
