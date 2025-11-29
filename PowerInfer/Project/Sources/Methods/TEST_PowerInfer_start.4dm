//%attributes = {"invisible":true}
var $powerinfer : cs:C1710.server
$powerinfer:=cs:C1710.server.new()

$isRunning:=$powerinfer.isRunning()

$file:=File:C1566(""; fk platform path:K87:2)

$powerinfer.start({\
model: $file; \
embedding: True:C214; \
ctx_size: 2048; \
batch_size: 2048; \
threads: 4; \
threads_batch: 4; \
port: 8080; vram_budget: 6})