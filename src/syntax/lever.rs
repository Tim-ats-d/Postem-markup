extern crate thiserror;
use std::io;

use thiserror::Error;

#[derive(Error, Debug)]
pub enum LexerError{
    #[error("fileIO error")]
    FileIOError(#[from] std::io::Error),

    #[error("Missing expected symbol {expected:?}, found {found:?}")]
    MissingExpectedSymbol{
        expected: TokenType,
        found: Token,
    },
    #[error("Can't find opening symbol ({open:?}) for {symbol:?}")]
    MissbalancedSymbol{
        symbol: char,
        open: char,
    },
    #[error("Undefined Token {token:?}")]
    UnknownToken{
        token: String, 
    },
}

pub type Token = TokenType;

pub struct Punctiation {
    pub raw: char,
    pub kind: PunctuationKind
}

#[derive(Debug)]
pub enum TokenType{
    /**end of token stream*/
    EOF,

    /**Punctiation*/
    Punctiation{raw: char, kind: PunctuationKind},

    /**Operators*/
    Operator(String),

    /**Identifier*/
    Identifier(String),

    /**Single char*/
    Char(char),

    Numeric(String),
}

#[derive(Debug)]
pub enum PunctuationKind{
    Open(BalencingDepthType),
    Close(BalencingDepthType),

    Separator,
}

type BalencingDepthType = i32; //0 is the top level

pub struct Lexer<'a> { //'a is a lifetime marker
    pub cur_line: usize, //current line number
    pub cur_column: usize, //current column number

    pub codepoint_offset: usize, //current codepoint offset

    chars: std::iter::Peekable<std::str::Chars<'a>>, //current char iterator
    state: std::collections::HashMap<char, i32>, //current state
}

//Lexer itself is a struct that implements Iterator<Token>
impl<'a> Lexer<'a> {
    //new lexer takes a string as input and returns a lexer object
    pub fn new(chars: &'a str) -> Lexer<'a> {
        Lexer {
            cur_line: 1,
            cur_column: 1,
            codepoint_offset: 0,
            chars: chars.chars().peekable(),
            state: std::collections::HashMap::new(),
        }
    } 

    fn map_balance(c: &char) -> char{ //map balance char to a char that can be used in a hashmap
         match c { 
            '{' => '}',
            '[' => ']',
            '(' => ')',
            //reverse
            '}' => '{',
            ')' => '(',
            ']' => '[',

            _ => panic!("WHY THE FUCK are you trying to map a balancing character that ISNT A FUCKING balancing character!?!?"),
         }

    }

    // push a character to the hash table
    fn push(&mut self, c: &char) -> BalencingDepthType{
        if let Some(v) = self.state.get_mut(&c){// if the key is already in the hash table, increment the value
            *v += 1;
            return *v - 1;
        } else{ // if the key is not in the hash table, add it with a value of 1
            self.state.insert(*c, 1); 
            return 0; 
        }
    }
    fn pop(&mut self, c: &char) -> Result<BalencingDepthType, LexerError>{
        if let Some(v) = self.state.get_mut(&Lexer::map_balance(&c)){
            if *v >= 1{
                *v -= 1;
                Ok(*v)
            } else{
                Err(LexerError::MissbalancedSymbol{symbol: *c, open: Lexer::map_balance(&c)}) 
            }
        } else{
            Err(LexerError::MissbalancedSymbol{symbol: *c, open: Lexer::map_balance(&c)})
        }
    }


    fn parsenumber(&mut self, start: char) -> Result<Token, LexerError>{
        let mut seen_dot = false;
        let mut seen_e = false;
        let mut num = start.to_string();

        if start == '.'{
            seen_dot = true;
        }

        loop{
            match self.chars.peek(){
                Some(c) if *c == 'e' || *c == 'E' => {
                }
            }
        }

        /*
          lets say we have a number like this: 10 its a simple number of type INT 
          but now lets have a number like this: 10.5 its a number of type FLOAT
          but now lets have a number like this: 10.5e10 is ALSO a number of type FLOAT
          but now lets have a number like this: .10 IS ALSO A NUMBER OF TYPE FLOAT
         */

    }

    // type transformation from char to TokenType
    pub fn typetransform(&mut self, c: char) -> Result<TokenType, LexerError> {
        match c {
            '(' | '{' | '[' => Ok(TokenType::Punctiation{raw: c, kind: PunctuationKind::Open(self.push(&c))}),
            ')' | '}' | ']' => Ok(TokenType::Punctiation{raw: c, kind: PunctuationKind::Close(self.pop(&c)?)}),
            '0' ..= '9' => self.parsenumber(c),
            _ => Err(LexerError::UnknownToken{token: c.to_string()}),
        }
    }
    // consume a character from the input stream
    fn consume(&mut self) -> Option<char>{
        match self.chars.next(){
            Some(c) => {
                self.cur_column += 1;
                if c == '\n'{
                    self.cur_line += 1;
                    self.cur_column = 1;
                }
                self.codepoint_offset += 1;
                Some(c)
            },
            None => None,
        }
    }
    // skip whitespace
    fn skipwhitespaces(&mut self) {
        while let Some(c) = self.chars.peek() {
            if !c.is_whitespace() {
                break
            }
            self.consume();
        }
    }
    // next token
    pub fn next_token(&mut self) -> Result<TokenType, LexerError>{
        self.skipwhitespaces();

        if let Some(c) = self.consume(){
            self.typetransform(c)
        } else{
            Ok(TokenType::EOF)
        }
        
    }

}
