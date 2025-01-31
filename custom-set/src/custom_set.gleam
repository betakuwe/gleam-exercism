import gleam/dict.{type Dict}
import gleam/list

pub opaque type Set(t) {
  Set(internal: Dict(t, Bool))
}

pub fn new(members: List(t)) -> Set(t) {
  members
  |> list.map(fn(member) { #(member, True) })
  |> dict.from_list
  |> Set
}

pub fn is_empty(set: Set(t)) -> Bool {
  dict.is_empty(set.internal)
}

pub fn contains(in set: Set(t), this member: t) -> Bool {
  dict.has_key(set.internal, member)
}

pub fn is_subset(first: Set(t), of second: Set(t)) -> Bool {
  dict.keys(first.internal) |> list.all(contains(second, _))
}

pub fn size(set: Set(t)) -> Int {
  dict.size(set.internal)
}

pub fn disjoint(first: Set(t), second: Set(t)) -> Bool {
  case size(first) > size(second) {
    True -> disjoint(second, first)
    False ->
      dict.keys(first.internal)
      |> list.all(fn(key) { !contains(second, key) })
  }
}

pub fn is_equal(first: Set(t), to second: Set(t)) -> Bool {
  first.internal == second.internal
}

pub fn add(to set: Set(t), this member: t) -> Set(t) {
  dict.insert(set.internal, member, True) |> Set
}

pub fn intersection(of first: Set(t), and second: Set(t)) -> Set(t) {
  case size(first) > size(second) {
    True -> intersection(second, first)
    False ->
      dict.filter(first.internal, fn(key, _) { contains(second, key) }) |> Set
  }
}

pub fn difference(between first: Set(t), and second: Set(t)) -> Set(t) {
  dict.filter(first.internal, fn(key, _) { !contains(second, key) }) |> Set
}

pub fn union(of first: Set(t), and second: Set(t)) -> Set(t) {
  dict.merge(first.internal, second.internal) |> Set
}
