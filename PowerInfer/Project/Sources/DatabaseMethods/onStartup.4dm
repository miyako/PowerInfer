var $PowerInfer : cs:C1710.PowerInfer

If (False:C215)
	$PowerInfer:=cs:C1710.PowerInfer.new()  //default
Else 
	var $homeFolder : 4D:C1709.Folder
	$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".PowerInfer")
	$file:=$homeFolder.file("bamboo-7b-v0.1.Q4_0.powerinfer.gguf")
	$URL:="https://huggingface.co/Tiiny/Bamboo-base-v0.1-gguf/resolve/main/bamboo-7b-v0.1.Q4_0.powerinfer.gguf"
	var $port : Integer
	$port:=8080
	
	var $event : cs:C1710.PowerInferEvent
	$event:=cs:C1710.PowerInferEvent.new()
/*
Function onError($params : Object; $error : cs._error)
Function onSuccess($params : Object)
*/
	$event.onError:=Formula:C1597(ALERT:C41($2.message))
	$event.onSuccess:=Formula:C1597(ALERT:C41(This:C1470.file.name+" loaded!"))
	
/*
chat
*/
	
	$file:=$homeFolder.file("Tiiny/Bamboo-base-v0.1-gguf")
	$URL:="https://huggingface.co/Tiiny/Bamboo-base-v0.1-gguf/resolve/main/bamboo-7b-v0.1.Q4_0.powerinfer.gguf"
	$port:=8081
	$PowerInfer:=cs:C1710.PowerInfer.new($port; $file; $URL; {\
		ctx_size: 512; \
		batch_size: 2048; \
		threads: 4; \
		threads_batch: 4; \
		log_disable: True:C214; \
		vram_budget: 4}; \
		$event)
	
End if 