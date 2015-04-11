package{
	
	//import flash.media.*;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	//import flash.utils.getQualifiedClassName;
  import flash.net.*;
	import flash.system.Security;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.text.*;
	//import flash.errors.IOError;
	import flash.xml.*;
	
	public class myButton extends MovieClip{
		
		public static var stg_cl:MovieClip;
		public static var stg_class:Class;
		
		public static var money:int=-1;
		public static var znaki:int=-1;
		public static var ar_znaki:int=-1;
		public static var checks:int=-1;
		public static var id_tank:int=-1;
		public static var fuel:int=-1;
		public static var fuel_max:int=1200;
		public static var pl_level:int=-1;
		
		public static var tf:TextFormat=new TextFormat("Verdana",9,0x006600,true);
		
		public static var m_init:Boolean=false;
		//public var types:Array=new Array();
		public static var serv_url:String="empty";
		public static var th_cl:Array=new Array();
		
		public static var send_vars:Array=new Array(7);
		
		public function get my_level():int{
			return (pl_level);
		}
		
		public function setVar(_ar:Array){
			fuel=_ar[0];
		}
		
		public function urlInit(_cl:MovieClip,url:String){
			serv_url=url;
			stg_cl=_cl;
			stg_class=stg_cl.getClass(stg_cl);
			root["buy_cred_win"].visible=false;
		}
		
		public function myButton(){
			//Font.registerFont(arial);
			//Font.registerFont(verdana);
			super();
			Security.allowDomain("*");
			stop();
			//txt.embedFonts=true;
			//txt.selectable=false;
			/*if(stg_cl==null){
				stg_cl=this.parent.parent as MovieClip;
				//trace(stg_cl);
			}*/
			
			if(name.slice(0,3)=="buy"&&int(name.slice(3,4))<3){
				th_cl.push(this);
			}else if(name.slice(0,5)=="min_b"||name.slice(0,5)=="min_b"){
				root["num_tx"+name.slice(5,6)+"_"+int(name.slice(7,9))].addEventListener(Event.CHANGE, changeHandler);
				root["num_tx"+name.slice(5,6)+"_"+int(name.slice(7,9))].addEventListener(FocusEvent.FOCUS_OUT, correctParty);
			}
			if(!m_init){
				//LoadMap();
				m_init=true;
				/*var mTimer=new Timer(1000, 1);
				mTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ready);
				mTimer.start();*/
			}
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
			addEventListener(MouseEvent.CLICK, m_click);
		}
		
		public function showInfo(info_str:String,X:int,Y:int,H:int){
			stg_cl.setChildIndex(stg_class.shop,stg_cl.numChildren-1);
			stg_cl.setChildIndex(stg_class.chat_cl,stg_cl.numChildren-1);
			root["info_tx"].selectable=false;
			root["info_tx"].multiline=true;
			root["info_tx"].autoSize=TextFieldAutoSize.LEFT;
			root["info_tx"].wordWrap=false;
			root["info_tx"].textColor=0xF0DB7D;
			root["info_tx"].text=info_str;
			root["info_tx"].x=X-root["info_tx"].width;
			root["info_tx"].y=Y-root["info_tx"].height-H/2;
			while(root["info_tx"].y<0){
				root["info_tx"].y+=5;
			}
			if(root["info_tx"].x<0){
				root["info_tx"].x=5;
			}else if(root["info_tx"].x+root["info_tx"].width>St_clip.stg_cl.width){
				root["info_tx"].x=St_clip.stg_cl.width-root["info_tx"].width-5;
			}
			var info_w:int=root["info_tx"].width;
			var info_h:int=root["info_tx"].height;
			var info_rw:int=10;
			var info_rh:int=10;
			St_clip.self.mouseEnabled=root["info_tx"].mouseEnabled=false;
			St_clip.self.graphics.lineStyle(1, 0x000000, 1, true);
			St_clip.self.graphics.beginFill(0x990700,1);
			St_clip.self.graphics.drawRoundRect(root["info_tx"].x-3, root["info_tx"].y, info_w+10, info_h+2, info_rw, info_rh);
			St_clip.stg_cl.setChildIndex(root["info_tx"],St_clip.stg_cl.numChildren-1);
			root["info_tx"].visible=true;
		}
		
		public function hideInfo(){
			root["info_tx"].visible=false;
			St_clip.self.graphics.clear();
		}
		
		public function sendRequest(names:Array, attr:Array, idies:Array, _i:int=0){
			//trace(serv_url);
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
				if(int(idies[0][0])==1){
					if(int(idies[1][0])==1){
						loader.addEventListener(Event.COMPLETE, listShop);
					}else if(int(idies[1][0])==33){
						loader.addEventListener(Event.COMPLETE, buyCredits);
						stg_class.wind["choise_cl"].setSt(-2);
					}
				}else if(int(idies[0][0])==2){
					if(int(idies[1][0])==2){
						loader.addEventListener(Event.COMPLETE, listSkills);
					}else if(int(idies[1][0])==3){
						loader.addEventListener(Event.COMPLETE, listItems);
					}else if(int(idies[1][0])==1){
						loader.addEventListener(Event.COMPLETE, listPlayer);
					}
				}else if(int(idies[0][0])==4){
					loader.addEventListener(Event.COMPLETE, addFuel);
					if(_i==0)stg_cl["buy_send"]=[names, attr, idies];
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
				if(int(idies[0][0])==1){
					if(int(idies[1][0])==2){
						loader.addEventListener(Event.COMPLETE, addSkills);
					}else if(int(idies[1][0])==3){
						loader.addEventListener(Event.COMPLETE, addItems);
					}
				}
			}
			//trace("str\n"+strXML);
			list=new XML(strXML);
			//trace("xml\n"+list);
			var variables:URLVariables = new URLVariables();
			variables.query = list;
			variables.send = "send";
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
			stg_cl.warn_f(10,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				if(event.currentTarget.currentFrameLabel=="empty"){
					return;
				}
				if(stg_class.help_on){
					if(name=="buy0_0"){
						if(stg_class.help_st!=4){
							return;
						}
					}else if(name=="buy0_1"){
						if(stg_class.help_st!=5){
							return;
						}
					}else if(name=="exit"){
						if(stg_class.help_st!=6){
							return;
						}
					}else if(name=="min_b0_1"||name=="max_b0_1"){
						if(stg_class.help_st!=5){
							return;
						}
					}else if(name!="yes_b"&&name!="no_b"){
						return;
					}
				}
				if((!root["wait_cl"].visible&&!root["fuel_win"].visible)||parent.name=="wait_cl"||parent.name=="fuel_win"){
					Mouse.cursor=MouseCursor.BUTTON;
					if(name.slice(0,4)=="info"){
						var _par:MovieClip=this.parent as MovieClip;
						if(_par.name=="fuel_win"||_par.name=="wait_cl"){
							showInfo(this["i_text"]+"",_par.x+x,_par.y+y,height);
						}else{
							showInfo(this["i_text"]+"",x,y,height);
						}
					}
					try{
						gotoAndStop("over");
					}catch(er:Error){}
				}
			}
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//if(!stg_cl["warn_er"]){
				if(event.currentTarget.currentFrameLabel=="empty"){
					return;
				}
				Mouse.cursor=MouseCursor.AUTO;
				if(name.slice(0,4)=="info"){
					hideInfo();
				}
				try{
					gotoAndStop("out");
				}catch(er:Error){}
			//}
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				if(event.currentTarget.currentFrameLabel=="empty"){
					return;
				}
				if(stg_class.help_on){
					if(name=="buy0_0"){
						if(stg_class.help_st!=4){
							return;
						}
					}else if(name=="buy0_1"){
						if(stg_class.help_st!=5){
							return;
						}
					}else if(name=="exit"){
						if(stg_class.help_st!=6){
							return;
						}
					}else if(name=="min_b0_1"||name=="max_b0_1"){
						if(stg_class.help_st!=5){
							return;
						}
					}else if(name!="yes_b"&&name!="no_b"){
						return;
					}
				}
				//ar_znaki
				if((!root["wait_cl"].visible&&!root["fuel_win"].visible)||event.currentTarget.parent.name=="wait_cl"||event.currentTarget.parent.name=="fuel_win"){
					event.currentTarget.gotoAndStop("press");
					init_iter(event.currentTarget as MovieClip);
				}
			}
		}
		
		public function init_iter(_this_cl:MovieClip){
			if(_this_cl.name.slice(0,5)=="min_b"){
				stg_cl.playSound("buy1",1);
				iter_clip=_this_cl;
				var _nm:Array=_this_cl.name.slice(5,12).split("_");
				iter_fund=function(){
					//root["buy"+_nm[0]+"_"+_nm[1]]["party"]=int(_this_cl.text);
					if(root["buy"+_nm[0]+"_"+_nm[1]]["party"]>root["buy"+_nm[0]+"_"+_nm[1]]["min_lim"]){
						root["buy"+_nm[0]+"_"+_nm[1]]["party"]-=root["buy"+_nm[0]+"_"+_nm[1]]["min_lim"];
						root["num_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["party"]+"";
						root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("out");
						try{
							root["m_m_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["_price_m"]*root["buy"+_nm[0]+"_"+_nm[1]]["party"];
							if((root["buy"+_nm[0]+"_"+_nm[1]]["_hide"]==1)||(int(root["m_m_tx"+_nm[0]+"_"+_nm[1]].text))>money){
								root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("empty");
							}
						}catch(er:Error){}
						try{
							root["m_z_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["_price_z"]*root["buy"+_nm[0]+"_"+_nm[1]]["party"];
							if((root["buy"+_nm[0]+"_"+_nm[1]]["_hide"]==1)||(int(root["m_z_tx"+_nm[0]+"_"+_nm[1]].text))>znaki){
								root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("empty");
							}
						}catch(er:Error){}
					}
				}
				start_iter();
			}else if(_this_cl.name.slice(0,5)=="max_b"){
				stg_cl.playSound("buy1",1);
				iter_clip=_this_cl;
				var _nm:Array=_this_cl.name.slice(5,12).split("_");
				var _max:int=995;
				if(_nm[0]==0){
					_max=9995;
				}
				iter_fund=function(){
					if(root["buy"+_nm[0]+"_"+_nm[1]]["party"]<_max){
						root["buy"+_nm[0]+"_"+_nm[1]]["party"]+=root["buy"+_nm[0]+"_"+_nm[1]]["min_lim"];
						root["num_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["party"]+"";
						root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("out");
						try{
							root["m_m_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["_price_m"]*root["buy"+_nm[0]+"_"+_nm[1]]["party"];
							if((root["buy"+_nm[0]+"_"+_nm[1]]["_hide"]==1)||(int(root["m_m_tx"+_nm[0]+"_"+_nm[1]].text))>money){
								root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("empty");
							}
						}catch(er:Error){}
						try{
							root["m_z_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["_price_z"]*root["buy"+_nm[0]+"_"+_nm[1]]["party"];
							if((root["buy"+_nm[0]+"_"+_nm[1]]["_hide"]==1)||(int(root["m_z_tx"+_nm[0]+"_"+_nm[1]].text))>znaki){
								root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("empty");
							}
						}catch(er:Error){}
					}
				}
				start_iter();
			}/*else if(_this_cl.name.slice(0,9)=="right_atz"){
				stg_cl.playSound("buy1",1);
				if(_this_cl.name.slice(9,10)=="1"){
					if(int(parent["from_tx"+_this_cl.name.slice(9,10)].text)<=znaki-5){
						parent["from_tx"+_this_cl.name.slice(9,10)].text=int(parent["from_tx"+_this_cl.name.slice(9,10)].text)+5;
						parent["to_tx"+_this_cl.name.slice(9,10)].text=int(parent["from_tx"+_this_cl.name.slice(9,10)].text)/5;
					}
				}
			}else if(_this_cl.name.slice(0,8)=="left_atz"){
				stg_cl.playSound("buy1",1);
				if(_this_cl.name.slice(8,9)=="1"){
					if(int(parent["from_tx"+_this_cl.name.slice(8,9)].text)>=5){
						parent["from_tx"+_this_cl.name.slice(8,9)].text=int(parent["from_tx"+_this_cl.name.slice(8,9)].text)-5;
						parent["to_tx"+_this_cl.name.slice(8,9)].text=int(parent["from_tx"+_this_cl.name.slice(8,9)].text)/5;
					}
				}
			}*/else if(_this_cl.name=="left_cr"){
				stg_cl.playSound("buy1",1);
				iter_clip=_this_cl;
				iter_fund=function(){
					if(int(parent["val_tx"].text)>=parent["_min"]){
						parent["val_tx"].text=int(parent["val_tx"].text)-1;
						cred_conv();
					}
				}
				start_iter();
			}else if(_this_cl.name=="right_cr"){
				stg_cl.playSound("buy1",1);
				iter_clip=_this_cl;
				iter_fund=function(){
					parent["val_tx"].text=int(parent["val_tx"].text)+1;
					cred_conv();
				}
				start_iter();
			}
		}
		
		public function stop_iter(event:MouseEvent){
			try{
				stage.removeEventListener(Event.ENTER_FRAME, obm_iter);
			}catch(er:Error){}
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, stop_iter);
			}catch(er:Error){}
			iter_c=0;
		}
		
		public function start_iter(){
			stop_iter(new MouseEvent(MouseEvent.MOUSE_UP));
			stage.addEventListener(MouseEvent.MOUSE_UP, stop_iter);
			stage.addEventListener(Event.ENTER_FRAME, obm_iter);
		}
		
		public function obm_iter(event:Event){
			if(iter_c>30){
				iter_fund.apply(iter_clip);
			}else if(iter_c>15&&iter_c%2==0){
				iter_fund.apply(iter_clip);
			}else if(iter_c>5&&iter_c%5==0){
				iter_fund.apply(iter_clip);
			}else if(iter_c%10==0){
				iter_fund.apply(iter_clip);
			}
			iter_c++;
		}
		
		public static var iter_fund:Function;
		public static var iter_clip:MovieClip;
		public static var iter_c:int=0;
		
		public function changeAmmo(event:Event){
			root["item_b0_0_"+event.currentTarget.name.slice(9,10)]["party"]=int(event.currentTarget.text);
		}
		
		public static var ava_id:int=0;
		public static var ava_page:int=0;
		public static var ava_type:int=-1;
		public static var ava_free:int=0;
		public static var ava_clip:MovieClip=new MovieClip();
		public static var weap_clip:MovieClip=new MovieClip();
		public static var weap_id:int=0;
		
		public function cred_conv(){
			root["buy_cred_win"]["val_name"].text=m_name(int(root["buy_cred_win"]["val_tx"].text),3);
			var _prc:int=stg_class.prnt_cl.val_conv(0,int(root["buy_cred_win"]["val_tx"].text));
			root["buy_cred_win"]["sn_tx"].text=_prc+" "+m_name(_prc,4);
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				if(event.currentTarget.currentFrameLabel=="empty"){
					return;
				}
				if(stg_class.help_on){
					if(name=="buy0_0"){
						if(stg_class.help_st!=4){
							return;
						}
					}else if(name=="buy0_1"){
						if(stg_class.help_st!=5){
							return;
						}
					}else if(name=="exit"){
						if(stg_class.help_st!=6){
							return;
						}
					}else if(name=="min_b0_1"||name=="max_b0_1"){
						if(stg_class.help_st!=5){
							return;
						}
					}else if(name!="yes_b"&&name!="no_b"){
						return;
					}
				}
				if((!root["wait_cl"].visible&&!root["fuel_win"].visible)||parent.name=="wait_cl"||parent.name=="fuel_win"){
					event.currentTarget.gotoAndStop("over");
				}
			}
		}
		
		public function m_click(event:MouseEvent){
			//trace(event.target+"   "+event.currentTarget);
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(stg_cl["wall_win"]){
					return;
				}
				if(event.currentTarget.currentFrameLabel=="empty"){
					return;
				}
				if(stg_class.help_on){
					if(name=="buy0_0"){
						if(stg_class.help_st!=4){
							return;
						}else{
							try{
								stg_cl.removeChild(stg_class.help_cl);
							}catch(er:Error){
								
							}
						}
					}else if(name=="buy0_1"){
						if(stg_class.help_st!=5){
							return;
						}else{
							try{
								stg_cl.removeChild(stg_class.help_cl);
							}catch(er:Error){
								
							}
						}
					}else if(name=="exit"){
						if(stg_class.help_st!=6){
							return;
						}else{
							try{
								stg_cl.removeChild(stg_class.help_cl);
							}catch(er:Error){
								
							}
							clear_buy_ar();
							stg_cl.createMode(1);
							stg_class.help_cl["lesson1"]["win"]["leave_cl"].set_type(7);
							stg_class.help_cl["lesson1"]["win"]["leave_cl"].sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",7+""]]);
						}
					}else if(name=="min_b0_1"||name=="max_b0_1"){
						if(stg_class.help_st!=5){
							return;
						}
					}else if(name!="yes_b"&&name!="no_b"){
						return;
					}
				}
				if((!root["wait_cl"].visible&&!root["fuel_win"].visible)||parent.name=="wait_cl"||parent.name=="fuel_win"){
					event.currentTarget.gotoAndStop("over");
					if(event.currentTarget.name=="exit"){
						clear_buy_ar();
						stg_cl.createMode(1);
					}else if(event.currentTarget.name=="yes_b"){
						this["_fnc"].call();
					}else if(event.currentTarget.name=="get_val_b"){
						clear_buy_ar();
						var _prc:int=stg_class.prnt_cl.val_conv(0,stg_class.prnt_cl.sn_price);
						root["buy_cred_win"]["kurs_tx"].text=stg_class.prnt_cl.sn_price+" "+m_name(stg_class.prnt_cl.sn_price,3)+"  - "+_prc+" "+m_name(_prc,4);
						root["buy_cred_win"]["val_tx"].text=5;
						root["buy_cred_win"]._min=2;
						cred_conv();
						root["buy_cred_win"].visible=true;
					}else if(event.currentTarget.name=="val_buy"){
						/*re_cred=new Object();
						re_cred._need=root["buy_cred_win"]["val_tx"].text;
						re_cred.fnc=function(){
							sendRequest(["query","action"],[["id"],["id","add_val"]],[["1"],[33+"",re_cred._need]]);
						}
						re_cred.fnc.call();*/
						sendRequest(["query","action"],[["id"],["id","add_val"]],[["1"],[33+"",root["buy_cred_win"]["val_tx"].text]]);
					}else if(event.currentTarget.name=="rekl4"){
						stg_class.prnt_cl.linkTo1(new URLRequest(links[4]));
					}else if(event.currentTarget.name=="show_all"){
						resetRkl();
						sendRequest(["query","action"],[["id"],["id","all","type"]],[["2"],[11+"",1+"",-1+""]]);
					}else if(event.currentTarget.name=="teh_cl"){
						root["fuel_win"].visible=true;
						root["fuel_win"]["comm_tx"].textColor=0xff0000;
						root["fuel_win"]["buy_fuel"].gotoAndStop("empty");
						if(int(root["fuel_win"]["m_tx"].text)>money){
							root["fuel_win"]["comm_tx"].text="У ВАС недостаточно средств!";
						}else if(fuel==fuel_max){
							root["fuel_win"]["comm_tx"].text="У ВАС максимум топлива!";
						}else{
							root["fuel_win"]["comm_tx"].textColor=0x009900;
							root["fuel_win"]["comm_tx"].text="Покупка доступна!";
							root["fuel_win"]["buy_fuel"].gotoAndStop("out");
						}
						root["fuel_win"]["buy_fuel"]["party"]=root["fuel_win"]["buy_fuel"]["min_party"];
						root["fuel_win"]["m_tx"].text=root["fuel_win"]["buy_fuel"]["party"]*root["fuel_win"]["buy_fuel1"]["price_m"];
						root["fuel_win"]["fuel_tx"].text=(root["fuel_win"]["buy_fuel"]["party"])+"/"+fuel_max;
						root["fuel_win"]["fill_cl"].height=((root["fuel_win"]["buy_fuel"]["party"])/fuel_max)*96;
					}else if(event.currentTarget.name=="close_cl"){
						event.currentTarget.parent.visible=false;
						if(event.currentTarget.parent.name=="buy_cred_win"){
							buy_not();
							try{
								buy_mem("buy");
							}catch(er:Error){
								clear_buy_ar();
							}
						}
						root["fuel_win"]["buy_fuel"]["party"]=root["fuel_win"]["buy_fuel"]["min_party"];
						root["fuel_win"]["m_tx"].text=root["fuel_win"]["buy_fuel"]["party"]*root["fuel_win"]["buy_fuel1"]["price_m"];
						root["fuel_win"]["fuel_tx"].text=(root["fuel_win"]["buy_fuel"]["party"])+"/"+fuel_max;
						root["fuel_win"]["fill_cl"].height=((root["fuel_win"]["buy_fuel"]["party"])/fuel_max)*96;
					}else if(event.currentTarget.name=="buy_fuel1"){
						root["fuel_win"]["buy_fuel"]["party"]+=root["fuel_win"]["buy_fuel"]["min_party"];
						if(root["fuel_win"]["buy_fuel"]["party"]>fuel_max){
							root["fuel_win"]["buy_fuel"]["party"]=fuel_max;
						}
						root["fuel_win"]["m_tx"].text=root["fuel_win"]["buy_fuel"]["party"]*root["fuel_win"]["buy_fuel1"]["price_m"];
						root["fuel_win"]["fuel_tx"].text=(root["fuel_win"]["buy_fuel"]["party"])+"/"+fuel_max;
						root["fuel_win"]["fill_cl"].height=((root["fuel_win"]["buy_fuel"]["party"])/fuel_max)*96;
						root["fuel_win"]["comm_tx"].textColor=0xff0000;
						root["fuel_win"]["buy_fuel"].gotoAndStop("empty");
						if(int(root["fuel_win"]["m_tx"].text)>money){
							root["fuel_win"]["comm_tx"].text="У ВАС недостаточно средств!";
						}else if(fuel==fuel_max){
							root["fuel_win"]["comm_tx"].text="У ВАС максимум топлива!";
						}else{
							root["fuel_win"]["comm_tx"].textColor=0x009900;
							root["fuel_win"]["comm_tx"].text="Покупка доступна!";
							root["fuel_win"]["buy_fuel"].gotoAndStop("out");
						}
					}else if(event.currentTarget.name=="no_b"){
						//root["fuel_win"]["buy_fuel"]["party"]=0;
						//root["fuel_win"]["fuel_tx"].text=(fuel+root["fuel_win"]["buy_fuel"]["party"])+"/"+root["fuel_win"]["buy_fuel"]["min_party"];
						//root["fuel_win"]["fill_cl"].height=((fuel+root["fuel_win"]["buy_fuel"]["party"])/root["fuel_win"]["buy_fuel"]["min_party"])*96;
						root["wait_cl"].visible=false;
						if(stg_class.help_on){
							var _lsn:int=stg_class.help_st;
							stg_cl.Lesson(_lsn);
						}
					}else if(event.currentTarget.name=="buy_val"){
						root["exit"].showMWin(5);
					}else if(event.currentTarget.name.slice(0,3)=="buy"){
						initBuy(event.currentTarget as MovieClip);
					}
				}
			}
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
		
		public function initBuy(_buy_cl:MovieClip){
			if(_buy_cl.name.slice(0,3)=="buy"){
				var _nm:Array=_buy_cl.name.slice(3,10).split("_");
				var _id:int=_buy_cl["ID"];
				var _party:int=_buy_cl["party"];
				if(_buy_cl.name=="buy_fuel"){
					root["wait_cl"].gotoAndStop(1);
					root["wait_cl"]["buy_type"].text="Вы покупаете:"
					root["wait_cl"]["what_buy"].text=root["fuel_win"]["buy_fuel"]["party"]+" л. топлива";
					root["wait_cl"]["price_m_tx"].text=root["fuel_win"]["m_tx"].text;
					root["wait_cl"]["price_z_tx"].text=0;
					root["wait_cl"]["yes_b"]._fnc=function(){
						sendRequest(["query","action"],[["id"],["id","quantity"]],[["4"],[_id+"",root["fuel_win"]["buy_fuel"]["party"]+""]]);
					}
				}else if(int(_nm[0])<3){
					root["wait_cl"].gotoAndStop(1);
					if(_buy_cl["_type"]==1){
						root["wait_cl"]["buy_type"].text="Вы покупаете умение:"
						root["wait_cl"]["what_buy"].text=root["name_tx"+int(_nm[0])+"_"+int(_nm[1])].text;
						root["wait_cl"]["yes_b"]._fnc=function(){
							sendRequest(["query","action","buy"],[["id"],["id"],["id"]],[["1"],["2"],[_id+""]]);
						}
					}else{
						root["wait_cl"]["buy_type"].text="Вы покупаете предмет:"
						root["wait_cl"]["what_buy"].text=root["name_tx"+int(_nm[0])+"_"+int(_nm[1])].text+"-"+_party+"шт.";
						root["wait_cl"]["yes_b"]._fnc=function(){
							sendRequest(["query","action","buy"],[["id"],["id"],["id","quantity"]],[["1"],["3"],[_id+"",_party+""]]);
						}
					}
					try{
						root["wait_cl"]["price_m_tx"].text=root["m_m_tx"+int(_nm[0])+"_"+int(_nm[1])].text;
					}catch(er:Error){
						root["wait_cl"]["price_m_tx"].text=0;
					}
					try{
						root["wait_cl"]["price_z_tx"].text=root["m_z_tx"+int(_nm[0])+"_"+int(_nm[1])].text;
					}catch(er:Error){
						root["wait_cl"]["price_z_tx"].text=0;
					}
				}else if(int(_nm[0])==4){
					root["wait_cl"].gotoAndStop(2);
					root["wait_cl"]["buy_type"].text="Вы покупаете:"
					try{
						root["wait_cl"]["what_buy"].text=root["m_m_tx"+int(_nm[0])+"_"+int(_nm[1])].text+" ";
					}catch(er:Error){
						try{
							root["wait_cl"]["what_buy"].text=root["m_z_tx"+int(_nm[0])+"_"+int(_nm[1])].text+" ";
						}catch(er:Error){
							try{
								root["wait_cl"]["what_buy"].text=root["m_a_tx"+int(_nm[0])+"_"+int(_nm[1])].text+" ";
							}catch(er:Error){
								
							}
						}
					}
					root["wait_cl"]["what_buy"].appendText(root["name_tx"+int(_nm[0])+"_"+int(_nm[1])].text);
					root["wait_cl"]["yes_b"]._fnc=function(){
						sendRequest(["query","action"],[["id"],["id"]],[["4"],[_id+""]]);
					}
				}
				root["wait_cl"].visible=true;
			}
		}
		
		public function waiting(event:TimerEvent):void{
			////trace(event.currentTarget.currentCount);
			if(event.currentTarget.currentCount>9){
				root["wait_cl"].alpha-=1/10;
			}
		}
		
		public function waiting1(event:TimerEvent):void{
			////trace(event.currentTarget.currentCount);
			if(event.currentTarget.currentCount>9){
				root["wait_cl"].alpha-=1/5;
			}
		}
		
		public function time_over(event:TimerEvent):void{
			root["wait_cl"].visible=false;
		}
		
		public function onError(event:IOErrorEvent):void{
			//trace("Shop+php: "+event);
			stg_cl.warn_f(4,"Ангар");
		}
		
		public static var rkls:Array=new Array(5);
		public static var links:Array=new Array("","","","","");
		public static var rkln:Array=new Array(5);
		public static var rkld:Array=new Array(5);
		
		
		public function LoadImage(ur:String,_t:int,_c:int){
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = true;
			var loader:Loader = new Loader();
			//trace(loader+"   "+loader.contentLoaderInfo);
			var mcl:MovieClip=new MovieClip();
			if(_t>-2){
				mcl.addEventListener(MouseEvent.MOUSE_OVER, m_over);
				mcl.addEventListener(MouseEvent.MOUSE_OUT, m_out);
				mcl.addEventListener(MouseEvent.MOUSE_DOWN, m_press);
				mcl.addEventListener(MouseEvent.MOUSE_UP, m_release);
			}
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressImage);
			if(_t==5){
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeRkl);
				mcl.graphics.clear();
				mcl.graphics.beginFill(0xffffff,.1);
				mcl.graphics.drawRect(0,0,258,75);
				mcl.name="rekl4";
				mcl.addChild(loader);
				rkls[4]=(mcl);
				stg_class.games_cl["ch1"].Reklame(rkln[4],rkld[4],rkls[4],1);
			}else if(_t==6){
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeRkl);
				mcl.graphics.clear();
				mcl.graphics.beginFill(0xffffff,.1);
				mcl.graphics.drawRect(0,0,258,75);
				mcl.name="rekl4";
				mcl.addChild(loader);
				rkls[4]=(mcl);
				//trace(rkln[4],rkld[4],rkls[4]);
				stg_class.games_cl["ch1"].Reklame(rkln[4],rkld[4],rkls[4],2);
			}
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadImage);
			if(_t<2){
				loader.load(new URLRequest(ur), loaderContext);
			}else{
				loader.load(new URLRequest(ur+"?"+(Math.random()*1000000000000)), loaderContext);
			}
		}
		
		public function Reklame(ur:String,_t:int,_c:int,arr:Array){
			//trace("free      "+ur);
			rkln[4]=arr[0];
			rkld[4]=arr[1];
			links[4]=arr[2];
			LoadImage(ur,5,_c);
			LoadImage(ur,6,_c);
		}
		
		public function resetRkl(){
			stg_class.games_cl["ch1"].resetRkl(rkls);
			stg_class.prnt_cl._sendRequest("getAds");
		}
		
		public function openAva(event:Event){
			
		}
		
		public function progressImage(event:ProgressEvent){
			
		}
		
		public function completeRkl(event:Event){
			event.currentTarget.content.x=0;
			event.currentTarget.content.y=0;
		}
		
		public function completeRand(event:Event){
			try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}
			event.currentTarget.content.x=0;
			event.currentTarget.content.y=0;
			//event.currentTarget.content.name="pict";
		}
		
		public function completeWeap(event:Event){
			/*try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}*/
			event.currentTarget.content.x=1;
			event.currentTarget.content.y=14;
			//event.currentTarget.content.name="pict";
		}
		
		public function completeNew(event:Event){
			/*try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}*/
			event.currentTarget.content.x=0;
			event.currentTarget.content.y=0;
			//event.currentTarget.content.name="pict";
		}
		
		public function completeAll(event:Event){
			try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}
			event.currentTarget.content.x=0;
			event.currentTarget.content.y=0;
			//event.currentTarget.content.name="pict";
		}
		
		public function accessError(event:SecurityErrorEvent){
			
		}
		
		public function unLoadImage(event:IOErrorEvent){
			
		}
		
		public function showMWin(_need:int){
			clear_buy_ar();
			var _prc:int=stg_class.prnt_cl.val_conv(0,stg_class.prnt_cl.sn_price);
			root["buy_cred_win"]["kurs_tx"].text=stg_class.prnt_cl.sn_price+" "+m_name(stg_class.prnt_cl.sn_price,3)+"  - "+_prc+" "+m_name(_prc,4);
			root["buy_cred_win"]["val_tx"].text=_need;
			root["buy_cred_win"]._min=2;
			cred_conv();
			root["buy_cred_win"].visible=true;
		}
		
		private static var re_cred:Object;
		public function rebuyCredits():void{
			try{re_cred.fnc.call();}catch(er:Error){}
			re_cred=null;
			
			try{
				root["exit"].buy_mem("buy");
				root["buy_cred_win"].visible=false;
				//trace("a");
			}catch(er:Error){
				stg_class.panel["ammo0"].sendRequest(["query","action"],[["id"],["id"]],[["2"],["25"]]);
			}
		}
		
		public static var re_buy:Object;
		
		public function needMoney(_ar:Array,_need:int,_min:int=0){
			re_buy=new Object();
			re_buy._ar=_ar;
			re_buy._need=_need;
			re_buy.first_call=function(){
				re_buy._ar[0].call();
			};
			re_buy.listShop=function(_str:int){
				var _prc:int=stg_class.prnt_cl.val_conv(0,stg_class.prnt_cl.sn_price);
				root["buy_cred_win"]["kurs_tx"].text=stg_class.prnt_cl.sn_price+" "+m_name(stg_class.prnt_cl.sn_price,3)+"  - "+_prc+" "+m_name(_prc,4);
				root["buy_cred_win"]["val_tx"].text=re_buy._need;
				if(_min==0){
					root["buy_cred_win"]._min=re_buy._need+1;
				}else{
					root["buy_cred_win"]._min=2;
				}
				cred_conv();
				root["buy_cred_win"].visible=true;
			};
			for(var i:int=1;i<re_buy._ar.length;i++){
				re_buy[re_buy._ar[i][1]+"_function"]=_ar[i][0];
				re_buy[re_buy._ar[i][1]]=function(_str:String){
					re_buy[_str].call();
				};
			}
			re_buy.first_call.call();
		}
		
		public function any_func(_fnc:Function){
			re_buy=new Object();
			re_buy.listShop=_fnc;
		}
		
		public function buy_mem(_str:String){
			re_buy[_str].apply(re_buy,[_str+"_function"]);
		}
		
		public function clear_buy_ar(){
			re_buy=null;
		}
		
		public function buy_not(){
			try{
				re_buy["re_try"]=null;
			}catch(er:Error){
				
			}
		}
		
		public function buyCredits(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nПокупка кредитов.");
				stg_class.wind["choise_cl"].erTestReq(1,33,str);
				return;
			}
			//trace(list);
			try{
				if(list.child("err")[0].attribute("code")!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					if(int(list.child("err")[0].attribute("sn_val_need"))!=0){
						stg_class.prnt_cl.showMoneyWin(int(list.child("err")[0].attribute("sn_val_need")));
						stg_cl.warn_f(9,"");
					}
					return;
				}else{
					re_cred=null;
					try{
						root["exit"].buy_mem("buy");
						root["buy_cred_win"].visible=false;
						//trace("a");
					}catch(er:Error){
						//sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["1"],["1","0","1","1"]]);
						//trace("b");
					}
					stg_cl.warn_f(9,"");
					fuel=int(list.child("err")[0].attribute("fuel"));
					setMoneys([int(list.child("err")[0].attribute("money_m")),int(list.child("err")[0].attribute("money_z")),int(list.child("err")[0].attribute("money_a")),int(list.child("err")[0].attribute("sn_val"))]);
					stg_class.panel["fuel_tx"].text=fuel+"/"+list.child("err")[0].attribute("fuel_max");
					stg_class.panel["fuel_bar"].graphics.clear();
					stg_class.panel["fuel_bar"].graphics.beginFill(0x00ff00);
					stg_class.panel["fuel_bar"].graphics.drawRect(.5,.5,(fuel/int(list.child("err")[0].attribute("fuel_max")))*87,3);
				}
			}catch(er:Error){
				
			}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function addFuel(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nПокупка, vip раздел.");
				stg_class.wind["choise_cl"].erTestReq(4,0,str);
				return;
			}
			//trace("addFuel   "+list);
			try{
				var _vn:int=0;
				if(list.child("err")[0].attribute("code")==1){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					_vn=1;
					//return;
				}else if(list.child("err")[0].attribute("code")==2){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					_vn=2;
					//return;
				}else if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
				}else{
					stg_cl.warn_f(9,"");
					//sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["2"],["1","0","1","1"]]);
					fuel=int(list.child("err")[0].attribute("fuel"));
					setMoneys([int(list.child("err")[0].attribute("money_m")),int(list.child("err")[0].attribute("money_z")),int(list.child("err")[0].attribute("money_a")),int(list.child("err")[0].attribute("sn_val"))]);
					stg_class.panel["fuel_tx"].text=fuel+"/"+list.child("err")[0].attribute("fuel_max");
					stg_class.panel["fuel_bar"].graphics.clear();
					stg_class.panel["fuel_bar"].graphics.beginFill(0x00ff00);
					stg_class.panel["fuel_bar"].graphics.drawRect(.5,.5,(fuel/int(list.child("err")[0].attribute("fuel_max")))*87,3);
					testPrice();
				}
				if(int(list.child("err")[0].attribute("sn_val_need"))!=0){
					stg_cl.warn_f(9,"");
					var _ar:Array=new Array();
					_ar[0]=function(){
						try{buy_mem("listShop");}catch(er:Error){trace(er);}
					};
					_ar[1]=new Array();
					_ar[1][0]=function(){
						try{buy_mem("re_try");}catch(er:Error){}
						try{buy_mem("end");}catch(er:Error){}
					};
					_ar[1][1]="buy";
					_ar[2]=[function(){
						clear_buy_ar();
					},"end"];
					_ar[3]=[function(){
						sendRequest(stg_cl["buy_send"][0],stg_cl["buy_send"][1],stg_cl["buy_send"][2]);
					},"re_try"];
					needMoney(_ar,int(list.child("err")[0].attribute("sn_val_need")));
				}
				if(_vn!=0){
					return;
				}
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nПокупка, vip раздел.");
				stg_class.wind["choise_cl"].erTestReq(4,0,str);
				return;
			}
			root["wait_cl"].visible=false;
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function testPrice():void{
			for(var j=0;j<th_cl.length;j++){
				var _b:int=0;
				try{
					if(int(root["m_m_tx"+th_cl[j].name.substr(3)].text)>money){
						_b=1;
					}
				}catch(er:Error){}
				try{
					if(int(root["m_z_tx"+th_cl[j].name.substr(3)].text)>znaki){
						_b=1;
					}
				}catch(er:Error){}
				if(th_cl[j]["_hide"]==0||th_cl[j]["_hide"]==2){
					if(_b==0){
						th_cl[j].gotoAndStop("out");
					}else{
						th_cl[j].gotoAndStop("empty");
					}
				}
			}
		}
		
		public function addSkills(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nПокупка умений.");
				stg_class.wind["choise_cl"].erTestReq(1,2,str);
				return;
			}
			
			//trace("addSkills\n"+list+"\n");
			try{
				if(list.child("err")[0].attribute("code")!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){}
			if(int(list.child("moneys")[0].attribute("ws1"))>0){
				stg_class.f_cd1=int(list.child("moneys")[0].attribute("ws1"));
			}
			////trace(list.child("err")[0].attribute("id")+"   "+list.child("err")[0].attribute("money_m"));
			var _er:int=0;
			_er=shopUpdate(list);
			
			money=list.child("moneys")[0].attribute("money_m");
			znaki=list.child("moneys")[0].attribute("money_z");
			stg_class.panel["skills_tx"].text=znaki;
			stg_class.panel["money_tx"].text=money;
			
			for(var i:int=0;i<list.child("slot").length();i++){
				var _cl:MovieClip=stg_class.panel["ammo0"].find_sl2(int(list.child("slot")[i].attribute("id")));
				if(_cl!=null){
					if(_cl.name.slice(0,4)!="ammo"){
						_cl.teg_slot(list.child("slot")[i],1);
					}else{
						//trace("b   "+th_cl[j].name.slice(10,11)+"   "+th_cl[j]["ID"]);
						_cl.quantity=int(list.child("slot")[i].attribute("num"));
						_cl.empty=!Boolean(int(list.child("slot")[i].attribute("ready")));
						stg_class.panel["ammo0"].resetAmmo();
					}
				}
			}
			root["wait_cl"].visible=false;
			if(_er<=0){
				stg_cl.warn_f(9,"");
			}
			if(stg_class.help_on){
				var _lsn:int=stg_class.help_st+1;
				stg_cl.initLesson(_lsn);
				stg_class.help_cl["lesson1"]["win"]["leave_cl"].set_type(_lsn);
				stg_class.help_cl["lesson1"]["win"]["leave_cl"].sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",_lsn+""]]);
			}
			testPrice();
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function named():String{
		  var _str:String="empty";
			 if(name.slice(0,7)=="skill_b"){
				if(name=="skill_b1_0"){
					_str="power_cl";
				}else if(name=="skill_b1_2"){
					_str="fast_fire";
				}else if(name=="skill_b2_1"){
					_str="mine";
				}else if(name=="skill_b2_0"){
					_str="remont";
				}else if(name=="skill_b2_2"){
					_str="radio1";
				}else if(name=="skill_b2_3"){
					_str="radio2";
				}else if(name=="skill_b2_4"){
					_str="radio3";
				}else if(name=="skill_b0_0"){
					_str="ammo";
				}else if(name=="skill_b1_1"){
					_str="speed_cl";
				}
			}
			return _str;
		}
		
		public function addItems(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nПокупка предметов.");
				stg_class.wind["choise_cl"].erTestReq(1,3,str);
				return;
			}
			try{
				if(list.child("err")[0].attribute("code")!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){}
			//trace("addItems\n"+list+"\n");
			money=list.child("moneys")[0].attribute("money_m");
			znaki=list.child("moneys")[0].attribute("money_z");
			stg_class.panel["skills_tx"].text=znaki;
			stg_class.panel["money_tx"].text=money;
			
			for(var i:int=0;i<list.child("slot").length();i++){
				var _cl:MovieClip=stg_class.panel["ammo0"].find_sl2(int(list.child("slot")[i].attribute("id")));
				if(_cl!=null){
					if(_cl.name.slice(0,4)!="ammo"){
						_cl.teg_slot(list.child("slot")[i],1);
					}else{
						//trace("b   "+th_cl[j].name.slice(10,11)+"   "+th_cl[j]["ID"]);
						_cl.quantity=int(list.child("slot")[i].attribute("num"));
						_cl.empty=!Boolean(int(list.child("slot")[i].attribute("ready")));
						stg_class.panel["ammo0"].resetAmmo();
					}
				}
			}
			root["wait_cl"].visible=false;
			if(stg_class.help_on){
				var _lsn:int=stg_class.help_st+1;
				stg_cl.initLesson(_lsn);
				stg_class.help_cl["lesson1"]["win"]["leave_cl"].set_type(_lsn);
				stg_class.help_cl["lesson1"]["win"]["leave_cl"].sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",_lsn+""]]);
			}
			testPrice();
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function listSkills(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nСписок умений.");
				stg_class.wind["choise_cl"].erTestReq(2,2,str);
				return;
			}
			//trace("listSkills\n"+list+"\n");
			
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function listItems(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nСписок предметов.");
				stg_class.wind["choise_cl"].erTestReq(2,3,str);
				return;
			}
			//trace("listItems\n"+list+"\n");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		private var m_m_names:Array=["монета войны","монеты войны","монет войны","монеты войны","монетах войны"];
		private var m_z_names:Array=["знак отваги","знака отваги","знаков отваги","знаки отваги","знаках отваги"];
		private var m_a_names:Array=["знак арены","знака арены","знаков арены","знаки арены","знаках арены"];
		private var vl_names:Array=["кредит","кредита","кредитов","кредиты","кредитах"];
		
		public function m_name(_n:Number,_type:int,_many:int=0):String{
			var _i:int;
			var _str:String=String(_n);
			var _l:int=_str.length;
			if(_many==0){
				if(_l>1&&_str.substr(_l-2,1)=="1"){
					_i=2;
				}else if(_str.substr(_l-1,1)=="1"){
					_i=0;
				}else if(int(_str.substr(_l-1,1))>4||int(_str.substr(_l-1,1))==0){
					_i=2;
				}else{
					_i=1;
				}
			}else if(_many==1){
				_i=3;
			}else if(_many==2){
				_i=4;
			}
			if(_type==0){
				return m_m_names[_i];
			}else if(_type==1){
				return m_z_names[_i];
			}else if(_type==2){
				return m_a_names[_i];
			}else if(_type==3){
				return vl_names[_i];
			}
			return stg_class.prnt_cl.sn_name[_i];
		}
		
		public function getMoneys(_i:int):Number{
			if(_i==0){
				return money;
			}else if(_i==1){
				return znaki;
			}else if(_i==2){
				return ar_znaki;
			}
			return checks;
		}
		
		public function setMoneys(_ar:Array){
			if(_ar[0]>=0){money=_ar[0];}
			if(_ar[1]>=0){znaki=_ar[1];}
			if(_ar[2]>=0){ar_znaki=_ar[2];}
			if(_ar[3]>=0){checks=_ar[3];}
			stg_class.panel["skills_tx"].text=znaki;
			stg_class.panel["ar_tx"].text=ar_znaki;
			stg_class.panel["money_tx"].text=money;
			stg_class.panel["credits_tx"].text=checks;
			root["vip2"].text="На счету "+checks+" "+m_name(checks,3);
		}
		
		public function addMoneys(_ar:Array){
			if(int(_ar[0])!=0){money+=_ar[0];}
			if(int(_ar[1])!=0){znaki+=_ar[1];}
			if(int(_ar[2])!=0){ar_znaki+=_ar[2];}
			if(int(_ar[3])!=0){checks+=_ar[3];}
			stg_class.panel["skills_tx"].text=znaki;
			stg_class.panel["ar_tx"].text=ar_znaki;
			stg_class.panel["money_tx"].text=money;
			stg_class.panel["credits_tx"].text=checks;
			root["vip2"].text="На счету "+checks+" "+m_name(checks,3);
		}
		
		public function listPlayer(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			onlyPlayer(str);
		}
		
		public function onlyPlayer(str:String,_er:int=0):void{
			//trace(str);
			try{
				var list:XML=new XML(str);
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nПрофиль игрока.");
				stg_class.wind["choise_cl"].erTestReq(2,1,str);
				return;
			}
			//trace("listPlayer\n"+list+"\n");
			if(list.child("result").length()>0){
				list=list.child("result")[0].child("profile")[0];
			}else if(list.child("profile").length()>0){
				list=list.child("profile")[0];
			}else{
				stg_cl.warn_f(5,"Неверный формат полученных данных.\n1_Профиль игрока.");
				stg_class.wind["choise_cl"].erTestReq(2,1,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			
			//trace("listPlayer\n"+list+"\n");
			//wall_mess
			var s1:String="tank";
			fuel=int(list.child(s1)[0].attribute("fuel"));
			setMoneys([int(list.child(s1)[0].attribute("money_m")),int(list.child(s1)[0].attribute("money_z")),int(list.child(s1)[0].attribute("money_a")),int(list.child(s1)[0].attribute("sn_val"))]);
			stg_class.panel["fuel_tx"].text=fuel+"/"+list.child(s1)[0].attribute("fuel_max");
			stg_class.panel["fuel_bar"].graphics.clear();
			stg_class.panel["fuel_bar"].graphics.beginFill(0x00ff00);
			stg_class.panel["fuel_bar"].graphics.drawRect(.5,.5,(fuel/int(list.child(s1)[0].attribute("fuel_max")))*87,3);
			
			if(int(list.child(s1)[0].attribute("group_id"))>0){
				stg_class.wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["7"],["5"]]);
			}else{
				
			}
			stg_cl.initLesson(int(list.child(s1)[0].attribute("study")));
			stg_cl["v_name"]=list.child(s1)[0].attribute("name");
			stg_class.stat_cl["ch1"].setNamePl(list.child(s1)[0].attribute("rang")+" "+stg_cl["v_name"]);
			stg_class.wind["choise_cl"].startStatus();
			for(var i=0;i<list.child(s1)[0].child("medals")[0].child("medal").length();i++){
				try{
					stg_cl.holly[0]=list.child(s1).child("medals")[0].child("medal")[i].attribute("title");
					stg_cl.holly[1]=list.child(s1).child("medals")[0].child("medal")[i].attribute("message");
				}catch(er:Error){
					stg_cl.holly[0]="no holly";
				}
				stg_cl.upl[0]=list.child(s1).child("medals")[0].child("medal")[i].attribute("id");
				stg_cl.upl_name=list.child(s1).child("medals")[0].child("medal")[i].attribute("name");
				stg_cl.upl_mess=list.child(s1).child("medals")[0].child("medal")[i].attribute("descr");
				stg_cl.upl_mess1=list.child(s1)[0].attribute("rang")+" "+stg_cl["v_name"];
				stg_class.prnt_cl["upl_pict"]=serv_url.slice(0,serv_url.length-13)+list.child(s1).child("medals")[0].child("medal")[i].attribute("img");
				stg_cl.showWall();
				break;
			}
			stg_cl["kurs"]=int(list.child(s1)[0].attribute("kurs"));
			stg_cl["dov_e"]=Number(list.child(s1)[0].attribute("doverie"));
			
			id_tank=list.child(s1)[0].attribute("id");
			pl_level=list.child(s1)[0].attribute("level");
			if(pl_level>2){
				stg_class.wind["choise_cl"].showNews();
			}
			stg_cl["polk_id"]=list.child(s1)[0].attribute("polk");
			
			if(stg_cl["polk_id"]!=0){
				if(int(list.child(s1)[0].attribute("polk_rang"))!=100){
					stg_class.chat_cl.polkSet(list.child(s1)[0].attribute("room"),1);
				}else{
					stg_class.chat_cl.polkSet(list.child(s1)[0].attribute("room"));
				}
			}else{
				stg_class.chat_cl.room_exit(2);
			}
			stg_class.chat_cl.saveInfo();
			stg_class.chat_cl.setRooms();
			
			if(int(list.child(s1)[0].attribute("mess_count"))>0){
				stg_class.chat_cl["messages"]=int(list.child(s1)[0].attribute("mess_count"));
				stg_class.chat_cl.light_mess();
			}
			
			stg_class.rang_name=list.child(s1)[0].attribute("rang")+"";
			stg_class.rang_st=list.child(s1)[0].attribute("rang_st")+"";
			stg_cl.expoInit(int(list.child(s1)[0].attribute("level")),int(list.child(s1)[0].attribute("exp_now")),int(list.child(s1)[0].attribute("exp_max")),list.child(s1)[0].attribute("rang"));
			stg_class.norm_sp=(24/(int(list.child(s1)[0].attribute("param2"))*2));
			stg_class.fast_sp=(24/(int(list.child(s1)[0].attribute("param3"))*2));
			stg_class.basic_dm=int(list.child(s1)[0].attribute("dp"));
			stg_class.pl_name=stg_cl["v_name"];
			
			testPrice();
		
			stg_class.chat_cl.onCreationComplete();
			stg_class.chat_cl.rootSet(stg_class.prnt_cl.root_gr);
			if(_er==0){
				stg_cl.warn_f(9,"");
			}
			//stg_class.panel["ammo0"].resetAmmo();
			//clip.createMode(2);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function typed(_i:int):String{
			var _str:String="empty";
			if(_i<11){
				_str="ammo"+(_i-2);
			}else if(_i<21){
				if((_i-10)<6){
					_str="mine"+(_i-10);
				}else{
					_str="get_die";
				}
			}else if(_i<31){
				_str="remont"+(_i-20);
			}else if(_i<41){
				_str="radio"+(_i-30);
			}else if(_i==41){
				_str="power_cl";
			}else if(_i==42){
				_str="fast_fire";
			}else if(_i==43){
				_str="new_live";
			}else if(_i==44){
				_str="speed_cl";
			}else if(_i==47){
				_str="stels_cl";
			}else if(_i==48){
				_str="set_free";
			}
			return _str;
		}
		
		public var getted:int=0;
		
		public static var myPattern:RegExp =  /\r\n/gi;
		public static var myPattern1:RegExp = /\r\r/gi;
		public static var myPattern2:RegExp = /\n\n/gi;
		public static var myPattern3:RegExp = /\n\r/gi;
		public static var myPattern4:RegExp = /\[br\]/gi;
		
		public function new_line_f(_s:String):String{
			var _text:String="";
			//trace(_s);
			_text=_s.replace(myPattern, "\n");
			_text=_text.replace(myPattern1, "\n");
			_text=_text.replace(myPattern2, "\n");
			_text=_text.replace(myPattern3, "\n");
			_text=_text.replace(myPattern4, "\n");
			return _text;
		}
		
		public function listShop(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nПеречень товаров.");
				stg_class.wind["choise_cl"].erTestReq(1,1,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			//trace("listShop\n"+list+"\n");
			//str="";
			//var tf:TextFormat=new TextFormat("myVerdana", 9, 0x990000);
			var _er:int=0;
			var _prc:int=stg_class.prnt_cl.val_conv(0,stg_class.prnt_cl.sn_price);
			root["val_kurs_tx"].text="Курс : "+stg_class.prnt_cl.sn_price+" "+m_name(stg_class.prnt_cl.sn_price,3)+"  - "+_prc+" "+m_name(_prc,4);
			
			_er=shopUpdate(list.child("shop")[0]);
			
			if(_er<=0){
				stg_cl.warn_f(9,"");
			}
			root["wait_cl"].visible=false;
			//trace("\n"+list.child("profile"));
			if((list.child("profile")+"").length>0){
				var str_only:String="<XML_wrapper>"+list.child("profile")+"</XML_wrapper>";
				onlyPlayer(str_only+"",_er);
			}
			if(stg_class.help_on){
				if(stg_class.m_mode==2&&stg_class.help_st==3){
					stg_class.help_cl["lesson1"]["win"]["leave_cl"].set_type(4);
					stg_class.help_cl["lesson1"]["win"]["leave_cl"].sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",4+""]]);
				}
			}
			try{buy_mem("listShop");}catch(er:Error){}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		private function shopUpdate(list:XML):int {
			//trace(list);
			var _er:int=0;
			for(var i:int=0;i<list.child("razdel").length();i++){
				var _num:int=int(list.child("razdel")[i].attribute("num"))-1;
				try{
					if(root["razdel_tx"+_num].text==""){
						root["info_rzd"+_num].i_text=new_line_f(list.child("razdel")[i].attribute("descr"));
						root["razdel_tx"+_num].text=list.child("razdel")[i].attribute("name");
					}
				}catch(er:Error){
					stg_cl.warn_f(5,"В рем-ангаре не предусмотрен "+(_num+1)+"-й раздел.\nРаздел \""+list.child("razdel")[i].attribute("name")+"\" был исключён.",5);
					_er=1;
					continue;
				}
				if(_num==4){
					root["info4_0"].i_text=new_line_f(list.child("razdel")[i].attribute("descr1"));
				}
				for(var j:int=0;j<list.child("razdel")[i].child("punkt").length();j++){
					var _num1:int=int(list.child("razdel")[i].child("punkt")[j].attribute("num"))-1;
					if(_num==3){
						root["info"+_num+"_"+_num1].i_text=new_line_f(list.child("razdel")[i].child("punkt")[j].attribute("descr"));
						root["fuel_win"]["info_fuel"].i_text=new_line_f(list.child("razdel")[i].attribute("descr1"));
						root["fuel_win"]["buy_fuel1"].price_m=int(list.child("razdel")[i].child("punkt")[j].attribute("price_m"));
						root["fuel_win"]["buy_fuel"].party=root["fuel_win"]["buy_fuel"].min_party=int(list.child("razdel")[i].child("punkt")[j].attribute("min_party"));
						root["fuel_win"]["fuel_tx"].text=(root["fuel_win"]["buy_fuel"]["party"])+"/"+fuel_max;
						root["fuel_win"]["fill_cl"].height=((root["fuel_win"]["buy_fuel"]["party"])/fuel_max)*96;
						root["fuel_win"]["buy_fuel"].ID=list.child("razdel")[i].child("punkt")[j].attribute("id");
						continue;
					}
					try{
						if(root["name_tx"+_num+"_"+_num1].text==""||root["buy"+_num+"_"+_num1]["_type"]==1){
							if(_num==0){
								_er=-(_num1+1);
							}
							root["buy"+_num+"_"+_num1].min_lim=int(list.child("razdel")[i].child("punkt")[j].attribute("min_party"));
							root["name_tx"+_num+"_"+_num1].text=list.child("razdel")[i].child("punkt")[j].attribute("name");
						}
					}catch(er:Error){
						if(_er<=0){
							stg_cl.warn_f(5,"В "+(_num+1)+"-м разделе рем-ангара не предусмотрен "+(_num1+1)+"-й пункт.\nПункт \""+list.child("razdel")[i].child("punkt")[j].attribute("name")+"\" был исключён.",5);
							_er=2;
							continue;
						}
					}
					root["buy"+_num+"_"+_num1].party=root["buy"+_num+"_"+_num1].min_lim;
					root["buy"+_num+"_"+_num1]._type=list.child("razdel")[i].child("punkt")[j].attribute("type");
					if(_num!=4){
						if(int(root["buy"+_num+"_"+_num1]._type)!=0||root["info"+_num+"_"+_num1].i_text==null){
							root["info"+_num+"_"+_num1].i_text=new_line_f(list.child("razdel")[i].child("punkt")[j].attribute("descr"));
						}
					}
					root["buy"+_num+"_"+_num1].ID=list.child("razdel")[i].child("punkt")[j].attribute("id");
					root["buy"+_num+"_"+_num1]._hide=int(list.child("razdel")[i].child("punkt")[j].attribute("hidden"));
					if(root["buy"+_num+"_"+_num1]["_hide"]==0){
						root["buy"+_num+"_"+_num1].gotoAndStop("out");
					}else if(root["buy"+_num+"_"+_num1]["_hide"]==3){
						root["buy"+_num+"_"+_num1].visible=false;
						try{
							root["m_m_tx"+_num+"_"+_num1].text="";
						}catch(er:Error){}
						try{
							root["m_z_tx"+_num+"_"+_num1].text="";
						}catch(er:Error){}
					}else{
						root["buy"+_num+"_"+_num1].gotoAndStop("empty");
					}
					try{
						root["num_tx"+_num+"_"+_num1].text=root["buy"+_num+"_"+_num1].min_lim;
					}catch(er:Error){
						
					}
					//if(int(list.child("razdel")[i].child("punkt")[j].attribute("price_m"))!=0){
						try{
							if(int(root["buy"+_num+"_"+_num1]._type)==0){
								if(root["buy"+_num+"_"+_num1]._price_m==null){
									root["buy"+_num+"_"+_num1]._price_m=int(list.child("razdel")[i].child("punkt")[j].attribute("price_m"));
								}
								root["m_m_tx"+_num+"_"+_num1].text=root["buy"+_num+"_"+_num1]._price_m*root["buy"+_num+"_"+_num1].min_lim;
							}else{
								root["buy"+_num+"_"+_num1]._price_m=int(list.child("razdel")[i].child("punkt")[j].attribute("price_m"));
								root["m_m_tx"+_num+"_"+_num1].text=int(list.child("razdel")[i].child("punkt")[j].attribute("price_m"));
							}
							
						}catch(er:Error){
							/*if(_er<=0){
								stg_cl.warn_f(5,"В "+(_num+1)+"-м разделе рем-ангара, в "+(_num1+1)+"-м пункте не предусмотрена продажа за монеты.\nПункт \""+list.child("razdel")[i].child("punkt")[j].attribute("name")+"\" был обработан некорректно.",5);
								_er=3;
								//continue;
							}*/
						}
					//}
					//if(int(list.child("razdel")[i].child("punkt")[j].attribute("price_z"))!=0){
						try{
							if(int(root["buy"+_num+"_"+_num1]._type)==0){
								if(root["buy"+_num+"_"+_num1]._price_z==null){
									root["buy"+_num+"_"+_num1]._price_z=int(list.child("razdel")[i].child("punkt")[j].attribute("price_z"));
								}
								root["m_z_tx"+_num+"_"+_num1].text=root["buy"+_num+"_"+_num1]._price_z*root["buy"+_num+"_"+_num1].min_lim;
							}else{
								root["buy"+_num+"_"+_num1]._price_z=int(list.child("razdel")[i].child("punkt")[j].attribute("price_z"));
								root["m_z_tx"+_num+"_"+_num1].text=int(list.child("razdel")[i].child("punkt")[j].attribute("price_z"));
							}
							
						}catch(er:Error){
							/*if(_er<=0){
								stg_cl.warn_f(5,"В "+(_num+1)+"-м разделе рем-ангара, в "+(_num1+1)+"-м пункте не предусмотрена продажа за знаки.\nПункт \""+list.child("razdel")[i].child("punkt")[j].attribute("name")+"\" был обработан некорректно.",5);
								_er=3;
								//continue;
							}*/
						}
					//}
					//if(int(list.child("razdel")[i].child("punkt")[j].attribute("price_a"))!=0){
						try{
							root["m_a_tx"+_num+"_"+_num1].text=int(list.child("razdel")[i].child("punkt")[j].attribute("price_a"))/**root["buy"+_num+"_"+_num1].min_lim*/;
							root["buy"+_num+"_"+_num1]._price_a=int(list.child("razdel")[i].child("punkt")[j].attribute("price_a"));
						}catch(er:Error){
							/*if(_er<=0){
								stg_cl.warn_f(5,"В "+(_num+1)+"-м разделе рем-ангара, в "+(_num1+1)+"-м пункте не предусмотрены знаки арены.\nПункт \""+list.child("razdel")[i].child("punkt")[j].attribute("name")+"\" был обработан некорректно.",5);
								_er=3;
								//continue;
							}*/
						}
					//}
				}
			}
			return _er;
		}
		
		private function changeHandler(event:Event):void {
    	var _nm:Array=event.currentTarget.name.slice(6,14).split("_");
			//event.currentTarget.text=int(event.currentTarget.text)-int(event.currentTarget.text)%5;
			var _max:int=995;
			var _min:int=1;
			if(_nm[0]==0){
				_max=9995;
				_min=5;
			}
			if(int(event.currentTarget.text)>_max){
				event.currentTarget.text=_max+"";
				event.currentTarget.scrollH=0;
			}else if(int(event.currentTarget.text)<_min){
				event.currentTarget.text=_min+"";
			}
			root["buy"+_nm[0]+"_"+_nm[1]]["party"]=int(event.currentTarget.text);
			root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("out");
			try{
				root["m_m_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["_price_m"]*root["buy"+_nm[0]+"_"+_nm[1]]["party"];
				if((root["buy"+_nm[0]+"_"+_nm[1]]["_hide"]==1)||(int(root["m_m_tx"+_nm[0]+"_"+_nm[1]].text))>money){
					root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("empty");
				}
			}catch(er:Error){}
			try{
				root["m_z_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["_price_z"]*root["buy"+_nm[0]+"_"+_nm[1]]["party"];
				if((root["buy"+_nm[0]+"_"+_nm[1]]["_hide"]==1)||(int(root["m_z_tx"+_nm[0]+"_"+_nm[1]].text))>znaki){
					root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("empty");
				}
			}catch(er:Error){}
    }
		
		private function correctParty(event:FocusEvent):void {
    	var _nm:Array=event.currentTarget.name.slice(6,14).split("_");
			event.currentTarget.text=int(event.currentTarget.text)-int(event.currentTarget.text)%root["buy"+_nm[0]+"_"+_nm[1]]["min_lim"];
			var _max:int=995;
			var _min:int=1;
			if(_nm[0]==0){
				_max=9995;
				_min=5;
			}
			if(int(event.currentTarget.text)>_max){
				event.currentTarget.text=_max+"";
			}else if(int(event.currentTarget.text)<_min){
				event.currentTarget.text=_min+"";
			}
			root["buy"+_nm[0]+"_"+_nm[1]]["party"]=int(event.currentTarget.text);
			root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("out");
			try{
				root["m_m_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["_price_m"]*root["buy"+_nm[0]+"_"+_nm[1]]["party"];
				if((root["buy"+_nm[0]+"_"+_nm[1]]["_hide"]==1)||(int(root["m_m_tx"+_nm[0]+"_"+_nm[1]].text))>money){
					root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("empty");
				}
			}catch(er:Error){}
			try{
				root["m_z_tx"+_nm[0]+"_"+_nm[1]].text=root["buy"+_nm[0]+"_"+_nm[1]]["_price_z"]*root["buy"+_nm[0]+"_"+_nm[1]]["party"];
				if((root["buy"+_nm[0]+"_"+_nm[1]]["_hide"]==1)||(int(root["m_z_tx"+_nm[0]+"_"+_nm[1]].text))>znaki){
					root["buy"+_nm[0]+"_"+_nm[1]].gotoAndStop("empty");
				}
			}catch(er:Error){}
    }
	}
}
















