package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
  import flash.net.*;
	import flash.system.Security;
	import flash.system.System;
	
	public class Options extends MovieClip{
		
		public static var stg_cl:MovieClip;
		public static var serv_url:String="";
		public static var stg_class:Class;
		
		public static var vars:Array=new Array(
			["rad_b",0],["smoke_b",0],["bull_b",0],["expl_b",0],["game_s_b",0],["serv_s_b",0],["vibro_b",0],["tracks_b",0],
			["port0",0],["port1",0],["port2",0],["port3",0],["port4",0]);
		
		public function getVar(_i:int){
			return vars[_i];
		}
		
		public function urlInit(url:String,cl:MovieClip){
			serv_url=url;
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
			var mySO:SharedObject = SharedObject.getLocal("xlabtanks");
			if(!mySO.data.ar){
				var _ar:Array=new Array();
				for(var i:int=0;i<vars.length;i++){
					_ar.push(vars[i][1]);
				}
				mySO.data.ar=_ar;
				mySO.flush();
			}else{
				/*trace(mySO.data.ar);
				trace(vars);
				trace(mySO.size);*/
				for(var i:int=0;i<vars.length;i++){
					if(mySO.data.ar[i]!=0){
						vars[i][2]["press_cl"].visible=true;
					}else{
						vars[i][2]["press_cl"].visible=false;
					}
					setOpt(vars[i][2],1);
				}
			}
		}
		
		public function saveAr(){
			var mySO:SharedObject = SharedObject.getLocal("xlabtanks");
			var _ar:Array=new Array();
			for(var i:int=0;i<vars.length;i++){
				if(vars[i][2]["press_cl"].visible){
					_ar.push(1);
				}else{
					_ar.push(0);
				}
			}
			/*trace(_ar);
			trace(vars);*/
			mySO.data.ar=_ar;
			mySO.flush();
		}
		
		public function Options(){
			super();
			Security.allowDomain("*");
			stop();
			/*var mySO:SharedObject = SharedObject.getLocal("xlabtanks");
			trace(mySO.size);*/
			if(this["press_cl"]!=null){
				if(name!="port4"){
					this["press_cl"].visible=false;
				}
			}
			for(var i:int=0;i<vars.length;i++){
				if(vars[i][0]==name){
					vars[i][2]=this;
					//trace(vars[i][0]+"   "+vars[i][2]);
					break;
				}
			}
			
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
		}
		
		public function setOpt(_cl:MovieClip,_i:int=0){
			if(_cl.name=="vibro_b"){
				if(!_cl["press_cl"].visible){
					stg_cl["expl_on"]=true;
				}else{
					stg_cl["expl_on"]=false;
				}
			}else if(_cl.name=="tracks_b"){
				if(!_cl["press_cl"].visible){
					stg_cl["track_on"]=true;
				}else{
					stg_cl["track_on"]=false;
				}
			}else if(_cl.name=="rad_b"){
				if(!_cl["press_cl"].visible){
					stg_cl["rad_on"]=true;
				}else{
					stg_cl["rad_on"]=false;
				}
			}else if(_cl.name=="smoke_b"){
				if(!_cl["press_cl"].visible){
					stg_cl["smoke_on"]=true;
				}else{
					stg_cl["smoke_on"]=false;
				}
			}else if(_cl.name=="bull_b"){
				if(!_cl["press_cl"].visible){
					stg_cl["bull_on"]=true;
				}else{
					stg_cl["bull_on"]=false;
				}
			}else if(_cl.name=="expl_b"){
				if(!_cl["press_cl"].visible){
					stg_cl["expl_norm"]=true;
				}else{
					stg_cl["expl_norm"]=false;
				}
			}else if(_cl.name=="game_s_b"){
				if(!_cl["press_cl"].visible){
					stg_cl["sound_on"][0]=true;
				}else{
					stg_cl["sound_on"][0]=false;
				}
			}else if(_cl.name=="serv_s_b"){
				if(!_cl["press_cl"].visible){
					stg_cl["sound_on"][1]=true;
				}else{
					stg_cl["sound_on"][1]=false;
				}
			}else if(_cl.name.slice(0,4)=="port"){
				//trace(_cl.name+"   "+int(root["win1"]["port_tx"+int(_cl.name.slice(4,7))].text));
				if(stg_cl["ports_ar"].length>0){
					if(_cl["press_cl"].visible){
						if(int(root["win1"]["port_tx"+int(_cl.name.slice(4,7))].text)>0){
							if(_i==0&&stg_cl["port_now"]<=0){
								var _str:String="Внимание!\nНастройки порта соединения предназначены для опытных пользователей! Выбор порта влияет на скорость соединения с сервером. Меняй порт либо понимая с какой целью это делается, либо по рекомендации Генштаба.";
								stg_cl.warn_f(5,_str,5);
							}
							for(var m:int=0;m<5;m++){
								if(root["win1"]["port"+m]!=_cl){
									root["win1"]["port"+m]["press_cl"].visible=false;
								}
							}
							stg_cl["port_now"]=int(root["win1"]["port_tx"+int(_cl.name.slice(4,7))].text);
						}else{
							for(var m:int=0;m<4;m++){
								root["win1"]["port"+m]["press_cl"].visible=false;
							}
							root["win1"]["port4"]["press_cl"].visible=true;
							stg_cl["port_now"]=0;
						}
					}
				}else{
					stg_cl["ports_ch"][int(_cl.name.slice(4,7))]=_cl["press_cl"].visible;
				}
			}
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			Mouse.cursor=MouseCursor.BUTTON;
			gotoAndStop("over");
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			Mouse.cursor=MouseCursor.AUTO;
			gotoAndStop("out");
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(this["press_cl"]!=null){
				if(!this["press_cl"].visible){
					this["press_cl"].visible=true;
				}else{
					this["press_cl"].visible=false;
				}
				setOpt(this);
			}else{
				gotoAndStop("press");
			}
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(name=="close_all"){
				stg_cl.showOpt();
			}
			gotoAndStop("over");
		}

	}
	
}
