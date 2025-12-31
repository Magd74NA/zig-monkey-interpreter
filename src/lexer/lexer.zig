const std = @import("std");

const Lexer = struct {
    input: []const u8,
    position: usize,
    readPosition: usize,
    ch: u8,

    // Lexer read character
    pub fn readChar(l: *Lexer) void {
        if (l.readPosition >= l.input.len) {
            l.ch = 0;
        } else {
            l.ch = l.input[l.readPosition];
        }
        l.position = l.readPosition;
        l.readPosition += 1;
    }

    pub fn init(input: []const u8) !*Lexer {
        var l = Lexer;
        l.input = input;
        l.position = 0; // current position in input (points to current char)
        l.readPosition = 0; // current reading position in input (after current char)
        l.ch = 0; // current char under examination

        l.readChar();
        return l;
    }

    //Peek ahead utility for multi symbol tokens
    pub fn peekChar(l: *const Lexer) u8 {
        if (l.readPosition >= l.input.len) {
            return 0;
        } else {
            return l.input[l.readPosition];
        }
    }
};

fn isDigit(ch: u8) bool {
    return '0' <= ch and ch <= '9';
}

fn isLetter(ch: u8) bool {
    return 'a' <= ch and ch <= 'z' or 'A' <= ch and ch <= 'Z' or ch == '_';
}
