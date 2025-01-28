import gleam/bool
import gleam/dict
import gleam/list

const ref = [
  ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"],
  ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"],
  ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"],
  ["", "M", "MM", "MMM"],
]

pub fn convert(number: Int) -> String {
  list.index_map(ref, fn(row, order) {
    let order_dict =
      list.index_map(row, fn(roman, digit) { #(digit, roman) })
      |> dict.from_list
    #(order, order_dict)
  })
  |> dict.from_list
  |> convert_loop(number, 0, "")
}

fn convert_loop(ref_dict, number, order, acc) {
  use <- bool.guard(number == 0, acc)
  let assert Ok(order_dict) = dict.get(ref_dict, order)
  let assert Ok(roman) = dict.get(order_dict, number % 10)
  convert_loop(ref_dict, number / 10, order + 1, roman <> acc)
}
