import gleam/list
import gleam/string

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  case input, size {
    "", _ -> Error(EmptySeries)
    _, size if size == 0 -> Error(SliceLengthZero)
    _, size if size < 0 -> Error(SliceLengthNegative)
    _, _ ->
      case size > string.length(input) {
        True -> Error(SliceLengthTooLarge)
        False ->
          string.split(input, "")
          |> list.window(size)
          |> list.map(string.join(_, ""))
          |> Ok
      }
  }
}

pub type Error {
  EmptySeries
  SliceLengthNegative
  SliceLengthZero
  SliceLengthTooLarge
}
