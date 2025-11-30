# Distance - Formally Verified Distance Metrics Library

Distances is a comprehensive collection of distance and similarity algorithms implemented in Ada 2012. Designed for high-integrity systems, the library utilizes SPARK 2014 to prove the absence of runtime errors (buffer overflows, division by zero). It features generic interfaces to support various floating-point precisions, fixed-point types and integer types, covering domains such as linear algebra, string manipulation, and statistical measures.

## Features

- **SPARK Silver Level Verification:** Formally proven absence of runtime errors
- **Signature-Based Genericity:** Flexible instantiation via `Distance.Numeric.Signatures` package
- **Zero Allocation:** Compatible with embedded/bare-metal systems
- **Comprehensive Metrics:**
  - **Numeric:** Euclidean, Manhattan, Minkowski, Chebyshev, Canberra
  - **Textual:** Hamming, Levenshtein, Damerau-Levenshtein, Jaro-Winkler, Sørensen-Dice
  - **Statistical:** Cosine Similarity

## Building

This project uses [Alire](https://alire.ada.dev/) for dependency management.

### Prerequisites

- GNAT (Ada 2012 compiler)
- SPARK 2024 (gnatprove)
- Alire package manager

### Build Commands

```bash
# Build the library
alr build

# Run SPARK verification
cd tests && alr exec -- gnatprove -P distance_tests.gpr --level=2 proof.adb

# Run tests
cd tests && alr test
```

### Build Output

- Library: `lib/libDistance.a`
- Object files: `obj/development/`
- Test executable: `tests/bin/test_runner`

## Usage

### Numeric Distance Metrics

All numeric distance functions use the **signature-based generic pattern**. First instantiate a `Signatures` package, then instantiate the distance function.

#### Euclidean Distance (L2 Norm)

Calculate the straight-line distance between two numeric vectors:

```ada
with Ada.Numerics.Elementary_Functions;
with Distance.Numeric.Signatures;
with Distance.Numeric.Euclidean_Generic;

procedure Example is
   type Float_Vector is array (Positive range <>) of Float;

   --  Step 1: Instantiate elementary functions package
   package Float_Functions is new Ada.Numerics.Elementary_Functions (Float);

   --  Step 2: Instantiate signatures package
   package Float_Sig is new Distance.Numeric.Signatures
     (Element_Type => Float,
      Zero         => 0.0,
      One          => 1.0,
      Sqrt         => Float_Functions.Sqrt,
      "**"         => Float_Functions."**",
      Max_Element  => Float'Last);

   --  Step 3: Instantiate distance function
   function Float_Euclidean is new Distance.Numeric.Euclidean_Generic
     (Numeric_Ops => Float_Sig,
      Index_Type  => Positive,
      Vector      => Float_Vector);

   V1 : constant Float_Vector := (0.0, 0.0, 0.0);
   V2 : constant Float_Vector := (3.0, 4.0, 0.0);
   D  : constant Float := Float_Euclidean (V1, V2);
   --  D = 5.0 (3-4-5 triangle)
begin
   null;
end Example;
```

#### Manhattan Distance (L1 Norm)

```ada
function Float_Manhattan is new Distance.Numeric.Manhattan_Generic
  (Numeric_Ops => Float_Sig, Index_Type => Positive, Vector => Float_Vector);
--  Manhattan((0,0), (3,4)) = 7.0
```

#### Minkowski Distance (Lp Norm)

Generalized distance with configurable `P` parameter:

```ada
function Float_Minkowski is new Distance.Numeric.Minkowski_Generic
  (Numeric_Ops => Float_Sig,
   Index_Type  => Positive,
   Vector      => Float_Vector,
   Log         => Float_Functions.Log,
   Exp         => Float_Functions.Exp);
--  P=1: Manhattan, P=2: Euclidean, P=∞: Chebyshev
```

#### Chebyshev Distance (L∞ Norm)

Maximum absolute difference across dimensions:

```ada
function Float_Chebyshev is new Distance.Numeric.Chebyshev_Generic
  (Numeric_Ops => Float_Sig, Index_Type => Positive, Vector => Float_Vector);
--  Chebyshev((0,0), (3,4)) = 4.0
```

#### Canberra Distance

Weighted distance metric sensitive to values near zero:

```ada
function Float_Canberra is new Distance.Numeric.Canberra_Generic
  (Numeric_Ops => Float_Sig, Index_Type => Positive, Vector => Float_Vector);
```

**SPARK Contracts (All Numeric Metrics):**
- Precondition: Vectors must have equal length and be non-empty
- Postcondition: Result is non-negative (distance ≥ 0.0)
- Verified to SPARK Silver Level (no runtime errors)

### Textual Distance Metrics

String similarity metrics for edit distance and fuzzy matching.

#### Levenshtein Distance

Minimum single-character edits (insertions, deletions, substitutions):

```ada
with Distance.Textual.Levenshtein;

function String_Levenshtein is new Distance.Textual.Levenshtein
  (Character, Positive, String);

D : constant Natural := String_Levenshtein ("kitten", "sitting");
--  D = 3
```

#### Damerau-Levenshtein Distance

Levenshtein with transposition support:

```ada
with Distance.Textual.Damerau_Levenshtein;

function String_DL is new Distance.Textual.Damerau_Levenshtein
  (Character, Positive, String);

D : constant Natural := String_DL ("ca", "ac");
--  D = 1 (single transposition)
```

#### Jaro-Winkler Similarity

Similarity score (0.0 to 1.0) with prefix bonus:

```ada
with Distance.Textual.Jaro_Winkler;

function String_JW is new Distance.Textual.Jaro_Winkler
  (Character, Positive, String);

S : constant Float := String_JW ("MARTHA", "MARHTA");
--  S ≈ 0.961
```

#### Hamming Distance

Count of differing positions (requires equal-length strings):

```ada
with Distance.Textual.Hamming;

function String_Hamming is new Distance.Textual.Hamming
  (Character, Positive, String);

D : constant Natural := String_Hamming ("karolin", "kathrin");
--  D = 3
```

#### Sørensen-Dice Coefficient

Bigram-based similarity (0.0 to 1.0):

```ada
with Distance.Textual.Sorensen_Dice;

function String_Dice is new Distance.Textual.Sorensen_Dice
  (Character, Positive, String);

S : constant Float := String_Dice ("night", "nacht");
--  S ≈ 0.25
```

### Statistical Metrics

#### Cosine Similarity

Measures angle between vectors (-1.0 to 1.0):

```ada
with Distance.Statistical.Cosine_Similarity_Generic;

function Float_Cosine is new Distance.Statistical.Cosine_Similarity_Generic
  (Numeric_Ops => Float_Sig, Index_Type => Positive, Vector => Float_Vector);

S : constant Float := Float_Cosine ((1.0, 0.0), (1.0, 1.0));
--  S ≈ 0.707 (45° angle)
```

## Development

### Project Structure

```
distance/
├── src/                              # Library source code
├── tests/                            # Test suite (AUnit)
│   ├── distance_tests.gpr
│   └── src/
│       ├── numeric_tests/            # Numeric metric tests
│       ├── textual_tests/            # Textual metric tests
│       └── proof/                    # SPARK proof units
├── docs/                             # Documentation
├── alire.toml                        # Alire crate manifest
└── distance.gpr                      # Main project file
```

### SPARK Verification

All code is verified to SPARK Silver Level (Absence of Runtime Errors):

```bash
cd tests && alr exec -- gnatprove -P distance.gpr --mode=silver proof.adb
```

### Testing

The project uses AUnit for unit testing:

```bash
# Build tests only
cd tests && alr run test_runner
```

## License

Apache-2.0 WITH LLVM-exception
