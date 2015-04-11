package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.system.Security;
	import flash.system.System;
	
	public class ak_button extends MovieClip{
		
		public static var stg_cl:MovieClip;
		public static var serv_url:String="";
		public static var stg_class:Class;
		
		public function urlInit(url:String,cl:MovieClip){
			serv_url=url;
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public function ak_button() {
			super();
			Security.allowDomain("*");
			stop();
			
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
			//win_reset();
		}
		
		public function win_reset(){
			root["begin_cl"].visible=false;
			root["end_cl"].visible=false;
			root["diplom_cl"].visible=false;
			root["ege_cl"].visible=false;
			root["kurs"].visible=false;
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//trace(stg_cl["wall_win"]+"   "+stg_cl["warn_er"]+"   "+root["ready_cl"].visible);
			if(stg_cl["wall_win"]||stg_cl["warn_er"]){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			Mouse.cursor=MouseCursor.BUTTON;
			try{
				gotoAndStop("over");
			}catch(er:Error){}
		}
		
		public function m_out(event:MouseEvent){
			if(currentFrameLabel=="empty"){
				return;
			}
			Mouse.cursor=MouseCursor.AUTO;
			try{
				gotoAndStop("out");
			}catch(er:Error){}
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//trace(stg_cl["wall_win"]+"   "+stg_cl["warn_er"]+"   "+root["ready_cl"].visible);
			if(stg_cl["wall_win"]||stg_cl["warn_er"]){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			try{
				gotoAndStop("press");
			}catch(er:Error){}
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//trace(stg_cl["wall_win"]+"   "+stg_cl["warn_er"]+"   "+root["ready_cl"].visible);
			if(stg_cl["wall_win"]||stg_cl["warn_er"]){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			if(name=="close_cl"||name=="out_cl"){
				parent.visible=false;
			}else if(name=="close_par"||name=="out_par"){
				stg_cl.createMode(1);
			}else if(name.slice(0,6)=="battle"){
				sendRequest([["query"],["action"]],[["id"],["id","battle"]],[["10"],["4",""+this["ID"]]]);
			}else if(name.slice(0,6)=="zachot"){
				if(parent==root["kurs"]){
					sendRequest([["query"],["action"]],[["id"],["id","predmet"]],[["10"],["3",""+this["ID"]]]);
				}else if(parent==root["ege_cl"]){
					sendRequest([["query"],["action"]],[["id"],["id","predmet"]],[["10"],["5",""+this["ID"]]]);
				}
			}
			try{
				gotoAndStop("over");
			}catch(er:Error){}
		}
		
		public function sendRequest(names:Array, attr:Array, idies:Array, _i:int=0){
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
				if(int(idies[0][0])==10){
					if(int(idies[1][0])==1){
						loader.addEventListener(Event.COMPLETE, to_akademy);
					}else if(int(idies[1][0])==2){
						loader.addEventListener(Event.COMPLETE, to_kurs);
					}else if(int(idies[1][0])==3){
						loader.addEventListener(Event.COMPLETE, get_predmet);
					}else if(int(idies[1][0])==4){
						loader.addEventListener(Event.COMPLETE, get_battle);
					}else if(int(idies[1][0])==5){
						loader.addEventListener(Event.COMPLETE, get_gos);
						stg_cl.warn_f(10,"Идёт подготовка сценария битвы.");
						b=1;
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
			}
			//trace("str\n"+strXML);
			list=new XML(strXML);
			//trace("s_xml\n"+list+"\n");
			var variables:URLVariables = new URLVariables();
			variables.query = list;
			variables.send = "send";
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			if(b==0){
				stg_cl.warn_f(10,"");
			}else if(b==2){
				stg_cl.warn_f(14,"");
			}
			loader.load(rqs);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function onError(event:IOErrorEvent):void{
			//trace("Select+php2: "+event);
			stg_cl.warn_f(4,"Академия");
		}
		
		public function get_gos(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПоступление в академию.");
				stg_cl.erTestReq(3,12,str);
				return;
			}
			
			//trace("get_predmet\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			
			
			//stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function get_predmet(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПоступление в академию.");
				stg_cl.erTestReq(3,12,str);
				return;
			}
			
			//trace("get_predmet\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			this.visible=false;
			if(int(list.child("err")[0].attribute("kurs"))<4){
				root["kurs"]["bg_fon"]["ak_tx"].text=int(list.child("err")[0].attribute("money_za"));
				if(int(this.name.slice(6,8))<11&&root["kurs"]["line_cl"+(int(this.name.slice(6,8))+1)].visible){
					if(this.name.slice(0,6)=="zachot"&&root["kurs"]["zachot"+(int(this.name.slice(6,8))+1)]["price"]<=int(root["kurs"]["bg_fon"]["ak_tx"].text)){
						root["kurs"]["zachot"+(int(this.name.slice(6,8))+1)].gotoAndStop("out");
					}
				}
			}
			if(stg_cl["kurs"]!=int(list.child("err")[0].attribute("kurs"))){
				sendRequest([["query"],["action"]],[["id"],["id"]],[["10"],["2"]]);
			}
			//stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function get_battle(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПоступление в академию.");
				stg_cl.erTestReq(3,12,str);
				return;
			}
			
			//trace("get_battle\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			this.visible=false;
			if(int(list.child("err")[0].attribute("kurs"))<4){
				root["kurs"]["bg_fon"]["ak_tx"].text=int(list.child("err")[0].attribute("money_za"));
			}
			if(stg_cl["kurs"]!=int(list.child("err")[0].attribute("kurs"))){
				sendRequest([["query"],["action"]],[["id"],["id"]],[["10"],["2"]]);
			}
			//stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function to_akademy(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПоступление в академию.");
				stg_cl.erTestReq(3,12,str);
				return;
			}
			
			//trace("to_akademy\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			sendRequest([["query"],["action"]],[["id"],["id"]],[["10"],["2"]]);
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function to_kurs(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nЗадачи курса академии.");
				stg_cl.erTestReq(3,12,str);
				return;
			}
			
			//trace("to_kurs\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			win_reset();
			
			for(var j:int=0;j<12;j++){
				root["kurs"]["zachot"+j].visible=false;
				root["kurs"]["line_cl"+j].visible=false;
			}
			for(var j:int=0;j<8;j++){
				root["kurs"]["zachot"+j].visible=false;
			}
			
			if(int(list.child("akademia")[0].attribute("kurs"))<4){
				root["kurs"]["kurs_tx"].text=list.child("akademia")[0].attribute("kurs");
				for(var j:int=0;j<list.child("akademia")[0].child("predmety")[0].child("predmet").length();j++){
					//trace("a   "+j);
					root["kurs"]["line_cl"+j].visible=true;
					root["kurs"]["zachot"+j].ID=list.child("akademia")[0].child("predmety")[0].child("predmet")[j].attribute("id");
					root["kurs"]["zachot"+j].price=int(list.child("akademia")[0].child("predmety")[0].child("predmet")[j].attribute("za_need"));
					if(int(list.child("akademia")[0].child("predmety")[0].child("predmet")[j].attribute("hidden"))==2){
						root["kurs"]["zachot"+j].visible=false;
					}else{
						if(int(list.child("akademia")[0].child("predmety")[0].child("predmet")[j].attribute("hidden"))==1){
							root["kurs"]["zachot"+j].gotoAndStop("empty");
						}else{
							root["kurs"]["zachot"+j].gotoAndStop("out");
						}
						root["kurs"]["zachot"+j].visible=true;
					}
					root["kurs"]["line_cl"+j]["num_tx"].text=(j+1);
					root["kurs"]["line_cl"+j]["name_tx"].text=list.child("akademia")[0].child("predmety")[0].child("predmet")[j].attribute("name");
					root["kurs"]["line_cl"+j]["ak_tx"].text="Знаков Академии: "+list.child("akademia")[0].child("predmety")[0].child("predmet")[j].attribute("za_need");
				}
				for(j=0;j<list.child("akademia")[0].child("battles")[0].child("battle").length();j++){
					//trace("b   "+j);
					root["kurs"]["battle"+j].ID=list.child("akademia")[0].child("battles")[0].child("battle")[j].attribute("id");
					root["kurs"]["bg_fon"]["num_tx"+j].text=list.child("akademia")[0].child("battles")[0].child("battle")[j].attribute("num")+"/"+list.child("akademia")[0].child("battles")[0].child("battle")[j].attribute("need");
					if(int(list.child("akademia")[0].child("battles")[0].child("battle")[j].attribute("hidden"))==2){
						root["kurs"]["bg_fon"]["num_tx"+j].textColor=0x003300;
						root["kurs"]["battle"+j].visible=false;
					}else{
						root["kurs"]["bg_fon"]["num_tx"+j].textColor=0x003300;
						root["kurs"]["battle"+j].visible=true;
						if(int(list.child("akademia")[0].child("battles")[0].child("battle")[j].attribute("hidden"))==1){
							root["kurs"]["battle"+j].gotoAndStop("empty");
							root["kurs"]["bg_fon"]["num_tx"+j].textColor=0xff0000;
						}else{
							root["kurs"]["battle"+j].gotoAndStop("out");
						}
					}
				}
				root["kurs"].visible=true;
				root["kurs"]["bg_fon"]["ak_tx"].text=int(list.child("akademia")[0].attribute("money_za"));
			}else if(int(list.child("akademia")[0].attribute("kurs"))==4){
				for(var j:int=0;j<list.child("akademia")[0].child("gosy")[0].child("gos").length();j++){
					//trace("a   "+j);
					root["ege_cl"]["zachot"+j].ID=list.child("akademia")[0].child("gosy")[0].child("gos")[j].attribute("id");
					if(int(list.child("akademia")[0].child("gosy")[0].child("gos")[j].attribute("hidden"))==2){
						root["ege_cl"]["zachot"+j].visible=false;
					}else{
						if(int(list.child("akademia")[0].child("gosy")[0].child("gos")[j].attribute("hidden"))==1){
							root["ege_cl"]["zachot"+j].gotoAndStop("empty");
						}else{
							root["ege_cl"]["zachot"+j].gotoAndStop("out");
						}
						root["ege_cl"]["zachot"+j].visible=true;
					}
				}
				for(j=0;j<list.child("akademia")[0].child("battles")[0].child("battle").length();j++){
					//trace("b   "+j);
					root["ege_cl"]["bg_fon"]["num_tx"+j].text=int(list.child("akademia")[0].child("battles")[0].child("battle")[j].attribute("num"))+"";
					if(int(list.child("akademia")[0].child("battles")[0].child("battle")[j].attribute("hidden"))==2){
						root["ege_cl"]["bg_fon"]["num_tx"+j].textColor=0x003300;
					}
				}
				root["ege_cl"].visible=true;
				root["ege_cl"]["bg_fon"]["ak_tx"].text=int(list.child("akademia")[0].attribute("money_za"));
			}else{
				for(j=0;j<list.child("akademia")[0].child("battles")[0].child("battle").length();j++){
					//trace("b   "+j);
					root["diplom_cl"]["bg_fon"]["num_tx"+j].text=int(list.child("akademia")[0].child("battles")[0].child("battle")[j].attribute("num"))+"";
					if(int(list.child("akademia")[0].child("battles")[0].child("battle")[j].attribute("hidden"))==2){
						root["diplom_cl"]["bg_fon"]["num_tx"+j].textColor=0x003300;
					}
				}
				root["diplom_cl"]["bg_fon"]["ak_tx"].text=int(list.child("akademia")[0].attribute("money_za"));
				root["diplom_cl"].visible=true;
			}
			
			if(stg_cl["kurs"]!=int(list.child("akademia")[0].attribute("kurs"))){
				if(int(list.child("akademia")[0].attribute("kurs"))<4){
					root["begin_cl"].visible=true;
					root["begin_cl"]["kurs_tx"].text=int(list.child("akademia")[0].attribute("kurs"));
				}else if(int(list.child("akademia")[0].attribute("kurs"))>=5){
					root["end_cl"].visible=true;
					root["end_cl"]["ak_tx"].text=int(list.child("akademia")[0].attribute("money_za"));
				}
			}
			stg_cl["kurs"]=int(list.child("akademia")[0].attribute("kurs"));
			
			stg_cl.warn_f(9,"");
			stg_cl.createMode(8);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
	}
}
