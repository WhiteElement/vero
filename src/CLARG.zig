const std = @import("std");
const expect = std.testing.expect;

const libError = error{ NoValueForParam, ParamNotPassed, InitError, AllocPrintError };

/// Returns Argument Values for cli Option/Flag.
pub fn getCliOption(allocator: std.mem.Allocator, option: []const u8) libError![]const u8 {
    var iter = getIter(allocator) catch |err| {
        std.log.err("ERROR getting cli arguments\n{!}", .{err});
        return libError.InitError;
    };

    const pattern_one = std.fmt.allocPrint(allocator, "-{s}", .{option}) catch |err| {
        std.log.err("ERROR trying to concatenate\n{!}", .{err});
        return libError.AllocPrintError;
    };
    const pattern_two = std.fmt.allocPrint(allocator, "--{s}", .{option}) catch |err| {
        std.log.err("ERROR trying to concatenate\n{!}", .{err});
        return libError.AllocPrintError;
    };

    defer {
        allocator.free(pattern_one);
        allocator.free(pattern_two);
    }

    while (iter.next()) |val| {
        if (std.mem.eql(u8, val, pattern_one) or std.mem.eql(u8, val, pattern_two)) {
            const value = iter.next();
            return value orelse return libError.NoValueForParam;
        }
    }
    return libError.ParamNotPassed;
}

pub fn getPositionalArgument(allocator: std.mem.Allocator, pos: u8) libError![]const u8 {
    var iter = getIter(allocator) catch |err| {
        std.log.err("ERROR getting positional argument\n{!}\n", .{err});
        return libError.InitError;
    };

    var idx: u8 = 0;
    while (iter.next()) |val| {
        if (idx == pos) {
            return val;
        }
        idx += 1;
    }

    return libError.NoValueForParam;
}

fn getIter(allocator: std.mem.Allocator) !std.process.ArgIterator {
    return try std.process.argsWithAllocator(allocator);
}
