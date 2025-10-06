# Design Dojo - Interactive Software Engineering Pattern Learning

## Purpose
This is an interactive learning environment where you practice identifying, understanding, and applying software design patterns.
Think of it as a "programming gym" where you build fluency with the fundamental building blocks that professional engineers use daily.

**Philosophy**: Patterns aren't academic exercises - they're practical tools for creating **testable, decoupled, maintainable** systems.
We follow principles from *Patterns in the Machine*: design for testability, abstract dependencies, and solve real problems.

## Your Learning Goal
> "I have concepts of what I need to build, but struggle to express them in code. I want fluency with established design patterns and industry
'lego blocks' so I can translate ideas into clean, maintainable implementations."

---

## Core Principles (Influenced by *Patterns in the Machine*)

### 1. **Testability First**
Every pattern we learn will be evaluated through this lens:
- Can I test this logic without running the whole system?
- Can I inject test doubles/mocks easily?
- Does this pattern make my code *more* testable or less?

### 2. **Loose Coupling via Abstraction**
Patterns should help you:
- Separate "what" from "how"
- Make dependencies explicit and replaceable
- Isolate change to minimize ripple effects

### 3. **Solve Real Maintenance Pain**
We learn patterns by recognizing problems:
- "This class knows too much about implementation details" → Abstraction layer
- "I can't test this without external dependencies" → Repository/Dependency Injection
- "Changes in one place break three other things" → Loose coupling patterns

### 4. **Incremental, Feedback-Driven Learning**
- Apply patterns to small, real problems first
- Test that the pattern actually improved things
- Iterate and refine

### 5. **Data-Centric Thinking**
Many patterns revolve around **where state lives** and **who owns it**:
- Data Model pattern - single source of truth
- Repository pattern - isolate data access
- Observer pattern - react to state changes

---

## Session Format

Each session follows this structure:

### 1. **The Problem** (5 min)
- Show concrete messy code that has the pain point
- List specific problems: testing issues, rigidity, coupling
- Make it relatable - you've seen this mess before
- **Key**: Start with pain, not pattern names

### 2. **The "Aha!" Moment** (1 min)
- Pattern explained in **one sentence**
- The core insight that makes everything click
- Example: "Encapsulate each algorithm in its own class so they can be swapped"

### 3. **Before & After** (10 min)
- Side-by-side code comparison
- **Before**: Messy, coupled, hard to test
- **After**: Clean, using the pattern
- **Testability Demo**: Show how testing improves
- **PITM Connection**: How does this enable testing without full system?

### 4. **Pattern Recognition** (5 min)
- **"You already use this!"** - Find the pattern in alchemy or familiar code
- Reinforces that patterns aren't academic - you've been using them
- Builds confidence and pattern recognition skills

### 5. **Hands-On Exercise** (15-20 min)
You'll receive **messy code** to refactor:
- Similar size/complexity to the demo (~20-30 lines)
- Clear problems that the pattern solves
- Concrete enough to code immediately
- **Bonus challenge**: Write a test showing improved testability

**Exercise Format**:
```
Here's messy code: [code block]
Problems: [specific list]
Your task: [clear refactoring goals]
Hints: [just enough to get started]
```

### 6. **Your Implementation** (your time)
- Create a sandbox/exercise directory
- Write the refactored code
- **Optional**: Write a test demonstrating testability improvement
- Paste your solution when ready

### 7. **Review & Discussion** (10 min)
- I review your implementation
- Discuss: Did pattern improve testability? Extensibility? Clarity?
- Tradeoffs: When NOT to use this pattern (avoid pattern fever!)
- Connect to other patterns and PITM principles

---

## What Makes a Good Exercise

Based on successful sessions:

### ✅ DO
- **Relatable problem** - logging, sorting, formatting (everyday tasks)
- **Clear pain points** - giant if/else, can't test, can't extend
- **~20-30 lines** - small enough to refactor in 15 minutes
- **Immediate testability win** - show test before/after
- **Find it in their code if it exists** - "you already use this in alchemy!"

### ❌ DON'T
- Abstract examples (FooFactory, BarStrategy) - use real domains
- Massive codebases - too overwhelming
- Overly simple - "just make an interface" (need real complexity)
- Skip the "why" - always show the problem first

---

## Learning Tracks

### Track 1: Pattern Catalog (Recommended for building vocabulary)
Systematic tour of essential patterns grouped by purpose.

**Each pattern taught with:**
- Traditional OOP explanation
- PITM testability perspective
- Standalone examples + optional real codebase exercises

#### Creational Patterns (How objects are made)
- **Factory Method** - Decouple object creation, enable test doubles
- **Abstract Factory** - Create families of related objects
- **Builder** - Construct complex objects step-by-step
- **Singleton** - Single instance pattern (and when to avoid it!)

#### Structural Patterns (How objects relate)
- **Adapter** - Make incompatible interfaces work together
- **Decorator** - Add behavior without modifying original
- **Facade** - Simplify complex subsystem
- **Composite** - Treat individual and collections uniformly

#### Behavioral Patterns (How objects communicate)
- **Strategy** - Encapsulate algorithms, make them swappable
- **Observer** - One-to-many notification
- **Command** - Encapsulate requests as objects
- **Template Method** - Define skeleton, let subclasses fill in details
- **Chain of Responsibility** - Pass requests along handler chain

#### Architectural Patterns (System-level organization)
- **Data Model Pattern** - Centralized, testable system state (PITM core pattern!)
- **Repository Pattern** - Separate data access from business logic
- **Dependency Injection** - Invert control, inject dependencies for testability
- **Pipeline Pattern** - Chain processing stages
- **Layered Architecture** - Separate concerns (presentation, business logic, data)

#### Thread/Concurrency/Parallelization
- **Thrad Pools**
- **Active Objects/Monitor Objects**
- **Async-Await** - Synchronization patterns and thread management.
- **Future and Producer/Consumer** - Future and Promises pattern
- **Mutexes and Semaphores** - Read/Write locks
- **Barrier Pattern**
- **Thread Safety** - Learning how to deal with and managage common pitfalls to concurrency
such as deadlocks, data-races/race-conditions, synchronization

### Track 2: Testability-First (PITM Approach)
Learn patterns by solving testability problems:

1. **"I can't test this without external dependencies"** → Dependency Injection + Mocks
2. **"This class does too many things"** → Strategy + Data Model separation
3. **"Tests are slow/flaky"** → Repository + Test Doubles
4. **"Changing one thing breaks everything"** → Loose coupling patterns
5. **"I can't simulate edge cases"** → Decorator + Stub/Fake objects

### Track 3: Problem-First (Learn patterns organically)
Real problems → discover which pattern solves them:

- **"Creating objects is getting complex"** → Factory/Builder
- **"I have similar code in 5 places"** → Template Method
- **"I need to swap implementations at runtime"** → Strategy/Adapter
- **"This function has 10 parameters"** → Builder/Parameter Object
- **"I need to notify multiple listeners"** → Observer

### Track 4: Codebase Deep Dive (Apply to your projects)
Pick a codebase (alchemy, personal project, work code, open source) and apply patterns:

- **Refactor monolithic functions** using Extract Method + patterns
- **Improve testability** using Dependency Injection
- **Add extensibility** using Strategy + Factory
- **Isolate dependencies** using Repository + Adapter
- **Pattern Detective**: Find patterns already in use

---

## How to Start a Session

### Quick Start Template
```
Design Dojo Session

Track: [Pattern Catalog | Testability-First | Problem-First | Codebase Deep Dive]
Pattern/Problem: [pattern name OR problem description]
Language: [C++ | Python | Go | TypeScript | etc.]
Context: [Standalone | Specific codebase/project]
Focus: [concept | refactoring | building from scratch | testing]
```

### Example Session Requests

**Example 1: Pure Pattern Learning (Standalone)**
```
Design Dojo - Pattern Catalog
Pattern: Strategy Pattern
Language: C++
Context: Standalone - teach me the pattern with fresh examples
Focus: Understand the concept, see before/after, then do a refactor exercise
```

**Example 2: Testability-First (Standalone)**
```
Design Dojo - Testability-First
Problem: "Code tightly coupled to file I/O - can't test easily"
Language: Python
Context: Give me a messy example to refactor
Focus: Show me the pattern that decouples this and makes it testable
```

**Example 3: Apply to Real Codebase**
```
Design Dojo - Codebase Deep Dive
Target: alchemy App::exec() method
Pattern: Dependency Injection + Extract Method
Goal: Make it more testable and maintainable
```

**Example 4: Problem-First Discovery**
```
Design Dojo - Problem-First
Problem: "I'm building a plugin system and don't know which patterns to use"
Language: C++
Focus: Help me identify the right patterns for this use case
```

**Example 5: Pattern Recognition**
```
Design Dojo - Pattern Detective
Target: [alchemy codebase | Linux kernel networking | your favorite OSS project]
Goal: Walk through code and identify patterns in use
```

---

## Exercise Modes

### Mode 1: Concept Only
- Learn the pattern conceptually
- See minimal standalone examples
- No coding required (good for first exposure)

### Mode 2: Guided Refactor
- I provide messy code (standalone, not tied to real project)
- You apply the pattern to clean it up
- I review and provide feedback

### Mode 3: Green Field
- I give you requirements
- You design and implement using the pattern
- Good for practicing "pattern selection"

### Mode 4: Real Codebase
- Apply patterns to actual projects (alchemy, your work, OSS)
- Focus on practical improvements
- Can span multiple sessions

### Mode 5: Pattern Detective
- I show you real code
- You identify which patterns are being used
- Builds "pattern recognition" skills

---

## Progress Tracking

### Current Curriculum Status
**Phase**: Not started
**Next Lesson**: Phase 1, Lesson 1 - Strategy Pattern
**Completed**: 0/18 patterns

### Patterns Learned (Curriculum Order)

#### Phase 1: Behavioral Foundations ⏳
- [ ] **1. Strategy Pattern** - Encapsulate algorithms, make them interchangeable
- [ ] **2. Template Method** - Algorithm skeleton with customizable steps
- [ ] **3. Command Pattern** - Encapsulate requests as objects

#### Phase 2: Creation Patterns ⏳
- [ ] **4. Factory Method** - Delegate object creation
- [ ] **5. Builder Pattern** - Construct complex objects step-by-step
- [ ] **6. Abstract Factory** - Create families of related objects

#### Phase 3: Structural Basics ⏳
- [ ] **7. Adapter Pattern** - Make incompatible interfaces compatible
- [ ] **8. Decorator Pattern** - Add behavior without modifying original
- [ ] **9. Facade Pattern** - Simplify complex subsystem

#### Phase 4: Advanced Behavioral ⏳
- [ ] **10. Observer Pattern** - One-to-many event notification
- [ ] **11. Chain of Responsibility** - Pass request along handler chain
- [ ] **12. State Pattern** - Object behavior changes with state

#### Phase 5: Architectural & System Design ⏳
- [ ] **13. Repository Pattern** - Separate data access logic
- [ ] **14. Dependency Injection** - Invert control, improve testability
- [ ] **15. Pipeline Pattern** - Chain processing stages

#### Phase 6: Advanced Topics ⏳
- [ ] **16. Composite Pattern** - Treat individual and collections uniformly
- [ ] **17. Proxy Pattern** - Control access to another object
- [ ] **18. Singleton Pattern** - Single instance (use sparingly!)

### Bonus Patterns (Beyond Curriculum)
- [ ] **Data Model Pattern** - Centralized system state (PITM)
- [ ] **Flyweight Pattern** - Share objects to reduce memory
- [ ] **Memento Pattern** - Capture and restore object state
- [ ] **Iterator Pattern** - Access collection elements sequentially
- [ ] **Mediator Pattern** - Centralize complex communications

### Pattern Families Mastered
- [ ] **Creational Patterns** (6 patterns: Factory, Abstract Factory, Builder, Singleton, Prototype, Object Pool)
- [ ] **Structural Patterns** (7 patterns: Adapter, Decorator, Facade, Composite, Proxy, Bridge, Flyweight)
- [ ] **Behavioral Patterns** (11 patterns: Strategy, Template Method, Command, Observer, Chain, State, Iterator, Mediator, Memento, Visitor, Interpreter)
- [ ] **Architectural Patterns** (system-level: Repository, DI, Pipeline, Layered, MVC)
- [ ] **Testing Patterns** (test doubles, fixtures, builders)

---

## PITM-Specific Practices

As we learn patterns, we'll also practice these disciplines:

### Design Practices
- **Design for Testability** - Can this run without the full system?
- **Abstract External Dependencies** - File I/O, network, hardware, etc.
- **Data-Centric State Management** - Where does state live? Who owns it?
- **Clear Module Boundaries** - Public interface vs. implementation detail

### Testing Practices
- **Unit tests without integration** - Test logic in isolation
- **Simulation/Mocking** - Replace slow/flaky dependencies
- **Test-Driven Refactoring** - Write test first, then apply pattern

### Code Organization
- **Naming Conventions** - Consistent, clear names
- **File Organization** - Logical grouping
- **Minimal Public Interfaces** - Expose only what clients need

---

## Anti-Patterns to Recognize & Avoid

### Code Smells
- **God Object** - One class that does everything
- **Long Method** - Function that does too many things
- **Feature Envy** - Method uses another class's data more than its own
- **Shotgun Surgery** - One change requires modifications in many places
- **Primitive Obsession** - Using primitives instead of small objects

### PITM Anti-Patterns
- **Tightly-Coupled Dependencies** - Logic that can't run without external systems
- **Untestable Design** - Code structured so testing requires full system
- **Hidden Dependencies** - Dependencies not visible in constructor/interface
- **Big Ball of Mud** - No clear architecture, everything coupled

### Pattern Overuse
- **Pattern Fever** - Using patterns where simple code would work
- **Premature Abstraction** - Creating interfaces before you need flexibility
- **Over-Engineering** - Adding complexity "in case we need it later"

---

## Evaluation Criteria

After applying a pattern, ask:

### Testability ✅
- Can I test this logic in isolation now?
- Can I inject test doubles easily?
- Are my tests faster/more reliable?

### Maintainability ✅
- Is the code easier to understand?
- Can I change one thing without breaking others?
- Are responsibilities clearly separated?

### Flexibility ✅
- Can I swap implementations without changing clients?
- Can I extend behavior without modifying existing code?

### Simplicity ⚠️
- Did I add necessary complexity or unnecessary abstraction?
- Is the code harder to follow now?
- Am I over-engineering?

**If a pattern fails these checks, it might be the wrong pattern or unnecessary.**

---

## Guided Curriculum Mode

### Natural Learning Progression

Patterns build on each other. This curriculum introduces them in order of:
1. **Foundational concepts** (you'll use these everywhere)
2. **Increasing complexity** (simple → advanced)
3. **Related families** (learn similar patterns together)

**Just say: "Start the curriculum" or "Next lesson"**

#### Phase 1: Behavioral Foundations (weeks 1-2)
*Start here - these teach core OOP thinking*
1. **Strategy Pattern** - Swap algorithms (most important pattern to learn first!)
2. **Template Method** - Skeleton with customizable steps
3. **Command Pattern** - Encapsulate requests as objects

#### Phase 2: Creation Patterns (weeks 3-4)
*How to create objects flexibly*
4. **Factory Method** - Delegate object creation
5. **Builder Pattern** - Construct complex objects step-by-step
6. **Abstract Factory** - Create families of related objects

#### Phase 3: Structural Basics (weeks 5-6)
*How objects relate and compose*
7. **Adapter Pattern** - Make incompatible interfaces work
8. **Decorator Pattern** - Add behavior without modifying original
9. **Facade Pattern** - Simplify complex subsystems

#### Phase 4: Advanced Behavioral (weeks 7-8)
*Sophisticated communication patterns*
10. **Observer Pattern** - Event notification system
11. **Chain of Responsibility** - Flexible request handling
12. **State Pattern** - Behavior changes with state

#### Phase 5: Architectural & System Design (weeks 9-10)
*Large-scale organization*
13. **Repository Pattern** - Isolate data access
14. **Dependency Injection** - Invert control for testability
15. **Pipeline Pattern** - Chain processing stages

#### Phase 6: Advanced Topics (weeks 11-12)
*Specialized patterns*
16. **Composite Pattern** - Treat individual/collections uniformly
17. **Proxy Pattern** - Control access to objects
18. **Singleton Pattern** - Single instance (and alternatives)

#### Phase 7: Concurrency and Multi-threading
TODO(fractals)

### Curriculum Commands

**To start or continue the curriculum:**
```
"Start the curriculum"           → Begin at Phase 1, Lesson 1 (Strategy)
"Next lesson"                    → Continue to next pattern in sequence
"What's my current lesson?"      → Show where you are in curriculum
"Skip to Phase [N]"              → Jump to a specific phase
```

**For variety:**
```
"Surprise me"                    → Random pattern you haven't learned yet
"Random beginner lesson"         → Random from Phase 1-2
"Random advanced lesson"         → Random from Phase 4-6
```

**Default settings for curriculum mode:**
- **Language**: C++ (since you're working in alchemy)
- **Context**: Standalone first, then optional real codebase application
- **Format**: Concept → Demo → Exercise → Review

*You can override these anytime: "Next lesson in Python" or "Next lesson applied to alchemy"*

---

## Quick Start Options

### Option 1: Guided Curriculum (Recommended)
```
Start the curriculum
```
I'll take you through patterns in natural learning order, tracking your progress.

### Option 2: Pick Your Own
```
Design Dojo - Pattern Catalog
Pattern: [pattern name]
Language: [C++ | Python | etc.]
Context: [Standalone | Real codebase]
```

### Option 3: Surprise Me
```
Surprise me
```
I'll pick a random pattern appropriate for your current skill level.

### Option 4: Problem-Driven
```
Design Dojo - Problem-First
Problem: [Describe your problem]
```
I'll help you identify which pattern(s) solve it.

---

## Strategies for Managing Cognitive Load

When implementing patterns, you'll juggle multiple concepts simultaneously (class hierarchies, interfaces, state management, C++ syntax).
Expert programmers don't hold all this in their head - they use external strategies.

### Strategy 1: Externalize Your Memory

Write down class responsibilities before coding. This offloads working memory.

**Example sketch:**
```
TextBuffer (receiver)
  - content: string
  - insert/delete/replace methods

Command interface
  - execute()
  - undo()

InsertTextCmd (concrete command)
  - needs: TextBuffer&, position, text
  - execute: buffer.insert()
  - undo: buffer.erase()

Editor (invoker)
  - has: TextBuffer, history vector, index
  - executeCmd()
  - undo()
  - redo()
```

Spend 2-3 minutes sketching structure before writing code. This is your external memory.

### Strategy 2: Build One Piece at a Time

Don't implement all classes before testing. Build incrementally:

**Example progression:**
```cpp
// Step 1: Just receiver + one command
TextBuffer buffer;
InsertTextCmd cmd(buffer, 0, "hello");
cmd.execute();  // test
cmd.undo();     // test

// Step 2: Add invoker with execute
Editor editor;
editor.executeCmd(...);

// Step 3: Add undo/redo
editor.undo();
editor.redo();

// Step 4: Add more command types
// Step 5: Add additional features
```

Test each piece before moving to the next. Incremental development reduces cognitive load.

### Strategy 3: Pattern Templates (Mental Models)

After 3-5 implementations, you develop mental templates. Instead of remembering every detail, you fill in blanks:

**Command Pattern Template:**
```
Components needed:
  - Command interface (execute, undo)
  - Concrete commands (store receiver ref, params, prev state)
  - Receiver (actual object being manipulated)
  - Invoker (executes commands, stores history)
```

**Fill in the blanks for your domain:**
- Receiver = `TextBuffer`
- Commands = `InsertTextCmd`, `DeleteTextCmd`, `ReplaceTextCmd`
- Invoker = `Editor`

**Fluency timeline:**
- 1st implementation: "Constantly referencing examples"
- 2nd-3rd: "Remember structure, checking details"
- 5th: "Implement from memory, checking syntax"
- 10th: "Automatic, thinking about design tradeoffs"

You build the template through repetition - it takes 3-5 implementations to internalize.

### Strategy 4: Copy-Paste-Modify

Expert programmers copy existing code constantly. After writing one concrete command, copy it for the next:

```cpp
// Write InsertTextCmd first
class InsertTextCmd : public EditorCommand {
  TextBuffer& buffer;
  size_t position;
  string text;

  void execute() override { buffer.insert(position, text); }
  void undo() override { buffer.erase(position, text.length()); }
};

// Copy structure for DeleteTextCmd
class DeleteTextCmd : public EditorCommand {
  TextBuffer& buffer;
  size_t position;
  size_t length;       // changed: store length instead of text
  string deletedText;  // changed: capture deleted text

  void execute() override {
    deletedText = buffer.substr(position, length);  // changed
    buffer.erase(position, length);
  }
  void undo() override {
    buffer.insert(position, deletedText);  // changed
  }
};
```

---

*Remember: Patterns are tools for solving problems. Every pattern should make your code more **testable, maintainable, and decoupled**. If it doesn't, you might not need that pattern.*

**Core Question**: "Can I test this logic without running the whole system?"
