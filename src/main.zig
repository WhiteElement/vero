const std = @import("std");
const assert = @import("./assert.zig").assert;

const inputErrors = error{
    NoFilePassed,
};

pub fn main() !void {
    const fileInput = try fileNameFromArgs();
    std.log.info("Trying to Parse {any}", .{fileInput});

    _ = try loadFile(fileInput);
}

fn loadFile(filePath: []const u8) !std.fs.File {
    const file = try std.fs.cwd().openFile(filePath, .{});
    std.log.info("Found {any}, parsing", .{file});
    return file;
}

fn fileNameFromArgs() inputErrors![]const u8 {
    var args = std.process.args();
    var arg_idx: u8 = 0;

    while (args.next()) |arg| {
        arg_idx += 1;

        if (arg_idx == 2) return arg;
    }
    return inputErrors.NoFilePassed;
}
