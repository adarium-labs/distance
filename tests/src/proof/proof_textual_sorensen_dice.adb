pragma SPARK_Mode (On);

with Distance.Textual.Sorensen_Dice;

procedure Proof_Textual_Sorensen_Dice is
   function String_Sorensen_Dice is new Distance.Textual.Sorensen_Dice (Positive, Character, String, Max_Length => 32);
begin
   null;
end Proof_Textual_Sorensen_Dice;
