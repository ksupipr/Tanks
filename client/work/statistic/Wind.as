package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.setTimeout;
	
	public class Wind extends MovieClip{
		
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
		public var i_id:String="0";
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
		
		public static var _search:Boolean=true;
		
		public function erTestReq(a:int,b:int,c:String){
			//trace(uid+"   "+a+"   "+b+"   "+c);
			var reslt_s:String=c;
			var strXML:String="<query id=\"111\" id_u=\""+stg_cl["v_id"]+"\" query=\"\" log_query="+"\""+a+"\""+" log_action="+"\""+b+"\" />";
			var rqs:URLRequest=new URLRequest(serv_url+"?query="+111+"&action="+0);
			rqs.method=URLRequestMethod.POST;
			//var list:XML=new XML(strXML);
			var variables:URLVariables = new URLVariables();
			variables.query = strXML;
			variables.result = reslt_s;
			variables.send = "send";
			rqs.data = variables;
			//trace(serv_url+"\n");
			//trace(rqs.data);
			var loader:URLLoader=new URLLoader(rqs);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
		}
		
		public function urlInit(url:String,clip:MovieClip){
			serv_url=url;
			stg_cl=clip;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public function wallM1(arr1:Array){
			root["ch1"].visible=false;
			root["ch2"].visible=false;
			root["ch3"].visible=false;
			wind1["svodka_cl"].visible=false;
			root["wind_cl"].graphics.lineStyle(2, 0x195F1E, 1);
			root["wind_cl"].graphics.moveTo(20-root["wind_cl"].width/2, 1-root["wind_cl"].height/2);
			root["wind_cl"].graphics.lineTo(root["wind_cl"].width/2-10,1-root["wind_cl"].height/2);
			St_clip.stg.scaleX=St_clip.stg.scaleY=arr1[0];
			wind1.x=arr1[1];
			wind1.y=arr1[2];
			root["wind_cl"].x=wind1.x-arr1[3]+root["wind_cl"].width/2;
			root["wind_cl"].y=wind1.y-arr1[3]+root["wind_cl"].height/2;
		}
		
		public function wallM(arr1:Array,arr2:Array){
			try{
				root["exit_cl"].visible=false;
				root["help_cl"].visible=false;
				root["logo_cl"].visible=false;
				root["wind_cl"].visible=false;
			}catch(er:Error){
				trace("er1");
			}
			try{
				root["ch1"].visible=false;
				root["ch2"].visible=false;
				root["ch3"].visible=false;
			}catch(er:Error){
				trace("er6");
			}
			try{
				wind1.visible=false;
			}catch(er:Error){
				trace("er2");
			}
			try{
				root["wind_cl"].parent.addChild(wind2);
			}catch(er:Error){
				trace("er3");
			}
			try{
			for(var i:int=0;i<16;i++){
				wind2["d"+i].visible=false;
			}
			}catch(er:Error){
				trace("er3");
			}
			try{
			wind2["line_cl"].visible=false;
			wind2["name_pl"].visible=false;
			wind2["scroll_cl"].visible=false;
			wind2["medal_cl"].visible=false;
			}catch(er:Error){
				trace("er5");
			}
			wind2.addChild(mdl);
			mdl["closer_cl"].visible=false;
			mdl.x=arr1[0]-mdl.parent.x;
			mdl.width=arr1[2];
			mdl.scaleY=mdl.scaleX;
			mdl.y=arr1[1]-mdl.parent.y/*+(arr1[3]-mdl.height)/2*/;
			root["back_fon"].x=arr2[0];
			root["back_fon"].width=arr2[2];
			root["back_fon"].height=arr2[3];
			root["back_fon"].y=arr2[1];
			St_clip.stg.visible=true;
		}
		
		public function Wind(){
			super();
			Security.allowDomain("*");
			stop();
			//trace(name);
			if(name=="ch1"){
				wind1=new win_cl1();
				wind2=new dostejenie();
				wind3=new reiting();
				wind1["skin_cl"].visible=false;
				wind3["call_win"].visible=false;
				mdl=new medals();
				mdl.x=13;
				mdl.y=27;
				wind1.x=wind2.x=wind3.x=17;
				wind1.y=wind2.y=wind3.y=76;
				clearStat();
				setWind(1);
				m_active=true;
				name_tx.textColor=0x0F3C06;
				name_tx.text="Статистика";
				gotoAndStop(1);
				for(var i:int=0;i<20;i++){
					try{
						Wind["txt"+i].name="txt"+i;
						Wind["txt"+i].addEventListener(MouseEvent.MOUSE_OVER, m_over);
						Wind["txt"+i].addEventListener(MouseEvent.MOUSE_OUT, m_out);
						Wind["txt"+i].addEventListener(MouseEvent.MOUSE_DOWN, m_press);
						Wind["txt"+i].addEventListener(MouseEvent.MOUSE_UP, m_release);
						//wind2["scroll_cl"]["sc"].addEventListener(MouseEvent.MOUSE_MOVE, m_move);
					}catch(er:Error){
						
					}
				}
				if(offline==0){
					wind3["offline_cl"]["press_cl"].visible=false;
				}else{
					wind3["offline_cl"]["press_cl"].visible=true;
				}
			}else if(name=="ch2"){
				name_tx.textColor=0xFFFFFF;
				name_tx.text="Достижения";
				gotoAndStop(2);
			}else if(name=="ch3"){
				name_tx.textColor=0xFFFFFF;
				name_tx.text="Рейтинг";
				gotoAndStop(2);
			}else if(name=="info_look"){
				i_text="Нажмите на кнопку снизу,\nчтобы увидеть статистику\nдругого игрока.";
			}else if(name=="info_stat"){
				i_text="Нажав на кнопку в этом столбце,\nвы можете пригласить игрока в группу\nи на дуэль.";
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
				wind3["search_tx"].restrict = "^\"";
			}
			mode_num=m_mode;
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			//trace(event.currentTarget.name+"   "+name);
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				if(event.currentTarget.name.slice(0,6)=="status"){
					if(event.currentTarget.currentFrame<2){
						return;
					}
				}
				if(event.currentTarget.name.slice(0,3)=="mdl"){
					showInfo1(i_text,root.mouseX+10,root.mouseY+10,0);
					Mouse.cursor=MouseCursor.BUTTON;
					return;
				}else{
					Mouse.cursor=MouseCursor.BUTTON;
				}
				if(event.currentTarget.name.slice(0,3)=="txt"){
					event.currentTarget.textColor=0x00ff00;
					return;
				}else if(event.currentTarget.name.slice(0,4)=="call"){
					if(event.currentTarget.currentFrameLabel=="empty"){
						return;
					}
				}
				if(name.slice(0,2)=="ch"){
					if(!m_active){
						Mouse.cursor=MouseCursor.BUTTON;
						name_tx.textColor=0xFFFF00;
						gotoAndStop("over");
					}
				}else if(name.slice(2,5)=="log"){
					if(i_text!=""){
						showInfo(i_text);
					}
				}else if(name.slice(4,7)=="log"){
					if(i_text!=""){
						showInfo(i_text);
					}
				}else if(name=="info_look"){
					if(i_text!=""){
						showInfo(i_text);
					}
				}else if(name=="info_stat"){
					if(i_text!=""){
						showInfo(i_text);
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
			if(currentFrameLabel=="empty"){
				return;
			}
			if(event.currentTarget.name.slice(0,3)=="mdl"){
				hideInfo();
				Mouse.cursor=MouseCursor.AUTO;
				return;
			}else{
				Mouse.cursor=MouseCursor.AUTO;
			}
			if(event.currentTarget.name.slice(0,6)=="status"){
				if(event.currentTarget.currentFrame<2){
					return;
				}
			}else if(event.currentTarget.name.slice(0,3)=="txt"){
				if(int(event.currentTarget.text)!=page){
					event.currentTarget.textColor=0x195F1E;
				}
				return;
			}else if(event.currentTarget.name.slice(0,4)=="call"){
				if(event.currentTarget.currentFrameLabel=="empty"){
					return;
				}
			}
			if(name.slice(0,2)=="ch"){
				if(!m_active){
					name_tx.textColor=0xFFFFFF;
					gotoAndStop("out");
				}
			}else{
				if(name.slice(2,5)=="log"){
					hideInfo();
				}else if(name.slice(4,7)=="log"){
					hideInfo();
				}else if(name=="info_look"){
					hideInfo();
				}else if(name=="info_stat"){
					hideInfo();
				}else{
					gotoAndStop("out");
				}
			}
		}
		
		public static var call_id:String="0";
		
		public function m_out1(event:MouseEvent){
			//trace(root.mouseX+"   "+root["player_cl"].x+"   "+root["player_cl"].width);
			//trace(root.mouseY+"   "+root["player_cl"].y+"   "+root["player_cl"].height);
			if(wind3.mouseX<=wind3["call_win"].x||wind3.mouseX>=wind3["call_win"].x+wind3["call_win"].width){
				wind3["call_win"].visible=false;
				wind3["call_win"].removeEventListener(MouseEvent.MOUSE_OUT, m_out1);
			}
			if(wind3.mouseY<=wind3["call_win"].y||wind3.mouseY>=wind3["call_win"].y+wind3["call_win"].height-5){
				wind3["call_win"].visible=false;
				wind3["call_win"].removeEventListener(MouseEvent.MOUSE_OUT, m_out1);
			}
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				if(event.currentTarget.name.slice(0,6)=="status"){
					if(event.currentTarget.currentFrame<2){
						return;
					}else{
						call_id=parent["look"+event.currentTarget.name.slice(6,8)]["i_id"];
						wind3["call_win"].x=wind3.mouseX-width+15;
						wind3["call_win"].y=wind3.mouseY-15;
						if(wind3["call_win"].y<0){
							wind3["call_win"].y=0;
						}else if(wind3["call_win"].y>wind3.width-wind3["call_win"].width){
							wind3["call_win"].y=wind3.width-wind3["call_win"].width;
						}
						wind3["call_win"]["name_tx"].text=parent["name"+event.currentTarget.name.slice(6,8)].text;
						for(var i:int=0;i<4;i++){
							if(us_h[int(event.currentTarget.name.slice(6,8))][i]==0){
								wind3["call_win"]["call"+i].gotoAndStop("out");
							}else{
								wind3["call_win"]["call"+i].gotoAndStop("empty");
							}
						}
						stg_cl.setChildIndex(stg_class.stat_cl,stg_cl.numChildren-1);
						wind3["call_win"].visible=true;
						wind3["call_win"].addEventListener(MouseEvent.MOUSE_OUT, m_out1);
					}
				}else if(event.currentTarget.name.slice(0,3)=="txt"){
					if(event.currentTarget.parent==wind3){
						sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5",event.currentTarget.text,offline+""]]);
					}else if(event.currentTarget.parent==mdl){
						sendRequest([["query"],["action"]],[["id"],["id","page","user_id"]],[["2"],["8",event.currentTarget.text,""+us_id]]);
					}
					return;
				}else if(event.currentTarget.name.slice(0,4)=="call"){
					if(event.currentTarget.currentFrameLabel=="empty"){
						return;
					}
				}
				if(name.slice(0,2)=="ch"){
					if(!m_active){
						setWind(int(name.slice(2,3)));
						de_active();
						name_tx.textColor=0x0F3C06;
						gotoAndStop("press");
						m_active=true;
						if(name=="ch1"){
							clear_id();
							root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["2"],["4"]]);
						}else if(name=="ch3"){
							sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5","0",offline+""]]);
						}else if(name=="ch2"){
							root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["2"],["6",""+us_id]]);
						}
					}
				}else{
					if(name=="to_game"){
						stg_cl.linkTo1(new URLRequest("http://vkontakte.ru/app1888415"));
					}else if(name=="exit_cl"){
						stg_cl.createMode(1);
					}else if(name=="left1"){
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
						if(_search){
							sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5","0",offline+""]]);
							_search=false;
							setTimeout(function(){_search=true;}, 180000);
						}
					}else if(name=="refind"){
						sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5",page+"",offline+""]]);
					}else if(name=="offline_cl"){
						if(!this["press_cl"].visible){
							this["press_cl"].visible=true;
							offline=1;
						}else{
							this["press_cl"].visible=false;
							offline=0;
						}
						sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5",page+"",offline+""]]);
					}else if(name=="sc"){
						stage.addEventListener(MouseEvent.MOUSE_MOVE, m_move);
						stage.addEventListener(MouseEvent.MOUSE_UP, m_Release);
					}else if(name=="rect"){
						m_scroll();
						stage.addEventListener(MouseEvent.MOUSE_MOVE, m_move);
						stage.addEventListener(MouseEvent.MOUSE_UP, m_Release);
					}else if(name=="up"){
						wind2["scroll_cl"]["sc"].y-=wind2["scroll_cl"]["sc"].height;
						sc_coor();
					}else if(name=="down"){
						wind2["scroll_cl"]["sc"].y+=wind2["scroll_cl"]["sc"].height;
						sc_coor();
					}else if(name.slice(0,3)=="mdl"){
						if(int(name.slice(3,4))<picts.length&&picts[int(name.slice(3,4))]!=null){
							//if(stg_cl["reff"]!="wall_post_inline"){
								stg_cl.upl_mess=dscr[int(name.slice(3,4))];
								//trace(stg_cl.upl_mess+"   "+int(name.slice(3,4)));
								//trace(dscr);
								stg_cl.upl_mess1=name_pl;
							//}
							stg_cl.upl[0]=ids[int(name.slice(3,4))];
							stg_cl.upl_name=nms[int(name.slice(3,4))];
							stg_class.prnt_cl["upl_pict"]=urls[int(name.slice(3,4))];
							//trace();
							stg_cl.holly[0]="no holly";
							stg_cl.showWall();
						}
						//trace("press_bdl");
						//stg_cl._sendRequest("wall.getPhotoUploadServer");
					}
					gotoAndStop("press");
				}
			}
		}
		
		public static var name_pl:String="";
		
		public function m_Release(event:MouseEvent){
			stage.removeEventListener(MouseEvent.MOUSE_UP, m_Release);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, m_move);
		}
		
		//public static var mY:int=0;
		//public static var scroll_sc:Boolean=false;
		
		public function m_move(event:MouseEvent){
				m_scroll();
		}
		
		public function m_scroll(){
				wind2["scroll_cl"]["sc"].y=wind2["scroll_cl"]["rect"].mouseY+wind2["scroll_cl"]["sc"].height/2;
				sc_coor();
		}
		
		public function sc_coor(){
			if(wind2["scroll_cl"]["sc"].y<wind2["scroll_cl"]["rect"].y+1){
				wind2["scroll_cl"]["sc"].y=wind2["scroll_cl"]["rect"].y+1;
				newDast(0,ar,ar1,ar2);
				return;
			}else if(wind2["scroll_cl"]["sc"].y>wind2["scroll_cl"]["rect"].y+(wind2["scroll_cl"]["rect"].height-wind2["scroll_cl"]["sc"].height)-2){
				wind2["scroll_cl"]["sc"].y=wind2["scroll_cl"]["rect"].y+(wind2["scroll_cl"]["rect"].height-wind2["scroll_cl"]["sc"].height)-2;
			}
			var n:int=int(((wind2["scroll_cl"]["sc"].y+8+wind2["scroll_cl"]["sc"].height/2)-wind2["scroll_cl"]["rect"].y)/(wind2["scroll_cl"]["sc"].height/2));
			if(int(n/2)*2==n){
				newDast(n,ar,ar1,ar2);
			}else if(n-1>=0){
				newDast(n-1,ar,ar1,ar2);
			}else{
				newDast(0,ar,ar1,ar2);
			}
		}
		
		public function setNamePl(s:String){
			name_pl=s;
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				if(event.currentTarget.name.slice(0,6)=="status"){
					if(event.currentTarget.currentFrame<2){
						return;
					}
				}else if(event.currentTarget.name.slice(0,3)=="txt"){
					//sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["5","0","0"]]);
				}else if(event.currentTarget.name.slice(0,4)=="call"){
					if(event.currentTarget.currentFrameLabel=="empty"){
						return;
					}else{
						event.currentTarget.parent.visible=false;
						if(event.currentTarget.name=="call1"){
							sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["7"],["1",call_id+""]]);
						}else if(event.currentTarget.name=="call2"){
							sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["7"],["3",call_id+""]]);
						}else if(event.currentTarget.name=="call3"){
							sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["9"],["3",call_id+""]]);
						}
					}
				}
				if(name.slice(0,2)=="ch"){
					
				}else{
					if(name.slice(0,4)=="link"){
						stg_cl.linkTo(new URLRequest(i_link));
						gotoAndStop("over");
					}else if(name.slice(0,4)=="look"){
						us_id=i_id;
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
						root["wind_cl"].parent.removeChild(wind3);
						gotoAndStop("over");
					}else if(name=="search_cl"){
						if(_search){
							clearReit();
							sendRequest([["query"],["action"]],[["id"],["id","page","offline","search"]],[["2"],["5","0",offline+"",parent["search_tx"].text]]);
							parent["search_tx"].text="";
							_search=false;
							setTimeout(function(){_search=true;}, 180000);
						}
						gotoAndStop("over");
					}else if(name=="sc"){
						//scroll_sc=false;
						//removeEventListener(MouseEvent.MOUSE_MOVE, m_move);
						//mY=0;
						gotoAndStop("over");
					}else if(name=="svodka_cl"){
						sendRequest([["query"],["action"]],[["id"],["id"]],[["2"],["9"]]);
					}else if(name=="medal_cl"){
						sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["2"],["8",""+us_id]]);
					}else if(name=="list_army"){
						sendRequest([["query"],["action"]],[["id"],["id"]],[["12"],["1"]]);
					}else if(name=="arm_er_ok"){
						wind1["army_win"]["army_not"].visible=false;
					}else if(name=="close_army"){
						wind1["army_win"].visible=false;
					}else if(name=="army_no"){
						wind1["army_win"]["ask_win"].visible=false;
					}else if(name.slice(0,8)=="new_army"){
						wind1["army_win"]["ask_win"]["army_yes"].ID=this['ID'];
						wind1["army_win"]["ask_win"].visible=true;
					}else if(name=="army_yes"){
						sendRequest([["query"],["action"]],[["id"],["id","world_id"]],[["12"],["2",""+this['ID']]]);
					}else if(name=="closer_cl"){
						try{
							wind2.removeChild(mdl);
						}catch(er:Error){
							//trace("er "+i);
						}
					}else{
						if(name=="close_cl"){
							parent.visible=false;
						}else if(name=="academ_b"){
							if(stg_cl["kurs"]==0){
								wind1["ac_win"].visible=true;
							}else{
								stg_class.akadem_cl["begin_cl"]["close_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["10"],["2"]]);
							}
						}else if(name=="raport"){
							stg_class.akadem_cl["begin_cl"]["close_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["10"],["1"]]);
						}
						gotoAndStop("over");
					}
				}
			}
		}
		
		public function lookSv(idgm:String){
			us_id=idgm;
			setWind(int(name.slice(2,3)));
			de_active();
			name_tx.textColor=0x0F3C06;
			gotoAndStop("press");
			m_active=true;
			clearStat();
			clearReit();
			sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["2"],["4",""+us_id]]);
		}
		
		public function eventsInit(){
			wind3["search_tx"].addEventListener(KeyboardEvent.KEY_DOWN, k_press);
		}
		
		public function k_press(event:KeyboardEvent){
			if(event.keyCode==Keyboard.ENTER){
				root["ch1"].clearReit();
				root["ch1"].sendRequest([["query"],["action"]],[["id"],["id","page","offline","search"]],[["2"],["5","0",offline+"",wind3["search_tx"].text]]);
				wind3["search_tx"].text="";
				stage.focus=null;
			}
		}
		
		public function clear_id(){
			us_id="0";
		}
		
		public function sendRequest(names:Array, attr:Array, idies:Array, _i:int=0){
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
					if(int(idies[1][0])==4){
						loader.addEventListener(Event.COMPLETE, statistic);
						//trace(idies[1]);
						if(int(idies[1][1])==0||idies[1].length<2){
							clear_id();
						}
					}else if(int(idies[1][0])==5){
						loader.addEventListener(Event.COMPLETE, getReiting);
					}else if(int(idies[1][0])==6){
						loader.addEventListener(Event.COMPLETE, getDost);
					}else if(int(idies[1][0])==9){
						loader.addEventListener(Event.COMPLETE, getSvod);
					}else if(int(idies[1][0])==8){
						loader.addEventListener(Event.COMPLETE, getMedals);
					}
				}else if(int(idies[0][0])==7){
					if(int(idies[1][0])==1||int(idies[1][0])==3){
						loader.addEventListener(Event.COMPLETE, call1);
					}
				}else if(int(idies[0][0])==9){
					if(int(idies[1][0])==3){
						loader.addEventListener(Event.COMPLETE, call1);
					}
				}else if(int(idies[0][0])==12){
					if(int(idies[1][0])==1){
						loader.addEventListener(Event.COMPLETE, getArmies);
					}else if(int(idies[1][0])==2){
						loader.addEventListener(Event.COMPLETE, goToArmy);
						if(_i==0)stg_cl["buy_send"]=[names, attr, idies, 3];
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
		
		public function getArmies(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nСписок армий.");
				erTestReq(12,1,str);
				return;
			}
			//trace("getArmies\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			army_reset();
			wind1["army_win"]["choise_win"]["name_tx"].text=stg_class.prnt_cl.army_n;
			for(var i:int=0;i<list.child("worlds").child("world").length();i++){
				wind1["army_win"]["choise_win"]["army_is"+i].visible=true;
				wind1["army_win"]["choise_win"]["new_army"+i].visible=true;
				wind1["army_win"]["choise_win"]["army_is"+i]["name_tx"].text=(list.child("worlds").child("world")[i].attribute("name"));
				wind1["army_win"]["choise_win"]["army_is"+i]["price_tx"].text=(list.child("worlds").child("world")[i].attribute("price"))+" "+stg_class.shop["exit"].m_name(int(list.child("worlds").child("world")[i].attribute("price")),3);
				if(int(list.child("worlds").child("world")[i].attribute("price"))==0){
					wind1["army_win"]["choise_win"]["army_is"+i]["price_tx"].text="Бесплатно";
				}
				wind1["army_win"]["choise_win"]["army_is"+i]["stat_tx"].text="Доступна";
				wind1["army_win"]["choise_win"]["new_army"+i].ID=(list.child("worlds").child("world")[i].attribute("num"));
			}
			wind1["army_win"]["choise_win"].visible=true;
			wind1["army_win"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{stg_class.shop["exit"].buy_mem("re_try");}catch(er:Error){}
			try{stg_class.shop["exit"].buy_mem("end");}catch(er:Error){}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function goToArmy(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПереход в армию.");
				erTestReq(12,2,str);
				return;
			}
			//trace("goToArmy\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))==2){
					stg_cl.warn_f(9,"");
					if(int(list.child("err")[0].attribute("sn_val_need"))!=0){
						var _ar:Array=new Array();
						_ar[0]=function(){
							stg_cl.createMode(2);
						};
						_ar[1]=[function(){
							stg_class.stat_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id"]],[["2"],["4"]]);
						},"buy"];
						_ar[2]=[function(){
							stg_class.stat_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id"]],[["12"],["1"]]);
						},"statistic"];
						_ar[3]=[function(){
							stg_class.shop["exit"].clear_buy_ar();
						},"end"];
						_ar[4]=[function(){
							stg_class.stat_cl["ch1"].sendRequest(stg_cl["buy_send"][0],stg_cl["buy_send"][1],stg_cl["buy_send"][2]);
						},"re_try"];
						stg_class.shop["exit"].needMoney(_ar,int(list.child("err")[0].attribute("sn_val_need")));
					}
					return;
				}else if(int(list.child("err")[0].attribute("code"))!=0){
					army_reset();
					wind1["army_win"]["choise_win"].visible=true;
					wind1["army_win"].visible=true;
					wind1["army_win"]["army_not"].visible=true;
					wind1["army_win"]["army_not"]["er_text"].text=list.child("err")[0].attribute("comm");
					stg_cl.warn_f(9,"");
					return;
				}else{
					wind1["army_win"]["choise_win"].visible=true;
					wind1["army_win"].visible=true;
					wind1["army_win"]["army_ok"].visible=true;
					wind1["army_win"]["army_ok"]["mess_tx"].text=list.child("err")[0].attribute("comm");
				}
			}catch(er:Error){
				
			}
			
			
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function call1(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nРейтинг: вызов на дуэль.");
				erTestReq(7,1,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl.warn_f(9,"");
			//trace("call0   "+list);
			var ar:Array=new Array();
			ar.push(int(list.child("window")[0].attribute("type")));
			ar.push(int(list.child("window")[0].attribute("sender")));
			ar.push(list.child("window")[0].attribute("from"));
			ar.push(int(list.child("window")[0].attribute("time")));
			ar.push(int(list.child("window")[0].attribute("time_max")));
			ar.push(int(list.child("window")[0].attribute("state")));
			//ar.push(int(list.child("window")[0].attribute("type")));
			//stg_cl.createMode(1);
			stg_class.wind["choise_cl"].call_f(ar);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function clearStat(){
			for(var i:int=0;i<19;i++){
				wind1["txt"+i].text="";
			}
			for(var i:int=0;i<cls.length;i++){
				try{
					wind1.removeChild(cls[i]);
				}catch(er:Error){}
			}
			for(var i:int=0;i<sk_ava.length;i++){
				try{
					wind1["skin_cl"].removeChild(sk_ava[i]);
				}catch(er:Error){}
			}
			wind1["st_name"].text="";
			wind1["top_tx"].text="";
			cls=new Array();
			sk_ava=new Array();
		}
		
		public function newStat(ar:Array,ar1:Array){
			for(var i:int=0;i<ar.length;i++){
				wind1["txt"+i].text=ar[i];
			}
			wind2["name_pl"].text=wind1["st_name"].text=ar1[0];
			wind1["top_tx"].text=ar1[1];
			wind1["polk_tx"].text=ar1[2];
			wind1["polk_rang"].text=ar1[3];
			wind1["kntr_tx"].text=ar1[4];
		}
		
		public function newDast(b:int,a:Array,a1:Array,a2:Array){
			for(var i:int=b;i<16+b;i++){
				if(a2[i]!=-1){
					wind2["d"+(i-b)]["name_tx"].text="\""+a[i]+"\"";
					wind2["d"+(i-b)]["txt"].text=a1[i];
					if(a2[i]==0){
						wind2["d"+(i-b)]["txt"].textColor=wind2["d"+(i-b)]["name_tx"].textColor=0x333333;
					}else{
						wind2["d"+(i-b)]["txt"].textColor=wind2["d"+(i-b)]["name_tx"].textColor=0xFF0000;
					}
					wind2["d"+(i-b)].gotoAndStop(a2[i]+1);
					wind2["d"+(i-b)].visible=true;
				}else{
					wind2["d"+(i-b)].visible=false;
				}
			}
			//trace(ar.length+"   "+wind2["scroll_cl"]["rect"].height);
			//trace(wind2["scroll_cl"]["rect"].height/(ar.length-16));
		}
		
		public static var ar:Array=new Array();
		public static var ar1:Array=new Array();
		public static var ar2:Array=new Array();
		
		public function getDost(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nДостижения: список.");
				erTestReq(2,6,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			try{
				wind2.removeChild(mdl);
			}catch(er:Error){
				//trace("er "+i);
			}
			//trace(list);
			ar=new Array();
			ar1=new Array();
			ar2=new Array();
			for(var i:int=0;i<list.child("achievements").child("achiv").length();i++){
				ar.push(list.child("achievements").child("achiv")[i].attribute("name")+"");
				ar1.push(list.child("achievements").child("achiv")[i].attribute("descr")+"");
				ar2.push(list.child("achievements").child("achiv")[i].attribute("getted"));
			}
			//trace(ar.length);
			//trace(ar1);
			//trace(ar2);
			if(int(ar.length/2)*2!=ar.length){
				ar.push("empty");
				ar1.push("empty");
				ar2.push(-1);
				ar.push("empty");
				ar1.push("empty");
				ar2.push(-1);
			}else{
				ar.push("empty");
				ar1.push("empty");
				ar2.push(-1);
			}
			//trace(ar.length);
			wind2["scroll_cl"]["sc"].y=wind2["scroll_cl"]["rect"].y;
			wind2["scroll_cl"]["sc"].height=(wind2["scroll_cl"]["rect"].height/(ar.length-16))*2;
			newDast(0,ar,ar1,ar2);
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var w_now:Array=new Array;
		public static var w_new:Array=new Array;
		public static var sk_ava:Array=new Array;
		
		public function skins(sk_ar:Array):void{
			wind1["skin_cl"]["name_tx"].text=sk_ar[0];
			wind1["skin_cl"]["tx1"].text=sk_ar[1];
			wind1["skin_cl"]["tx2"].text=sk_ar[2];
		}
		
		public function army_reset():void{
			wind1["army_win"].visible=false;
			wind1["army_win"]["army_ok"].visible=false;
			wind1["army_win"]["ask_win"].visible=false;
			wind1["army_win"]["army_not"].visible=false;
			for(var i:int=0;i<6;i++){
				wind1["army_win"]["choise_win"]["army_is"+i].visible=false;
				wind1["army_win"]["choise_win"]["new_army"+i].visible=false;
			}
			//wind1["army_win"]["choise_win"].visible=false;
		}
		
		public function statistic(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nСтатистика: страница.");
				erTestReq(2,4,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			//trace(list);
			var s1:String="stat";
			var s2:String="user";
			//trace(serv_url);
			//trace(root["ch1"]);
			//trace(list.child(s2)[0].attribute("ava"));
			clearStat();
			army_reset();
			var ar:Array=new Array();
			var ar1:Array=new Array();
			for(var i:int=0;i<list.child(s1).length();i++){
				ar.push(list.child(s1)[i].attribute("out")+"");
			}
			ar1.push(list.child(s2)[0].attribute("name")+"");
			wind1["ac_win"]["znak_tx"].text=list.child(s2)[0].attribute("money_za");
			//trace(wind1["ac_win"]["znak_tx"].text+"   "+list.child(s2)[0].attribute("money_za"));
			if(int(wind1["ac_win"]["znak_tx"].text)<100){
				wind1["ac_win"]["raport"].gotoAndStop("empty");
			}else{
				wind1["ac_win"]["raport"].gotoAndStop("out");
			}
			//list.child(s2)[0].attribute("class_name");
			ar1.push("Рейтинг: "+list.child(s2)[0].attribute("top")+"");
			ar1.push(list.child(s2)[0].attribute("polk")+"");
			ar1.push(list.child(s2)[0].attribute("polk_rang")+"");
			ar1.push(list.child(s2)[0].attribute("contract")+"");
			/*var sk1:Array=new Array();
			sk1.push(list.child("by_now")[0].child("skin")[0].attribute("name"));
			sk1.push(list.child("by_now")[0].child("skin")[0].attribute("descr"));
			sk1.push(list.child("by_now")[0].child("skin")[0].attribute("descr2"));
			skins(sk1);*/
			//trace(serv_url.slice(0,serv_url.length-13));
			for(var i=0;i<2;i++){
				try{
					try{
						root["ch1"].LoadSk(stg_class.res_url+"/"+list.child("by_now")[0].child("mod")[i].attribute("img"),i);
					}catch(er:Error){
						LoadSk(stg_class.res_url+"/"+list.child("by_now")[0].child("mod")[i].attribute("img"),i);
					}
				}catch(er:Error){
					
				}
			}
			try{
				LoadSk(stg_class.res_url+"/"+list.child("by_now")[0].child("skin")[0].attribute("img"),3);
			}catch(er:Error){
				
			}
			wind1["ac_win"].visible=false;
			newStat(ar,ar1);
			if(stg_cl["reff"]=="wall_view_inline"){
				wallM1(stg_cl["arr3"]);
				St_clip.stg.visible=true;
			}else{
				stg_cl.createMode(4);
			}
			var str_link:String="";
			try{
				str_link=list.child(s2)[0].attribute("class_img");
			}catch(er:Error){}
			if(str_link.length>1){
				try{
					root["ch1"].LoadCl(stg_class.res_url+"/"+str_link);
				}catch(er:Error){
					LoadCl(stg_class.res_url+"/"+str_link);
				}
			}
			if(String(list.child(s2)[0].attribute("ava"))!=""){
				try{
					root["ch1"].LoadAva(stg_class.res_url+"/"+list.child(s2)[0].attribute("ava"));
				}catch(er:Error){
					LoadAva(stg_class.res_url+"/"+list.child(s2)[0].attribute("ava"));
				}
			}else{
				try{
					//if(avas.length>1){
						wind1["ava_cl"].removeChild(avas[0]);
						avas.shift();
					//}
				}catch(er:Error){
					//trace("er15 ");
				}
			}
			try{
				wind1.removeChild(wind1.getChildByName("tx_ava"));
			}catch(er:Error){
				
			}
			if(String(list.child(s2)[0].attribute("kurs_img"))!=""){
				var txt_ava:TextField=new TextField();
				txt_ava.htmlText=" <img id='pict' align='left' hspace='0' vspace='0' src='"+(stg_class.res_url+"/"+list.child(s2)[0].attribute("kurs_img"))+"' />";
				txt_ava.name="tx_ava";
				txt_ava.x=75-txt_ava.textWidth;
				txt_ava.y=125-txt_ava.textHeight;
				txt_ava.width=txt_ava.textWidth+46;
				txt_ava.height=txt_ava.textHeight+85;
				txt_ava.selectable=false;
				wind1.addChild(txt_ava);
			}
			stg_cl.warn_f(9,"");
			try{stg_class.shop["exit"].buy_mem("statistic");}catch(er:Error){}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var avas:Array=new Array();
		public static var cls:Array=new Array();
		
		public function LoadCl(ur:String){
			//trace(ur);
			var loader:Loader = new Loader();
			/*var mc:MovieClip=new pre();
			mc.x=11;
			mc.y=26;
			mc.gotoAndPlay(int(Math.random()*15)+1);
			mc.name="pre_cl";
			wind1["ava_cl"].addChild(mc);*/
			wind1.addChild(loader);
			cls.push(loader);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openImage );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressImage);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeCl);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadCl);
			
			loader.load(new URLRequest(ur));
		}
		
		public function LoadSk(ur:String,_c:int){
			//trace(ur);
			var loader:Loader = new Loader();
			/*var mc:MovieClip=new pre();
			mc.x=11;
			mc.y=26;
			mc.gotoAndPlay(int(Math.random()*15)+1);
			mc.name="pre_cl";
			wind1["ava_cl"].addChild(mc);*/
			if(_c==0){
				loader.x=15;
				loader.y=77;
			}else if(_c==1){
				loader.x=67;
				loader.y=77;
			}else if(_c==3){
				loader.x=15;
				loader.y=13;
			}
			//loader.x+=wind1["skin_cl"].x-wind1["skin_cl"].width/2;
			//loader.y+=wind1["skin_cl"].y-wind1["skin_cl"].height/2;
			wind1["skin_cl"].addChild(loader);
			sk_ava.push(loader);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openImage );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressImage);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeSk);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadCl);
			
			loader.load(new URLRequest(ur));
		}
		
		public function unLoadCl(event:IOErrorEvent){
			/*try{
				//if(avas.length>1){
					wind1["ava_cl"].removeChild(avas[0]);
					avas.shift();
				//}
			}catch(er:Error){
				//trace("er15 ");
			}*/
		}
		
		public function completeSk(event:Event){
			//event.currentTarget.content.x=event.currentTarget.loader.x;
			//event.currentTarget.content.y=event.currentTarget.loader.y;
			//event.currentTarget.loader.x=0;
			//event.currentTarget.loader.y=0;
			/*try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}*/
			//wind1["ava_cl"].addChild(avas[0]);
		}
		
		public function completeCl(event:Event){
			event.currentTarget.content.x=5;
			event.currentTarget.content.y=125;
			/*try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}*/
			//wind1["ava_cl"].addChild(avas[0]);
		}
		
		public function LoadAva(ur:String){
			//trace(ur);
			var loader:Loader = new Loader();
			try{
				//if(avas.length>1){
					wind1["ava_cl"].removeChild(avas[0]);
					avas.shift();
				//}
			}catch(er:Error){
				//trace("er15 ");
			}
			var mc:MovieClip=new pre();
			mc.x=11;
			mc.y=26;
			mc.gotoAndPlay(int(Math.random()*15)+1);
			mc.name="pre_cl";
			wind1["ava_cl"].addChild(mc);
			avas.push(loader);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openImage );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressImage);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeAva);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadAva);
			
			loader.load(new URLRequest(ur));
		}
		
		public function unLoadAva(event:IOErrorEvent){
			try{
				//if(avas.length>1){
					wind1["ava_cl"].removeChild(avas[0]);
					avas.shift();
				//}
			}catch(er:Error){
				//trace("er15 ");
			}
		}
		
		public function completeAva(event:Event){
			//event.currentTarget.content.x=1;
			//event.currentTarget.content.y=1;
			try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}
			wind1["ava_cl"].addChild(avas[0]);
		}
		
		public function clearReit(){
			for(var i:int=0;i<24;i++){
				try{
					wind3["rang"+i].text="";
					wind3["name"+i].text="";
					wind3["cmd"+i].text="";
					wind3["reit_tx"+i].text="";
					wind3["rang"+i].textColor=0x195F1E;
					wind3["name"+i].textColor=0x195F1E;
					wind3["cmd"+i].textColor=0x195F1E;
					wind3["reit_tx"+i].textColor=0x195F1E;
					wind3["n_log"+i].visible=false;
					wind3["cmd_log"+i].visible=false;
					wind3["n_log"+i]["i_text"]="";
					wind3["cmd_log"+i]["i_text"]="";
					wind3["look"+i].visible=false;
					wind3["link"+i].visible=false;
					wind3["link"+i]["i_link"]="";
					wind3["status"+i].visible=false;
					wind3["call_win"].visible=false;
				}catch(er:Error){
					trace("er "+i);
				}
			}
			for(var i:int=0;i<20;i++){
				try{
					Wind["txt"+i].text="";
					wind3.removeChild(Wind["txt"+i]);
				}catch(er:Error){
					continue;
				}
			}
			us_h=new Array();
		}
		
		public static var us_id:String="0";
		public static var us_h:Array=new Array();
		
		public function getReiting(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nРейтинг: страница.");
				erTestReq(2,5,str);
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
			var s1:String="user";
			var _ar:Array=new Array();
			var _ar1:Array=new Array();
			var _ar4:Array=new Array();
			var _ar5:Array=new Array();
			var _ar6:Array=new Array();
			var _ar7:Array=new Array();
			var _ar8:Array=new Array();
			var _ar9:Array=new Array();
			clearReit();
			clearMedals();
			for(var i:int=0;i<list.child("top").child(s1).length();i++){
				var _ar2:Array=new Array();
				_ar2.push(list.child("top").child(s1)[i].attribute("rang"));
				_ar2.push(list.child("top").child(s1)[i].attribute("name"));
				_ar2.push(list.child("top").child(s1)[i].attribute("command"));
				_ar2.push(list.child("top").child(s1)[i].attribute("top"));
				_ar2.push(list.child("top").child(s1)[i].attribute("slogan"));
				_ar2.push(list.child("top").child(s1)[i].attribute("command_slogan"));
				_ar2.push(list.child("top").child(s1)[i].attribute("profile_sn"));
				_ar2.push(list.child("top").child(s1)[i].attribute("profile_game"));
				_ar2.push(list.child("top").child(s1)[i].attribute("status"));
				_ar2.push(list.child("top").child(s1)[i].attribute("me"));
				_ar2.push(list.child("top").child(s1)[i].attribute("h0"));
				_ar2.push(list.child("top").child(s1)[i].attribute("h1"));
				_ar2.push(list.child("top").child(s1)[i].attribute("h2"));
				_ar2.push(list.child("top").child(s1)[i].attribute("h3"));
				/*if(int(_ar2[8])==0){
					_ar.push(_ar2);
				}else if(int(_ar2[8])==1){
					_ar1.push(_ar2);
				}else if(int(_ar2[8])==2){
					_ar4.push(_ar2);
				}else if(int(_ar2[8])==3){
					_ar5.push(_ar2);
				}else if(int(_ar2[8])==4){
					_ar6.push(_ar2);
				}else if(int(_ar2[8])==5){
					_ar7.push(_ar2);
				}else if(int(_ar2[8])==6){
					_ar8.push(_ar2);
				}else if(int(_ar2[8])==7){
					_ar9.push(_ar2);
				}*/
				_ar1.push(_ar2);
			}
			var _ar3:Array=new Array(_ar1,_ar4,_ar5,_ar6,_ar7,_ar8,_ar9,_ar);
			var _c:int=0;
			var _c1:int=0;
			for(var i:int=0;i<list.child("top").child(s1).length();i++){
				try{
					//trace(_c+"   "+_c1+"   "+i);
					//trace(_ar3[_c].length);
					if(_c<_ar3.length){
						if(_c==0){
							_c1=i;
						}else{
							_c1=i;
							for(var j:int=_c-1;j>-1;j--){
								_c1-=_ar3[j].length;
							}
						}
						if(_c1>=_ar3[_c].length){
							_c++;
							try{
								while(_ar3[_c].length==0){
									_c++;
								}
							}catch(er:Error){}
							if(_c>=_ar3.length){
								break;
							}
						}
						if(_c==0){
							_c1=i;
						}else{
							_c1=i;
							for(var j:int=_c-1;j>-1;j--){
								_c1-=_ar3[j].length;
							}
						}
					}else{
						if(i>=_ar3[_c].length){
							break;
						}
					}
					wind3["rang"+i].text=_ar3[_c][_c1][0]+"";
					wind3["name"+i].text=_ar3[_c][_c1][1]+"";
					wind3["cmd"+i].text=_ar3[_c][_c1][2]+"";
					wind3["reit_tx"+i].text=_ar3[_c][_c1][3]+"";
					wind3["n_log"+i]["i_text"]=_ar3[_c][_c1][4]+"";
					wind3["cmd_log"+i]["i_text"]=_ar3[_c][_c1][5]+"";
					if(wind3["n_log"+i]["i_text"]!=""){
						wind3["n_log"+i].visible=true;
					}
					if(wind3["cmd_log"+i]["i_text"]!=""){
						wind3["cmd_log"+i].visible=true;
					}
					wind3["look"+i].visible=true;
					wind3["link"+i].visible=true;
					wind3["link"+i]["i_link"]=_ar3[_c][_c1][6]+"";
					wind3["look"+i]["i_id"]=_ar3[_c][_c1][7];
					//if(int(list.child("top").child(s1)[_c1].attribute("status"))==0){
						wind3["status"+i].visible=true;
					//}
					if(int(_ar3[_c][_c1][8])==0){
						wind3["status"+i].gotoAndStop(1);
						wind3["rang"+i].textColor=0x195F1E;
						wind3["name"+i].textColor=0x195F1E;
						wind3["cmd"+i].textColor=0x195F1E;
						wind3["reit_tx"+i].textColor=0x195F1E;
					}else{
						if(int(_ar3[_c][_c1][8])==3){
							wind3["rang"+i].textColor=0x990700;
							wind3["name"+i].textColor=0x990700;
							wind3["cmd"+i].textColor=0x990700;
							wind3["reit_tx"+i].textColor=0x990700;
						}else if(int(_ar3[_c][_c1][8])==4){
							wind3["rang"+i].textColor=0x999999;
							wind3["name"+i].textColor=0x999999;
							wind3["cmd"+i].textColor=0x999999;
							wind3["reit_tx"+i].textColor=0x999999;
						}else if(int(_ar3[_c][_c1][8])==5){
							wind3["rang"+i].textColor=0x00CC00;
							wind3["name"+i].textColor=0x00CC00;
							wind3["cmd"+i].textColor=0x00CC00;
							wind3["reit_tx"+i].textColor=0x00CC00;
						}else if(int(_ar3[_c][_c1][8])==6){
							wind3["rang"+i].textColor=0x000099;
							wind3["name"+i].textColor=0x000099;
							wind3["cmd"+i].textColor=0x000099;
							wind3["reit_tx"+i].textColor=0x000099;
						}else{
							wind3["rang"+i].textColor=0x195F1E;
							wind3["name"+i].textColor=0x195F1E;
							wind3["cmd"+i].textColor=0x195F1E;
							wind3["reit_tx"+i].textColor=0x195F1E;
						}
						wind3["status"+i].gotoAndStop(2);
					}
					if(int(_ar3[_c][_c1][9])==1){
						wind3["rang"+i].textColor=0xff0000;
						wind3["name"+i].textColor=0xff0000;
						wind3["cmd"+i].textColor=0xff0000;
						wind3["reit_tx"+i].textColor=0xff0000;
					}
					var h:Array=new Array();
					h.push(int(_ar3[_c][_c1][10]));
					h.push(int(_ar3[_c][_c1][11]));
					h.push(int(_ar3[_c][_c1][12]));
					h.push(int(_ar3[_c][_c1][13]));
					us_h.push(h);
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
			pages=int(list.child("pages")[0].attribute("page_end"));
			page=int(list.child("pages")[0].attribute("page_now"));
			var cicle:int=10;
			if(page<5){
				cicle+=(5-page)*2;
			}
			//trace(pages+"   "+page+"   "+cicle);
			for(var i:int=0;i<cicle;i++){
				//trace(page+"   "+pages+"   "+vect);
				if((page-vect)>0&&(page-vect)<=pages){
					if(vect==5){
						break;
					}
					count=5-vect;
					Wind["txt"+count].embedFonts=false;
					//Wind["txt"+count].restrict="0-9";
					Wind["txt"+count].selectable=false;
					Wind["txt"+count].multiline=false;
					Wind["txt"+count].autoSize=TextFieldAutoSize.LEFT;
					Wind["txt"+count].wordWrap=false;
					Wind["txt"+count].antiAliasType=AntiAliasType.ADVANCED;
					Wind["txt"+count].defaultTextFormat=tf;
					if(vect==0){
						Wind["txt"+count].textColor=0x00ff00;
					}else{
						Wind["txt"+count].textColor=0x195F1E;
					}
					Wind["txt"+count].text=(page-vect)+"";
					Wind["txt"+count].width=Wind["txt"+count].textWidth;
					Wind["txt"+count].height=Wind["txt"+count].textHeight;
					Wind["txt"+count].y=330;
					w+=Wind["txt"+count].width+10;
					//trace(Wind["txt"+count].text+"   "+count+"   "+vect+"   "+Wind["txt"+count].width+"   "+w+"   "+Wind["txt"+count].textWidth+"   "+Wind["txt"+count].textHeight);
					if(w>175){
						//trace("count1   "+count);
						Wind["txt"+count].text="";
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
				if(Wind["txt"+i].text!=""){
					if(count>0){
						//trace(Wind["txt"+(i-1)].width+" a  "+Wind["txt"+(i-1)].height);
						Wind["txt"+i].x=Wind["txt"+(i-1)].x+Wind["txt"+(i-1)].width+10;
					}else{
						//trace(Wind["txt"+(i)].width+" b  "+Wind["txt"+(i)].height);
						Wind["txt"+i].x=320;
					}
					//trace(i+"   "+Wind["txt"+i].text+"   "+Wind["txt"+i].x);
					wind3.addChild(Wind["txt"+i]);
					count++;
				}
			}
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getSvod(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nСводка: страница.");
				erTestReq(2,9,str);
				return;
			}
				try{
					if(int(list.child("err")[0].attribute("code"))!=0){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
						return;
					}
				}catch(er:Error){
					
				}
				//trace("Svodka   "+list);
				var s1:String="svodka";
				var s2:String="line";
				var sv1:Array=new Array();
				var sv2:Array=new Array();
				//clearReit();
				try{
					for(var i:int=0;i<list.child(s1).length();i++){
						var sv:Array=new Array();
						sv1.push(list.child(s1)[i].attribute("name"));
						for(var j:int=0;j<list.child(s1)[i].child(s2).length();j++){
							var sv3:Array=new Array();
							sv3.push(list.child(s1)[i].child(s2)[j].attribute("name"));
							sv3.push(list.child(s1)[i].child(s2)[j].attribute("user"));
							sv3.push(list.child(s1)[i].child(s2)[j].attribute("value"));
							sv3.push(list.child(s1)[i].child(s2)[j].attribute("prifile_game"));
							sv3.push(list.child(s1)[i].child(s2)[j].attribute("profile_sn"));
							sv3.push(list.child(s1)[i].child(s2)[j].attribute("slogan"));
							sv.push(sv3);
						}
						sv2.push(sv);
					}
				}catch(er:Error){
					stg_cl.errTest("Svodka-Error2   "+er+"   "+er.message,int(600/2));
				}
				try{
					stg_cl.newSvodka(sv1,sv2);
				}catch(er:Error){
					//stg_cl.errTest("Svodka-Error3   "+er+"   "+er.message,int(600/2));
				}
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var picts:Array=new Array();
		public static var urls:Array=new Array();
		public static var nms:Array=new Array();
		public static var dscr:Array=new Array();
		public static var ids:Array=new Array();
		
		public function clearMedals(){
			try{
				wind2.removeChild(mdl);
			}catch(er:Error){
				//trace("er "+i);
			}
			for(var i:int=0;i<10;i++){
				try{
					mdl["mdl"+i]["i_text"]="";
					mdl["mdl"+i].removeChild(picts[i]);
				}catch(er:Error){
					//trace("er "+i);
				}
			}
			for(var i:int=0;i<20;i++){
				try{
					Wind["txt"+i].text="";
					mdl.removeChild(Wind["txt"+i]);
				}catch(er:Error){
					continue;
				}
			}
			picts=new Array();
			urls=new Array();
			nms=new Array();
			dscr=new Array();
			ids=new Array();
		}
		
		public function getMedals(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nНаграды: список.");
				erTestReq(2,8,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			//trace("Medals   "+list);
			clearReit();
			clearMedals();
			var count:int=0;
			var count1:int=0;
			var count2:int=0;
			var w:int=0;
			var vect:int=0;
			pages=int(list.child("pages")[0].attribute("page_end"));
			page=int(list.child("pages")[0].attribute("page_now"));
			//pages=542;
			//page=357;
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
					Wind["txt"+count].embedFonts=true;
					Wind["txt"+count].selectable=false;
					Wind["txt"+count].multiline=false;
					Wind["txt"+count].autoSize=TextFieldAutoSize.LEFT;
					Wind["txt"+count].wordWrap=false;
					Wind["txt"+count].antiAliasType=AntiAliasType.ADVANCED;
					Wind["txt"+count].defaultTextFormat=tf;
					if(vect==0){
						Wind["txt"+count].textColor=0x00ff00;
					}else{
						Wind["txt"+count].textColor=0x195F1E;
					}
					Wind["txt"+count].text=(page-vect)+"";
					Wind["txt"+count].y=270;
					w+=Wind["txt"+count].width+10;
					//trace(Wind["txt"+count].text+"   "+count+"   "+vect+"   "+Wind["txt"+count].width+"   "+w);
					if(w>295){
						//trace("count1   "+count);
						Wind["txt"+count].text="";
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
				if(Wind["txt"+i].text!=""){
					if(count>0){
						//trace(Wind["txt"+(i-1)].width+"   "+Wind["txt"+(i-1)].height);
						Wind["txt"+i].x=Wind["txt"+(i-1)].x+Wind["txt"+(i-1)].width+10;
					}else{
						//trace(Wind["txt"+(i)].width+"   "+Wind["txt"+(i)].height);
						Wind["txt"+i].x=60;
					}
					//trace(i+"   "+Wind["txt"+i].text+"   "+Wind["txt"+i].x);
					mdl.addChild(Wind["txt"+i]);
					count++;
				}
			}
			if(stg_cl["reff"]!="wall_post_inline"){
				wind2.addChild(mdl);
			}else{
				wallM(stg_cl["arr1"],stg_cl["arr2"]);
			}
			for(var i:int=0;i<list.child("medals")[0].child("medal").length();i++){
				ids.push(list.child("medals")[0].child("medal")[i].attribute("id"));
				mdl["mdl"+i]["i_text"]=list.child("medals")[0].child("medal")[i].attribute("descr");
				dscr.push(mdl["mdl"+i]["i_text"]);
				nms.push(list.child("medals")[0].child("medal")[i].attribute("name"));
				urls.push(stg_class.res_url+"/"+list.child("medals")[0].child("medal")[i].attribute("img"));
				mdl["mdl"+i].LoadImage(stg_class.res_url+"/"+list.child("medals")[0].child("medal")[i].attribute("img"));
			}
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function LoadImage(ur:String){
			//trace(ur);
			var loader:Loader = new Loader();
			var mc:MovieClip=new pre1();
			mc.x=29;
			mc.y=55;
			mc.gotoAndPlay(int(Math.random()*15)+1);
			mc.name="pre_cl";
			addChild(mc);
			addChild(loader);
			picts.push(loader);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openImage );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressImage);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeImage);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadImage);
			
			loader.load(new URLRequest(ur));
		}
		
		public function openImage(event:Event){
			
		}
		
		public function progressImage(event:Event){
			
		}
		
		public function completeImage(event:Event){
			try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}
			event.currentTarget.content.x+=1;
			event.currentTarget.content.y+=1;
			//event.currentTarget.content.name="pict";
		}
		
		public function accessError(event:Event){
			
		}
		
		public function unLoadImage(event:Event){
			
		}
		
		public function showInfo(info:String){
			root["info_tx"].selectable=false;
			root["info_tx"].multiline=true;
			root["info_tx"].autoSize=TextFieldAutoSize.LEFT;
			root["info_tx"].wordWrap=false;
			root["info_tx"].textColor=0xF0DB7D;
			root["info_tx"].text=info;
			root["info_tx"].x=x+parent.x;
			root["info_tx"].y=y-root["info_tx"].height-height/2+parent.y;
			if(root["info_tx"].y<0){
				root["info_tx"].y=0;
				root["info_tx"].x=x+width+10;
			}
			var info_w:int=root["info_tx"].width;
			var info_h:int=root["info_tx"].height;
			var info_rw:int=10;
			var info_rh:int=10;
			St_clip.self.graphics.lineStyle(1, 0x000000, 1, true);
			St_clip.self.graphics.beginFill(0x990700,1);
			St_clip.self.graphics.drawRoundRect(root["info_tx"].x-3, root["info_tx"].y, info_w+10, info_h+2, info_rw, info_rh);
			St_clip.stg.setChildIndex(St_clip.self,St_clip.stg.numChildren-1);
			St_clip.stg.setChildIndex(root["info_tx"],St_clip.stg.numChildren-1);
			root["info_tx"].visible=true;
		}
		
		public function showInfo1(info:String,X:int,Y:int,W:int){
			if(info==""){
				return;
			}
			root["info_tx"].selectable=false;
			root["info_tx"].multiline=true;
			root["info_tx"].autoSize=TextFieldAutoSize.LEFT;
			root["info_tx"].wordWrap=false;
			root["info_tx"].textColor=0xF0DB7D;
			root["info_tx"].text=info;
			root["info_tx"].x=X;
			root["info_tx"].y=Y;
			if(root["info_tx"].y<0){
				root["info_tx"].y=0;
				root["info_tx"].x=X+W+10;
			}
			var info_w:int=root["info_tx"].width;
			var info_h:int=root["info_tx"].height;
			var info_rw:int=10;
			var info_rh:int=10;
			St_clip.self.graphics.lineStyle(1, 0x000000, 1, true);
			St_clip.self.graphics.beginFill(0x990700,1);
			St_clip.self.graphics.drawRoundRect(root["info_tx"].x-3, root["info_tx"].y, info_w+10, info_h+2, info_rw, info_rh);
			St_clip.stg.setChildIndex(St_clip.self,St_clip.stg.numChildren-1);
			St_clip.stg.setChildIndex(root["info_tx"],St_clip.stg.numChildren-1);
			root["info_tx"].visible=true;
		}
		
		public function hideInfo(){
			St_clip.self.root["info_tx"].visible=false;
			St_clip.self.graphics.clear();
		}
		
		public function onError(event:IOErrorEvent):void{
			stg_cl.warn_f(4,"Личное дело");
		}
		
	}
}