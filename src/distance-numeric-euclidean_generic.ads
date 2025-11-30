------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------------

--  Generic Euclidean distance function for numeric vectors (signature-based)
--
--  Calculates the straight-line distance between two points in
--  N-dimensional space (L2 norm). This is the most common distance
--  metric, representing the shortest path between two points.
--
--  **Formula:** sqrt(sum((Left[i] - Right[i])^2))
--
--  **Generic Parameters:**
--    - Numeric_Ops: Instantiation of Distance.Numeric.Signatures providing
--      the Element_Type and required operations
--    - Index_Type: Array index type (Integer, Positive, etc.)
--    - Vector: Array type indexed by Index_Type containing Element_Type
--
--  **Preconditions:**
--    - Vectors must have equal length
--    - Vectors must be non-empty
--    - Element values must be within safe bounds to prevent overflow
--      (abs value <= Max_Element / 2)
--
--  **Postconditions:**
--    - Result is non-negative (distance >= Zero)
--
--  **SPARK Verification:**
--    - Verified to Silver Level (Absence of Runtime Errors)
--    - Loop invariants ensure sum remains non-negative and bounded
--    - Overflow prevention via precondition bounds checking
--
--  **Usage Example:**
--
--     --  For Float type:
--     package Float_Math is new
--       Ada.Numerics.Generic_Elementary_Functions (Float);
--     package Float_Sig is new Distance.Numeric.Signatures
--       (Element_Type => Float,
--        Zero         => 0.0,
--        One          => 1.0,
--        Sqrt         => Float_Math.Sqrt,
--        Max_Element  => Float'Base'Last);
--
--     type Float_Vector is array (Positive range <>) of Float;
--     function Float_Euclidean is new Distance.Numeric.Euclidean_Generic
--       (Numeric_Ops => Float_Sig,
--        Index_Type  => Positive,
--        Vector      => Float_Vector);
--
--     V1 : constant Float_Vector := (0.0, 0.0, 0.0);
--     V2 : constant Float_Vector := (3.0, 4.0, 0.0);
--     D  : constant Float := Float_Euclidean (V1, V2);
--     --  D = 5.0 (3-4-5 triangle)
--
--  @param Left First vector in the distance calculation. Must have same
--    length as Right and all elements must be within safe bounds to
--    prevent overflow (abs value <= Max_Element / 2).
--  @param Right Second vector in the distance calculation. Must have
--    same length as Left and all elements must be within safe bounds.
--  @return Non-negative Euclidean distance (L2 norm) between the two
--    vectors. Result is guaranteed to be >= Zero by postcondition.

pragma SPARK_Mode (On);

with Distance.Numeric.Signatures;

generic
   with package Numeric_Ops is new Distance.Numeric.Signatures (<>);
   type Index_Type is range <>;
   type Vector is array (Index_Type range <>) of Numeric_Ops.Element_Type;
function Distance.Numeric.Euclidean_Generic (Left, Right : Vector) return Numeric_Ops.Element_Type with
  Pre =>
    Left'Length > 0
    and then Left'First = Right'First
    and then Left'Last = Right'Last
    and then (for all I in Left'Range
              => Numeric_Ops."<="
                   (Numeric_Ops."abs" (Left (I)),
                    Numeric_Ops."/" (Numeric_Ops.Max_Element, Numeric_Ops."+" (Numeric_Ops.One, Numeric_Ops.One)))
              and then Numeric_Ops."<="
                         (Numeric_Ops."abs" (Right (I)),
                          Numeric_Ops."/"
                            (Numeric_Ops.Max_Element, Numeric_Ops."+" (Numeric_Ops.One, Numeric_Ops.One)))),
  Post => Numeric_Ops.">=" (Euclidean_Generic'Result, Numeric_Ops.Zero);
