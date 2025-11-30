with AUnit;
with AUnit.Test_Cases;

package Test_Hamming is

   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Test_Case);
   function Name (T : Test_Case) return AUnit.Message_String;

   procedure Test_Identical_Strings (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_One_Difference (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Multiple_Differences (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_All_Different (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Wide_String (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Wide_Wide_String (T : in out AUnit.Test_Cases.Test_Case'Class);

end Test_Hamming;
