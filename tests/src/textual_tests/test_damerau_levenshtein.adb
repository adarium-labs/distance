with AUnit.Assertions;
with AUnit.Test_Cases;
with Distance.Textual.Damerau_Levenshtein;

package body Test_Damerau_Levenshtein is

   use AUnit.Assertions;

   function String_Damerau_Levenshtein is new
     Distance.Textual.Damerau_Levenshtein (Positive, Character, String, Max_Length => 32);

   overriding
   function Name (T : Test_Case) return AUnit.Message_String is
   begin
      return AUnit.Format ("Damerau-Levenshtein Distance Tests");
   end Name;

   overriding
   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Identical_Strings'Access, "Identical strings");
      Register_Routine (T, Test_Transposition'Access, "Transposition");
      Register_Routine (T, Test_Mixed_Operations'Access, "Mixed operations");
      Register_Routine (T, Test_No_Transposition'Access, "No transposition needed");
      Register_Routine (T, Test_Empty_Strings'Access, "Empty string cases");
   end Register_Tests;

   procedure Test_Identical_Strings (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "distance";
      Right  : constant String := "distance";
      Result : constant Natural := String_Damerau_Levenshtein (Left, Right);
   begin
      Assert (Result = 0, "Expected 0 edits for identical strings, got" & Natural'Image (Result));
   end Test_Identical_Strings;

   procedure Test_Transposition (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "ca";
      Right  : constant String := "ac";
      Result : constant Natural := String_Damerau_Levenshtein (Left, Right);
   begin
      Assert (Result = 1, "Expected 1 edit for simple transposition, got" & Natural'Image (Result));
   end Test_Transposition;

   procedure Test_Mixed_Operations (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "abcdef";
      Right  : constant String := "bacdfe";
      Result : constant Natural := String_Damerau_Levenshtein (Left, Right);
      --  ab -> ba (1 transposition)
      --  cd -> cd (no change)
      --  ef -> fe (1 transposition)
      --  Total: 2 transpositions
   begin
      Assert (Result = 2, "Expected 2 edits for two transpositions, got" & Natural'Image (Result));
   end Test_Mixed_Operations;

   procedure Test_No_Transposition (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "kitten";
      Right  : constant String := "sitting";
      Result : constant Natural := String_Damerau_Levenshtein (Left, Right);
      --  Same as Levenshtein: 3 edits (k->s, e->i, insert g)
   begin
      Assert (Result = 3, "Expected 3 edits (no transposition benefit), got" & Natural'Image (Result));
   end Test_No_Transposition;

   procedure Test_Empty_Strings (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left    : constant String := "";
      Right   : constant String := "abc";
      Result1 : constant Natural := String_Damerau_Levenshtein (Left, Right);
      Result2 : constant Natural := String_Damerau_Levenshtein (Left => Right, Right => Left);
   begin
      Assert (Result1 = 3, "Expected distance 3 from empty to 'abc', got" & Natural'Image (Result1));
      Assert (Result2 = 3, "Expected distance 3 from 'abc' to empty, got" & Natural'Image (Result2));
   end Test_Empty_Strings;

end Test_Damerau_Levenshtein;
