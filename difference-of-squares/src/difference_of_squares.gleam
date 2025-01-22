pub fn square_of_sum(n: Int) -> Int {
  square_of_sum_loop(n, 0)
}

fn square_of_sum_loop(n, acc) {
  case n <= 0 {
    True -> acc * acc
    False -> square_of_sum_loop(n - 1, acc + n)
  }
}

pub fn sum_of_squares(n: Int) -> Int {
  sum_of_squares_loop(n, 0)
}

fn sum_of_squares_loop(n, acc) {
  case n <= 0 {
    True -> acc
    False -> sum_of_squares_loop(n - 1, acc + n * n)
  }
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
