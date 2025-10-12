# Claude Code Instructions for Alchemy Project

## Project Overview
**Alchemy** is a C++ refactoring and code generation tool built on libclang/LLVM.
- The goal is to create an extensible command-line tool that can analyze C source files (with later support for other source files)
and perform transformations like struct alignment optimization and boilerplate generation.
- project source locations: `inc/**/*.hpp`, `src/**/*.hpp`

## File Structure Reference
```
alchemy/
├── inc/                          # public interfaces
│   ├── analyzer.hpp              # StructAlignmentOperation (analyze + generate recipes)
│   ├── app.hpp                   # App orchestrator
│   ├── app_context.hpp           # AppContext + Metrics variant (SAlignMetrics, CmockMetrics, CppunitMetrics)
│   ├── cli.hpp                   # CLI validation architecture (Validator, CliInputs, feature traits)
│   ├── core.hpp                  # Result<T> monad + core types
│   ├── discovery.hpp             # file discovery with glob patterns
│   ├── metrics_reporter.hpp      # metrics variant dispatcher (reportMetrics)
│   ├── operation.hpp             # Operation interface + Recipe variant (RefactorRecipe, CodeGenRecipe)
│   ├── parser.hpp                # parser interface + ParsedArtifacts + ParseResults
│   ├── pipeline.hpp              # stateless pipeline functions (parse, executeOperations)
│   ├── salign_reporter.hpp       # SAlignReporter (static functions, three-level display)
│   ├── struct_parsing_rule.hpp   # StructParsingRule + StructDef + FieldDef
│   └── transmute.hpp             # transmutation interface (applyRecipes, applyRefactor, applyCodeGen)
├── src/                          # implementations
│   ├── analyzer.cpp              # StructAlignmentOperation implementation
│   ├── app.cpp                   # App orchestration (LLVM setup, pipeline execution)
│   ├── cli.cpp                   # CLI parsing (LLVM adapter + Validator implementation)
│   ├── discovery.cpp             # file discovery with threading support
│   ├── metrics_reporter.cpp      # metrics variant dispatcher (separates by type, calls reporters)
│   ├── parser.cpp                # parser implementation (runs ClangTool with parsing rules)
│   ├── pipeline.cpp              # pipeline functions (requirement gathering, operation execution)
│   ├── salign_reporter.cpp       # SAlignReporter implementation
│   ├── struct_parsing_rule.cpp   # StructParsingRule implementation (Clang AST matching)
│   └── transmute.cpp             # recipe variant dispatcher + type-specific functions
├── tests/
│   ├── unit/                     # unit tests (35 CLI + others)
│   │   ├── test_analyzer.cpp     # analyzer tests
│   │   ├── test_cli.cpp          # CLI validation tests (black-box via Validator::validate)
│   │   ├── test_discovery.cpp    # file discovery tests
│   │   ├── test_salign_pipeline.cpp  # salign operation tests
│   │   └── test_transmute.cpp    # transmutation tests (+ 4 codegen stubs)
│   ├── integration/              # 11 integration tests (bypasses CLI, uses mocking)
│   │   └── test_salign.cpp       # end-to-end salign tests
│   ├── performance/              # performance benchmarks
│   └── utils.hpp/utils.cpp       # test utilities (createCliInputs, MockBuildConfig)
├── design/                       # architecture documentation
│   ├── component-diagrams.md     # component architecture
│   ├── sequence-diagrams.md      # interaction flows
│   └── plugin-architecture.md    # future plugin system design
├── CURRENT_CONTEXT_NOTES.md      # CLI refactor documentation (semantic groups + validation)
├── main.cpp                      # entry point
├── Makefile                      # build targets (test.unit, test.integration, etc.)
└── CMakeLists.txt                # build configuration
```

## Project files

- please see the project Makefile for targets
- headers can be found under `inc/`
- source can be found under `src/`
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
- **Current scope**: C header files (.h extensions) for struct analysis
- **Architecture**: CLI (parseCli → Validator) → App → Discovery → Pipeline (parse, executeOperations) → Transmute (variant dispatchers) → Report (variant dispatchers)
- **CLI Architecture**: Semantic grouping (PathOptions, FeatureFlags, BuildConfig) + namespace-based feature traits + centralized Validator
- **Error handling**: Custom Result<T> monad (see `inc/core.hpp`)
- **Build system**: CMake with proper dependency management
- **Variant architecture**: Recipe = variant<RefactorRecipe, CodeGenRecipe>, Metrics = variant<SAlignMetrics, CmockMetrics, CppunitMetrics>
- **Static polymorphism**: std::variant + std::visit for compile-time dispatch (no vtables, zero heap allocations)
- **Current features**: --salign (struct alignment optimization), --dry-run (preview without writing files)
- **Test coverage**: unit tests (35 CLI + others) + 11 integration tests + performance/stress tests

## Notes
- please read `pitm.md` for context on what overall software engineering practices to reinforce in my learning
