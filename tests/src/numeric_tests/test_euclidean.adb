--  Test cases for Euclidean distance function

with AUnit.Assertions;
with Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Long_Elementary_Functions;
with Distance.Numeric.Signatures;
with Distance.Numeric.Euclidean_Generic;

package body Test_Euclidean is

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

   function Float_Euclidean is new
     Distance.Numeric.Euclidean_Generic (Numeric_Ops => Float_Sig, Index_Type => Positive, Vector => Float_Vector);

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

   function Long_Float_Euclidean is new
     Distance.Numeric.Euclidean_Generic
       (Numeric_Ops => Long_Float_Sig,
        Index_Type  => Positive,
        Vector      => Long_Float_Vector);

   ----------
   -- Name --
   ----------

   function Name (T : Test_Case) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Euclidean Distance Tests");
   end Name;

   --------------------
   -- Register_Tests --
   --------------------

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_3_4_5_Triangle'Access, "3-4-5 Triangle");
      Register_Routine (T, Test_Zero_Distance'Access, "Zero Distance");
      Register_Routine (T, Test_High_Dimensional'Access, "High Dimensional");
      Register_Routine (T, Test_Long_Float_Instantiation'Access, "Long_Float Instantiation");
   end Register_Tests;

   -------------------------
   -- Test_3_4_5_Triangle --
   -------------------------

   procedure Test_3_4_5_Triangle (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (0.0, 0.0, 0.0);
      V2       : constant Float_Vector := (3.0, 4.0, 0.0);
      Distance : constant Float := Float_Euclidean (V1, V2);
   begin
      Assert (abs (Distance - 5.0) < 0.0001, "3-4-5 triangle distance should be 5.0, got" & Float'Image (Distance));
   end Test_3_4_5_Triangle;

   -----------------------
   -- Test_Zero_Distance --
   -----------------------

   procedure Test_Zero_Distance (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V        : constant Float_Vector := (1.0, 2.0, 3.0, 4.0, 5.0);
      Distance : constant Float := Float_Euclidean (V, V);
   begin
      Assert (Distance = 0.0, "Distance from vector to itself should be 0.0, got" & Float'Image (Distance));
   end Test_Zero_Distance;

   ---------------------------
   -- Test_High_Dimensional --
   ---------------------------

   procedure Test_High_Dimensional (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      --  10-dimensional vectors
      V1       : constant Float_Vector (1 .. 10) := (others => 0.0);
      V2       : constant Float_Vector (1 .. 10) := (others => 1.0);
      Distance : constant Float := Float_Euclidean (V1, V2);
      Expected : constant Float := 3.162278;  --  sqrt(10) ≈ 3.162278
   begin
      Assert
        (abs (Distance - Expected) < 0.0001, "10D unit distance should be sqrt(10), got" & Float'Image (Distance));
   end Test_High_Dimensional;

   ------------------------------------
   -- Test_Long_Float_Instantiation --
   ------------------------------------

   procedure Test_Long_Float_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Long_Float_Vector := (0.0, 0.0);
      V2       : constant Long_Float_Vector := (1.0, 1.0);
      Distance : constant Long_Float := Long_Float_Euclidean (V1, V2);
      Expected : constant Long_Float := 1.414214;  --  sqrt(2) ≈ 1.414214
   begin
      Assert
        (abs (Distance - Expected) < 0.0001, "2D unit diagonal should be sqrt(2), got" & Long_Float'Image (Distance));
   end Test_Long_Float_Instantiation;

end Test_Euclidean;
