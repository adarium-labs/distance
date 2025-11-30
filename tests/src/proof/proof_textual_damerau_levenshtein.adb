pragma SPARK_Mode (On);

with Distance.Textual.Damerau_Levenshtein;

procedure Proof_Textual_Damerau_Levenshtein is
   function String_Damerau_Levenshtein is new
     Distance.Textual.Damerau_Levenshtein (Positive, Character, String, Max_Length => 32);
begin
   null;
end Proof_Textual_Damerau_Levenshtein;
