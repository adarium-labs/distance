pragma SPARK_Mode (On);

with Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Long_Elementary_Functions;
with Distance.Numeric.Signatures;
with Distance.Statistical.Cosine_Similarity_Generic;

procedure Proof_Statistical_Cosine_Similarity is
   type Float_Vector is array (Positive range <>) of Float;
   type Long_Float_Vector is array (Positive range <>) of Long_Float;

   package Float_Sig is new
     Distance.Numeric.Signatures
       (Element_Type => Float,
        Zero         => 0.0,
        One          => 1.0,
        Sqrt         => Ada.Numerics.Elementary_Functions.Sqrt,
        "**"         => Ada.Numerics.Elementary_Functions."**",
        Max_Element  => Float'Last);

   function Float_Cosine is new
     Distance.Statistical.Cosine_Similarity_Generic
       (Numeric_Ops => Float_Sig,
        Index_Type  => Positive,
        Vector      => Float_Vector);

   package Long_Float_Sig is new
     Distance.Numeric.Signatures
       (Element_Type => Long_Float,
        Zero         => 0.0,
        One          => 1.0,
        Sqrt         => Ada.Numerics.Long_Elementary_Functions.Sqrt,
        "**"         => Ada.Numerics.Long_Elementary_Functions."**",
        Max_Element  => Long_Float'Last);

   function Long_Float_Cosine is new
     Distance.Statistical.Cosine_Similarity_Generic
       (Numeric_Ops => Long_Float_Sig,
        Index_Type  => Positive,
        Vector      => Long_Float_Vector);
begin
   null;
end Proof_Statistical_Cosine_Similarity;
