const std = @import("std");
const assert = @import("./assert.zig").assert;
const csv = @import("./Csv/Csv.zig").Csv;

pub fn main() !void {

    var args_iter = std.process.args();
    var arg_num: u8 = 1;
    const search_term = while(args_iter.next()) |arg| {
        if (arg_num == 2) break arg;
        arg_num += 1;
    } else "";

    const csv_file = try csv.init("/mnt/c/Entwicklung/zig/vero/src/data/username.csv", true); 
    defer csv_file.close();
    try csv_file.search(search_term);

}
