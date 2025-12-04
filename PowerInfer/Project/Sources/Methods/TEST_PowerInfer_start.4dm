//%attributes = {"invisible":true}
var $PowerInfer : cs:C1710.PowerInfer

If (True:C214)
	$PowerInfer:=cs:C1710.PowerInfer.new()  //default
Else 
	var $modelsFolder : 4D:C1709.Folder
	$modelsFolder:=Folder:C1567(fk home folder:K87:24).folder(".PowerInfer")
	$file:=$modelsFolder.file("bamboo-7b-v0.1.Q4_0.powerinfer.gguf")
	$URL:="https://huggingface.co/PowerInfer/Bamboo-base-v0.1-gguf/blob/main/bamboo-7b-v0.1.Q4_0.powerinfer.gguf"
	var $port : Integer
	$port:=8080
	$PowerInfer:=cs:C1710.PowerInfer.new($port; $file; $URL; {\
		ctx_size: 2048; \
		batch_size: 2048; \
		threads: 4; \
		threads_batch: 4; \
		temp: 0.7; \
		vram_budget: 4}; \
		Formula:C1597(ALERT:C41(This:C1470.file.name+($1.success ? " started!" : " did not start..."))))
End if 