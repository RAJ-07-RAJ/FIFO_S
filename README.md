
# FIFO Design Techniques in Verilog (Synchronous FIFO)

## Overview

This repository contains **three canonical synchronous FIFO implementations in Verilog**, each using a **different full/empty detection strategy**.
The goal is to **compare design trade-offs**, demonstrate **correct RTL coding practices**, and provide **clean, reusable testbenches** for verification.

All designs are:

* Fully synchronous (single clock)
* Parameterized (DATA_WIDTH, DEPTH)
* Synthesizable
* Verified using self-checking style stimulus (safe read/write behavior)

---

## FIFO Variants Implemented

### 1. FIFO Method-1: One-Slot-Empty Technique

**Concept**

* Read and write pointers have the same width.
* Full and empty cannot be distinguished when pointers are equal.
* To avoid ambiguity, **one FIFO location is intentionally left unused**.

**Conditions**

* Empty: `w_ptr == r_ptr`
* Full : `(w_ptr + 1'b1) == r_ptr`

**Characteristics**

* Simple logic
* One memory slot wasted
* Suitable for learning and small designs
* Not space-efficient

**Files**

* `fifo_method1.v`
* `tb_fifo_method1.v`

---

### 2. FIFO Method-2: Extra MSB (Toggle Bit) Technique

**Concept**

* Pointer width is increased by **one extra MSB**.
* Lower bits address memory.
* MSB tracks wrap-around.
* Full and empty are distinguished using MSB comparison.

**Conditions**

* Empty: write pointer equals read pointer (all bits)
* Full : lower bits equal AND MSBs different

**Characteristics**

* No wasted memory
* Clean full/empty detection
* Industry-standard approach
* Scales well and forms the basis for async FIFOs

**Files**

* `fifo_method2.v`
* `tb_fifo_method2.v`

---

### 3. FIFO Method-3: Counter-Based Technique

**Concept**

* A counter explicitly tracks the number of valid entries.
* Read/write pointers only generate addresses.
* Full and empty depend entirely on counter value.

**Conditions**

* Empty: `count == 0`
* Full : `count == DEPTH`

**Characteristics**

* No wasted memory
* Very simple flag logic
* Requires **careful handling of simultaneous read/write**
* Incorrect counter updates silently break FIFO behavior

**Files**

* `fifo_method3.v`
* `tb_fifo_method3.v`

---

## Common Interface

All FIFO implementations use the **same interface** to allow easy comparison and reuse.

```verilog
input  clk
input  rst
input  wr_en
input  rd_en
input  [DATA_WIDTH-1:0] data_in

output [DATA_WIDTH-1:0] data_out
output full
output empty
```

---

## Testbench Philosophy

Each FIFO has an associated **clean, deterministic testbench** that:

* Applies a proper reset
* Never writes when FIFO is full
* Never reads when FIFO is empty
* Tests:

  * Write until full
  * Read until empty
  * Simultaneous read & write
* Generates waveform dumps for analysis

The testbenches are designed to **expose real FIFO bugs**, not mask them.

---

## How to Run Simulation

Example using **Icarus Verilog**:

```bash
iverilog fifo_method2.v tb_fifo_method2.v
vvp a.out
gtkwave fifo_method2.vcd
```

Replace filenames as needed for other FIFO variants.

---

## Comparison Summary

| Method   | Wasted Slot | Extra Logic | Reliability            | Typical Use            |
| -------- | ----------- | ----------- | ---------------------- | ---------------------- |
| Method-1 | Yes         | Low         | High                   | Learning / small FIFOs |
| Method-2 | No          | Medium      | High                   | Industry standard      |
| Method-3 | No          | Medium      | Medium (if done wrong) | Controlled designs     |

---

## Key Learning Outcomes

* Understanding ambiguity in FIFO full/empty detection
* Correct handling of simultaneous read and write operations
* Importance of pointer width and wrap-around
* Why testbench quality matters as much as RTL quality

---

## Future Extensions

* Asynchronous FIFO using Gray-coded pointers
* FIFO with assertions and formal checks
* AXI-Stream compliant FIFO wrapper
* Scoreboard-based self-checking testbench

---

## Author Notes

This repository is intended for:

* RTL/Digital Design learning
* Interview preparation
* Demonstrating FIFO design depth beyond textbook explanations

