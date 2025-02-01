pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  keep_loop(list, predicate, [])
}

fn keep_loop(list, predicate, acc) {
  case list {
    [] -> reverse_loop(acc, [])
    [elem, ..rest] ->
      case predicate(elem) {
        True -> [elem, ..acc]
        False -> acc
      }
      |> keep_loop(rest, predicate, _)
  }
}

fn reverse_loop(list, acc) {
  case list {
    [] -> acc
    [elem, ..rest] -> reverse_loop(rest, [elem, ..acc])
  }
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  discard_loop(list, predicate, [])
}

fn discard_loop(list, predicate, acc) {
  case list {
    [] -> reverse_loop(acc, [])
    [elem, ..rest] ->
      case predicate(elem) {
        True -> acc
        False -> [elem, ..acc]
      }
      |> discard_loop(rest, predicate, _)
  }
}
