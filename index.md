---
layout: default
---

![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/PowerInfer)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/PowerInfer/total)

# Use PowerInfer from 4D

#### Abstract

[PowerInfer](https://github.com/SJTU-IPADS/PowerInfer) is a highly customised inference engine based on llama.cpp. It uses a special file format (`.powerinfer.gguf`) that includes an auxiliary "predictor" model to predict which neurones to activate. This optimised mode known as "sparse inference" is said to be up to 11x faster than the standard llama.cpp which is called "dense inference" for distinction.

#### Usage

Instantiate `cs.PowerInfer.PowerInfer`  in your *On Startup* database method:

```4d
var $PowerInfer : cs.PowerInfer.PowerInfer

If (True)
    $PowerInfer:=cs.PowerInfer.PowerInfer.new()  //default
Else 
    var $modelsFolder : 4D.Folder
    $modelsFolder:=Folder(fk home folder).folder(".PowerInfer")
    $file:=$modelsFolder.file("bamboo-7b-v0.1.Q4_0.powerinfer.gguf")
    $URL:="https://huggingface.co/PowerInfer/Bamboo-base-v0.1-gguf/blob/main/bamboo-7b-v0.1.Q4_0.powerinfer.gguf"
    var $port : Integer
    $port:=8080
    $PowerInfer:=cs.PowerInfer.PowerInfer.new($port; $file; $URL; {\
    ctx_size: 2048; \
    batch_size: 2048; \
    threads: 4; \
    threads_batch: 4; \
    temp: 0.7; \
    vram_budget: 4})
End if 
```

Unless the server is alraedy running (in which case the costructor does nothing), the following procedure runs in the background:

1. The specified model is download via HTTP
2. The `server` program is started

Now you can test the server:

```
curl -X POST http://127.0.0.1:8080/v1/embeddings \
     -H "Content-Type: application/json" \
     -d '{"input":"The quick brown fox jumps over the lazy dog."}'
```

Or, use AI Kit:

```4d
var $AIClient : cs.AIKit.OpenAI
$AIClient:=cs.AIKit.OpenAI.new()
$AIClient.baseURL:="http://127.0.0.1:8080/v1"

var $text : Text
$text:="The quick brown fox jumps over the lazy dog."

var $responseEmbeddings : cs.AIKit.OpenAIEmbeddingsResult
$responseEmbeddings:=$AIClient.embeddings.create($text)
```

Finally to terminate the server:

```4d
var $PowerInfer : cs.PowerInfer.PowerInfer
$PowerInfer:=cs.PowerInfer.PowerInfer.new()
$PowerInfer.terminate()
```

#### Models

Tools to generate the predictor model is not public. You can only use pre-trained predictors from the official [Hugging Face](https://huggingface.co/PowerInfer) list of models. The "clip" models cap "outlier" neurones in the model's math. 

Official models are quite large in size. You can use the `quantize` tool to reduce the file size. 

Only a few official models are published:
|-|-:|
|Model|Size|
|[bamboo-7b-v0.1.powerinfer.gguf](https://huggingface.co/PowerInfer/Bamboo-base-v0.1-gguf/resolve/main/bamboo-7b-v0.1.powerinfer.gguf)|
`16` GB|
|[bamboo-7b-v0.1.Q4_0.powerinfer.gguf](https://huggingface.co/PowerInfer/Bamboo-base-v0.1-gguf/resolve/main/bamboo-7b-v0.1.Q4_0.powerinfer.gguf)|`4.68` GB|
|[bamboo-7b-dpo-v0.1.powerinfer.gguf](https://huggingface.co/PowerInfer/Bamboo-DPO-v0.1-gguf/resolve/main/bamboo-7b-dpo-v0.1.powerinfer.gguf)|`16` GB|
|[bamboo-7b-dpo-v0.1.Q4_0.powerinfer.gguf](https://huggingface.co/PowerInfer/Bamboo-DPO-v0.1-gguf/resolve/main/bamboo-7b-dpo-v0.1.Q4_0.powerinfer.gguf)|`4.68` GB|

#### Apple Silicon

The CLI supports a `--vram-budget` option to budget VRAM usage but this switch is not available on Apple Silicon (it is intended for CUDA). Unlike the original llama.cpp, there is no Metal optimisation yet.

#### AI Kit compatibility

The API is compatibile with [Open AI](https://platform.openai.com/docs/api-reference/embeddings). 
