import gleam/list.{Continue, Stop}
import gleam/result
import gleam/string

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  string.to_graphemes(rna)
  |> list.sized_chunk(3)
  |> list.fold_until(Ok([]), fn(polypeptides_result, chunk) {
    case polypeptides_result {
      Error(_) -> Stop(Error(Nil))
      Ok(polypeptides) ->
        case string.join(chunk, "") {
          "AUG" -> Continue(Ok(["Methionine", ..polypeptides]))
          "UUU" | "UUC" -> Continue(Ok(["Phenylalanine", ..polypeptides]))
          "UUA" | "UUG" -> Continue(Ok(["Leucine", ..polypeptides]))
          "UCU" | "UCC" | "UCA" | "UCG" ->
            Continue(Ok(["Serine", ..polypeptides]))
          "UAU" | "UAC" -> Continue(Ok(["Tyrosine", ..polypeptides]))
          "UGU" | "UGC" -> Continue(Ok(["Cysteine", ..polypeptides]))
          "UGG" -> Continue(Ok(["Tryptophan", ..polypeptides]))
          "UAA" | "UAG" | "UGA" -> Stop(Ok(polypeptides))
          _ -> Stop(Error(Nil))
        }
    }
  })
  |> result.map(list.reverse)
}
