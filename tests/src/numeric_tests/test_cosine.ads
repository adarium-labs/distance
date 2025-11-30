--  Test cases for Cosine similarity function

with AUnit;
with AUnit.Test_Cases;

package Test_Cosine is

   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   procedure Register_Tests (T : in out Test_Case);
   function Name (T : Test_Case) return AUnit.Message_String;

   procedure Test_Aligned_Vectors (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Opposite_Vectors (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Orthogonal_Vectors (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Non_Trivial_Angle (T : in out AUnit.Test_Cases.Test_Case'Class);
   procedure Test_Long_Float_Instantiation (T : in out AUnit.Test_Cases.Test_Case'Class);

end Test_Cosine;
