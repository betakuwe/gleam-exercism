import gleam/dict
import gleam/function
import gleam/list
import gleam/string

pub fn is_isogram(phrase phrase: String) -> Bool {
  let just_letters =
    string.lowercase(phrase)
    |> string.replace(" ", "")
    |> string.replace("-", "")
    |> string.to_graphemes
  list.group(just_letters, function.identity)
  |> dict.size
  == list.length(just_letters)
}
