package utils{
	
	import crypto.CryptEvent;
	import crypto.cypher;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.core.SoundAsset;
	
	public class loadObject{
		
		public var params:Array=null;
		public var retry:int=0;
		public var max_retry:int=3;
		public var hosts:Array=new Array;
		public var url:String="";
		public var result:Function=null;
		public var cache:Object=null;
		public var rehost:int=0;
		public var percent:int=0;
		public var host_num:int=0;
		public var loader:URLLoader=null;
		public var state:int=0;
		public var target:MovieClip=null;
		public var time_out:int=-1;
		public var file_name:String="";
		public var _name:String="";
		public var _type:String="";
		public var data:*=null;
		public var app_dmn:ApplicationDomain=null;
		public var encrypted:Boolean=false;
		public var dspParser:Loader=null;
		public var last_loaded:Number=0;
		
		private static var count:int=0;
		private static var buffer:Object=new Object();
		
		public function loadObject(_url:String,_target:MovieClip,_hosts:Array=null,_cache:Object=null,_result:Function=null,_params:Array=null,_max_retry:int=3){
			target=_target;
			url=_url;
			hosts=_hosts;
			result=_result;
			cache=_cache;
			params=_params;
			max_retry=_max_retry;
			
			var url_ar:Array=_url.split("/");
			var name_ar:Array=url_ar[url_ar.length-1].split(".");
			name_ar[name_ar.length-1]=name_ar[name_ar.length-1].split("?")[0];
			if(name_ar.length>1){
				_type=(name_ar[name_ar.length-1]).toLowerCase();
				_name=(name_ar.slice(0,name_ar.length-1).join("."));
			}else{
				_type="";
				_name=(name_ar[name_ar.length-1]).toLowerCase();
			}
			
			//trace(_name+"   "+_type);
			if(cypher.formats.hasOwnProperty(_type)){
				try{
					if(!target["cypher_on"]){
						target["cypher_on"]=false;
						//trace("cypher_on"+"   "+str);
					}
				}catch(er:Error){
					throw new Error("Object \"_target\" must have a public parameter \"cypher_on:Boolean\"");
					return;
				}
				encrypted=true;
				_type=cypher.formats[_type];
				//trace(str+"="+cypher.formats[str]);
			}
			
			if(!target["cypher_on"]){
				new cypher(target);
				target.addEventListener(CryptEvent.PROGRESS, cryptProgress);
				target.addEventListener(CryptEvent.COMPLETE, cryptComplete);
				target.addEventListener(CryptEvent.ERROR, cryptError);
				target["cypher_on"]=true;
			}
			
			count++;
			if(_hosts==null||_url.split("://").length>1){
				hosts=[""];
			}else{
				host_num=int(Math.random()*_hosts.length);
			}
			file_name=_url.split(/[^A-Za-z0-9]{1}/gx).join("_");
			if(buffer[file_name]==null){
				buffer[file_name]=[this];
			}else{
				buffer[file_name].push(this);
				return;
			}
			if(_url.split(/\s*/gxis).join("")==""){
				deactivate();
				for(var i:int=0;i<buffer[file_name].length;i++){
					result("error",buffer[file_name][i],"finally[ link error ("+_url+" >> "+url.split(/\s*/gxis).join("")+")]",buffer[file_name][i].params);
				}
				/*try{
				buffer[file_name]=null;
				delete buffer[file_name];
				}catch(er:Error){}*/
				clear(1);
				clear(2);
				clear(3);
				clear(0,1);
				return;
			}
			if(!cache_test(0)){
				loadCl();
			}
		}
		
		public function clear(phase:int,clear:int=0):void{
			if(phase==1){
				try{
					clearTimeout(time_out);
				}catch(er:Error){}
				try{
					loader.close();
				}catch(er:Error){}
			}
			if(phase==2){
				cypher.clearObject(_name+"_"+_type);
			}
			if(phase==3){
				if(_type=="swf"||_type=="png"||_type=="jpg"){
					try{
						dspParser.contentLoaderInfo.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, errorDisplayObj);
						dspParser.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorDisplayObj);
						dspParser.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorDisplayObj);
						dspParser.contentLoaderInfo.removeEventListener(Event.UNLOAD, errorDisplayObj);
						dspParser.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeDisplayObj);
						dspParser.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressDisplayObj);
					}catch(er:Error){}
					try{
						dspParser.close();
					}catch(er:Error){}
					try{
						dspParser.unloadAndStop();
					}catch(er:Error){}
				}
			}
			if(clear!=0){
				try{
					buffer[file_name]=null;
					delete buffer[file_name];
				}catch(er:Error){}
			}
		}
		
		public function cache_test(phase:int):Boolean{
			if(cache!=null&&cache.hasOwnProperty(file_name)&&cache[file_name]!=null){
				clear(phase);
				count--;
				deactivate();
				for(var i:int=0;i<buffer[file_name].length;i++){
					result("from_cache",buffer[file_name][i],cache[file_name],buffer[file_name][i].params);
				}
				/*try{
					buffer[file_name]=null;
					delete buffer[file_name];
				}catch(er:Error){}*/
				clear(0,1);
				return true;
			}
			return false;
		}
		
		public static function cypher_state():Number{
			return cypher.percents();
		}
		
		public static function get_url(_url:String,_hosts:Array):String{
			var _num:int=0;
			if(_hosts==null||_url.split("://").length>1){
				_hosts=[""];
			}else{
				_num=0;
			}
			if(_hosts[_num]!=""){
				return _hosts[_num]+"/"+_url;
			}else{
				return _url;
			}
		}
		
		private function loadCl():void{
			for(var i:int=0;i<buffer[file_name].length;i++){
				result("start",buffer[file_name][i],null,buffer[file_name][i].params);
			}
			try{
				clearTimeout(time_out);
			}catch(er:Error){}
			try{
				loader.close();
			}catch(er:Error){}
			loader = new URLLoader();
			loader=loader;
			
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			state=0;
			percent=0;
			loader.addEventListener(Event.OPEN, open_lstnr);
			loader.addEventListener(ProgressEvent.PROGRESS, process_lstnr);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, secure_lstnr);
			loader.addEventListener(IOErrorEvent.IO_ERROR, io_lstnr);
			loader.addEventListener(Event.COMPLETE, complite_lstnr);
			var _url_str:String="";
			if(hosts[host_num]!=""){
				_url_str=hosts[host_num]+"/"+url;
			}else{
				_url_str=url;
			}
			if(_url_str.indexOf("?")>=0){
				_url_str+="&retry="+retry;
			}else{
				_url_str+="?retry="+retry;
			}
			
			loader.load(new URLRequest(_url_str));
			/*time_out=setTimeout(function():void{
				if(loader!=null){
					if(state==0){
						//trace(loader.name+"   "+loader.contentLoaderInfo.url);
						state=0;
						hostCount("timeout");
					}
				}
			}, 20000);*/
		}
		
		public function errCount(e_str:String,outside:Boolean=false):void{
			if(outside&&cache!=null&&cache[file_name]!=null){
				cache[file_name]=null;
			}
			if(retry<max_retry){
				retry++;
				for(var i:int=0;i<buffer[file_name].length;i++){
					result("try_url",buffer[file_name][i],e_str,buffer[file_name][i].params);
				}
				loadCl();
			}else{
				hostCount(e_str);
			}
		}
		
		public function hostCount(e_str:String,outside:Boolean=false):void{
			if(outside&&cache!=null&&cache[file_name]!=null){
				cache[file_name]=null;
			}
			if(rehost<hosts.length-1){
				rehost++;
				host_num++;
				if(host_num>hosts.length-1){
					host_num-=hosts.length;
				}
				retry=0;
				for(var i:int=0;i<buffer[file_name].length;i++){
					result("change_host",buffer[file_name][i],e_str,buffer[file_name][i].params);
				}
				loadCl();
			}else{
				//console.status("<font color=\"#ff0000\" size=\"11\">Cant load file: "+_res[_st].url+"</font>\n");
				count--;
				deactivate();
				for(var i:int=0;i<buffer[file_name].length;i++){
					result("error",buffer[file_name][i],"finally[ load_error (e_str="+e_str+") (outside="+outside+")]",buffer[file_name][i].params);
				}
				/*try{
					buffer[file_name]=null;
					delete buffer[file_name];
				}catch(er:Error){}*/
				clear(1);
				clear(2);
				clear(3);
				clear(0,1);
			}
		}
		
		private function open_lstnr(event:Event):void{
			state=1;
			for(var i:int=0;i<buffer[file_name].length;i++){
				result("open",buffer[file_name][i],null,buffer[file_name][i].params);
			}
		}
		
		private function process_lstnr(event:ProgressEvent):void{
			if(cache_test(1)){
				return;
			}
			state=2;
			percent=event.bytesLoaded/event.bytesTotal;
			for(var i:int=0;i<buffer[file_name].length;i++){
				result("progress",buffer[file_name][i],null,buffer[file_name][i].params);
			}
		}
		
		private function secure_lstnr(event:SecurityErrorEvent):void{
			if(cache_test(1)){
				return;
			}
			for(var i:int=0;i<buffer[file_name].length;i++){
				result("error",buffer[file_name][i],"security",buffer[file_name][i].params);
			}
			state=-1;
			try{
				clearTimeout(time_out);
			}catch(er:Error){}
			errCount("SecurityErrorEvent");
		}
		private function io_lstnr(event:IOErrorEvent):void{
			if(cache_test(1)){
				return;
			}
			for(var i:int=0;i<buffer[file_name].length;i++){
				result("error",buffer[file_name][i],"io",buffer[file_name][i].params);
			}
			state=-2;
			try{
				clearTimeout(time_out);
			}catch(er:Error){}
			errCount("IOErrorEvent");
		}
		
		private function complite_lstnr(event:Event):void{
			state=3;
			var _data:ByteArray=loader.data;
			try{
				clearTimeout(time_out);
			}catch(er:Error){}
			try{
				loader.close();
			}catch(er:Error){}
			for(var i:int=0;i<buffer[file_name].length;i++){
				result("loaded",buffer[file_name][i],_data,buffer[file_name][i].params);
			}
			initFile(_data);
		}
		
		private function initFile(_data:ByteArray):void {
			if(cache_test(1)){
				return;
			}
			if(encrypted){
				try{
					cypher.decode(_data,_name+"_"+_type,count,this);
				}catch(er:Error){
					errCount("Can't decrypt file "+er);
				}
			}else{
				parseFile(_data);
			}
		}
		
		private static function cryptProgress(event:CryptEvent):void {
			if(buffer[event.dataObject.file_name][0].cache_test(2)){
				return;
			}
			for(var i:int=0;i<buffer[event.dataObject.file_name].length;i++){
				buffer[event.dataObject.file_name][i].result("decrypt",buffer[event.dataObject.file_name][i],event,buffer[event.dataObject.file_name][i].params);
			}
		}
		
		private static function cryptError(event:CryptEvent):void {
			if(buffer[event.dataObject.file_name][0].cache_test(2)){
				return;
			}
			for(var i:int=0;i<buffer[event.dataObject.file_name].length;i++){
				buffer[event.dataObject.file_name][i].result("error",buffer[event.dataObject.file_name][i],event,buffer[event.dataObject.file_name][i].params);
			}
			buffer[event.dataObject.file_name][0].errCount(event.toString());
		}
		
		private static function cryptComplete(event:CryptEvent):void {
			if(buffer[event.dataObject.file_name][0].cache_test(2)){
				return;
			}
			for(var i:int=0;i<buffer[event.dataObject.file_name].length;i++){
				buffer[event.dataObject.file_name][i].result("decrypt",buffer[event.dataObject.file_name][i],event,buffer[event.dataObject.file_name][i].params);
			}
			event.dataObject.parseFile(event.data);
		}
		
		public function parseFile(_data:ByteArray):void {
			if(cache_test(2)){
				return;
			}
			//target.output("parseFile   "+_type+"   "+_str+"\n");
			if(_type=="swf"){
				parseDisplayObj(_data);
			}else if(_type=="png"){
				parseDisplayObj(_data);
			}else if(_type=="jpg"){
				parseDisplayObj(_data);
			}else if(_type=="mp3"){
				parseSoundObj(_data);
			}else if(_type=="xml"){
				parseXML(_data);
			}else if(_type=="txt"){
				parseTXT(_data);
			}else{
				data=_data;
				parseComplete(_data);
			}
		}
		
		private function parseComplete(_data:*):void {
			if(cache!=null){
				cache[file_name]=_data;
			}
			count--;
			deactivate();
			for(var i:int=0;i<buffer[file_name].length;i++){
				result("complete",buffer[file_name][i],_data,buffer[file_name][i].params);
			}
			/*try{
				buffer[file_name]=null;
				delete buffer[file_name];
			}catch(er:Error){}*/
			clear(1);
			clear(2);
			clear(3);
			clear(0,1);
		}
		
		private function deactivate():void {
			if(count==0){
				try{
					target.removeEventListener(CryptEvent.PROGRESS, cryptProgress);
					target.removeEventListener(CryptEvent.COMPLETE, cryptComplete);
					target.removeEventListener(CryptEvent.ERROR, cryptError);
					cypher.deactivate();
					target["cypher_on"]=false;
				}catch(er:Error){
					
				}
			}
		}
		
		private function parseDisplayObj(_data:ByteArray):void {
			dspParser=new Loader();
			dspParser.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorDisplayObj);
			dspParser.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorDisplayObj);
			dspParser.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorDisplayObj);
			dspParser.contentLoaderInfo.addEventListener(Event.UNLOAD, errorDisplayObj);
			dspParser.contentLoaderInfo.addEventListener(Event.COMPLETE, completeDisplayObj);
			dspParser.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressDisplayObj);
			try{
				var context:LoaderContext = new LoaderContext(false, new ApplicationDomain(target.loaderInfo.applicationDomain));
				dspParser.loadBytes(_data,context);
			}catch(er:Error){
				errCount("Can't parse displayObj file "+er);
			}
		}
		
		private function errorDisplayObj(event:Event):void {
			if(cache_test(3)){
				return;
			}
			for(var i:int=0;i<buffer[file_name].length;i++){
				result("error",buffer[file_name][i],"parse",buffer[file_name][i].params);
			}
			errCount(event.toString());
		}
		private function progressDisplayObj(event:Event):void {
			if(cache_test(3)){
				return;
			}
		}
		private function completeDisplayObj(event:Event):void {
			if(cache_test(3)){
				return;
			}
			data=event.currentTarget.content;
			app_dmn=event.currentTarget.applicationDomain;
			parseComplete(data);
		}
		
		private function parseSoundObj(_data:ByteArray):void {
			try{
				//var _class:Class=(_data as Class);
				var snd:SoundAsset = new SoundAsset();
				var _len:int=_data.length;
				snd.loadCompressedDataFromByteArray(_data,_len);
				data=snd;
				parseComplete(data);
			}catch(er:Error){
				for(var i:int=0;i<buffer[file_name].length;i++){
					result("error",buffer[file_name][i],"parse",buffer[file_name][i].params);
				}
				errCount(er.message);
			}
		}
		
		private function parseXML(_data:*):void {
			try{
				var _str:String=_data.readUTFBytes(_data.length);
				var xml:XML = new XML(_str);
				//trace("XML parse:\n"+xml);
				data=xml;
				parseComplete(data);
			}catch(er:Error){
				for(var i:int=0;i<buffer[file_name].length;i++){
					result("error",buffer[file_name][i],"parse",buffer[file_name][i].params);
				}
				errCount(er.message);
			}
		}
		
		private function parseTXT(_data:*):void {
			try{
				var _str:String=_data.readUTFBytes(_data.length);
				data=_str;
				parseComplete(data);
			}catch(er:Error){
				for(var i:int=0;i<buffer[file_name].length;i++){
					result("error",buffer[file_name][i],"parse",buffer[file_name][i].params);
				}
				errCount(er.message);
			}
		}
		
	}
}