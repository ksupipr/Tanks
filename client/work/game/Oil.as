package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Oil extends MovieClip{
		
		public var health1:int=100;
		public var health:int=100;
		public var _type:int=100;
		public var t_cl:MovieClip=new MovieClip();
		public var player:Boolean=false;
		public var _over:int=0;
		public var x_pos:int;
		public var y_pos:int;
		public var pos_in_map:int;
		public var _num:int=0;
		public var pict:Bitmap;
		
		public function Oil(_i:int){
			super();
			stop();
			setFrames(_i);
		}
		
		public function overTest(){
			if(_over>0){
				var _mw=pict.bitmapData.width;
				var _mh=pict.bitmapData.height;
				if(_over==2){
					//trace(_mw+"   "+_mh+"   "+width+"   "+height+"   "+myStage.ov_ar[0]+"   "+myStage.ov_ar[1]+"   "+myStage.ov_ar[2]);
					var shp:Shape = new Shape();
					var mtrx:Matrix = new Matrix();
					mtrx.createGradientBox(_mw, _mh, 0, 0, 0);
					shp.graphics.beginGradientFill(GradientType.RADIAL, myStage.ov_ar[0], myStage.ov_ar[1], myStage.ov_ar[2], mtrx, "pad", "rgb", 0);
					shp.graphics.drawRect(0, 0, _mw, _mh);
					shp.graphics.endFill();
					var bmd2:BitmapData = new BitmapData(_mw, _mh, true, 0x00ffffff);
					var bmd3:BitmapData = pict.bitmapData.clone();
					bmd2.draw(shp);
					var pt:Point = new Point(0, 0);
					var mult:uint = 0xff; // 0x80 = 50%
					bmd3.copyPixels(bmd2, new Rectangle(0,0,_mw, _mh), pt, bmd3, pt, true);
					graphics.clear();
					graphics.beginBitmapFill(bmd3);
					graphics.drawRect(0, 0, _mw, _mh);
				}else{
					graphics.clear();
					graphics.beginBitmapFill(pict.bitmapData);
					graphics.drawRect(0, 0, _mw, _mh);
					_over=0;
				}
			}
		}
		
		public function setFrames(_i:int){
			//trace("a   "+myStage.images.length);
			//trace(_i);
			if(_i==0){
				pict=new Bitmap(myStage.lib.png.oil.bitmapData.clone());
			}else{
				pict=new Bitmap(myStage.lib.png.oil1.bitmapData.clone());
			}
			graphics.beginBitmapFill(pict.bitmapData);
			graphics.drawRect(0, 0, pict.width, pict.height);
			addChild(t_cl);
			//addEventListener(Event.ENTER_FRAME, render);
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
					t_cl.graphics.drawRect(width/2-15,4,30,3);
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
					t_cl.graphics.drawRect(width/2-15,-5,30,3);
					t_cl.graphics.beginFill(0xff0000,1);
					t_cl.graphics.lineStyle(1, 0x4e1602, 1);
				}
				t_cl.graphics.drawRect(width/2-15,4,(health/health1)*30,3);
			}
		}
	}
	
}