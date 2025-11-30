with AUnit;
with AUnit.Test_Cases;

package Test_Levenshtein is

   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   overriding
   procedure Register_Tests (T : in out Test_Case);
   overriding
   function Name (T : Test_Case) return AUnit.Message_String;

   procedure Test_Identical_Strings (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Pure_Insertion (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Pure_Deletion (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Substitution (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Mixed_Edits (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Empty_Strings (T : in out AUnit.Test_Cases.Test_Case'Class);

end Test_Levenshtein;
