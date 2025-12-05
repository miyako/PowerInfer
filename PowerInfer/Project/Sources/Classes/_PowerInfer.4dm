Class extends _CLI

Class constructor($command : Text; $controller : 4D:C1709.Class)
	
	If (Not:C34(OB Instance of:C1731($controller; cs:C1710._PowerInfer_Controller)))
		$controller:=cs:C1710._PowerInfer_Controller
	End if 
	
	var $program : Text
	
	Case of 
		: ($command="embedding")
			$program:="embedding"
		: ($command="quantize")
			$program:="quantize"
		: ($command="cli")
			$program:="main"
		Else 
			$program:="server"
	End case 
	
	Super:C1705($program; $controller)
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.controller.worker
	
Function terminate()
	
	This:C1470.controller.terminate()