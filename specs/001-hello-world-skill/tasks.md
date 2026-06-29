# Tasks: Hello World Skill

**Input**: Design documents from `specs/001-hello-world-skill/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/skill-contract.md](contracts/skill-contract.md), [quickstart.md](quickstart.md)

**Tests**: No dedicated automated test suite was requested. Validation tasks use the quickstart checks and repository linting.

**Organization**: Tasks are grouped by user story to enable independent implementation and validation.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel because it touches different files or only reads files
- **[Story]**: User story label for story-scoped tasks
- Every task includes an exact file path

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Confirm the existing skill package and planning inputs are in the expected locations before editing.

- [X] T001 Verify the active feature pointer in `.specify/feature.json` references `specs/001-hello-world-skill`
- [X] T002 Verify the existing skill package contains `skills/hello-world/SKILL.md` and `skills/hello-world/agents/openai.yaml`
- [X] T003 [P] Compare the local skill convention in `skills/ai-skill-template/SKILL.md` against the target skill in `skills/hello-world/SKILL.md`
- [X] T004 [P] Compare the OpenAI metadata convention in `skills/ai-skill-template/agents/openai.yaml` against `skills/hello-world/agents/openai.yaml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the shared contract that all user stories depend on.

**CRITICAL**: No user story work should begin until this phase is complete.

- [X] T005 Align `skills/hello-world/SKILL.md` frontmatter so `name: hello-world` and the description satisfy `specs/001-hello-world-skill/contracts/skill-contract.md`
- [X] T006 Align `skills/hello-world/agents/openai.yaml` so `interface.display_name`, `interface.short_description`, and `interface.default_prompt` satisfy `specs/001-hello-world-skill/contracts/skill-contract.md`
- [X] T007 [P] Review `specs/001-hello-world-skill/quickstart.md` and keep its expected file paths consistent with `skills/hello-world/SKILL.md` and `skills/hello-world/agents/openai.yaml`

**Checkpoint**: The skill package contract is ready and all user story tasks can proceed.

---

## Phase 3: User Story 1 - Run the Hello World Skill (Priority: P1) MVP

**Goal**: A Codex user can invoke `hello-world` and receive a concise, predictable greeting.

**Independent Test**: Invoke `$hello-world` and confirm the response includes "Hello, world" or an equivalent greeting without requiring setup or clarification.

### Implementation for User Story 1

- [X] T008 [US1] Update the default workflow in `skills/hello-world/SKILL.md` so a no-context invocation returns a concise hello-world greeting
- [X] T009 [US1] Update the output guidance in `skills/hello-world/SKILL.md` to prohibit credentials, network access, external accounts, and setup for the default greeting
- [X] T010 [US1] Validate the no-context behavior against the invocation contract documented in `specs/001-hello-world-skill/contracts/skill-contract.md`

**Checkpoint**: User Story 1 is independently functional and ready for MVP validation.

---

## Phase 4: User Story 2 - Understand the Skill Purpose (Priority: P2)

**Goal**: A user browsing available skills can understand that `hello-world` is a simple demonstration greeting skill.

**Independent Test**: Review `SKILL.md` and OpenAI metadata; a first-time user should identify the skill purpose in under 30 seconds.

### Implementation for User Story 2

- [X] T011 [P] [US2] Refine the skill overview in `skills/hello-world/SKILL.md` so it clearly states the skill is a minimal hello-world demonstration
- [X] T012 [P] [US2] Refine `interface.short_description` in `skills/hello-world/agents/openai.yaml` so discovery surfaces identify the skill as a hello-world demonstration
- [X] T013 [US2] Validate the discoverability wording against `specs/001-hello-world-skill/data-model.md`

**Checkpoint**: User Story 2 is independently functional and discovery text is clear.

---

## Phase 5: User Story 3 - Handle Optional User Text (Priority: P3)

**Goal**: A user can provide optional context and still receive a focused hello-world response.

**Independent Test**: Invoke `$hello-world create a minimal shell example` and confirm the response stays concise, minimal, and relevant to the requested context.

### Implementation for User Story 3

- [X] T014 [US3] Update optional-context instructions in `skills/hello-world/SKILL.md` so extra user text is tolerated without treating it as an error
- [X] T015 [US3] Update example guidance in `skills/hello-world/SKILL.md` so contextual requests still produce the smallest useful hello-world output
- [X] T016 [US3] Validate optional-context behavior against `specs/001-hello-world-skill/quickstart.md`

**Checkpoint**: User Story 3 is independently functional and optional input behavior is defined.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validate the complete feature and keep release-facing metadata consistent.

- [X] T017 [P] Run the Python metadata validation from `specs/001-hello-world-skill/quickstart.md` against `skills/hello-world/SKILL.md`
- [X] T018 [P] Run the `yq` metadata validation from `specs/001-hello-world-skill/quickstart.md` against `skills/hello-world/agents/openai.yaml`
- [X] T019 Run `make lint` using `Makefile` and resolve any shell lint findings in repository scripts
- [X] T020 Review `README.md` to confirm the existing skill distribution description remains accurate for `skills/hello-world/`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; start immediately.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the MVP.
- **User Story 2 (Phase 4)**: Depends on Foundational; can run in parallel with US1 after T005-T007.
- **User Story 3 (Phase 5)**: Depends on Foundational; can run in parallel with US1/US2 after T005-T007, but avoid same-file edit conflicts in `skills/hello-world/SKILL.md`.
- **Polish (Phase 6)**: Depends on all selected user stories being complete.

### User Story Dependencies

- **US1 (P1)**: No dependency on other stories after Foundational.
- **US2 (P2)**: No behavioral dependency on US1, but shares `skills/hello-world/SKILL.md`.
- **US3 (P3)**: No behavioral dependency on US1 or US2, but shares `skills/hello-world/SKILL.md`.

### Parallel Opportunities

- T003 and T004 can run in parallel.
- T007 can run in parallel with T005-T006 because it reads design docs and checks expected paths.
- T011 and T012 can run in parallel because they touch different files.
- T017 and T018 can run in parallel because they validate different files.

---

## Parallel Example: User Story 2

```text
Task: "T011 [P] [US2] Refine the skill overview in skills/hello-world/SKILL.md so it clearly states the skill is a minimal hello-world demonstration"
Task: "T012 [P] [US2] Refine interface.short_description in skills/hello-world/agents/openai.yaml so discovery surfaces identify the skill as a hello-world demonstration"
```

## Parallel Example: Polish

```text
Task: "T017 [P] Run the Python metadata validation from specs/001-hello-world-skill/quickstart.md against skills/hello-world/SKILL.md"
Task: "T018 [P] Run the yq metadata validation from specs/001-hello-world-skill/quickstart.md against skills/hello-world/agents/openai.yaml"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Validate `$hello-world` manually using `specs/001-hello-world-skill/quickstart.md`.
5. Stop and review before expanding discovery and optional-context behavior.

### Incremental Delivery

1. Deliver US1 to prove the skill runs and greets.
2. Deliver US2 to improve skill discovery and first-time understanding.
3. Deliver US3 to make optional user text behavior explicit.
4. Complete Phase 6 validation and linting.

### Notes

- Tasks touching `skills/hello-world/SKILL.md` should be sequenced carefully to avoid edit conflicts.
- No new scripts, dependencies, service layers, or broad scaffolding are planned.
- Commit only after reviewing the dirty worktree and staging the intended files.
