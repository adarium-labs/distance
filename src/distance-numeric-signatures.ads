--------------------------------------------------------------------------------
--  Distance - A formally verified Ada library for distance metrics
--  Copyright (c) 2025
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--------------------------------------------------------------------------------

--  Package: Distance.Numeric.Signatures
--
--  Purpose: Defines the signature (interface) for numeric operations required
--           by generic distance metric functions.
--
--  Responsibilities:
--    * Define the generic formal parameters for numeric types
--    * Specify required mathematical operations (+, -, *, abs, etc.)
--    * Support floating-point, fixed-point, and integer types
--    * Enable use of custom implementations (e.g., formally proved sqrt)
--
--  Design Notes:
--    This signature package follows the pattern used in Ada.Numerics for
--    Generic_Elementary_Functions. It allows distance metrics to be
--    instantiated with any numeric type that provides the required
--    operations, including:
--      - Floating-point types (Float, Long_Float)
--      - Fixed-point types (with custom sqrt from spark_math)
--      - Integer types (with custom sqrt from spark_math)
--
--    Users instantiate this package with their numeric type and operations,
--    then pass the instantiated package to the generic distance functions.
--
--  External Effects: None (Pure package)
--  Thread Safety: Thread-safe (Pure package, no shared state)
--  SPARK Status: Compatible

pragma SPARK_Mode (On);

generic
   type Element_Type is private;

   --  Constants
   Zero : Element_Type;
   One : Element_Type;

   --  Basic arithmetic operations
   with function "+" (Left, Right : Element_Type) return Element_Type is <>;
   with function "-" (Left, Right : Element_Type) return Element_Type is <>;
   with function "*" (Left, Right : Element_Type) return Element_Type is <>;
   with function "/" (Left, Right : Element_Type) return Element_Type is <>;

   --  Absolute value
   with function "abs" (Value : Element_Type) return Element_Type is <>;

   --  Comparison operations
   with function "<=" (Left, Right : Element_Type) return Boolean is <>;
   with function ">=" (Left, Right : Element_Type) return Boolean is <>;
   with function "=" (Left, Right : Element_Type) return Boolean is <>;

   --  Mathematical functions for distance calculations
   --  Note: For types without native sqrt/power, users provide
   --  custom implementations (e.g., from spark_math library)
   with function Sqrt (Value : Element_Type) return Element_Type is <>;
   with function "**" (Left : Element_Type; Right : Element_Type) return Element_Type is <>;

   --  Maximum element value for bounds checking
   --  Used in preconditions to prevent overflow
   Max_Element : Element_Type;

package Distance.Numeric.Signatures with Pure
is
   --  This package is a signature package (interface specification).
   --  It contains no implementation - only type and operation definitions
   --  used as formal parameters for generic distance metric functions.
   --
   --  **Usage Example:**
   --
   --  For Float type:
   --     package Float_Sig is new Distance.Numeric.Signatures
   --       (Element_Type => Float,
   --        Zero         => 0.0,
   --        One          => 1.0,
   --        Sqrt         => Ada.Numerics.Generic_Elementary_Functions.Sqrt,
   --        Max_Element  => Float'Base'Last);
   --
   --  For custom fixed-point type with formally proved sqrt:
   --     package Fixed_Sig is new Distance.Numeric.Signatures
   --       (Element_Type => My_Fixed_Type,
   --        Zero         => 0.0,
   --        One          => 1.0,
   --        Sqrt         => Spark_Math.Fixed.Sqrt,  -- Formally verified!
   --        Max_Element  => My_Fixed_Type'Last);

end Distance.Numeric.Signatures;
