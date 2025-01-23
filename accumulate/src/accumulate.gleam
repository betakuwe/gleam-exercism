import gleam/list

pub fn accumulate(list: List(a), fun: fn(a) -> b) -> List(b) {
  nanana(list, fun, [])
}

fn nanana(list, fun, acc) {
  case list {
    [] -> list.reverse(acc)
    [wut, ..heh] -> nanana(heh, fun, [fun(wut), ..acc])
  }
}
