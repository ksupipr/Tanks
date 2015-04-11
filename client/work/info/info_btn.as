package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;
	
	public class info_btn extends MovieClip{
		
		private static var stg_cl:MovieClip;
		private static var stg_class:Class;
		
		public static var info_cl:MovieClip;
		public static var messTmUp:Timer=new Timer(100);
		public static var messTmDn:Timer=new Timer(100);
		
		public function init_f(cl:MovieClip){
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public function setParCl(_cl:MovieClip){
			info_cl=_cl;
		}
		
		public function info_btn() {
			super();
			stop();
			//stg_cl=info.stg_cl;
			//stg_class=info.stg_class;
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
			addEventListener(MouseEvent.CLICK, m_click);
			
			if(name=="exit_cl"){
				messTmUp.addEventListener(TimerEvent.TIMER, arrowUpMess);
				messTmDn.addEventListener(TimerEvent.TIMER, arrowDnMess);
			}
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//trace(stg_cl["wall_win"]+"   "+stg_cl["warn_er"]+"   "+root["ready_cl"].visible);
			if(stg_cl["wall_win"]){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			
			if(name.slice(0,5)=="punkt"){
				if(this["back_cl"].currentFrame<3){
					this["back_cl"].gotoAndStop(2);
				}
			}else if(name.slice(0,8)=="podpunkt"){
				if(this["back_cl"].currentFrame<3){
					this["back_cl"].gotoAndStop(2);
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
			
			if(name.slice(0,5)=="punkt"){
				if(this["back_cl"].currentFrame<3){
					this["back_cl"].gotoAndStop(1);
				}
			}else if(name.slice(0,8)=="podpunkt"){
				if(this["back_cl"].currentFrame<3){
					this["back_cl"].gotoAndStop(1);
				}
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
			if(stg_cl["wall_win"]){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			
			var name_str:String=event.currentTarget.name;
			
			if(name_str=="sc_rect"){
				parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
				if(event.currentTarget.parent.name=="sc_mess"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scMessStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollMess);
				}
			}else if(name_str=="sc_mover"){
				event.currentTarget.x_coor=event.currentTarget.mouseX;
				if(event.currentTarget.parent.name=="sc_mess"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scMessStop);
					stage.addEventListener(Event.ENTER_FRAME, scrollMess);
				}
			}else if(name_str=="to_left"){
				if(event.currentTarget.parent.name=="sc_mess"){
					if(!messTmUp.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowMessStop);
						messTmUp.start();
					}
				}
			}else if(name_str=="to_right"){
				if(event.currentTarget.parent.name=="sc_mess"){
					if(!messTmDn.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowMessStop);
						messTmDn.start();
					}
				}
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
			if(stg_cl["wall_win"]){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			try{
				gotoAndStop("over");
			}catch(er:Error){}
		}
		
		public function m_click(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//trace(stg_cl["wall_win"]+"   "+stg_cl["warn_er"]+"   "+root["ready_cl"].visible);
			if(stg_cl["wall_win"]){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			
			if(name.slice(0,5)=="punkt"){
				if(this["back_cl"].currentFrame<3){
					info._self.drawList(int(name.slice(5,7)));
				}
			}else if(name.slice(0,8)=="podpunkt"){
				if(this["back_cl"].currentFrame<3){
					var _ar:Array=name.split("_");
					info._self.drawList(int(_ar[1]),int(_ar[2]));
				}
			}else if(name=="exit_cl"){
				stg_cl.createMode(1);
			}
			
			try{
				gotoAndStop("over");
			}catch(er:Error){}
		}
		
		public function scMessStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, scMessStop);
				stage.removeEventListener(Event.ENTER_FRAME, scrollMess);
			}catch(er:Error){}
			root["info_win"]["sc_mess"]["sc_mover"].x_coor=null;
			/*Mouse.cursor=MouseCursor.BUTTON;
			try{
				gotoAndStop("over");
			}catch(er:Error){}*/
		}
		
		public function scrollMess(event:Event){
			if(root["info_win"]["sc_mess"].mouseX-root["info_win"]["sc_mess"]["sc_mover"]["x_coor"]<root["info_win"]["sc_mess"]["to_left"].width+4){
				root["info_win"]["sc_mess"]["sc_mover"].x=root["info_win"]["sc_mess"]["to_left"].width+4;
			}else if(root["info_win"]["sc_mess"].mouseX+root["info_win"]["sc_mess"]["sc_mover"].width-root["info_win"]["sc_mess"]["sc_mover"]["x_coor"]>root["info_win"]["sc_mess"].height-root["info_win"]["sc_mess"]["to_left"].width-2){
				root["info_win"]["sc_mess"]["sc_mover"].x=root["info_win"]["sc_mess"].height-root["info_win"]["sc_mess"]["to_left"].width-root["info_win"]["sc_mess"]["sc_mover"].width-2;
			}else{
				root["info_win"]["sc_mess"]["sc_mover"].x=root["info_win"]["sc_mess"].mouseX-root["info_win"]["sc_mess"]["sc_mover"]["x_coor"];
			}
			info_cl.moveMessText(root["info_win"]["sc_mess"]["sc_mover"].x);
			//trace(root["info_win"]["sc_mess"]["sc_mover"].x+"   "+root["info_win"]["sc_mess"]["to_left"].width);
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
			root["info_win"]["sc_mess"]["sc_mover"].x_coor=null;
		}
		
		public function arrowUpMess(event:TimerEvent){
			//trace(root["info_win"]["sc_mess"]["sc_mover"].x+"   "+root["info_win"]["sc_mess"]["sc_mover"].width/4);
			if(root["info_win"]["sc_mess"]["sc_mover"].x-root["info_win"]["sc_mess"]["sc_mover"].width/8<root["info_win"]["sc_mess"]["to_left"].width+4){
				root["info_win"]["sc_mess"]["sc_mover"].x=root["info_win"]["sc_mess"]["to_left"].width+4;
			}else{
				root["info_win"]["sc_mess"]["sc_mover"].x-=root["info_win"]["sc_mess"]["sc_mover"].width/8;
			}
			info_cl.moveMessText(root["info_win"]["sc_mess"]["sc_mover"].x);
		}
		
		public function arrowDnMess(event:TimerEvent){
			//trace(root["info_win"]["sc_mess"]["sc_mover"].x+"   "+root["info_win"]["sc_mess"]["sc_mover"].width/4);
			if(root["info_win"]["sc_mess"]["sc_mover"].x+root["info_win"]["sc_mess"]["sc_mover"].width/8>root["info_win"]["sc_mess"].height-root["info_win"]["sc_mess"]["to_left"].width-root["info_win"]["sc_mess"]["sc_mover"].width-2){
				root["info_win"]["sc_mess"]["sc_mover"].x=root["info_win"]["sc_mess"].height-root["info_win"]["sc_mess"]["to_left"].width-root["info_win"]["sc_mess"]["sc_mover"].width-2;
			}else{
				root["info_win"]["sc_mess"]["sc_mover"].x+=root["info_win"]["sc_mess"]["sc_mover"].width/8;
			}
			info_cl.moveMessText(root["info_win"]["sc_mess"]["sc_mover"].x);
		}
	}
}
