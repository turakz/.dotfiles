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
- Current version: v2.8

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
- **Testability First**: 138 unit + 21 integration tests, all with mocked dependencies
- **Loose Coupling**: Clear layer boundaries, dependency injection via templates
- **Data-Centric**: `ParseResults`, `Recipe` variants, `Metrics` flow through system
- **Design for Testability**: Can test logic without running full pipeline

---

## 📁 Current File Structure (v2.8)

<details>
<summary>inc/ - Public Headers (click to expand)</summary>

```
inc/
├── app/core/
│   ├── core.hpp                 # Result<T> monad, Error::format()
│   └── utils/
│       └── utils.hpp            # extractVariantFrom<T>() template
├── app/
│   ├── app.hpp                  # App orchestrator
│   └── color.hpp                # ANSI color codes
├── cli/
│   └── cli.hpp                  # CLI parsing + Validator
├── config/
│   └── config.hpp               # AppConfig, SourceInventory (CONSOLIDATED in refactoring #2)
├── operation/
│   ├── operation_base.hpp       # RecipeOperationBase<Derived> CRTP template
│   ├── operation.hpp            # Recipe variant, RecipeOperation variant
│   ├── refactoring/
│   │   └── salign_operation.hpp # StructAlignmentOperation
│   └── codegen/
│       └── cunit_operation.hpp  # CUnitTestOperation
├── parsing/
│   ├── artifacts/
│   │   └── artifacts.hpp        # ParseResults, StructDef, FieldDef
│   ├── parser.hpp               # ParsingRuleAdapter interface
│   ├── clang_parser.hpp         # ClangParser implementation
│   ├── clang_parsing_rules.hpp  # ClangParsingMatcher base class
│   ├── clang_struct_extractor.hpp # ClangStructExtractor (AST traversal)
│   ├── clang_struct_parsing_rule.hpp # ClangStructParsingRule (AST matching)
│   └── parsing_requirements.hpp # ParsingRequirements (operation needs)
├── pipeline/
│   ├── pipeline.hpp             # Template-based pipeline functions (NOW IN HEADER)
│   └── preflight_validator.hpp  # Pre-flight validation (validates before transmute)
├── transmute/
│   └── transmute.hpp            # applyRecipes, applyRefactor, applyCodeGen
└── reporting/
    ├── metrics_reporter.hpp     # Metrics variant dispatcher
    └── salign_reporter.hpp      # SAlignReporter (three-level display)
```
</details>

<details>
<summary>src/ - Implementations (click to expand)</summary>

```
src/
├── app/
│   └── app.cpp                  # Parser creation, pipeline execution, metrics reporting
├── cli/
│   └── cli.cpp                  # LLVM adapter + Validator implementation
│                                # - detail::createOutputDir: create output directories
│                                # - detail::validateFeature<T>: template for feature validation
├── config/
│   └── config.cpp               # sourceFilesAsStrings() implementation
├── operation/
│   ├── refactoring/
│   │   └── salign_operation.cpp # *Impl() methods (executeImpl, getNameImpl, getRequirementsImpl)
│   │                            # - detail::calculatePercentage: safe percentage calculation
│   │                            # - computeCacheMetrics: SPLC score, cache waste, cache util
│   │                            # - computeCacheLine: lcm-based cache line multiple
│   │                            # - computeOptimizedSize: simulates memory layout
│   │                            # - sortFieldsForOptimalAlignment: reorders fields
│   └── codegen/
│       └── cunit_operation.cpp  # *Impl() methods (stub implementation)
├── parsing/
│   ├── clang_parser.cpp         # ClangParser implementation (ClangTool runner)
│   ├── clang_struct_extractor.cpp # ClangStructExtractor (AST callbacks)
│   └── clang_struct_parsing_rule.cpp # ClangStructParsingRule (field extraction)
├── pipeline/
│   ├── pipeline.cpp             # Non-template helpers only
│   │                            # - executeTransmute: apply recipes to files
│   │                            # - validateTransmute: validate before transmutation
│   │                            # - transmute: orchestrates validation + execution
│   └── preflight_validator.cpp  # Pre-flight validation implementation
├── transmute/
│   └── transmute.cpp            # Recipe variant dispatcher + type-specific functions
└── reporting/
    ├── metrics_reporter.cpp     # Metrics variant dispatcher (separates by type)
    └── salign_reporter.cpp      # SAlignReporter implementation
```
</details>

<details>
<summary>tests/ - Test Structure (click to expand)</summary>

```
tests/
├── unit/                        # 138 unit tests (mock all dependencies)
│   ├── test_core_types.cpp      # Result<T> tests - 12 tests (includes rvalue tests)
│   ├── test_pipeline.cpp        # Pipeline tests - 26 tests
│   │                            # - Uses TestRecipeOperation variant (CRTP-based mocks)
│   │                            # - Tests: executeOperations, runParser, transmute, execute
│   │                            # - Includes pre-flight validation tests
│   ├── test_operation.cpp       # StructAlignmentOperation tests - 20 tests
│   │                            # - Tests public API (getRequirements, getName, operator())
│   │                            # - Tests computeCacheLine, computeOptimizedSize helpers
│   ├── test_cli.cpp             # CLI validation tests - 35 tests
│   ├── test_discovery.cpp       # File discovery tests - 18 tests
│   ├── test_clang_parser.cpp    # ClangParser tests - 7 tests
│   ├── test_clang_struct_extractor.cpp # ClangStructExtractor tests - 9 tests
│   ├── test_clang_struct_parsing_rule.cpp # ClangStructParsingRule tests - 6 tests
│   ├── test_app_context.cpp     # AppConfig tests - 10 tests
│   └── test_transmute.cpp       # Transmutation tests - 6 tests
├── integration/                 # 21 integration tests (end-to-end)
│   └── test_salign.cpp          # Salign end-to-end tests (includes pre-flight validation)
├── performance/                 # Performance benchmarks
│   ├── baseline.md              # Performance baseline documentation
│   ├── test_salign.cpp          # Basic performance tests
│   ├── test_salign_complexity.cpp # Complexity scaling tests
│   ├── test_salign_parsing.cpp  # Parsing performance tests
│   ├── test_salign_realistic.cpp # Realistic workload tests
│   └── test_salign_stress.cpp   # Stress tests
├── data/
│   └── integration/
│       ├── HelloWorld.h         # Sample struct definitions
│       └── HelloWorldEmpty.h    # Empty file test case
├── utils.hpp                    # Test utilities (createCliInputs, mock helpers, createRecipe)
├── utils.cpp                    # Test utilities implementation
└── CMakeLists.txt               # Test build configuration
```
</details>

<details>
<summary>design/ - Architecture Documentation (click to expand)</summary>

```
docs/design/
├── CLI_IDEA_LAND.md             # CLI design exploration
├── alchemy-dev-v1.md            # v1 development notes
├── alchemy-dev-v2.md            # v2 development roadmap (current: v2.8)
├── component-diagrams.md        # Component architecture (current: v2.4)
└── sequence-diagrams.md         # Interaction flows (current: v2.4)
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
- **Test Coverage**: 138 unit + 21 integration = 159 tests (all passing ✅)
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
