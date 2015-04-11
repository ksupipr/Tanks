package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;
	
	public class f_list_btn extends MovieClip{
		
		private static var list_cl:MovieClip;
		public static var listTmUp:Timer=new Timer(25);
		public static var listTmDn:Timer=new Timer(25);
		
		public function setParCl(_cl:MovieClip){
			list_cl=_cl;
			listTmUp.addEventListener(TimerEvent.TIMER, arrowUpList);
			listTmDn.addEventListener(TimerEvent.TIMER, arrowDnList);
		}
		
		public function f_list_btn(){
			super();
			stop();
			
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
			addEventListener(MouseEvent.CLICK, m_click);
		}
		
		public function m_over(event:MouseEvent){
			if(currentFrameLabel=="empty"){
				return;
			}
			var name_str:String=event.currentTarget.name;
			
			
			
			Mouse.cursor=MouseCursor.BUTTON;
			try{
				gotoAndStop("over");
			}catch(er:Error){}
		}
		
		public function m_out(event:MouseEvent){
			if(currentFrameLabel=="empty"){
				return;
			}
			var name_str:String=event.currentTarget.name;
			
			Mouse.cursor=MouseCursor.AUTO;
			
			if(name_str=="pochta_b"){
				if(list_cl["messages"]>0){
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
			var name_str:String=event.currentTarget.name;
			
			if(name_str=="sc_rect"){
				parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
				if(event.currentTarget.parent.name=="sc_list"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scListStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollList);
				}
			}else if(name_str=="sc_mover"){
				event.currentTarget.x_coor=event.currentTarget.mouseX;
				if(event.currentTarget.parent.name=="sc_list"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scListStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollList);
				}
			}else if(name_str=="to_left"){
				if(event.currentTarget.parent.name=="sc_list"){
					if(!listTmUp.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowListStop);
						listTmUp.start();
					}
				}
			}else if(name_str=="to_right"){
				if(event.currentTarget.parent.name=="sc_list"){
					if(!listTmDn.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowListStop);
						listTmDn.start();
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
			var name_str:String=event.currentTarget.name;
			
			try{
				gotoAndStop("over");
			}catch(er:Error){}
		}
		
		public function m_click(event:MouseEvent){
			if(currentFrameLabel=="empty"){
				return;
			}
			var name_str:String=event.currentTarget.name;
			
			
		}
		
		public function scListStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, scListStop);
				stage.removeEventListener(Event.ENTER_FRAME, scrollList);
			}catch(er:Error){}
			list_cl["sc_list"]["sc_mover"].x_coor=null;
			/*Mouse.cursor=MouseCursor.BUTTON;
			try{
				gotoAndStop("over");
			}catch(er:Error){}*/
		}
		
		public function scrollList(event:Event){
			if(list_cl["sc_list"].mouseX-list_cl["sc_list"]["sc_mover"]["x_coor"]<list_cl["sc_list"]["to_left"].width+4){
				list_cl["sc_list"]["sc_mover"].x=list_cl["sc_list"]["to_left"].width+4;
			}else if(list_cl["sc_list"].mouseX+list_cl["sc_list"]["sc_mover"].width-list_cl["sc_list"]["sc_mover"]["x_coor"]>list_cl["sc_list"].height-list_cl["sc_list"]["to_left"].width-2){
				list_cl["sc_list"]["sc_mover"].x=list_cl["sc_list"].height-list_cl["sc_list"]["to_left"].width-list_cl["sc_list"]["sc_mover"].width-2;
			}else{
				list_cl["sc_list"]["sc_mover"].x=list_cl["sc_list"].mouseX-list_cl["sc_list"]["sc_mover"]["x_coor"];
			}
			list_cl.scrollList(list_cl["sc_list"]["sc_mover"].x);
			//trace(root["sc_mess"]["sc_mover"].x+"   "+root["sc_mess"]["to_left"].width);
			/*Mouse.cursor=MouseCursor.AUTO;
			try{
				gotoAndStop("out");
			}catch(er:Error){}*/
		}
		
		public function arrowListStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, arrowListStop);
			}catch(er:Error){}
			try{
				listTmUp.reset();
			}catch(er:Error){}
			try{
				listTmDn.reset();
			}catch(er:Error){}
			list_cl["sc_list"]["sc_mover"].x_coor=null;
		}
		
		public function arrowUpList(event:TimerEvent){
			if(list_cl["sc_list"]["sc_mover"].x-list_cl["sc_list"]["sc_mover"].width/25<list_cl["sc_list"]["to_left"].width+4){
				list_cl["sc_list"]["sc_mover"].x=list_cl["sc_list"]["to_left"].width+4;
			}else{
				list_cl["sc_list"]["sc_mover"].x-=list_cl["sc_list"]["sc_mover"].width/25;
			}
			list_cl.scrollList(list_cl["sc_list"]["sc_mover"].x,1);
		}
		
		public function arrowDnList(event:TimerEvent){
			if(list_cl["sc_list"]["sc_mover"].x+list_cl["sc_list"]["sc_mover"].width/25>list_cl["sc_list"].height-list_cl["sc_list"]["to_left"].width-list_cl["sc_list"]["sc_mover"].width-2){
				list_cl["sc_list"]["sc_mover"].x=list_cl["sc_list"].height-list_cl["sc_list"]["to_left"].width-list_cl["sc_list"]["sc_mover"].width-2;
			}else{
				list_cl["sc_list"]["sc_mover"].x+=list_cl["sc_list"]["sc_mover"].width/25;
			}
			list_cl.scrollList(list_cl["sc_list"]["sc_mover"].x,1);
		}
		
	}
}
