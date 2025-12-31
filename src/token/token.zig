const std = @import("std");

pub const TokenType = enum {
    ILLEGAL,
    EOF,

    // Identifiers + literals
    IDENT, // add, foobar, x, y, ...
    INT, // 1343456

    // Operators
    ASSIGN,
    PLUS,
    MINUS,
    SLASH,
    ASTERISK,
    GT,
    LT,
    BANG,

    // Two char operators
    EQ,
    NOT_EQ,

    // Delimiters
    COMMA,
    SEMICOLON,
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,

    // Keywords
    FUNCTION,
    LET,
    RETURN,
    IF,
    TRUE,
    ELSE,
    FALSE,
};

pub const Token = struct {
    type: TokenType,
    literal: []const u8,
};

pub fn lookupIdent(ident: []const u8) TokenType {
    if (std.mem.eql(u8, ident, "fn")) return .FUNCTION;
    if (std.mem.eql(u8, ident, "let")) return .LET;
    if (std.mem.eql(u8, ident, "return")) return .RETURN;
    if (std.mem.eql(u8, ident, "if")) return .IF;
    if (std.mem.eql(u8, ident, "else")) return .ELSE;
    if (std.mem.eql(u8, ident, "true")) return .TRUE;
    if (std.mem.eql(u8, ident, "false")) return .FALSE;
    return .IDENT;
}
