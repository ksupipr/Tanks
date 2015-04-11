package{
	
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.system.Security;
	import flash.system.System;
	import flash.net.*;
	import flash.ui.*;
	import flash.system.ApplicationDomain;
	import flash.geom.*;
	//import flash.geom.Point;
	
	public class Help_class extends MovieClip{
		
		public static var stg_cl:MovieClip;
		public static var serv_url:String="";
		public static var stg_class:Class;
		
		public function urlInit(url:String,cl:MovieClip){
			serv_url=url;
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
			//root["lesson5"]["arrow_btn"].hitArea=stg_class.shop["buy0_1"];
			set_mask(root["lesson1"]["arrow_btn"],stg_class.chat_cl["pochta_b"]);
			//set_mask(root["lesson2"]["arrow_btn"],stg_class.shop["max_b0_1"]);
			set_mask(root["lesson3"]["arrow_btn"],stg_class.wind["shop_cl"]);
			set_mask(root["lesson4"]["arrow_btn"],stg_class.shop["buy0_0"]);
			set_mask(root["lesson5"]["arrow_btn"],stg_class.shop["buy0_1"]);
			set_mask(root["lesson6"]["arrow_btn"],stg_class.shop["exit"]);
			set_mask(root["lesson7"]["arrow_btn"],stg_class.wind["choise_cl"]);
			set_mask(root["lesson8"]["arrow_btn"],stg_class.wind["win_cl"]["b8"]);
			set_mask(root["lesson9"]["arrow_btn"],stg_class.wind["win_cl"]["play_cl"]);
			
			try{
				var cont:MovieClip=stg_class.prnt_cl;
				
				for(var i:int=1;i<50;i++){
					var _stx:String=cont.simpleVar("training"+i+"_next");
					if(_stx=="underfined"){
						break;
					}
					root["lesson"+i].next_st=int(_stx);
					cont.findVar("training"+(i),root["lesson"+i]["win"]["mess_tx"],null);
				}
				
				//cont.format_tx(lang.child("training")[0].child("step")[0],root["lesson1"]["win"]["mess_tx"],null);
				//cont.format_tx(lang.child("training")[0].child("step")[1],root["lesson2"]["win"]["mess_tx"],null);
				
				cont.findVar("training_exit",root["out_win"]["mess_tx"],null);
				
				cont.findVar("simple_no",root["out_win"]["out_no"]["name_tx"],null);
				cont.findVar("simple_yes",root["out_win"]["out_yes"]["name_tx"],null);
				cont.findVar("lesson_repeat",root["lesson2"]["repeat_btn"]["name_tx"],null);
				cont.findVar("lesson_next",root["lesson2"]["next_btn"]["name_tx"],null);
				cont.findVar("lesson_repeat",root["lesson10"]["repeat_btn"]["name_tx"],null);
				cont.findVar("lesson_next",root["lesson10"]["next_btn"]["name_tx"],null);
				
				
				/*var tf:TextField=new TextField();
				tf.width=tf.height=300;
				parent.addChild(tf);
				cont.format_tx(lang.child("training")[0].child("exit")[0],tf,null);*/
			}catch(er:Error){
				cont.output("<font color='#FF0000'>set lesson texts error: </font>"+er);
			}
		}
		
		public function set_mask(_cl:MovieClip,_dp:DisplayObject,_type:int=0){
			//trace(_cl.rotation);
			/*var _clone:DisplayObject=new DisplayObject();
			_clone.x=_dp.x;
			_clone.y=_dp.y;
			_clone.width=_dp.width;
			_clone.height=_dp.height;
			_clone.rotation=_cl.rotation;*/
			var _pt:Point=new Point(_dp.x,_dp.y);
			if(_type==0){
				_pt.x+=_dp.width/2;
				_pt.y+=_dp.height/2;
			}
			var _sz:Point=new Point(_dp.width,_dp.height);
			_pt=_dp.parent.localToGlobal(_pt);
			_pt=_cl.globalToLocal(_pt);
			stg_class.prnt_cl.draw_mask(_cl,_pt.x,_pt.y,_sz.x,_sz.y,5,5);
		}
		
		public function Help_class(){
			super();
			Security.allowDomain("*");
			if(name.substr(0,9)=="arrow_btn"){
				//trace(name+"   "+rotation);
				//if(parent.name=="lesson1"){
					//draw_mask(this,10,-10,45,15,5,5);
				//}
			}else{
				stop();
			}
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
			/*if(name=="leave_cl"){
				for(var i:int=1;i<11;i++){
					root["lesson"+i].visible=false;
				}
			}*/
		}
		
		public var tx_clrs:Array=[0,0xFFFF00,0xFF0000,0x000000,0x666666];
		public var _frames:Array=["","out","over","press","empty"];
		public var _labels:Object={"out":1,"over":2,"press":3,"empty":4};
		public function gotoFrame(_frame:int=0,_label:String="out"){
			if(_frame==0){
				gotoAndStop(_labels[_label]);
			}else{
				gotoAndStop(_frame);
			}
			try{
				this["name_tx"].textColor=tx_clrs[currentFrame];
			}catch(er:Error){}
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(_frames[currentFrame]=="empty"){
				return;
			}
			if(name.substr(0,9)=="arrow_btn"){
				/*if(parent.name=="lesson5"){
					Mouse.cursor=MouseCursor.BUTTON;
					stg_class.shop["buy0_1"].gotoFrame(0,"over");
				}*/
				return;
			}
			Mouse.cursor=MouseCursor.BUTTON;
			gotoFrame(0,"over");
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(_frames[currentFrame]=="empty"){
				return;
			}
			Mouse.cursor=MouseCursor.AUTO;
			if(name.substr(0,9)=="arrow_btn"){
				/*if(parent.name=="lesson5"){
					stg_class.shop["buy0_1"].gotoFrame(0,"out");
				}*/
				return;
			}
			gotoFrame(0,"out");
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(_frames[currentFrame]=="empty"){
				return;
			}
			if(name.substr(0,9)=="arrow_btn"){
				/*if(parent.name=="lesson5"){
					stg_class.shop["buy0_1"].gotoFrame(0,"press");
				}*/
				return;
			}
			gotoFrame(0,"press");
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(_frames[currentFrame]=="empty"){
				return;
			}
			if(name.substr(0,9)=="arrow_btn"){
				/*if(parent.name=="lesson1"){
					parent.visible=false;
					stg_class.chat_cl.openPochta();
				}else if(parent.name=="lesson3"){
					//parent.visible=false;
					stg_cl.createMode(2);
					//_type=4;
					//sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",_type+""]]);
					stg_cl.removeChild(St_clip.stg);
				}else if(parent.name=="lesson4"){
					stg_class.shop["buy0_0"].initBuy(stg_class.shop["buy0_0"]);
				}else if(parent.name=="lesson5"){
					stg_class.shop["buy0_1"].gotoFrame(0,"over");
					stg_class.shop["buy0_1"].initBuy(stg_class.shop["buy0_1"]);
					try{
						stg_cl.removeChild(St_clip.stg);
					}catch(er:Error){}
				}*/
				return;
			}
			gotoFrame(0,"over");
			if(name=="close_cl"){
				_type=0;
				sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",_type+""]]);
				stg_cl.removeChild(St_clip.stg);
				stg_cl.initLesson(_type);
			}else if(name=="close_empt"){
				root["empt_cl"].visible=false;
			}else if(name=="out_yes"){
				_type=0;
				sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",_type+""]]);
				stg_cl.removeChild(St_clip.stg);
				stg_cl.initLesson(_type);
			}else if(name=="out_no"){
				root["out_win"].visible=false;
			}else if(name=="out_cl"){
				root["out_win"].visible=true;
			}else if(name=="leave_cl"){
				if(_type!=11){
					root["out_win"].visible=true;
				}else{
					_type=0;
					sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",_type+""]]);
					stg_cl.removeChild(St_clip.stg);
					stg_cl.initLesson(_type);
				}
			}else if(name=="leave_cl1"){
				root["out_win"].visible=true;
			}else if(name=="next_btn"){
				_type=int(parent["next_st"]);
				//trace("to next "+parent["next_st"]+" "+_type);
				sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",_type+""]]);
				stg_cl.removeChild(St_clip.stg);
			}else if(name=="repeat_btn"){
				if(_type==2){
					stg_class.chat_cl.repeat_bttl();
					stg_cl.removeChild(St_clip.stg);
				}else if(_type==10){
					stg_class.chat_cl.repeat_bttl();
					stg_cl.removeChild(St_clip.stg);
				}
			}
		}
		
		public function sendRequest(names:Array, attr:Array, idies:Array){
			var b:int=0;
			var rqs:URLRequest=new URLRequest(serv_url+"?query="+idies[0][0]+"&action="+idies[1][0]);
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			var list:XML;
			var strXML:String="";
			if(names.length==2){
				strXML+="<"+names[0];
				for(var i:int=0;i<attr[0].length;i++){
					strXML+=" "+attr[0][i]+"=\""+idies[0][i]+"\"";
				}
				strXML+=">";
				strXML+="<"+names[1];
				for(var i:int=0;i<attr[1].length;i++){
					strXML+=" "+attr[1][i]+"=\""+idies[1][i]+"\"";
				}
				strXML+="/>";
				strXML+="</"+names[0]+">";
				if(int(idies[0][0])==2){
					if(int(idies[1][0])==14){
						//if(int(idies[1][1])==12){
							loader.addEventListener(Event.COMPLETE, conferm);
							b=1;
						//}
					}
				}
			}else if(names.length==3){
				strXML+="<"+names[0];
				for(var i:int=0;i<attr[0].length;i++){
					strXML+=" "+attr[0][i]+"=\""+idies[0][i]+"\"";
				}
				strXML+=">";
				strXML+="<"+names[1];
				for(var i:int=0;i<attr[1].length;i++){
					strXML+=" "+attr[1][i]+"=\""+idies[1][i]+"\"";
				}
				strXML+=">";
				strXML+="<"+names[2];
				for(var i:int=0;i<attr[2].length;i++){
					strXML+=" "+attr[2][i]+"=\""+idies[2][i]+"\"";
				}
				strXML+="/>";
				strXML+="</"+names[1]+">";
				strXML+="</"+names[0]+">";
				/*if(int(idies[1][0])==2){
					loader.addEventListener(Event.COMPLETE, addCombat);
				}*/
			}
			////trace(int(idies[1][0]));
			////trace("str\n"+strXML);
			list=new XML(strXML);
			//trace("s_xml\n"+list+"\n");
			var variables:URLVariables = new URLVariables();
			variables.query = list;
			variables.send = "send";
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			//trace("variables");
			//trace(variables);
			if(b==0){
				stg_cl.warn_f(10,"");
			}else if(b==2){
				stg_cl.warn_f(14,"");
			}
			loader.load(rqs);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function conferm(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nОбучающий режим.");
				trace("data1="+str);
				stg_cl.erTestReq(7,2,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else{
					//trace("H   "+_type+"   "+stg_class.m_mode);
					stg_cl.initLesson(_type);
				}
			}catch(er:Error){
				
			}
			try{System.disposeXML(list);}catch(er:Error){}
		}
	
		public function onError(event:IOErrorEvent):void{
			//trace("Select+php2: "+event);
			stg_cl.warn_f(4,"Выбор боя");
		}
		
		public static var _type:int=0;
		
		public function set_type(a:int){
			_type=a;
		}
		
		public function get_type(){
			return _type;
		}
		
		public function resetImage(){
			try{
				root["cl_win"]["pict_cl"].removeChild(img[0]);
			}catch(er:Error){}
			img=new Array();
		}
		
		public function LoadImage(ur:String){
			//trace(ur);
			var loader:Loader = new Loader();
			root["cl_win"]["pict_cl"].addChild(loader);
			img.push(loader);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openImage );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressImage);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeImage);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadImage);
			
			loader.load(new URLRequest(ur+"?"+(Math.random()*1000000000000)));
		}
		
		public function openImage(event:Event){
			
		}
		
		public function progressImage(event:Event){
			
		}
		
		public function completeImage(event:Event){
			//event.currentTarget.content.x+=1;
			//event.currentTarget.content.y+=1;
			//event.currentTarget.content.name="pict";
		}
		
		public static var img:Array=new Array();
		
		public function accessError(event:Event){
			
		}
		
		public function unLoadImage(event:Event){
			
		}
		
	}
	
}
