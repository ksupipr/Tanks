package utils{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.system.System;
	import flash.system.SystemUpdater;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class Console extends MovieClip{
		
		public static var stg_cl:MovieClip;
		public static var stg_class:Class;
		public static var fpsMeter:FpsMeter;
		
		private var textHint:TextField=new TextField();
		private var console_str:String="";
		private var textConsole:TextField=new TextField();
		private var last_cmds:Array=new Array();
		private var cmds_pos:int = 0;
		private var textCommand:TextField=new TextField();
		private var list_cmds:Vector.<String>=new <String>[
			"help - show console commands",
			"clear - clear console",
			"clear_h - clear commands history",
			"go_line - scrolls the text up to the line with the specified number, example:\n\"go_line 55\"",
			"get_request - send a GET request, example:\n\"get_request http://unlexx.no-ip.org/loc/index.php?45539467129.856346\"",
			"post_request - send a POST request, example:\n\"post_request http://unlexx.no-ip.org/sendQuery.php?query=3&action=6&level=4 send=send&query=<query id=\"3\"><action id=\"6\"/></query>\" - send two POST variable: \"send\" and \"query\"",
			"kill_request - completes the request, check the responses using firebug, flash player does not always generate an event, such as if the tag in the header of Keep-Alive",
			"flashvars - shows the flashvars",
			"fps_metric - shows the FPS and memory usage info",
			"system - shows system info",
			"socket_cmd - sends a command to battle server, example:\n\"socket_cmd 22 0 150\" - activate a rocket fire on 150 coordinate",
			"socket_log - \n\"socket_log 1\" for output metka1\n\"socket_log 2\" for output send package\n\"socket_log 3\" for output receive package\n\"socket_log -1\" for output all package\n\"socket_log 0\" for output off",
			"chat_log - \n\"chat_log 1\" for log_on\n\"chat_log 0\" for log_off",
			"enable_p2p - init peer2peer connect",
			"call_p2p - connect with a group of users on the specified name, example:\n\"call_p2p testGroup\"",
			"hung_up_p2p - breaks the connection with the specified user or breaks all connections, example:\n\"hung_up_p2p 0 c342df62e2f4444060fba7f5f14c7992c8f44dc8127a1ff1c492a8880d289039\" - 0 to search for id\n\"hung_up_p2p 1 1_20707807\" - 1 to search for name\n\"hung_up_p2p all\" - \"all\" for all breaks",
			"public_mess - send public p2p text message, example:\n\"public_mess Hello world!\" - send \"Hello world!\""
		];
		private var press_key:Array=new Array();
		private var console_cl:Sprite=new Sprite();
		private var wait_answ:Boolean=false;
		private var cons_ldt:URLLoader=new URLLoader();
		
		private function key_press(event:KeyboardEvent):void{
			if(press_key[event.keyCode]>0){
				return;
			}
			press_key[event.keyCode]=1;
			if(event.keyCode==192){
				showConsole();
			}
		}
		
		private function key_rls(event:KeyboardEvent):void{
			press_key[event.keyCode]=0;
		}
		
		private var cmd_text:String="";
		private function change_cmd(event:Event):void{
			if(do_after!=null){
				var _str:String=textCommand.text;
				var _first:String="";
				if(_str.length<cmd_text.length){
					_first=cmd_text.substr(0,_str.length);
				}else{
					var _i:int=_str.indexOf(cmd_text);
					if(_i!=0){
						_first=cmd_text+_str.substr(0,_i);
					}else{
						_first=cmd_text+_str.substr(cmd_text.length,_str.length);
					}
				}
				//_first.split("\n").join("");
				textCommand.text=_first;
				textCommand.setSelection(textCommand.text.length,textCommand.text.length);
			}
			hint();
			form_test();
		}
		
		private function form_test():void{
			var _text:String=textCommand.text;
			if(_text.substr(0,10)=="run_script"){
				view_form("script");
			}else if(_text.substr(0,5)=="admin"){
				view_form("admin");
			}else if(_text.substr(0,7)=="run_cmd"){
				view_form("admin");
			}else{
				view_form();
			}
			cmd_text=_text;
		}
		
		private var do_after:Function=null;
		private function key_console(event:KeyboardEvent):void{
			if(press_key[event.keyCode]>0){
				return;
			}
			if(event.keyCode==Keyboard.ENTER){
				if(textHint.stage==null){
					if(event.ctrlKey){
						add_command(textCommand.text);
					}
				}else{
					stg_cl.stage.focus=null;
					textCommand.text=hint_list[hint_pos][0]+" ";
					do_after=function(){
						textCommand.setSelection(textCommand.text.length,textCommand.text.length);
						stg_cl.stage.focus=textCommand;
						do_after=null;
					}
					unhint();
					form_test();
				}
			}else if(event.keyCode==Keyboard.UP){
				if(textHint.stage==null){
					if(event.ctrlKey){
						if(cmds_pos>0){
							cmds_pos--;
						}else{
							cmds_pos=0;
						}
						if(last_cmds[cmds_pos]!=null){
							textCommand.text=last_cmds[cmds_pos];
						}
						form_test();
						unhint();
					}
				}else{
					if(hint_pos>0){
						hint_pos--;
					}else{
						hint_pos=0;
					}
					if(hint_list[hint_pos][0]!=null){
						do_after=function(){
							textCommand.setSelection(textCommand.text.length,textCommand.text.length);
							do_after=null;
						}
						last_hint=hint_list[hint_pos][0];
						textHint.setSelection(hint_list[hint_pos][1],hint_list[hint_pos][1]+last_hint.length);
					}
					//form_test();
				}
			}else if(event.keyCode==Keyboard.DOWN){
				if(textHint.stage==null){
					if(event.ctrlKey){
						if(cmds_pos<last_cmds.length-1){
							cmds_pos++;
						}else{
							cmds_pos=last_cmds.length-1;
						}
						if(last_cmds[cmds_pos]!=null){
							textCommand.text=last_cmds[cmds_pos];
						}
						form_test();
						unhint();
					}
				}else{
					if(hint_pos<hint_list.length-1){
						hint_pos++;
					}else{
						hint_pos=hint_list.length-1;
					}
					if(hint_list[hint_pos][0]!=null){
						do_after=function(){
							textCommand.setSelection(textCommand.text.length,textCommand.text.length);
							do_after=null;
						};
						last_hint=hint_list[hint_pos][0];
						textHint.setSelection(hint_list[hint_pos][1],hint_list[hint_pos][1]+last_hint.length);
					}
					//form_test();
				}
			}
			if(do_after!=null){
				setTimeout(do_after,17);
			}
		}
		
		private function format_str(_str:String):String{
			var cmd_str:String=_str;
			//trace(_str);
			cmd_str=cmd_str.split(/\s+/g).join(" ");
			for(var i:int=0;i<cmd_str.length;i++){
				if(cmd_str.charAt(i)==" "){
					cmd_str=cmd_str.substr(i+1);
				}else{
					break;
				}
			}
			for(var i:int=cmd_str.length-1;i>-1;i++){
				if(cmd_str.charAt(i)==" "){
					cmd_str=cmd_str.substr(0,i);
				}else{
					break;
				}
			}
			return cmd_str;
		}
		
		private function add_command(_cmd:String):void{
			var _cmd_ar:Array=_cmd.split(" ");
			var _valid:int=0;
			if(_cmd_ar[0]=="help"){
				status("<b><font color=\"#000000\" size=\"11\">Commands list</font></b>\n");
				var _str:String="<font color=\"#000000\" size=\"11\">";
				for(var i:int=0;i<list_cmds.length;i++){
					var _help_ar:Array=list_cmds[i].split(" ");
					_str+=("<li><b>"+_help_ar[0]+"</b>"+_escapeHtmlEntities(_help_ar.slice(1).join(" "))+"</li>\n");
				}
				status(_str+"</font>\n");
			}else if(_cmd_ar[0]=="clear"){
				console_str="";
				textConsole.text=console_str;
			}else if(_cmd_ar[0]=="clear_h"){
				last_cmds=new Vector.<String>();
			}else if(_cmd_ar[0]=="go_line"){
				textConsole.scrollV=_cmd_ar[1];
			}else if(_cmd_ar[0]=="kill_request"){
				try{
					cons_ldt.close();
				}catch(er:Error){}
				cons_ldt=null;
				wait_answ=false;
				status("<font color=\"#555555\" size=\"11\">request close();</font>" + "\n\n");
			}else if(_cmd_ar[0]=="get_request"){
				try{
					cons_ldt.close();
				}catch(er:Error){}
				var rqs:URLRequest=new URLRequest(_cmd_ar[1]);
				rqs.method=URLRequestMethod.GET;
				var loader:URLLoader=new URLLoader(rqs);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, function(ev:Event):void{
					status("<font color=\"#000000\" size=\"11\">Answer: \n" + _escapeHtmlEntities(ev.target.data)+"</font>" + "\n\n");
					wait_answ=false;
				});
				loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:IOErrorEvent):void{
					status("<font color=\"#ff0000\" size=\"11\">Error: \n" + _escapeHtmlEntities(ev.toString())+"</font>" + "\n\n");
					wait_answ=false;
				});
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(ev:SecurityErrorEvent):void{
					status("<font color=\"#ff0000\" size=\"11\">Error: \n" + _escapeHtmlEntities(ev.toString())+"</font>" + "\n\n");
					wait_answ=false;
				});
				status("<font color=\"#555555\" size=\"11\">wait... "+_escapeHtmlEntities(_cmd_ar[1])+"</font>" + "\n\n");
				//loader.dataFormat = URLLoaderDataFormat.TEXT;
				cons_ldt=loader;
				wait_answ=true;
				loader.load(rqs);
			}else if(_cmd_ar[0]=="post_request"){
				try{
					cons_ldt.close();
				}catch(er:Error){}
				var rqs:URLRequest=new URLRequest(_cmd_ar[1]);
				rqs.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader(rqs);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				var variables:URLVariables = new URLVariables();
				var _vars:Array=_cmd_ar.slice(2).join(" ").split("&");
				for(var i:int=0;i<_vars.length;i++){
					var _var:Array=_vars[i].split("=");
					variables[_var[0]]=_var.slice(1).join("=");
				}
				rqs.data = variables;
				loader.addEventListener(Event.COMPLETE, function(ev:Event):void{
					status("<font color=\"#000000\" size=\"11\">Answer: \n" + _escapeHtmlEntities(ev.target.data)+"</font>" + "\n\n");
					wait_answ=false;
				});
				loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:IOErrorEvent):void{
					status("<font color=\"#ff0000\" size=\"11\">Error: \n" + _escapeHtmlEntities(ev.toString())+"</font>" + "\n\n");
					wait_answ=false;
				});
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(ev:SecurityErrorEvent):void{
					status("<font color=\"#ff0000\" size=\"11\">Error: \n" + _escapeHtmlEntities(ev.toString())+"</font>" + "\n\n");
					wait_answ=false;
				});
				status("<font color=\"#555555\" size=\"11\">wait... "+_escapeHtmlEntities(_cmd_ar[1]+" ["+_vars)+"]</font>" + "\n\n");
				//loader.dataFormat = URLLoaderDataFormat.TEXT;
				cons_ldt=loader;
				wait_answ=true;
				loader.load(rqs);
			}else if(_cmd_ar[0]=="flashvars"){
				status("<b><font color=\"#000000\" size=\"11\">flashVars</font></b>\n");
				var _str:String="<font color=\"#000000\" size=\"11\">";
				var flashVars:Object=null;
				flashVars = stg_cl.stage.loaderInfo.parameters as Object;
				for(var str:String in flashVars){
					_str+=("<li><b>"+_escapeHtmlEntities(str)+"</b>= "+_escapeHtmlEntities(flashVars[str])+"</li>\n");
				}
				status(_str+"</font>\n");
			}else if(_cmd_ar[0]=="fps_metric"){
				if(fpsMeter==null){
					fpsMeter=new FpsMeter();
					stg_cl.stage.addChild(fpsMeter);
				}else{
					try{
						stg_cl.stage.removeChild(fpsMeter);
					}catch(er:Error){}
					fpsMeter=null;
				}
			}else if(_cmd_ar[0]=="system"){
				status("<b><font color=\"#000000\" size=\"14\">System info</font></b>\n");
				var _str:String = "<font color=\"#000000\" size=\"14\"><li><b>Доступ к камере и микрофону запрещен администратором:</b> " + Capabilities.avHardwareDisable+"</li>" +
					"<li><b>Текущая архитектура центрального процессора:</b> " + Capabilities.cpuArchitecture+"</li>" +
					"<li><b>Поддержка системой специальных возможностей:</b> " + Capabilities.hasAccessibility+"</li>" +
					"<li><b>Поддержка системой воспроизведения аудио:</b> " + Capabilities.hasAudio+"</li>" +
					"<li><b>Может ли система кодировать аудиопотоки:</b> " + Capabilities.hasAudioEncoder+"</li>" +
					"<li><b>Поддержка системой внедренного видео:</b> " + Capabilities.hasEmbeddedVideo+"</li>" +
					"<li><b>Установлен ли в системе редактор метода ввода (IME):</b> " + Capabilities.hasIME+"</li>" +
					"<li><b>Имеет ли система декодер МР3:</b> " + Capabilities.hasMP3+"</li>" +
					"<li><b>Поддерживает ли система печать:</b> " + Capabilities.hasPrinting+"</li>" +
					"<li><b>Поддержка системой разработки приложений видеотрансляции через FMS:</b> " + Capabilities.hasScreenBroadcast+"</li>" +
					"<li><b>Поддержка системой воспроизведения приложений видеотрансляции:</b> " + Capabilities.hasScreenPlayback+"</li>" +
					"<li><b>Поддержка системой воспроизведения потокового аудио:</b> " + Capabilities.hasStreamingAudio+"</li>" +
					"<li><b>Поддержка системой воспроизведения потокового видео:</b> " + Capabilities.hasStreamingVideo+"</li>" +
					"<li><b>Поддержка системой собственных сокетов SSL через NetConnection:</b> " + Capabilities.hasTLS+"</li>" +
					"<li><b>Способна ли система кодировать видеопотоки:</b> " + Capabilities.hasVideoEncoder+"</li>" +
					"<li><b>Является ли плеер отладочной версией:</b> " + Capabilities.isDebugger+"</li>" +
					"<li><b>Код языка системы:</b> " + Capabilities.language+"</li>" +
					"<li><b>Доступ к жесткому диску запрещен администратором:</b> " + Capabilities.localFileReadDisable+"</li>" +
					"<li><b>Производитель работающей версии Flash Player:</b> " + Capabilities.manufacturer+"</li>" +
					"<li><b>Самый высокий уровень IDC H.264:</b> " + Capabilities.maxLevelIDC+"</li>" +
					"<li><b>Операционная система:</b> " + Capabilities.os+"</li>" +
					"<li><b>Пропорции экрана в пикселях:</b> " + Capabilities.pixelAspectRatio+"</li>" +
					"<li><b>Тип среды выполнения:</b> " + Capabilities.playerType+"</li>" +
					"<li><b>Цветность экрана:</b> " + Capabilities.screenColor+"</li>" +
					"<li><b>Разрешение dpi экрана в пикселях:</b> " + Capabilities.screenDPI+"</li>" +
					"<li><b>Разрешение экрана по горизонтали:</b> " + Capabilities.screenResolutionX+"</li>" +
					"<li><b>Разрешение экрана по вертикали:</b> " + Capabilities.screenResolutionY+"</li>" +
					"<li><b>Поддержка системой выполнения 32-разрядных процессов:</b> " + Capabilities.supports32BitProcesses+"</li>" +
					"<li><b>Поддержка системой выполнения 64-разрядных процессов:</b> " + Capabilities.supports64BitProcesses+"</li>" +
					"<li><b>Тип поддерживаемого сенсорного экрана:</b> " + Capabilities.touchscreenType+"</li>" +
					"<li><b>Версия Flash Player:</b> " + Capabilities.version+"</li>"+"</font>\n\n";
				status(_str);
			}else if(_cmd_ar[0]=="socket_log"){
				stg_class["cl_clip"].log_pack(_cmd_ar[1]);
				status("<font color=\"#000000\" size=\"11\">socket_log=" + _cmd_ar[1] +"</font>" + "\n");
			}else if(_cmd_ar[0]=="socket_cmd"){
				var _bytes:Array=_cmd_ar.slice(1);
				var br:ByteArray=new ByteArray();
				var _str:String="[";
				try{
					for(var i:int=0;i<_bytes.length;i++){
						if(int(_bytes[i])<10){
							_str+="  ";
						}else if(int(_bytes[i])<100){
							_str+=" ";
						}
						_str+=(_bytes[i])+" ";
						br.writeByte(_bytes[i]);
					}
					var _sckt:Socket=stg_class["cl_clip"]["socket"];
					_sckt.writeBytes(br,0,br.length);
					_sckt.flush();
					_str+="]";
					status("<font color=\"#000000\" size=\"11\">Socket send: \n" + _escapeHtmlEntities(_str)+"</font>" + "\n\n");
				}catch(er:Error){
					status("<font color=\"#ff0000\" size=\"11\">Socket error: \n" + _escapeHtmlEntities(er.toString())+"</font>" + "\n\n");
				}
			}else if(_cmd_ar[0]=="chat_log"){
				stg_cl.chat_log=_cmd_ar[1];
				status("<font color=\"#000000\" size=\"11\">chat_log=" + _cmd_ar[1] +"</font>" + "\n");
			}else if(_cmd_ar[0]=="enable_p2p"){
				if(!stg_class["cl_class"].p2p_on){
					stg_class["cl_class"].p2p_client.inclusion();
				}
			}else if(_cmd_ar[0]=="call_p2p"){
				stg_class["cl_class"].p2p_client.onConnect(_cmd_ar[1]);
			}else if(_cmd_ar[0]=="hung_up_p2p"){
				if(_cmd_ar[1]=="all"){
					stg_class["cl_class"].p2p_client.onHangupAll();
				}
			}else if(_cmd_ar[0]=="public_mess"){
				stg_class["cl_class"].p2p_client.onSendAll(_cmd_ar.slice(1).join(" "));
			}else{
				_valid=1;
			}
			if(_valid==0){
				last_cmds.push(_cmd);
				cmds_pos=last_cmds.length-1;
				textCommand.text="";
			}else{
				textCommand.textColor=0xff0000;
			}
		}
		
		public function showConsole():void{
			if(console_cl.stage==null){
				textCommand.addEventListener(KeyboardEvent.KEY_DOWN, key_console);
				textCommand.addEventListener(Event.CHANGE, change_cmd);
				if(fpsMeter!=null&&fpsMeter.stage!=null){
					var _ind:int=0;
					if(stg_cl.stage.getChildIndex(fpsMeter)>0){
						_ind=stg_cl.stage.getChildIndex(fpsMeter);
						if(_ind<stg_cl.stage.numChildren-1){
							stg_cl.stage.setChildIndex(fpsMeter, stg_cl.stage.numChildren-1);
							_ind=stg_cl.stage.getChildIndex(fpsMeter)-1;
						}
					}
					stg_cl.stage.addChildAt(console_cl,_ind);
				}else{
					stg_cl.stage.addChild(console_cl);
				}
				stg_cl.stage.focus=textCommand;
				output();
				hint();
			}else{
				unhint();
				try{
					stg_cl.stage.removeChild(console_cl);
				}catch(er:Error){}
				try{
					textCommand.removeEventListener(KeyboardEvent.KEY_DOWN, key_console);
					textCommand.removeEventListener(TextEvent.TEXT_INPUT, change_cmd);
				}catch(er:Error){}
				stg_cl.stage.focus=null;
				textConsole.text="";
			}
		}
		
		private function _escapeHtmlEntities(html:String):String{
			html = html.split("&").join('&amp;');
			html = html.split('"').join('&quot;');
			html = html.split("'").join('&apos;');
			html = html.split("<").join('&lt;');
			html = html.split(">").join('&gt;');
			html = html.split("\\").join("&#92;");
			return html;
		}
		
		public function Console() {
			super();
			Security.allowDomain("*");
			stop();
			
			
			textConsole.wordWrap=true;
			//textConsole.autoSize=TextFieldAutoSize.LEFT;
			textConsole.multiline=true;
			textConsole.alwaysShowSelection=true;
			textHint.multiline=true;
			textHint.alwaysShowSelection=true;
			//textConsole.alpha=50;
			textCommand.type=TextFieldType.INPUT;
			textCommand.restrict = "^`~Ёё";
			textCommand.alwaysShowSelection=true;
			//textCommand.alpha=50;
			console_cl.addChild(textConsole);
			console_cl.addChild(textCommand);
			view_form();
			
			var versionString:String = Capabilities.version;
			status("<b><font color=\"#003300\" size=\"11\">Player: " + versionString+"</font></b>" + "\n\n");
			var pattern:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/;
			var result:Object = pattern.exec(versionString);
			var vers:Array=new Array();
			if(result!=null){
				/*trace("Результат: " + result.input);
				trace("Платформа: " + result[1]);
				trace("Версия плеера: " + result[2]);
				trace("Промежуточная версия: " + result[3]);
				trace("Номер сборки: " + result[4]);
				trace("Внутренний номер сборки: " + result[5]);*/
				vers[0]=result[1];
				vers[1]=int(result[2]);
				vers[2]=int(result[3]);
				vers[3]=int(result[4]);
				vers[3]=int(result[5]);
				//trace(vers);
			}else{
				status("<b><font color=\"#ff0000\" size=\"11\">PLAYER VERSION PARSE ERROR! </font></b>" + "\n\n");
			}
		}
		
		private var _hint:String="";
		private var hint_list:Array=new Array();
		private var hint_pos:int=0;
		private var last_hint:String="";
		private function hint(){
			var cmd_str:String=format_str(textCommand.text);
			var _cmd_ar:Array=cmd_str.split(" ");
			if(_cmd_ar.length>1){
				unhint();
				return;
			}else if(_cmd_ar[0]==""){
				unhint();
				return;
			}
			hint_list=new Array();
			var hint_str:String="";
			var _l:int=0;
			var _h:int=0;
			for(var i:int=0;i<list_cmds.length;i++){
				var _help_ar:Array=list_cmds[i].split(" ");
				var _valid:String=_help_ar[0];
				var _test:String=_cmd_ar[0];
				if(_valid==_test){
					unhint();
					return;
				}else if(_valid.substr(0,_test.length)==_test){
					//var hint_s:String="<a href=\"event:"+_valid+"\"><u>"+_valid+"</u></a>\n";
					hint_list.push([_valid,_l]);
					hint_str+="<a href=\"event:"+_valid+"\"><u>"+_valid+"</u></a>\n";
					_l+=_valid.length+1;
					if(_valid==last_hint){
						_h=hint_list.length-1;
					}
				}
			}
			if(hint_str==""){
				unhint();
				return;
			}
			hint_pos=_h;
			hint_str="<font size=\"15\">"+hint_str+"</font>";
			textHint.y=textCommand.y+20;
			textHint.htmlText=hint_str;
			textHint.height=textHint.textHeight+5;
			textHint.width=textHint.textWidth+5;
			if(textHint.height+textHint.y>stg_cl.stage.height){
				textHint.height=stg_cl.stage.height-textHint.y;
			}
			textHint.setSelection(hint_list[hint_pos][1],hint_list[hint_pos][1]+hint_list[hint_pos][0].length);
			textHint.addEventListener(TextEvent.LINK, hint_link);
			if(textHint.stage==null){
				stg_cl.stage.addChild(textHint);
			}
		}
		
		private function hint_link(event:TextEvent){
			textCommand.text=event.text+" ";
			unhint();
			form_test();
		}
		
		private function unhint(){
			try{
				textHint.removeEventListener(TextEvent.LINK, hint_link);
			}catch(er:Error){}
			try{
				stg_cl.stage.removeChild(textHint);
			}catch(er:Error){}
			last_hint="";
		}
		
		private var _form:String="";
		private function view_form(_type:String="norm"){
			if(textCommand.textColor==0xff0000){
				textCommand.textColor=0x000000;
			}
			if(_form==_type){
				return;
			}
			var _gr:Graphics=console_cl.graphics;
			_gr.clear();
			//textConsole.x=textConsole.y=0;
			if(_type=="norm"){
				textConsole.width=756;
				textConsole.height=200;
				textCommand.y=textConsole.y+textConsole.height;
				textCommand.width=textConsole.width;
				textCommand.height=60;
				textCommand.multiline=true;
			}else if(_type=="script"){
				textConsole.width=756;
				textConsole.height=200;
				textCommand.y=textConsole.y+textConsole.height;
				textCommand.width=textConsole.width;
				textCommand.height=300;
				textCommand.multiline=true;
			}else if(_type=="admin"){
				textConsole.width=756;
				textConsole.height=200;
				textCommand.y=textConsole.y+textConsole.height;
				textCommand.width=textConsole.width;
				textCommand.height=300;
				textCommand.multiline=true;
			}
			_gr.beginFill(0xffffff,.8);
			_gr.drawRect(0,0,textConsole.width,textConsole.height);
			_gr.lineStyle(1,0x000000,1);
			_gr.drawRect(0,textCommand.y,textCommand.width,textCommand.height);
			_form=_type;
		}
		
		public function init(par_cl:MovieClip,par_class:Class):void{
			stg_cl=par_cl;
			stg_class=par_class;
			
			try{
				stg_cl.stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_press);
				stg_cl.stage.removeEventListener(KeyboardEvent.KEY_UP, key_rls);
			}catch(er:Error){}
			
			if(stg_cl.br!=1){
				if(console_cl.stage!=null){
					showConsole();
				}
				return;
			}
			stg_cl.stage.addEventListener(KeyboardEvent.KEY_DOWN, key_press);
			stg_cl.stage.addEventListener(KeyboardEvent.KEY_UP, key_rls);
		}
		
		public function status(msg:String,_num:int=0):void{
			if(_num==0){
				console_str+=msg;
			}else{
				console_str+=_escapeHtmlEntities(msg);
			}
			if(console_str.length>1310720){
				console_str=console_str.substr(console_str.length-1310720);
			}
			output();
		}
		
		private function output():void{
			if(console_cl.stage!=null){
				var _b:int=0;
				if(textConsole.scrollV==textConsole.maxScrollV){
					_b=1;
				}
				textConsole.htmlText=console_str;
				if(_b==1){
					textConsole.scrollV=textConsole.maxScrollV;
				}
				//trace("ScriptDebug: " + msg);
			}
		}
		
		public function get log():String{
			return console_str.split("\n").join("<br>");
		}
		
	}
	
}