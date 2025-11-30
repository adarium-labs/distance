with AUnit.Assertions;
with AUnit.Test_Cases;
with Distance.Textual.Hamming;

package body Test_Hamming is

   use AUnit.Assertions;

   function String_Hamming is new Distance.Textual.Hamming (Positive, Character, String);

   function Wide_String_Hamming is new Distance.Textual.Hamming (Positive, Wide_Character, Wide_String);

   function Wide_Wide_String_Hamming is new Distance.Textual.Hamming (Positive, Wide_Wide_Character, Wide_Wide_String);

   function Name (T : Test_Case) return AUnit.Message_String is
   begin
      return AUnit.Format ("Hamming Distance Tests");
   end Name;

   procedure Register_Tests (T : in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Identical_Strings'Access, "Identical strings");
      Register_Routine (T, Test_One_Difference'Access, "One difference");
      Register_Routine (T, Test_Multiple_Differences'Access, "Multiple differences");
      Register_Routine (T, Test_All_Different'Access, "All different");
      Register_Routine (T, Test_Wide_String'Access, "Wide_String support");
      Register_Routine (T, Test_Wide_Wide_String'Access, "Wide_Wide_String support");
   end Register_Tests;

   procedure Test_Identical_Strings (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "ABCDEF";
      Right  : constant String := "ABCDEF";
      Result : constant Natural := String_Hamming (Left, Right);
   begin
      Assert (Result = 0, "Expected 0 differences, got" & Natural'Image (Result));
   end Test_Identical_Strings;

   procedure Test_One_Difference (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "ABCDEF";
      Right  : constant String := "ABXDEF";
      Result : constant Natural := String_Hamming (Left, Right);
   begin
      Assert (Result = 1, "Expected 1 difference, got" & Natural'Image (Result));
   end Test_One_Difference;

   procedure Test_Multiple_Differences (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "AAAAAA";
      Right  : constant String := "AABBAA";
      Result : constant Natural := String_Hamming (Left, Right);
   begin
      Assert (Result = 2, "Expected 2 differences, got" & Natural'Image (Result));
   end Test_Multiple_Differences;

   procedure Test_All_Different (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant String := "ABC";
      Right  : constant String := "XYZ";
      Result : constant Natural := String_Hamming (Left, Right);
   begin
      Assert (Result = 3, "Expected 3 differences, got" & Natural'Image (Result));
   end Test_All_Different;

   procedure Test_Wide_String (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant Wide_String := (1 => 'A', 2 => 'B', 3 => 'C');
      Right  : constant Wide_String := (1 => 'A', 2 => 'X', 3 => 'C');
      Result : constant Natural := Wide_String_Hamming (Left, Right);
   begin
      Assert (Result = 1, "Expected 1 difference for Wide_String, got" & Natural'Image (Result));
   end Test_Wide_String;

   procedure Test_Wide_Wide_String (T : in out AUnit.Test_Cases.Test_Case'Class) is
      pragma Unreferenced (T);
      Left   : constant Wide_Wide_String := (1 => 'A', 2 => 'B', 3 => 'C');
      Right  : constant Wide_Wide_String := (1 => 'Z', 2 => 'B', 3 => 'C');
      Result : constant Natural := Wide_Wide_String_Hamming (Left, Right);
   begin
      Assert (Result = 1, "Expected 1 difference for Wide_Wide_String, got" & Natural'Image (Result));
   end Test_Wide_Wide_String;

end Test_Hamming;
