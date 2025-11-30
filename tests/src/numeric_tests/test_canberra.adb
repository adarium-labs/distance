--  Test cases for Canberra distance function

with AUnit.Assertions;
with Ada.Numerics.Elementary_Functions;
with Distance.Numeric.Signatures;
with Distance.Numeric.Canberra_Generic;

package body Test_Canberra is

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

   function Float_Canberra is new
     Distance.Numeric.Canberra_Generic (Numeric_Ops => Float_Sig, Index_Type => Positive, Vector => Float_Vector);

   ----------
   -- Name --
   ----------

   function Name (T : Test_Case) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Canberra Distance Tests");
   end Name;

   --------------------
   -- Register_Tests --
   --------------------

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Basic_Weighted'Access, "Basic Weighted Distance");
      Register_Routine (T, Test_Zero_Distance'Access, "Zero Distance");
      Register_Routine (T, Test_One_Zero_Value'Access, "One Zero Value");
      Register_Routine (T, Test_Both_Zero_Values'Access, "Both Zero Values");
   end Register_Tests;

   -------------------------
   -- Test_Basic_Weighted --
   -------------------------

   procedure Test_Basic_Weighted (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (1.0, 2.0, 3.0);
      V2       : constant Float_Vector := (2.0, 3.0, 4.0);
      Distance : constant Float := Float_Canberra (V1, V2);
      --  Expected: |1-2|/(1+2) + |2-3|/(2+3) + |3-4|/(3+4)
      --          = 1/3 + 1/5 + 1/7 ≈ 0.676190
   begin
      Assert (abs (Distance - 0.676190) < 0.0001, "Canberra distance should be ~0.676, got" & Float'Image (Distance));
   end Test_Basic_Weighted;

   -----------------------
   -- Test_Zero_Distance --
   -----------------------

   procedure Test_Zero_Distance (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V        : constant Float_Vector := (1.0, 2.0, 3.0, 4.0, 5.0);
      Distance : constant Float := Float_Canberra (V, V);
   begin
      Assert (Distance = 0.0, "Distance from vector to itself should be 0.0, got" & Float'Image (Distance));
   end Test_Zero_Distance;

   ------------------------
   -- Test_One_Zero_Value --
   ------------------------

   procedure Test_One_Zero_Value (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (0.0, 2.0);
      V2       : constant Float_Vector := (1.0, 2.0);
      Distance : constant Float := Float_Canberra (V1, V2);
      --  Expected: |0-1|/(0+1) + |2-2|/(2+2) = 1/1 + 0/4 = 1.0
   begin
      Assert (abs (Distance - 1.0) < 0.0001, "Canberra distance should be 1.0, got" & Float'Image (Distance));
   end Test_One_Zero_Value;

   --------------------------
   -- Test_Both_Zero_Values --
   --------------------------

   procedure Test_Both_Zero_Values (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (0.0, 1.0, 2.0);
      V2       : constant Float_Vector := (0.0, 1.0, 3.0);
      Distance : constant Float := Float_Canberra (V1, V2);
      --  Expected: 0/0 (=0) + |1-1|/(1+1) + |2-3|/(2+3)
      --          = 0 + 0/2 + 1/5 = 0.2
   begin
      Assert (abs (Distance - 0.2) < 0.0001, "Canberra distance should be 0.2, got" & Float'Image (Distance));
   end Test_Both_Zero_Values;

end Test_Canberra;
