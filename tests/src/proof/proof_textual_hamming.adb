pragma SPARK_Mode (On);

with Distance.Textual.Hamming;

procedure Proof_Textual_Hamming is
   function String_Hamming is new Distance.Textual.Hamming (Positive, Character, String);
begin
   null;
end Proof_Textual_Hamming;
