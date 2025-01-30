pub fn score(x: Float, y: Float) -> Int {
  case x *. x +. y *. y {
    d if d >. 100.0 -> 0
    d if d >. 25.0 -> 1
    d if d >. 1.0 -> 5
    _ -> 10
  }
}
