package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	
	public class Radar extends MovieClip{
		
		public var mskin_s:String="ra_frames";
		//public var img:MovieClip=new MovieClip();
		//public var clip:Array=new Array();
		public var frame:int=0;
		public var health1:int=100;
		public var health:int=100;
		public var _type:int=100;
		public var t_cl:MovieClip=new MovieClip();
		public var player:Boolean=false;
		public var _over:int=0;
		public var x_pos:int;
		public var y_pos:int;
		public var pos_in_map:int;
		
		public function overTest(){
			if(_over>0){
				var _mw=Tank[mskin_s][frame].bitmapData.width;
				var _mh=Tank[mskin_s][frame].bitmapData.height;
				if(_over==2){
					//trace(_mw+"   "+_mh+"   "+width+"   "+height+"   "+myStage.ov_ar[0]+"   "+myStage.ov_ar[1]+"   "+myStage.ov_ar[2]);
					var shp:Shape = new Shape();
					var mtrx:Matrix = new Matrix();
					mtrx.createGradientBox(_mw, _mh, 0, 0, 0);
					shp.graphics.beginGradientFill(GradientType.RADIAL, myStage.ov_ar[0], myStage.ov_ar[1], myStage.ov_ar[2], mtrx, "pad", "rgb", 0);
					shp.graphics.drawRect(0, 0, _mw, _mh);
					shp.graphics.endFill();
					var bmd2:BitmapData = new BitmapData(_mw, _mh, true, 0x00ffffff);
					var bmd3:BitmapData = Tank[mskin_s][frame].bitmapData.clone();
					bmd2.draw(shp);
					var pt:Point = new Point(0, 0);
					var mult:uint = 0xff; // 0x80 = 50%
					bmd3.copyPixels(bmd2, new Rectangle(0,0,_mw, _mh), pt, bmd3, pt, true);
					graphics.clear();
					graphics.beginBitmapFill(bmd3);
					graphics.drawRect(0, 0, _mw, _mh);
				}else{
					graphics.clear();
					graphics.beginBitmapFill(Tank[mskin_s][frame].bitmapData);
					graphics.drawRect(0, 0, _mw, _mh);
					_over=0;
				}
			}
		}
		
		public function Radar(){
			super();
			stop();
			frame=Math.floor(Math.abs(Math.random()*10)+1);
			setFrames();
			/*addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent){
				_over=2;
				Mouse.cursor=MouseCursor.BUTTON;
			});
			addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent){
				_over=1;
				Mouse.cursor=MouseCursor.AUTO;
			});*/
		}
		
		public function setFrames(){
			graphics.beginBitmapFill(Tank[mskin_s][frame].bitmapData);
			graphics.drawRect(0, 0, 48, 48);
			addChild(t_cl);
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		public function healthTest(){
			if(health1>0){
				t_cl.graphics.clear();
				/*if(health>(health1/3)*2){
					//graphics.beginFill(0x00ff36,1);
					sm_c=0;
				}else if(health>health1/3){
					//graphics.beginFill(0xfffc00,1);
					sm_c=6;
				}else{
					//graphics.beginFill(0xff0000,1);
					sm_c=3;
				}*/
				if(health<0){
					health=0;
				}
				//trace("Radar_health   "+health1+"   "+health+"   "+myStage.tank_type+"   "+myStage.self_battle+"   "+_type);
				if(!myStage.self_battle){
					if(myStage.tank_type!=_type){
						t_cl.graphics.beginFill(0x4e1602,.4);
						t_cl.graphics.lineStyle(1, 0x4e1602, 1);
					}else{
						t_cl.graphics.beginFill(0x143306,.4);
						t_cl.graphics.lineStyle(1, 0x143306, 1);
					}
					t_cl.graphics.drawRect(10,4,30,3);
					if(myStage.tank_type!=_type){
						t_cl.graphics.beginFill(0xff0000,1);
						t_cl.graphics.lineStyle(1, 0x4e1602, 1);
					}else{
						t_cl.graphics.beginFill(0x00ff36,1);
						t_cl.graphics.lineStyle(1, 0x143306, 1);
					}
				}else{
					t_cl.graphics.beginFill(0x4e1602,.4);
					t_cl.graphics.lineStyle(1, 0x4e1602, 1);
					t_cl.graphics.drawRect(10,-5,30,3);
					t_cl.graphics.beginFill(0xff0000,1);
					t_cl.graphics.lineStyle(1, 0x4e1602, 1);
				}
				t_cl.graphics.drawRect(10,4,(health/health1)*30,3);
			}
		}
		
		public function render(event:Event){
			if(!myStage.self["rad_on"]){
				return;
			}
			graphics.clear();
			frame++;
			if(frame==12){
				frame=0;
			}
			graphics.beginBitmapFill(Tank[mskin_s][frame].bitmapData);
			graphics.drawRect(0, 0, 48, 48);
			//graphics.endFill();
			overTest();
		}
	}
	
}