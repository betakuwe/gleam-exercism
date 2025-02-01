import gleam/bool
import gleam/list
import gleam/regex
import gleam/string

pub fn clean(input: String) -> Result(String, String) {
  let assert Ok(have_letters) = regex.from_string("[a-zA-Z]")
  use <- bool.guard(
    regex.check(have_letters, input),
    Error("letters not permitted"),
  )
  let assert Ok(valid_symbols) = regex.from_string("^[0-9- ().+]+$")
  use <- bool.guard(
    !regex.check(valid_symbols, input),
    Error("punctuations not permitted"),
  )
  let assert Ok(digit_regex) = regex.from_string("\\d")
  let digits =
    regex.scan(digit_regex, input)
    |> list.map(fn(match) { match.content })
    |> string.join("")
  let num_digits = string.length(digits)
  use <- bool.guard(num_digits < 10, Error("must not be fewer than 10 digits"))
  use <- bool.guard(
    num_digits > 11,
    Error("must not be greater than 11 digits"),
  )
  use <- bool.guard(
    num_digits == 11 && !string.starts_with(digits, "1"),
    Error("11 digits must start with 1"),
  )
  let ten_digits = case num_digits {
    11 -> string.drop_left(digits, 1)
    _ -> digits
  }
  use <- bool.guard(
    string.starts_with(ten_digits, "0"),
    Error("area code cannot start with zero"),
  )
  use <- bool.guard(
    string.starts_with(ten_digits, "1"),
    Error("area code cannot start with one"),
  )
  let seven_digits = string.drop_left(ten_digits, 3)
  use <- bool.guard(
    string.starts_with(seven_digits, "0"),
    Error("exchange code cannot start with zero"),
  )
  use <- bool.guard(
    string.starts_with(seven_digits, "1"),
    Error("exchange code cannot start with one"),
  )
  Ok(ten_digits)
}
