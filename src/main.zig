// Program: Random Password Generator
//
// Description: Generates random passwords of a user-specified length using Zig programming language.
//
// Author: [\Chieng Sisovin\](https://github.com/sisovin)
// Date: 2025-01-15

const std = @import("std");
const random = @import("std").Random;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    const allocator = std.heap.page_allocator;

    // Prompt the user for the desired password length
    std.debug.print("The password length should not be less than 4 and should not exceed 128 characters.\n", .{});
    try stdout.print("Length: ", .{});
    const length_input = try allocator.alloc(u8, 64);
    defer allocator.free(length_input);

    var length_str = try stdin.readUntilDelimiterOrEof(length_input, '\n') orelse return;
    // Manually remove any newline characters
    while (length_str[length_str.len - 1] == '\n' or length_str[length_str.len - 1] == '\r') {
        length_str = length_str[0 .. length_str.len - 1];
    }
    std.debug.print("Length: {s}\n", .{length_str});

    const length: usize = try std.fmt.parseInt(usize, length_str, 10);

    // Validate the password length
    if (length < 4) {
        try stdout.print("Password length must be >= 4 to include all character types!\n", .{});
        return;
    }
    if (length > 128) {
        try stdout.print("Password length must be <= 128!\n", .{});
        return;
    }

    // Define possible characters
    const digits = "0123456789";
    const lowers = "abcdefghijklmnopqrstuvwxyz";
    const uppers = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const symbols = "!@#$%^&*()";

    const digits_len = digits.len;
    const lowers_len = lowers.len;
    const uppers_len = uppers.len;
    const symbols_len = symbols.len;

    // Allocate memory for the password
    const password = try allocator.alloc(u8, length + 1);
    defer allocator.free(password);
    @memset(password, 0);

    // Initialize random number generator
    const timeStamp = std.time.milliTimestamp();
    // std.debug.print("Seed: {}\n", .{timeStamp});
    const seed: u64 = @intCast(timeStamp);
    std.debug.print("Seed: {}\n", .{seed});
    var rng = random.DefaultPrng.init(seed);

    // Ensure at least one character from each type
    password[0] = digits[rng.next() % digits_len];
    password[1] = lowers[rng.next() % lowers_len];
    password[2] = uppers[rng.next() % uppers_len];
    password[3] = symbols[rng.next() % symbols_len];

    // Fill the rest of the password randomly
    for (password[4..]) |*char| {
        const char_type = rng.next() % 4;
        char.* = switch (char_type) {
            0 => digits[rng.next() % digits_len],
            1 => lowers[rng.next() % lowers_len],
            2 => uppers[rng.next() % uppers_len],
            else => symbols[rng.next() % symbols_len],
        };
    }

    // Fisher-Yates shuffle implementation
    var idx: usize = length - 1;
    while (idx > 0) : (idx -= 1) {
        const swap_idx = rng.next() % (idx + 1);
        const temp = password[idx];
        password[idx] = password[swap_idx];
        password[swap_idx] = temp;
    }

    // Ensure null termination and print
    password[length] = 0;
    try stdout.print("Password: {s}\n", .{password[0..length]});
}
