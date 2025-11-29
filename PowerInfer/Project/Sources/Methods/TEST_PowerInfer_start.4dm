//%attributes = {"invisible":true}
var $powerinfer : cs:C1710.server
$powerinfer:=cs:C1710.server.new()

$isRunning:=$powerinfer.isRunning()

$file:=File:C1566("Macintosh HD:Users:miyako:Documents:GitHub:PowerInfer:models:bamboo-7b-v0.1.Q4_0.powerinfer.gguf"; fk platform path:K87:2)

$powerinfer.start({\
model: $file; \
embedding: True:C214; \
ctx_size: 2048; \
batch_size: 2048; \
threads: 4; \
threads_batch: 4; \
port: 8080; vram_budget: 16})