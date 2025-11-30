------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

--  Package: Distance.Statistical
--
--  Purpose: Parent package for statistical similarity metrics with support for
--           multiple numeric types (floating-point, fixed-point, integer)
--
--  Responsibilities:
--    * Provide generic similarity functions for numeric vectors
--    * Support floating-point, fixed-point, and integer types
--    * Enable formal verification to SPARK Silver Level
--    * Use signature-based generics for maximum flexibility
--
--  Design Notes:
--    This package provides signature-based generic similarity functions that
--    work with any numeric type:
--
--    - Distance.Numeric.Signatures: Defines operation interface
--    - Distance.Statistical.Cosine_Similarity_Generic: Generic cosine similarity
--
--    These generics allow use of any numeric type by providing a signature
--    package with required operations. Ideal for:
--      * Floating-point types (Float, Long_Float)
--      * Fixed-point types with custom sqrt from spark_math
--      * Integer types with custom sqrt from spark_math
--      * Custom numeric types
--
--  **Example Usage (Floating-Point):**
--
--     type Float_Vector is array (Positive range <>) of Float;
--
--     package Float_Math is new
--       Ada.Numerics.Generic_Elementary_Functions (Float);
--
--     package Float_Sig is new Distance.Numeric.Signatures
--       (Element_Type => Float,
--        Zero         => 0.0,
--        One          => 1.0,
--        Sqrt         => Float_Math.Sqrt,
--        "**"         => Float_Math."**",
--        Max_Element  => Float'Base'Last);
--
--     function Float_Cosine is new Distance.Statistical.Cosine_Similarity_Generic
--       (Numeric_Ops => Float_Sig,
--        Index_Type  => Positive,
--        Vector      => Float_Vector);
--
--  **Child Packages:**
--    - Distance.Statistical.Cosine_Similarity_Generic: Cosine similarity (signature-based)
--
--  **Common Contracts:**
--    - Precondition: Vectors must have equal length and be non-empty
--    - Precondition: Both vectors must have at least one non-zero element
--
--  External Effects: None (Pure package)
--  Thread Safety: Thread-safe (Pure package, no shared state)
--  SPARK Status: Compatible

pragma SPARK_Mode (On);

package Distance.Statistical
  with Pure
is
   --  This package serves as the parent for all statistical similarity metrics.
   --  See child packages for specific similarity function implementations.

end Distance.Statistical;
