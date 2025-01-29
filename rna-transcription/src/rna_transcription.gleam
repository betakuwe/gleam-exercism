import gleam/list
import gleam/result
import gleam/string

pub fn to_rna(dna: String) -> Result(String, Nil) {
  string.to_graphemes(dna)
  |> list.try_fold("", fn(rna, dna_nucleotide) {
    case dna_nucleotide {
      "G" -> Ok("C")
      "C" -> Ok("G")
      "T" -> Ok("A")
      "A" -> Ok("U")
      _ -> Error(Nil)
    }
    |> result.map(fn(rna_nucleotide) { rna <> rna_nucleotide })
  })
}
