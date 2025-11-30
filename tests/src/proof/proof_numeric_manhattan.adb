pragma SPARK_Mode (On);

with Ada.Numerics.Elementary_Functions;
with Distance.Numeric.Signatures;
with Distance.Numeric.Manhattan_Generic;

procedure Proof_Numeric_Manhattan is
   type Float_Vector is array (Positive range <>) of Float;

   package Float_Sig is new
     Distance.Numeric.Signatures
       (Element_Type => Float,
        Zero         => 0.0,
        One          => 1.0,
        Sqrt         => Ada.Numerics.Elementary_Functions.Sqrt,
        "**"         => Ada.Numerics.Elementary_Functions."**",
        Max_Element  => Float'Last);

   function Float_Manhattan is new
     Distance.Numeric.Manhattan_Generic (Numeric_Ops => Float_Sig, Index_Type => Positive, Vector => Float_Vector);
begin
   null;
end Proof_Numeric_Manhattan;
