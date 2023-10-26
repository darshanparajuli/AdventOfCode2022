const std = @import("std");

var std_out_mutex = std.Thread.Mutex{};

pub fn print_stdout(comptime fmt: []const u8, args: anytype) !void {
    std_out_mutex.lock();
    defer std_out_mutex.unlock();

    const stdout = std.io.getStdOut().writer();
    try stdout.print(fmt, args);
}
