# Design Dojo Exams - Pattern Exercise Generator

## Purpose
This is an interactive learning environment where I'd like to practice identifying, understanding, and applying software design patterns.
Think of it as a "programming gym" where you help me build fluency with the fundamental building blocks that professional engineers use daily.

**Philosophy**: Patterns aren't academic exercises - they're practical tools for creating **testable, decoupled, maintainable** systems.

## My Learning Goal
> "I have concepts of what I need to build, but struggle to express them in code. I want fluency with established design patterns and industry
'lego blocks' so I can translate ideas into clean, maintainable implementations."
> "I want to get better at creating and holding abstraction in my head."
> "I want to strengthen my comfort with programming tools and debugging."

preferred languages: Modern C++17, Mojo, Python, Lua

---

This prompt defines the format for generating **self-study pattern exercises**. Each exercise is a standalone file containing:
1. Quiz questions (test understanding before coding)
2. Messy code example (needs refactoring)
3. Space for student implementation
4. Self-check criteria

**Key Goal**: Create infinitely reusable exercises by generating different messy examples for the same patterns.

---

## Exercise File Format

Each pattern gets ONE file: `scratch/inc/patterns/[pattern_name].hpp`

### Template Structure

```cpp
// [PATTERN_NAME].hpp - Self-Study Exercise
// Generated: [DATE]
//
// Instructions:
// 1. Answer quiz questions BEFORE looking at code
// 2. Read messy code and identify problems
// 3. Refactor using [Pattern Name]
// 4. Self-check: Does your code answer the quiz questions?

// ============= QUIZ (Answer BEFORE refactoring) =============
//
// UNDERSTANDING: (what/why - conceptual)

// -> generate 2-3 questions that help reinforce underlying understandings of the design pattern

// IDENTIFICATION: (recognize it in the wild)

// -> generate 2-3 questions that help reinforce how to identify when to apply the pattern in the wild

// USAGE: (what does client code look like?)

// -> generate 2-3 questions that help reinforce what usage of the pattern looks like

// IMPLEMENTATION: (details of applying it)

// -> generate 2-3 questions that help reinforce what programming or design mechanics are needed to implement it

// ============================================================

// ============= MESSY CODE (Needs Refactoring) ==============

[MESSY CODE EXAMPLE - see criteria below]

// ============================================================

// ============= YOUR REFACTORING (Implement Here) ============

// TODO: Apply [Pattern Name] to fix the code above
//
// Hints:
// - [Hint 1: what's problematic about the code]
// - [Hint 2: what makes the code hard to: [maintain|debug|extend|change]

// YOUR CODE HERE:




// ============================================================

// ============= SELF-CHECK ===================================
// After refactoring, verify:

// -> generate requirements or acceptance criteria that can be used to check solutions against
// to help user determine if they've completed the exercise

// ============================================================
```

---

## Messy Code Criteria

### Requirements (All Examples Must Have)
✅ **15-55 lines** - Small enough to refactor in 15-40 minutes
✅ **Clear pain point**
✅ **Realistic domain** - Not abstract FooBar (use games, files, networks, etc.)
✅ **Obvious need** - Pattern solves real problem, not forced
✅ **Concrete logic** - Actual code, not just comments
✅ **Single class** - Keep it focused (not whole systems)
✅ **Compiles and Runs**

### Anti-Patterns to Avoid
❌ Abstract examples (FooFactory, BarStrategy)
❌ Too simple (pattern overkill)
❌ Too complex (can't refactor in one sitting)
❌ Multiple patterns needed at once
❌ Requires domain knowledge to understand
❌ Just comments instead of actual code

### Patterns from Klaus Iglberger's "C++ Software Design"

**BEHAVIORAL PATTERNS:**
- **Strategy**: Sorting, compression, encryption, pathfinding, payment processing (classic + type-erased)
- **Command**: Undo/redo, macro recording, request queuing, transaction logs (classic + type-erased)
- **Observer**: Event systems, pub/sub, model updates, logging, notifications (classic + modern signal/slot)
- **Visitor**: AST operations, document processing, std::variant/std::visit (classic + std::visit approach)
- **Template Method (NVI)**: Game loops, data processing pipelines, algorithms with steps (via Non-Virtual Interface)

**STRUCTURAL PATTERNS:**
- **Adapter**: Third-party API wrappers, legacy code integration, format conversion, function wrappers
- **Decorator**: Text formatting, stream processing, UI components, middleware (runtime + compile-time CRTP)
- **Bridge**: Separate interface from implementation, platform abstraction, pimpl idiom
- **External Polymorphism**: Non-intrusive polymorphism for types you don't own
- **Type Erasure**: Modern C++ abstraction (any_iterator, function wrappers, std::function-like)

**CREATIONAL PATTERNS:**
- **Prototype**: Object cloning, virtual copy constructor pattern
- **Singleton**: Config managers, loggers (+ show why it's often bad and alternatives)

**MODERN C++ IDIOMS:**
- **CRTP** (Curiously Recurring Template Pattern): Static polymorphism, mixin behaviors
- **Expression Templates**: Lazy evaluation, domain-specific embedded languages

---

## Messy Code Patterns by Pattern Type

### Strategy Pattern - Messy Code Template
```cpp
class SomeProcessor {
public:
    void process(const std::string& type, Data data) {
        if (type == "variant1") {
            // algorithm 1
        }
        else if (type == "variant2") {
            // algorithm 2
        }
        else if (type == "variant3") {
            // algorithm 3
        }
    }
};
```

### Factory Pattern - Messy Code Template
```cpp
class Client {
public:
    void doSomething(const std::string& type) {
        if (type == "type1") {
            Type1* obj = new Type1();
            obj->specificSetup1();
            obj->configure();
            // use obj
            delete obj;
        }
        else if (type == "type2") {
            Type2* obj = new Type2();
            obj->specificSetup2();
            obj->configure();
            // use obj
            delete obj;
        }
    }
};
```

### Observer Pattern - Messy Code Template
```cpp
class Model {
    Data data;
    UI* ui;
    Logger* logger;
    Analytics* analytics;

    void updateData(Data newData) {
        data = newData;
        // Manual notification chain
        ui->refresh(data);
        logger->log("Data changed");
        analytics->track("update", data);
    }
};
```

### Template Method - Messy Code Template
```cpp
class Processor1 {
public:
    void process() {
        step1();
        specificStep1();  // varies
        step2();
        specificStep2();  // varies
        step3();
    }
};

class Processor2 {
public:
    void process() {
        step1();          // DUPLICATED
        specificStep1_different();  // varies
        step2();          // DUPLICATED
        specificStep2_different();  // varies
        step3();          // DUPLICATED
    }
};
```

### Decorator Pattern - Messy Code Template
```cpp
// Class explosion for feature combinations
class BasicStream { };
class EncryptedStream { };
class CompressedStream { };
class EncryptedCompressedStream { };
class BufferedStream { };
class BufferedEncryptedStream { };
class BufferedCompressedStream { };
class BufferedEncryptedCompressedStream { };
// ... exponential growth!
```

---

## Generation Rules

### When Generating a Workbook

1. **Randomize domains** - Different examples for same pattern across generations
2. **Vary complexity** - Mix beginner-friendly and moderately challenging
3. **Include tradeoffs** - Some exercises highlight pattern limitations
4. **Keep independent** - Each file is self-contained
5. **Make it runnable** - Code should compile (with stubs if needed)

### Quality Checklist (Every Exercise)

Before generating, verify:
- [ ] Domain is realistic and relatable
- [ ] Pain point is obvious (if/else, duplication, etc.)
- [ ] Hints guide without giving away answer
- [ ] Self-check ties back to quiz

---

## Canonical Pattern Structures (GoF/Refactoring Guru)

**CRITICAL**: All generated exercises MUST follow these canonical structures. Do not invent or modify the standard pattern components.

### Command Pattern
**Participants:**
1. **Receiver** - Object that performs the actual work (e.g., Editor, Light, Document)
2. **Command Interface** - Declares `execute()` and optionally `undo()` methods
3. **ConcreteCommand** - Implements Command, holds Receiver reference + parameters + undo data
4. **Invoker** - Stores and triggers commands (e.g., CommandHistory, RemoteControl)
5. **Client** - Creates commands with receiver reference, passes to Invoker

**Key Insight:** Client creates command with receiver. Invoker executes it. Receiver does the work.

**Refactoring Hints Template:**
```cpp
// Canonical Structure (from GoF/Refactoring Guru):
// 1. Receiver - Object that performs the actual work (Editor)
// 2. Command - Interface with execute() and undo() methods
// 3. ConcreteCommand - Implements Command, holds Receiver reference + parameters
// 4. Invoker - Stores and triggers commands (CommandHistory)
// 5. Client - Creates commands and configures them with Receiver (Application)
//
// Hints:
// - Keep [Receiver] simple (just mutation methods - the Receiver)
// - Create Command interface with execute() and undo()
// - [ConcreteCommands] hold reference to [Receiver] + store undo data
// - Create [Invoker] class that manages command history
// - Application creates commands with receiver reference, passes to [Invoker]
```

### Strategy Pattern
**Participants:**
1. **Context** - Maintains reference to a strategy, delegates work to it
2. **Strategy Interface** - Declares common method (e.g., `execute()`, `process()`)
3. **ConcreteStrategies** - Implement different algorithms

**Key Insight:** Client passes the desired strategy to context (not context selecting it!)

**Refactoring Hints Template:**
```cpp
// Canonical Structure (from GoF/Refactoring Guru):
// 1. Context - maintains reference to a strategy object
//    - Delegates work to the linked strategy
//    - Works with strategies through common interface
//    - Can switch strategies at runtime
// 2. Strategy Interface - declares common method (execute/process)
// 3. Concrete Strategies - implement the interface with different algorithms
//
// Key: Client passes the desired strategy to the context, not context selecting it!
```

### Factory Method Pattern
**Participants:**
1. **Product Interface** - Declares common interface for all products
2. **ConcreteProducts** - Implement the Product interface
3. **Creator** - Base class declaring factory method returning Product
4. **ConcreteCreators** - Override factory method to return specific products

**Key Insight:** Decouples product creation from usage. Enables extensibility.

**Refactoring Hints Template:**
```cpp
// Canonical Structure (from GoF/Refactoring Guru):
// 1. Product Interface - declares common interface for all products
// 2. Concrete Products - implement Product
// 3. Creator (base class) - declares factory method returning Product
//    - Can have default implementation or be abstract
//    - Contains core business logic using products
// 4. Concrete Creators - override factory method to return specific products
//
// Note: For Simple Factory (simpler variant), just create a factory class/function
//       For full Factory Method, use separate creator subclasses per product type
```

### Observer Pattern
**Participants:**
1. **Publisher/Subject** - Issues events, maintains subscriber list
2. **Observer/Subscriber Interface** - Declares notification method (e.g., `update()`)
3. **ConcreteObservers** - Implement interface, react to notifications

**Key Insight:** Observers register at runtime. Subject doesn't know concrete observer types.

**Refactoring Hints Template:**
```cpp
// Canonical Structure (from GoF/Refactoring Guru):
// 1. Publisher/Subject - issues events of interest
//    - Maintains list of subscribers/observers
//    - Provides subscribe/unsubscribe methods
//    - Notifies all subscribers when state changes
// 2. Subscriber/Observer Interface - declares notification method (update/notify)
// 3. Concrete Subscribers - implement interface, perform actions on notification
//
// Key: Observers register at runtime, subject doesn't know concrete observer types!
```

### Decorator Pattern
**Participants:**
1. **Component** - Common interface for wrappers and wrapped objects
2. **ConcreteComponent** - Basic behavior being wrapped
3. **BaseDecorator** - Has field referencing wrapped object
4. **ConcreteDecorators** - Add extra behaviors dynamically
5. **Client** - Can wrap components in multiple layers

**Key Insight:** Each decorator wraps a component and adds behavior before/after delegating.

**Refactoring Hints Template:**
```cpp
// Canonical Structure (from GoF/Refactoring Guru):
// 1. Component - common interface for wrappers and wrapped objects
// 2. Concrete Component - basic behavior being wrapped
// 3. Base Decorator - has field referencing wrapped object
// 4. Concrete Decorators - add extra behaviors dynamically
// 5. Client - can wrap components in multiple layers of decorators
//
// Key: Each decorator adds behavior before/after delegating to wrapped object
```

### Template Method Pattern
**Participants:**
1. **AbstractClass** - Defines template method + algorithm steps
   - Template method: calls steps in order (non-virtual/final)
   - Abstract steps: must be implemented by subclasses
   - Optional steps: default implementation (can override)
   - Hooks: empty optional methods
2. **ConcreteClasses** - Implement abstract steps

**Key Insight:** Algorithm structure in base class, varying steps in subclasses.

**Refactoring Hints Template:**
```cpp
// Canonical Structure (from GoF/Refactoring Guru):
// 1. Abstract Class - defines template method + algorithm steps
//    - Template method: calls steps in specific order (final/non-virtual)
//    - Abstract steps: must be implemented by subclasses
//    - Optional steps: default implementation (can be overridden)
//    - Hooks: optional empty methods
// 2. Concrete Classes - implement abstract steps
//
// Key: Template method defines skeleton, subclasses customize specific steps
```

### Adapter Pattern
**Participants:**
1. **Client Interface** - Protocol that client code uses
2. **Client** - Contains business logic using the interface
3. **Service/Adaptee** - Incompatible class (often 3rd-party/legacy)
4. **Adapter** - Implements client interface, wraps service, translates calls

**Key Insight:** Makes incompatible interfaces work together without modifying existing code.

**Refactoring Hints Template:**
```cpp
// Canonical Structure (from GoF/Refactoring Guru):
// 1. Client Interface - protocol that client code uses
// 2. Client - contains business logic using the interface
// 3. Service/Adaptee - incompatible classes (3rd-party, legacy)
// 4. Adapter - implements client interface, wraps service, translates calls
//
// Key: Adapter bridges incompatible interfaces without modifying existing code
```

### Singleton Pattern
**Participants:**
1. **Private static field** - Stores the single instance
2. **Private constructor** - Prevents direct instantiation
3. **Public static getInstance()** - Creates instance on first call (lazy init), returns it

**Key Insight:** Ensures only one instance exists. Often an anti-pattern (testing, hidden dependencies).

**Refactoring Hints Template:**
```cpp
// Canonical Structure (from GoF/Refactoring Guru):
// 1. Private static field to store the single instance
// 2. Private constructor (prevent direct instantiation)
// 3. Public static getInstance() method that:
//    - Creates instance on first call (lazy initialization)
//    - Returns same instance on subsequent calls
// 4. Delete copy constructor and assignment operator (C++11+)
//
// Anti-pattern warning: Consider dependency injection instead for testability!
```

---

## Canonical Reference Implementations

**PURPOSE**: These are the gold-standard implementations to extrapolate from when generating new exercises. Each shows the complete pattern structure with realistic code.

### Command Pattern - Reference Implementation

```cpp
// RECEIVER - performs actual work
class TextEditor {
private:
  std::string text_;

public:
  void insertAt(const std::string& str, int pos) {
    text_.insert(pos, str);
  }

  void deleteAt(int pos, int len) {
    text_.erase(pos, len);
  }

  std::string getText() const { return text_; }
};

// COMMAND INTERFACE
class Command {
public:
  virtual ~Command() = default;
  virtual void execute() = 0;
  virtual void undo() = 0;
};

// CONCRETE COMMAND - wraps receiver + params + undo data
class InsertCommand : public Command {
private:
  TextEditor& editor_;      // Reference to receiver
  std::string text_;
  int position_;
  int insertedLength_;      // For undo

public:
  InsertCommand(TextEditor& editor, const std::string& text, int pos)
    : editor_(editor), text_(text), position_(pos), insertedLength_(0) {}

  void execute() override {
    editor_.insertAt(text_, position_);
    insertedLength_ = text_.length();
  }

  void undo() override {
    editor_.deleteAt(position_, insertedLength_);
  }
};

// INVOKER - manages command history
class CommandHistory {
private:
  std::vector<std::unique_ptr<Command>> history_;
  int currentIndex_;

public:
  CommandHistory() : currentIndex_(-1) {}

  void execute(std::unique_ptr<Command> cmd) {
    // Truncate redo history
    if (currentIndex_ < static_cast<int>(history_.size()) - 1) {
      history_.erase(history_.begin() + currentIndex_ + 1, history_.end());
    }
    cmd->execute();
    history_.push_back(std::move(cmd));
    ++currentIndex_;
  }

  void undo() {
    if (currentIndex_ >= 0) {
      history_[currentIndex_]->undo();
      --currentIndex_;
    }
  }

  void redo() {
    if (currentIndex_ < static_cast<int>(history_.size()) - 1) {
      ++currentIndex_;
      history_[currentIndex_]->execute();
    }
  }
};

// CLIENT - creates commands and uses invoker
class Application {
private:
  TextEditor editor_;         // Receiver
  CommandHistory history_;    // Invoker

public:
  void run() {
    // Client creates command with receiver reference
    auto cmd = std::make_unique<InsertCommand>(editor_, "Hello", 0);

    // Pass to invoker
    history_.execute(std::move(cmd));

    // Can undo/redo
    history_.undo();
    history_.redo();
  }
};
```

### Strategy Pattern - Reference Implementation

```cpp
// STRATEGY INTERFACE
class CompressionStrategy {
public:
  virtual ~CompressionStrategy() = default;
  virtual std::string compress(const std::string& data) = 0;
  virtual std::string getAlgorithmName() const = 0;
};

// CONCRETE STRATEGIES
class GzipStrategy : public CompressionStrategy {
public:
  std::string compress(const std::string& data) override {
    return "gzip:" + data;  // Simplified
  }
  std::string getAlgorithmName() const override { return "GZIP"; }
};

class Lz4Strategy : public CompressionStrategy {
public:
  std::string compress(const std::string& data) override {
    return "lz4:" + data;   // Simplified
  }
  std::string getAlgorithmName() const override { return "LZ4"; }
};

// CONTEXT - holds strategy reference, delegates work
class FileCompressor {
private:
  std::unique_ptr<CompressionStrategy> strategy_;

public:
  // Client passes strategy to context
  FileCompressor(std::unique_ptr<CompressionStrategy> strategy)
    : strategy_(std::move(strategy)) {}

  // Can change strategy at runtime
  void setStrategy(std::unique_ptr<CompressionStrategy> strategy) {
    strategy_ = std::move(strategy);
  }

  void compressFile(const std::string& inputFile, const std::string& outputFile) {
    std::string data = readFile(inputFile);
    std::string compressed = strategy_->compress(data);  // Delegate to strategy
    writeFile(outputFile, compressed);
    std::cout << "Compressed with " << strategy_->getAlgorithmName() << "\n";
  }

private:
  std::string readFile(const std::string& f) { return "file contents"; }
  void writeFile(const std::string& f, const std::string& d) {}
};

// CLIENT - chooses strategy and passes to context
void clientCode() {
  // Client decides which strategy
  auto compressor = FileCompressor(std::make_unique<GzipStrategy>());
  compressor.compressFile("input.txt", "output.gz");

  // Switch strategy at runtime
  compressor.setStrategy(std::make_unique<Lz4Strategy>());
  compressor.compressFile("input.txt", "output.lz4");
}
```

### Factory Method Pattern - Reference Implementation

```cpp
// PRODUCT INTERFACE
class Document {
public:
  virtual ~Document() = default;
  virtual void open() = 0;
  virtual void render() = 0;
};

// CONCRETE PRODUCTS
class PDFDocument : public Document {
public:
  void open() override {
    std::cout << "Opening PDF with library initialization...\n";
  }
  void render() override {
    std::cout << "Rendering PDF pages\n";
  }
};

class WordDocument : public Document {
public:
  void open() override {
    std::cout << "Opening Word with Office interop...\n";
  }
  void render() override {
    std::cout << "Rendering Word document\n";
  }
};

// CREATOR (abstract base class)
class DocumentCreator {
public:
  virtual ~DocumentCreator() = default;

  // Factory method (abstract)
  virtual std::unique_ptr<Document> createDocument() = 0;

  // Template method using factory method
  void viewDocument(const std::string& filename) {
    auto doc = createDocument();  // Factory method call
    std::cout << "Loading: " << filename << "\n";
    doc->open();
    doc->render();
  }
};

// CONCRETE CREATORS
class PDFCreator : public DocumentCreator {
public:
  std::unique_ptr<Document> createDocument() override {
    return std::make_unique<PDFDocument>();
  }
};

class WordCreator : public DocumentCreator {
public:
  std::unique_ptr<Document> createDocument() override {
    return std::make_unique<WordDocument>();
  }
};

// CLIENT
void clientCode() {
  std::unique_ptr<DocumentCreator> creator;

  // Client chooses creator
  std::string type = "pdf";
  if (type == "pdf") {
    creator = std::make_unique<PDFCreator>();
  } else {
    creator = std::make_unique<WordCreator>();
  }

  creator->viewDocument("report.pdf");
}

// ALTERNATIVE: Simple Factory (simpler, more common)
class DocumentFactory {
public:
  static std::unique_ptr<Document> createDocument(const std::string& type) {
    if (type == "pdf") return std::make_unique<PDFDocument>();
    if (type == "word") return std::make_unique<WordDocument>();
    return nullptr;
  }
};

void simpleFactoryClient() {
  auto doc = DocumentFactory::createDocument("pdf");
  doc->open();
  doc->render();
}
```

### Observer Pattern - Reference Implementation

```cpp
// OBSERVER INTERFACE
class Observer {
public:
  virtual ~Observer() = default;
  virtual void update(float temperature) = 0;
};

// SUBJECT/PUBLISHER
class WeatherStation {
private:
  float temperature_;
  std::vector<Observer*> observers_;  // List of observers

public:
  void attach(Observer* observer) {
    observers_.push_back(observer);
  }

  void detach(Observer* observer) {
    observers_.erase(
      std::remove(observers_.begin(), observers_.end(), observer),
      observers_.end()
    );
  }

  void setTemperature(float temp) {
    temperature_ = temp;
    notify();  // Notify all observers
  }

  float getTemperature() const { return temperature_; }

private:
  void notify() {
    for (Observer* obs : observers_) {
      obs->update(temperature_);
    }
  }
};

// CONCRETE OBSERVERS
class PhoneDisplay : public Observer {
public:
  void update(float temp) override {
    std::cout << "[Phone] Temperature: " << temp << "°F\n";
  }
};

class DesktopDisplay : public Observer {
public:
  void update(float temp) override {
    std::cout << "[Desktop] Current temp: " << temp << "°F\n";
  }
};

class DataLogger : public Observer {
public:
  void update(float temp) override {
    std::cout << "[Logger] Logging: " << temp << "°F\n";
  }
};

// CLIENT
void clientCode() {
  WeatherStation station;

  // Create observers
  PhoneDisplay phone;
  DesktopDisplay desktop;
  DataLogger logger;

  // Register observers at runtime
  station.attach(&phone);
  station.attach(&desktop);
  station.attach(&logger);

  // When subject changes, all observers notified
  station.setTemperature(72.5f);

  // Can dynamically remove observers
  station.detach(&logger);
  station.setTemperature(75.0f);  // Logger won't be notified
}
```

### Decorator Pattern - Reference Implementation

```cpp
// COMPONENT INTERFACE
class Coffee {
public:
  virtual ~Coffee() = default;
  virtual std::string getDescription() const = 0;
  virtual double cost() const = 0;
};

// CONCRETE COMPONENT (basic object)
class SimpleCoffee : public Coffee {
public:
  std::string getDescription() const override {
    return "Simple coffee";
  }
  double cost() const override {
    return 2.0;
  }
};

// BASE DECORATOR
class CoffeeDecorator : public Coffee {
protected:
  std::unique_ptr<Coffee> wrappedCoffee_;  // Reference to wrapped object

public:
  CoffeeDecorator(std::unique_ptr<Coffee> coffee)
    : wrappedCoffee_(std::move(coffee)) {}

  std::string getDescription() const override {
    return wrappedCoffee_->getDescription();
  }

  double cost() const override {
    return wrappedCoffee_->cost();
  }
};

// CONCRETE DECORATORS
class MilkDecorator : public CoffeeDecorator {
public:
  MilkDecorator(std::unique_ptr<Coffee> coffee)
    : CoffeeDecorator(std::move(coffee)) {}

  std::string getDescription() const override {
    return wrappedCoffee_->getDescription() + ", milk";
  }

  double cost() const override {
    return wrappedCoffee_->cost() + 0.5;
  }
};

class SugarDecorator : public CoffeeDecorator {
public:
  SugarDecorator(std::unique_ptr<Coffee> coffee)
    : CoffeeDecorator(std::move(coffee)) {}

  std::string getDescription() const override {
    return wrappedCoffee_->getDescription() + ", sugar";
  }

  double cost() const override {
    return wrappedCoffee_->cost() + 0.3;
  }
};

class WhippedCreamDecorator : public CoffeeDecorator {
public:
  WhippedCreamDecorator(std::unique_ptr<Coffee> coffee)
    : CoffeeDecorator(std::move(coffee)) {}

  std::string getDescription() const override {
    return wrappedCoffee_->getDescription() + ", whipped cream";
  }

  double cost() const override {
    return wrappedCoffee_->cost() + 0.7;
  }
};

// CLIENT - wraps components in multiple layers
void clientCode() {
  // Simple coffee
  auto coffee = std::make_unique<SimpleCoffee>();
  std::cout << coffee->getDescription() << " = $" << coffee->cost() << "\n";

  // Wrap in decorators
  coffee = std::make_unique<MilkDecorator>(std::move(coffee));
  coffee = std::make_unique<SugarDecorator>(std::move(coffee));
  coffee = std::make_unique<WhippedCreamDecorator>(std::move(coffee));

  std::cout << coffee->getDescription() << " = $" << coffee->cost() << "\n";
  // Output: "Simple coffee, milk, sugar, whipped cream = $3.5"
}
```

### Template Method Pattern - Reference Implementation

```cpp
// ABSTRACT CLASS
class DataParser {
public:
  virtual ~DataParser() = default;

  // TEMPLATE METHOD (non-virtual, defines algorithm skeleton)
  std::vector<std::string> parse(const std::string& filename) {
    std::cout << "Opening file: " << filename << "\n";
    std::string data = readFile(filename);

    if (!validateFormat(data)) {
      std::cout << "Invalid format\n";
      return {};
    }

    // Hook: call subclass-specific parsing
    std::vector<std::string> records = parseData(data);

    // Optional hook with default implementation
    postProcess(records);

    std::cout << "Closing file\n";
    return records;
  }

protected:
  // Common steps (same for all subclasses)
  std::string readFile(const std::string& filename) {
    return "file contents";
  }

  // Abstract step (must be implemented by subclasses)
  virtual std::vector<std::string> parseData(const std::string& data) = 0;

  // Optional step with default implementation
  virtual bool validateFormat(const std::string& data) {
    return true;  // Default: accept all
  }

  // Hook (optional, empty body)
  virtual void postProcess(std::vector<std::string>& records) {
    // Default: do nothing
  }
};

// CONCRETE CLASS 1
class CSVParser : public DataParser {
protected:
  std::vector<std::string> parseData(const std::string& data) override {
    std::cout << "Parsing CSV data...\n";
    // CSV-specific parsing logic
    return {"CSV record 1", "CSV record 2"};
  }

  bool validateFormat(const std::string& data) override {
    // CSV-specific validation
    return data.find(',') != std::string::npos;
  }
};

// CONCRETE CLASS 2
class JSONParser : public DataParser {
protected:
  std::vector<std::string> parseData(const std::string& data) override {
    std::cout << "Parsing JSON data...\n";
    // JSON-specific parsing logic
    return {"JSON record 1", "JSON record 2"};
  }

  bool validateFormat(const std::string& data) override {
    // JSON-specific validation
    return data.find('{') != std::string::npos;
  }

  void postProcess(std::vector<std::string>& records) override {
    std::cout << "Post-processing JSON (removing whitespace)...\n";
  }
};

// CLIENT
void clientCode() {
  std::unique_ptr<DataParser> parser;

  parser = std::make_unique<CSVParser>();
  auto csvRecords = parser->parse("data.csv");

  parser = std::make_unique<JSONParser>();
  auto jsonRecords = parser->parse("data.json");
}
```

### Adapter Pattern - Reference Implementation

```cpp
// CLIENT INTERFACE (Target)
class MediaPlayer {
public:
  virtual ~MediaPlayer() = default;
  virtual void play(const std::string& filename) = 0;
};

// Concrete implementation of client interface
class MP3Player : public MediaPlayer {
public:
  void play(const std::string& filename) override {
    std::cout << "Playing MP3 file: " << filename << "\n";
  }
};

// SERVICE/ADAPTEE (incompatible 3rd-party class)
class AdvancedMP4Player {
public:
  void playMP4(const std::string& file) {
    std::cout << "Advanced MP4 playback: " << file << "\n";
  }
};

class LegacyAVIPlayer {
public:
  void loadAVI(const std::string& file) {
    std::cout << "Loading AVI: " << file << "\n";
  }
  void playVideo() {
    std::cout << "Playing AVI video\n";
  }
};

// ADAPTER (bridges incompatible interfaces)
class MP4Adapter : public MediaPlayer {
private:
  AdvancedMP4Player mp4Player_;  // Wraps adaptee

public:
  void play(const std::string& filename) override {
    // Translate interface
    mp4Player_.playMP4(filename);
  }
};

class AVIAdapter : public MediaPlayer {
private:
  LegacyAVIPlayer aviPlayer_;  // Wraps adaptee

public:
  void play(const std::string& filename) override {
    // Translate interface (multi-step call)
    aviPlayer_.loadAVI(filename);
    aviPlayer_.playVideo();
  }
};

// CLIENT
class AudioPlayer {
private:
  std::unique_ptr<MediaPlayer> player_;

public:
  void playMedia(const std::string& type, const std::string& filename) {
    if (type == "mp3") {
      player_ = std::make_unique<MP3Player>();
    } else if (type == "mp4") {
      player_ = std::make_unique<MP4Adapter>();  // Use adapter
    } else if (type == "avi") {
      player_ = std::make_unique<AVIAdapter>();  // Use adapter
    }

    player_->play(filename);
  }
};

void clientCode() {
  AudioPlayer player;
  player.playMedia("mp3", "song.mp3");
  player.playMedia("mp4", "video.mp4");  // Adapter translates
  player.playMedia("avi", "movie.avi");  // Adapter translates
}
```

### Singleton Pattern - Reference Implementation

```cpp
// SINGLETON (Thread-safe C++11 version)
class ConfigManager {
private:
  std::map<std::string, std::string> settings_;

  // Private constructor
  ConfigManager() {
    std::cout << "Loading config (expensive)...\n";
    settings_["db_host"] = "localhost";
    settings_["db_port"] = "5432";
  }

public:
  // Delete copy/move
  ConfigManager(const ConfigManager&) = delete;
  ConfigManager& operator=(const ConfigManager&) = delete;
  ConfigManager(ConfigManager&&) = delete;
  ConfigManager& operator=(ConfigManager&&) = delete;

  // Public static accessor (thread-safe in C++11+)
  static ConfigManager& getInstance() {
    static ConfigManager instance;  // Lazy initialization
    return instance;
  }

  std::string get(const std::string& key) {
    return settings_[key];
  }

  void set(const std::string& key, const std::string& value) {
    settings_[key] = value;
  }
};

// CLIENT
void clientCode() {
  // Access singleton
  ConfigManager& config = ConfigManager::getInstance();
  std::cout << "DB Host: " << config.get("db_host") << "\n";

  // Same instance everywhere
  ConfigManager& config2 = ConfigManager::getInstance();
  config2.set("api_key", "secret123");

  // config and config2 are the same object
  std::cout << "API Key: " << config.get("api_key") << "\n";
}

// BETTER ALTERNATIVE: Dependency Injection
class Application {
private:
  ConfigManager& config_;  // Injected dependency

public:
  Application(ConfigManager& config) : config_(config) {}

  void run() {
    std::cout << "Using " << config_.get("db_host") << "\n";
  }
};

void dependencyInjectionExample() {
  ConfigManager config;  // Regular class, no singleton
  Application app(config);  // Inject dependency
  app.run();
}
```

---

## Usage Commands

### Generate Full Workbook
```
Generate a full pattern workbook for: Strategy, Factory, Observer, Decorator,
Template Method, Command, Adapter, Singleton
```

Creates 8 files in `scratch/inc/patterns/` with unique examples.

### Regenerate for Practice (New Examples)
```
Generate a NEW pattern workbook (different examples)
```

Creates fresh exercises for the same patterns with different domains.

### Generate Single Pattern
```
Generate a [Pattern Name] exercise
```

Creates one file with quiz + messy code.

### Generate with Domain Constraint
```
Generate a Strategy Pattern exercise using video game AI
```

Creates an exercise in the specified domain.

---

## Example: Complete Strategy Pattern Exercise

```cpp
// strategy.hpp - Self-Study Exercise
// Pattern: Strategy
// Generated: 2025-10-15

// Instructions:
// 1. Answer quiz questions BEFORE looking at code
// 2. Read messy code and identify problems
// 3. Refactor using Strategy Pattern
// 4. Self-check: Does your code answer the quiz questions?

// ============= QUIZ (Answer BEFORE refactoring) =============
//
// UNDERSTANDING:
// Q1: What problem does Strategy Pattern solve? (in one sentence)
// Q2: What are the three parts of Strategy Pattern?
//
// IDENTIFICATION:
// Q3: How do you recognize when code needs Strategy?
// Q4: What are the "smells" in the messy code below?
//
// USAGE:
// Q5: In the messy code, how does the client choose which compression algorithm to use?
// Q6: After refactoring, write 2-3 lines of client code that compresses with gzip
// Q7: How does the refactored version make it easier to swap algorithms at runtime?
//
// IMPLEMENTATION:
// Q8: How would you add BrotliStrategy without modifying existing code?
// Q9: When is the algorithm chosen - compile-time or runtime? How would you change this?
// Q10: What's the difference between Strategy and just extracting functions?
//
// ============================================================

// ============= MESSY CODE (Needs Refactoring) ==============

#include <string>

class FileCompressor {
public:
  void compress(const std::string& inputFile,
                const std::string& outputFile,
                const std::string& algorithm) {
      std::string data = readFile(inputFile);

      if (algorithm == "gzip") {
          auto compressed = gzipCompress(data);
          writeFile(outputFile, compressed);
      }
      else if (algorithm == "lz4") {
          auto compressed = lz4Compress(data);
          writeFile(outputFile, compressed);
      }
      else if (algorithm == "zstd") {
          auto compressed = zstdCompress(data);
          writeFile(outputFile, compressed);
      }
  }

private:
  std::string gzipCompress(const std::string& data) {
      return "gzip:" + data;
  }
  std::string lz4Compress(const std::string& data) {
      return "lz4:" + data;
  }
  std::string zstdCompress(const std::string& data) {
      return "zstd:" + data;
  }
  std::string readFile(const std::string& filename) {
      return "file contents";
  }
  void writeFile(const std::string& filename, const std::string& data) {}
};

// ============================================================

// ============= YOUR REFACTORING (Implement Here) ============

// TODO: Apply Strategy Pattern to fix the code above
//
// Hints:
// - Create a CompressionStrategy interface with a compress() method
// - Implement GzipStrategy, Lz4Strategy, ZstdStrategy classes
// - FileCompressor should store a strategy and delegate compression to it

// YOUR CODE HERE:




// ============================================================

// ============= SELF-CHECK ===================================
// After refactoring, verify:
// ✓ Q6: Does your client code look like what you predicted?
//       (e.g., FileCompressor comp(make_unique<GzipStrategy>()))
// ✓ Q8: Can you add BrotliStrategy by creating one new class?
// ✓ Does your code have: Strategy interface + Concrete strategies + Context?
// ✓ Does it eliminate the if/else chain from Q4?
// ============================================================
```

---

## Notes

- **Spaced repetition**: Generate new workbooks weekly for review
- **Progressive difficulty**: Start with Strategy/Factory, advance to Composite/Visitor
- **Real codebase connection**: After mastering patterns, apply to alchemy refactoring
- **Help Reinforce Practical and Realistic Fluency in User**

---

**Document Version**: 1.0
**Last Updated**: 2025-10-15
**Status**: Format finalized with UNDERSTANDING/IDENTIFICATION/USAGE/IMPLEMENTATION structure
