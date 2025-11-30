------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

pragma SPARK_Mode (On);

package Distance
  with Pure
is
   --  Root package for the Distance library
   --
   --  Provides formally verified distance and similarity algorithms for
   --  safety-critical and high-integrity applications.
   --
   --  **SPARK Verification:** All packages verified to SPARK Silver Level
   --  (Absence of Runtime Errors - AoRE)
   --
   --  **Zero Allocation:** No heap usage, suitable for embedded systems
   --
   --  **Generic Design:** Signature-based instantiation for flexible
   --  numeric type support (Float, Long_Float, fixed-point, integer)
   --
   --  **Domain Organization:**
   --    - Distance.Numeric: Vector distance metrics (Euclidean, Manhattan,
   --        Minkowski, Chebyshev, Canberra) via signature-based generics
   --    - Distance.Textual: String similarity metrics (Hamming, Levenshtein,
   --        Damerau-Levenshtein, Jaro-Winkler, Sørensen-Dice)
   --    - Distance.Statistical: Statistical measures (Cosine Similarity)
   --    - Distance.Geographic: Geographic distance calculations (planned)
end Distance;
