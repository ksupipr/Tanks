package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.system.Security;
	import flash.system.System;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import flash.utils.escapeMultiByte;
	import flash.utils.unescapeMultiByte;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.xml.XMLNode;
	import flash.filters.GlowFilter;
	import flash.net.*;
	import flash.text.*;
	
	import org.igniterealtime.xiff.collections.ArrayCollection;
	import org.igniterealtime.xiff.im.Roster;
	import org.igniterealtime.xiff.data.im.RosterItemVO;
	import org.igniterealtime.xiff.data.register.RegisterExtension;
	import org.igniterealtime.xiff.vcard.VCard;
	import org.igniterealtime.xiff.data.forms.FormExtension;
	
	import org.igniterealtime.xiff.conference.Room;
	import org.igniterealtime.xiff.conference.RoomOccupant;
	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.events.*;
	import org.igniterealtime.xiff.data.im.RosterItem;
	
	public class myChat extends MovieClip{
		
		private var jab_serv:String="";
		private var group_serv:String="";
		private var jab_port:int=0;
		private var username:String="";
		private var nick:String="";
		private var password:String="";
		private var gr_name:String="";
		private var gr_name1:String="";
		private var gr_name2:String="";
		private var gr_now:String="";
		private var msgs:Array=new Array([],[],[]);
		private var users:Array=new Array([],[],[]);
		public var _last_room:int=-1;
		public var _log:int=0;
		private static var _self:MovieClip;
		public var pochta_win:MovieClip;
		
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
				if(int(idies[0][0])==11){
					if(int(idies[1][0])==1){
						loader.addEventListener(Event.COMPLETE, getAllMess);
					}else if(int(idies[1][0])==2){
						loader.addEventListener(Event.COMPLETE, getNewMess);
					}else if(int(idies[1][0])==3){
						loader.addEventListener(Event.COMPLETE, getOneMess);
					}
				}else if(int(idies[0][0])==2){
					if(int(idies[1][0])==22){
						loader.addEventListener(Event.COMPLETE, usData);
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
			loader.addEventListener(IOErrorEvent.IO_ERROR, onScrError);
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
		
		public function onScrError(event:IOErrorEvent):void{
			//trace("Select+php2: "+event);
			stg_cl.warn_f(4,"Чат");
		}
		
		public function myChat(){
			super();
			stop();
			Security.allowDomain("*");
			_self=this;
			toStart();
			//trace(_space.join(" "));
		}
		
		public var messages:int=0;
		public var mess_ar:Array;
		public var mess_par:Array=new Array();
		
		public function mess_test(){
			var _b:int=0;
			for(var i=0;i<mess_ar.length;i++){
				if(mess_ar[i][3]==0){
					_b++;
				}
			}
			messages=_b;
			if(messages>0){
				light_mess();
			}else{
				stop_mess();
			}
		}
		
		public function getAllMess(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nСписок сообщений.");
				stg_cl.erTestReq(11,1,str);
				return;
			}
			//trace("getAllMess\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			closePochta();
			var _b:int=0;
			pochta_win=new pochta();
			pochta_win["mess_field"].scrollRect=new Rectangle(0, 0, 326, 341);
			var Y:int=0;
			mess_ar=new Array();
			pochta_win["all_tx"].text=list.child("messages")[0].attribute("count");//unreaded
			pochta_win["new_tx"].text=list.child("messages")[0].attribute("unreaded");
			mess_par[0]=int(pochta_win["all_tx"].text);
			mess_par[1]=int(pochta_win["new_tx"].text);
			//trace(list.child("messages")[0].attribute("count")+"   "+list.child("messages")[0].attribute("unreaded")+"   "+mess_par[0]+"   "+mess_par[1]);
			for(var i=0;i<list.child("messages")[0].child("mess").length();i++){
				mess_ar[i]=(new Array());
				mess_ar[i][0]=new mess_clip();
				mess_ar[i][0].name="mess_"+i;
				mess_ar[i][1]=int(list.child("messages")[0].child("mess")[i].attribute("id"));
				mess_ar[i][2]=(list.child("messages")[0].child("mess")[i].attribute("date"));
				mess_ar[i][3]=int(list.child("messages")[0].child("mess")[i].attribute("readed"));
				mess_ar[i][4]=String(list.child("messages")[0].child("mess")[i].attribute("subj"));
				mess_ar[i][5]=int(list.child("messages")[0].child("mess")[i].attribute("type"));
				if(mess_ar[i][4].length>20){
					mess_ar[i][4]=mess_ar[i][4].substr(0,20);
				}
				var _str:String="<font color=\"#003300\" size=\"11\">"+mess_ar[i][2]+"   </font>";
				// максимум 20 символов, и ...
				if(mess_ar[i][3]==0){
					_str+="<b><font color=\"#003300\" size=\"11\">"+mess_ar[i][4]+"</font></b>\n";
					_b++;
				}else{
					_str+="<font color=\"#003300\" size=\"11\">"+mess_ar[i][4]+"</font>\n";
				}
				//_str+="<font color=\"#003300\" size=\"11\">"+mess_ar[i][4]+"</font>\n";
				mess_ar[i][0]["mess_tx"].mouseWheelEnabled=false;
				mess_ar[i][0]["mess_tx"].htmlText=_str;
				mess_ar[i][0]["mess_tx"].height=mess_ar[i][0]["mess_tx"].textHeight+5;
				mess_ar[i][0].graphics.clear();
				mess_ar[i][0].graphics.beginFill(0xFFEBC1,1);
				mess_ar[i][0].graphics.drawRect(0,0,325,mess_ar[i][0].height);
				mess_ar[i][0].x=0;
				mess_ar[i][0].y=Y;
				Y+=mess_ar[i][0].height+2;
				mess_ar[i][0]["read_mess"].ID=mess_ar[i][1];
				mess_ar[i][0]["close_mess"].visible=false;
				pochta_win["mess_field"].addChild(mess_ar[i][0]);
			}
			if(Y>341){
				pochta_win["sc_pochta"].visible=true;
				pochta_win["sc_pochta"]["sc_rect"].graphics.clear();
				pochta_win["sc_pochta"]["sc_rect"].graphics.lineStyle(1,0x9A0700);
				pochta_win["sc_pochta"]["sc_rect"].graphics.beginFill(0xFCE3C5);
				pochta_win["sc_pochta"]["sc_rect"].graphics.drawRect(pochta_win["sc_pochta"]["to_left"].width+2,1,341-(pochta_win["sc_pochta"]["to_left"].width*2+3),pochta_win["sc_pochta"]["to_left"].height-1);
				pochta_win["sc_pochta"]["to_right"].x=pochta_win["sc_pochta"]["sc_rect"].width+pochta_win["sc_pochta"]["to_right"].width*2+3;
			}else{
				pochta_win["sc_pochta"].visible=false;
			}
			pochta_win["mess_field"].W=Y;
			messages=_b;
			if(messages>0){
				light_mess();
			}else{
				stop_mess();
			}
			pochta_win.x=120;
			pochta_win.y=7;
			addChild(pochta_win);
			if(stg_class.warn_cl.stage==null){
				try{
					stg_cl.setChildIndex(this, stg_cl.numChildren-1);
				}catch(er:Error){
					
				}
			}else{
				try{
					stg_cl.setChildIndex(this, stg_cl.getChildIndex(stg_class.warn_cl)-1);
				}catch(er:Error){
					
				}
			}
			drawMessages(0);
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function scrollPochta(event:MouseEvent):void{
			//trace(event.delta);
			var rect:Rectangle=pochta_win["mess_field"].scrollRect;
			var _sc:int=rect.y-event.delta*((pochta_win["mess_field"].W/rect.height)*3);
			//trace(rect.y+"   "+event.delta+"   "+_sc+"   "+pochta_win["mess_field"].width+"   "+pochta_win["mess_field"].scrollRect.width);
			if(_sc<0){
				_sc=0;
			}else if(_sc>pochta_win["mess_field"].W-rect.height){
				_sc=pochta_win["mess_field"].W-rect.height;
			}
			//trace(event.delta+"   "+_sc);
			rect.y=_sc;
			pochta_win["mess_field"].scrollRect=rect;
			pochta_win["sc_pochta"]["sc_mover"].x=(rect.y/pochta_win["mess_field"].W)*((pochta_win["sc_pochta"]["sc_rect"].width-8))+pochta_win["sc_pochta"]["to_left"].width+4;
			//trace("scroll   "+rect.y+"   "+pochta_win["mess_field"].W);
		}
		
		public function scrollMessages(Y:Number,_i:int=0):void{
			var rect:Rectangle=pochta_win["mess_field"].scrollRect;
			rect.y=(((Y-pochta_win["sc_pochta"]["to_left"].width-4)/(pochta_win["sc_pochta"]["sc_rect"].width-pochta_win["sc_pochta"]["sc_mover"].width))*(pochta_win["mess_field"].W-rect.height))*1.035;
			pochta_win["mess_field"].scrollRect=rect;
			/*if(Y==pochta_win["sc_pochta"]["sc_rect"].x+pochta_win["sc_pochta"]["sc_rect"].width){
				trace("move   "+rect.y+"   "+pochta_win["mess_field"].W);
			}*/
		}
		
		public function drawMessages(Y:Number,_i:int=0):void{
			var P:int=0;
			var W:Number=0;
			for(var i=0;i<mess_ar.length;i++){
				mess_ar[i][0].y=P;
				P+=mess_ar[i][0].height+2;
				W+=mess_ar[i][0].height+2;
			}
			pochta_win["mess_field"].W=W;
			//trace(pochta_win["mess_field"].W+"   "+W);
			var _w:int=0;
			try{
				pochta_win["mess_field"].removeEventListener(MouseEvent.MOUSE_WHEEL, scrollPochta);
			}catch(er:Error){}
			var rect:Rectangle=pochta_win["mess_field"].scrollRect;
			if(W>341){
				pochta_win["sc_pochta"].visible=true;
				pochta_win["sc_pochta"]["sc_rect"].graphics.clear();
				pochta_win["sc_pochta"]["sc_rect"].graphics.lineStyle(1,0x9A0700);
				pochta_win["sc_pochta"]["sc_rect"].graphics.beginFill(0xFCE3C5);
				pochta_win["sc_pochta"]["sc_rect"].graphics.drawRect(pochta_win["sc_pochta"]["to_left"].width+2,1,341-(pochta_win["sc_pochta"]["to_left"].width*2+3),pochta_win["sc_pochta"]["to_left"].height-1);
				pochta_win["sc_pochta"]["to_right"].x=pochta_win["sc_pochta"]["sc_rect"].width+pochta_win["sc_pochta"]["to_right"].width*2+3;
				_w=(341/W)*(pochta_win["sc_pochta"]["sc_rect"].width-4);
				if(_w<9){
					_w=9;
				}
				pochta_win["sc_pochta"]["sc_mover"]["sc_fill"].graphics.clear();
				pochta_win["sc_pochta"]["sc_mover"]["sc_fill"].graphics.beginFill(0x990000);
				pochta_win["sc_pochta"]["sc_mover"]["sc_fill"].graphics.drawRect(0,2,_w,11);
				pochta_win["sc_pochta"]["sc_mover"]["sc_zn"].x=Math.round(_w/2)-.5;
				if(_i==0){
					rect.y=0;
					pochta_win["sc_pochta"]["sc_mover"].x=pochta_win["sc_pochta"]["to_left"].width+4;
				}else{
					if(rect.y>pochta_win["mess_field"].W-rect.height){
						rect.y=pochta_win["mess_field"].W-rect.height;
					}
					pochta_win["sc_pochta"]["sc_mover"].x=(rect.y/pochta_win["mess_field"].W)*((pochta_win["sc_pochta"]["sc_rect"].width-8))+pochta_win["sc_pochta"]["to_left"].width+4;
				}
				pochta_win["mess_field"].addEventListener(MouseEvent.MOUSE_WHEEL, scrollPochta);
				/*if(_b==1){
					pochta_win["sc_pochta"]["sc_mover"].x=int(((root["get_tx"].scrollV-1)/(root["get_tx"].maxScrollV-1))*(pochta_win["sc_pochta"]["sc_rect"].width-(pochta_win["sc_pochta"]["sc_mover"].width+3))+pochta_win["sc_pochta"]["to_left"].width+3);
					if(pochta_win["sc_pochta"]["sc_mover"].x<pochta_win["sc_pochta"]["to_left"].width+4){
						pochta_win["sc_pochta"]["sc_mover"].x=pochta_win["sc_pochta"]["to_left"].width+4;
					}else if(pochta_win["sc_pochta"]["sc_mover"].x+pochta_win["sc_pochta"]["sc_mover"].width>pochta_win["sc_pochta"].height-pochta_win["sc_pochta"]["to_left"].width-2){
						pochta_win["sc_pochta"]["sc_mover"].x=pochta_win["sc_pochta"].height-pochta_win["sc_pochta"]["to_left"].width-pochta_win["sc_pochta"]["sc_mover"].width-2;
					}
				}*/
			}else{
				rect.y=0;
				pochta_win["sc_pochta"].visible=false;
			}
			pochta_win["mess_field"].scrollRect=rect;
			mess_test();
		}
		
		public function getNewMess(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nНепрочитанные сообщения.");
				stg_cl.erTestReq(11,2,str);
				return;
			}
			trace("getNewMess\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getOneMess(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nЧтение сообщения.");
				stg_cl.erTestReq(11,3,str);
				return;
			}
			//trace("getOneMess\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			for(var i=0;i<mess_ar.length;i++){
				if(mess_ar[i][0]["read_mess"]["ID"]==int(list.child("messages")[0].child("mess")[0].attribute("id"))){
					try{
						mess_ar[i][0].removeChild(mess_ar[i][0].getChildByName("to_battle"));
					}catch(er:Error){}
					mess_ar[i][3]=int(list.child("messages")[0].child("mess")[0].attribute("readed"));
					mess_ar[i][6]=list.child("messages")[0].child("mess")[0].attribute("text");
					try{
						mess_ar[i][7]=int(list.child("messages")[0].child("mess")[0].child("battle")[0].attribute("id"));
					}catch(er:Error){
						mess_ar[i][7]=-1;
					}
					var _str:String="<font color=\"#003300\" size=\"11\">"+mess_ar[i][2]+"   </font>";
					_str+="<font color=\"#003300\" size=\"11\">"+mess_ar[i][4]+"</font>\n";
					_str+="<font color=\"#003300\" size=\"11\">"+mess_ar[i][6]+"</font>";
					mess_ar[i][0]["mess_tx"].htmlText=_str;
					mess_ar[i][0]["mess_tx"].height=mess_ar[i][0]["mess_tx"].textHeight+5;
					if(mess_ar[i][7]>0){
						var _cl:MovieClip=new mess_battle();
						_cl.name="to_battle";
						_cl.x=140;
						_cl.y=mess_ar[i][0]["mess_tx"].y+mess_ar[i][0]["mess_tx"].height;
						_cl.ID=mess_ar[i][7];
						mess_ar[i][0].addChild(_cl);
					}
					mess_ar[i][0].graphics.clear();
					mess_ar[i][0].graphics.lineStyle(1,0x9A0700);
					mess_ar[i][0].graphics.beginFill(0xFFEBC1,1);
					mess_ar[i][0].graphics.drawRect(0,0,325,mess_ar[i][0].height+4);
					mess_ar[i][0]["close_mess"].ID=mess_ar[i][0]["read_mess"]["ID"];
					mess_ar[i][0]["read_mess"].visible=false;
					mess_ar[i][0]["close_mess"].visible=true;
					drawMessages(-pochta_win["mess_field"].scrollRect.y,1);
					break;
				}
			}
			
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function sendCombats(_s:String,_b:Boolean,_i:int){
			//trace(new XML(_s));
			stg_class.wind["choise_cl"].sendCombats(_s,_b,_i);
		}
		
		public function light_mess(){
			root["pochta_b"].gotoAndPlay("out");
		}
		
		public function stop_mess(){
			root["pochta_b"].gotoAndStop("out");
		}
		
		public function closePochta(){
			try{
				removeChild(pochta_win);
			}catch(er:Error){}
		}
		
		public function openPochta(){
			if(true/*mess_ar==null||mess_ar.length==0||messages>0*/){
				sendRequest(["query","action"],[["id"],["id"]],[["11"],["1"]]);
			}else{
				closePochta();
				var _b:int=0;
				pochta_win=new pochta();
				pochta_win["all_tx"].text=mess_par[0];
				pochta_win["new_tx"].text=mess_par[1];
				pochta_win["mess_field"].scrollRect=new Rectangle(0, 0, 326, 341);
				var Y:int=0;
				for(var i=0;i<mess_ar.length;i++){
					var _str:String="<font color=\"#003300\" size=\"11\">"+mess_ar[i][2]+"   </font>";
					// максимум 20 символов, и ...
					if(mess_ar[i][3]==0){
						_str+="<b><font color=\"#003300\" size=\"11\">"+mess_ar[i][4]+"</font></b>\n";
						_b++;
					}else{
						_str+="<font color=\"#003300\" size=\"11\">"+mess_ar[i][4]+"</font>\n";
					}
					//_str+="<font color=\"#003300\" size=\"11\">"+mess_ar[i][4]+"</font>\n";
					mess_ar[i][0]["mess_tx"].htmlText=_str;
					mess_ar[i][0]["mess_tx"].height=mess_ar[i][0]["mess_tx"].textHeight+5;
					mess_ar[i][0].graphics.clear();
					mess_ar[i][0].graphics.beginFill(0xFFEBC1,1);
					mess_ar[i][0].graphics.drawRect(0,0,325,mess_ar[i][0].height);
					mess_ar[i][0].x=0;
					mess_ar[i][0].y=Y;
					Y+=mess_ar[i][0].height+2;
					mess_ar[i][0]["read_mess"].ID=mess_ar[i][1];
					mess_ar[i][0]["close_mess"].visible=false;
					pochta_win["mess_field"].addChild(mess_ar[i][0]);
				}
				if(Y>341){
					pochta_win["sc_pochta"].visible=true;
					pochta_win["sc_pochta"]["sc_rect"].graphics.clear();
					pochta_win["sc_pochta"]["sc_rect"].graphics.lineStyle(1,0x9A0700);
					pochta_win["sc_pochta"]["sc_rect"].graphics.beginFill(0xFCE3C5);
					pochta_win["sc_pochta"]["sc_rect"].graphics.drawRect(pochta_win["sc_pochta"]["to_left"].width+2,1,341-(pochta_win["sc_pochta"]["to_left"].width*2+3),pochta_win["sc_pochta"]["to_left"].height-1);
					pochta_win["sc_pochta"]["to_right"].x=pochta_win["sc_pochta"]["sc_rect"].width+pochta_win["sc_pochta"]["to_right"].width*2+3;
				}else{
					pochta_win["sc_pochta"].visible=false;
				}
				pochta_win["mess_field"].W=Y;
				messages=_b;
				if(messages>0){
					light_mess();
				}else{
					stop_mess();
				}
				pochta_win.x=120;
				pochta_win.y=7;
				addChild(pochta_win);
				if(stg_class.warn_cl.stage==null){
					try{
						stg_cl.setChildIndex(this, stg_cl.numChildren-1);
					}catch(er:Error){
						
					}
				}else{
					try{
						stg_cl.setChildIndex(this, stg_cl.getChildIndex(stg_class.warn_cl)-1);
					}catch(er:Error){
						
					}
				}
				drawMessages(0);
			}
		}
		
		public function closeMess(_i:int){
			var _id:int=-1;
			for(var i=0;i<mess_ar.length;i++){
				if(mess_ar[i][0]["read_mess"]["ID"]==_i){
					_id=i;
					break;
				}
			}
			if(_id<0){
				return;
			}else{
				try{
					mess_ar[i][0].removeChild(mess_ar[i][0].getChildByName("to_battle"));
				}catch(er:Error){}
				var _str:String="<font color=\"#003300\" size=\"11\">"+mess_ar[i][2]+"   </font>";
				_str+="<font color=\"#003300\" size=\"11\">"+mess_ar[i][4]+"</font>\n";
				mess_ar[i][0]["mess_tx"].htmlText=_str;
				mess_ar[i][0]["mess_tx"].height=mess_ar[i][0]["mess_tx"].textHeight+5;
				mess_ar[i][0].graphics.clear();
				mess_ar[i][0].graphics.beginFill(0xFFEBC1,1);
				mess_ar[i][0].graphics.drawRect(0,0,325,mess_ar[i][0].height);
				mess_ar[i][0]["read_mess"].visible=true;
				mess_ar[i][0]["close_mess"].visible=false;
				drawMessages(-pochta_win["mess_field"].scrollRect.y,1);
			}
		}
		
		public var last_bttl:String="";
		public function repeat_bttl(){
			sendCombats(last_bttl,true,0);
		}
		
		public function openMess(_i:int){
			var _id:int=-1;
			for(var i=0;i<mess_ar.length;i++){
				if(mess_ar[i][0]["read_mess"]["ID"]==_i){
					_id=i;
					break;
				}
			}
			if(_id<0){
				return;
			}else if(mess_ar[i][6]==null){
				sendRequest(["query","action"],[["id"],["id","message"]],[["11"],["3",_i+""]]);
			}else{
				var _str:String="<font color=\"#003300\" size=\"11\">"+mess_ar[i][2]+"   </font>";
				_str+="<font color=\"#003300\" size=\"11\">"+mess_ar[i][4]+"</font>\n";
				_str+="<font color=\"#003300\" size=\"11\">"+mess_ar[i][6]+"</font>";
				mess_ar[i][0]["mess_tx"].htmlText=_str;
				mess_ar[i][0]["mess_tx"].height=mess_ar[i][0]["mess_tx"].textHeight+5;
				if(mess_ar[i][7]>0){
					var _cl:MovieClip=new mess_battle();
					_cl.name="to_battle";
					_cl.x=140;
					_cl.y=mess_ar[i][0]["mess_tx"].y+mess_ar[i][0]["mess_tx"].height;
					_cl.ID=mess_ar[i][7];
					mess_ar[i][0].addChild(_cl);
				}
				mess_ar[i][0].graphics.clear();
				mess_ar[i][0].graphics.lineStyle(1,0x9A0700);
				mess_ar[i][0].graphics.beginFill(0xFFEBC1,1);
				mess_ar[i][0].graphics.drawRect(0,0,325,mess_ar[i][0].height+4);
				mess_ar[i][0]["close_mess"].ID=mess_ar[i][0]["read_mess"]["ID"];
				mess_ar[i][0]["read_mess"].visible=false;
				mess_ar[i][0]["close_mess"].visible=true;
				drawMessages(-pochta_win["mess_field"].scrollRect.y,1);
			}
		}
		
		private var _cens:Array;
		private var _space:Array=["\\\!","\\\~","\\\`","\\\@","\\\#","\\\$","\\\%","\\\^","\\\&","\\\*","\\\(","\\\)","\\\_","\\\+","\\\=","\\\|","\\\\","\\\/","\\\"","\\\.","\\\,","\\\'","\\\№","\\\;","\\\:","\\\?","\\\[","\\\]","\\\{","\\\}"," "];
		private var _rst_n:String="";
		private var _rand_cens:Array;
		private var ptrn:RegExp;
		private var check_s:Object;
		
		private function string_test(_str:String):String{
			var _s:String="";
			for(var i:int=0;i<_str.length;i++){
				//trace(_str.charAt(i)+"   "+_rst_n.indexOf(_str.charAt(i)));
				_s+=((_rst_n.indexOf(_str.charAt(i))>-1)?(_str.charAt(i)):(""));
			}
			//trace(_str);
			//trace(_s);
			return _s;
		}
		
		public function rand_str():String{
			var _str:String=""
			var _rand:int=Math.random()*9+3;
			while(_str.length<_rand){
				_str+=_rand_cens[int(Math.random()*_rand_cens.length)];
			}
			return _str;
		}
		
		private function cens_test(_str:String):String{
			//trace(_str);
			//addMess(gr_now,"<b><font color=\"#333333\" size=\"10\">Исходный текст: </font></b>"+_str+"\n");
			var _into:String=" "+_str+" ";
			var _s:String=_into.toLowerCase();
			for(var i:int=0;i<_cens.length;i++){
				var _check:String=_cens[i];
				//trace(_check);
				if(_check.charAt(0)=="*"&&_check.charAt(_check.length-1)=="*"){
					for(var j:int=0;j<_space.length;j++){
						for(var n:int=0;n<_space.length;n++){
							//trace(_s+"   "+(_space[j]+""+_check.substr(1,_check.length-2)+""+_space[n]));
							ptrn=new RegExp(_space[j]+""+_check.substr(1,_check.length-2)+""+_space[n]);
							var _obj:Object = ptrn.exec(_s);
							while(_obj!=null){
								_into=_into.replace(_into.substr(_obj.index,_obj[0].length),_obj[0].charAt(0)+rand_str()+_obj[0].charAt(_obj[0].length-1));
								_s=_into.toLowerCase();
								_obj=ptrn.exec(_s);
							}
						}
					}
				}else if(_check.charAt(0)=="*"){
					for(var j:int=0;j<_space.length;j++){
						//trace(_s+"   "+(_space[j]+""+_check.substr(1,_check.length-1)));
						ptrn=new RegExp(_space[j]+""+_check.substr(1,_check.length-1));
						var _obj:Object = ptrn.exec(_s);
						while(_obj!=null){
							_into=_into.replace(_into.substr(_obj.index,_obj[0].length),_obj[0].charAt(0)+rand_str());
							_s=_into.toLowerCase();
							_obj=ptrn.exec(_s);
						}
					}
				}else if(_check.charAt(_check.length-1)=="*"){
					for(var j:int=0;j<_space.length;j++){
						ptrn=new RegExp(_check.substr(0,_check.length-1)+_space[j]);
						var _obj:Object = ptrn.exec(_s);
						while(_obj!=null){
							_into=_into.replace(_into.substr(_obj.index,_obj[0].length),rand_str()+_obj[0].charAt(_obj[0].length-1));
							_s=_into.toLowerCase();
							_obj=ptrn.exec(_s);
						}
					}
				}else{
					ptrn=new RegExp(_cens[i]);
					var _obj:Object = ptrn.exec(_s);
					while(_obj!=null){
						_into=_into.replace(_into.substr(_obj.index,_obj[0].length),rand_str());
						_s=_into.toLowerCase();
						_obj=ptrn.exec(_s);
					}
				}
			}
			//trace(_into);
			//addMess(gr_now,"<b><font color=\"#993333\" size=\"10\">Коррекция >>>: </font></b>"+_into+"\n");
			return _into;
		}
		
		public var us_list:MovieClip;
		public var avas:MovieClip;
		public var us_win:MovieClip;
		private var ban_win:MovieClip;
		
		private function toStart():void{
			var _cens_str:String="ДЕБИЛ,ДиБИЛ,ПИЗД,ПЕЗД,pizd,pisd,ПЁЗД,pezd,pesd,БЛЯД,БЛЕЯ,БЛЕА,blat,blad,blya,blea,blia,6lya,6lea,6lia,*6ля*,*мля*,*бля*,БЛЯТ,dibil,debil,di6il,de6il,";
			_cens_str+="ХУЙ,xui,xyi,xuy,hui,hyi,huy,xue,xye,hue,hye,xua,xya,hua,hya,huй,hyй,huи,hyи,xuй,xyй,xuи,xyи,huя,hyя,xuя,xyя,huе,hyе,xuе,xyе,huю,";
			_cens_str+="hyю,xuю,xyю,huё,hyё,xuё,xyё,ХУЁ,ХУЯ,ХУИ,ХУЮ,ХУЕ,ВЗЪЁБ,ВЫЕБ,ВЫЁБ,eban,e6an,ЕБАН,ЁБАН,ebnu,e6nu,ЕБНУ,ЁБНУ,ebal,e6al,ЕБАЛ,ЁБАЛ,*сука,*суки,*суку,сцук,цука,цуко,";
			_cens_str+="ebar,e6ar,ЁБАР,ЁБЫР,ebat,e6at,ЕБАТ,ЁБАТ,ebli,e6li,ЕБЛИ,ЁБЛИ,eblo,e6lo,ЕБЛО,ЁБЛО,ebla,e6la,ЕБЛА,ЁБЛА,ЕБЛЫСЬ,ebly,e6ly,ЁБЛЯ,ЕБЛЯ,*суке,*сучь,*сучо,*сучё,*суче,";
			_cens_str+="ЁБС,zaeb,zae6,ЗАЁБ,ЗАЕБ,ebuch,e6uch,ЕБУЧ,ЁБУЧ,ebuh,e6uh,ЕБУХ,ЁБУХ,ebut,e6ut,ebyt,e6yt,ЕБУТ,ЁБУТ,ebun,e6un,ebyn,e6yn,ЕБУН,ЁБУН,zalyp,suk,suc,";
			_cens_str+="ЕБЕНЬ,ЁБЕНЬ,ebi,e6i,ЕБИ,ebai,e6ai,ebay,e6ay,ЕБАЙ,ЁБАЙ,ЁБЫВ,ЕБЫВ,soses,sases,СОСЁШЬ,САСЁШЬ,СОСЕШЬ,САСЕШЬ,pidr,pedr,пидр,педр,залуп,zalup,";
			_cens_str+="sosi,sasi,СОСИ,САСИ,sosut,sasut,sosyt,sasyt,СОСУТ,САСУТ,pidor,pidar,ПИДАР,ПИДОР,pedik,pedic,ПЕДИК,gandon,gondon,ГАНДОН,ГОНДОН,дроч,droc,";
			_cens_str+="МУДАК,МУДИЛ,poime,ПОИМЕ,*loh,*lox*,*ЛОХ*,*ЛОХИ,*ЛОШИДЗ,debil,de6il,ОЕБ,ОЁБ,АЕБ,АЁБ,УЕБ,УЁБ,oeb,oe6,оёб,оеб,оё6,ое6,aeb,ae6,ueb,ue6,yeb,ye6";
			_cens=_cens_str.toLowerCase().split(",");
			//trace(_cens);
			_rst_n="ёйцукенгшщзхъфывапролджэячсмитьбю";
			_rst_n+="ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ";
			_rst_n+="1234567890+*=(),.?!:; ";
			_rst_n+="|_%$#{}[]";
			_rst_n+="qwertyuiopasdfghjklzxcvbnm";
			_rst_n+="QWERTYUIOPASDFGHJKLZXCVBNM";
			_rst_n+="♔♕♖♗♘♙♙♚♛♜♝♞♟";
			_rst_n+="♈♉♊♋♌♍♎♏♐♑♒♓";
			_rst_n+="♩♪♫♬♭♮♯✆☎☏✈✐✑✒✂✉";
			_rst_n+="★✩✪✫✬✭✮✯✰☂☉♂♀";
			_rst_n+="☚☛☜☝☞☟✌☯☮✇☭☄☢☸☠";
			_rand_cens=("@,#,$,%,^,&,*,(,),_,-,+,=,|,~,`,!,№,;,:,?,[,],{,}").split(",");
			root["send_tx"].restrict="1";
			ban_win=new prive();
			avas=new ava_clips();
			for(var i:int=0;i<20;i++){
				try{
					avas["ava"+i].addEventListener(MouseEvent.MOUSE_OVER, m_over);
					avas["ava"+i].addEventListener(MouseEvent.MOUSE_OUT, m_out);
					//root["avas"]["ava"+i].addEventListener(MouseEvent.MOUSE_DOWN, m_press);
					//root["avas"]["ava"+i].addEventListener(MouseEvent.MOUSE_UP, m_release);
				}catch(er:Error){
					
				}
			}
			avas.x=0;
			avas.y=394;
			avaReset();
			_minimize();
			root["sc_mess"].visible=false;
			root["priv_tx"].visible=false;
			root["rootGroup"].gotoAndStop("out");
			root["reid"].gotoAndStop("out");
			root["polk"].gotoAndStop("out");
			root["rootGroup"].name_gr=root["reid"].name_gr=root["polk"].name_gr="";
			root["get_tx"].selectable=false;
			root["get_tx"].background=root["send_tx"].background=root["priv_tx"].background=ban_win["mess_tx"].background=ban_win["ban_tx"].background=true;
			root["get_tx"].border=root["send_tx"].border=root["priv_tx"].border=ban_win["mess_tx"].border=ban_win["ban_tx"].border=true;
			root["get_tx"].borderColor=root["send_tx"].borderColor=root["priv_tx"].borderColor=ban_win["mess_tx"].borderColor=ban_win["ban_tx"].borderColor=0x9A0700;
			root["get_tx"].backgroundColor=root["send_tx"].backgroundColor=root["priv_tx"].backgroundColor=ban_win["mess_tx"].backgroundColor=ban_win["ban_tx"].backgroundColor=0xFCE3C5;
			root["get_tx"].addEventListener(TextEvent.LINK, usClick);
			root["rootGroup"].setParCl(this);
			addEventListener(KeyboardEvent.KEY_DOWN, keyPr);
			//addEventListener(KeyboardEvent.KEY_UP, keyRl);
			root["priv_us"].gotoAndStop("empty");
			us_list=new users_win();
			for(var i:int=0;i<25;i++){
				us_list["us"+i]["name_tx"].addEventListener(TextEvent.LINK, usClick);
				us_list["us"+i]["name_tx"].addEventListener(MouseEvent.MOUSE_OVER, usOver);
				us_list["us"+i]["name_tx"].addEventListener(MouseEvent.MOUSE_OUT, usOut);
			}
			tmUser=new Timer(5000);
			tmUser.addEventListener(TimerEvent.TIMER, checkUsers);
			tmMess=new Timer(3000,1);
			tmMess.addEventListener(TimerEvent.TIMER_COMPLETE, reDraw);
			tmLast=new Timer(20000,1);
			tmLast.addEventListener(TimerEvent.TIMER_COMPLETE, clearLast);
			prLast=new Timer(20000,1);
			prLast.addEventListener(TimerEvent.TIMER_COMPLETE, clearPrLast);
			tmWait=new Timer(2000,1);
			tmAlive=new Timer(30000);
			tmAlive.addEventListener(TimerEvent.TIMER, sendAlive);
			tmCache=new Timer(5*60*1000);
			tmCache.addEventListener(TimerEvent.TIMER, clearCards);
			tmCache.start();
			setVkl(0);
			//tmUser.start();
			//onCreationComplete();
			//chat_exit();
			us_win=new new_win();
		}
		
		public function clearCards(event:TimerEvent){
			VCard.clearCache();
		}
		
		public function sendAlive(event:TimerEvent){
			try{
				connection.sendKeepAlive();
			}catch(er:Error){}
		}
		
		public function show_ban_win(){
			if(stg_class.prnt_cl.br>0){
				if(root["priv_tx"].visible){
					ban_win.x=3;
					ban_win.y=455;
					ban_win["name_tx"].text=root["priv_tx"].text;
					ban_win["ban_tx"].text=60+"";
					ban_win["mess_tx"].text="Оскорбление других участников чата.";
					addChild(ban_win);
				}
			}
		}
		
		public function hide_ban_win(){
			try{
				removeChild(ban_win);
			}catch(er:Error){}
		}
		
		public function send_ban_mess(){
			try{call_us.close()}catch(er:Error){}
			if(stg_class.prnt_cl.br>0){
				var rqs:URLRequest=new URLRequest(serv_url);
 				rqs.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader(rqs);
 				var strXML:String="<query id=\"2\"><action id=\""+15+"\" ban_reason=\""+ban_win["mess_tx"].text+"\" user_id=\""+_login(priv_n)+"\" time=\""+ban_win["ban_tx"].text+"\"></action></query>";
 				var list:XML=new XML(strXML);
				var variables:URLVariables = new URLVariables();
				variables.query = list;
				variables.send = "send";
				rqs.data = variables;
				//trace("ban\n"+list);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
 				loader.addEventListener(Event.COMPLETE, ban);
 				loader.load(rqs);
			}
			hide_ban_win();
		}
		
		public function ban(event:Event):void{
			var str:String=event.target.data+"";
			trace("ban="+str);
			//stg_cl.errTest(str,int(300));
			try{
				var list:XML=new XML(str);
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nБан.");
				stg_cl.erTestReq(7,2,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else{
					addMess(gr_now,"<b><font color=\"#ff0000\" size=\"10\">Игрок забанен.</font></b> \n");
				}
			}catch(er:Error){
				
			}
			//stg_cl.warn_f(9,"");
			//trace("conferm1=\n"+list);
		}
		
		public function showAvas(){
			try{
				tmCache.reset();
			}catch(er:Error){}
			closePochta();
			hideList();
			hide_ban_win();
			_minimize();
			outRooms();
			VCard.clearCache();
			try{
				removeChild(avas);
			}catch(er:Error){}
			addChild(avas);
			root["get_tx"].visible=root["send_tx"].visible=root["priv_tx"].visible=false;
			root["get_tx"].text=root["send_tx"].text=root["priv_tx"].text="";
		}
		
		public function hideAvas(){
			VCard.clearCache();
			try{
				removeChild(avas);
			}catch(er:Error){}
			try{
				tmCache.reset();
			}catch(er:Error){}
			tmCache.start();
			avaReset();
			root["get_tx"].visible=root["send_tx"].visible=true;
			_minimize();
			hide_ban_win();
			unPriv();
		}
		
		public function setRooms(){
			rootSet(gr_name);
			reidSet(gr_name1);
			polkSet(gr_name2);
		}
		
		public function outRooms(){
			room_exit(0,null,0,1);
			room_exit(1,null,0,1);
			room_exit(2,null,0,1);
		}
		
		public function m_over(event:MouseEvent){
			showInfo(dscr[int(event.currentTarget.name.slice(3,4))],event.currentTarget);
			//showInfo("Text",event.currentTarget);
		}
		
		public function m_out(event:MouseEvent){
			hideInfo();
		}
		
		public var dscr:Array=new Array(10);
		public var pict:Array=new Array();
		
		public function avaReset(){
			//trace(pict.length);
			for(var i:int=0;i<10;i++){
				for(var j:int=0;j<10;j++){
					try{
						avas["ava"+i].removeChild(pict[j]);
						//trace(pict[i]+"   "+i);
					}catch(er:Error){
						//trace("er "+i);
					}
				}
				avas["ava"+i]["name_tx"].text="";
				avas["ava"+i]["lenta_cl"].visible=false;
				avas["ava"+i]["xp_bar"]["fill"].width=0;
				for(var j:int=0;j<3;j++){
					avas["ava"+i]["l"+j].gotoAndStop(2);
				}
				//avas["ava"+i].visible=false;
			}
			dscr=new Array(10);
			pict=new Array();
		}
		
		public function showInfo(info:String,cl:Object){
			if(info==null){
				return;
			}
			if(info==""){
				return;
			}
			root["info_tx"].selectable=false;
			root["info_tx"].multiline=true;
			root["info_tx"].autoSize=TextFieldAutoSize.LEFT;
			root["info_tx"].wordWrap=false;
			root["info_tx"].textColor=0xF0DB7D;
			root["info_tx"].text=info;
			root["info_tx"].x=cl.x+cl.parent.x;
			root["info_tx"].y=cl.y-root["info_tx"].height-cl.height/2+cl.parent.y+cl.parent.parent.y;
			if(root["info_tx"].y<0){
				root["info_tx"].y=0;
				root["info_tx"].x=cl.x+cl.width+10;
			}
			if(root["info_tx"].x>cl.parent.width-root["info_tx"].width-10){
				root["info_tx"].x=cl.parent.width-root["info_tx"].width-10;
			}
			var info_w:int=root["info_tx"].width;
			var info_h:int=root["info_tx"].height;
			var info_rw:int=10;
			var info_rh:int=10;
			root["clip_cl"].graphics.lineStyle(1, 0x000000, 1, true);
			root["clip_cl"].graphics.beginFill(0x990700,1);
			root["clip_cl"].graphics.drawRoundRect(root["info_tx"].x-3, root["info_tx"].y, info_w+10, info_h+2, info_rw, info_rh);
			//root.parent.setChildIndex(root,root.parent.numChildren-1);
			setChildIndex(root["clip_cl"],numChildren-1);
			setChildIndex(root["info_tx"],numChildren-1);
			root["info_tx"].visible=true;
		}
		
		public function hideInfo(){
			root["info_tx"].visible=false;
			root["clip_cl"].graphics.clear();
		}
		
		private function setVkl(_i:int){
			//trace(_i);
			var _ar:Array=["rootGroup","reid","polk"]
			for(var i:int=0;i<3;i++){
				if(_i!=i){
					if(root[_ar[i]]["name_gr"]!=""){
						root[_ar[i]].gotoAndStop("over");
					}else{
						root[_ar[i]].gotoAndStop("out");
					}
				}else{
					root[_ar[i]].gotoAndStop("empty");
				}
			}
		}
		
		public var gl_f:GlowFilter=new GlowFilter(0xffffff, 1.0, 32, 32, 1, 1, false, false);
		public var gl_f_in:GlowFilter=new GlowFilter(0xff0000, 1.0, 16, 16, 1, 1, true, false);
		
		private function usOver(event:MouseEvent):void{
			event.currentTarget.textColor=0x00FF00;
		}
		
		private function usOut(event:MouseEvent):void{
			event.currentTarget.textColor=0x003300;
		}
		
		private function focus_in(event:FocusEvent):void{
			event.currentTarget.filters=[gl_f_in];
		}
		
		private function focus_out(event:FocusEvent):void{
			event.currentTarget.filters=null;
		}
		
		private var tmUser:Timer;
		private var tmMess:Timer;
		private var tmLast:Timer;
		private var prLast:Timer;
		private var tmWait:Timer;
		private var tmCache:Timer;
		
		public var _ctrl:int=0;
		
		private function keyPr(event:KeyboardEvent):void{
			if(event.keyCode==Keyboard.ENTER){
				//send_ban_mess();
				if(stage.focus==root["send_tx"]){
					sendMess();
				}/*else if(stage.focus==root["send_tx"]){
					try{room.sendPrivateMessage(nickname, text);}catch(er:Error){}
				}*/
			}
		}
		
		private function keyRl(event:KeyboardEvent):void{
			if(event.keyCode==Keyboard.CONTROL){
				_ctrl=0;
			}
		}
		
		public function _trim(str:String):String {
      var _buff:String="";
			var _mess:String="";
			for(var i:int=0;i<str.length;i++){
				if(_buff.length==0){
					_buff+=str.charAt(i);
					_mess+=str.charAt(i);
				}else if(_buff.charAt(_buff.length-1)==str.charAt(i)){
					if(_buff.length>1){
						//str
					}else{
						_buff+=str.charAt(i);
						_mess+=str.charAt(i);
					}
				}else{
					_buff="";
					_mess+=str.charAt(i);
				}
			}
			for (var i = 0; _mess.charCodeAt(i) < 33; i++);
      for (var j = _mess.length-1; _mess.charCodeAt(j) < 33; j--);
      return _mess.substr(i, j + 1);
    }
		
		public function clearLast(event:TimerEvent) {
			_l_mess=new Array();
		}
		
		public function clearPrLast(event:TimerEvent) {
			_l_pr_mess=new Array();
		}
		
		public function add_last(_str:String) {
			_l_mess.push(_str);
			if(_l_mess.length>3){
				_l_mess.shift();
			}
			try{
				tmLast.reset();
			}catch(er:Error){}
			tmLast.start();
		}
		
		public function add_pr_last(_str:String) {
			_l_pr_mess.push(_str);
			if(_l_pr_mess.length>3){
				_l_pr_mess.shift();
			}
			try{
				prLast.reset();
			}catch(er:Error){}
			prLast.start();
		}
		
		public function test_last(_str:String,_ar:Array):String {
			for(var i:int=0;i<_ar.length;i++){
				if(_str==_ar[i]){
					return "";
				}else{
					var _n:int=0;
					var _c:int=0;
					if(_str.length>_ar[i].length){
						for(var j:int=0;j<_str.length;j++){
							if(_str.charAt(j)==_ar[i].charAt(_c)){
								_n++;
								_c++;
							}
						}
						//trace(_str+"\n"+_ar[i]);
						//trace("a   "+(_n/_str.length)+"\n");
						if(_n/_str.length>.8){
							return "";
						}
					}else{
						for(var j:int=0;j<_ar[i].length;j++){
							if(_str.charAt(_c)==_ar[i].charAt(j)){
								_n++;
								_c++;
							}
						}
						//trace(_str+"\n"+_ar[i]);
						//trace("b   "+(_n/_ar[i].length)+"\n");
						if(_n/_ar[i].length>.8){
							return "";
						}
					}
				}
			}
			return _str;
		}
		
		private var _l_mess:Array=new Array();
		private var _l_pr_mess:Array=new Array();
		public var ban_time:int=0;
		public var ban_text:String="";
		public var banned:Boolean=true;
		
		public function show_ban_mess():void{
			if(ban_text!=""){
				addMess(gr_now,"<b><font color=\"#ff0000\" size=\"10\">"+ban_text+"</font></b> \n");
			}
		}
		
		public function sendMess():void{
			//trace(gr_now+"   "+gr_name+"   "+gr_name1+"   "+gr_name2);
			if(banned&&gr_now==gr_name){
				show_ban_mess();
				return;
			}else if(tmWait.running){
				return;
			}else{
				tmWait.start();
			}
			
			var _str:String=_trim(root["send_tx"].text);
			if(_str==""){
				root["send_tx"].text="";
				return;
			}
			//add_last(_str);
			//_str=cens_test(_str);
			var _room:Room;
			var i:int=0;
			//trace("mess   "+test_last(_str,_l_mess)+" <> "+cens_test(_str));
			if(!root["priv_tx"].visible){
				if(test_last(_str,_l_mess)==""){
					root["send_tx"].text="";
					addMess(gr_now,"<b><font color=\"#ff0000\" size=\"10\">Постарайтесь не писать одинаковых сообщений.</font></b> \n");
					return;
				}
				if(gr_now==gr_name){
					_room=room;
				}else if(gr_now==gr_name1){
					_room=room1;
				}else if(gr_now==gr_name2){
					_room=room2;
				}
				//trace("room   "+_room+" <> "+_room.isActive+" <> "+_room.roomJID+" <> "+gr_now);
				if(_room!=null){
					add_last(_str);
					_str=cens_test(_str);
					try{
						_room.isActive=true;
						_room.sendMessage(_str);
						//trace("send   "+_str);
					}catch(er:Error){
						//trace("err   "+er);
					}
				}
				i=-1;
			}else{
				if(test_last(_str,_l_pr_mess)==""){
					root["send_tx"].text="";
					addMess(gr_now,"<b><font color=\"#ff0000\" size=\"10\">Постарайтесь не писать одинаковых сообщений.</font></b> \n");
					return;
				}
				var _ar:Array=priv_n.split("♣");
				var _i:int=2;
				var _where:String="";
				if(_ar[0]!="toRoom"){
					if(gr_now==gr_name){
						_room=room;
					}else if(gr_now==gr_name1){
						_room=room1;
					}else if(gr_now==gr_name2){
						_room=room2;
					}
				}else{
					_i=4;
					if(_ar[1]==gr_name){
						_room=room;
						_where="(Общая комната)";
					}else if(_ar[1]==gr_name1){
						_room=room1;
						_where="(Комната группы)";
					}else if(_ar[1]==gr_name2){
						_room=room2;
						_where="(Полковая комната)";
					}
				}
				var pr_v:String=(_ar.slice(_i-2)).join("♣");
				if(_room!=null&&_room.isActive){
					for(i=0;i<_room.source.length;i++){
						if(_room.source[i].displayName==pr_v){
							add_pr_last(_str);
							_str=cens_test(_str);
							try{
								_room.isActive=true;
								_room.sendPrivateMessage(pr_v,_str);
								var _nick:String=(_room.nickname);
								addMess(_room.roomName,"<font color=\"#333333\" size=\"10\">"+root["time_cl"]["time_tx"].text+"</font>  <b><font color=\"#62B902\" size=\"12\"><a href=\"event:"+pr_v+"\">Для "+nickNames(pr_v)+"</a>:</font></b>","<b><font color=\"#003300\" size=\"12\"> "+_str+"</font></b>\n",_nick,1);
								if(gr_now!=_room.roomName){
									addMess(gr_now,"<font color=\"#333333\" size=\"10\">"+root["time_cl"]["time_tx"].text+"</font>  <b><font color=\"#62B902\" size=\"12\"><a href=\"event:"+"toRoom♣"+_room.roomName+"♣"+pr_v+"\">Для "+nickNames(pr_v)+""+_where+"</a>:</font></b>","<b><font color=\"#003300\" size=\"12\"> "+_str+"</font></b>\n",_nick,1);
								}
							}catch(er:Error){}
							i=-1;
							break;
						}
					}
					if(i!=-1){
						addMess(gr_now,"<b><font color=\"#ff0000\" size=\"10\">Не удалось отправить сообщение, возможно участник покинул комнату.</font></b> \n");
					}
				}
			}
			if(i==-1){
				root["send_tx"].text="";
			}
		}
		
		private var connection:XMPPConnection;
		private var room:Room;
		private var room1:Room;
		private var room2:Room;
		
		private var _users:ArrayCollection;
		
		public function setLog(_i:int):void{
			if(_i==1){
				_log=1;
				try{
					connection.removeEventListener(IncomingDataEvent.INCOMING_DATA  , inDate);
					connection.removeEventListener(OutgoingDataEvent.OUTGOING_DATA , outDate);
				}catch(er:Error){}
				try{
					connection.addEventListener(IncomingDataEvent.INCOMING_DATA  , inDate);
					connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA , outDate);
				}catch(er:Error){}
			}else{
				_log=0;
				try{
					connection.removeEventListener(IncomingDataEvent.INCOMING_DATA  , inDate);
					connection.removeEventListener(OutgoingDataEvent.OUTGOING_DATA , outDate);
				}catch(er:Error){}
			}
		}
		
		public function urlInit(url:String,cl:MovieClip){
			serv_url=url;
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public var serv_url:String="";
		public var stg_cl:MovieClip;
		public var stg_class:Class;
		
		private function getUserData(){
			_log=stg_class.prnt_cl.chat_log;
			jab_serv=stg_class.prnt_cl.jabb;
			group_serv=stg_class.prnt_cl.conf;
			jab_port=stg_class.prnt_cl.jport;
			username=stg_class.prnt_cl.jlogin;
			password=stg_class.prnt_cl.jpass;
			nick=stg_cl["v_name"];
			nick=string_test(nick);
			nick=nick.split(" ").join("♦");
			gr_now=stg_class.prnt_cl.root_gr;
			_rst_n+="✖†√☻☺♠♣♥♦☣";
			root["send_tx"].restrict=_rst_n+"/№\\\-\"";
			_rst_n+="ЀѐЂђЃѓЄєЅѕІіЇїЈјЋћЍѝЎўЏЏґ";
			_rst_n+="-";
			/*trace(jab_serv);
			trace(group_serv);
			trace(jab_port);
			trace(username);
			trace(password);
			trace(nick);*/
		}
		
		public function onCreationComplete():void{
			if(connection!=null){
				return;
			}
			stg_class.prnt_cl.output("try connect to "+jab_serv+"\n",1);
			root["get_tx"].text="Подключение...";
			getUserData();
			//Security.loadPolicyFile("xmlsocket://"+jab_serv+":"+80);
			Security.loadPolicyFile("http://"+jab_serv+"/crossdomain.xml");
			
			connection = new XMPPConnection();
			username=username;
			//trace(username);
			connection.username = username;
			connection.password = password;
			
			connection.useAnonymousLogin=false;
			connection.server = jab_serv;
			//connection.domain = jab_serv;
			//connection.resource = "flashPlayer";
			connection.port = jab_port;
			//trace(username+"   "+password+"   "+jab_serv+"   "+gr_name);
			connection.addEventListener(LoginEvent.LOGIN, onLogin);
			connection.addEventListener(XIFFErrorEvent.XIFF_ERROR, onError);
			connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, isConnect);
			connection.addEventListener(DisconnectionEvent.DISCONNECT, disConnect);
			//connection.addEventListener(MessageEvent.MESSAGE , getMess);
			
			//connection.addEventListener(ChangePasswordSuccessEvent.PASSWORD_SUCCESS  , changePass);
			//connection.addEventListener(PresenceEvent.PRESENCE , onPresence);
			
			if(_log!=0){
				try{
					connection.removeEventListener(IncomingDataEvent.INCOMING_DATA  , inDate);
					connection.removeEventListener(OutgoingDataEvent.OUTGOING_DATA , outDate);
				}catch(er:Error){}
				try{
					connection.addEventListener(IncomingDataEvent.INCOMING_DATA  , inDate);
					connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA , outDate);
				}catch(er:Error){}
			}else{
				connection.addEventListener(IncomingDataEvent.INCOMING_DATA  , connectLogs);
				connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA , connectLogs);
			}
			
			connection.addEventListener(RegistrationSuccessEvent.REGISTRATION_SUCCESS , regDone);
			connection.addEventListener(RegistrationFieldsEvent.REG_FIELDS, onRegistrationFields);
			f_repeate={_obj:connection,_fnc:connection.connect,_prm:[],_count:0};
			conTime();
			connection.connect(0);
		}
		
		public function connectLogs(event:*){
			if(event is IncomingDataEvent){
				stg_class.prnt_cl.output("<font color=\"#0033FF\" size=\"12\">\nChat IN_Date\n"+unHtml(event.data.toString())+"</font>\n");
			}else if(event is OutgoingDataEvent){
				stg_class.prnt_cl.output("<font color=\"#0033FF\" size=\"12\">\nChat OUT_Date\n"+unHtml(event.data.toString())+"</font>\n");
			}
		}
		
		public static function secureEr(){
			if(_con<3){
				_con++;
				_self.connection.disconnect();
				conTime();
				_self.connection.connect(0);
			}else{
				conTmReset();
				_self["get_tx"].appendText("Ошибка: не удалось получить файл политики безопасности.\n");
			}
		}
		
		public static function ioEr(){
			if(_con<3){
				_con++;
				_self.connection.disconnect();
				conTime();
				_self.connection.connect(0);
			}else{
				conTmReset();
				_self["get_tx"].appendText("Ошибка: сервер недоступен.\n");
			}
		}
		
		public static function conTmReset(){
			try{
				_conTm.stop();
			}catch(er:Error){}
			try{
				_conTm.removeEventListener(TimerEvent.TIMER_COMPLETE, longWait);
			}catch(er:Error){}
		}
		
		public static function conTime(){
			conTmReset();
			_conTm=new Timer(8000,1);
			_conTm.addEventListener(TimerEvent.TIMER_COMPLETE, longWait);
		}
		
		public static function longWait(event:TimerEvent){
			if(_con<3){
				_con++;
				_self.connection.disconnect();
				conTime();
				_self.connection.connect(0);
			}else{
				conTmReset();
				_self["get_tx"].appendText("Ошибка: превышено время ожидания.\n");
			}
		}
		
		private static var _conTm:Timer;
		private static var _con:int=0;
		
		private function onLogin(e:LoginEvent):void{
			reg_st=0;
			addMess(gr_name,"<b>"+"<font color=\"#007700\" size=\"10\">"+"Логин и пароль приняты"+"</font>"+"</b> "+"\n");
			try{
				connection.removeEventListener(IncomingDataEvent.INCOMING_DATA  , connectLogs);
				connection.removeEventListener(OutgoingDataEvent.OUTGOING_DATA , connectLogs);
			}catch(er:Error){}
			var _fnc:Array=[rootSet,reidSet,polkSet];
			for(var i:int=0;i<3;i++){
				if(_join[i]!=null){
					_fnc[i].apply(this,[_join[i]]);
				}
			}
			_join=[];
		}
		
		public function room_exit(_i:int,_str:String=null,_mod:int=0,_all:int=0):void{
			//trace("exit   "+_i+"   "+_mod+"   "+_str+"   "+_all);
			var _rooms:Array=[room,room1,room2];
			var _names:Array=[gr_name,gr_name1,gr_name2];
			var _ar:Array=["rootGroup","reid","polk"];
			var _j:int=0;
			if(gr_now==gr_name1){
				_j=1;
			}else if(gr_now==gr_name2){
				_j=2;
			}
			_join[_i]=null;
			try{
				_rooms[_i].leave();
			}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.ADMIN_ERROR, roomAdmErr);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.BANNED_ERROR, roomBanErr);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.NICK_CONFLICT, roomNickConf);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.LOCKED_ERROR, roomLockErr);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.ROOM_DESTROYED, roomDestroy);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.REGISTRATION_REQ_ERROR, roomRegErr);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.PASSWORD_ERROR, roomPassErr);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.MAX_USERS_ERROR, roomMaxUsErr);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.CONFIGURE_ROOM, roomConf);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.CONFIGURE_ROOM_COMPLETE, roomConfComp);}catch(er:Error){}
			
			try{_rooms[_i].removeEventListener(RoomEvent.USER_JOIN, roomUsJoin);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.ROOM_LEAVE, roomLeave);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.USER_DEPARTURE, usDep);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.GROUP_MESSAGE, groupMess);}catch(er:Error){}
			try{_rooms[_i].removeEventListener(RoomEvent.PRIVATE_MESSAGE, privMess);}catch(er:Error){}
			if(_i==1){
				room1=null;
			}else if(_i==2){
				room2=null;
			}else{
				room=null;
			}
			root[_ar[_i]]["name_gr"]="";
			msgs[_i]=[];
			users[_i]=[];
			if(_all==0){
				if(_i==_j){
					for(var i:int=0;i<3;i++){
						if(i!=_i&&_rooms[i]!=null&&_rooms[i].isActive){
							changeRoom(_names[i]);
							break;
						}
					}
				}else{
					setVkl(_j);
				}
			}else{
				root["get_tx"].text="";
			}
			if(_str!=null){
				if(_i==1){
					reidSet(_str,_mod);
				}else if(_i==2){
					polkSet(_str,_mod);
				}else{
					rootSet(_str,_mod);
				}
			}
		}
		
		private var _join:Array=[];
		
		public function rootSet(_str:String,_i:int=0):void{
			if(_str==""){
				return;
			}else if(connection==null||!connection.isLoggedIn()){
				_join[0]=_str;
				return;
			}else if(room==null){
				room = new Room(connection);
				
				room.addEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);
				room.addEventListener(RoomEvent.ADMIN_ERROR, roomAdmErr);
				room.addEventListener(RoomEvent.BANNED_ERROR, roomBanErr);
				room.addEventListener(RoomEvent.NICK_CONFLICT, roomNickConf);
				room.addEventListener(RoomEvent.LOCKED_ERROR, roomLockErr);
				room.addEventListener(RoomEvent.ROOM_DESTROYED, roomDestroy);
				room.addEventListener(RoomEvent.REGISTRATION_REQ_ERROR, roomRegErr);
				room.addEventListener(RoomEvent.PASSWORD_ERROR, roomPassErr);
				room.addEventListener(RoomEvent.MAX_USERS_ERROR, roomMaxUsErr);
				/*if(_i==0){
					room.addEventListener(RoomEvent.CONFIGURE_ROOM, roomConf);
					room.addEventListener(RoomEvent.CONFIGURE_ROOM_COMPLETE, roomConfComp);
				}*/
				room.addEventListener(RoomEvent.USER_JOIN, roomUsJoin);
				room.addEventListener(RoomEvent.ROOM_LEAVE, roomLeave);
				//room.addEventListener(RoomEvent.USER_DEPARTURE, usDep);
				room.addEventListener(RoomEvent.GROUP_MESSAGE, groupMess);
				room.addEventListener(RoomEvent.PRIVATE_MESSAGE, privMess);
			}
			
			if(!room.isActive){
				var _b:Boolean=false;
				//trace(gr_now+"   "+gr_name);
				if(gr_now==""||gr_now==gr_name){
					_b=true;
				}
				gr_name=_str;
				if(_b){
					gr_now=gr_name;
				}
				root["rootGroup"].name_gr=gr_name;
				room.roomJID = new UnescapedJID(gr_name+"@"+group_serv);
				room.nickname=username+"♣"+nick+"♣"+stg_cl.rang_jbr+"♣"+stg_cl["dov_e"];
				room.roomName=gr_name;
				room.join(true);
			}else if(_str!=room.roomName){
				room_exit(0,_str,_i);
			}
		}
		
		public function reidSet(_str:String,_i:int=0):void{
			//trace(_str+"   "+_i);
			if(_str==""){
				return;
			}else if(connection==null||!connection.isLoggedIn()){
				_join[1]=_str;
				return;
			}else if(room1==null){
				room1 = new Room(connection);
				
				room1.addEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);
				room1.addEventListener(RoomEvent.ADMIN_ERROR, roomAdmErr);
				room1.addEventListener(RoomEvent.BANNED_ERROR, roomBanErr);
				room1.addEventListener(RoomEvent.NICK_CONFLICT, roomNickConf);
				room1.addEventListener(RoomEvent.LOCKED_ERROR, roomLockErr);
				room1.addEventListener(RoomEvent.ROOM_DESTROYED, roomDestroy);
				room1.addEventListener(RoomEvent.REGISTRATION_REQ_ERROR, roomRegErr);
				room1.addEventListener(RoomEvent.PASSWORD_ERROR, roomPassErr);
				room1.addEventListener(RoomEvent.MAX_USERS_ERROR, roomMaxUsErr);
				if(_i==0){
					room1.addEventListener(RoomEvent.CONFIGURE_ROOM, roomConf);
					room1.addEventListener(RoomEvent.CONFIGURE_ROOM_COMPLETE, roomConfComp);
				}
				
				//room1.addEventListener(RoomEvent.USER_JOIN, roomUsJoin);
				room1.addEventListener(RoomEvent.ROOM_LEAVE, roomLeave);
				//room1.addEventListener(RoomEvent.USER_DEPARTURE, usDep);
				room1.addEventListener(RoomEvent.GROUP_MESSAGE, groupMess);
				room1.addEventListener(RoomEvent.PRIVATE_MESSAGE, privMess);
			}
			
			if(!room1.isActive){
				var _b:Boolean=false;
				//trace(gr_now+"   "+gr_name1);
				if(gr_now==gr_name1){
					_b=true;
				}
				gr_name1=_str;
				if(_b){
					gr_now=gr_name1;
				}
				root["reid"].name_gr=gr_name1;
				room1.roomJID = new UnescapedJID(gr_name1+"@"+group_serv);
				room1.nickname=username+"♣"+nick+"♣"+stg_cl.rang_jbr+"♣"+stg_cl["dov_e"];
				room1.roomName=gr_name1;
				room1.join(true);
			}else if(_str!=room1.roomName){
				room_exit(1,_str,_i);
			}
		}
		
		public function polkSet(_str:String,_i:int=0):void{
			
			if(_str==""){
				return;
			}else if(connection==null||!connection.isLoggedIn()){
				_join[2]=_str;
				return;
			}else if(room2==null){
				room2 = new Room(connection);
				
				room2.addEventListener(RoomEvent.ROOM_JOIN, onRoomJoin);
				room2.addEventListener(RoomEvent.ADMIN_ERROR, roomAdmErr);
				room2.addEventListener(RoomEvent.BANNED_ERROR, roomBanErr);
				room2.addEventListener(RoomEvent.NICK_CONFLICT, roomNickConf);
				room2.addEventListener(RoomEvent.LOCKED_ERROR, roomLockErr);
				room2.addEventListener(RoomEvent.ROOM_DESTROYED, roomDestroy);
				room2.addEventListener(RoomEvent.REGISTRATION_REQ_ERROR, roomRegErr);
				room2.addEventListener(RoomEvent.PASSWORD_ERROR, roomPassErr);
				room2.addEventListener(RoomEvent.MAX_USERS_ERROR, roomMaxUsErr);
				if(_i==0){
					room2.addEventListener(RoomEvent.CONFIGURE_ROOM, roomConf);
					room2.addEventListener(RoomEvent.CONFIGURE_ROOM_COMPLETE, roomConfComp);
				}
				//room2.addEventListener(RoomEvent.USER_JOIN, roomUsJoin);
				room2.addEventListener(RoomEvent.ROOM_LEAVE, roomLeave);
				//room2.addEventListener(RoomEvent.USER_DEPARTURE, usDep);
				room2.addEventListener(RoomEvent.GROUP_MESSAGE, groupMess);
				room2.addEventListener(RoomEvent.PRIVATE_MESSAGE, privMess);
			}
			
			if(!room2.isActive){
				var _b:Boolean=false;
				//trace(gr_now+"   "+gr_name2);
				if(gr_now==gr_name2){
					_b=true;
				}
				gr_name2=_str;
				if(_b){
					gr_now=gr_name2;
				}
				root["polk"].name_gr=gr_name2;
				room2.roomJID = new UnescapedJID(gr_name2+"@"+group_serv);
				room2.nickname=username+"♣"+nick+"♣"+stg_cl.rang_jbr+"♣"+stg_cl["dov_e"];
				room2.roomName=gr_name2;
				room2.join(true);
			}else if(_str!=room2.roomName){
				room_exit(2,_str,_i);
			}
			//trace("set   "+_str+"   "+room2.roomName);
		}
		
		private function roomConfComp(e:RoomEvent):void{
			//trace(e.data);
		}
		
		private function roomConf(e:RoomEvent):void{
			var _room:Room=(e.currentTarget as Room);
			//addMess(gr_name,"<b>"+"<font color=\"#6600FF\" size=\"10\">"+"Конфигурация "+_room+"</font>"+"</b> "+"\n");
			//var _xml:XMLNode=new XMLNode(1,(new XML(e.data)).child(""));
			var str:String=e.data+"";
			var _xml:XML=new XML(str);
			var _list:XMLList=_xml.children();
			//trace(_list);
			var _fe:FormExtension=new FormExtension();
			_fe.title=_list[0];
			var _obj:Object=new Object();
			for(var i:int=1;i<_list.length();i++){
				//trace(_list[i].attribute("var")+"   "+_list[i].child("value"));
				//if(_list[i].attribute("var")!=null){
					if(_list[i].attribute("var")=="muc#roomconfig_whois"){
						_obj[String(_list[i].attribute("var"))]=["anyone"];
					}else if(_list[i].attribute("var")=="muc#roomconfig_persistentroom"){
						//if(_room!=room1){
							_obj[String(_list[i].attribute("var"))]=["1"];
						/*}else{
							_obj[String(_list[i].attribute("var"))]=["0"];
						}*/
					}else if(_list[i].attribute("var")=="muc#roomconfig_roomname"){
						_obj[String(_list[i].attribute("var"))]=[_room.roomName];
					}else{
						_obj[String(_list[i].attribute("var"))]=[String(_list[i].children()[0])];
					}
				//}
			}
			_fe.setFields(_obj);
			_room.configure(_fe);
		}
		
		public function saveInfo():void{
			var _str:String=username+"♣"+nick+"♣"+stg_cl.rang_jbr+"♣"+stg_cl["dov_e"];
			try{
				if(room.nickname!=_str){
					room.nickname=_str;
				}
			}catch(er:Error){}
			try{
				if(room1.nickname!=_str){
					room1.nickname=_str;
				}
			}catch(er:Error){}
			try{
				if(room2.nickname!=_str){
					room2.nickname=_str;
				}
			}catch(er:Error){}
			/*try{
				var _mjid:UnescapedJID=new UnescapedJID(room.roomName+"@"+group_serv+"/"+room.nickname, false);
				var vCard:VCard = VCard.getVCard(connection, _mjid);
				vCard.url=stg_class.prnt_cl.link;
				vCard.role=(stg_class.rang_st+"");
				vCard.note=stg_cl["dov_e"];
				vCard.saveVCard(connection);
				//delVCard(jid);
			}catch(er:Error){}
			try{
				var _mjid1:UnescapedJID=new UnescapedJID(room1.roomName+"@"+group_serv+"/"+room1.nickname, false);
				var vCard1:VCard = VCard.getVCard(connection, _mjid1);
				vCard1.url=stg_class.prnt_cl.link;
				vCard1.role=(stg_class.rang_st+"");
				vCard1.note=stg_cl["dov_e"];
				vCard1.saveVCard(connection);
			}catch(er:Error){}
			try{
				var _mjid2:UnescapedJID=new UnescapedJID(room2.roomName+"@"+group_serv+"/"+room2.nickname, false);
				var vCard2:VCard = VCard.getVCard(connection, _mjid2);
				vCard2.url=stg_class.prnt_cl.link;
				vCard2.role=(stg_class.rang_st+"");
				vCard2.note=stg_cl["dov_e"];
				vCard2.saveVCard(connection);
			}catch(er:Error){}*/
		}
		
		private function onRoomJoin(e:RoomEvent):void{
			//trace("JOIN");
			var _room:Room=(e.currentTarget as Room);
			//_room.requestConfiguration();
			//trace("room join   "+_room.userJID+"   "+connection.jid+"   "+_room.source);
			
			/*var _mjid:UnescapedJID=new UnescapedJID(_room.roomName+"@"+group_serv+"/"+room.nickname, false);
			var vCard:VCard = VCard.getVCard(connection, _mjid);
			//vCard.addEventListener("saveError", function(ev:VCardEvent){trace("save error");});
			//vCard.addEventListener("saved", function(ev:VCardEvent){trace("saved");});
			//vCard.nickname=nick;
			vCard.url=stg_class.prnt_cl.link;
			vCard.role=(stg_class.rang_st+"");
			vCard.note=stg_cl["dov_e"];
			vCard.saveVCard(connection);*/
			
			var _type:String=_room.roomName;
			var _str:String="";
			if(_type==gr_name){
				_str="общую комнату";
				if(root["rootGroup"].currentFrameLabel!="empty")root["rootGroup"].gotoAndStop("over");
			}else if(_type==gr_name1){
				_str="комнату группы";
				//addMess(_type,"<b>"+"<font color=\"#6600FF\" size=\"10\">"+"Вы вошли в комнату"+"</font>"+"</b> "+"\n");
				if(root["reid"].currentFrameLabel!="empty")root["reid"].gotoAndStop("over");
			}else if(_type==gr_name2){
				_str="полковую комнату";
				//addMess(_type,"<b>"+"<font color=\"#6600FF\" size=\"10\">"+"Вы вошли в комнату"+"</font>"+"</b> "+"\n");
				if(root["polk"].currentFrameLabel!="empty")root["polk"].gotoAndStop("over");
			}
			if(_type==gr_now)changeRoom(_type,1);
			//addMess(gr_name,"<b>"+"<font color=\"#6600FF\" size=\"10\">"+"Вы вошли в "+_str+"</font>"+"</b> "+"\n");
		}
		
		private function roomLeave(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			//root["get_tx"].htmlText+=("room leave\n"+e.currentTarget.roomName+"\n"+e.nickname+"\n\n");
			var _type:String=e.currentTarget.roomName;
			var _str:String="";
			var _i:int=0;
			if(_type==gr_name){
				_str="общей комнаты";
				root["rootGroup"].gotoAndStop("out");
			}else if(_type==gr_name1){
				_str="комнаты группы";
				//addMess(_type,"<b>"+"<font color=\"#6600FF\" size=\"10\">"+"Вы вышли из комнаты"+"</font>"+"</b> "+"\n");
				root["reid"].gotoAndStop("out");
				_i=1;
			}else if(_type==gr_name2){
				_str="полковой комнаты";
				//addMess(_type,"<b>"+"<font color=\"#6600FF\" size=\"10\">"+"Вы вышли из комнаты"+"</font>"+"</b> "+"\n");
				root["polk"].gotoAndStop("out");
				_i=2;
			}
			//addMess(gr_name,"<b>"+"<font color=\"#6600FF\" size=\"10\">"+"Вы вышли из "+_str+"</font>"+"</b> "+"\n");
			/*msgs[_i]=new Array();
			drawGrMess(_i);
			users[_i]=new Array();
			drawUsList(_type,_i);*/
		}
		
		private function groupMess(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"   "+e.from+"   "+e.nickname+"   "+e.reason+"   "+e.subject+"   "+e.data.to+"   "+e.data.state+"   "+e.data.thread+"   "+e.data.type+"   "+e.data.time);
			//trace("onRoomJoin   "+e.data.from.node+"   "+e.data.from.domain+"   "+e.data.from.bareJID+"   "+e.data.from.resource+"   "+e.data.from.unescaped);
			//root["get_tx"].htmlText+=("groupMessage=[ <b>"+e.nickname+": "+e.data.body+"</b> from ]\n\n");
			var _room:Room=(e.currentTarget as Room);
			var _date:Date=e.data.time;
			var _time:String;
			var _nick:String=e.data.from.resource;
			if(_date!=null){
				_time=_date.hours+":";
				if(_time.length<3){
					_time="0"+_time;
				}
				if(_date.minutes<10){
					_time+="0"+_date.minutes;
				}else{
					_time+=_date.minutes;
				}
				if(_nick==_room.nickname){
					addMess(_room.roomName,"<font color=\"#999999\" size=\"10\">"+_time+"</font>  <b><font color=\"#006A15\" size=\"12\"><a href=\"event:"+_nick+"\">"+nickNames(_nick)+"</a></font></b>","<font color=\"#333333\" size=\"12\"> "+unHtml(e.data.body)+"</font>\n",_nick,1);
				}else{
					addMess(_room.roomName,"<font color=\"#999999\" size=\"10\">"+_time+"</font>  <b><font color=\"#3F7F3F\" size=\"12\"><a href=\"event:"+_nick+"\">"+nickNames(_nick)+"</a></font></b>","<font color=\"#333333\" size=\"12\"> "+unHtml(e.data.body)+"</font>\n",_nick,1);
				}
			}else{
				_time=root["time_cl"]["time_tx"].text;
				if(_nick==_room.nickname){
					addMess(_room.roomName,"<font color=\"#333333\" size=\"10\">"+_time+"</font>  <b><font color=\"#006A15\" size=\"12\"><a href=\"event:"+_nick+"\">"+nickNames(_nick)+"</a></font></b>","<font color=\"#333333\" size=\"12\"> "+unHtml(e.data.body)+"</font>\n",_nick,1);
				}else{
					addMess(_room.roomName,"<font color=\"#333333\" size=\"10\">"+_time+"</font>  <b><font color=\"#3F7F3F\" size=\"12\"><a href=\"event:"+_nick+"\">"+nickNames(_nick)+"</a></font></b>","<font color=\"#333333\" size=\"12\"> "+unHtml(e.data.body)+"</font>\n",_nick,1);
				}
			}
		}
		
		private function privMess(e:RoomEvent):void{
			//trace("priv");
			//trace("onRoomJoin   "+e.data+"   "+e.from+"   "+e.nickname+"   "+e.reason+"   "+e.subject+"   "+e.data.to+"   "+e.data.state+"   "+e.data.thread+"   "+e.data.type+"   "+e.data.time);
			//trace("onRoomJoin   "+e.data.from.node+"   "+e.data.from.domain+"   "+e.data.from.bareJID+"   "+e.data.from.resource+"   "+e.data.from.unescaped);
			var _room:Room=(e.currentTarget as Room);
			//var _date:Date=e.data.time;
			var _nick:String=e.data.from.resource;
			var _time:String;
			/*if(_date!=null){
				_time=_date.hours+":";
				if(_time.length<3){
					_time="0"+_time;
				}
				if(_date.minutes<10){
					_time+="0"+_date.minutes;
				}else{
					_time+=_date.minutes;
				}
				addMess(_room.roomName,"<font color=\"#999999\" size=\"10\">"+_time+"</font>  <b><font color=\"#530202\" size=\"12\"><a href=\"event:"+_nick+"\">"+nickNames(_nick)+"</a>:</font><font color=\"#273327\" size=\"12\"> "+unHtml(e.data.body)+"</font></b>\n");
			}else{*/
				var _mess:String=unHtml(e.data.body);
				var _rn:String=_room.roomName;
				_time=root["time_cl"]["time_tx"].text;
				if(gr_now!=_room.roomName){
					var _where:String="(Общая комната)";
					if(_rn==gr_name1){
						_where="(Комната группы)";
					}else if(_rn==gr_name2){
						_where="(Полковая комната)";
					}
					addMess(gr_now,"<font color=\"#333333\" size=\"10\">"+_time+"</font>  <b><font color=\"#62B902\" size=\"12\"><a href=\"event:"+"toRoom♣"+_rn+"♣"+_nick+"\">От "+nickNames(_nick)+""+_where+"</a></font></b>","<b><font color=\"#003300\" size=\"12\"> "+_mess+"</font></b>\n",_nick,1);
				}
				addMess(_rn,"<font color=\"#333333\" size=\"10\">"+_time+"</font>  <b><font color=\"#62B902\" size=\"12\"><a href=\"event:"+_nick+"\">От "+nickNames(_nick)+"</a></font></b>","<b><font color=\"#003300\" size=\"12\"> "+_mess+"</font></b>\n",_nick,1);
			//}
		}
		
		public function show_us_menu(_whom:String=null):void{
			if(us_win.stage!=null){
				removeChild(us_win);
				return;
			}
			var _room:Room=room;
			if(gr_now==gr_name1){
				_room=room1;
			}else if(gr_now==gr_name2){
				_room=room2;
			}
			if(_whom!=null){
				var _ar:Array=_whom.split("♣");
				var _i:int=2;
				if(_ar[0]!="toRoom"){
					
				}else{
					_i=4;
				}
				//trace("_whom   "+_ar+"   "+_ar.join("♣")+"   "+_i);
				if(_ar.join("♣")==_room.nickname){
					unPriv();
					hide_ban_win();
					return;
				}
			}
			try{
				call_us.removeEventListener(IOErrorEvent.IO_ERROR, us_win._erFnc);
				call_us.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, us_win._erFnc);
				call_us.removeEventListener(Event.COMPLETE, us_win._resFnc);
			}catch(er:Error){}
			try{
				call_us.close();
			}catch(er:Error){}
			try{
				removeChild(us_win);
			}catch(er:Error){}
			if(_whom==null){
				us_win.ID=nickId(priv_n);
				us_win._nick=nickNames(priv_n);
			}else{
				us_win.ID=nickId(_whom);
				us_win._nick=nickNames(_whom);
			}
			addChild(us_win);
			us_win.x=4;
			us_win.y=395;
			us_win["call0"].visible=false;
			us_win["call1"].visible=false;
			us_win["call2"].visible=false;
			us_win["call3"].visible=false;
			us_win["name_tx"].text="Загрузка...";
			var rqs:URLRequest=new URLRequest(serv_url+"?query="+2+"&action="+18);
			rqs.method=URLRequestMethod.POST;
			call_us=new URLLoader(rqs);
			us_win._erFnc=function(event:Event){
				us_win.visible=false;
			}
			us_win._resFnc=function(event:Event) {
				var str:String=event.target.data+"";
				//trace(str);
				try{
					var list:XML=new XML(str);
				}catch(er:Error){
					stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: Чат-приглашение.");
					stg_cl.erTestReq(2,4,str);
					return;
				}
				//trace("getUs\n"+list);
				try{
					if(int(list.child("err")[0].attribute("code"))!=0){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
						return;
					}
				}catch(er:Error){
					
				}
				for(var n:int=0;n<4;n++){
					if(list.child("invite")[0].attribute("mh"+(n+1))==0){
						us_win["call"+n].visible=true;
					}
				}
				us_win["name_tx"].text=us_win._nick;
			}
			call_us.addEventListener(IOErrorEvent.IO_ERROR, us_win._erFnc);
			call_us.addEventListener(SecurityErrorEvent.SECURITY_ERROR, us_win._erFnc);
			call_us.addEventListener(Event.COMPLETE, us_win._resFnc);
			var variables:URLVariables = new URLVariables();
			variables.query = new XML("<query id=\""+2+"\"><action id=\""+18+"\" user_id=\""+us_win.ID+"\"/></query>");
			variables.send = "send";
			//trace("s_xml\n"+variables.query+"\n");
			rqs.data = variables;
			call_us.dataFormat = URLLoaderDataFormat.TEXT;
			call_us.load(rqs);
		}
		
		private var priv_n:String="";
		private var _l_priv_n:String="";
		private var call_us:URLLoader;
		
		private function usClick(event:TextEvent):void{
			hide_ban_win();
			if(_l_priv_n!=event.text){
				_l_pr_mess=new Array();
			}
			priv_n=_l_priv_n=event.text;
			var _ar:Array=priv_n.split("♣");
			var _room:Room=room;
			if(gr_now==gr_name1){
				_room=room1;
			}else if(gr_now==gr_name2){
				_room=room2;
			}
			//trace(_ar);
			var _i:int=2;
			if(_ar[0]!="toRoom"){
				
			}else{
				_i=4;
			}
			//trace("usClick   "+_ar+"   "+_ar[_i-1].split("♦").join(" ")+"   "+_i+"   "+_ar.join("♣")+"   "+_room.nickname+"   "+_ctrl);
			if(_ctrl==1){
				get_user(_ar[0]);
				//get_card(gr_now,_ar.join("♣"));
				return;
			}else if(_ar[_i-1]==null||_ar[_i-1]==""){
				_ar[_i-1]="Без имени";
			}else if(_ar.join("♣")==_room.nickname){
				unPriv();
				return;
			}
			
			root["priv_tx"].text=_ar[_i-1].split("♦").join(" ")+":";
			root["priv_tx"].width=root["priv_tx"].textWidth+5;
			root["priv_tx"].x=root["priv_us"].x+root["priv_us"].width+2;
			root["send_tx"].x=root["priv_tx"].x+root["priv_tx"].width+2;
			root["priv_tx"].y=root["send_tx"].y;
			root["send_tx"].width=root["send_b"].x-root["send_tx"].x-2;
			root["priv_tx"].visible=true;
			root["priv_us"].gotoAndStop("out");
		}
		
		public function unPriv():void{
			try{
				removeChild(us_win);
			}catch(er:Error){}
			root["priv_tx"].visible=false;
			root["send_tx"].x=root["priv_us"].x+root["priv_us"].width+2;
			root["send_tx"].width=root["send_b"].x-root["send_tx"].x-2;
			root["priv_tx"].text="";
			root["send_tx"].text="";
			root["priv_us"].gotoAndStop("empty");
		}
		
		private function unHtml(_str:String) {
       _str = _str.split("&").join('&amp;');
       _str = _str.split('"').join('&quot;');
       _str = _str.split("'").join('&apos;');
       _str = _str.split("<").join('&lt;');
       _str = _str.split(">").join('&gt;');
       _str = _str.split("\\").join("&#92;");
       return _str;
    }
		
		private function getMess(e:MessageEvent):void{
			//trace("onMess   "+e.data+e.data.to+"   "+e.data.state+"   "+e.data.thread+"   "+e.data.type);
			//trace("onMess   "+e.data.from.node+"   "+e.data.from.domain+"   "+e.data.from.bareJID+"   "+e.data.from.resource+"   "+e.data.from.unescaped);
			//trace("getMess   "+e.data.body+"\n"+e.data.htmlBody+"\n"+e.data.state+"\n"+e.data.subject+"\n"+e.data.thread+"\n"+e.data.time+"\n");
			//root["get_tx"].htmlText+=("getMessage=[ <b>"+e.data.body+"</b> ]   "+e.data.type+"   "+e.data.from+"\n\n");
		}
		
		private function usDep(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			//root["get_tx"].htmlText+=("user leave room: "+e.nickname+"\n\n");
			//addUser(e.currentTarget.roomName,"<b><font color=\"#9d0e03\" size=\"12\">"+e.nickname+"</font></b>",1);
		}
		
		private function roomUsJoin(e:RoomEvent):void{
			//trace("onUsJoin   "+e.data.from+"   "+e.data.to+"   "+e.from+"   "+e.nickname+"   "+e.reason+"   "+e.subject);
			var _room:Room=(e.currentTarget as Room);
			//trace(_room.userJID);
			var _i:int=0;
			if(_room.roomName==gr_name1){
				_room=room1;
				_i=1;
			}else if(_room.roomName==gr_name2){
				_room=room2;
				_i=2;
			}
			//var _mjid:UnescapedJID=new UnescapedJID(_room.roomName+"@"+group_serv+"/"+e.nickname, false);
			//VCard.testVCard(_mjid);
			//trace(vCard.role+"   "+_mjid);
		}
		
		private function _login(_str:String):String{
			var _ar:Array=_str.split("♣");
			var _i:int=2;
			if(_ar[0]!="toRoom"){
				
			}else{
				_i=4;
			}
			//trace("login   "+_ar+"   "+_ar[_i-2]+"   "+_i);
			return (_ar[_i-2]);
		}
		
		private function nickId(_str:String):String{
			var _ar:Array=_str.split("♣");
			var _i:int=2;
			if(_ar[0]!="toRoom"){
				
			}else{
				_i=4;
			}
			//trace("nickId   "+_ar+"   "+_ar[_i-2].split("_")[1]+"   "+_i);
			return (_ar[_i-2].split("_")[1]);
		}
		
		private function nickNames(_str:String):String{
			var _ar:Array=_str.split("♣");
			var _i:int=2;
			if(_ar[0]!="toRoom"){
				
			}else{
				_i=4;
			}
			if(_ar[_i]==null||_ar[_i]==""){
				_ar[_i]="Без имени";
			}
			//trace("nickNames   "+_ar+"   "+_i);
			try{
				return (_ar[_i-1].split("♦").join(" "));
			}catch(er:Error){
				return ("Без имени");
			}
			return (_ar[_i-1].split("♦").join(" "));
		}
		
		private function _rang(_str:String):String{
			var _ar:Array=_str.split("♣");
			var _i:int=2;
			if(_ar[0]!="toRoom"){
				
			}else{
				_i=4;
			}
			//trace("_rang   "+_ar+"   "+_ar[_i]+"   "+_i);
			return (_ar[_i].split("|").join("/"));
		}
		
		private function _dov_e(_str:String):String{
			var _ar:Array=_str.split("♣");
			var _i:int=2;
			if(_ar[0]!="toRoom"){
				
			}else{
				_i=4;
			}
			//trace("dov_e   "+_ar+"   "+_ar[_i+1]+"   "+_i);
			return (_ar[_i+1]);
		}
		
		public function showList(){
			try{
				if(us_list.stage!=null){
					removeChild(us_list);
					return;
				}
			}catch(er:Error){}
			var _i:int=0;
			if(gr_now==gr_name){
				us_list["channel_tx"].htmlText="<b>Общий</b>";
			}else if(gr_now==gr_name1){
				us_list["channel_tx"].htmlText="<b>Группа</b>";
				_i=1;
			}else if(gr_now==gr_name2){
				us_list["channel_tx"].htmlText="<b>Полк</b>";
				_i=2;
			}
			list_now=gr_now;
			us_list._i=_i;
			us_count=0;
			us_list["sc_us"].visible=false;
			sortUs(sort_us);
			
			us_list.x=120;
			us_list.y=7;
			addChild(us_list);
			if(stg_class.warn_cl.stage==null){
				try{
					stg_cl.setChildIndex(this, stg_cl.numChildren-1);
				}catch(er:Error){
					
				}
			}else{
				try{
					stg_cl.setChildIndex(this, stg_cl.getChildIndex(stg_class.warn_cl)-1);
				}catch(er:Error){
					
				}
			}
		}
		
		public function hideList(){
			try{
				removeChild(us_list);
			}catch(er:Error){}
			try{
				tmUser.stop();
			}catch(er:Error){}
		}
		
		private var list_now:String="";
		
		private function checkUsers(event:TimerEvent):void{
			var _room:Room;
			var _i:int=-1;
			var _n:Number=0;
			var _l:Number=Number.MIN_VALUE;
			var _c:int=0;
			if(list_now==gr_name){
				_room=room;
				_i=0;
			}else if(list_now==gr_name1){
				_room=room1;
				_i=1;
			}else if(list_now==gr_name2){
				_room=room2;
				_i=2;
			}
			if(_room!=null&&_room.isActive){
				users[_i]=new Array();
				//trace(_room.source+"   "+_room.source.length);
				for(var i:int=0;i<_room.source.length;i++){
					//trace(_room.source[i].displayName+"   "+nickNames(_room.source[i].displayName));
					_c=0;
					if(sort_us==1){
						_l=nickNames(_room.source[i].displayName).toLowerCase().charCodeAt(0);
						if(users[_i].length==0){
							users[_i][i]=([_room.source[i].displayName,nickNames(_room.source[i].displayName)]);
							users[_i][i][2]=("<b><font color=\"#003300\" size=\"10\"><a href=\"event:"+users[_i][i][0]+"\">"+users[_i][i][1]+"</a></font></b>\n");
							continue;
						}
						for(var j:int=0;j<users[_i].length;j++){
							_n=users[_i][j][1].toLowerCase().charCodeAt(0);
							if(_l>_n){
								_c=j;
								//trace(_l+"   "+_n+"   "+_room.source[i].displayName+"   "+users[_i][j][0]);
								break;
							}else if(_c==0&&j==users[_i].length-1){
								_c=j+1;
								//break;
							}
						}
					}else if(sort_us==2){
						_l=rng_num(_rang(_room.source[i].displayName));
						if(users[_i].length==0){
							users[_i][i]=([_room.source[i].displayName,nickNames(_room.source[i].displayName)]);
							users[_i][i][2]=("<b><font color=\"#003300\" size=\"10\"><a href=\"event:"+users[_i][i][0]+"\">"+users[_i][i][1]+"</a></font></b>\n");
							continue;
						}
						for(var j:int=0;j<users[_i].length;j++){
							_n=rng_num(_rang(users[_i][j][0]));
							if(_l>_n){
								_c=j;
								//trace(_l+"   "+_n+"   "+_room.source[i].displayName+"   "+users[_i][j][0]);
								break;
							}else if(_c==0&&j==users[_i].length-1){
								_c=j+1;
								//break;
							}
						}
						/*_c=rng_num(_rang(_room.source[i].displayName));
						if(_c>users[_i].length-1){
							_c=users[_i].length-1;
						}*/
					}
					//trace(_l+"   "+_n+"   "+_room.source[i].displayName+"   "+users[_i][_c][0]);
					var _ar:Array=([_room.source[i].displayName,nickNames(_room.source[i].displayName)]);
					_ar[2]=("<b><font color=\"#003300\" size=\"10\"><a href=\"event:"+_ar[0]+"\">"+_ar[1]+"</a></font></b>\n");
					users[_i].splice(_c, 0, _ar);
				}
				if(sort_us==1){
					users[_i].reverse();
				}
			}
			//users.sort();
			if(_i>=0){
				drawUsList(list_now,_i);
			}
		}
		
		private var rng_names:Array=["ряд.","серж.","ст-на","л-т","ст.л-т","к-н","м-р","п/п-к","п-к","ген.м-р","ген.л-т","ген.п-к"];
		private var sort_us:int=1;
		
		public function rng_num(_s:String):int{
			for(var i:int=0;i<rng_names.length;i++){
				if(rng_names[i]==_s){
					//trace("find   "+i+"   "+_s);
					return i;
				}
			}
			//trace("not   "+i+"   "+_s);
			return 0;
		}
		
		public function sortUs(_i:int):void{
			us_list["sort1"]["press_cl"].visible=us_list["sort2"]["press_cl"].visible=false;
			us_list["sort"+_i]["press_cl"].visible=true;
			sort_us=_i;
			var _te:TimerEvent=new TimerEvent(TimerEvent.TIMER);
			tmUser.dispatchEvent(_te);
			//setGrMess(gr_now,1);
			try{
				tmUser.reset();
			}catch(er:Error){}
			tmUser.start();
		}
		
		public function chat_exit():void{
			connection.disconnect();
		}
		
		public function changeRoom(_type:String,_i:int=0):void{
			//trace(gr_now+"   "+_type);
			if(_i==0&&gr_now==_type){
				return;
			}
			gr_now=_type;
			setGrMess(_type,1);
			//trace(gr_now);
		}
		
		private function setUsList(_type:String=""):void{
			var _i:int=0;
			if(_type==gr_name){
				_i=0;
			}else if(_type==gr_name1){
				_i=1;
			}else if(_type==gr_name2){
				_i=2;
			}
			list_now=_type;
			us_list._i=_i;
			us_count=0;
			drawUsList(_type,_i,1);
		}
		
		public function get_user(_us:String):void{
			//trace("get_user "+_us);
			sendRequest(["query","action"],[["id"],["id","login"]],[["2"],["22",_us+""]]);
		}
		
		public function usData(event:Event):void{
			var str:String=event.target.data+"";
			//trace("usData="+str);
			//stg_cl.errTest(str,int(300));
			try{
				var list:XML=new XML(str);
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nДанные игрока.");
				stg_cl.erTestReq(7,2,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			stg_cl.linkTo(new URLRequest(list.child("tank_data")[0].attribute("link")));
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		/*private var one_card:VCard;
		
		public function get_card(_rn:String,_nick_s:String,_i:int=0):void{
			try{
				one_card.removeEventListener("loaded", card_loaded);
			}catch(er:Error){}
			var _mjid:UnescapedJID=new UnescapedJID(_rn+"@"+group_serv+"/"+_nick_s, false);
			one_card = VCard.getVCard(connection, _mjid);
			one_card.addEventListener("loaded", card_loaded);
		}
		
		public function card_loaded(event:VCardEvent):void{
			stg_cl.linkTo(new URLRequest(one_card.url));
		}*/
		
		private var us_count:int=0;
		
		private function drawUsList(_rn:String,_type:int,_i:int=0):void{
			for(var i:int=0;i<25;i++){
				if(i+us_count<users[_type].length){
					/*try{
						//if(i>0){
							var _mjid:UnescapedJID=new UnescapedJID(_rn+"@"+group_serv+"/"+users[_type][i+us_count][0], false);
							var vCard:VCard = VCard.getVCard(connection, _mjid);
							//trace(vCard.role+"   "+_mjid);
						//}
						if(vCard.role!=null){
							us_list["us"+i]["rang_tx"].text=vCard.role;
						}else{
							us_list["us"+i]["rang_tx"].text="";
						}
						if(vCard.url!=null){
							us_list["us"+i]["us_link"]._link=vCard.url;
						}else{
							us_list["us"+i]["us_link"]._link=stg_class.prnt_cl.link_group;
						}
						if(vCard.note!=null){
							us_list["us"+i]["dov_tx"].text=vCard.note;
						}else{
							us_list["us"+i]["dov_tx"].text="";
						}
					}catch(er:Error){
						us_list["us"+i]["rang_tx"].text="";
						us_list["us"+i]["dov_tx"].text="";
						us_list["us"+i]["us_link"]._link=stg_class.prnt_cl.link_group;
					}*/
					us_list["us"+i]["rang_tx"].text=_rang(users[_type][i+us_count][0]);
					us_list["us"+i]["dov_tx"].text=_dov_e(users[_type][i+us_count][0]);
					us_list["us"+i]["us_menu"].ID=users[_type][i+us_count][0];
					us_list["us"+i]["us_menu"]._rn=_rn;
					us_list["us"+i]["us_link"].visible=true;
					us_list["us"+i]["us_menu"].visible=true;
					us_list["us"+i]["name_tx"].htmlText=users[_type][i+us_count][2];
					us_list["us"+i]["name_tx"].mouseWheelEnabled=false;
					us_list["us"+i]["name_tx"].width=us_list["us"+i]["name_tx"].textWidth+5;
					if(us_list["us"+i]["name_tx"].width>138){
						us_list["us"+i]["name_tx"].width=138;
					}
				}else{
					us_list["us"+i]["rang_tx"].text="";
					us_list["us"+i]["name_tx"].text="";
					us_list["us"+i]["dov_tx"].text="";
					us_list["us"+i]["us_link"].visible=false;
					us_list["us"+i]["us_menu"].visible=false;
				}
			}
			us_list._i=_type;
			if(users[_type].length>25){
				us_list["sc_us"]["sc_rect"].graphics.clear();
				us_list["sc_us"]["sc_rect"].graphics.lineStyle(1,0x9A0700);
				us_list["sc_us"]["sc_rect"].graphics.beginFill(0xFCE3C5);
				us_list["sc_us"]["sc_rect"].graphics.drawRect(us_list["sc_us"]["to_left"].width+2,1,340-(us_list["sc_us"]["to_left"].width*2+3),us_list["sc_us"]["to_left"].height-1);
				us_list["sc_us"]["to_right"].x=us_list["sc_us"]["sc_rect"].width+us_list["sc_us"]["to_right"].width*2+3;
				var _w:int=(25/users[_type].length)*(us_list["sc_us"]["sc_rect"].width-4);
				if(_w<9){
					_w=9;
				}
				if(_w<us_list["sc_us"]["sc_rect"].width-4){
					us_list["sc_us"].visible=true;
					us_list["sc_us"]["sc_mover"]["sc_fill"].graphics.clear();
					us_list["sc_us"]["sc_mover"]["sc_fill"].graphics.beginFill(0x990000);
					us_list["sc_us"]["sc_mover"]["sc_fill"].graphics.drawRect(0,2,_w,11);
					us_list["sc_us"]["sc_mover"]["sc_zn"].x=Math.round(_w/2)-.5;
					us_list["sc_us"]["sc_mover"].x=int((us_count/users[_type].length)*(us_list["sc_us"]["sc_rect"].width-(us_list["sc_us"]["sc_mover"].width+3))+us_list["sc_us"]["to_left"].width+3);
					if(us_list["sc_us"]["sc_mover"].x<us_list["sc_us"]["to_left"].width+4){
						us_list["sc_us"]["sc_mover"].x=us_list["sc_us"]["to_left"].width+4;
					}else if(us_list["sc_us"]["sc_mover"].x+us_list["sc_us"]["sc_mover"].width>us_list["sc_us"].height-us_list["sc_us"]["to_left"].width-2){
						us_list["sc_us"]["sc_mover"].x=us_list["sc_us"].height-us_list["sc_us"]["to_left"].width-us_list["sc_us"]["sc_mover"].width-2;
					}
				}else{
					us_list["sc_us"].visible=false;
				}
			}else{
				us_list["sc_us"].visible=false;
			}
			us_list["us_num_tx"].htmlText="<b>"+users[_type].length+"</b>";
			//trace(us_list["us_num_tx"].text);
		}
		
		private var _list_cnt:int=0;
		
		public function moveUsList(X:Number,_i:int=0){
			us_count=((X-us_list["sc_us"]["to_left"].width-4)/(us_list["sc_us"]["sc_rect"].width-us_list["sc_us"]["sc_mover"].width))*users[us_list._i].length;
			if(_list_cnt>3||_i==1){
				_list_cnt=0;
				var _te:TimerEvent=new TimerEvent(TimerEvent.TIMER);
				tmUser.dispatchEvent(_te);
				try{
					tmUser.reset();
				}catch(er:Error){}
				tmUser.start();
			}else{
				_list_cnt++;
			}
		}
		
		private function addMess(_type:String,_s:String,_s1:String="",_s2:String="",_j:int=0):void{
			var _i:int=-1;
			if(_type==gr_name){
				_i=0;
			}else if(_type==gr_name1){
				_i=1;
			}else if(_type==gr_name2){
				_i=2;
			}
			if(_i>=0){
				msgs[_i].push([_s,_s1,_s2,_j]);
				if(gr_now==_type){
					drawGrMess(_i,0);
				}
			}
		}
		
		private function setGrMess(_type:String="",_j:int=0):void{
			var _i:int=0;
			if(_type==gr_name){
				_i=0;
			}else if(_type==gr_name1){
				_i=1;
			}else if(_type==gr_name2){
				_i=2;
			}
			//trace(_type+"   "+gr_name1+"   "+_i);
			setVkl(_i);
			drawGrMess(_i,_j);
		}
		
		private function reDraw(event:TimerEvent):void{
			drawGrMess(re_type,0,0);
		}
		
		private var re_type:int=0;
		private var mess_w:int=600;
		
		private function drawGrMess(_type:int,_i:int=0,_rd:int=1):void{
			try{
				tmMess.reset();
			}catch(er:Error){
				
			}
			var _str:String="";
			var _rang_s:String="";
			var _b:int=0;
			var _d:Number=0;
			try{
				root["get_tx"].removeEventListener(Event.SCROLL, scrollMess);
			}catch(er:Error){}
			if(root["get_tx"].scrollV==root["get_tx"].maxScrollV||_i==1){
				_b=1;
			}
			if(msgs[_type].length>100){
				msgs[_type].splice(0,msgs[_type].length-100);
			}else if(msgs[_type].length==0){
				root["get_tx"].text="";
				root["get_tx"].width=mess_w;
				root["sc_mess"].visible=false;
				return;
			}
			var _rooms:Array=[room,room1,room2];
			for(var i:int=0;i<msgs[_type].length;i++){
				_rang_s="";
				_d=0;
				if(msgs[_type][i][3]==0){
					msgs[_type][i][3]--;
				}else if(msgs[_type][i][3]<0&&_i==1){
					msgs[_type].splice(i,1);
					i--;
					continue;
				}else if(msgs[_type][i][3]==1){
					_rang_s="</font><font color=\"#333333\" size=\"12\"> ["+_rang(msgs[_type][i][2])+"]</font>";
					_d=int(_dov_e(msgs[_type][i][2]));
					if(_d>0){
						if(_d<20){
							_rang_s+="<b></font><font color=\"#ff0000\" size=\"10\">("+_d+")</font></b>";
						}else if(_d<50){
							_rang_s+="<b></font><font color=\"#7F3F3F\" size=\"10\">("+_d+")</font></b>";
						}else if(_d<80){
							_rang_s+="<b></font><font color=\"#3F7F3F\" size=\"10\">("+_d+")</font></b>";
						}else{
							_rang_s+="<b></font><font color=\"#999999\" size=\"10\">("+_d+")</font></b>";
						}
					}else if(_d<=0){
						_rang_s+="<b></font><font color=\"#ff0000\" size=\"10\">("+_d+")</font></b>";
					}
					_rang_s+="<b><font color=\"#4F1E1E\" size=\"12\">:</font></b>";
				}
				_str+=msgs[_type][i][0]+_rang_s+msgs[_type][i][1];
			}
			/*if(_rd>0){
				re_type=_type;
				tmMess.start();
			}*/
			root["get_tx"].htmlText=_str;
			if(_b==1){
				root["get_tx"].scrollV=root["get_tx"].maxScrollV;
			}
			var _w:int=(root["get_tx"].height/root["get_tx"].textHeight)*(root["sc_mess"]["sc_rect"].width-4);
			if(_w<9){
				_w=9;
			}
			if(_w<root["sc_mess"]["sc_rect"].width-4){
				root["get_tx"].width=mess_w-root["sc_mess"].width-2;
				_w=(root["get_tx"].height/root["get_tx"].textHeight)*(root["sc_mess"]["sc_rect"].width-4);
				if(_w<9){
					_w=9;
				}
				root["sc_mess"].visible=true;
				root["sc_mess"]["sc_mover"]["sc_fill"].graphics.clear();
				root["sc_mess"]["sc_mover"]["sc_fill"].graphics.beginFill(0x990000);
				root["sc_mess"]["sc_mover"]["sc_fill"].graphics.drawRect(0,2,_w,11);
				root["sc_mess"]["sc_mover"]["sc_zn"].x=Math.round(_w/2)-.5;
				if(_b==1){
					root["sc_mess"]["sc_mover"].x=int(((root["get_tx"].scrollV-1)/(root["get_tx"].maxScrollV-1))*(root["sc_mess"]["sc_rect"].width-(root["sc_mess"]["sc_mover"].width+3))+root["sc_mess"]["to_left"].width+3);
					if(root["sc_mess"]["sc_mover"].x<root["sc_mess"]["to_left"].width+4){
						root["sc_mess"]["sc_mover"].x=root["sc_mess"]["to_left"].width+4;
					}else if(root["sc_mess"]["sc_mover"].x+root["sc_mess"]["sc_mover"].width>root["sc_mess"].height-root["sc_mess"]["to_left"].width-2){
						root["sc_mess"]["sc_mover"].x=root["sc_mess"].height-root["sc_mess"]["to_left"].width-root["sc_mess"]["sc_mover"].width-2;
					}
				}
				root["get_tx"].addEventListener(Event.SCROLL, scrollMess);
			}else{
				root["get_tx"].width=mess_w;
				root["sc_mess"].visible=false;
			}
		}
		
		public var _size:int=0;
		
		public function _minimize(){
			graphics.clear();
			graphics.lineStyle(1,0x9A0700);
			graphics.beginFill(0xFF9837);
			graphics.drawRect(0,394,607,122);
			root["users_b"].y=root["pochta_b"].y=root["say_b"].y=root["rect_b"].y=root["time_cl"].y=root["opt_b"].y=root["max_b"].y=root["rootGroup"].y=root["reid"].y=root["polk"].y=394+2;
			root["bord_cl"].y=root["say_b"].y+6;
			root["get_tx"].y=root["users_b"].y+root["users_b"].height+1;
			root["get_tx"].height=root["send_tx"].y-root["get_tx"].y-2;
			root["sc_mess"].y=root["get_tx"].y;
			root["sc_mess"]["sc_rect"].graphics.clear();
			root["sc_mess"]["sc_rect"].graphics.lineStyle(1,0x9A0700);
			root["sc_mess"]["sc_rect"].graphics.beginFill(0xFCE3C5);
			root["sc_mess"]["sc_rect"].graphics.drawRect(root["sc_mess"]["to_left"].width+2,1,root["get_tx"].height-(root["sc_mess"]["to_left"].width*2+3),root["sc_mess"]["to_left"].height-1);
			root["sc_mess"]["to_right"].x=root["sc_mess"]["sc_rect"].width+root["sc_mess"]["to_right"].width*2+3;
			setGrMess(gr_now);
			_size=1;
			root["max_b"].visible=true;
			root["min_b"].visible=false;
			Mouse.cursor=MouseCursor.AUTO;
		}
		
		public function set time(value:String):void{
			root["time_cl"]["time_tx"].text=value;
		}
		
		public function _maximize(){
			graphics.clear();
			graphics.lineStyle(1,0x9A0700);
			graphics.beginFill(0xFF9837);
			graphics.drawRect(0,0,607,516);
			root["users_b"].y=root["pochta_b"].y=root["say_b"].y=root["rect_b"].y=root["time_cl"].y=root["opt_b"].y=root["max_b"].y=root["rootGroup"].y=root["reid"].y=root["polk"].y=2;
			root["bord_cl"].y=root["say_b"].y+6;
			root["get_tx"].y=root["users_b"].y+root["users_b"].height+2;
			root["get_tx"].height=root["send_tx"].y-root["get_tx"].y-2;
			root["sc_mess"].y=root["get_tx"].y;
			root["sc_mess"]["sc_rect"].graphics.clear();
			root["sc_mess"]["sc_rect"].graphics.lineStyle(1,0x9A0700);
			root["sc_mess"]["sc_rect"].graphics.beginFill(0xFCE3C5);
			root["sc_mess"]["sc_rect"].graphics.drawRect(root["sc_mess"]["to_left"].width+2,1,root["get_tx"].height-(root["sc_mess"]["to_left"].width*2+3),root["sc_mess"]["to_left"].height-1);
			root["sc_mess"]["to_right"].x=root["sc_mess"]["sc_rect"].width+root["sc_mess"]["to_right"].width*2+3;
			setGrMess(gr_now);
			_size=2;
			root["max_b"].visible=false;
			root["min_b"].visible=true;
			Mouse.cursor=MouseCursor.AUTO;
			if(stg_class.warn_cl.stage==null){
				try{
					stg_cl.setChildIndex(this, stg_cl.numChildren-1);
				}catch(er:Error){
					
				}
			}else{
				try{
					stg_cl.setChildIndex(this, stg_cl.getChildIndex(stg_class.warn_cl)-1);
				}catch(er:Error){
					
				}
			}
		}
		
		public function moveMessText(X:Number){
			root["get_tx"].scrollV=((X-root["sc_mess"]["to_left"].width-4)/(root["sc_mess"]["sc_rect"].width-root["sc_mess"]["sc_mover"].width))*root["get_tx"].numLines;
		}
		
		private function scrollMess(event:Event){
			//trace(event.currentTarget.scrollV);
			if(root["sc_mess"]["sc_mover"].x_coor!=null){
				return;
			}
			//trace((root["get_tx"].scrollV));
			root["sc_mess"]["sc_mover"].x=int(((root["get_tx"].scrollV-1)/(root["get_tx"].maxScrollV-1))*(root["sc_mess"]["sc_rect"].width-(root["sc_mess"]["sc_mover"].width+3))+root["sc_mess"]["to_left"].width+3);
			if(root["sc_mess"]["sc_mover"].x<root["sc_mess"]["to_left"].width+4){
				root["sc_mess"]["sc_mover"].x=root["sc_mess"]["to_left"].width+4;
				//trace("a");
			}else if(root["sc_mess"]["sc_mover"].x+root["sc_mess"]["sc_mover"].width>root["sc_mess"].height-root["sc_mess"]["to_left"].width-2){
				root["sc_mess"]["sc_mover"].x=root["sc_mess"].height-root["sc_mess"]["to_left"].width-root["sc_mess"]["sc_mover"].width-2;
			}
		}
		
		private function roomRegErr(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			root["get_tx"].htmlText+=("Room Reg Error\n");
			var _type:String=e.currentTarget.roomName;
			var _str:String="Room Registration Error";
			if(_type==gr_name){
				_str+=" в общей комнате";
			}else if(_type==gr_name1){
				_str+=" в комнате группы";
			}else if(_type==gr_name2){
				_str+=" в полковой комнате";
			}
			addMess(gr_name,"<b>"+"<font color=\"#ff0000\" size=\"10\">"+_str+"</font>"+"</b> "+"\n");
		}
		
		private function roomMaxUsErr(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			var _type:String=e.currentTarget.roomName;
			var _str:String="Room Max Users Error";
			if(_type==gr_name){
				_str+=" в общей комнате";
			}else if(_type==gr_name1){
				_str+=" в комнате группы";
			}else if(_type==gr_name2){
				_str+=" в полковой комнате";
			}
			addMess(gr_name,"<b>"+"<font color=\"#ff0000\" size=\"10\">"+_str+"</font>"+"</b> "+"\n");
		}
		
		private function roomPassErr(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			var _type:String=e.currentTarget.roomName;
			var _str:String="Room Password Error";
			if(_type==gr_name){
				_str+=" в общей комнате";
			}else if(_type==gr_name1){
				_str+=" в комнате группы";
			}else if(_type==gr_name2){
				_str+=" в полковой комнате";
			}
			addMess(gr_name,"<b>"+"<font color=\"#ff0000\" size=\"10\">"+_str+"</font>"+"</b> "+"\n");
		}
		
		private function roomLockErr(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			var _type:String=e.currentTarget.roomName;
			var _str:String="Room Locked Error";
			if(_type==gr_name){
				_str+=" в общей комнате";
			}else if(_type==gr_name1){
				_str+=" в комнате группы";
			}else if(_type==gr_name2){
				_str+=" в полковой комнате";
			}
			//addMess(gr_name,"<b>"+"<font color=\"#ff0000\" size=\"10\">"+_str+"</font>"+"</b> "+"\n");
		}
		
		private function roomDestroy(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			var _type:String=e.currentTarget.roomName;
			var _str:String="Room Destroy";
			if(_type==gr_name){
				_str+=" в общей комнате";
			}else if(_type==gr_name1){
				_str+=" в комнате группы";
			}else if(_type==gr_name2){
				_str+=" в полковой комнате";
			}
			addMess(gr_name,"<b>"+"<font color=\"#ff0000\" size=\"10\">"+_str+"</font>"+"</b> "+"\n");
		}
		
		private function roomAdmErr(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			var _type:String=e.currentTarget.roomName;
			var _str:String="Room Admin Error";
			if(_type==gr_name){
				_str+=" в общей комнате";
			}else if(_type==gr_name1){
				_str+=" в комнате группы";
			}else if(_type==gr_name2){
				_str+=" в полковой комнате";
			}
			addMess(gr_name,"<b>"+"<font color=\"#ff0000\" size=\"10\">"+_str+"</font>"+"</b> "+"\n");
		}
		
		private function roomBanErr(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			var _type:String=e.currentTarget.roomName;
			var _str:String="Room Ban Error";
			if(_type==gr_name){
				_str+=" в общей комнате";
			}else if(_type==gr_name1){
				_str+=" в комнате группы";
			}else if(_type==gr_name2){
				_str+=" в полковой комнате";
			}
			addMess(gr_name,"<b>"+"<font color=\"#ff0000\" size=\"10\">"+_str+"</font>"+"</b> "+"\n");
		}
		
		private function roomNickConf(e:RoomEvent):void{
			//trace("onRoomJoin   "+e.data+"\n"+e.from+"\n"+e.nickname+"\n"+e.reason+"\n"+e.subject+"\n");
			var _type:String=e.currentTarget.roomName;
			var _str:String="Room Nick Conflict ";
			if(_type==gr_name){
				_str+=" в общей комнате";
			}else if(_type==gr_name1){
				_str+=" в комнате группы";
			}else if(_type==gr_name2){
				_str+=" в полковой комнате";
			}
			addMess(gr_name,"<b>"+"<font color=\"#ff0000\" size=\"10\">"+_str+"</font>"+"</b> "+"\n");
		}
		
		private function onPresence(e:PresenceEvent):void{
			trace("onPresence   "+e.data+"\n");
		}
		
		private function inDate(e:IncomingDataEvent):void{
			//trace("inDate\n"+e.data+"\n");
			//addMess(gr_name,"<font color=\"#0033FF\" size=\"12\">\ninDate\n"+unHtml(e.data.toString())+"</font>\n","","",2);
			stg_class.prnt_cl.output("<font color=\"#0033FF\" size=\"12\">\nChat inDate\n"+unHtml(e.data.toString())+"</font>\n");
		}
		
		private function outDate(e:OutgoingDataEvent):void{
			//trace("outDate\n"+e.data+"\n");
			//addMess(gr_name,"<font color=\"#0033FF\" size=\"12\">\noutDate\n"+unHtml(e.data.toString())+"</font>\n","","",2);
			stg_class.prnt_cl.output("<font color=\"#0033FF\" size=\"12\">\nChat outDate\n"+unHtml(e.data.toString())+"</font>\n");
		}
		
		private function changePass(e:ChangePasswordSuccessEvent):void{
			trace("changePass   "+"\n");
		}
		
		private function regDone(e:RegistrationSuccessEvent):void{
			reg_st=3;
			addMess(gr_name,"<b>"+"<font color=\"#007700\" size=\"10\">"+"Вы зарегистрированы"+"</font>"+"</b> "+"\n");
			f_repeate={_obj:connection,_fnc:connection.disconnect,_prm:[],_count:0};
			connection.disconnect();
		}
		
		private function disConnect(e:DisconnectionEvent):void{
			addMess(gr_name,"<b>"+"<font color=\"#999999\" size=\"10\">"+"disConnect"+"</font>"+"</b> "+"\n");
			if(reg_st==1){
				reg_st=2;
				f_repeate={_obj:connection,_fnc:connection.connect,_prm:[],_count:0};
				connection.connect(0);
				//connection.getRegistrationFields();
			}else if(reg_st==3){
				f_repeate={_obj:connection,_fnc:connection.connect,_prm:[],_count:0};
				connection.connect(0);
			}else{
				room_exit(0,null,0,1);
				room_exit(1,null,0,1);
				room_exit(2,null,0,1);
				if(stg_class.m_mode!=3){
					setTimeout(function(){
						_join=[gr_name];
						onCreationComplete();
					},3000);
				}
			}
		}
		
		private var tmAlive:Timer;
		
		private function isConnect(e:ConnectionSuccessEvent):void{
			conTmReset();
			try{
				tmAlive.reset();
			}catch(er:Error){
				
			}
			tmAlive.start();
			addMess(gr_name,"<b>"+"<font color=\"#999999\" size=\"10\">"+"isConnect"+"</font>"+"</b> "+"\n");
			if(reg_st==2){
				f_repeate={_obj:connection,_fnc:connection.getRegistrationFields,_prm:[],_count:0};
				connection.getRegistrationFields();
			}
		}
		
		private function onRegistrationFields(e:RegistrationFieldsEvent):void{
			addMess(gr_name,"<b>"+"<font color=\"#999999\" size=\"10\">"+"Получение списка данных, необходимых для регистрации"+"</font>"+"</b> "+"\n");
			//trace(e.fields);
			//trace(e.data.getRequiredFieldNames());
			var _regExt:RegisterExtension=e.data;
			var _ar:Array=_regExt.getRequiredFieldNames();
			var _obj:Object=new Object();
			var _b:Boolean=false;
			for(var i:int=0;i<_ar.length;i++){
				_ar[i]=[_ar[i],_regExt.getField(String(_ar[i]))];
				if(_ar[i][1]==null){
					_obj[_ar[i][0]+""]=this[_ar[i][0]+""];
					_b=true;
					//trace(_obj[_ar[i][0]+""]+"   "+(_ar[i][0]+""));
				}
			}
			//trace(_ar);
			if(_b){
				f_repeate={_obj:connection,_fnc:connection.sendRegistrationFields,_prm:[_obj,_obj["key"]],_count:0};
				connection.sendRegistrationFields(_obj,_obj["key"]);
			}
			//trace(connection["socket"].localPort);
			//root["get_tx"].appendText("isConnect\n\n");
		}
		
		private var f_repeate:Object;
		private var reg_st:int=0;
		
		private function onError(e:XIFFErrorEvent):void{
			var _str:String="Error Code="+e.errorCode+" Type="+e.errorType+" Ext="+e.errorExt+" Condition="+e.errorCondition+" ErrorMess="+e.errorMessage;
			//addMess(gr_name,"<b>"+"<font color=\"#ff0000\" size=\"10\">"+_str+"</font>"+"</b> "+"\n");
			if(int(e.errorCode)==401){
				/*if(reg_st==0){
					reg_st=1;
				}*/
			}else if(e.errorType=="wait"){
				if(f_repeate!=null&&f_repeate._count<3){
					setTimeout(function(){
						f_repeate._count++;
						f_repeate._fnc.apply(f_repeate._obj,f_repeate._prm);
					},3000);
				}else{
					f_repeate=null;
				}
			}
		}
	}
}