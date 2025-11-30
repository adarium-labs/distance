--  Test cases for Minkowski distance function

with AUnit;
with AUnit.Test_Cases;

package Test_Minkowski is

   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Test_Case);
   function Name (T : Test_Case) return AUnit.Message_String;

   procedure Test_P1_Equals_Manhattan (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_P2_Equals_Euclidean (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Non_Integral_P (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Zero_Distance (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Long_Float_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class);

end Test_Minkowski;
