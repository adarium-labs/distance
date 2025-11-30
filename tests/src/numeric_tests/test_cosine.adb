--  Test cases for Cosine similarity function

with AUnit.Assertions;
with Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Long_Elementary_Functions;
with Distance.Numeric.Signatures;
with Distance.Statistical.Cosine_Similarity_Generic;

package body Test_Cosine is

   use AUnit.Assertions;

   --  Float instantiation via signatures
   type Float_Vector is array (Positive range <>) of Float;

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

   --  Long_Float instantiation via signatures
   type Long_Float_Vector is array (Positive range <>) of Long_Float;

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

   ----------
   -- Name --
   ----------

   function Name (T : Test_Case) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Cosine Similarity Tests");
   end Name;

   --------------------
   -- Register_Tests --
   --------------------

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Aligned_Vectors'Access, "Aligned vectors");
      Register_Routine (T, Test_Opposite_Vectors'Access, "Opposite vectors");
      Register_Routine (T, Test_Orthogonal_Vectors'Access, "Orthogonal vectors");
      Register_Routine (T, Test_Non_Trivial_Angle'Access, "Non-trivial angle");
      Register_Routine (T, Test_Long_Float_Instantiation'Access, "Long_Float instantiation");
   end Register_Tests;

   -------------------------
   -- Test_Aligned_Vectors --
   -------------------------

   procedure Test_Aligned_Vectors (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (1.0, 0.0);
      V2       : constant Float_Vector := (2.0, 0.0);
      Similar  : constant Float := Float_Cosine (V1, V2);
      Expected : constant Float := 1.0;
   begin
      Assert
        (abs (Similar - Expected) < 0.0001, "Aligned vectors should have cosine 1.0, got" & Float'Image (Similar));
   end Test_Aligned_Vectors;

   ---------------------------
   -- Test_Opposite_Vectors --
   ---------------------------

   procedure Test_Opposite_Vectors (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (1.0, 0.0);
      V2       : constant Float_Vector := (-2.0, 0.0);
      Similar  : constant Float := Float_Cosine (V1, V2);
      Expected : constant Float := -1.0;
   begin
      Assert
        (abs (Similar - Expected) < 0.0001, "Opposite vectors should have cosine -1.0, got" & Float'Image (Similar));
   end Test_Opposite_Vectors;

   ---------------------------
   -- Test_Orthogonal_Vectors --
   ---------------------------

   procedure Test_Orthogonal_Vectors (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1      : constant Float_Vector := (1.0, 0.0);
      V2      : constant Float_Vector := (0.0, 1.0);
      Similar : constant Float := Float_Cosine (V1, V2);
   begin
      Assert (abs (Similar) < 0.0001, "Orthogonal vectors should have cosine 0.0, got" & Float'Image (Similar));
   end Test_Orthogonal_Vectors;

   ---------------------------
   -- Test_Non_Trivial_Angle --
   ---------------------------

   procedure Test_Non_Trivial_Angle (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (1.0, 0.0);
      V2       : constant Float_Vector := (1.0, 1.0);
      Similar  : constant Float := Float_Cosine (V1, V2);
      Expected : constant Float := 0.707106;  --  cos(45 degrees)
   begin
      Assert
        (abs (Similar - Expected) < 0.0001,
         "45-degree vectors should have cosine ~0.7071, got" & Float'Image (Similar));
   end Test_Non_Trivial_Angle;

   ------------------------------------
   -- Test_Long_Float_Instantiation --
   ------------------------------------

   procedure Test_Long_Float_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Long_Float_Vector := (1.0, 0.0);
      V2       : constant Long_Float_Vector := (2.0, 0.0);
      Similar  : constant Long_Float := Long_Float_Cosine (V1, V2);
      Expected : constant Long_Float := 1.0;
   begin
      Assert
        (abs (Similar - Expected) < 0.0001,
         "Aligned Long_Float vectors should have cosine 1.0, got" & Long_Float'Image (Similar));
   end Test_Long_Float_Instantiation;

end Test_Cosine;
