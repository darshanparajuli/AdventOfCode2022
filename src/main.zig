const std = @import("std");
const day1 = @import("day1.zig");

pub fn main() !void {
    var arenaAllocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arenaAllocator.deinit();

    try day1.run(arenaAllocator.allocator());
}
