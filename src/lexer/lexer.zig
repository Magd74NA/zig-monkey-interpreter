const std = @import("std");
const token = @import("../token/token.zig");

const Lexer = struct {
    input: []const u8,
    position: usize,
    readPosition: usize,
    ch: u8,

    fn readDigit(l: *Lexer) []const u8 {
        //position records the starting position of our "word"
        const start: usize = l.position; //Mark
        while (isDigit(l.ch)) { //Loop
            l.readChar();
        }
        // returns the literal "word" by
        // returning a slice from position to the last lexed character
        return l.input[start..l.position]; //Slice
    }

    fn readLetter(l: *Lexer) []const u8 {
        //position records the starting position of our "word"
        const start: usize = l.position; //Mark
        while (isLetter(l.ch)) { //Loop
            l.readChar();
        }
        // returns the literal "word" by
        // returning a slice from position to the last lexed character
        return l.input[start..l.position]; //Slice
    }

    // Lexer read character
    fn readChar(l: *Lexer) void {
        if (l.readPosition >= l.input.len) {
            l.ch = 0;
        } else {
            l.ch = l.input[l.readPosition];
        }
        l.position = l.readPosition;
        l.readPosition += 1;
    }

    pub fn init(input: []const u8) Lexer {
        var l = Lexer{
            .input = input,
            .position = 0, // current position in input (points to current char)
            .readPosition = 0, // current reading position in input (after current char)
            .ch = 0, // current char under examination
        };
        l.readChar();
        return l;
    }

    //Peek ahead utility for multi symbol tokens
    fn peekChar(l: *const Lexer) u8 {
        if (l.readPosition >= l.input.len) {
            return 0;
        } else {
            return l.input[l.readPosition];
        }
    }

    // Defines and skips which characters are considered meaningless whitespace
    fn skipWhitespace(l: *Lexer) void {
        // GOLANG VERSION for l.ch == ' ' || l.ch == '\t' || l.ch == '\n' || l.ch == '\r' {
        while (l.ch == ' ' or l.ch == '\t' or l.ch == '\n' or l.ch == '\r') {
            l.readChar();
        }
    }

    pub fn NextToken(l: *Lexer) !token.Token {
        var tok: token.Token = undefined;

        l.skipWhitespace();

        tok = switch (l.ch) {
            ';' => newToken(token.SEMICOLON, l.ch),
            '(' => newToken(token.LPAREN, l.ch),
            ')' => newToken(token.RPAREN, l.ch),
            ',' => newToken(token.COMMA, l.ch),
            '+' => newToken(token.PLUS, l.ch),
            '-' => newToken(token.MINUS, l.ch),
            '/' => newToken(token.SLASH, l.ch),
            '*' => newToken(token.ASTERISK, l.ch),
            '>' => newToken(token.GT, l.ch),
            '<' => newToken(token.LT, l.ch),
            '{' => newToken(token.LBRACE, l.ch),
            '}' => newToken(token.RBRACE, l.ch),
            '=' => if (l.peekChar() == '=') {
                const start = l.position; // position of '='
                l.readChar();
                const literal = l.input[start .. l.position + 1]; // slice directly from input
                l.readChar(); // consume second '='
                token.Token{ .Type = token.EQ, .literal = literal };
            } else {
                newToken(token.ASSIGN, l.ch);
            },
            '=' => if (l.peekChar() == '=') {
                const start = l.position; // position of '='
                l.readChar();
                const literal = l.input[start .. l.position + 1]; // slice directly from input
                l.readChar(); // consume second '='
                token.Token{ .Type = token.NOT_EQ, .literal = literal };
            } else {
                newToken(token.BANG, l.ch);
            },
            0 => {
                tok.literal = "";
                tok.type = token.EOF;
            },
            else => {
                if (isLetter(l.ch)) {
                    tok.literal = l.readLetter();
                    tok.Type = token.LookupIdent(tok.literal);
                    return tok;
                } else if (isDigit(l.ch)) {
                    tok.literal = l.readDigit();
                    tok.Type = token.INT;
                    return tok;
                } else {
                    tok = newToken(token.ILLEGAL, l.ch);
                }
            },
        };
        l.readChar();
        return tok;
    }
};

fn isDigit(ch: u8) bool {
    return '0' <= ch and ch <= '9';
}

fn isLetter(ch: u8) bool {
    return ('a' <= ch and ch <= 'z') or ('A' <= ch and ch <= 'Z') or (ch == '_');
}

fn newToken(tokenType: token.TokenType, literal: []u8) token.Token {
    var tok: token.Token = undefined;
    tok.type = tokenType;
    tok.literal = literal;
    return tok;
}
