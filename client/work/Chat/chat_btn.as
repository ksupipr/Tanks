package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class chat_btn extends MovieClip{
		
		public static var chat_cl:MovieClip;
		public static var messTmUp:Timer=new Timer(100);
		public static var messTmDn:Timer=new Timer(100);
		public static var usTmUp:Timer=new Timer(100);
		public static var usTmDn:Timer=new Timer(100);
		public static var pchtTmUp:Timer=new Timer(100);
		public static var pchtTmDn:Timer=new Timer(100);
		
		public function setParCl(_cl:MovieClip){
			chat_cl=_cl;
		}
		
		public function chat_btn() {
			super();
			stop();
			
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
			addEventListener(MouseEvent.CLICK, m_click);
			if(name=="rootGroup"){
				messTmUp.addEventListener(TimerEvent.TIMER, arrowUpMess);
				messTmDn.addEventListener(TimerEvent.TIMER, arrowDnMess);
				usTmUp.addEventListener(TimerEvent.TIMER, arrowUpUs);
				usTmDn.addEventListener(TimerEvent.TIMER, arrowDnUs);
				pchtTmUp.addEventListener(TimerEvent.TIMER, arrowUpPcht);
				pchtTmDn.addEventListener(TimerEvent.TIMER, arrowDnPcht);
			}
		}
		
		public function m_over(event:MouseEvent){
			if(currentFrameLabel=="empty"){
				return;
			}
			if(event.currentTarget["name_gr"]!=null){
				return;
			}
			var name_str:String=event.currentTarget.name;
			
			if(chat_cl.stg_class.help_on){
				if(name_str=="pochta_b"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="to_battle"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="pochta_out"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="read_mess"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="close_mess"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="send_b"){
					
				}else if(name_str=="clear_b"){
					
				}else if(name_str=="rect_b"){
					
				}else{
					return;
				}
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
			if(event.currentTarget["name_gr"]!=null){
				return;
			}
			var name_str:String=event.currentTarget.name;
			
			Mouse.cursor=MouseCursor.AUTO;
			
			if(name_str=="pochta_b"){
				if(chat_cl["messages"]>0){
					gotoAndPlay("out");
				}else{
					gotoAndStop("out");
				}
				return;
			}
			
			try{
				gotoAndStop("out");
			}catch(er:Error){}
		}
		
		public function m_press(event:MouseEvent){
			if(currentFrameLabel=="empty"){
				return;
			}
			if(event.currentTarget["name_gr"]!=null){
				return;
			}
			var name_str:String=event.currentTarget.name;
			
			if(chat_cl.stg_class.help_on){
				if(name_str=="pochta_b"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="to_battle"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="pochta_out"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="read_mess"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="close_mess"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="send_b"){
					
				}else if(name_str=="clear_b"){
					
				}else if(name_str=="rect_b"){
					
				}else{
					return;
				}
			}
			
			if(name_str=="sc_rect"){
				parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
				if(event.currentTarget.parent.name=="sc_mess"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scMessStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollMess);
				}else if(event.currentTarget.parent.name=="sc_us"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scUsStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollUs);
				}else if(event.currentTarget.parent.name=="sc_pochta"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scPchtStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollPcht);
				}
			}else if(name_str=="sc_mover"){
				event.currentTarget.x_coor=event.currentTarget.mouseX;
				if(event.currentTarget.parent.name=="sc_mess"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scMessStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollMess);
				}else if(event.currentTarget.parent.name=="sc_us"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scUsStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollUs);
				}else if(event.currentTarget.parent.name=="sc_pochta"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scPchtStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollPcht);
				}
			}else if(name_str=="to_left"){
				if(event.currentTarget.parent.name=="sc_mess"){
					if(!messTmUp.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowMessStop);
						messTmUp.start();
					}
				}else if(event.currentTarget.parent.name=="sc_us"){
					if(!usTmUp.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowUsStop);
						usTmUp.start();
					}
				}else if(event.currentTarget.parent.name=="sc_pochta"){
					if(!pchtTmUp.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowPchtStop);
						pchtTmUp.start();
					}
				}
			}else if(name_str=="to_right"){
				if(event.currentTarget.parent.name=="sc_mess"){
					if(!messTmDn.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowMessStop);
						messTmDn.start();
					}
				}else if(event.currentTarget.parent.name=="sc_us"){
					if(!usTmDn.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowUsStop);
						usTmDn.start();
					}
				}else if(event.currentTarget.parent.name=="sc_pochta"){
					if(!pchtTmDn.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowPchtStop);
						pchtTmDn.start();
					}
				}
			}
			
			try{
				gotoAndStop("press");
			}catch(er:Error){}
		}
		
		public function m_release(event:MouseEvent){
			if(currentFrameLabel=="empty"){
				return;
			}
			if(event.currentTarget["name_gr"]!=null){
				return;
			}
			var name_str:String=event.currentTarget.name;
			
			if(chat_cl.stg_class.help_on){
				if(name_str=="pochta_b"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="to_battle"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="pochta_out"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="read_mess"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="close_mess"){
					if(chat_cl.stg_class.help_st!=1){
						return;
					}
				}else if(name_str=="send_b"){
					
				}else if(name_str=="clear_b"){
					
				}else if(name_str=="rect_b"){
					
				}else{
					return;
				}
			}
			
			try{
				gotoAndStop("over");
			}catch(er:Error){}
		}
		
		public function m_click(event:MouseEvent){
			if(currentFrameLabel=="empty"){
				return;
			}
			var name_str:String=event.currentTarget.name;
			
			if(chat_cl.stg_class.help_on){
				if(name_str=="pochta_b"){
					if(chat_cl.stg_class.help_st==1){
						chat_cl.stg_class.help_cl["lesson"+1].visible=false;
					}else{
						return;
					}
				}else if(name_str=="to_battle"){
					if(chat_cl.stg_class.help_st==1){
						
					}else{
						return;
					}
				}else if(name_str=="pochta_out"){
					if(chat_cl.stg_class.help_st==1){
						chat_cl.stg_class.help_cl["lesson"+1].visible=true;
					}else{
						return;
					}
				}else if(name_str=="read_mess"){
					if(chat_cl.stg_class.help_st==1){
						
					}else{
						return;
					}
				}else if(name_str=="close_mess"){
					if(chat_cl.stg_class.help_st==1){
						
					}else{
						return;
					}
				}else if(name_str=="send_b"){
					
				}else if(name_str=="clear_b"){
					
				}else if(name_str=="rect_b"){
					
				}else{
					return;
				}
			}
			
			if(name_str=="show_sm"){
				/*if(chat_cl["_log"]==0){
					chat_cl.setLog(0);
				}else{
					chat_cl.setLog(1);
				}*/
			}else if(name_str=="to_battle"){
				var id_str:String="<query id=\"3\"><action id=\"11\">";
				id_str+="<battle id=\""+event.currentTarget["ID"]+"\" />";
				id_str+="</action></query>";
				chat_cl.last_bttl=id_str;
				chat_cl.sendCombats(id_str,true,0);
			}else if(name_str=="sort1"){
				chat_cl.sortUs(1);
			}else if(name_str=="sort2"){
				chat_cl.sortUs(2);
			}else if(name_str=="pochta_out"){
				chat_cl.closePochta();
			}else if(name_str=="pochta_b"){
				chat_cl.openPochta();
			}else if(name_str=="read_mess"){
				chat_cl.openMess(this["ID"]);
			}else if(name_str=="close_mess"){
				chat_cl.closeMess(this["ID"]);
			}else if(name_str=="us_menu"){
				chat_cl.show_us_menu(this["ID"]);
			}else if(name_str=="send_ban"){
				chat_cl.send_ban_mess();
			}else if(name_str=="rect_b"){
				chat_cl.show_ban_win();
			}else if(name_str=="close_ban"){
				chat_cl.hide_ban_win();
			}else if(name_str=="clear_b"){
				chat_cl.unPriv();
			}else if(name_str=="max_b"){
				chat_cl._maximize();
			}else if(name_str=="min_b"){
				chat_cl._minimize();
			}else if(name_str=="users_b"){
				chat_cl.showList();
			}else if(name_str=="close_cl"){
				chat_cl.hideList();
			}else if(name_str=="send_b"){
				chat_cl.sendMess();
			}else if(name_str=="priv_us"){
				chat_cl.show_us_menu();
			}else if(name_str=="call1"){
				chat_cl.removeChild(chat_cl["us_win"]);
				chat_cl["stg_cl"].getClass(chat_cl["stg_cl"]).stat_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["7"],["1",parent["ID"]+""]]);
			}else if(name_str=="call2"){
				chat_cl.removeChild(chat_cl["us_win"]);
				chat_cl["stg_cl"].getClass(chat_cl["stg_cl"]).stat_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["7"],["3",parent["ID"]+""]]);
			}else if(name_str=="call3"){
				chat_cl.removeChild(chat_cl["us_win"]);
				chat_cl["stg_cl"].getClass(chat_cl["stg_cl"]).stat_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["9"],["3",parent["ID"]+""]]);
			}else if(name_str=="us_link"){
				//trace(parent["us_menu"]["ID"]);
				chat_cl.get_user(parent["us_menu"]["ID"].split("♣")[0]);
				//chat_cl.get_card(parent["us_menu"]["_rn"],parent["us_menu"]["ID"]);
			}else if(name_str=="rootGroup"||name_str=="reid"||name_str=="polk"){
				if(event.currentTarget.currentFrameLabel!="over"){
					return;
				}
				chat_cl.changeRoom(event.currentTarget["name_gr"]);
				//chat_cl.setVkl(name_str);
			}
		}
		
		public function scMessStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, scMessStop);
				stage.removeEventListener(Event.ENTER_FRAME, scrollMess);
			}catch(er:Error){}
			root["sc_mess"]["sc_mover"].x_coor=null;
			/*Mouse.cursor=MouseCursor.BUTTON;
			try{
				gotoAndStop("over");
			}catch(er:Error){}*/
		}
		
		public function scrollMess(event:Event){
			if(root["sc_mess"].mouseX-root["sc_mess"]["sc_mover"]["x_coor"]<root["sc_mess"]["to_left"].width+4){
				root["sc_mess"]["sc_mover"].x=root["sc_mess"]["to_left"].width+4;
			}else if(root["sc_mess"].mouseX+root["sc_mess"]["sc_mover"].width-root["sc_mess"]["sc_mover"]["x_coor"]>root["sc_mess"].height-root["sc_mess"]["to_left"].width-2){
				root["sc_mess"]["sc_mover"].x=root["sc_mess"].height-root["sc_mess"]["to_left"].width-root["sc_mess"]["sc_mover"].width-2;
			}else{
				root["sc_mess"]["sc_mover"].x=root["sc_mess"].mouseX-root["sc_mess"]["sc_mover"]["x_coor"];
			}
			chat_cl.moveMessText(root["sc_mess"]["sc_mover"].x);
			//trace(root["sc_mess"]["sc_mover"].x+"   "+root["sc_mess"]["to_left"].width);
			/*Mouse.cursor=MouseCursor.AUTO;
			try{
				gotoAndStop("out");
			}catch(er:Error){}*/
		}
		
		public function arrowMessStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, arrowMessStop);
			}catch(er:Error){}
			try{
				messTmUp.reset();
			}catch(er:Error){}
			try{
				messTmDn.reset();
			}catch(er:Error){}
			root["sc_mess"]["sc_mover"].x_coor=null;
		}
		
		public function arrowUpMess(event:TimerEvent){
			//trace(root["sc_mess"]["sc_mover"].x+"   "+root["sc_mess"]["sc_mover"].width/4);
			if(root["sc_mess"]["sc_mover"].x-root["sc_mess"]["sc_mover"].width/8<root["sc_mess"]["to_left"].width+4){
				root["sc_mess"]["sc_mover"].x=root["sc_mess"]["to_left"].width+4;
			}else{
				root["sc_mess"]["sc_mover"].x-=root["sc_mess"]["sc_mover"].width/8;
			}
			chat_cl.moveMessText(root["sc_mess"]["sc_mover"].x);
		}
		
		public function arrowDnMess(event:TimerEvent){
			//trace(root["sc_mess"]["sc_mover"].x+"   "+root["sc_mess"]["sc_mover"].width/4);
			if(root["sc_mess"]["sc_mover"].x+root["sc_mess"]["sc_mover"].width/8>root["sc_mess"].height-root["sc_mess"]["to_left"].width-root["sc_mess"]["sc_mover"].width-2){
				root["sc_mess"]["sc_mover"].x=root["sc_mess"].height-root["sc_mess"]["to_left"].width-root["sc_mess"]["sc_mover"].width-2;
			}else{
				root["sc_mess"]["sc_mover"].x+=root["sc_mess"]["sc_mover"].width/8;
			}
			chat_cl.moveMessText(root["sc_mess"]["sc_mover"].x);
		}
		
		public function scUsStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, scUsStop);
				stage.removeEventListener(Event.ENTER_FRAME, scrollUs);
			}catch(er:Error){}
			chat_cl["us_list"]["sc_us"]["sc_mover"].x_coor=null;
			/*Mouse.cursor=MouseCursor.BUTTON;
			try{
				gotoAndStop("over");
			}catch(er:Error){}*/
		}
		
		public function scrollUs(event:Event){
			if(chat_cl["us_list"]["sc_us"].mouseX-chat_cl["us_list"]["sc_us"]["sc_mover"]["x_coor"]<chat_cl["us_list"]["sc_us"]["to_left"].width+4){
				chat_cl["us_list"]["sc_us"]["sc_mover"].x=chat_cl["us_list"]["sc_us"]["to_left"].width+4;
			}else if(chat_cl["us_list"]["sc_us"].mouseX+chat_cl["us_list"]["sc_us"]["sc_mover"].width-chat_cl["us_list"]["sc_us"]["sc_mover"]["x_coor"]>chat_cl["us_list"]["sc_us"].height-chat_cl["us_list"]["sc_us"]["to_left"].width-2){
				chat_cl["us_list"]["sc_us"]["sc_mover"].x=chat_cl["us_list"]["sc_us"].height-chat_cl["us_list"]["sc_us"]["to_left"].width-chat_cl["us_list"]["sc_us"]["sc_mover"].width-2;
			}else{
				chat_cl["us_list"]["sc_us"]["sc_mover"].x=chat_cl["us_list"]["sc_us"].mouseX-chat_cl["us_list"]["sc_us"]["sc_mover"]["x_coor"];
			}
			chat_cl.moveUsList(chat_cl["us_list"]["sc_us"]["sc_mover"].x);
			//trace(root["sc_mess"]["sc_mover"].x+"   "+root["sc_mess"]["to_left"].width);
			/*Mouse.cursor=MouseCursor.AUTO;
			try{
				gotoAndStop("out");
			}catch(er:Error){}*/
		}
		
		public function arrowUsStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, arrowUsStop);
			}catch(er:Error){}
			try{
				usTmUp.reset();
			}catch(er:Error){}
			try{
				usTmDn.reset();
			}catch(er:Error){}
			chat_cl["us_list"]["sc_us"]["sc_mover"].x_coor=null;
		}
		
		public function arrowUpUs(event:TimerEvent){
			if(chat_cl["us_list"]["sc_us"]["sc_mover"].x-chat_cl["us_list"]["sc_us"]["sc_mover"].width/8<chat_cl["us_list"]["sc_us"]["to_left"].width+4){
				chat_cl["us_list"]["sc_us"]["sc_mover"].x=chat_cl["us_list"]["sc_us"]["to_left"].width+4;
			}else{
				chat_cl["us_list"]["sc_us"]["sc_mover"].x-=chat_cl["us_list"]["sc_us"]["sc_mover"].width/8;
			}
			chat_cl.moveUsList(chat_cl["us_list"]["sc_us"]["sc_mover"].x,1);
		}
		
		public function arrowDnUs(event:TimerEvent){
			if(chat_cl["us_list"]["sc_us"]["sc_mover"].x+chat_cl["us_list"]["sc_us"]["sc_mover"].width/8>chat_cl["us_list"]["sc_us"].height-chat_cl["us_list"]["sc_us"]["to_left"].width-chat_cl["us_list"]["sc_us"]["sc_mover"].width-2){
				chat_cl["us_list"]["sc_us"]["sc_mover"].x=chat_cl["us_list"]["sc_us"].height-chat_cl["us_list"]["sc_us"]["to_left"].width-chat_cl["us_list"]["sc_us"]["sc_mover"].width-2;
			}else{
				chat_cl["us_list"]["sc_us"]["sc_mover"].x+=chat_cl["us_list"]["sc_us"]["sc_mover"].width/8;
			}
			chat_cl.moveUsList(chat_cl["us_list"]["sc_us"]["sc_mover"].x,1);
		}
		
		public function scPchtStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, scPchtStop);
				stage.removeEventListener(Event.ENTER_FRAME, scrollPcht);
			}catch(er:Error){}
			chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x_coor=null;
			/*Mouse.cursor=MouseCursor.BUTTON;
			try{
				gotoAndStop("over");
			}catch(er:Error){}*/
		}
		
		public function scrollPcht(event:Event){
			if(chat_cl["pochta_win"]["sc_pochta"].mouseX-chat_cl["pochta_win"]["sc_pochta"]["sc_mover"]["x_coor"]<chat_cl["pochta_win"]["sc_pochta"]["to_left"].width+4){
				chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x=chat_cl["pochta_win"]["sc_pochta"]["to_left"].width+4;
			}else if(chat_cl["pochta_win"]["sc_pochta"].mouseX+chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].width-chat_cl["pochta_win"]["sc_pochta"]["sc_mover"]["x_coor"]>chat_cl["pochta_win"]["sc_pochta"].height-chat_cl["pochta_win"]["sc_pochta"]["to_left"].width-2){
				chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x=chat_cl["pochta_win"]["sc_pochta"].height-chat_cl["pochta_win"]["sc_pochta"]["to_left"].width-chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].width-2;
			}else{
				chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x=chat_cl["pochta_win"]["sc_pochta"].mouseX-chat_cl["pochta_win"]["sc_pochta"]["sc_mover"]["x_coor"];
			}
			chat_cl.scrollMessages(chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x);
			//trace(root["sc_mess"]["sc_mover"].x+"   "+root["sc_mess"]["to_left"].width);
			/*Mouse.cursor=MouseCursor.AUTO;
			try{
				gotoAndStop("out");
			}catch(er:Error){}*/
		}
		
		public function arrowPchtStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, arrowPchtStop);
			}catch(er:Error){}
			try{
				pchtTmUp.reset();
			}catch(er:Error){}
			try{
				pchtTmDn.reset();
			}catch(er:Error){}
			chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x_coor=null;
		}
		
		public function arrowUpPcht(event:TimerEvent){
			if(chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x-chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].width/8<chat_cl["pochta_win"]["sc_pochta"]["to_left"].width+4){
				chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x=chat_cl["pochta_win"]["sc_pochta"]["to_left"].width+4;
			}else{
				chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x-=chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].width/8;
			}
			chat_cl.scrollMessages(chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x,1);
		}
		
		public function arrowDnPcht(event:TimerEvent){
			if(chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x+chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].width/8>chat_cl["pochta_win"]["sc_pochta"].height-chat_cl["pochta_win"]["sc_pochta"]["to_left"].width-chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].width-2){
				chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x=chat_cl["pochta_win"]["sc_pochta"].height-chat_cl["pochta_win"]["sc_pochta"]["to_left"].width-chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].width-2;
			}else{
				chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x+=chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].width/8;
			}
			chat_cl.scrollMessages(chat_cl["pochta_win"]["sc_pochta"]["sc_mover"].x,1);
		}
		
	}
}
