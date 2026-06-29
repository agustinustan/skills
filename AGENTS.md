# Repository Instructions

This machine is WSL with Docker Desktop integration and mise.

When you need to understand available CLI tools, run:

```bash
angkrang doctor
```

## Working Rules

- Prefer mise-managed tools and tasks.
- Use `mise run <task>` when available.
- Check `git status` before editing.
- Never expose secrets.
- Ask before deleting files, force-pushing, or running destructive commands.
- For Docker, prefer `docker compose` over legacy `docker-compose`.

## Documentation System

Documentation under `docs/` follows Diataxis and software engineering documentation principles. Put new documentation in the category that matches the reader's task:

- `docs/tutorials/`: learning-oriented walkthroughs for first-time users.
- `docs/how-to/`: task-oriented procedures for users who already know the project.
- `docs/reference/`: factual lookup material such as commands, configuration, APIs, schemas, and integration contracts.
- `docs/explanation/`: understanding-oriented material such as architecture, domain model, workflows, decisions, and tradeoffs.

Before adding or moving documentation:

1. Update `docs/README.md` when adding, renaming, or removing a documentation page.
2. Keep how-to pages procedural and outcome-focused.
3. Keep reference pages concise, exhaustive, and stable.
4. Keep explanation pages focused on context, rationale, and design constraints.
5. Do not mix tutorials, how-to procedures, reference tables, and architectural rationale in one page unless the page is explicitly an index.

## Code Discovery

This project uses codebase-memory-mcp when available. Prefer graph tools for code discovery:

1. `search_graph`
2. `trace_path`
3. `get_code_snippet`
4. `query_graph`
5. `get_architecture`

Fall back to file search for string literals, shell scripts, config files, documentation, and cases where graph results are incomplete.

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
at specs/001-hello-world-skill/plan.md
<!-- SPECKIT END -->
