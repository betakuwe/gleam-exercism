import gleam/list
import gleam/string

pub fn build(letter: String) -> String {
  let assert [letter_code] = string.to_utf_codepoints(letter)
  let letter_int = string.utf_codepoint_to_int(letter_code)
  let half_length = letter_int - 65
  let assert [_, ..rest] as indices = list.range(half_length, 0)
  [list.reverse(rest), indices]
  |> list.concat
  |> list.map(build_line(_, half_length))
  |> string.join("\n")
}

fn build_line(index, half_length) {
  case index {
    0 -> {
      let spaces = string.repeat(" ", half_length)
      spaces <> "A" <> spaces
    }
    _ -> {
      let assert Ok(letter_codepoint) = index + 65 |> string.utf_codepoint
      let letter = string.from_utf_codepoints([letter_codepoint])
      let assert [_, ..rest] as right_half =
        [
          list.repeat(" ", index),
          [letter],
          list.repeat(" ", half_length - index),
        ]
        |> list.concat
      [list.reverse(rest), right_half]
      |> list.concat
      |> string.join("")
    }
  }
}
