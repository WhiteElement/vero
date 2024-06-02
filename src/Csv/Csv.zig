const std = @import("std");
const assert = @import("../assert.zig").assert;

const csvError = error {
    OpenError
};

pub const Csv = struct { 
    path: []const u8,
    file: std.fs.File,
    header: bool = false,

    //
    // APIs
    // 
    pub fn init(file_path: []const u8, hasHeader: bool) csvError!Csv {

        const file = openFile(file_path) catch return csvError.OpenError;
        std.log.info("Opening file:{any}\n", .{file});

        return Csv{ 
            .path = file_path,
            .file = file,
            .header = hasHeader,
        };
    }

    pub fn toTerminal(self: Csv, lines: usize) !void {
        const reader = self.file.reader();
        var buf: [1024]u8 = undefined;

        var line_num: usize = if (self.header) 0 else 1;
        while(try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            if (line_num <= lines or lines == 0) {
                std.debug.print("{any}: {s}\n", .{line_num, line});
                line_num += 1;
            }
        }

    }

    pub fn search(self: Csv, phrase: []const u8) !void {
        const reader = self.file.reader();
        var buf: [1024]u8 = undefined;

        while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            if (std.mem.containsAtLeast(u8, line, 1, phrase)) {
                std.debug.print("Match: {s}\n", .{line});
            }
        }
    }

    //
    // PRIVATE
    //

    fn openFile(file_path: []const u8) !std.fs.File {
        return try std.fs.openFileAbsolute(file_path, .{});
    }
};



//
// TESTS
//

test "can open sample file" {
    _ = try Csv.init("/mnt/c/Entwicklung/zig/vero/src/data/username.csv", true);
}

test "output sample file to terminal" {
    const file = try Csv.init("/mnt/c/Entwicklung/zig/vero/src/data/username.csv", true);
    try file.toTerminal(0);
}

test "output first 3 lines from sample file to terminal" {
    const file = try Csv.init("/mnt/c/Entwicklung/zig/vero/src/data/username.csv", true);
    try file.toTerminal(3);
}

