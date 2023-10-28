const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 2:\n", .{});
    const input = try util.read_input_of_day(allocator, 2);
    try part_1(try input.clone());
    try part_2(input);
}

const Rps = enum(u32) {
    rock = 1,
    paper = 2,
    scissor = 3,

    fn from_char(c: u8) Rps {
        return switch (c) {
            'A' => Rps.rock,
            'B' => Rps.paper,
            'C' => Rps.scissor,
            'X' => Rps.rock,
            'Y' => Rps.paper,
            'Z' => Rps.scissor,
            else => unreachable,
        };
    }
};

fn part_1(input: ArrayList([]u8)) !void {
    var sum: u32 = 0;
    for (input.items) |line| {
        const p1 = Rps.from_char(line[0]);
        const p2 = Rps.from_char(line[2]);
        sum += play_rps(p2, p1);
    }
    try util.print_stdout("  part 1: {}\n", .{sum});
}

fn part_2(input: ArrayList([]u8)) !void {
    var sum: u32 = 0;
    for (input.items) |line| {
        const p1 = Rps.from_char(line[0]);
        const p2 = Rps.from_char(line[2]);
        sum += play_rps_2(p1, p2);
    }
    try util.print_stdout("  part 2: {}\n", .{sum});
}

// p1 is player, p2 is opponent.
fn play_rps(p1: Rps, p2: Rps) u32 {
    var score: u32 = 0;
    switch (p1) {
        .rock => {
            score = switch (p2) {
                .rock => 3,
                .paper => 0,
                .scissor => 6,
            };
        },

        .paper => {
            score = switch (p2) {
                .rock => 6,
                .paper => 3,
                .scissor => 0,
            };
        },

        .scissor => {
            score = switch (p2) {
                .rock => 0,
                .paper => 6,
                .scissor => 3,
            };
        },
    }

    return @intFromEnum(p1) + score;
}

// strat RPS indicates whether to lose, draw or win.
fn play_rps_2(opponent: Rps, strat: Rps) u32 {
    var selection: Rps = undefined;
    switch (opponent) {
        .rock => {
            selection = switch (strat) {
                .rock => Rps.scissor,
                .paper => Rps.rock,
                .scissor => Rps.paper,
            };
        },

        .paper => {
            selection = switch (strat) {
                .rock => Rps.rock,
                .paper => Rps.paper,
                .scissor => Rps.scissor,
            };
        },

        .scissor => {
            selection = switch (strat) {
                .rock => Rps.paper,
                .paper => Rps.scissor,
                .scissor => Rps.rock,
            };
        },
    }

    const score: u32 = switch (strat) {
        .rock => 0,
        .paper => 3,
        .scissor => 6,
    };

    return @intFromEnum(selection) + score;
}
