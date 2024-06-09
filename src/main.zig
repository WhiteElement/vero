const std = @import("std");
const assert = @import("./assert.zig").assert;
const csv = @import("./Csv/Csv.zig").Csv;
const clarg = @import("./CLARG.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const file = try clarg.getPositionalArgument(alloc, 1);
    const search_term = try clarg.getPositionalArgument(alloc, 2);
    std.log.info("Searching in:'{s}' for '{s}'...\n", .{ file, search_term });

    const csv_file = try csv.init(file, true);
    defer csv_file.close();

    try csv_file.search(search_term);
}
