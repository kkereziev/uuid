const std = @import("std");
const StringBuilder = @import("string_builder");
const Self = @This();

pub const Nil = Self{ ._bytes = [_]u8{0x0} ** 16 };

// Indices in the UUID string representation for each byte.
const encoded_pos = [16]u8{ 0, 2, 4, 6, 9, 11, 14, 16, 19, 21, 24, 26, 28, 30, 32, 34 };
const hex = "0123456789abcdef";
const hex_to_nibble = [_]u8{
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    0,   1,   2,   3,   4,   5,   6,   7,   8,   9,   255, 255, 255, 255, 255, 255,
    255, 10,  11,  12,  13,  14,  15,  255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 10,  11,  12,  13,  14,  15,  255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
};

_bytes: [16]u8,

pub fn newV4() Self {
    var uuid = Self{ ._bytes = undefined };

    std.crypto.random.bytes(&uuid._bytes);

    uuid._bytes[6] = (uuid._bytes[6] & 0x0f) | 0x40;
    uuid._bytes[8] = (uuid._bytes[8] & 0x3f) | 0x80;

    return uuid;
}

pub fn toString(self: Self) [36]u8 {
    var buf: [36]u8 = undefined;

    buf[8] = '-';
    buf[13] = '-';
    buf[18] = '-';
    buf[23] = '-';

    inline for (encoded_pos, 0..) |i, j| {
        buf[i + 0] = hex[self._bytes[j] >> 4];
        buf[i + 1] = hex[self._bytes[j] & 0x0f];
    }

    return buf;
}

test {
    std.testing.refAllDecls(@This());
}

const t = std.testing;

test "generate new v4 uuid and print it via string" {
    std.debug.print("{s}\n", .{newV4().toString()});
}

test "print nil uuid v4" {
    const buf = Nil.toString();

    try t.expectEqualStrings("00000000-0000-0000-0000-000000000000", &buf);
}
