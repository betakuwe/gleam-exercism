import gleam/dict
import gleam/list.{Continue, Stop}
import gleam/result
import gleam/string

const ref = [
  #("AUG", "Methionine"),
  #("UUU", "Phenylalanine"),
  #("UUC", "Phenylalanine"),
  #("UUA", "Leucine"),
  #("UUG", "Leucine"),
  #("UCU", "Serine"),
  #("UCC", "Serine"),
  #("UCA", "Serine"),
  #("UCG", "Serine"),
  #("UAU", "Tyrosine"),
  #("UAC", "Tyrosine"),
  #("UGU", "Cysteine"),
  #("UGC", "Cysteine"),
  #("UGG", "Tryptophan"),
  #("UAA", "STOP"),
  #("UAG", "STOP"),
  #("UGA", "STOP"),
]

pub fn proteins(rna: String) -> Result(List(String), Nil) {
  let ref_dict = dict.from_list(ref)
  string.to_graphemes(rna)
  |> list.sized_chunk(3)
  |> list.fold_until(Ok([]), fn(result, chunk) {
    result.map(result, fn(result_list) {
      let rna = string.join(chunk, "")
      case dict.get(ref_dict, rna) {
        Error(_) -> Stop(Error(Nil))
        Ok("STOP") -> Stop(Ok(result_list))
        Ok(polypeptide) -> Continue(Ok([polypeptide, ..result_list]))
      }
    })
    |> result.unwrap(Stop(Error(Nil)))
  })
  |> result.map(list.reverse)
}
