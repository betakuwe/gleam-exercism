import gleam/int
import gleam/list
import gleam/string

pub type Color {
  Black
  Brown
  Red
  Orange
  Yellow
  Green
  Blue
  Violet
  Grey
  White
}

pub fn value(colors: List(Color)) -> Result(Int, Nil) {
  case colors {
    [c1, c2, ..] ->
      list.map([c1, c2], fn(color) {
        case color {
          Black -> "0"
          Brown -> "1"
          Red -> "2"
          Orange -> "3"
          Yellow -> "4"
          Green -> "5"
          Blue -> "6"
          Violet -> "7"
          Grey -> "8"
          White -> "9"
        }
      })
      |> string.join("")
      |> int.parse
    _ -> Error(Nil)
  }
}
