package{
	
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.*;
	import flash.net.*;
	
	public class Win_cl extends MovieClip{
		
		public var pr_str:String="Подсказка не работает.\nВременно))";
		
		public static var stat_cl:MovieClip;
		public static var st_draw:MovieClip=new MovieClip();
		
		public static var wins:Array=new Array();
		public static var rangs:Array=new Array();
		
		public static var names:Array=new Array();
		
		public static var frags:Array=new Array();
		public static var dmgs:Array=new Array();
		
		public static var battle_num:Number=0;
		public static var new_log:Boolean=false;
		
		public function setNum(_n:int){
			battle_num=_n;
			if(_n==0){
				new_log=false;
			}
		}
		
		public function newLog(){
			var clip:MovieClip=root["win_cl"].parent.parent as MovieClip;
			var xml_str="<query id=\"3\"><action id=\"7\" metka1=\""+battle_num+"\" /></query>";
			var xml:XML=new XML(xml_str);
			var rqs:URLRequest=new URLRequest(clip.getClass(clip).scr_url+"?query="+3+"&action="+7);
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			loader.addEventListener(Event.COMPLETE, getLog);
			var variables:URLVariables = new URLVariables();
			variables.query = xml;
			variables.send = "send";
			rqs.data = variables;
			//trace(xml);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
		}
		
		public function onError(event:IOErrorEvent):void{
			//trace("Game+php: "+event);
			(root["win_cl"].parent.parent as MovieClip).warn_f(4,"Лог битвы");
		}
		
		public function getLog(event:Event){
			var clip:MovieClip=root["win_cl"].parent.parent as MovieClip;
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				clip.warn_f(5,"Неверный формат полученных данных. \nЛог битвы.");
				clip.erTestReq(3,7,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					clip.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			clip.warn_f(9,"");
			root["win_cl"]["show_st"].resetStat();
			var ar25:Array=new Array();
			var _c:int=0;
			var _d:int=0;
			var _k:int=0;
			for(var i:int=0;i<list.child("battle_log").child("user").length();i++){
				_c=0;
				_d=0;
				_k=0;
				var ar33:Array=new Array();
				ar33.push(list.child("battle_log").child("user")[i].attribute("rang")+"");
				ar33.push(list.child("battle_log").child("user")[i].attribute("name")+"");
				ar33.push(int(list.child("battle_log").child("user")[i].attribute("kill_all")));
				ar33.push(int(list.child("battle_log").child("user")[i].attribute("damage_all")));
				if(int(list.child("battle_log").child("user")[i].attribute("win"))==1){
					ar33.push(1);
				}else{
					_c=ar25.length;
					ar33.push(2);
				}
				/*for(var j:int=0;j<ar25.length;j++){
					if(ar25[j][4]==ar33[4]){
						if(ar25[j][2]>ar33[2]){
							if(_k<j){
								_c=_k=j;
							}
						}else if(ar25[j][2]==ar33[2]){
							if(ar25[j][2]>=ar33[2]){
								if(_d<j){
									_c=_d=j;
								}
							}else{
								if(_d<j+1){
									_c=_d=j+1;
								}
							}
						}
					}
				}*/
				for(var j:int=0;j<ar25.length;j++){
					if(ar25[j][4]>=ar33[4]){
						_c=j;
						for(var n:int=0;n<ar25.length;n++){
							if(ar25[n][4]==ar33[4]){
								if(ar25[n][2]<=ar33[2]){
									_c=n;
									for(var k:int=0;k<ar25.length;k++){
										if(ar25[k][4]==ar33[4]){
											if(ar25[k][2]==ar33[2]){
												if(ar25[k][3]<=ar33[3]){
													_c=k;
													break;
												}else{
													_c=k+1;
												}
											}
										}
									}
									break;
								}else{
									_c=n+1;
								}
							}
						}
						break;
					}else{
						_c=j+1;
					}
				}
				ar25.splice(_c,0,ar33);
				//trace(ar33);
			}
			//ar25.sort();
			root["win_cl"]["show_st"].newStat(ar25);
			root["win_cl"]["show_st"].drawStat();
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function resetStat(){
			wins=new Array();
			rangs=new Array();
			names=new Array();
			frags=new Array();
			dmgs=new Array();
		}
		
		public function newStat(ar:Array){
			for(var i:int=0;i<ar.length;i++){
				rangs.push(ar[i][0]);
				names.push(ar[i][1]);
				frags.push(ar[i][2]);
				dmgs.push(ar[i][3]);
				wins.push(ar[i][4]);
			}
		}
		
		public function drawStat(){
			var x1:int=3.5;
			var x2:int=86.5;
			var x3:int=227.5;
			var x4:int=288.5;
			var w1:int=82;
			var w2:int=140;
			var w3:int=60;
			var w4:int=60;
			var Y:int=1;
			var h:int=16;
			st_draw.graphics.clear();
			st_draw.graphics.beginFill(0x006600,1);
			st_draw.graphics.drawRect(x1,Y,w1,h);
			st_draw.graphics.drawRect(x2,Y,w2,h);
			st_draw.graphics.drawRect(x3,Y,w3,h);
			st_draw.graphics.drawRect(x4,Y,w4,h);
			h=12;
			//trace(stat_cl["fon_cl"]+"   "+stat_cl["fon_cl"].graphics);
			/*trace(wins);
			trace(rangs);
			trace(names);
			trace(frags);
			trace(dmgs);*/
			for(var i:int=0;i<10;i++){
				if(i<wins.length){
					if(wins[i]==1){
						st_draw.graphics.beginFill(0xFF0000,1);
					}else{
						st_draw.graphics.beginFill(0x0066FF,1);
					}
					stat_cl["rang"+i].text=rangs[i];
					stat_cl["name"+i].text=names[i];
					stat_cl["frag"+i].text=frags[i]+"";
					stat_cl["dmg" +i].text=dmgs[i]+"";
				}else{
					st_draw.graphics.beginFill(0xFFFFFF,1);
				}
				Y=(i)*13+18;
				st_draw.graphics.drawRect(x1,Y,w1,h);
				st_draw.graphics.drawRect(x2,Y,w2,h);
				st_draw.graphics.drawRect(x3,Y,w3,h);
				st_draw.graphics.drawRect(x4,Y,w4,h);
			}
			if(!new_log){
				root["clip"].parent.addChild(stat_cl);
			}
			new_log=true;
		}
		
		public function Win_cl(){
			super();
			Security.allowDomain("*");
			stop();
			if(name=="show_st"){
				stat_cl=new comb_st();
				stat_cl.x=int(parent.width/2);
				stat_cl.y=int(parent.height/2);
				stat_cl["fon_cl"].addChild(st_draw);
			}
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
		}
		
		public function showInfo(i_text:String){
			root["info_tx"].selectable=false;
			root["info_tx"].multiline=true;
			root["info_tx"].autoSize=TextFieldAutoSize.LEFT;
			root["info_tx"].wordWrap=false;
			root["info_tx"].textColor=0xF0DB7D;
			root["info_tx"].text=i_text;
			//trace(parent.x+"   "+x);
			root["info_tx"].x=x+parent.x;
			root["info_tx"].y=y-root["info_tx"].height-height/2+parent.y;
			/*if(root["info_tx"].y<0){
				root["info_tx"].y=0;
				root["info_tx"].x=x+width+10;
			}*/
			var info_w:int=root["info_tx"].width;
			var info_h:int=root["info_tx"].height;
			var info_rw:int=10;
			var info_rh:int=10;
			root["clip"].graphics.lineStyle(1, 0x000000, 1, true);
			root["clip"].graphics.beginFill(0x990700,1);
			root["clip"].graphics.drawRoundRect(root["info_tx"].x-3, root["info_tx"].y, info_w+10, info_h+2, info_rw, info_rh);
			parent.parent.setChildIndex(root["info_tx"],parent.parent.numChildren-1);
			root["info_tx"].visible=true;
		}
		
		public function m_over(event:MouseEvent){
			Mouse.cursor=MouseCursor.BUTTON;
			if(name=="pr_info"){
				showInfo(pr_str);
			}
			gotoAndStop("over");
		}
		
		public function m_out(event:MouseEvent){
			Mouse.cursor=MouseCursor.AUTO;
			if(name.slice(3,7)=="info"){
				root["info_tx"].visible=false;
				root["clip"].graphics.clear();
			}
			gotoAndStop("out");
		}
		
		public function m_press(event:MouseEvent){
			gotoAndStop("press");
		}
		
		public function m_release(event:MouseEvent){
			gotoAndStop("over");
			if(name=="exit_cl"||name=="close_cl"){
				var clip:MovieClip=parent.parent.parent as MovieClip;
				//trace(clip);
				clip["game_over"]=false;
				clip["warn_er"]=false;
				clip.gameReset();
				clip.warn_f(13,"");
				parent.parent.parent.removeChild(parent.parent);
			}else if(name=="show_st"){
				if(new_log){
					root["clip"].parent.addChild(stat_cl);
				}else{
					newLog();
				}
			}else if(name=="back_cl"){
				root["clip"].parent.removeChild(stat_cl);
			}
		}
	}
	
}