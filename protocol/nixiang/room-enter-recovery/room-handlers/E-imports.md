# Existing imports evidence and runtime-dump scope

The analyzed input is game-runtime.bin.i64, a flat runtime dump (base 0) with no import table represented by IDA survey. The on-disk dump starts at original VA 0x10000, so absolute pointers must be translated by subtracting 0x10000; relative call destinations in this IDB are already correct file offsets.

Existing baseline evidence was read at C:/Users/24032/Desktop/code/kungfu-mock-server/research/2026-09-06/work/login-to-world/evidence/E-06-ida-imports.md. It records Client.exe imagebase 0x10000, 61 imports including Client_CT!MainFunction and KERNEL32!GetProcAddress / LoadLibraryExW / CreateFileW / WriteFile; no statically imported network/crypto APIs. This subtask operates on already captured runtime code only and does not attempt IAT repair.
