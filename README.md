![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/PowerInfer)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/PowerInfer/total)

# PowerInfer
Local inference engine

**aknowledgements**: [SJTU-IPADS/PowerInfer](https://github.com/SJTU-IPADS/PowerInfer)

### Apple Silicon

```
cmake -S . -B build_arm -DLLAMA_METAL=ON -DLLAMA_ACCELERATE=ON
cmake --build build_arm --config Release
```

### Intel

```
cmake -S . -B build_amd -DLLAMA_ACCELERATE=ON
cmake --build build_amd --config Release
```

> [!WARNING]
> `-DLLAMA_STATIC=ON` is not applicable for macOS. You get `ld: library 'crt0.o' not found` error.

### Windows

```
cmake -S . -B build -A X64
 -DLLAMA_STATIC=ON
 -DGGML_USE_AVX2=ON
 -DLLAMA_SHARED=OFF
 -DBUILD_SHARED_LIBS=OFF
 -DGGML_IQK_FLASH_ATTENTION=OFF
 -DGGML_IQK_MOE=OFF
cmake --build build --config Release
```

> [!WARNING]
> `-DLLAMA_DIRECTML=ON` is only available on some experimental forks.
