# FossilPark

## START HERE

Before changing the project, read and inspect in this order:

1. [`PROJECT_MEMORY.md`](PROJECT_MEMORY.md)
2. [`AGENTS.md`](AGENTS.md)
3. [`CONTRACTS.md`](CONTRACTS.md)
4. The relevant Dev log or integration handoff
5. Current source related to the task
6. Current Git branch and status

`PROJECT_MEMORY.md` is the shared project router and continuity memory. `CONTRACTS.md` remains the authority for production schemas, enums, payloads, Remote names, and domain ownership. Chat history is not a source of truth.

## Rojo

To build the place file from scratch, use:

```bash
rojo build -o "FossilPark.rbxlx"
```

Then, open `FossilPark.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```

For more help, check out [the Rojo documentation](https://rojo.space/docs).
