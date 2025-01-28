import gleam/list
import gleam/set
import gleam/string

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  let word_lower = string.lowercase(word)
  let anagrams =
    word_lower
    |> string.split("")
    |> list.permutations()
    |> list.map(string.join(_, ""))
    |> set.from_list
    |> set.drop([word_lower])
  candidates
  |> list.map(fn(candidate) { #(candidate, string.lowercase(candidate)) })
  |> list.filter_map(fn(candidate_pair) {
    let #(original_candidate, lowered_candidate) = candidate_pair
    case set.contains(anagrams, lowered_candidate) {
      True -> Ok(original_candidate)
      False -> Error(Nil)
    }
  })
}
