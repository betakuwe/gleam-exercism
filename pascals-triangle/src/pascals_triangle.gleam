import gleam/list

pub fn rows(n: Int) -> List(List(Int)) {
  rows_loop(n, [])
}

fn rows_loop(n, acc) {
  case n <= 0 {
    True -> list.reverse(acc)
    False -> {
      let row = case acc {
        [] -> [1]
        [prev, ..] -> row_loop(prev, [1])
      }
      rows_loop(n - 1, [row, ..acc])
    }
  }
}

fn row_loop(prev, acc) {
  case prev {
    [a, b, ..rest] -> row_loop([b, ..rest], [a + b, ..acc])
    [a, ..rest] -> row_loop(rest, [a, ..acc])
    [] -> acc
  }
}
