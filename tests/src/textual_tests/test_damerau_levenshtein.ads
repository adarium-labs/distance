--  Test cases for Damerau-Levenshtein distance function

with AUnit;
with AUnit.Test_Cases;

package Test_Damerau_Levenshtein is

   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Test_Case);
   --  Register all test routines

   function Name (T : Test_Case) return AUnit.Message_String;
   --  Test case name

   --  Test routines
   procedure Test_Identical_Strings (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Transposition (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Mixed_Operations (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_No_Transposition (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Empty_Strings (T : in out AUnit.Test_Cases.Test_Case'Class);

end Test_Damerau_Levenshtein;
