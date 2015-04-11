package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	
	public class Tesla extends MovieClip{
		
		public var mskin_s:String="tsl_frames";
		//public var img:MovieClip=new MovieClip();
		//public var clip:Array=new Array();
		public var frame:int=0;
		public var health1:int=100;
		public var health:int=100;
		public var _type:int=100;
		public var R:int=100;
		public var t_cl:MovieClip=new MovieClip();
		public var player:Boolean=false;
		public var _over:int=0;
		public var x_pos:int;
		public var y_pos:int;
		public var pos_in_map:int;
		public var trgts:Object = new Object();
		public var efx:Object = new Object();
		public var snds:Object = new Object();
		
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
		
		public function Tesla(){
			super();
			stop();
			frame=Math.floor(Math.abs(Math.random()*5)+1);
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
				//trace("Tesla_health   "+health1+"   "+health+"   "+myStage.tank_type+"   "+myStage.self_battle+"   "+_type);
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
			/*if(!myStage.self["rad_on"]){
				return;
			}*/
			graphics.clear();
			frame++;
			if(frame==6){
				frame=0;
			}
			graphics.beginBitmapFill(Tank[mskin_s][frame].bitmapData);
			graphics.drawRect(0, 0, 48, 48);
			//graphics.endFill();
			overTest();
			efx_move();
		}
		
		public function efx_move(){
			for(var str:String in trgts){
				if(trgts[str].stage!=null){
					if(trgts[str].mmove){
						var _sx:int=(trgts[str].x+13)-(x+24);
						var _sy:int=(trgts[str].y+13)-(y+24);
						var _s:int=Math.sqrt(Math.pow(_sx,2)+Math.pow(_sy,2));
						var _c:int=Math.round(_s/24);
						var nAngle:int = efx["fx"+str].rotation;
						var mAngle:int = Math.atan2(_sy, _sx)*180/Math.PI;
						var dAngle:int = nAngle-mAngle;
						if (dAngle>180) {
							dAngle = -360+dAngle;
						} else if (dAngle<(-180)) {
							dAngle = 360+dAngle;
						}
						nAngle-=dAngle;
						if(efx["fx"+str]._cnt<_c-1){
							//trace("add   "+efx["fx"+str]._cnt+"   "+_c);
							while(efx["fx"+str]._cnt<_c-1){
								var i:int=efx["fx"+str]._cnt+1;
								efx["fx"+str]["cl"+i]=new myStage.electro_fx();
								var _fr:int=efx["fx"+str]["cl"+i].currentFrame+1;
								if(_fr>4){
									_fr-=4;
								}
								efx["fx"+str]["cl"+i].gotoAndPlay(_fr);
								efx["fx"+str]["cl"+i].x=i*24;
								efx["fx"+str].addChild(efx["fx"+str]["cl"+i]);
								efx["fx"+str]._cnt=i;
							}
							//trace("add1   "+efx["fx"+str]._cnt+"   "+_c);
						}else if(efx["fx"+str]._cnt>_c-1){
							while(efx["fx"+str]._cnt>_c-1){
								try{
									//trace("remove   "+efx["fx"+str]._cnt+"   "+_c);
									efx["fx"+str].removeChild(efx["fx"+str]["cl"+efx["fx"+str]._cnt]);
									efx["fx"+str]._cnt--;
									//trace("remove1   "+efx["fx"+str]._cnt+"   "+_c);
								}catch(er:Error){
									//trace(er);
									break;
									/*for(var i:int=0;i<_c;i++){
										efx["fxt"+str]["cl"+i]=new myStage.electro_fx();
										efx["fxt"+str]["cl"+i].x=i*24;
										efx["fxt"+str]._cnt=i;
										efx["fxt"+str].addChild(efx["fxt"+str]["cl"+i]);
									}*/
								}
							}
						}
						efx["fx"+str].rotation=0;
						efx["fx"+str].width=_s;
						efx["fx"+str].rotation=nAngle;
					}
				}else{
					try{
						myStage.expls.removeChild(efx["fx"+str]);
					}catch(er:Error){}
					efx["fx"+str]=null;
					delete trgts[str];
					delete efx["fx"+str];
					
					myStage.self.stop_loop(snds["tsl"+str]);
					snds["tsl"+str]=null;
					delete snds["tsl"+str];
				}
			}
		}
		
		public function trgts_fix(str:String,cl:MovieClip){
			//trace("fix   "+str);
			cl["efx_ar"][0]=1;
			if(trgts["t"+str]==null){
				trgts["t"+str]=cl;
				snds["tslt"+str]=myStage.self.start_loop("tesla",0);
			}
			if(efx["fxt"+str]==null){
				var _sx:Number=(trgts["t"+str].x+13)-(x+24);
				var _sy:Number=(trgts["t"+str].y+13)-(y+24);
				var _s:int=Math.sqrt(Math.pow(_sx,2)+Math.pow(_sy,2));
				var _c:int=Math.round(_s/24);
				efx["fxt"+str]=new MovieClip();
				efx["fxt"+str].x=x+24;
				efx["fxt"+str].y=y+24;
				var nAngle:int = efx["fxt"+str].rotation;
				var mAngle:Number = Math.atan2(_sy, _sx)*180/Math.PI;
				var dAngle:Number = nAngle-mAngle;
				if (dAngle>180) {
					dAngle = -360+dAngle;
				} else if (dAngle<(-180)) {
					dAngle = 360+dAngle;
				}
				nAngle-=dAngle;
				for(var i:int=0;i<_c;i++){
					efx["fxt"+str]["cl"+i]=new myStage.electro_fx();
					var _fr:int=i%4;
					if(_fr==0){
						_fr=4;
					}
					efx["fxt"+str]["cl"+i].gotoAndPlay(_fr);
					efx["fxt"+str]["cl"+i].x=i*24;
					efx["fxt"+str]._cnt=i;
					efx["fxt"+str].addChild(efx["fxt"+str]["cl"+i]);
				}
				myStage.expls.addChild(efx["fxt"+str]);
				efx["fxt"+str].rotation=0;
				efx["fxt"+str].width=_s;
				efx["fxt"+str].rotation=nAngle;
			}
		}
		
		public function trgts_unfix(str:String){
			trgts["t"+str]=null;
			try{
				myStage.expls.removeChild(efx["fxt"+str]);
			}catch(er:Error){}
			efx["fxt"+str]=null;
			delete trgts["t"+str];
			delete efx["fxt"+str];
			
			myStage.self.stop_loop(snds["tslt"+str]);
			snds["tslt"+str]=null;
			delete snds["tslt"+str];
		}
		
		public function efx_del(){
			for(var str:String in trgts){
				try{
					trgts[str].reset_fx(0);
				}catch(er:Error){}
				trgts[str]=null;
				try{
					myStage.expls.removeChild(efx["fx"+str]);
				}catch(er:Error){}
				efx["fx"+str]=null;
				delete trgts[str];
				delete efx["fx"+str];
				
				myStage.self.stop_loop(snds["tsl"+str]);
				snds["tsl"+str]=null;
				delete snds["tsl"+str];
			}
		}
	}
	
}