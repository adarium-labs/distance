with AUnit.Assertions;
with AUnit.Test_Cases;
with Distance.Textual.Jaro_Winkler;

package body Test_Jaro_Winkler is

   use AUnit.Assertions;

   function String_Jaro_Winkler is new
     Distance.Textual.Jaro_Winkler
       (Index_Type   => Positive,
        Element_Type => Character,
        Text_Type    => String,
        Score_Type   => Long_Float,
        Max_Length   => 32,
        Prefix_Scale => 0.1);

   overriding
   function Name (T : Test_Case) return AUnit.Message_String is
   begin
      return AUnit.Format ("Jaro-Winkler Distance Tests");
   end Name;

   overriding
   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Identical_Strings'Access, "Identical strings");

      Register_Routine (T, Test_Completely_Different'Access, "Completely different strings");

      Register_Routine (T, Test_Prefix_Boost'Access, "Prefix boost behavior");

      Register_Routine (T, Test_Transposition_Sensitivity'Access, "Transposition sensitivity");

      Register_Routine (T, Test_Short_Vs_Longer'Access, "Short vs longer strings");
   end Register_Tests;

   procedure Assert_Approx (Got, Expected, Tolerance : Long_Float; Message : String) is
   begin
      Assert
        (abs (Got - Expected) <= Tolerance,
         Message & " expected" & Long_Float'Image (Expected) & ", got" & Long_Float'Image (Got));
   end Assert_Approx;

   procedure Test_Identical_Strings (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "distance";
      Right  : constant String := "distance";
      Result : constant Long_Float := String_Jaro_Winkler (Left, Right);
   begin
      Assert_Approx
        (Got       => Result,
         Expected  => 1.0,
         Tolerance => 0.000001,
         Message   => "Expected similarity 1.0 for identical " & "strings,");
   end Test_Identical_Strings;

   procedure Test_Completely_Different (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "ABC";
      Right  : constant String := "XYZ";
      Result : constant Long_Float := String_Jaro_Winkler (Left, Right);
   begin
      Assert_Approx
        (Got       => Result,
         Expected  => 0.0,
         Tolerance => 0.000001,
         Message   => "Expected similarity 0.0 for completely different " & "strings,");
   end Test_Completely_Different;

   procedure Test_Prefix_Boost (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left  : constant String := "MARTHA";
      Right : constant String := "MARHTA";
      Score : constant Long_Float := String_Jaro_Winkler (Left, Right);
      Base  : constant Long_Float := String_Jaro_Winkler ("MARTHA", "XARTHA");
   begin
      Assert (Score > Base, "Expected strings sharing a longer common prefix " & "to have higher similarity");
   end Test_Prefix_Boost;

   procedure Test_Transposition_Sensitivity (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "ABCD";
      Right1 : constant String := "ABDC"; -- simple transposition of C and D
      Right2 : constant String := "AXYZ"; -- mostly different
      S1     : constant Long_Float := String_Jaro_Winkler (Left, Right1);
      S2     : constant Long_Float := String_Jaro_Winkler (Left, Right2);
   begin
      Assert (S1 > S2, "Expected simple transposition to yield higher similarity " & "than mostly different strings");
   end Test_Transposition_Sensitivity;

   procedure Test_Short_Vs_Longer (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "AB";
      Right1 : constant String := "ABCD";
      Right2 : constant String := "WXYZ";
      S1     : constant Long_Float := String_Jaro_Winkler (Left, Right1);
      S2     : constant Long_Float := String_Jaro_Winkler (Left, Right2);
   begin
      Assert
        (S1 > S2, "Expected partially matching short/long pair to have higher " & "similarity than unrelated pair");
   end Test_Short_Vs_Longer;

end Test_Jaro_Winkler;
