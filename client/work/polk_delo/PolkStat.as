package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.*;
	import flash.net.*;
	import flash.text.*;
	
	public class PolkStat extends MovieClip{
		
		public static var txt0:TextField=new TextField();
		public static var txt1:TextField=new TextField();
		public static var txt2:TextField=new TextField();
		public static var txt3:TextField=new TextField();
		public static var txt4:TextField=new TextField();
		public static var txt5:TextField=new TextField();
		public static var txt6:TextField=new TextField();
		public static var txt7:TextField=new TextField();
		public static var txt8:TextField=new TextField();
		public static var txt9:TextField=new TextField();
		public static var txt10:TextField=new TextField();
		public static var txt11:TextField=new TextField();
		public static var txt12:TextField=new TextField();
		public static var txt13:TextField=new TextField();
		public static var txt14:TextField=new TextField();
		public static var txt15:TextField=new TextField();
		public static var txt16:TextField=new TextField();
		public static var txt17:TextField=new TextField();
		public static var txt18:TextField=new TextField();
		public static var txt19:TextField=new TextField();
		public static var tf:TextFormat=new TextFormat("Verdana", 9, 0x195F1E, true, false);
		
		public var m_active:Boolean=false;
		public var i_text:String="";
		public var i_link:String="";
		public var i_id:Number=0;
		public static var offline:int=0;
		public static var mode_num:int=0;
		public static var pages:int=0;
		public static var page:int=0;
		
		public static var wind1:MovieClip;
		public static var wind2:MovieClip;
		public static var wind3:MovieClip;
		public static var mdl:MovieClip;
		
		public static var stg_cl:MovieClip;
		public static var serv_url:String="empty";
		public static var stg_class:Class;
		
		public static var d_names:Array=new Array();
		public static var d_text:Array=new Array();
		
		public function urlInit(url:String,clip:MovieClip){
			serv_url=url;
			stg_cl=clip;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public function PolkStat(){
			super();
			Security.allowDomain("*");
			stop();
			//trace(name);
			if(name=="ch3"){
				wind1=new MovieClip();
				wind2=new MovieClip();
				wind3=new reit();
				mdl=new MovieClip();
				mdl.x=13;
				mdl.y=27;
				wind1.x=wind2.x=wind3.x=17;
				wind1.y=wind2.y=wind3.y=76;
				clearReit();
				setWind(3);
				m_active=true;
				name_tx.textColor=0x0F3C06;
				name_tx.text="Рейтинг";
				gotoAndStop(1);
				for(var i:int=0;i<20;i++){
					try{
						PolkStat["txt"+i].name="txt"+i;
						PolkStat["txt"+i].addEventListener(MouseEvent.MOUSE_OVER, m_over);
						PolkStat["txt"+i].addEventListener(MouseEvent.MOUSE_OUT, m_out);
						PolkStat["txt"+i].addEventListener(MouseEvent.MOUSE_DOWN, m_press);
						PolkStat["txt"+i].addEventListener(MouseEvent.MOUSE_UP, m_release);
						//wind2["scroll_cl"]["sc"].addEventListener(MouseEvent.MOUSE_MOVE, m_move);
					}catch(er:Error){
						
					}
				}
			}else if(name=="ch2"){
				name_tx.textColor=0xFFFFFF;
				name_tx.text="Достижения";
				gotoAndStop(2);
			}else if(name=="ch1"){
				name_tx.textColor=0xFFFFFF;
				name_tx.text="Статистика";
				gotoAndStop(2);
			}
			
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
		}
		
		public function de_active(){
			for(var i:int=1;i<4;i++){
				try{
					root["ch"+i]["m_active"]=false;
					root["ch"+i].gotoAndStop("out");
					root["ch"+i]["name_tx"].textColor=0xFFFFFF;
				}catch(er:Error){
					
				}
			}
		}
		
		public function setWind(m_mode:int){
			if(mode_num==m_mode){
				return;
			}
			if(m_mode==1){
				try{
					root["wind_cl"].parent.removeChild(wind2);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind3);
				}catch(er:Error){}
				root["wind_cl"].parent.addChild(wind1);
			}else if(m_mode==2){
				try{
					root["wind_cl"].parent.removeChild(wind1);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind3);
				}catch(er:Error){}
				root["wind_cl"].parent.addChild(wind2);
			}else if(m_mode==3){
				clearReit();
				try{
					root["wind_cl"].parent.removeChild(wind1);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind2);
				}catch(er:Error){}
				root["wind_cl"].parent.addChild(wind3);
			}
			mode_num=m_mode;
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//trace(event.currentTarget.name+"   "+name);
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				Mouse.cursor=MouseCursor.BUTTON;
				if(event.currentTarget.name.slice(0,3)=="txt"){
					event.currentTarget.textColor=0x00ff00;
					return;
				}
				if(name.slice(0,2)=="ch"){
					if(!m_active){
						Mouse.cursor=MouseCursor.BUTTON;
						name_tx.textColor=0xFFFF00;
						gotoAndStop("over");
					}
				}else{
					gotoAndStop("over");
				}
			}
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			Mouse.cursor=MouseCursor.AUTO;
			if(event.currentTarget.name.slice(0,3)=="txt"){
				if(int(event.currentTarget.text)!=page){
					event.currentTarget.textColor=0x195F1E;
				}
				return;
			}
			if(name.slice(0,2)=="ch"){
				if(!m_active){
					name_tx.textColor=0xFFFFFF;
					gotoAndStop("out");
				}
			}else{
				gotoAndStop("out");
			}
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
			}
			if(event.currentTarget.name.slice(0,3)=="txt"){
				if(event.currentTarget.parent==wind3){
					sendRequest([["query"],["action"]],[["id"],["id","page","search_me"]],[["9"],["16",event.currentTarget.text+"",0+""]]);
				}else if(event.currentTarget.parent==mdl){
					sendRequest([["query"],["action"]],[["id"],["id","page","user_id"]],[["2"],["8",event.currentTarget.text,""+us_id]]);
				}
				return;
			}else if(name.slice(0,2)=="ch"){
				if(!m_active){
					setWind(int(name.slice(2,3)));
					de_active();
					name_tx.textColor=0x0F3C06;
					gotoAndStop("press");
					m_active=true;
					if(name=="ch1"){
						//root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["2"],["4",""+us_id]]);
					}else if(name=="ch3"){
						sendRequest([["query"],["action"]],[["id"],["id","page","search_me"]],[["9"],["16",0+"",0+""]]);
					}else if(name=="ch2"){
						//root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["2"],["6",""+us_id]]);
					}
				}
			}else{
				if(name=="exit_cl"){
					stg_cl.createMode(1);
				}/*else if(name=="left1"){
					sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5","1",offline+""]]);
				}else if(name=="left2"){
					if((page-10)>0){
						sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5",(page-10)+"",offline+""]]);
					}else{
						sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5","1",offline+""]]);
					}
				}else if(name=="right1"){
					sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5",pages+"",offline+""]]);
				}else if(name=="right2"){
					if((page+10)<pages){
						sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5",(page+10)+"",offline+""]]);
					}else{
						sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5",pages+"",offline+""]]);
					}
				}else if(name=="left1_m"){
					sendRequest([["query"],["action"]],[["id"],["id","page","user_id"]],[["2"],["8","1",""+us_id]]);
				}else if(name=="left2_m"){
					if((page-10)>0){
						sendRequest([["query"],["action"]],[["id"],["id","page","user_id"]],[["2"],["8",(page-10)+"",""+us_id]]);
					}else{
						sendRequest([["query"],["action"]],[["id"],["id","page","user_id"]],[["2"],["8","1",""+us_id]]);
					}
				}else if(name=="right1_m"){
					//clearMedals()
					sendRequest([["query"],["action"]],[["id"],["id","page","user_id"]],[["2"],["8",pages+"",""+us_id]]);
				}else if(name=="right2_m"){
					if((page+10)<pages){
						sendRequest([["query"],["action"]],[["id"],["id","page","user_id"]],[["2"],["8",(page+10)+"",""+us_id]]);
					}else{
						sendRequest([["query"],["action"]],[["id"],["id","page","user_id"]],[["2"],["8",pages+"",""+us_id]]);
					}
				}else if(name=="find_self"){
					sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5","0",offline+""]]);
				}*/
				gotoAndStop("press");
			}
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
			}
			if(name.slice(0,4)=="link"){
				stg_cl.linkTo(new URLRequest(i_link));
			}else if(name.slice(0,4)=="look"){
				/*us_id=i_id;
				de_active();
				root["ch1"]["name_tx"].textColor=0x0F3C06;
				root["ch1"].gotoAndStop("press");
				root["ch1"]["m_active"]=true;
				name_pl=parent["rang"+name.slice(4,5)].text+" "+parent["name"+name.slice(4,5)].text;
				clearStat();
				clearReit();
				sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["2"],["4",""+i_id]]);
				mode_num=1;
				root["wind_cl"].parent.addChild(wind1);
				root["wind_cl"].parent.removeChild(wind3);*/
			}
			if(name.slice(0,2)!="ch"){
				gotoAndStop("over");
			}
		}
		
		public function clear_id(){
			us_id=0;
		}
		
		public function sendRequest(names:Array, attr:Array, idies:Array){
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
				if(int(idies[0][0])==9){
					if(int(idies[1][0])==16){
						loader.addEventListener(Event.COMPLETE, getReiting);
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
			list=new XML(strXML);
			//trace("s_xml\n"+list+"\n");
			var variables:URLVariables = new URLVariables();
			variables.query = list;
			variables.send = "send";
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			stg_cl.warn_f(10,"");
			loader.load(rqs);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function onError(event:IOErrorEvent):void{
			stg_cl.warn_f(4,"Статистика полка");
		}
		
		public function clearReit(){
			for(var i:int=0;i<24;i++){
				try{
					wind3["rang"+i].text="";
					wind3["name"+i].text="";
					wind3["cmd"+i].text="";
					wind3["num"+i].text="";
					wind3["reit_tx"+i].text="";
					wind3["rang"+i].textColor=0x195F1E;
					wind3["name"+i].textColor=0x195F1E;
					wind3["cmd"+i].textColor=0x195F1E;
					wind3["num"+i].textColor=0x195F1E;
					wind3["reit_tx"+i].textColor=0x195F1E;
					wind3["look"+i].visible=false;
					wind3["link"+i].visible=false;
					wind3["link"+i]["i_link"]="";
					wind3["fon_s"+i].gotoAndStop(1);
				}catch(er:Error){
					trace("er "+i);
				}
			}
			for(var i:int=0;i<20;i++){
				try{
					PolkStat["txt"+i].text="";
					wind3.removeChild(PolkStat["txt"+i]);
				}catch(er:Error){
					continue;
				}
			}
			us_h=new Array();
		}
		
		public static var us_id:Number=0;
		public static var us_h:Array=new Array();
		
		public function getReiting(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				trace(str+"\n"+er);
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nРейтинг полков: страница.");
				stg_cl.erTestReq(2,5,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			//trace("Reiting   "+list);
			
			var s1:String="polk";
			clearReit();
			for(var i:int=0;i<list.child("polks_top").child(s1).length();i++){
				try{
					wind3["rang"+i].text=list.child("polks_top").child(s1)[i].attribute("commander_rang")+"";
					wind3["name"+i].text=list.child("polks_top").child(s1)[i].attribute("commander_name")+"";
					wind3["num"+i].text=list.child("polks_top").child(s1)[i].attribute("name")+"";
					wind3["reit_tx"+i].text=list.child("polks_top").child(s1)[i].attribute("top")+"";
					wind3["look"+i].visible=true;
					wind3["link"+i].visible=true;
					wind3["link"+i]["i_link"]=list.child("polks_top").child(s1)[i].attribute("sn_link")+"";
					wind3["look"+i]["i_id"]=list.child("polks_top").child(s1)[i].attribute("id");
					if(int(list.child("polks_top").child(s1)[i].attribute("id"))==stg_cl["polk_id"]){
						wind3["rang"+i].textColor=0xff0000;
						wind3["name"+i].textColor=0xff0000;
						wind3["num"+i].textColor=0xff0000;
						wind3["reit_tx"+i].textColor=0xff0000;
					}
					wind3["cmd"+i].textColor=0xffffff;
					if(int(list.child("polks_top").child(s1)[i].attribute("type"))==0){
						wind3["cmd"+i].text="Кадрированный";
					}else if(int(list.child("polks_top").child(s1)[i].attribute("type"))==1){
						wind3["cmd"+i].text="Боевой";
					}else if(int(list.child("polks_top").child(s1)[i].attribute("type"))==2){
						wind3["cmd"+i].text="Гвардейский";
					}
					wind3["fon_s"+i].gotoAndStop(int(list.child("polks_top").child(s1)[i].attribute("type"))+2);
				}catch(er:Error){
					//trace(i);
					continue;
				}
			}
			var count:int=0;
			var count1:int=0;
			var count2:int=0;
			var w:int=0;
			var vect:int=0;
			pages=int(list.child("pages")[0].attribute("page_max"));
			page=int(list.child("pages")[0].attribute("now"));
			//trace(pages+"   "+page);
			var cicle:int=10;
			if(page<5){
				cicle+=(5-page)*2;
			}
			for(var i:int=0;i<cicle;i++){
				//trace(page+"   "+pages+"   "+vect);
				if((page-vect)>0&&(page-vect)<=pages){
					if(vect==5){
						break;
					}
					count=5-vect;
					PolkStat["txt"+count].embedFonts=true;
					PolkStat["txt"+count].selectable=false;
					PolkStat["txt"+count].multiline=false;
					PolkStat["txt"+count].autoSize=TextFieldAutoSize.LEFT;
					PolkStat["txt"+count].wordWrap=false;
					PolkStat["txt"+count].antiAliasType=AntiAliasType.ADVANCED;
					PolkStat["txt"+count].defaultTextFormat=tf;
					if(vect==0){
						PolkStat["txt"+count].textColor=0x00ff00;
					}else{
						PolkStat["txt"+count].textColor=0x195F1E;
					}
					PolkStat["txt"+count].text=(page-vect)+"";
					PolkStat["txt"+count].y=333;
					w+=PolkStat["txt"+count].width+10;
					//trace(PolkStat["txt"+count].text+"   "+count+"   "+vect+"   "+PolkStat["txt"+count].width+"   "+w);
					if(w>175){
						//trace("count1   "+count);
						PolkStat["txt"+count].text="";
						break;
					}
					if(vect<0){
						vect--;
					}else if(vect==0){
						vect=-1;
					}
					vect=-vect;
					count1=count;
					count2++;
				}else{
					if(vect<0){
						vect--;
					}else if(vect==0){
						vect=-1;
					}
					vect=-vect;
				}
			}
			count=0;
			for(var i:int=0;i<20;i++){
				if(PolkStat["txt"+i].text!=""){
					if(count>0){
						//trace(PolkStat["txt"+(i-1)].width+"   "+PolkStat["txt"+(i-1)].height);
						PolkStat["txt"+i].x=PolkStat["txt"+(i-1)].x+PolkStat["txt"+(i-1)].width+10;
					}else{
						//trace(PolkStat["txt"+(i)].width+"   "+PolkStat["txt"+(i)].height);
						PolkStat["txt"+i].x=305;
					}
					//trace(i+"   "+PolkStat["txt"+i].text+"   "+PolkStat["txt"+i].x);
					wind3.addChild(PolkStat["txt"+i]);
					count++;
				}
			}
			
			root["ch3"].setWind(3);
			root["ch3"].de_active();
			root["ch3"]["name_tx"].textColor=0x0F3C06;
			root["ch3"].gotoAndStop("press");
			root["ch3"]["m_active"]=true;
			stg_cl.createMode(7);
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
	}
}
