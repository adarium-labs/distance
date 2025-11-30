with AUnit.Assertions;
with AUnit.Test_Cases;
with Distance.Textual.Levenshtein;

package body Test_Levenshtein is

   use AUnit.Assertions;

   function String_Levenshtein is new Distance.Textual.Levenshtein (Positive, Character, String, Max_Length => 32);

   overriding
   function Name (T : Test_Case) return AUnit.Message_String is
   begin
      return AUnit.Format ("Levenshtein Distance Tests");
   end Name;

   overriding
   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Identical_Strings'Access, "Identical strings");
      Register_Routine (T, Test_Pure_Insertion'Access, "Pure insertion");
      Register_Routine (T, Test_Pure_Deletion'Access, "Pure deletion");
      Register_Routine (T, Test_Substitution'Access, "Substitution");
      Register_Routine (T, Test_Mixed_Edits'Access, "Mixed edits");
      Register_Routine (T, Test_Empty_Strings'Access, "Empty string cases");
   end Register_Tests;

   procedure Test_Identical_Strings (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "distance";
      Right  : constant String := "distance";
      Result : constant Natural := String_Levenshtein (Left, Right);
   begin
      Assert (Result = 0, "Expected 0 edits for identical strings, got" & Natural'Image (Result));
   end Test_Identical_Strings;

   procedure Test_Pure_Insertion (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "kitten";
      Right  : constant String := "kittenX";
      Result : constant Natural := String_Levenshtein (Left, Right);
   begin
      Assert (Result = 1, "Expected 1 edit for pure insertion, got" & Natural'Image (Result));
   end Test_Pure_Insertion;

   procedure Test_Pure_Deletion (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "kitten";
      Right  : constant String := "kitte";
      Result : constant Natural := String_Levenshtein (Left, Right);
   begin
      Assert (Result = 1, "Expected 1 edit for pure deletion, got" & Natural'Image (Result));
   end Test_Pure_Deletion;

   procedure Test_Substitution (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "kitten";
      Right  : constant String := "sitten";
      Result : constant Natural := String_Levenshtein (Left, Right);
   begin
      Assert (Result = 1, "Expected 1 edit for substitution, got" & Natural'Image (Result));
   end Test_Substitution;

   procedure Test_Mixed_Edits (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "kitten";
      Right  : constant String := "sitting";
      Result : constant Natural := String_Levenshtein (Left, Right);
   begin
      Assert (Result = 3, "Expected 3 edits for mixed case kitten->sitting, got" & Natural'Image (Result));
   end Test_Mixed_Edits;

   procedure Test_Empty_Strings (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left    : constant String := "";
      Right   : constant String := "abc";
      Result1 : constant Natural := String_Levenshtein (Left, Right);
      Result2 : constant Natural := String_Levenshtein (Left => Right, Right => Left);
   begin
      Assert (Result1 = 3, "Expected distance 3 from empty to 'abc', got" & Natural'Image (Result1));
      Assert (Result2 = 3, "Expected distance 3 from 'abc' to empty, got" & Natural'Image (Result2));
   end Test_Empty_Strings;

end Test_Levenshtein;
