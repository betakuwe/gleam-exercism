pub fn is_leap_year(year: Int) -> Bool {
  let divisible_by_4 = year % 4 == 0
  let divisible_by_100 = year % 100 == 0
  let divisible_by_400 = year % 400 == 0
  case divisible_by_4, divisible_by_100, divisible_by_400 {
    True, False, _ | _, _, True -> True
    _, _, _ -> False
  }
}
