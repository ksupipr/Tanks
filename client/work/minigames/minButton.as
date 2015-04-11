package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.media.SoundChannel;
	
	public class minButton extends MovieClip{
		
		public static var wind1:MovieClip;
		public static var wind2:MovieClip;
		public static var wind3:MovieClip;
		public static var wind4:MovieClip;
		
		public static var stg_cl:MovieClip;
		public static var serv_url:String="empty";
		public static var stg_class:Class;
		public static var mode_num:int=0;
		
		public var m_active:Boolean=false;
		
		public function urlInit(url:String,clip:MovieClip){
			serv_url=url;
			stg_cl=clip;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public function minButton(){
			super();
			Security.allowDomain("*");
			stop();
			if(name=="ch1"){
				wind1=new game1();
				wind2=new game2();
				//wind3=new reiting();
				//wind3=new medals();
				for(var i:int=0;i<3;i++){
					wind2["ra"+i].visible=false;
					wind2["ra"+i].stop();
					var fr:int=int((Math.random()*8)+1);
					for(var j:int=-1;j<2;j++){
						var fr1:int=fr+j;
						if(fr1==9){
							fr1=1;
						}else if(fr==0){
							fr1=9;
						}
						wind2["r"+((3+i)+j*3)].gotoAndStop(fr1);
					}
				}
				wind2["get_tx"].text="";
				wind2["time_tx"].text="";
				wind2["what_tx"].text="";
				wind2["win_tx"].text="";
				wind2["lamp_cl"].gotoAndStop(1);
				wind2["win_cl"].visible=false;
				setWind(1);
				clearGame1();
				wind1.x=20;
				wind1.y=77;
				wind2.x=31;
				wind2.y=87;
				m_active=true;
				name_tx.textColor=0x0F3C06;
				gotoAndStop(1);
			}else if(name=="ch2"){
				name_tx.textColor=0xFFFFFF;
				gotoAndStop(2);
			}else if(name=="ch3"){
				name_tx.textColor=0x333333;
				gotoAndStop(2);
			}else if(name=="ch4"){
				name_tx.textColor=0x333333;
				gotoAndStop(2);
			}
			
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
		}
		
		public function Reklame(a:String,b:String,c:MovieClip,d:int){
			//trace(a);
			//trace(b);
			//trace(c);
			//trace(d);
			if(d==1){
				wind1["reklame1"]["name_tx"].text=a;
				wind1["reklame1"]["dscr_tx"].text=b;
				wind1["reklame1"].addChild(c);
			}else if(d==2){
				wind2["reklame2"]["name_tx"].text=a;
				wind2["reklame2"]["dscr_tx"].text=b;
				wind2["reklame2"].addChild(c);
			}
		}
		
		public function resetRkl(c:Array){
			try{
				wind1["reklame1"].removeChild(c[3]);
			}catch(er:Error){}
			try{
				wind2["reklame2"].removeChild(c[4]);
			}catch(er:Error){}
			try{
				wind1["reklame1"]["name_tx"].text="";
				wind1["reklame1"]["dscr_tx"].text="";
				wind2["reklame2"]["name_tx"].text="";
				wind2["reklame2"]["dscr_tx"].text="";
			}catch(er:Error){}
		}
		
		public function setWind(m_mode:int){
			if(mode_num==m_mode){
				return;
			}
			try{
				clearGame2();
			}catch(er:Error){}
			if(m_mode==1){
				try{
					root["wind_cl"].parent.removeChild(wind2);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind3);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind4);
				}catch(er:Error){}
				root["wind_cl"].parent.addChild(wind1);
			}else if(m_mode==2){
				try{
					root["wind_cl"].parent.removeChild(wind1);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind3);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind4);
				}catch(er:Error){}
				root["wind_cl"].parent.addChild(wind2);
			}else if(m_mode==3){
				try{
					root["wind_cl"].parent.removeChild(wind1);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind2);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind4);
				}catch(er:Error){}
				root["wind_cl"].parent.addChild(wind3);
			}else if(m_mode==4){
				try{
					root["wind_cl"].parent.removeChild(wind1);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind2);
				}catch(er:Error){}
				try{
					root["wind_cl"].parent.removeChild(wind3);
				}catch(er:Error){}
				root["wind_cl"].parent.addChild(wind4);
			}
			mode_num=m_mode;
		}
		
		public function de_active(){
			for(var i:int=1;i<3;i++){
				try{
					root["ch"+i]["m_active"]=false;
					root["ch"+i].gotoAndStop("out");
					root["ch"+i]["name_tx"].textColor=0xFFFFFF;
				}catch(er:Error){
					
				}
			}
		}
		
		public function m_over(event:MouseEvent){
			//trace(event.currentTarget.name+"   "+name);
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				if(name=="ch3"||name=="ch4"){
					return;
				}
				Mouse.cursor=MouseCursor.BUTTON;
				if(name.slice(0,2)=="ch"){
					if(!m_active){
						if(!wind1["wait_cl"].visible&&!wind2["ra0"].visible){
							Mouse.cursor=MouseCursor.BUTTON;
							name_tx.textColor=0xFFFF00;
							gotoAndStop("over");
						}
					}
				}else{
					if(name=="close_cl"||name=="try_cl"){
						if(!wind1["wait_cl"].visible){
							gotoAndStop("over");
						}
					}else if(name=="start_cl"){
						if(!wind2["win_cl"].visible&&!wind2["ra0"].visible)
							gotoAndStop("over");
					}else{
						gotoAndStop("over");
					}
				}
			}
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			Mouse.cursor=MouseCursor.AUTO;
			if(name=="ch3"||name=="ch4"){
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
		
		public function f_wins(){
			wind1["w_w_cl"].visible=false;
			wind1["w_d_cl"].visible=false;
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				if(name=="ch3"||name=="ch4"){
					return;
				}
				if(name.slice(0,2)=="ch"){
					if(!m_active){
						if(!wind1["wait_cl"].visible&&!wind2["ra0"].visible){
							setWind(int(name.slice(2,3)));
							de_active();
							name_tx.textColor=0x0F3C06;
							m_active=true;
							stg_cl.warn_f(10,"");
							f_wins();
							//stg_class.shop["exit"].resetRkl();
							if(name=="ch1"){
								root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","action_type","type"]],[["6"],["1","0","1"]]);
							}else if(name=="ch2"){
								root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","action_type"]],[["6"],["2","0"]]);
							}
						}
					}
				}
				if(name=="close_cl"||name=="try_cl"){
					if(!wind1["wait_cl"].visible){
						gotoAndStop("press");
					}
				}else if(name=="start_cl"){
					if(!wind2["win_cl"].visible&&!wind2["ra0"].visible)
						gotoAndStop("press");
				}else{
					gotoAndStop("press");
				}
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
				if(name=="ch3"||name=="ch4"){
					return;
				}
				if(name.slice(0,2)=="ch"){
					//if(!m_active){
						if(!wind1["wait_cl"].visible){
							name_tx.textColor=0xFFFF00;
							gotoAndStop("over");
						}
					//}
				}else{
					if(name=="close_cl"){
						if(!wind1["wait_cl"].visible&&!wind2["ra0"].visible){
							stg_cl.createMode(1);
						}
					}else if(name=="try_cl"){
						if(wind1["wait_cl"].visible||wind1["w_d_cl"].visible||wind1["w_w_cl"].visible||wind1["win_cl"].visible){
							return;
						}
						if(rkl_c1>2){
							//stg_class.shop["exit"].resetRkl();
							rkl_c1=0;
						}else{
							rkl_c1++;
						}
						stopTimer1();
						wind1["wait_cl"].visible=true;
						wind1["wait_cl"]["fill"].width=0;
						wind1["wait_cl"]["time_tx"].text="Доставка: 10 секунд";
						g1_ready=0;
						try{g1Timer.reset();}catch(er:Error){}
						g1Timer=new Timer(40);
						g1Timer.addEventListener(TimerEvent.TIMER, waiting);
						g1Timer.addEventListener(TimerEvent.TIMER_COMPLETE, time_over);
						g1Timer.start();
						root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","action_type","type"]],[["6"],["1","1","1"]]);
					}else if(name=="close1"){
						root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","action_type","type"]],[["6"],["1","0","1"]]);
					}else if(name=="start_cl"){
						if(wind2["win_cl"].visible||wind2["ra0"].visible){
							return;
						}
						if(rkl_c2>2){
							//stg_class.shop["exit"].resetRkl();
							rkl_c2=0;
						}else{
							rkl_c2++;
						}
						for(var i:int=0;i<3;i++){
							wind2["ra"+i].visible=true;
							wind2["ra"+i].gotoAndPlay(int(Math.random()*3)+1);
							tms[i]=int(Math.random()*25)+i*25;
						}
						stg_cl.playSound("a_start",1);
						try{Timer1.reset();}catch(er:Error){}
						Timer1=new Timer(40,0);
						Timer1.start();
						root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","action_type"]],[["6"],["2","1"]]);
					}else if(name=="cl_win_cas"){
						wind2["win_cl"].visible=false;
					}else if(name=="cl_w_d"){
						wind1["w_d_cl"].visible=false;
					}else if(name=="cl_w_w"){
						wind1["w_w_cl"].visible=false;
					}
					gotoAndStop("over");
				}
			}
		}
		
		public static var rkl_c1:int=0;
		public static var rkl_c2:int=0;
		public static var tms:Array=new Array(4);
		
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
				if(int(idies[0][0])==6){
					if(int(idies[1][0])==1){
						if(int(idies[1][1])==0){
							clearGame1();
							loader.addEventListener(Event.COMPLETE, getGame1);
						}else if(int(idies[1][1])==1){
							loader.addEventListener(Event.COMPLETE, getDetail1);
						}
					}else if(int(idies[1][0])==2){
						if(int(idies[1][1])==0){
							//clearGame2();
							loader.addEventListener(Event.COMPLETE, getGame2);
						}else if(int(idies[1][1])==1){
							loader.addEventListener(Event.COMPLETE, startGame2);
						}
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
			loader.load(rqs);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function startGame2(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВезение: пуск.");
				stg_class.wind["choise_cl"].erTestReq(6,2,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=1){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						wind2["win_cl"].visible=true;
					}
					return;
				}
			}catch(er:Error){
				
			}
			//trace("startGame2 xml\n"+list);
			
			var s1:String="rols";
			var s12:String="rol";
			var s2:String="money";
			var s3:String="win";
			wind2["win_tx"].text="";
			stg_class.panel["money_tx"].text=int(stg_class.panel["money_tx"].text)-1;
			var c:int=0;
			if(int(list.child(s1).child(s12)[1].attribute("num"))==int(list.child(s1).child(s12)[2].attribute("num"))){
				c=1;
			}
			
			for(var i:int=0;i<3;i++){
				if(i>0){
					if(int(list.child(s1).child(s12)[0].attribute("num"))==int(list.child(s1).child(s12)[i].attribute("num"))){
						c++;
					}
				}
				for(var j:int=-1;j<2;j++){
					var fr:int=int(list.child(s1).child(s12)[i].attribute("num"))+j;
					if(fr==9){
						fr=1;
					}else if(fr==0){
						fr=9;
					}
					wind2["r"+((3+i)+j*3)].gotoAndStop(fr);
				}
				wind2["ra"+i].visible=true;
				wind2["ra"+i].gotoAndPlay(int(Math.random()*3)+1);
				tms[i]=int(Math.random()*25)+i*25;
			}
			win[0]=c;
			if(c>1){
				//trace("startGame2 xml\n"+list);
				win[1]=int(list.child(s1).child(s12)[0].attribute("num"));
				win[2]=list.child(s3)[0].attribute("name");
				win[3]=int(list.child(s3)[0].attribute("num"));
				win[4]=list.child(s3)[0].attribute("time");
			}else if(c>0){
				//trace("startGame2 xml\n"+list);
				win[2]=list.child(s3)[0].attribute("name");
				win[4]=list.child(s3)[0].attribute("time");
			}
			win[5]=int(list.child(s2)[0].attribute("money_z"));
			win[6]=int(list.child(s2)[0].attribute("money_m"));
			stopTimer1();
			tms[3]=1;
			Timer1=new Timer(40, (tms[0]+tms[1]+tms[2]));
			Timer1.addEventListener(TimerEvent.TIMER, playRand);
			Timer1.start();
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public var channel:SoundChannel = new SoundChannel();
		public var channel1:SoundChannel = new SoundChannel();
		
		public function repeatSnd(event:Event){
			if(wind2["ra"+0].visible){
				channel = new SoundChannel();
				channel = stg_class.sounds[25].play();
				channel.addEventListener(Event.SOUND_COMPLETE, repeatSnd);
			}
		}
		
		public function repeatSnd1(event:Event){
			if(wind2["ra"+0].visible){
				channel = new SoundChannel();
				channel = stg_class.sounds[26].play();
				channel.addEventListener(Event.SOUND_COMPLETE, repeatSnd);
			}
		}
		
		public function playSnd(snd:int){
			channel = new SoundChannel();
			channel = stg_class.sounds[snd].play();
			if(snd==25){
				channel.addEventListener(Event.SOUND_COMPLETE, repeatSnd);
			}else if(snd==26){
				channel.addEventListener(Event.SOUND_COMPLETE, repeatSnd1);
			}
		}
		
		public function playRand(event:TimerEvent){
			if(int(event.currentTarget.currentCount/3)*3==event.currentTarget.currentCount){
				wind2["lamp_cl"].gotoAndStop(2);
			}else{
				wind2["lamp_cl"].gotoAndStop(1);
			}
			if(event.currentTarget.currentCount==event.currentTarget.repeatCount-tms[0]){
				stg_cl.playSound("move2",1);
				wind2["ra"+0].visible=false;
				wind2["ra"+0].stop();
				tms[3]++;
			}
			if(event.currentTarget.currentCount==event.currentTarget.repeatCount-tms[1]){
				stg_cl.playSound("a_stop",1);
				wind2["ra"+1].visible=false;
				wind2["ra"+1].stop();
				tms[3]++;
			}
			if(event.currentTarget.currentCount==event.currentTarget.repeatCount-tms[2]){
				stg_cl.playSound("a_stop",1);
				wind2["ra"+2].visible=false;
				wind2["ra"+2].stop();
				tms[3]++;
			}
			if(tms[3]==4){
				if(win[0]>1){
					stg_cl.playSound("big_win",1);
					wind2["lamp_cl"].gotoAndStop(3);
					wind2["get_tx"].text="Зачислено:";
					wind2["time_tx"].text=win[4];
					wind2["what_tx"].text=win[2];
					wind2["win_tx"].text="Выигрыш: "+win[2];
					if(win[1]==1){
						stg_class.panel["ammo"+5]["quantity"]+=win[3];
						stg_class.panel["ammo0"].resetAmmo();
					}else if(win[1]==2){
						var sl_cl:MovieClip=stg_class.panel["ammo0"].find_sl1(23);
						sl_cl["quantity"]+=win[3];
						sl_cl.ch_num();
					}else if(win[1]==3){
						var sl_cl:MovieClip=stg_class.panel["ammo0"].find_sl1(22);
						sl_cl["quantity"]+=win[3];
						sl_cl.ch_num();
					}else if(win[1]==4){
						var sl_cl:MovieClip=stg_class.panel["ammo0"].find_sl1(19);
						sl_cl["quantity"]+=win[3];
						sl_cl.ch_num();
					}else if(win[1]==7){
						var sl_cl:MovieClip=stg_class.panel["ammo0"].find_sl1(26);
						sl_cl["quantity"]+=win[3];
						sl_cl.ch_num();
					}else if(win[1]==8){
						var sl_cl:MovieClip=stg_class.panel["ammo0"].find_sl1(8);
						sl_cl["quantity"]+=win[3];
						sl_cl.ch_num();
					}
				}else if(win[0]>0){
					var _a_win:int=int(Math.random()*4);
					if(_a_win>0){
						stg_cl.playSound("a_win"+_a_win,1);
					}else{
						stg_cl.playSound("a_win",1);
					}
					wind2["lamp_cl"].gotoAndStop(3);
					wind2["get_tx"].text="Зачислено:";
					wind2["time_tx"].text=win[4];
					wind2["what_tx"].text=win[2];
					wind2["win_tx"].text="Выигрыш: "+win[2];
				}else{
					wind2["lamp_cl"].gotoAndPlay(4);
				}
				stg_class.panel["skills_tx"].text=win[5];
				stg_class.panel["money_tx"].text=win[6];
				tms[3]=0;
				event.currentTarget.stop();
			}
		}
		
		public function clearGame2(){
			wind2["lamp_cl"].gotoAndStop(1);
			wind2["ra"+0].visible=false;
			wind2["ra"+1].visible=false;
			wind2["ra"+2].visible=false;
			wind2["win_cl"].visible=false;
		}
		
		public static var win:Array=new Array(7);
		
		public function getGame2(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВезение: правила.");
				stg_class.wind["choise_cl"].erTestReq(6,2,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			//trace("getGame2 xml\n"+list);
			var s1:String="bonuses";
			var s12:String="bonus";
			for(var i:int=0;i<list.child(s1).child(s12).length();i++){
				wind2["tx"+(int(list.child(s1).child(s12)[i].attribute("num"))-1)].text=(list.child(s1).child(s12)[i].attribute("name")+" "+list.child(s1).child(s12)[i].attribute("getted")+" шт.");
			}
			wind2["lamp_cl"].gotoAndPlay(4);
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getGame1(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nТрудолюбие: страница.");
				stg_class.wind["choise_cl"].erTestReq(6,1,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			//trace("getGame1 xml\n"+list);
			var s1:String="detals";
			var s12:String="detal";
			var s2:String="popitky";
			var s3:String="week";
			var s31:String="day";
			//var s31:String="day";
			var ar1:Array=new Array();
			for(var i:int=0;i<list.child(s1).child(s12).length();i++){
				var ar12:Array=new Array();
				ar12.push(list.child(s1).child(s12)[i].attribute("id")+"");
				ar12.push(list.child(s1).child(s12)[i].attribute("img")+"");
				ar12.push(list.child(s1).child(s12)[i].attribute("need")+"");
				ar12.push(list.child(s1).child(s12)[i].attribute("type")+"");
				ar12.push(list.child(s1).child(s12)[i].attribute("name")+"");
				ar12.push(list.child(s1).child(s12)[i].attribute("descr")+"");
				ar1.push(ar12);
			}
			//trace(ar1);
			var ar2:Array=new Array();
			ar2.push(list.child(s2)[0].attribute("finish")+"");
			ar2.push(list.child(s2)[0].attribute("num")+"");
			ar2.push(list.child(s2)[0].attribute("num_of")+"");
			ar2.push(list.child(s2)[0].attribute("minut")+"");
			//trace(ar2);
			var ar3:Array=new Array();
			for(var i:int=0;i<list.child(s3).child(s31).length();i++){
				var ar32:Array=new Array();
				ar32.push(list.child(s3).child(s31)[i].attribute("getted")+"");
				ar3.push(ar32);
			}
			//trace(ar3);
			wind1["date_tx"].text=list.child(s3)[0].attribute("date")+"";
			newGame1(ar1,ar2,ar3);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function clearGame1(){
			for(var i:int=0;i<7;i++){
				wind1["ready"+i].gotoAndStop(1);
			}
			for(var i:int=0;i<9;i++){
				wind1["d_tx"+i].text="";
				wind1["d_tx"+i].textColor=0x666666;
				wind1["detail"+i].gotoAndStop(1);
			}
			for(var i:int=1;i<9;i++){
				wind1["img"+i].visible=false;
			}
			wind1["win_cl"].visible=false;
			wind1["wait_cl"].visible=false;
			//wind1["w_w_cl"].visible=false;
			//wind1["w_d_cl"].visible=false;
			wind1["time_tx"].text="";
			wind1["count_tx"].text="";
			wind1["date_tx"].text="";
		}
		
		public function newGame1(ar:Array,ar1:Array,ar2:Array){
			//trace(1);
			for(var i:int=0;i<ar2.length;i++){
				if(ar2[i][0]==0){
					wind1["ready"+i].gotoAndStop(3);
				}else if(ar2[i][0]==1){
					wind1["ready"+i].gotoAndStop(2);
				}else{
					wind1["ready"+i].gotoAndStop(1);
				}
			}
			//trace(2);
			for(var i:int=0;i<ar.length;i++){
				try{
					if(ar[i][2]==0){
						wind1["img"+ar[i][1]].visible=false;
						wind1["d_tx"+i].textColor=0x666666;
					}else{
						wind1["img"+ar[i][1]].visible=true;
						wind1["d_tx"+i].textColor=0xffffff;
					}
				}catch(er:Error){}
				wind1["d_tx"+i].text=ar[i][4];
				wind1["detail"+i].gotoAndStop(ar[i][2]+1);
			}
			//trace(3);
			if(ar1[0]!=1){
				if(ar1[3]!=0){
					wind1["time_tx"].text="Очередная попытка через "+ar1[3]+" минут!";
					wind1["try_cl"].visible=false;
				}else{
					wind1["time_tx"].text="Вы можете подать заявку!";
					wind1["try_cl"].visible=true;
				}
			}else{
				wind1["time_tx"].text="Все детали собраны!";
				wind1["try_cl"].visible=false;
			}
			//trace(4);
			/*if(ar1[1]==ar1[2]){
				wind1["time_tx"].text="На сегодня попытки закончились!";
				wind1["try_cl"].visible=false;
			}*/
			wind1["count_tx"].text="Заявки: "+ar1[1]+" из "+ar1[2];
			stopTimer1();
			Timer1=new Timer(40, 1500);
			Timer1.addEventListener(TimerEvent.TIMER_COMPLETE, reQuery);
			Timer1.start();
			stg_cl.warn_f(9,"");
		}
		
		public static var Timer1:Timer=new Timer(40, 1500);
		
		public function stopTimer1(){
			try{
				Timer1.removeEventListener(TimerEvent.TIMER_COMPLETE, reQuery);
			}catch(er:Error){}
			try{
				Timer1.removeEventListener(TimerEvent.TIMER, playRand);
			}catch(er:Error){}
			try{
				Timer1.reset();
			}catch(er:Error){}
		}
		
		public function reQuery(event:TimerEvent):void{
			root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","action_type","type"]],[["6"],["1","0","1"]]);
		}
		
		public function getDetail1(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nТрудолюбие: Заказ.");
				stg_class.wind["choise_cl"].erTestReq(6,1,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			//trace("getDetail1 xml\n"+list);
			var s1:String="detal";
			var s2:String="finish";
			win[0]=-1;
			try{
				if(list.child(s2).length()>0){
					win[0]=int(list.child(s2)[0].attribute("on_week"));
					win[5]=int(list.child(s2)[0].attribute("money_z"));
					win[6]=int(list.child(s2)[0].attribute("money_m"));
				}
			}catch(er:Error){}
			wind1["win_cl"]["name_tx"].text=list.child(s1)[0].attribute("name")+"";
			wind1["win_cl"]["dscr_tx"].text=list.child(s1)[0].attribute("descr")+"";
			wind1["win_cl"]["count_tx"].text=list.child(s1)[0].attribute("num")+" из "+list.child(s1)[0].attribute("num_finish");
			if(int(list.child(s1)[0].attribute("need"))==0){
				wind1["win_cl"]["need_tx"].text="Вам не нужна эта деталь!";
				wind1["win_cl"]["back_cl"].gotoAndStop(2);
				wind1["win_cl"]["needed"].visible=false;
			}else if(int(list.child(s1)[0].attribute("need"))==1){
				wind1["win_cl"]["need_tx"].text="Вам нужна эта деталь!";
				wind1["win_cl"]["back_cl"].gotoAndStop(1);
				wind1["win_cl"]["needed"].visible=true;
			}else if(int(list.child(s1)[0].attribute("need"))==2){
				wind1["win_cl"]["need_tx"].text="У вас уже есть эта деталь!";
				wind1["win_cl"]["back_cl"].gotoAndStop(3);
				wind1["win_cl"]["needed"].visible=false;
			}
			
			try{g1Timer.reset();}catch(er:Error){}
			g1Timer=new Timer(40, 201-g1_ready);
			g1Timer.addEventListener(TimerEvent.TIMER, waiting);
			g1Timer.addEventListener(TimerEvent.TIMER_COMPLETE, time_over);
			g1Timer.start();
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var g1Timer:Timer=new Timer(40, 200);
		public static var g1_ready:int=0;
		
		public function waiting(event:TimerEvent):void{
			////trace(event.currentTarget.currentCount);
			//if(event.currentTarget.currentCount>9){
				g1_ready++;
				if(g1_ready<201){
					wind1["wait_cl"]["fill"].width=g1_ready;
					wind1["wait_cl"]["time_tx"].text="Доставка: "+int((200-g1_ready)/25)+" секунд";
				}else{
					wind1["wait_cl"]["fill"].width=200;
					wind1["wait_cl"]["time_tx"].text="Доставка: задерживается";
				}
			//}
		}
		
		public function time_over(event:TimerEvent):void{
			if(win[0]>-1){
				stg_class.panel["skills_tx"].text=int(stg_class.panel["skills_tx"].text)+win[5];
				stg_class.panel["money_tx"].text=int(stg_class.panel["money_tx"].text)+win[6];
				if(win[0]==0){
					wind1["w_d_cl"].visible=true;
				}else{
					wind1["w_d_cl"].visible=true;
					wind1["w_w_cl"].visible=true;
				}
			}
			wind1["wait_cl"].visible=false;
			wind1["win_cl"].visible=true;
		}
		
		public function onError(event:IOErrorEvent):void{
			stg_cl.warn_f(4,"Внутренний наряд");
		}
		
	}
}