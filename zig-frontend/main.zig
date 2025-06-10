const std = @import("std");
const http = std.http;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const stdout = std.io.getStdOut().writer();

    const args = try std.process.argsAlloc(allocator);
    if (args.len < 2) {
        try stdout.print("Usage: summarise <path-to-code>\n", .{});
        return;
    }

    const file_path = args[1];
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const code = try file.readToEndAlloc(allocator, 16 * 1024); // 16 KB max
    defer allocator.free(code);

    const body = try std.fmt.allocPrint(allocator, "{{\"code\": \"{s}\"}}", .{std.zig.fmtEscapedString(code)});
    defer allocator.free(body);

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    var headers = http.Headers.init(allocator);
    try headers.append("Content-Type", "application/json");

    const response = try client.request(.POST, "http://127.0.0.1:5000/summarise", headers, body);
    defer response.deinit();

    const response_body = try response.reader().readAllAlloc(allocator, 4096);
    try stdout.print("Summary:\n{s}\n", .{response_body});
}
