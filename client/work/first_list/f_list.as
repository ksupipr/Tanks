package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.geom.Rectangle;
	
	public class f_list extends MovieClip{
		
		private var _self:MovieClip;
		private var sc_name:String="sc_board";
		private var _w:int=563;
		private var _h:int=164;
		private var _step:int=5;
		
		public function sc_reset(){
			root[sc_name].scrollRect=new Rectangle(0, 0, _w, _h);
			root["sc_list"]["sc_mover"].x=root["sc_list"]["to_left"].width+4;
		}
		
		public function f_list(){
			super();
			stop();
			Security.allowDomain("*");
			_self=this;
			//trace(root[sc_name].height+"   "+_h);
			var _W:int=0;
			root[sc_name].graphics.clear();
			root[sc_name].graphics.beginFill(0x990000,0);
			root[sc_name].graphics.drawRect(0,0,root[sc_name].width,root[sc_name].height);
			if(root[sc_name].height>_h){
				root["sc_list"].visible=true;
				root["sc_list"]["sc_rect"].graphics.clear();
				root["sc_list"]["sc_rect"].graphics.lineStyle(1,0x9A0700);
				root["sc_list"]["sc_rect"].graphics.beginFill(0xFCE3C5);
				root["sc_list"]["sc_rect"].graphics.drawRect(root["sc_list"]["to_left"].width+2,1,_h-(root["sc_list"]["to_left"].width*2+3),root["sc_list"]["to_left"].height-1);
				root["sc_list"]["to_right"].x=root["sc_list"]["sc_rect"].width+root["sc_list"]["to_right"].width*2+3;
				
				root["sc_list"].visible=true;
				_W=(_h/root[sc_name].height)*(root["sc_list"]["sc_rect"].width-4);
				if(_W<9){
					_W=9;
				}
				root["sc_list"]["sc_mover"]["sc_fill"].graphics.clear();
				root["sc_list"]["sc_mover"]["sc_fill"].graphics.beginFill(0x990000);
				root["sc_list"]["sc_mover"]["sc_fill"].graphics.drawRect(0,2,_W,11);
				root["sc_list"]["sc_mover"]["sc_zn"].x=Math.round(_W/2)-.5;
				root["sc_list"]["sc_mover"].x=root["sc_list"]["to_left"].width+4;
				root[sc_name].addEventListener(MouseEvent.MOUSE_WHEEL, scrollListM);
			}else{
				root["sc_list"].visible=false;
			}
			root[sc_name]._H=root[sc_name].height;
			root[sc_name].scrollRect=new Rectangle(0, 0, _w, _h);
			root["sc_list"]["to_right"].setParCl(_self);
		}
		
		public function scrollListM(event:MouseEvent):void{
			//trace(event.delta);
			var rect:Rectangle=root[sc_name].scrollRect;
			var _sc:int=rect.y-event.delta*_step;
			//trace(rect.y+"   "+event.delta+"   "+_sc+"   "+root[sc_name].height+"   "+rect.height);
			if(_sc<0){
				_sc=0;
			}else if(_sc>root[sc_name]._H-rect.height){
				_sc=root[sc_name]._H-rect.height;
			}
			//trace(event.delta+"   "+_sc);
			rect.y=_sc;
			root[sc_name].scrollRect=rect;
			root["sc_list"]["sc_mover"].x=(rect.y/root[sc_name]._H)*((root["sc_list"]["sc_rect"].width-8))+root["sc_list"]["to_left"].width+4;
		}
		
		public function scrollList(Y:Number,_i:int=0):void{
			var rect:Rectangle=root[sc_name].scrollRect;
			rect.y=((Y-root["sc_list"]["to_left"].width-4)/(root["sc_list"]["sc_rect"].width-root["sc_list"]["sc_mover"].width))*(root[sc_name]._H-rect.height)*1.060;
			root[sc_name].scrollRect=rect;
		}

	}
	
}
