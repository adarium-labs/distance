--  Test cases for Minkowski distance function

with AUnit.Assertions;
with Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Long_Elementary_Functions;
with Distance.Numeric.Signatures;
with Distance.Numeric.Minkowski_Generic;

package body Test_Minkowski is

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

   function Float_Minkowski is new
     Distance.Numeric.Minkowski_Generic
       (Numeric_Ops => Float_Sig,
        Index_Type  => Positive,
        Vector      => Float_Vector,
        Log         => Ada.Numerics.Elementary_Functions.Log,
        Exp         => Ada.Numerics.Elementary_Functions.Exp);

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

   function Long_Float_Minkowski is new
     Distance.Numeric.Minkowski_Generic
       (Numeric_Ops => Long_Float_Sig,
        Index_Type  => Positive,
        Vector      => Long_Float_Vector,
        Log         => Ada.Numerics.Long_Elementary_Functions.Log,
        Exp         => Ada.Numerics.Long_Elementary_Functions.Exp);

   ----------
   -- Name --
   ----------

   function Name (T : Test_Case) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Minkowski Distance Tests");
   end Name;

   --------------------
   -- Register_Tests --
   --------------------

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_P1_Equals_Manhattan'Access, "P=1 equals Manhattan distance");
      Register_Routine (T, Test_P2_Equals_Euclidean'Access, "P=2 equals Euclidean distance");
      Register_Routine (T, Test_Non_Integral_P'Access, "Non-integral P example");
      Register_Routine (T, Test_Zero_Distance'Access, "Zero distance");
      Register_Routine (T, Test_Long_Float_Instantiation'Access, "Long_Float instantiation");
   end Register_Tests;

   ------------------------------
   -- Test_P1_Equals_Manhattan --
   ------------------------------

   procedure Test_P1_Equals_Manhattan (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (0.0, 0.0);
      V2       : constant Float_Vector := (3.0, 4.0);
      P        : constant Float := 1.0;
      Distance : constant Float := Float_Minkowski (V1, V2, P);
      Expected : constant Float := 7.0;
   begin
      Assert
        (abs (Distance - Expected) < 0.0001,
         "Minkowski P=1 should match Manhattan distance 7.0, got" & Float'Image (Distance));
   end Test_P1_Equals_Manhattan;

   -----------------------------
   -- Test_P2_Equals_Euclidean --
   -----------------------------

   procedure Test_P2_Equals_Euclidean (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (0.0, 0.0, 0.0);
      V2       : constant Float_Vector := (3.0, 4.0, 0.0);
      P        : constant Float := 2.0;
      Distance : constant Float := Float_Minkowski (V1, V2, P);
      Expected : constant Float := 5.0;
   begin
      Assert
        (abs (Distance - Expected) < 0.0001,
         "Minkowski P=2 should match Euclidean distance 5.0, got" & Float'Image (Distance));
   end Test_P2_Equals_Euclidean;

   -------------------------
   -- Test_Non_Integral_P --
   -------------------------

   procedure Test_Non_Integral_P (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Float_Vector := (0.0, 0.0);
      V2       : constant Float_Vector := (3.0, 4.0);
      P        : constant Float := 3.0;
      Distance : constant Float := Float_Minkowski (V1, V2, P);
      Expected : constant Float := 4.49794;  --  Approximate (|3|^3 + |4|^3)^(1/3)
   begin
      Assert
        (abs (Distance - Expected) < 0.001,
         "Minkowski P=3 should be approximately 4.49794, got" & Float'Image (Distance));
   end Test_Non_Integral_P;

   -----------------------
   -- Test_Zero_Distance --
   -----------------------

   procedure Test_Zero_Distance (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V        : constant Float_Vector := (1.0, 2.0, 3.0, 4.0, 5.0);
      P        : constant Float := 2.0;
      Distance : constant Float := Float_Minkowski (V, V, P);
   begin
      Assert (Distance = 0.0, "Distance from vector to itself should be 0.0, got" & Float'Image (Distance));
   end Test_Zero_Distance;

   ------------------------------------
   -- Test_Long_Float_Instantiation --
   ------------------------------------

   procedure Test_Long_Float_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      V1       : constant Long_Float_Vector := (0.0, 0.0);
      V2       : constant Long_Float_Vector := (1.0, 1.0);
      P        : constant Long_Float := 2.0;
      Distance : constant Long_Float := Long_Float_Minkowski (V1, V2, P);
      Expected : constant Long_Float := 1.414214;  --  Approximate sqrt(2)
   begin
      Assert
        (abs (Distance - Expected) < 0.0001,
         "Long_Float Minkowski P=2 for unit diagonal should be sqrt(2), got" & Long_Float'Image (Distance));
   end Test_Long_Float_Instantiation;

end Test_Minkowski;
