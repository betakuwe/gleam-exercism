import gleam/string

pub fn message(log_line: String) -> String {
  case log_line {
    "[INFO]: " <> message | "[WARNING]: " <> message | "[ERROR]: " <> message ->
      string.trim(message)
    _ -> "Unknown"
  }
}

pub fn log_level(log_line: String) -> String {
  case log_line {
    "[INFO]: " <> _ -> "info"
    "[WARNING]: " <> _ -> "warning"
    "[ERROR]: " <> _ -> "error"
    _ -> "Unknown"
  }
}

pub fn reformat(log_line: String) -> String {
  message(log_line) <> " (" <> log_level(log_line) <> ")"
}
