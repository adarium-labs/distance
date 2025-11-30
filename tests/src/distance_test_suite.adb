--  Test suite implementation

with AUnit.Test_Suites;
with Test_Euclidean;
with Test_Manhattan;
with Test_Minkowski;
with Test_Chebyshev;
with Test_Canberra;
with Test_Cosine;
with Test_Hamming;
with Test_Levenshtein;
with Test_Damerau_Levenshtein;
with Test_Jaro_Winkler;
with Test_Sorensen_Dice;

package body Distance_Test_Suite is

   --  Create the test suite
   Result : aliased AUnit.Test_Suites.Test_Suite;

   --  Euclidean test case
   Euclidean_Tests : aliased Test_Euclidean.Test_Case;

   --  Manhattan test case
   Manhattan_Tests : aliased Test_Manhattan.Test_Case;

   --  Minkowski test case
   Minkowski_Tests : aliased Test_Minkowski.Test_Case;

   --  Chebyshev test case
   Chebyshev_Tests : aliased Test_Chebyshev.Test_Case;

   --  Canberra test case
   Canberra_Tests : aliased Test_Canberra.Test_Case;

   --  Cosine similarity test case
   Cosine_Tests : aliased Test_Cosine.Test_Case;

   --  Hamming test case
   Hamming_Tests : aliased Test_Hamming.Test_Case;

   Levenshtein_Tests : aliased Test_Levenshtein.Test_Case;

   Damerau_Levenshtein_Tests : aliased Test_Damerau_Levenshtein.Test_Case;

   Jaro_Winkler_Tests : aliased Test_Jaro_Winkler.Test_Case;

   Sorensen_Dice_Tests : aliased Test_Sorensen_Dice.Test_Case;

   function Suite return AUnit.Test_Suites.Access_Test_Suite is
   begin
      --  Add Euclidean distance tests
      Result.Add_Test (Euclidean_Tests'Access);

      --  Add Manhattan distance tests
      Result.Add_Test (Manhattan_Tests'Access);

      --  Add Minkowski distance tests
      Result.Add_Test (Minkowski_Tests'Access);

      --  Add Chebyshev distance tests
      Result.Add_Test (Chebyshev_Tests'Access);

      --  Add Canberra distance tests
      Result.Add_Test (Canberra_Tests'Access);

      --  Add cosine similarity tests
      Result.Add_Test (Cosine_Tests'Access);

      --  Add Hamming distance tests
      Result.Add_Test (Hamming_Tests'Access);

      Result.Add_Test (Levenshtein_Tests'Access);

      Result.Add_Test (Damerau_Levenshtein_Tests'Access);

      Result.Add_Test (Jaro_Winkler_Tests'Access);

      Result.Add_Test (Sorensen_Dice_Tests'Access);

      return Result'Access;
   end Suite;

end Distance_Test_Suite;
