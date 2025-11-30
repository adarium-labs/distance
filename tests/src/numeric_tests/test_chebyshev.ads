--  Test cases for Chebyshev distance function

with AUnit;
with AUnit.Test_Cases;

package Test_Chebyshev is

   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Test_Case);
   --  Register all test routines

   function Name (T : Test_Case) return AUnit.Message_String;
   --  Test case name

   --  Test routines
   procedure Test_Basic_Max (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Zero_Distance (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_High_Dimensional (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Long_Float_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class);

end Test_Chebyshev;
