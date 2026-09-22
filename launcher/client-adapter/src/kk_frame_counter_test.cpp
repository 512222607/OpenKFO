// Executes the exact Go-generated x86 observer in an isolated test process.
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <cstdio>
#include <cstring>

int wmain(int argc, wchar_t** argv) {
    if (argc != 2) return 1;
    FILE* file = nullptr; _wfopen_s(&file, argv[1], L"rb");
    if (!file) return 2;
    unsigned char code[24]; size_t size = fread(code, 1, sizeof(code), file); fclose(file);
    if (size != sizeof(code)) return 3;
    auto memory = (unsigned char*)VirtualAlloc((void*)0x20000000, 8192, MEM_RESERVE|MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    if (!memory) return 4;
    memcpy(memory, code, sizeof(code));
    // Go tests verify the production continuation. Relocate only this final
    // jump to a RET in our allocation, avoiding the test process's low heaps.
    *(unsigned*)(memory + 20) = 0x100 - 24;
    memory[0x100] = 0xc3;
    FlushInstructionCache(GetCurrentProcess(), memory, 8192);
    auto counter = (volatile unsigned*) (memory+4096);
    unsigned cases[] = {0, 0x88760868, 1, 0, 0x88760869};
    unsigned expectedCount = 0;
    for (unsigned input : cases) {
        unsigned result, copied, flags, savedECX, savedEDX;
        __asm {
            mov eax, input
            mov ecx, 12345678h
            mov edx, 87654321h
            call memory
            mov result, eax
            mov copied, ebx
            mov savedECX, ecx
            mov savedEDX, edx
            pushfd
            pop eax
            mov flags, eax
        }
        if (input == 0) ++expectedCount;
        if (result != input || copied != input || *counter != expectedCount ||
            savedECX != 0x12345678 || savedEDX != 0x87654321 ||
            ((flags & 0x40) != 0) != (input == 0x88760868)) return 5;
    }
    puts("PASS: S_OK only; device loss excluded; registers, flags and return stack preserved");
    VirtualFree(memory, 0, MEM_RELEASE);
    return 0;
}
