const std = @import("std");

const Lexer = struct {
    input: []const u8,
    position: usize,
    readPosition: usize,
    ch: u8,

    pub fn init(input: []const u8) !*Lexer {
        var l = Lexer;
        l.input = input;
        l.position = 0;
        l.readPosition = 0;
        l.ch = 0;

        l.readChar();
        return l;
    }

    pub fn readChar(l: *Lexer) void {
        if (l.readPosition >= l.input.len) {
            l.ch = 0;
        } else {
            l.ch = l.input[l.readPosition];
        }
        l.position = l.readPosition;
        l.readPosition += 1;
    }

    pub fn peekChar(l: *const Lexer) u8 {
        if (l.readPosition >= l.input.len) {
            return 0;
        } else {
            return l.input[l.readPosition];
        }
    }
};
