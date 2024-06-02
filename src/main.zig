const std = @import("std");
const assert = @import("./assert.zig").assert;
const csv = @import("./Csv/Csv.zig").Csv;

pub fn main() !void {

    const csv_file = try csv.init("/mnt/c/Entwicklung/zig/vero/src/data/username.csv", true); 
    try csv_file.search("a");

}
