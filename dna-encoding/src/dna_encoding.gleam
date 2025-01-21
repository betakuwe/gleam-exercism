import gleam/iterator.{Done, Next}
import gleam/list
import gleam/result

pub type Nucleotide {
  Adenine
  Cytosine
  Guanine
  Thymine
}

pub fn encode_nucleotide(nucleotide: Nucleotide) -> Int {
  case nucleotide {
    Adenine -> 0b00
    Cytosine -> 0b01
    Guanine -> 0b10
    Thymine -> 0b11
  }
}

pub fn decode_nucleotide(nucleotide: Int) -> Result(Nucleotide, Nil) {
  case nucleotide {
    0b00 -> Ok(Adenine)
    0b01 -> Ok(Cytosine)
    0b10 -> Ok(Guanine)
    0b11 -> Ok(Thymine)
    _ -> Error(Nil)
  }
}

pub fn encode(dna: List(Nucleotide)) -> BitArray {
  list.fold(over: dna, from: <<>>, with: fn(encoded_dna, nucleotide) {
    <<encoded_dna:bits, encode_nucleotide(nucleotide):2>>
  })
}

pub fn decode(dna: BitArray) -> Result(List(Nucleotide), Nil) {
  iterator.unfold(Ok(dna), fn(remaining_dna) {
    case remaining_dna {
      Ok(<<>>) -> Done
      Ok(<<nucleotide:2, rest:bits>>) ->
        Next(decode_nucleotide(nucleotide), Ok(rest))
      Ok(_) -> Next(Error(Nil), Error(Nil))
      Error(Nil) -> Done
    }
  })
  |> iterator.to_list
  |> result.all
}
