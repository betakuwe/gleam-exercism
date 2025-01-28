import gleam/list
import gleam/string

const vals = [
  #("M", 1000),
  #("CM", 900),
  #("D", 500),
  #("CD", 400),
  #("C", 100),
  #("XC", 90),
  #("L", 50),
  #("XL", 40),
  #("X", 10),
  #("IX", 9),
  #("V", 5),
  #("IV", 4),
  #("I", 1),
]

pub fn convert(number: Int) -> String {
  let #(_, romans) =
    list.map_fold(vals, number, fn(number, val_pair) {
      let #(roman, value) = val_pair
      let quotient = number / value
      let remainder = number % value
      #(remainder, string.repeat(roman, quotient))
    })
  string.join(romans, "")
}
