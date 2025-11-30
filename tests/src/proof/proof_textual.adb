pragma SPARK_Mode (On);

with Proof_Textual_Hamming;
with Proof_Textual_Levenshtein;
with Proof_Textual_Jaro_Winkler;

procedure Proof_Textual is
begin
   Proof_Textual_Hamming;
   Proof_Textual_Levenshtein;
   Proof_Textual_Jaro_Winkler;
end Proof_Textual;
