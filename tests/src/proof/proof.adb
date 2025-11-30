pragma SPARK_Mode (On);

with Proof_Numeric_Euclidean;
with Proof_Numeric_Manhattan;
with Proof_Numeric_Minkowski;
with Proof_Numeric_Chebyshev;
with Proof_Numeric_Canberra;
with Proof_Statistical_Cosine_Similarity;
with Proof_Textual_Hamming;
with Proof_Textual_Levenshtein;
with Proof_Textual_Damerau_Levenshtein;
with Proof_Textual_Jaro_Winkler;
with Proof_Textual_Sorensen_Dice;

procedure Proof is
begin
   Proof_Numeric_Euclidean;
   Proof_Numeric_Manhattan;
   Proof_Numeric_Minkowski;
   Proof_Numeric_Chebyshev;
   Proof_Numeric_Canberra;
   Proof_Statistical_Cosine_Similarity;
   Proof_Textual_Hamming;
   Proof_Textual_Levenshtein;
   Proof_Textual_Damerau_Levenshtein;
   Proof_Textual_Jaro_Winkler;
   Proof_Textual_Sorensen_Dice;
end Proof;
