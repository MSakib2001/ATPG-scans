📁 Scan-Based ATPG Project – ITC’99 b14 Viper Processor

## Overview

This project focuses on scan-based test pattern generation for the ITC’99 b14 Viper processor benchmark, performed as part of ECE 553: Testing and Testable Design of Digital Systems under Professor Azadeh Davoodi. The project is split into two phases: full scan ATPG and optimized partial scan design, both implemented using Synopsys Design Compiler and TetraMAX.

## 📌 Phase 1: Full Scan ATPG

Synthesized the b14 processor design with full scan insertion using Design Vision

Generated ATPG patterns using TetraMAX with add_faults -all to target all stuck-at faults

Explored test compression and compaction techniques (e.g., abort limit control, random vector prefill, high merge effort) to reduce pattern count

Achieved high test coverage with minimized pattern overhead

Automated the workflow using a custom tmax_fullscan.tcl and synthesis_fullscan.tcl script pair

## 📌 Phase 2: Partial Scan Optimization

Implemented a partial scan architecture with the goal of maximizing the following design quality metric:
M = TC / (A/K₁ × N/K₂ × L/K₃ × P/K₄)
where TC = test coverage, A = area, N = number of patterns, L = scan chain length, P = pin overhead

Used design exploration techniques to vary the number of scan flip-flops (K) and analyze trade-offs

Achieved superior M-value compared to full scan while keeping TC ≥ 40% and limiting to 2 scan chains

Selected scan flip-flops using testability heuristics and evaluated results via TetraMAX and Design Vision reports

## Included Files

b14_fullscan.vg, b14_pattern_fullscan.v, tmax_fullscan.tcl, etc. for full scan

b14_pscan.vg, b14_pattern_pscan.v, tmax_pscan.tcl, etc. for partial scan

Scripts for synthesis and test pattern generation

Summary reports and README with usage instructions

## Tools Used 

Synopsys Design Vision, Synopsys TetraMAX, ITC’99 b14 benchmark
## Skills Demonstrated 

ATPG, Scan Insertion, Test Compression, TCL Scripting, Design Metrics Optimization
