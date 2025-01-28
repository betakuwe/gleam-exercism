import gleam/list
import gleam/string

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  let word_lower = string.lowercase(word)
  let sorted_word = sort_word(word_lower)
  candidates
  |> list.filter(fn(candidate) {
    let candidate_lower = string.lowercase(candidate)
    candidate_lower != word_lower && sort_word(candidate_lower) == sorted_word
  })
}

fn sort_word(word) {
  string.to_graphemes(word)
  |> list.sort(string.compare)
  |> string.join("")
}
