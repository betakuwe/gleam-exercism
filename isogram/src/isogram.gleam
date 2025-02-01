import gleam/list
import gleam/set
import gleam/string

pub fn is_isogram(phrase phrase: String) -> Bool {
  let just_letters =
    string.lowercase(phrase)
    |> string.replace(" ", "")
    |> string.replace("-", "")
    |> string.to_graphemes
  set.from_list(just_letters) |> set.size == list.length(just_letters)
}
