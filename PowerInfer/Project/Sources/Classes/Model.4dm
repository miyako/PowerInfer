property URL : Text
property method : Text
property headers : Object
property dataType : Text
property automaticRedirections : Boolean
property file : 4D:C1709.File
property options : Object
property _onResponse : 4D:C1709.Function
property _fileHandle : 4D:C1709.FileHandle
property returnResponseBody : Boolean
property decodeData : Boolean
property range : Object
property bufferSize : Integer

Class constructor($port : Integer; $file : 4D:C1709.File; $URL : Text; $options : Object; $formula : 4D:C1709.Function)
	
	This:C1470.file:=$file
	This:C1470.URL:=$URL
	This:C1470.method:="GET"
	This:C1470.headers:={Accept: "application/vnd.github+json"}
	This:C1470.dataType:="blob"
	This:C1470.automaticRedirections:=True:C214
	This:C1470.options:=$options#Null:C1517 ? $options : {}
	This:C1470.options.embedding:=True:C214  //not embeddings
	This:C1470.options.port:=$port
	This:C1470.options.model:=$file
	This:C1470._onResponse:=$formula
	This:C1470.returnResponseBody:=False:C215
	This:C1470.decodeData:=True:C214
	This:C1470.bufferSize:=100*(1024^2)
	
	Case of 
		: (OB Instance of:C1731($file; 4D:C1709.File))
			If (Not:C34(This:C1470.file.exists))
				If (This:C1470.file.parent#Null:C1517)
					This:C1470.file.parent.create()
					This:C1470.head()
				End if 
			Else 
				This:C1470.start()
			End if 
		Else 
			//hugging face mode
			This:C1470.options.model:=This:C1470.URL
			This:C1470.file:={name: This:C1470.URL}
			This:C1470.start()
	End case 
	
Function head()
	
	This:C1470.method:="HEAD"
	This:C1470.range:={length: 0; start: 0; end: 0}
	//async call not supported for HEAD
	var $request : 4D:C1709.HTTPRequest
	$request:=4D:C1709.HTTPRequest.new(This:C1470.URL; This:C1470).wait()
	If ($request.response.status=200)
		This:C1470.method:="GET"
		If (Value type:C1509($request.response.headers["accept-ranges"])=Is text:K8:3) && \
			($request.response.headers["accept-ranges"]="bytes")
			This:C1470.range.length:=Num:C11($request.response.headers["content-length"])
		End if 
		This:C1470._fileHandle:=This:C1470.file.open("write")
		If (This:C1470.range.length#0)
			This:C1470.range.start:=0
			var $end : Real
			$end:=This:C1470.range.start+(This:C1470.bufferSize-1)
			This:C1470.range.end:=$end>This:C1470.range.length ? This:C1470.range.length : $end
			This:C1470.headers.Range:="bytes="+String:C10(This:C1470.range.start)+"-"+String:C10(This:C1470.range.end)
		Else 
			This:C1470.range:=Null:C1517  //simple get
		End if 
		4D:C1709.HTTPRequest.new(This:C1470.URL; This:C1470)
	End if 
	
Function start()
	
	var $llama : cs:C1710._worker
	$llama:=cs:C1710._worker.new()
	
	$llama.start(This:C1470.options.port; This:C1470.options)
	
	If (Value type:C1509(This:C1470._onResponse)=Is object:K8:27) && (OB Instance of:C1731(This:C1470._onResponse; 4D:C1709.Function))
		This:C1470._onResponse.call(This:C1470; {success: True:C214})
	End if 
	
Function terminate()
	
	var $llama : cs:C1710._worker
	$llama:=cs:C1710._worker.new()
	
	$llama.terminate()
	
Function onData($request : 4D:C1709.HTTPRequest; $event : Object)
	
	This:C1470._fileHandle.writeBlob($event.data)
	
Function onResponse($request : 4D:C1709.HTTPRequest; $event : Object)
	
	Case of 
		: (This:C1470.range#Null:C1517)  //range get
			If ([200; 206; 302].includes($request.response.status)) && ($request.dataType="blob")
				var $size : Real
				This:C1470.range.start:=This:C1470._fileHandle.getSize()
				If (This:C1470.range.start<This:C1470.range.length)
					var $end : Real
					$end:=This:C1470.range.start+(This:C1470.bufferSize-1)
					This:C1470.range.end:=$end>This:C1470.range.length ? This:C1470.range.length : $end
					This:C1470.headers.Range:="bytes="+String:C10(This:C1470.range.start)+"-"+String:C10(This:C1470.range.end)
					4D:C1709.HTTPRequest.new(This:C1470.URL; This:C1470)
				Else 
					This:C1470._fileHandle:=Null:C1517
					//This:C1470.start()
				End if 
			End if 
		: (This:C1470.range=Null:C1517)  //simple get
			If ($request.response.status=200)
				This:C1470._fileHandle:=Null:C1517
				//This:C1470.start()
			End if 
	End case 
	
Function onError($request : 4D:C1709.HTTPRequest; $event : Object)
	
	If (Value type:C1509(This:C1470._onResponse)=Is object:K8:27) && (OB Instance of:C1731(This:C1470._onResponse; 4D:C1709.Function))
		This:C1470._onResponse.call(This:C1470; {success: False:C215})
		This:C1470._fileHandle:=Null:C1517
		This:C1470.file.delete()
		This:C1470.terminate()
	End if 