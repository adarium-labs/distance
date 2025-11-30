with AUnit.Assertions;
with AUnit.Test_Cases;
with Distance.Textual.Sorensen_Dice;

package body Test_Sorensen_Dice is

   use AUnit.Assertions;

   function String_Sorensen_Dice is new Distance.Textual.Sorensen_Dice (Positive, Character, String, Max_Length => 32);

   overriding
   function Name (T : Test_Case) return AUnit.Message_String is
   begin
      return AUnit.Format ("Sorensen-Dice Coefficient Tests");
   end Name;

   overriding
   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Identical_Strings'Access, "Identical strings");
      Register_Routine (T, Test_Completely_Different'Access, "Completely different");
      Register_Routine (T, Test_Partial_Overlap'Access, "Partial overlap");
      Register_Routine (T, Test_Short_Strings'Access, "Short strings");
      Register_Routine (T, Test_Empty_Strings'Access, "Empty strings");
   end Register_Tests;

   procedure Test_Identical_Strings (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "distance";
      Right  : constant String := "distance";
      Result : constant Float := String_Sorensen_Dice (Left, Right);
   begin
      Assert
        (abs (Result - 1.0) < 0.0001, "Expected coefficient 1.0 for identical strings, got" & Float'Image (Result));
   end Test_Identical_Strings;

   procedure Test_Completely_Different (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "abc";
      Right  : constant String := "xyz";
      Result : constant Float := String_Sorensen_Dice (Left, Right);
      --  Bigrams Left:  {ab, bc}
      --  Bigrams Right: {xy, yz}
      --  Intersection: {} (empty)
      --  Coefficient = 2 * 0 / (2 + 2) = 0.0
   begin
      Assert
        (abs (Result - 0.0) < 0.0001,
         "Expected coefficient 0.0 for completely different strings, got" & Float'Image (Result));
   end Test_Completely_Different;

   procedure Test_Partial_Overlap (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "night";
      Right  : constant String := "nacht";
      Result : constant Float := String_Sorensen_Dice (Left, Right);
      --  Bigrams Left:  {ni, ig, gh, ht}
      --  Bigrams Right: {na, ac, ch, ht}
      --  Intersection: {ht}
      --  Coefficient = 2 * 1 / (4 + 4) = 0.25
   begin
      Assert (abs (Result - 0.25) < 0.0001, "Expected coefficient 0.25, got" & Float'Image (Result));
   end Test_Partial_Overlap;

   procedure Test_Short_Strings (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left1   : constant String := "a";
      Right1  : constant String := "a";
      Result1 : constant Float := String_Sorensen_Dice (Left1, Right1);

      Left2   : constant String := "a";
      Right2  : constant String := "b";
      Result2 : constant Float := String_Sorensen_Dice (Left2, Right2);
   begin
      Assert
        (abs (Result1 - 1.0) < 0.0001,
         "Expected coefficient 1.0 for identical single chars, got" & Float'Image (Result1));
      Assert
        (abs (Result2 - 0.0) < 0.0001,
         "Expected coefficient 0.0 for different single chars, got" & Float'Image (Result2));
   end Test_Short_Strings;

   procedure Test_Empty_Strings (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left1   : constant String := "";
      Right1  : constant String := "";
      Result1 : constant Float := String_Sorensen_Dice (Left1, Right1);

      Left2   : constant String := "";
      Right2  : constant String := "abc";
      Result2 : constant Float := String_Sorensen_Dice (Left2, Right2);
   begin
      Assert
        (abs (Result1 - 1.0) < 0.0001, "Expected coefficient 1.0 for two empty strings, got" & Float'Image (Result1));
      Assert
        (abs (Result2 - 0.0) < 0.0001, "Expected coefficient 0.0 for empty vs non-empty, got" & Float'Image (Result2));
   end Test_Empty_Strings;

end Test_Sorensen_Dice;
