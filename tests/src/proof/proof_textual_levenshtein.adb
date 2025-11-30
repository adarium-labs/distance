pragma SPARK_Mode (On);

with Distance.Textual.Levenshtein;

procedure Proof_Textual_Levenshtein is
   function String_Levenshtein is new Distance.Textual.Levenshtein (Positive, Character, String, Max_Length => 32);
begin
   null;
end Proof_Textual_Levenshtein;
