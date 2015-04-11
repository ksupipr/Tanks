package utils{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class FpsMeter extends Sprite {
		private static var SAMPLE_SIZE:int = 2;
		private static var SPRINGNESS:Number = 0.05;
		
		private var _dragRect:Rectangle = null;
		private var _isDragging:Boolean = false;
		private var max_fps:int = 0;
		private var _fps:Number = 0;
		private var _diff:Number = 0;
		private var s_fps:String = "";
		private var _time : int;
		private var _ms : int;
		private var _counter:int = 0;
		private var _bytes:Number = 0;
		private var t_bytes:String = "b";
		private var s_bytes:String = "b";
		private var _fpsTxt : TextField=new TextField();
		private var _text : String="FPS:             \nMEMORY:                         ";
		
		public function FpsMeter() {
			_fpsTxt.defaultTextFormat=new TextFormat("Verdana",11);
			_fpsTxt.autoSize=TextFieldAutoSize.LEFT;
			_fpsTxt.text=_text;
			_fpsTxt.width=_fpsTxt.textWidth;
			_fpsTxt.height=_fpsTxt.textHeight;
			_fpsTxt.x=_fpsTxt.y=5;
			_fpsTxt.mouseEnabled=false;
			var _gr:Graphics=graphics;
			_gr.beginFill(0xffffff,.7);
			_gr.lineStyle(1,0x000000,1);
			_gr.drawRect(0,0,_fpsTxt.width+10,_fpsTxt.height+10);
			addChild(_fpsTxt);
			addEventListener(Event.ADDED_TO_STAGE, on_added);
		}
		
		public function on_added(e : Event):void{
			_ms=_time=new Date().time;
			max_fps=_fps=stage.frameRate;
			SAMPLE_SIZE=Math.ceil(max_fps/10);
			removeEventListener(Event.ADDED_TO_STAGE, on_added);
			addEventListener(Event.ENTER_FRAME, on_enter_frame);
			addEventListener(MouseEvent.MOUSE_DOWN,_startDrag);
			addEventListener(MouseEvent.MOUSE_UP,_stopDrag);
		}
		
		private function _startDrag(e:MouseEvent):void{
			_dragRect=new Rectangle(0,0,stage.stageWidth-width,stage.stageHeight-height);
			if(!_isDragging){
				startDrag(false,_dragRect);
				_isDragging=true;
			}
		}
		
		private function _stopDrag(e:MouseEvent):void{
			if(_isDragging){
				stopDrag();
				_isDragging=false;
			}
		}
		
		public function on_enter_frame(e : Event):void{
			// calculate the FPS on SAMPLE_SIZE instance
			if(_counter++ == SAMPLE_SIZE){
				_time = new Date().time;
				if(_time>_ms){
					_diff=(1000/((_time-_ms)/_counter)-_fps);
					//_diff=(_diff/Math.abs(_diff))*.1;
					_diff*=.1;
					/*if(Math.abs(_diff)>.1){
						if(_diff<0){
							_diff=-1;
						}else{
							_diff=1;
						}
					}else if(Math.abs(_diff)<.1){
						if(_diff<0){
							_diff=-0.1;
						}else{
							_diff=0.1;
						}
					}*/
					_fps+=_diff;
					_ms=_time;
				}else{
					_ms=_time;
				}
				_bytes=System.totalMemoryNumber;
				if(_bytes>1048576){
					_bytes/=1048576;
					t_bytes=" mb";
					_counter=8;
				}else if(_bytes>1024){
					_bytes/=1024;
					t_bytes=" kb";
					_counter=8;
				}else{
					t_bytes=" b";
					_counter=4;
				}
				s_bytes=(_bytes).toString().substr(0, _counter);
				/*while(s_bytes.length<8){
					s_bytes+=" ";
				}*/
				s_bytes+=t_bytes;
				_counter = 0;
				s_fps=_fps.toString().substr(0, 4);
				if(s_fps.length==2){
					s_fps+=".0";
				}
				_text = "FPS: " + s_fps+"/"+max_fps+"\n";
				_text += "MEMORY: " + s_bytes;
				_fpsTxt.text=_text;
			}
			
		}
		
	}
}
