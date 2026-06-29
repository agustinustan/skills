---
name: hello-world
description: Return a concise Hello, world greeting or create the smallest useful hello-world example. Use when Codex is asked for a minimal greeting, starter snippet, smoke-test file, command, script, package, or repository integration.
---

# Hello World

## Overview

Use this as a minimal hello-world demonstration skill. Return a concise `Hello, world!` greeting by default. When the user provides a target language, runtime, framework, command, package, or repository context, create the smallest useful example that proves it works.

## Workflow

1. If the user invokes the skill with no extra context, respond with a brief greeting that includes `Hello, world!`.
2. If the user provides optional context, identify the target language, runtime, framework, command, package, or repository integration.
3. Check existing project conventions before adding or changing files.
4. Create only the smallest example that can be run directly when the user asks for an example or file.
5. Include the exact command to run it when execution instructions are useful.
6. Run the example or a syntax check when feasible.

## Output Guidelines

- For default invocations, keep the response short and complete without asking follow-up questions.
- Keep examples self-contained unless the repository already has a clear entry point.
- Use idiomatic file names for the target ecosystem, such as `hello.py`, `main.go`, `index.js`, or `src/main.rs`.
- Print or render `Hello, world!` unless the user asks for different text.
- Avoid adding dependencies for a basic hello-world example.
- Do not restructure the project or create broad scaffolding unless the user explicitly asks for a starter app.
- Do not require credentials, network access, external accounts, or project-specific setup for the default greeting behavior.
- Treat unrelated optional text as context, not as an error; keep the response focused on a minimal hello-world result.

## Examples

- "$hello-world" -> reply with a concise `Hello, world!` greeting.
- "Create a hello-world Python script" -> add a minimal script and run `python3 <file>`.
- "Make a hello-world endpoint" -> add the smallest route using the existing web framework.
- "Show me the hello-world command for this package" -> inspect package scripts and provide the shortest runnable command.
