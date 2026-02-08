# documentation.md

## Purpose

This document defines how documentation should be written
in order to enable engineers to **understand, decide, and change systems safely**.

The goal of documentation is not to maximize information,
but to **minimize comprehension cost and decision cost**.

---

## Audience & Scope

This guideline primarily targets
**documentation intended for engineers who need to understand, make decisions, and modify systems**.

Included:
- Engineer-facing README
- Design documents
- ADRs (Architecture Decision Records)
- Operations / maintenance documentation (Runbooks)
- Handover and incident-response documentation

Explicitly excluded:
- Executive or non-technical stakeholder materials
- Marketing and promotional content

User-facing documentation (e.g., user guides, API usage guides)
should follow the principles of structure, visualization, and avoidance of implicit knowledge,
but is **not required** to explain internal design or decision rationale.

---

## Core Principles

- Documentation is written to enable decisions, not just to be read.
- Write for engineers encountering the system for the first time.
- Avoid implicit knowledge.
- Code transcription is not documentation.
- Prefer structure and visualization over long prose.

Documentation is an artifact,
and its quality must be evaluated just like code.

---

## Writing Rules

- Documentation must be concise.
- **Facts and decisions must be clearly separated.**
- Do not mix in emotions, expectations, speculation, or subjective opinions.
- Avoid expressions such as “I think”, “should be”, or “might be”.
- Do not present future plans or undecided matters as facts.

Technical documentation is not narrative or storytelling;
it is a **factual record that supports decisions and actions**.

---

## Documentation Responsibilities

Documentation is categorized by responsibility.
This guideline defines responsibilities from three perspectives.

---

### Documentation That Must Be Written

The absence of the following is considered a defect:

- README.md (engineer-facing)
- Design documents
- ADRs (Architecture Decision Records)
- Operations / maintenance documentation (Runbooks)
- Incident-response and handover documentation

These documents exist to fulfill
**accountability for design, decisions, and operations**.

---

### Documentation That Engineers Are Expected to Read

The following are expected to be read
before making changes, operating systems, or reviewing work:

- README.md
- Design documents
- ADRs
- Operations / maintenance documentation (Runbooks)
- CONTRIBUTING.md
- Security and operational policies

Proceeding without reading these documents introduces risk.

---

### Documentation That Must Be Considered for Updates on Change

When code or behavior changes,
the need to update the following must always be evaluated:

- README.md
- Design documents (when structure changes)
- ADRs (when decisions are added or revised)
- CONTRIBUTING.md (when development workflow changes)
- Operations / Runbooks (when procedures or behavior change)

Choosing not to update documentation
is itself an **explicit design decision**.

---

## Engineer-Facing README

An engineer-facing README must answer:

- What is this?
- What is within scope and out of scope?
- What changes are likely to break the system?

A README does not need to include detailed design,
but it **must include information required for safe decision-making**.

The README serves as the entry point
and a map to more detailed documentation.

---

## Design Documents

Design documents exist to explain structure
and to enable reasoning about the impact of change.

They must include:
- Component structure
- Responsibilities and data flow
- Boundaries and dependencies
- High-level failure behavior

Prefer diagrams and visual representations over prose.

---

## ADR (Architecture Decision Record)

An ADR must be created when:

- One option is chosen among multiple alternatives
- A decision is hard to reverse
- The rationale cannot be inferred from the code alone

An ADR must include at minimum:
- Context
- Options considered
- Decision taken
- Rejected options and reasons
- Conditions under which the decision should be revisited

ADRs represent
**accountability to future engineers**.

---

## Operations and Maintenance Documentation

Operations documentation exists to enable engineers
to act during both normal operation and incidents.

It must include:
- Key points for normal operation
- Initial actions during incidents
- Observability points (logs, metrics)
- Dangerous operations and cautions

---

## Documentation for Work Outside Your Domain

When working in a domain outside your expertise,
documentation must explicitly state:

- Unknowns
- Assumptions
- Provisional or temporary decisions
- Matters that should be deferred to domain experts

Documentation should serve as
**safe footing for domain experts to intervene later**.

---

## What Not to Document

The following should generally not be documented:

- Implementation details obvious from the code
- Temporary or short-lived work notes
- Copies of official tool documentation

Choosing not to document something
is part of the design decision-making process.

---

## Maintenance

- Documentation must be maintained like code.
- Update documentation when it becomes inaccurate.
- If documentation cannot be kept accurate, consider removing it.

Outdated documentation is more dangerous than no documentation.

---

## Overrides

These guidelines may be overridden only when:

- A project-specific documentation standard exists, or
- An alternative rule set is agreed upon at the team or organizational level.

In such cases, the reason and scope of the override must be documented.
