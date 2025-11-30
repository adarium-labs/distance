with AUnit;
with AUnit.Test_Cases;

package Test_Jaro_Winkler is

   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   overriding
   procedure Register_Tests (T : in out Test_Case);
   overriding
   function Name (T : Test_Case) return AUnit.Message_String;

   procedure Test_Identical_Strings (T : in out AUnit.Test_Cases.Test_Case'Class);

   procedure Test_Completely_Different (T : in out AUnit.Test_Cases.Test_Case'Class);

   procedure Test_Prefix_Boost (T : in out AUnit.Test_Cases.Test_Case'Class);

   procedure Test_Transposition_Sensitivity (T : in out AUnit.Test_Cases.Test_Case'Class);

   procedure Test_Short_Vs_Longer (T : in out AUnit.Test_Cases.Test_Case'Class);

end Test_Jaro_Winkler;
