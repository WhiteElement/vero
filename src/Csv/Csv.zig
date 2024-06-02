const std = @import("std");
const assert = @import("../assert.zig").assert;

const csvError = error {
    OpenError
};

const Csv = struct { 
    path: []const u8,
    file: std.fs.File,
    header: bool = false,



    // APIs
    // 
    pub fn init(file_path: []const u8) csvError!Csv {

        const file = openFile(file_path) catch return csvError.OpenError;
        // assert(file.Metadata
        std.log.info("Opening file:{any}\n{any}\n", .{file, file.metadata()});

        return Csv{ 
            .path = file_path,
            .file = file,
            .header = 
        };
    }

    pub fn toTerminal(self: Csv, lines: usize) !void {
        const reader = self.file.reader();
        var buf: [1024]u8 = undefined;

        var line_num: usize = 1;
        while(try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            if (line_num <= lines or lines == 0) {
                std.debug.print("{any}: {s}\n", .{line_num, line});
                line_num += 1;
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
    _ = try Csv.init("/mnt/c/Entwicklung/zig/vero/src/data/username.csv");
}

test "output sample file to terminal" {
    const file = try Csv.init("/mnt/c/Entwicklung/zig/vero/src/data/username.csv");
    try file.toTerminal(0);
}

test "output first 3 lines from sample file to terminal" {
    const file = try Csv.init("/mnt/c/Entwicklung/zig/vero/src/data/username.csv");
    try file.toTerminal(3);
}

