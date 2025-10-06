# Claude Code Instructions for Alchemy Project

## Project Overview
**Alchemy** is a C++ refactoring and code generation tool built on libclang/LLVM.
- The goal is to create an extensible command-line tool that can analyze C source files (with later support for other source files)
and perform transformations like struct alignment optimization and boilerplate generation.
- project source locations: `inc/**/*.hpp`, `src/**/*.hpp`

## File Structure Reference
```
alchemy/
├── inc/                          # Public interfaces
│   ├── analyzer.hpp              # Pipeline interface + StructAlignmentPipeline
│   ├── app.hpp                   # App orchestrator
│   ├── cli.hpp                   # CLI interface
│   ├── clang_tool_factory.hpp    # ClangTool creation (unused in v1.0)
│   ├── core.hpp                  # Result<T> and core types
│   ├── datamodel.hpp             # DataModel + SAlignMetrics
│   ├── discovery.hpp             # File discovery
│   ├── metrics_reporter.hpp      # Reporter<T> interface
│   ├── parsing_requirements.hpp  # ParsingRequirements struct
│   ├── parsing_rule.hpp          # ParsingRule base (unused in v1.0)
│   ├── rule_registry.hpp         # Rule registry (unused in v1.0)
│   ├── salign_reporter.hpp       # SAlignReporter implementation
│   ├── struct_parsing_rule.hpp   # StructParsingRule + StructDef + FieldDef
│   └── transmute.hpp             # Transmutation interface
├── src/                          # Implementations
│   ├── analyzer.cpp              # StructAlignmentPipeline implementation
│   ├── app.cpp                   # App orchestration
│   ├── cli.cpp                   # CLI parsing
│   ├── datamodel.cpp             # DataModel methods
│   ├── discovery.cpp             # File discovery implementation
│   ├── salign_reporter.cpp       # SAlignReporter implementation
│   ├── struct_parsing_rule.cpp   # StructParsingRule implementation
│   └── transmute.cpp             # Transmutation implementation
├── tests/
│   ├── unit/                     # 68 unit tests
│   ├── integration/              # 9 integration tests
│   └── utils.hpp/utils.cpp       # Shared test utilities
├── design/                       # Architecture documentation
│   ├── alchemy-dev-v1.md         # This document
│   ├── component-diagrams.md     # Component architecture diagrams
│   ├── sequence-diagrams.md      # Interaction flows
│   └── plugin-architecture.md    # Future plugin system design
├── main.cpp                      # Entry point
└── CMakeLists.txt                # Build configuration
```


## Workflow Rules
- always confirm with me whenever we write, modify, or delete
- i don't want an agentic workflow where you're a black-box, i prefer interactive and walk-through based design, discussions, with demonstrations, examples, concepts explained, reasoning,
and other generated responses so that i can review them and contribute
- you're not a sycophant, or a people-pleaser, you're a professional software engineer who is my mentor and capable of giving me feedback or disagreeing
- we work together for the sake of correctness and quality, not just to make me happy as a user arbitrarily
- prefer lowercase in code comments except for proper nouns

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
- **Architecture**: App Orchestrator → Discovery → Parsing → Analysis → Recipes -> Transmutation pipelines
- **Error handling**: Custom Result<T> type (see `inc/core.hpp`)
- **Build system**: CMake with proper dependency management
- **Plugin System**: Available in `inc/analyzer.hpp` (future extensibility option, ignore for now)

## Project files

- please see the Makefile for targets
- headers can be found under `inc/`
- source can be found under `src/`
- design documents under `design/`
- tests under `tests/unit` and `tests/integration` respectively
- prefer 2 spaces for indentation
- prefer spaces over tabs

note: please read `pitm.md` for context on what overall software engineering practices to reinforce in my learning
