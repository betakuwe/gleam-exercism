import gleam/list

pub const new_list = list.new

pub fn existing_list() -> List(String) {
  ["Gleam", "Go", "TypeScript"]
}

pub fn add_language(languages: List(String), language: String) -> List(String) {
  [language, ..languages]
}

pub const count_languages = list.length

pub const reverse_list = list.reverse

pub fn exciting_list(languages: List(String)) -> Bool {
  case languages {
    ["Gleam", ..] | [_, "Gleam"] | [_, "Gleam", _] -> True
    _ -> False
  }
}
