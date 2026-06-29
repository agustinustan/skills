---
name: hello-world
description: Create minimal hello-world examples, starter snippets, and smoke-test files. Use when Codex is asked to demonstrate the simplest working output for a language, framework, command, script, package, or repository integration.
---

# Hello World

## Overview

Create the smallest useful example that proves a toolchain, runtime, or integration works. Prefer boring, readable output over abstractions or extra features.

## Workflow

1. Identify the target language, runtime, framework, or command from the user request or repository context.
2. Check existing project conventions before adding files.
3. Create the smallest example that can be run directly.
4. Include the exact command to run it when the user needs execution instructions.
5. Run the example or a syntax check when feasible.

## Output Guidelines

- Keep examples self-contained unless the repository already has a clear entry point.
- Use idiomatic file names for the target ecosystem, such as `hello.py`, `main.go`, `index.js`, or `src/main.rs`.
- Print or render `Hello, world!` unless the user asks for different text.
- Avoid adding dependencies for a basic hello-world example.
- Do not restructure the project or create broad scaffolding unless the user explicitly asks for a starter app.

## Examples

- "Create a hello-world Python script" -> add a minimal script and run `python3 <file>`.
- "Make a hello-world endpoint" -> add the smallest route using the existing web framework.
- "Show me the hello-world command for this package" -> inspect package scripts and provide the shortest runnable command.
