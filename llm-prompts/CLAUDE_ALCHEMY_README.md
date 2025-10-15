# Claude Code Instructions for Alchemy Project

## Project Overview
**Alchemy** is a C++ refactoring and code generation tool built on libclang/LLVM.
- The goal is to create an extensible command-line tool that can analyze C source files (with later support for other source files)
and perform transformations like struct alignment optimization and boilerplate generation.
- project source locations: `inc/**/*.hpp`, `src/**/*.hpp`

## File Structure Reference
```
 alchemy/
├── inc/                                    # public interfaces (semantically organized)
│   ├── app/                                # application layer (top-level orchestration)
│   │   ├── app.hpp                         # App orchestrator (creates parser, operations, executes pipeline)
│   │   ├── app_context.hpp                 # AppConfig (BuildConfig, SourceInventory), Metrics variant
│   │   ├── color.hpp                       # ANSI color codes for terminal output
│   │   └── core.hpp                        # Result<T> monad + core types
│   ├── cli/                                # command-line interface
│   │   └── cli.hpp                         # CLI parsing and validation (Validator, ParsedOptions, feature traits)
│   ├── files/                              # file system operations
│   │   └── discovery.hpp                   # file discovery with glob patterns + threading
│   ├── parsing/                            # parsing layer (source → structured data)
│   │   ├── clang_parser.hpp                # ClangParser (libclang integration via ClangTool)
│   │   ├── clang_parsing_rules.hpp         # parsing rules abstractions
│   │   ├── clang_struct_extractor.hpp      # ClangStructExtractor (AST traversal for structs)
│   │   ├── clang_struct_parsing_rule.hpp   # StructParsingRule (Clang AST matching + StructDef/FieldDef)
│   │   ├── parser.hpp                      # ParsingRuleAdapter interface + ParseResults
│   │   └── parsing_requirements.hpp        # ParsingRequirements (what operations need from parser)
│   ├── pipeline/                           # pipeline layer (orchestrates parse → execute → transmute)
│   │   ├── parsed_artifacts.hpp            # ParsedArtifacts (pipeline's data structure for parsed source)
│   │   └── pipeline.hpp                    # stateless pipeline functions (runParser, executeOperations, transmuteAllRecipes, execute)
│   ├── recipes/                            # recipe layer (artifacts → transformation recipes)
│   │   ├── operations/
│   │   │   ├── refactoring/
│   │   │   │   └── struct_alignment_operation.hpp  # StructAlignmentOperation (RefactorRecipe generation)
│   │   │   └── codegen/
│   │   │       ├── code_generator.hpp      # CodeGenerator interface (strategy pattern for test generation)
│   │   │       ├── cunit_generator.hpp     # CUnitGenerator (concrete CUnit test generator)
│   │   │       └── cunit_test_operation.hpp # CUnitTestOperation (CodeGenRecipe generation)
│   │   └── operation.hpp                   # RecipeOperation interface + Recipe variant (RefactorRecipe, CodeGenRecipe)
│   ├── reporting/                          # reporting layer (metrics output)
│   │   ├── metrics_reporter.hpp            # metrics variant dispatcher (reportMetrics)
│   │   └── salign_reporter.hpp             # SAlignReporter (static functions, three-level display)
│   └── transmute/                          # transmutation layer (recipes → file mutations)
│       └── transmute.hpp                   # transmutation interface (applyRecipes, applyRefactor, applyCodeGen)
├── src/                                    # implementations (mirrors inc/ structure)
│   ├── app/
│   │   └── app.cpp                         # App implementation (parser creation, pipeline execution, metrics reporting)
│   ├── cli/
│   │   └── cli.cpp                         # CLI parsing (LLVM adapter + Validator implementation)
│   ├── files/
│   │   └── discovery.cpp                   # file discovery implementation with threading support
│   ├── parsing/
│   │   ├── clang_parser.cpp                # ClangParser implementation (ClangTool runner)
│   │   ├── clang_struct_extractor.cpp      # ClangStructExtractor implementation (AST callbacks)
│   │   └── clang_struct_parsing_rule.cpp   # StructParsingRule implementation (field extraction)
│   ├── pipeline/
│   │   ├── parsed_artifacts.cpp            # ParsedArtifacts implementation
│   │   └── pipeline.cpp                    # pipeline functions (requirement gathering, operation execution, transmutation)
│   ├── recipes/
│   │   └── operations/
│   │       ├── refactoring/
│   │       │   └── struct_alignment_operation.cpp  # StructAlignmentOperation implementation
│   │       └── codegen/
│   │           ├── cunit_generator.cpp     # CUnitGenerator stub implementation
│   │           └── cunit_test_operation.cpp # CUnitTestOperation stub implementation
│   ├── reporting/
│   │   ├── metrics_reporter.cpp            # metrics variant dispatcher (separates by type, calls reporters)
│   │   └── salign_reporter.cpp             # SAlignReporter implementation
│   └── transmute/
│       └── transmute.cpp                   # recipe variant dispatcher + type-specific functions
├── tests/
│   ├── data/                               # test data files
│   │   └── integration/                    # integration test data
│   │       ├── HelloWorld.h                # sample struct definitions
│   │       └── HelloWorldEmpty.h           # empty file test case
│   ├── unit/                               # unit tests
│   │   ├── test_app_context.cpp            # ParsedArtifacts tests
│   │   ├── test_clang_parser.cpp           # ClangParser tests
│   │   ├── test_clang_struct_extractor.cpp # ClangStructExtractor tests
│   │   ├── test_clang_struct_parsing_rule.cpp # StructParsingRule tests
│   │   ├── test_cli.cpp                    # CLI validation tests (black-box via Validator::validate)
│   │   ├── test_core_types.cpp             # Result<T> monad tests
│   │   ├── test_discovery.cpp              # file discovery tests
│   │   ├── test_parsed_artifacts.cpp       # ParsedArtifacts integration tests
│   │   ├── test_pipeline.cpp               # pipeline function tests
│   │   ├── test_salign_pipeline.cpp        # salign operation tests
│   │   └── test_transmute.cpp              # transmutation tests (+ codegen stubs)
│   ├── integration/                        # integration tests (end-to-end)
│   │   └── test_salign.cpp                 # salign end-to-end tests
│   ├── performance/                        # performance benchmarks
│   │   ├── test_salign.cpp                 # basic performance tests
│   │   ├── test_salign_complexity.cpp      # complexity scaling tests
│   │   ├── test_salign_parsing.cpp         # parsing performance tests
│   │   ├── test_salign_realistic.cpp       # realistic workload tests
│   │   └── test_salign_stress.cpp          # stress tests
│   └── utils.hpp/utils.cpp                 # test utilities (createCliInputs, mock helpers)
├── design/                                 # architecture documentation
│   ├── CLI_IDEA_LAND.md                    # CLI design exploration
│   ├── alchemy-architecture.dot            # graphviz architecture diagram
│   ├── alchemy-dev-v1.md                   # v1 development notes
│   ├── alchemy-dev-v2.md                   # v2 development notes
│   ├── component-diagrams.md               # component architecture
│   ├── plugin-architecture.md              # future plugin system design
│   └── sequence-diagrams.md                # interaction flows
├── main.cpp                                # entry point
├── Makefile                                # build targets (test.unit, test.integration, etc.)
└── CMakeLists.txt                          # build configuration
```

## Architectural Layers

The project is organized into semantic layers with clear dependency boundaries:

### Layer Structure (Top → Bottom)
```
app/          Application layer - top-level orchestration
  ↓           - Creates parser backend (ClangParser)
  ↓           - Creates operations based on enabled features
  ↓           - Executes pipeline
  ↓           - Reports metrics (I/O responsibility)
  ↓
cli/          CLI layer - command-line interface
  ↓           - Parses and validates command-line arguments
  ↓           - Produces ParsedOptions for App
  ↓
pipeline/     Pipeline layer - stateless data transformation
  ↓           - Owns ParsedArtifacts (created from parsing, consumed by operations)
  ↓           - Gathers parsing requirements from operations
  ↓           - Runs parser to create ParsedArtifacts
  ↓           - Executes operations (pass artifacts by const ref)
  ↓           - Transmutes recipes
  ↓           - Returns results + metrics (no I/O)
  ↓
parsing/      Parsing layer - source → structured data
  ↓           - Parser implementations (ClangParser, future RustParser, etc.)
  ↓           - AST traversal and extraction (structs, functions)
  ↓           - Produces ParseResults (consumed by pipeline to build ParsedArtifacts)
  ↓
recipes/      Recipe layer - artifacts → transformation recipes
  ↓           - RecipeOperation interface (renamed from ParsingOperation)
  ↓           - operations/refactoring/: RefactorRecipe generation (StructAlignmentOperation)
  ↓           - operations/codegen/: CodeGenRecipe generation (CUnitTestOperation)
  ↓
transmute/    Transmutation layer - recipes → file mutations
  ↓           - applyRecipes: variant dispatcher (RefactorRecipe | CodeGenRecipe)
  ↓           - applyRefactor: byte-level in-place file modifications
  ↓           - applyCodeGen: generate and write new files
  ↓
reporting/    Reporting layer - output formatting
  ↓           - metrics_reporter: variant dispatcher for metrics
  ↓           - salign_reporter: struct alignment metrics formatting
  ↓
files/        File system layer - discovery and path operations
```

### Key Architectural Properties

1. **Separation of Concerns**:
   - `app/` handles I/O (file writing, console output, metrics reporting)
   - `cli/` handles command-line parsing (separate from app orchestration)
   - `pipeline/` handles data transformation (pure business logic, no I/O)
   - `parsing/` extracts structured data from source (no recipe generation)
   - `recipes/` generates transformation recipes from artifacts (no parsing)
   - `transmute/` applies recipes to files (writing only)
   - `reporting/` formats output (no business logic)

2. **Clear Semantic Boundaries** (v2.3 refactoring):
   - No conflation: `parsing/` creates data, `recipes/` creates recipes
   - `ParsedArtifacts` lives in `pipeline/` (where it's created and managed)
   - `RecipeOperation` interface renamed from `ParsingOperation` (more accurate)

3. **Dependency Flow**:
   - High-level depends on low-level (app → pipeline → {parsing, recipes, transmute})
   - Core types (`app/core.hpp`) used across all layers
   - `ParsedArtifacts` passed by const reference (no copying, parse once)

4. **Recent Improvements**:
   - v2.2: Moved metrics reporting from pipeline to app layer (separation of I/O)
   - v2.3: Split parsing/operations into `parsing/` (data extraction) and `recipes/` (transformation specs)
   - Clear boundaries enable testability and future refactoring

## Project files

- please see the project Makefile for targets
- headers can be found under `inc/` (semantically organized by layer)
- source can be found under `src/` (mirrors inc/ structure)
- design documents under `design/`
- tests under `tests/unit` and `tests/integration` respectively
- prefer 2 spaces for indentation
- prefer spaces over tabs

## Workflow Rules
- always confirm with me whenever we write, modify, or delete
- i don't want an agentic workflow where you're a black-box.
- i prefer interactive and walk-through based design and discussions
- this includes demonstrations, examples, concepts explained, reasoning,
so that i can review them and contribute as much as you're actively participating
- you're not a sycophant, or a people-pleaser, you're a professional software engineer who is my mentor and capable of giving me feedback or disagreeing
- i repeat, i prefer correctness and quality over validation
- so work together for the sake of correctness and quality, not just to make me happy as a user arbitrarily happy
- don't force things to work
- if a test fails, we consider whether the failure is an indication the code is broken first, not an indication
the test needs to be corrected -> the application code must be examined first before test code in this case
- i try to be mindful of over-thinking/over-abstracting/over-engineering
- i prefer to let abstractions emerge as the problem develops, and then reach for an abstraction, unless it is requirements change
that can reasonably be anticipated
- please prefer lowercase in code comments except for proper nouns

## Effective Context and Exchange Pattern

**What works exceptionally well**:

1. **Concrete Example First** - Show actual code structure before discussing abstractions
2. **Design Rationale** - Explain *why* each design choice exists and what it enables
3. **Inclusive Design Process** - Ask specific questions about edge cases and implementation decisions
4. **Clear Next Steps** - Provide concrete, actionable options with clear trade-offs
5. **Collaborative Approach** - Make it the user's decision while providing reasoning and context

**Successful Format**: **Example → Reasoning → Questions → Next Steps**

**Key Behaviors**:
- **Show, don't just tell** - Code examples with reasoning
- **Think out loud** - Share design considerations and trade-offs openly
- **Ask targeted questions** - Get user input on specific decisions, not vague requests
- **Break down complexity** - Turn big problems into clear, concrete tasks
- **Explain the "why"** - Connect implementation choices to larger architectural goals
- **Interactive design** - User reviews and contributes to output rather than receiving black-box solutions

## Key Project Context
- **Language**: C++17 with Clang/LLVM APIs
- **Current scope**: C header files (.h extensions) for struct analysis and test generation
- **Architecture**: CLI (parseCli → Validator) → App (orchestration + metrics reporting) → Discovery → Pipeline (parse → executeOperations → transmute) → Transmute (variant dispatchers)
- **CLI Architecture**: Semantic grouping (PathOptions, FeatureFlags, BuildConfig) + namespace-based feature traits + centralized Validator → produces ParsedOptions
- **Error handling**: Custom Result<T> monad (see `inc/core.hpp`)
- **Build system**: CMake with proper dependency management
- **Variant architecture**: Recipe = variant<RefactorRecipe, CodeGenRecipe>, Metrics = variant<SAlignMetrics, CmockMetrics, CppunitMetrics>
- **Static polymorphism**: std::variant + std::visit for compile-time dispatch (no vtables, zero heap allocations)
- **Strategy pattern**: CodeGenerator interface with framework-specific implementations (CUnitGenerator, GTestGenerator, etc.)
- **Separation of concerns**: Pipeline handles data transformation (no I/O), App handles I/O and reporting
- **Current features**: --salign (struct alignment optimization), --cunit (CUnit test generation stub), --dry-run (preview without writing files)
- **Test coverage**: 150 unit tests + 11 integration tests + performance/stress tests
- **Recent refactoring**: v2.2 - moved metrics reporting from pipeline to app layer, zero-cost abstraction validated with valgrind

## Notes
- please read `pitm.md` for context on what overall software engineering practices to reinforce in my learning
