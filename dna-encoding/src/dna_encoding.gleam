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
  use encoded_dna, nucleotide <- list.fold(dna, <<>>)
  <<encoded_dna:bits, encode_nucleotide(nucleotide):2>>
}

pub fn decode(dna: BitArray) -> Result(List(Nucleotide), Nil) {
  decode_loop(dna, [])
}

fn decode_loop(dna, nucleotide_list) {
  case dna {
    <<>> -> Ok(list.reverse(nucleotide_list))
    <<nucleotide_bits:2, dna_rest:bits>> -> {
      use nucleotide <- result.try(decode_nucleotide(nucleotide_bits))
      decode_loop(dna_rest, [nucleotide, ..nucleotide_list])
    }
    _ -> Error(Nil)
  }
}
