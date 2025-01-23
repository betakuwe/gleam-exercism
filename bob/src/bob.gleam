import gleam/regex
import gleam/result
import gleam/string

pub fn hey(remark: String) -> String {
  let is_question =
    string.trim_right(remark)
    |> string.last()
    |> result.map(fn(char) { char == "?" })
    |> result.unwrap(False)
  let is_yelling =
    string.uppercase(remark) == remark && string.lowercase(remark) != remark
  let is_silent =
    regex.from_string("^\\s*$")
    |> result.map(regex.check(_, remark))
    |> result.unwrap(False)
  case is_silent, is_question, is_yelling {
    True, _, _ -> "Fine. Be that way!"
    False, True, True -> "Calm down, I know what I'm doing!"
    False, True, False -> "Sure."
    False, False, True -> "Whoa, chill out!"
    _, _, _ -> "Whatever."
  }
}
