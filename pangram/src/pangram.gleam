import gleam/list
import gleam/set
import gleam/string

const letters = [
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
  "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
]

pub fn is_pangram(sentence: String) -> Bool {
  let sentence_letters =
    string.lowercase(sentence)
    |> string.to_graphemes
    |> set.from_list
  list.all(letters, set.contains(sentence_letters, _))
}
