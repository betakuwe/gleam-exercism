import gleam/int
import gleam/list
import gleam/string

const divs = [#(3, "Pling"), #(5, "Plang"), #(7, "Plong")]

pub fn convert(number: Int) -> String {
  let words =
    list.filter_map(divs, fn(pair) {
      let #(num, word) = pair
      case number % num == 0 {
        True -> Ok(word)
        False -> Error(Nil)
      }
    })
  case words {
    [] -> int.to_string(number)
    _ -> string.join(words, "")
  }
}
