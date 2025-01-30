import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}
import gleam/regex.{Match}
import gleam/string

pub fn count_words(input: String) -> Dict(String, Int) {
  let assert Ok(re) = regex.from_string("(?:[a-z0-9]+'?[a-z0-9]+|[a-z0-9]+)")
  regex.scan(re, string.lowercase(input))
  |> list.fold(dict.new(), fn(counts, match) {
    let Match(string, ..) = match
    dict.upsert(counts, string, fn(int_option) {
      case int_option {
        None -> 1
        Some(int) -> int + 1
      }
    })
  })
}
