const std = @import("std");
const day1 = @import("day1.zig");
const day2 = @import("day2.zig");
const day3 = @import("day3.zig");
const day4 = @import("day4.zig");
const day5 = @import("day5.zig");
const day6 = @import("day6.zig");
const day7 = @import("day7.zig");
const day8 = @import("day8.zig");
const day9 = @import("day9.zig");
const day10 = @import("day10.zig");
const day11 = @import("day11.zig");

pub fn main() !void {
    var arenaAllocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arenaAllocator.deinit();

    try day1.run(arenaAllocator.allocator());
    try day2.run(arenaAllocator.allocator());
    try day3.run(arenaAllocator.allocator());
    try day4.run(arenaAllocator.allocator());
    try day5.run(arenaAllocator.allocator());
    try day6.run(arenaAllocator.allocator());
    try day7.run(arenaAllocator.allocator());
    try day8.run(arenaAllocator.allocator());
    try day9.run(arenaAllocator.allocator());
    try day10.run(arenaAllocator.allocator());
    try day11.run(arenaAllocator.allocator());
}
