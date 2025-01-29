import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/result

pub fn can_chain(chain: List(#(Int, Int))) -> Bool {
  case chain {
    [] -> True
    _ -> {
      let graph =
        list.fold(chain, dict.new(), fn(graph, edge) {
          let #(from, to) = edge
          dict.upsert(graph, from, increment_graph(_, to))
          |> dict.upsert(to, increment_graph(_, from))
        })
      let assert [root, ..] = dict.keys(graph)
      can_euler_walk(graph, Some(root), [root])
    }
  }
}

fn increment_graph(maybe_nodes, node) {
  let nodes = option.unwrap(maybe_nodes, dict.new())
  use maybe_count <- dict.upsert(nodes, node)
  option.unwrap(maybe_count, 0) + 1
}

fn decrement_graph(maybe_nodes, node) {
  let nodes = option.unwrap(maybe_nodes, dict.new())
  case dict.get(nodes, node) {
    Error(_) -> nodes
    Ok(count) ->
      case count {
        1 -> dict.delete(nodes, node)
        _ -> dict.insert(nodes, node, count - 1)
      }
  }
}

fn can_euler_walk(graph, maybe_root, path) {
  case path {
    [] ->
      case maybe_root {
        Some(_) -> False
        None -> dict.values(graph) |> list.all(dict.is_empty)
      }
    [from, ..rest] -> {
      let to_result =
        dict.get(graph, from)
        |> result.try(fn(tos_dict) { dict.keys(tos_dict) |> list.first })
      case maybe_root, to_result {
        _, Ok(to) -> {
          let graph =
            dict.upsert(graph, from, decrement_graph(_, to))
            |> dict.upsert(to, decrement_graph(_, from))
          let maybe_root = option.or(maybe_root, Some(from))
          let path = [to, ..path]
          can_euler_walk(graph, maybe_root, path)
        }
        Some(root), _ if root != from -> False
        _, _ -> can_euler_walk(graph, None, rest)
      }
    }
  }
}
