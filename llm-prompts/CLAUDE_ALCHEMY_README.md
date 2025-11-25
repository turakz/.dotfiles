# Alchemy Project Context for Claude Code

## 🚀 REQUIRED READING ON SESSION START
**Read these files in order when starting any Alchemy session:**
1. This file (CLAUDE_ALCHEMY_README.md)
2. `~/.dotfiles/llm-prompts/pitm.md` - Pedagogical principles to reinforce

---

## 🎯 Project Mission
**Alchemy** - C++ refactoring and code generation tool built on libclang/LLVM
- Analyze C source files and perform transformations (struct alignment, test generation)
- Extensible architecture for future language support (C++, Rust, Mojo etc.)
- Current version: v2.11 (Query-Driver Refactor)

---

## 🏗️ Architecture: The Mental Model

### Core Pattern: Layered Data Transformation Pipeline
```
User Input (CLI)
    ↓
App Orchestration (creates parser + operations, reports results)
    ↓
Pipeline (stateless: parse → execute → transmute)
    ↓
├─ Parsing (source files → structured data)
├─ Operations (structured data → transformation recipes)
└─ Transmute (recipes → file mutations)
```

### Key Design Patterns In Use
- **CRTP-based operations** - Static polymorphism (zero-cost abstraction)
- **Variant-based polymorphism** - `std::variant` + `std::visit` for type-safe dispatch
- **Template-based pipeline** - Enables dependency injection for testing
- **Result<T> monad** - Consistent error handling across all layers
- **Atomic writes** - Temp file + rename (prevents corruption)
- **Pre-flight validation** - Fail-fast before any file modifications

### PITM Principles Manifested
- **Testability First**: 204 unit + 33 integration tests = 237 total (all passing)
- **Loose Coupling**: Clear layer boundaries, dependency injection via templates
- **Data-Centric**: `ParseResults`, `Recipe` variants, `Metrics` flow through system
- **Design for Testability**: Can test logic without running full pipeline
- **93.4% Test Coverage**: IAR translator (query-driver refactor)

---

## 📁 Current File Structure (v2.11 - Query-Driver Refactor)

<details>
<summary>inc/ - Public Headers (click to expand)</summary>

```
inc/
├── app/
│   ├── app.hpp                  # App orchestrator (parser creation, pipeline execution, reporting)
│   ├── color.hpp                # ANSI color codes for console output
│   └── core/
│       ├── core.hpp             # Result<T> monad, Error::format()
│       └── utils/
│           └── utils.hpp        # extractVariantFrom<T>() template
├── cli/
│   └── cli.hpp                  # CLI parsing + Validator
├── config/
│   └── config.hpp               # AppConfig, SourceInventory
├── files/
│   └── discovery.hpp            # File discovery and glob expansion
├── metrics/
│   ├── metrics.hpp              # Metrics variant type
│   └── salign_metrics.hpp       # SAlignMetrics (SPLC score, cache waste, cache utilization)
├── operation/
│   ├── operation_base.hpp       # RecipeOperationBase<Derived> CRTP template
│   ├── operation.hpp            # Recipe variant, RecipeOperation variant
│   ├── codegen/
│   │   └── cuint_operation.hpp  # CUnitTestOperation (stub)
│   └── refactoring/
│       └── salign_operation.hpp # StructAlignmentOperation (struct alignment optimization)
├── parsing/
│   ├── parser.hpp               # ParsingRuleAdapter interface
│   ├── parsing_requirements.hpp # ParsingRequirements (operation parsing needs)
│   ├── artifacts/
│   │   └── artifacts.hpp        # ParseResults, StructDef, FieldDef
│   └── libclang/
│       ├── clang_parser.hpp                 # ClangParser implementation (ClangTool runner)
│       ├── clang_parsing_rules.hpp          # ClangParsingMatcher base class
│       ├── clang_struct_extractor.hpp       # ClangStructExtractor (AST traversal)
│       ├── clang_struct_parsing_rule.hpp    # ClangStructParsingRule (AST matching)
│       └── compiler_adapters/
│           ├── clang_compilation_database_adapter.hpp   # Adapter wrapping libclang CompilationDatabase
│           ├── clang_compilation_database_factory.hpp   # Factory: compiler detection → translator → adapter
│           ├── iar_database_translator.hpp              # IARDbTranslator (IAR → Clang translation)
│           │                                            # - Query-driver approach: queries actual compiler for system includes
│           │                                            # - Architecture detection: M0/M1/M3/M4/M7/M23/M33 + FPU variants
│           │                                            # - Intrinsic keyword stubs, compatibility defines
│           └── msvc_database_translator.hpp             # MSVCDbTranslator (MSVC → Clang translation)
│                                                        # - MSVC flag translation (/I → -I, /D → -D, etc.)
├── pipeline/
│   ├── pipeline.hpp             # Template-based pipeline functions
│   └── preflight_validator.hpp  # Pre-flight validation (file existence, write permissions)
├── reporting/
│   ├── metrics_reporter.hpp     # Metrics variant dispatcher
│   └── salign_reporter.hpp      # SAlignReporter (three-level display: summary, struct, field)
└── transmute/
    └── transmute.hpp            # applyRecipes, applyRefactor, applyCodeGen (atomic file writes)
```
</details>

<details>
<summary>src/ - Implementations (click to expand)</summary>

```
src/
├── main.cpp                     # Entry point
├── app/
│   └── app.cpp                  # Parser creation, pipeline execution, metrics reporting
├── cli/
│   └── cli.cpp                  # LLVM adapter + Validator implementation
│                                # - detail::createOutputDir: create output directories
│                                # - detail::validateFeature<T>: template for feature validation
├── config/
│   └── config.cpp               # sourceFilesAsStrings() implementation
├── files/
│   └── discovery.cpp            # File discovery implementation
├── operation/
│   ├── codegen/
│   │   └── cunit_operation.cpp      # *Impl() methods (stub implementation)
│   └── refactoring/
│       └── salign_operation.cpp     # *Impl() methods (executeImpl, getNameImpl, getRequirementsImpl)
│                                    # - detail::calculatePercentage: safe percentage calculation
│                                    # - detail::computeCacheMetrics: SPLC score, cache waste, cache util
│                                    # - computeCacheLine: lcm-based cache line multiple
│                                    # - computeOptimizedSize: simulates memory layout
│                                    # - sortFieldsForOptimalAlignment: reorders fields by size (descending)
├── parsing/
│   ├── artifacts/
│   │   └── artifacts.cpp            # ParseResults implementation
│   └── libclang/
│       ├── clang_parser.cpp         # ClangParser implementation (ClangTool runner)
│       ├── clang_struct_extractor.cpp # ClangStructExtractor (AST callbacks)
│       ├── clang_struct_parsing_rule.cpp # ClangStructParsingRule (field extraction)
│       └── compiler_adapters/
│           ├── clang_compilation_database_adapter.cpp  # Adapter delegates to underlying CompilationDatabase
│           ├── clang_compilation_database_factory.cpp  # Factory: compiler detection → translator → adapter
│           │                                           # - isIARCompiler(): checks for IAR flags
│           │                                           # - isMSVCCompiler(): checks for MSVC flags
│           │                                           # - fromBuildDir(): detect → translate → adapt
│           ├── iar_database_translator.cpp             # IAR → Clang translation (query-driver approach)
│           │                                           # - querySystemIncludes(): exec compiler -E -xc -v
│           │                                           # - deriveArchitectureDefines(): M0/M1/M3/M4/M7/M23/M33
│           │                                           # - getIARCompatibilityDefines(): __intrinsic, __packed stubs
│           └── msvc_database_translator.cpp            # MSVC → Clang translation
│                                                       # - translateCommand(): /I → -I, /D → -D, /TC → -x c
├── pipeline/
│   ├── pipeline.cpp             # Non-template helpers only
│   │                            # - executeTransmute: apply recipes to files
│   │                            # - validateTransmute: validate before transmutation
│   │                            # - transmute: orchestrates validation + execution
│   └── preflight_validator.cpp  # Pre-flight validation implementation
├── reporting/
│   ├── metrics_reporter.cpp         # Metrics variant dispatcher (separates by type)
│   └── salign_reporter.cpp          # SAlignReporter implementation (three-level display)
└── transmute/
    └── transmute.cpp                # Recipe variant dispatcher + type-specific functions
                                     # - applyRefactor(): apply RefactorRecipe with atomic writes
                                     # - applyCodeGen(): apply CodeGenRecipe with atomic writes
                                     # - applyRecipes(): variant dispatcher
```
</details>

<details>
<summary>tests/ - Test Structure (click to expand)</summary>

```
tests/
├── unit/                                        # 204 unit tests (mock all dependencies)
│   ├── test_app.cpp                             # App orchestrator tests
│   ├── test_cli.cpp                             # CLI validation tests - 35 tests
│   ├── test_clang_parser.cpp                    # ClangParser tests - 7 tests
│   ├── test_clang_struct_extractor.cpp          # ClangStructExtractor tests - 9 tests
│   ├── test_clang_struct_parsing_rule.cpp       # ClangStructParsingRule tests - 6 tests
│   ├── test_compilation_database_adapter.cpp    # Compiler adapter tests - 13 tests
│   │                                            # - IAR/MSVC compiler detection
│   │                                            # - Error path coverage (empty DB, invalid compiler, non-zero exit)
│   │                                            # - Architecture-specific defines (M0/M3/M33/fallback)
│   ├── test_core_types.cpp                      # Result<T> tests - 12 tests (includes rvalue tests)
│   ├── test_discovery.cpp                       # File discovery tests - 18 tests
│   ├── test_operation.cpp                       # StructAlignmentOperation tests - 23 tests
│   │                                            # - Tests public API (getRequirements, getName, operator())
│   │                                            # - Tests computeCacheLine, computeOptimizedSize helpers
│   ├── test_pipeline.cpp                        # Pipeline tests - 19 tests
│   │                                            # - Uses TestRecipeOperation variant (CRTP-based mocks)
│   │                                            # - Tests: executeOperations, runParser, execute
│   ├── test_pipeline_transmute.cpp              # Pipeline transmute integration - 14 tests
│   ├── test_preflight_validator.cpp             # Pre-flight validation tests - 17 tests
│   ├── test_salign_invariants.cpp               # SAlign invariant tests - 9 tests
│   ├── test_salign_reporter.cpp                 # SAlignReporter tests - 19 tests
│   └── test_transmute.cpp                       # Transmutation tests - 18 tests
├── integration/                                 # 33 integration tests (end-to-end)
│   ├── test_clang_parser.cpp                    # Parser integration tests - 6 tests
│   │                                            # - Realistic compilation databases (GCC/Clang/IAR/MSVC)
│   │                                            # - Mock compiler execution
│   │                                            # - Full parser pipeline with translated commands
│   └── salign/
│       ├── test_salign_errors.cpp               # Error handling and pre-flight validation
│       ├── test_salign_pipeline.cpp             # End-to-end pipeline tests
│       └── test_salign_recipes.cpp              # Recipe generation behavior
├── performance/                                 # Performance benchmarks
│   ├── baseline.md                              # Performance baseline documentation
│   ├── test_salign.cpp                          # Basic performance tests
│   ├── test_salign_complexity.cpp               # Complexity scaling tests
│   ├── test_salign_parsing.cpp                  # Parsing performance tests
│   ├── test_salign_realistic.cpp                # Realistic workload tests
│   └── test_salign_stress.cpp                   # Stress tests
├── data/
│   ├── integration/
│   │   └── salign/
│   │       └── salign_test_fixture.hpp          # Shared test fixtures for salign integration tests
│   ├── mock_compilers/                          # Mock compiler binaries for testing
│   │   ├── mock_cl.cpp                          # Mock MSVC compiler (outputs include paths)
│   │   ├── mock_iccarm.cpp                      # Mock IAR compiler (outputs include paths)
│   │   └── CMakeLists.txt                       # Build configuration for mock compilers
│   └── shared_project/                          # Shared test project for parser integration tests
│       ├── main.c
│       ├── inc/                                 # Header files (config.h, utils.h, header_only.h)
│       └── src/                                 # Source files (config.c, utils.c)
├── utils.hpp                                    # Test utilities (createCliInputs, mock helpers, createRecipe)
├── utils.cpp                                    # Test utilities implementation (createIARDatabase, createMSVCDatabase)
└── CMakeLists.txt                               # Test build configuration
```
</details>

<details>
<summary>docs/design/ - Architecture Documentation (click to expand)</summary>

```
docs/design/
├── CLI_IDEA_LAND.md                 # CLI design exploration
├── alchemy-dev-v1.md                # v1 development notes
├── alchemy-dev-v2.md                # v2 development roadmap (current: v2.11)
├── component-diagrams.md            # Component architecture (current: v2.11)
├── sequence-diagrams.md             # Interaction flows (current: v2.11)
├── compiler_translation.md          # Compilation database translation design doc
└── query_driver_and_define_impl.md # Query-driver approach documentation (v2.11)
                                     # - Explains query-driver vs stub generation
                                     # - Documents compiler querying approach
                                     # - Architecture decisions for IAR translator
```
</details>

---

## ⚙️ Hard Requirements (Non-Negotiable)

1. **Header/Implementation Parity**: Every function must have both `.hpp` declaration AND `.cpp` definition
   - Exception: Template functions (always in headers)

2. **No Anonymous Namespaces**: Zero usage, anywhere

3. **Fully Qualified Names**: No namespace aliases in implementation files
   - Use `alchemy::core::Result`, not `using namespace` or aliases

4. **Template Functions in Headers**: Never in `.cpp` files

5. **Include Order**: Always `std → 3rd party → local`
   - Implementation files include their header first, then dependencies alphabetically

6. **Unit Tests Mock Dependencies When Reasonable**: Prefer component isolation, test API contracts only
   - Unit tests verify inputs → outputs (contract testing), edge cases, error paths, exceptions thrown
   - Integration tests verify component behavior (functionality testing) -> this can be a component in isolation or end-to-end

7. **Explicit Newlines**: `fmt::print` doesn't add them - include `\n` explicitly

8. **Documentation-Driven Decision Making**: Base all technical claims on verified facts, not probabilistic guessing
   - **Consult official documentation** before making claims about compiler flags, language features, or library behavior
   - **State uncertainty explicitly** when you don't know something ("I don't know which flags overlap - let me check the documentation")
   - **Verify assumptions** with searches or empirical tests rather than guessing based on probability
   - **Push back only with evidence** - disagree with concrete facts/documentation, not just confidence
   - **No speculation** - "GCC might support this" should be "Let me check the GCC documentation to verify"
   - **Transparency over correctness** - admitting uncertainty is better than misleading with confident guesses

---

## 🤝 How We Work Together

### The 6-Step Interactive Workflow
When proposing ANY code change (refactoring, feature, bug fix):

1. **Propose** - Detailed explanation of what and why
2. **Show Examples** - Before/after code with real examples from codebase
3. **Explain Reasoning** - Pros/cons, trade-offs, alternatives
4. **User Reviews** - User decides what to implement
5. **User Implements** - User writes code, runs tests
6. **Review Together** - Discuss implementation, ensure tests pass

### Key Working Principles
- **You're my mentor, not a sycophant, not a people-pleaser** - Disagree when I'm wrong, prioritize correctness over validation
- **No black-box implementations or Agentic workflows** - Interactive, walkthrough-based design
- **Test failures = broken code first** - Examine application code before blaming tests
- **One change at a time** - No batching multiple refactorings
- **Abstractions emerge** - Don't over-engineer upfront, let patterns emerge from actual need
- **It's ok to be methodical** - Don't rush, or take short-cuts and get ahead of yourself

### What Works Best
- **Show, don't tell** - Code examples with reasoning, especially if they can be mapped to industry standards
- **Think out loud** - Share design considerations openly
- **Ask targeted questions** - Specific decisions, not vague requests
- **Connect to principles** - Explain how changes improve testability/coupling/maintainability
- **Reinforce PITM practices** - Emphasize testability, loose coupling, data-centric design

---

## 🔧 Build & Test Info

- **Build System**: CMake + Makefile targets
  - `make alchemy.debug` - Debug build
  - `make test.unit` - Run unit tests
  - `make test.integration` - Run integration tests
  - `make test.all` - Run all tests
- **Test Coverage**: 204 unit + 33 integration = 237 tests (all passing ✅)
  - Overall codebase: 89.5% line coverage
  - Compiler adapters module: 90.7% line coverage
  - IAR translator: 93.4% line coverage
- **Current Features**:
  - `--salign` - Struct alignment optimization
  - `--cunit` - CUnit test generation (stub)
  - `--dry-run` - Preview without writing files
- **Code Style**:
  - Indentation: 2 spaces, no tabs
  - Comments: Lowercase except proper nouns

---

## 📊 Recent Refactoring History (v2.x)

### Completed Major Refactorings
- **v2.11**: Query-driver refactor (IAR translator now queries actual compiler for system includes)
  - Replaced hardcoded include path assumptions with actual compiler querying
  - Added `querySystemIncludes()`: executes compiler with `-E -xc -v /dev/null` to get real paths
  - Fixed critical substring matching bug in CPU architecture detection (M33 was matching M3!)
  - Changed from `cpuArch.find("Cortex-M3")` to exact `cpuArch == "Cortex-M3"` comparison
  - Added architecture variants: M0+, M4F, M7F, M33F (FPU-enabled variants)
  - Added 4 architecture-specific tests: M0, M3, M33, fallback
  - Created mock compiler infrastructure (`mock_iccarm`, `mock_cl`) for testing
  - Test coverage improvements: 87.2% → 93.4% for IAR translator (+6.2%)
  - Overall test count: 200 → 237 tests (+37 tests)
  - Fixed `writeFile()` visibility in test fixtures (moved from private to protected)
- **v2.10**: Compiler translator refactoring (removed CRTP, simplified to stateless translators)
  - Refactored from CRTP adapter pattern to simpler translator pattern
  - IAR/MSVC translators are now stateless (no polymorphism needed)
  - Fixed IAR detection bug (removed ambiguous flags from detection logic)
  - Added CMSIS stub generation for IAR projects
- **v2.9**: Compiler adapter architecture (IAR/MSVC support via Factory + Adapter patterns)
- **v2.8**: Result<T> move optimization (rvalue overloads)
- **v2.7**: CRTP for operations + template-based pipeline
- **v2.6**: Variant extraction helper, config consolidation
- **v2.5**: Error message formatting standardization
- **v2.4**: Atomic writes, pre-flight validation, error propagation fixes
- **v2.3**: Layer reorganization (parsing/ → operations/ → transmute/)
- **v2.2**: Metrics reporting moved to app layer
- **v2.1**: Parser abstraction layer (ParsingRuleAdapter)

---

## 📚 Additional Context Files

- **~/.dotfiles/llm-prompts/pitm.md** - MUST READ: Pedagogical principles (testability, loose coupling, incremental development)
- **CURRENT_REFACTORING_CONTEXT.md** - Current refactoring state, completed work, and pending items
- **design/ARCHITECTURE_AUDIT_2025.md** - Comprehensive architecture audit with refactoring recommendations

---

## 💡 Key Architectural Insights

### Separation of Concerns (Layers)
- `app/` - I/O and orchestration (file writing, console output, metrics reporting)
- `cli/` - Command-line parsing (separate from app orchestration)
- `pipeline/` - Pure data transformation (no I/O, testable logic)
- `parsing/` - Source → structured data (no recipe generation)
- `operation/` - Structured data → transformation recipes (no parsing)
- `transmute/` - Recipes → file mutations (writing only)
- `reporting/` - Metrics output formatting (no business logic)

### Dependency Flow
- High-level depends on low-level: `app → pipeline → {parsing, operations, transmute}`
- Core types (`app/core.hpp`) used across all layers
- Parser artifacts passed by const reference (parse once, no copying)

### Testability Strategy
- **CRTP-based operations**: Structural polymorphism enables mock operations with same shape as production
- **Template-based pipeline**: Generic over operation variant type, enables dependency injection
- **Test-specific variants**: `TestRecipeOperation` contains only mocks, no production types
- **Mock operations**: CRTP-based mocks with structural parity to production operations
- **True isolation**: Unit tests mock all dependencies, test API contracts
- **Integration tests**: End-to-end tests with real components verify behavior

---

## 🎓 Learning Context (PITM Integration)

This project is a learning vehicle for applying professional embedded/systems software engineering practices:

### Core Practices Being Reinforced
1. **Design for Testability** - Structure code so logic can be tested without hardware/full system
2. **Loose Coupling** - Separate concerns with clear boundaries (layers, abstractions)
3. **Data-Centric Thinking** - Represent state in central, testable models (variants, Result<T>)
4. **Incremental Development** - Build one piece at a time, test continuously
5. **Pattern Application** - Use consistent patterns (CRTP, variant dispatch, monads)

### Cognitive Load Management Strategies
- **Externalize memory** - Write down structure before coding
- **Build incrementally** - Test each piece before moving to next
- **Mental templates** - Develop templates through repetition (3-5 implementations to internalize)
- **Copy-paste-modify** - Reuse working code structure, modify for new context

### Core Question for Every Design Decision
"Can I test this logic without running the whole system?"
