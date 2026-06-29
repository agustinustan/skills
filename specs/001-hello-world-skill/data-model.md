# Data Model: Hello World Skill

## Skill

Represents the discoverable `hello-world` capability.

**Fields**:

- `name`: Exact skill identifier. Must be `hello-world`.
- `description`: Trigger-oriented description explaining when the skill should be used.
- `instructions`: Human-readable operational guidance for the assistant.
- `agent_metadata`: Optional per-agent display and prompt metadata.

**Validation rules**:

- `name` must match the directory name and the required identifier `hello-world`.
- `description` must identify the skill as a minimal hello-world or starter demonstration capability.
- `instructions` must define a default greeting behavior without requiring setup.
- `agent_metadata.interface.display_name` should be concise and user-facing.
- `agent_metadata.interface.short_description` should fit discovery surfaces.

## Invocation

Represents a user request to use the skill.

**Fields**:

- `requested_skill`: The skill name or trigger used by the user.
- `optional_text`: Additional user-provided context, if any.

**Validation rules**:

- `requested_skill` must resolve to `hello-world`.
- Missing `optional_text` is valid.
- Unrelated `optional_text` must not cause an error.

## Greeting Response

Represents the assistant output produced by the skill.

**Fields**:

- `greeting_text`: The visible greeting.
- `context_note`: Optional concise acknowledgement of a requested target language, runtime, framework, or integration when relevant.

**Validation rules**:

- `greeting_text` must include "Hello, world" or an equivalent clearly recognizable greeting.
- The default response must be brief enough to read in under 10 seconds.
- The response must not require credentials, network access, or project-specific setup.

## Relationships

- A `Skill` can be used by many `Invocation` instances.
- Each `Invocation` produces one `Greeting Response`.
- `agent_metadata` describes how the `Skill` appears in agent-specific discovery surfaces.

## State Transitions

```text
Unavailable -> Discoverable -> Invoked -> Greeting Returned
```

- `Unavailable`: Skill files are absent or invalid.
- `Discoverable`: Skill metadata exists and can be parsed.
- `Invoked`: User requests the skill.
- `Greeting Returned`: Assistant produces the expected greeting behavior.
