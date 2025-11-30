pragma SPARK_Mode (On);

with Distance.Textual.Jaro_Winkler;

procedure Proof_Textual_Jaro_Winkler is
   function String_Jaro_Winkler is new
     Distance.Textual.Jaro_Winkler
       (Index_Type   => Positive,
        Element_Type => Character,
        Text_Type    => String,
        Score_Type   => Long_Float,
        Max_Length   => 32,
        Prefix_Scale => 0.1);
begin
   null;
end Proof_Textual_Jaro_Winkler;
