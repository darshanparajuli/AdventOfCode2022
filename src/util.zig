const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

var std_out_mutex = std.Thread.Mutex{};

pub fn print_stdout(comptime fmt: []const u8, args: anytype) !void {
    std_out_mutex.lock();
    defer std_out_mutex.unlock();

    const stdout = std.io.getStdOut().writer();
    try stdout.print(fmt, args);
}

pub fn read_input_of_day(allocator: Allocator, day: u32) !ArrayList([]u8) {
    const fileName = try std.fmt.allocPrint(allocator, "input/day{}.txt", .{day});
    var file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var bufReader = std.io.bufferedReader(file.reader());
    var inStream = bufReader.reader();
    var buf: [8192]u8 = undefined;

    var arrayList = ArrayList([]u8).init(allocator);
    while (try inStream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try arrayList.append(try allocator.dupe(u8, line));
    }

    return arrayList;
}

pub fn Vec2(comptime T: type) type {
    return struct {
        x: T,
        y: T,
    };
}
