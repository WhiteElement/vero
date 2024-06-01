const std = @import("std");

const Csv = struct { file: std.fs.File };

pub fn init(file: std.fs.File) Csv {
    return Csv{ .file = file };
}
