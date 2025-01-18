import gleam/list

pub fn today(days: List(Int)) -> Int {
  case list.first(days) {
    Ok(count) -> count
    Error(Nil) -> 0
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [today, ..rest] -> [today + 1, ..rest]
    [] -> [1]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  case list.find(days, fn(num_birds) { num_birds == 0 }) {
    Ok(_) -> True
    Error(Nil) -> False
  }
}

pub fn total(days: List(Int)) -> Int {
  list.fold(over: days, from: 0, with: fn(a, b) { a + b })
}

pub fn busy_days(days: List(Int)) -> Int {
  list.count(days, fn(num_birds) { num_birds >= 5 })
}
