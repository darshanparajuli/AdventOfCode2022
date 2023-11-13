const std = @import("std");
const util = @import("util.zig");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn run(allocator: Allocator) !void {
    try util.print_stdout("Day 10:\n", .{});
    const input = try parse_input(allocator, (try util.read_input_of_day(allocator, 10)).items);
    try part_1(input.items);
    try part_2(input.items);
}

fn part_1(input: []Instruction) !void {
    var X: i32 = 1;
    var cycles: i32 = 0;
    var i: usize = 0;
    var sum: i32 = 0;

    while (cycles < 223 and i < input.len) : (i += 1) {
        const instr = input[i];
        switch (instr) {
            .noop => {
                cycles += 1;
                if (cycles == 20 or cycles == 60 or cycles == 100 or cycles == 140 or cycles == 180 or cycles == 220) {
                    sum += cycles * X;
                }
            },
            .addx => {
                cycles += 1;
                if (cycles == 20 or cycles == 60 or cycles == 100 or cycles == 140 or cycles == 180 or cycles == 220) {
                    sum += cycles * X;
                }
                cycles += 1;
                if (cycles == 20 or cycles == 60 or cycles == 100 or cycles == 140 or cycles == 180 or cycles == 220) {
                    sum += cycles * X;
                }
                X += instr.addx.value;
            },
        }
    }

    try util.print_stdout("  part 1: {}\n", .{sum});
}

fn part_2(input: []Instruction) !void {
    var X: i32 = 1;
    var cycles: i32 = 0;
    var instrIndex: usize = 0;

    var crt: [6][40]bool = undefined;
    for (0..crt.len) |j| {
        var i: usize = 0;
        while (i < crt[j].len) : (i += 1) {
            crt[j][i] = false;
        }
    }

    var pixelPos: usize = 0;

    while (cycles < 40 * 6 and instrIndex < input.len) : (instrIndex += 1) {
        const instr = input[instrIndex];
        switch (instr) {
            .noop => {
                cycles += 1;

                const y = pixelPos / 40;
                const x = pixelPos % 40;
                if (x >= X - 1 and x <= X + 1) {
                    crt[y][x] = true;
                } else {
                    crt[y][x] = false;
                }

                pixelPos += 1;
            },
            .addx => {
                cycles += 1;

                var y = pixelPos / 40;
                var x = pixelPos % 40;
                if (x >= X - 1 and x <= X + 1) {
                    crt[y][x] = true;
                } else {
                    crt[y][x] = false;
                }

                pixelPos += 1;

                cycles += 1;

                y = pixelPos / 40;
                x = pixelPos % 40;
                if (x >= X - 1 and x <= X + 1) {
                    crt[y][x] = true;
                } else {
                    crt[y][x] = false;
                }

                pixelPos += 1;
                X += instr.addx.value;
            },
        }
    }
    try util.print_stdout("  part 2:\n", .{});
    try print_crt(crt);
}

fn print_crt(crt: [6][40]bool) !void {
    for (0..crt.len) |j| {
        var i: usize = 0;
        try util.print_stdout("  ", .{});
        while (i < crt[j].len) : (i += 1) {
            if (crt[j][i]) {
                try util.print_stdout("#", .{});
            } else {
                try util.print_stdout(".", .{});
            }
        }
        try util.print_stdout("\n", .{});
    }
}

const InstructionType = enum {
    noop,
    addx,
};
const Instruction = union(InstructionType) {
    noop: void,
    addx: struct {
        value: i32,
    },
};

fn parse_input(allocator: Allocator, input: [][]u8) !ArrayList(Instruction) {
    var result = ArrayList(Instruction).init(allocator);

    for (input) |line| {
        if (std.mem.eql(u8, line, "noop")) {
            try result.append(.{
                .noop = {},
            });
        } else if (std.mem.startsWith(u8, line, "addx")) {
            var iter = std.mem.splitAny(u8, line, " ");
            _ = iter.next().?;
            const value = try std.fmt.parseInt(i32, iter.next().?, 10);
            try result.append(.{
                .addx = .{
                    .value = value,
                },
            });
        }
    }

    return result;
}
