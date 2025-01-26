import gleam/int
import gleam/dict.{type Dict}
import gleam/list
import gleam/regex
import gleam/result
import gleam/string

pub type Forth {
  Forth(stack: List(ForthToken), words: Dict(String, List(ForthToken)))
}

pub type ForthToken {
  ForthInt(Int)
  ForthPlus
  ForthMinus
  ForthTimes
  ForthDivide
  ForthDup
  ForthDrop
  ForthSwap
  ForthOver
  ForthColon
  ForthSemicolon
  ForthWord(String)
}

pub type ForthError {
  DivisionByZero
  StackUnderflow
  InvalidWord
  UnknownWord
}

pub fn new() -> Forth {
  Forth(stack: [], words: dict.new())
}

pub fn format_stack(f: Forth) -> String {
  f.stack
  |> list.reverse
  |> list.filter_map(fn(token) {
    case token {
      ForthInt(int) -> Ok(int.to_string(int))
      _ -> Error(Nil)
    }
  })
  |> string.join(" ")
}

pub fn eval(f: Forth, prog: String) -> Result(Forth, ForthError) {
  let assert Ok(re) = regex.from_string("\\s+")
  string.trim(prog)
  |> regex.split(re, _)
  |> list.try_map(parse_forth)
  |> result.try(push_forth(_, f))
}

fn parse_forth(string: String) -> Result(ForthToken, ForthError) {
  let check_int = case int.parse(string) {
    Ok(int) -> Ok(ForthInt(int))
    Error(_) -> Error(UnknownWord)
  }
  use <- result.lazy_or(check_int)
  case string {
    ":" -> Ok(ForthColon)
    ";" -> Ok(ForthSemicolon)
    _ -> Ok(ForthWord(string.uppercase(string)))
  }
}

fn push_forth(push: List(ForthToken), forth: Forth) -> Result(Forth, ForthError) {
  case push {
    [] -> Ok(forth)
    [token, ..push_rest] ->
      case token, forth.stack {
        ForthInt(_), _ ->
          push_forth(push_rest, Forth(..forth, stack: [token, ..forth.stack]))
        ForthDup, [ForthInt(a), ..] ->
          push_forth(
            push_rest,
            Forth(..forth, stack: [ForthInt(a), ..forth.stack]),
          )
        ForthDrop, [_, ..stack_rest] ->
          push_forth(push_rest, Forth(..forth, stack: stack_rest))
        ForthSwap, [ForthInt(a), ForthInt(b), ..stack_rest] ->
          push_forth(
            push_rest,
            Forth(..forth, stack: [ForthInt(b), ForthInt(a), ..stack_rest]),
          )
        ForthOver, [_, ForthInt(b), ..] ->
          push_forth(
            push_rest,
            Forth(..forth, stack: [ForthInt(b), ..forth.stack]),
          )
        ForthPlus, [ForthInt(a), ForthInt(b), ..stack_rest] ->
          push_forth(
            push_rest,
            Forth(..forth, stack: [ForthInt(b + a), ..stack_rest]),
          )
        ForthMinus, [ForthInt(a), ForthInt(b), ..stack_rest] ->
          push_forth(
            push_rest,
            Forth(..forth, stack: [ForthInt(b - a), ..stack_rest]),
          )
        ForthTimes, [ForthInt(a), ForthInt(b), ..stack_rest] ->
          push_forth(
            push_rest,
            Forth(..forth, stack: [ForthInt(b * a), ..stack_rest]),
          )
        ForthDivide, [ForthInt(a), ForthInt(b), ..stack_rest] ->
          case a {
            0 -> Error(DivisionByZero)
            _ ->
              push_forth(
                push_rest,
                Forth(..forth, stack: [ForthInt(b / a), ..stack_rest]),
              )
          }
        ForthColon, _ -> define_forth_word_start(push_rest, forth)
        ForthSemicolon, _ -> Error(InvalidWord)
        ForthWord(word_string), _ -> {
          case dict.get(forth.words, word_string) {
            Ok(word_definition_reversed) -> {
              push_forth(
                list.concat([word_definition_reversed, push_rest]),
                forth,
              )
            }
            Error(Nil) -> {
              let replace_token_result = string_to_token(word_string)
              use replace_token <- result.try(replace_token_result)
              push_forth([replace_token, ..push_rest], forth)
            }
          }
        }
        _, _ -> Error(StackUnderflow)
      }
  }
}

fn define_forth_word_start(push, forth) {
  case push {
    [] -> Error(InvalidWord)
    [token, ..push_rest] ->
      case token {
        ForthInt(_) | ForthColon -> Error(InvalidWord)
        ForthWord(word) ->
          create_forth_word_definition(push_rest, forth, word, [])
        ForthSemicolon -> push_forth(push_rest, forth)
        _ -> Error(UnknownWord)
      }
  }
}

fn create_forth_word_definition(
  push: List(ForthToken),
  forth: Forth,
  word: String,
  definition_reversed: List(ForthToken),
) -> Result(Forth, ForthError) {
  case push {
    [] -> Error(InvalidWord)
    [token, ..push_rest] ->
      case token {
        ForthSemicolon -> {
          let added_word =
            dict.insert(forth.words, word, list.reverse(definition_reversed))
          push_forth(push_rest, Forth(..forth, words: added_word))
        }
        ForthColon -> Error(InvalidWord)
        ForthWord(token_word) ->
          case dict.get(forth.words, token_word) {
            Ok(word_definition) ->
              list.concat([word_definition, definition_reversed])
              |> create_forth_word_definition(push_rest, forth, word, _)
            Error(Nil) -> {
              let replace_token_result = string_to_token(token_word)
              use replace_token <- result.try(replace_token_result)
              create_forth_word_definition(push_rest, forth, word, [
                replace_token,
                ..definition_reversed
              ])
            }
          }
        _ ->
          create_forth_word_definition(push_rest, forth, word, [
            token,
            ..definition_reversed
          ])
      }
  }
}

fn string_to_token(string) {
  case string {
    "DUP" -> Ok(ForthDup)
    "DROP" -> Ok(ForthDrop)
    "SWAP" -> Ok(ForthSwap)
    "OVER" -> Ok(ForthOver)
    "+" -> Ok(ForthPlus)
    "-" -> Ok(ForthMinus)
    "*" -> Ok(ForthTimes)
    "/" -> Ok(ForthDivide)
    _ -> Error(UnknownWord)
  }
}
