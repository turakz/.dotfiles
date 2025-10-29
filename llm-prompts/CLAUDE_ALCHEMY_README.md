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
│   │   ├── color.hpp                       # ANSI color codes for terminal output
│   │   └── core.hpp                        # Result<T> monad + core types
│   ├── cli/                                # command-line interface
│   │   └── cli.hpp                         # CLI parsing and validation (Validator, ParsedOptions, feature traits)
│   ├── config/                             # configuration types
│   │   ├── app_config.hpp                  # AppConfig (top-level configuration container)
│   │   ├── build_config.hpp                # BuildConfig (build directory, dry-run flag)
│   │   └── source_inventory.hpp            # SourceInventory (discovered source files)
│   ├── files/                              # file system operations
│   │   └── discovery.hpp                   # file discovery with glob patterns + threading
│   ├── metrics/                            # metrics types
│   │   ├── metrics.hpp                     # Metrics variant (SAlignMetrics, CmockMetrics, etc.)
│   │   └── salign_metrics.hpp              # SAlignMetrics (struct alignment metrics data)
│   ├── operations/                         # recipe operations
│   │   ├── recipes/
│   │   │   ├── refactoring/
│   │   │   │   └── struct_alignment_operation.hpp  # StructAlignmentOperation (RefactorRecipe generation)
│   │   │   └── codegen/
│   │   │       ├── code_generator.hpp      # CodeGenerator interface (strategy pattern for test generation)
│   │   │       ├── cunit_generator.hpp     # CUnitGenerator (concrete CUnit test generator)
│   │   │       └── cunit_test_operation.hpp # CUnitTestOperation (CodeGenRecipe generation)
│   │   └── operation.hpp                   # RecipeOperation interface + Recipe variant (RefactorRecipe, CodeGenRecipe)
│   ├── parsing/                            # parsing layer (source → structured data)
│   │   ├── artifacts/
│   │   │   └── artifacts.hpp               # ParseResults + StructDef/FieldDef (language-agnostic parser output)
│   │   ├── clang_parser.hpp                # ClangParser (libclang integration via ClangTool)
│   │   ├── clang_parsing_rules.hpp         # ClangParsingMatcher (base class for Clang AST matchers)
│   │   ├── clang_struct_extractor.hpp      # ClangStructExtractor (AST traversal for structs)
│   │   ├── clang_struct_parsing_rule.hpp   # ClangStructParsingRule (Clang AST matching implementation)
│   │   ├── parser.hpp                      # ParsingRuleAdapter interface (language-agnostic parser interface)
│   │   └── parsing_requirements.hpp        # ParsingRequirements (what operations need from parser)
│   ├── pipeline/                           # pipeline layer (orchestrates parse → execute → transmute)
│   │   ├── pipeline.hpp                    # stateless pipeline functions (runParser, executeOperations, transmute, transmuteAllRecipes, execute)
│   │   └── preflight_validator.hpp         # pre-flight validation (validates files before transmutation)
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
│   │                                       # - detail::createOutputDir: helper to create output directories
│   │                                       # - detail::validateFeature<T>: template for feature validation via traits
│   ├── files/
│   │   └── discovery.cpp                   # file discovery implementation with threading support
│   │                                       # - detail::findCommonAncestor: finds common ancestor directory from paths
│   │                                       # - buildDiscovery: builds DiscoveryConfig from patterns
│   │                                       # - findCandidateFiles: collects files with target extensions
│   │                                       # - compilePatterns: pre-compiles glob patterns to regex
│   │                                       # - discoverFiles: main discovery with threading
│   ├── operations/
│   │   └── recipes/
│   │       ├── refactoring/
│   │       │   └── struct_alignment_operation.cpp  # StructAlignmentOperation implementation
│   │       │                               # - detail::calculatePercentage: safe percentage calculation
│   │       │                               # - computeCacheMetrics: computes SPLC score, cache waste, cache util
│   │       │                               # - computeCacheLine: computes lcm-based cache line multiple
│   │       │                               # - computeOptimizedSize: simulates memory layout for optimization
│   │       │                               # - sortFieldsForOptimalAlignment: reorders fields by alignment
│   │       └── codegen/
│   │           ├── cunit_generator.cpp     # CUnitGenerator stub implementation
│   │           └── cunit_test_operation.cpp # CUnitTestOperation stub implementation
│   ├── parsing/
│   │   ├── clang_parser.cpp                # ClangParser implementation (ClangTool runner)
│   │   ├── clang_struct_extractor.cpp      # ClangStructExtractor implementation (AST callbacks)
│   │   └── clang_struct_parsing_rule.cpp   # ClangStructParsingRule implementation (field extraction)
│   ├── pipeline/
│   │   ├── pipeline.cpp                    # pipeline functions (requirement gathering, operation execution, transmutation)
│   │   │                                   # - gatherRequirements: collects parsing requirements from operations
│   │   │                                   # - runParser: executes parser based on requirements
│   │   │                                   # - executeOperations: runs all operations on artifacts
│   │   │                                   # - transmute: applies recipes to files (extracted helper)
│   │   │                                   # - transmuteAllRecipes: orchestrates pre-flight validation + transmutation
│   │   │                                   # - execute: full pipeline orchestration
│   │   └── preflight_validator.cpp         # pre-flight validation implementation
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
│   ├── unit/                               # unit tests (172 tests)
│   │   ├── test_app_context.cpp            # AppConfig tests (configuration types) - 10 tests
│   │   ├── test_clang_parser.cpp           # ClangParser tests - 7 tests
│   │   ├── test_clang_struct_extractor.cpp # ClangStructExtractor tests - 9 tests
│   │   ├── test_clang_struct_parsing_rule.cpp # ClangStructParsingRule tests - 6 tests
│   │   ├── test_cli.cpp                    # CLI validation tests (black-box via Validator::validate) - 35 tests
│   │   ├── test_core_types.cpp             # Result<T> monad tests - 6 tests
│   │   ├── test_discovery.cpp              # file discovery tests - 18 tests (includes helper function tests)
│   │   │                                   # - buildDiscovery tests for findCommonAncestor behavior
│   │   │                                   # - extension extraction, recursive search detection
│   │   ├── test_pipeline.cpp               # pipeline function tests - 36 tests
│   │   │                                   # - executeOperations, transmuteAllRecipes, execute
│   │   │                                   # - pre-flight validation tests
│   │   ├── test_salign_pipeline.cpp        # salign operation tests - 21 tests
│   │   ├── test_struct_alignment_operation.cpp # struct alignment operation tests - 18 tests
│   │   │                                   # - computeCacheLine, computeOptimizedSize API tests
│   │   │                                   # - helper function tests: calculatePercentage, computeCacheMetrics
│   │   └── test_transmute.cpp              # transmutation tests (+ codegen stubs) - 6 tests
│   ├── integration/                        # integration tests (14 tests - end-to-end)
│   │   └── test_salign.cpp                 # salign end-to-end tests (includes pre-flight validation)
│   ├── performance/                        # performance benchmarks
│   │   ├── baseline.md                     # performance baseline documentation
│   │   ├── test_salign.cpp                 # basic performance tests
│   │   ├── test_salign_complexity.cpp      # complexity scaling tests
│   │   ├── test_salign_parsing.cpp         # parsing performance tests
│   │   ├── test_salign_realistic.cpp       # realistic workload tests
│   │   └── test_salign_stress.cpp          # stress tests
│   ├── utils.hpp                           # test utilities (createCliInputs, mock helpers, createRecipe, etc.)
│   ├── utils.cpp                           # test utilities implementation
│   └── CMakeLists.txt                      # test build configuration
├── design/                                 # architecture documentation
│   ├── ARCHITECTURE_AUDIT_2025.md          # comprehensive architecture audit
│   ├── CLI_IDEA_LAND.md                    # CLI design exploration
│   ├── alchemy-architecture.dot            # graphviz architecture diagram
│   ├── alchemy-dev-v1.md                   # v1 development notes
│   ├── alchemy-dev-v2.md                   # v2 development roadmap (current: v2.6)
│   ├── component-diagrams.md               # component architecture (current: v2.4)
│   ├── plugin-architecture.md              # future plugin system design
│   └── sequence-diagrams.md                # interaction flows (current: v2.4)
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
  ↓           - Gathers parsing requirements from operations
  ↓           - Runs parser to produce parser::artifacts::ParseResults
  ↓           - Executes operations (pass artifacts by const ref)
  ↓           - Transmutes recipes
  ↓           - Returns results + metrics (no I/O)
  ↓
parsing/      Parsing layer - source → structured data
  ↓           - Parser implementations (ClangParser, future RustParser, etc.)
  ↓           - AST traversal and extraction (structs, functions)
  ↓           - Produces parser::artifacts::ParseResults (consumed directly by operations)
  ↓           - artifacts/: Language-agnostic data structures (StructDef, FieldDef)
  ↓
operations/   Recipe operations layer - artifacts → transformation recipes
  ↓           - RecipeOperation interface (strategy pattern)
  ↓           - recipes/refactoring/: RefactorRecipe generation (StructAlignmentOperation)
  ↓           - recipes/codegen/: CodeGenRecipe generation (CUnitTestOperation, generators)
  ↓
transmute/    Transmutation layer - recipes → file mutations
  ↓           - applyRecipes: variant dispatcher (RefactorRecipe | CodeGenRecipe)
  ↓           - applyRefactor: byte-level in-place file modifications with atomic writes (temp file + rename)
  ↓           - applyCodeGen: generate and write new files
  ↓           - Pre-flight validation: validates all files before any modifications (prevents partial success)
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
   - `operations/` generates transformation recipes from artifacts (no parsing)
   - `transmute/` applies recipes to files (writing only)
   - `reporting/` formats output (no business logic)

2. **Clear Semantic Boundaries** (v2.3 refactoring):
   - No conflation: `parsing/` creates data, `operations/` creates recipes
   - Parser artifacts (`parser::artifacts::ParseResults`) consumed directly by operations
   - `RecipeOperation` interface renamed from `ParsingOperation` (more accurate)

3. **Dependency Flow**:
   - High-level depends on low-level (app → pipeline → {parsing, operations, transmute})
   - Core types (`app/core.hpp`) used across all layers
   - Parser artifacts passed by const reference (no copying, parse once)

4. **Recent Improvements**:
   - v2.4 (Phase 4a + Phase 1.2):
     - Eliminated `ParseResults` wrapper - operations use `parser::artifacts::ParseResults` directly
     - Implemented atomic writes (temp file + rename pattern) to prevent file corruption
     - Fixed error propagation (transmute errors now fail pipeline)
     - Added pre-flight validation (validates all files before any modifications)
     - Removed redundant metrics (Data Size and Alignment - always showed "same")
   - v2.3: Split parsing/operations into `parsing/` (data extraction) and `operations/` (transformation specs)
   - v2.2: Moved metrics reporting from pipeline to app layer (separation of I/O)
   - Clear boundaries enable testability and future refactoring

## Project files

- please see the project Makefile for targets
- headers can be found under `inc/` (semantically organized by layer)
- source can be found under `src/` (mirrors inc/ structure)
- design documents under `design/`
- tests under `tests/unit` and `tests/integration` respectively
- prefer 2 spaces for indentation
- prefer spaces over tabs
- headers always follow the same include order: std, 3rd party, local
- local implementation files should always include their corresponding header first,
then all other dependencies are included below in alphabetical order

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
- header files and implementation files must have full parity -> if a function is created, it must have a header decl and an implementation -- this is a hard-requirement
  - template functions should always be implemented in the header, not in implementation files
- absolutely zero use of anonymous namespaces -- this is a hard-requirement

## Interactive Workflow Pattern

When discussing any kind of code-changes with user (refactorings, new features, bug fixes, architectural changes), follow this systematic, collaborative pattern:

**Step 1: Propose the Change**
- Provide detailed explanation of what you're proposing and why
- Explain the problem being solved or goal being achieved
- Be clear and thorough, but concise

**Step 2: Show Concrete Examples**
- Provide before/after code examples
- Show the actual code that will change
- Include usage examples where relevant
- Use real examples from the codebase when possible

**Step 3: Explain Reasoning**
- Articulate the reasons for the change
- List pros and cons explicitly
- Discuss trade-offs and design choices
- Compare alternatives if applicable
- Be honest about risks and complexities

**Step 4: User Reviews and Implements**
- Wait for user feedback and questions
- Answer clarifying questions thoroughly
- User decides what to implement
- User implements the changes themselves
- User runs tests to verify

**Step 5: Review Together**
- User shares the implementation (diff/commit)
- Review the actual implementation
- Discuss any variations from the proposal
- Ensure tests pass
- Confirm approach before moving forward

**Step 6: Iterate or Proceed**
- If changes needed, discuss and refine
- Once both parties agree, mark as complete
- Move to next item systematically
- Don't jump ahead or batch multiple changes

**Key Principles:**
- One change at a time - don't batch multiple refactorings
- User always implements - you propose and review
- Interactive discussion at every step
- No black-box implementations
- Tests must pass before proceeding
- Get explicit agreement before moving forward
- Ask good clarifying questions to understand requirements
- Be patient and thorough

## Effective Context and Exchange Pattern

**What works exceptionally well**:

1. **Concrete Example First** - Show actual code structure before discussing abstractions
2. **Design Rationale** - Explain *why* each design choice exists and what it enables
3. **Inclusive Design Process** - Ask specific questions about edge cases and implementation decisions
4. **Clear Next Steps** - Provide concrete, actionable options with clear trade-offs
5. **Collaborative Approach** - Make it the user's decision while providing reasoning and context

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
- **Error handling**: Custom Result<T> monad (see `inc/app/core.hpp`)
- **Build system**: CMake with proper dependency management
- **Current features**: --salign (struct alignment optimization), --cunit (CUnit test generation stub), --dry-run (preview without writing files)
- **Test coverage**: 172 unit tests + 14 integration tests + performance/stress tests (186 total - all passing)
- **Recent refactoring**:
  - v2.4 (Phase 4a + Phase 1.2):
    - Eliminated ParseResults wrapper - operations use parser::artifacts::ParseResults directly
    - Atomic writes with temp file + rename (prevents corruption on error)
    - Pre-flight validation (fail-fast before any file modifications)
    - Error propagation fixes (transmute errors now properly fail pipeline)
    - Metrics cleanup (removed redundant "Data Size" and "Alignment" rows)
  - v2.3: Layer reorganization (parsing/ → operations/ → transmute/)
  - v2.2: Moved metrics reporting from pipeline to app layer, zero-cost abstraction validated with valgrind
  - v2.1: Parser abstraction layer (ParsingRuleAdapter), lifecycle bug fix, zero performance regression

## Notes
- please read `pitm.md` for context on what overall software engineering practices to reinforce in my learning
