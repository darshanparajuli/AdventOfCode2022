const std = @import("std");
const day1 = @import("day1.zig");
const day2 = @import("day2.zig");
const day3 = @import("day3.zig");

pub fn main() !void {
    var arenaAllocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arenaAllocator.deinit();

    try day1.run(arenaAllocator.allocator());
    try day2.run(arenaAllocator.allocator());
    try day3.run(arenaAllocator.allocator());
}
