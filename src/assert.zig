const std = @import("std");

pub fn assert(assertion: bool, msg: []const u8) void {
    if (!assertion) {
        std.log.err("ASSERT FAIL: {s}", .{msg});
        std.process.exit(1);
    }
}
