package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	
	public class Laser extends MovieClip{
		
		public var mskin_s:String="tsl_frames";
		public var img:MovieClip=new MovieClip();
		public var fx_pos:Array=new Array();
		public var _num:int=0;
		public var rat:int=0;
		public var gr,gr_n:int=-1;
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
		public var efx:MovieClip;
		
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
		
		public function Laser(){
			super();
			addEventListener(Event.ADDED_TO_STAGE, activate);
			stop();
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
			var bmd:BitmapData=myStage.lib.png.laser1.bitmapData.clone();
			var mtrx:Matrix=new Matrix();
			mtrx.translate(-bmd.width/2,0);
			img.graphics.clear();
			img.graphics.beginBitmapFill(bmd,mtrx,false);
			img.graphics.drawRect(-bmd.width/2,0,bmd.width,bmd.height);
			img.rotation=(rat-1)*90;
			if(rat==1){
				img.x=0+24;
				img.y=0;
			}else if(rat==2){
				img.x=0+24;
				img.y=0+24;
			}else if(rat==3){
				img.x=0+24;
				img.y=0+24;
			}else if(rat==4){
				img.x=0;
				img.y=0+24;
			}
			addChild(img);
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
				//trace("Tesla_health   "+health1+"   "+health+"   "+myStage.tank_type+"   "+myStage.self_battle+"   "+_type);
				if(!myStage.self_battle){
					if(myStage.tank_type!=_type){
						t_cl.graphics.beginFill(0x4e1602,.4);
						t_cl.graphics.lineStyle(1, 0x4e1602, 1);
					}else{
						t_cl.graphics.beginFill(0x143306,.4);
						t_cl.graphics.lineStyle(1, 0x143306, 1);
					}
					if(rat==1){
						t_cl.graphics.drawRect(img.width/2-(img.width-30)/2,4,30,3);
					}else if(rat==2){
						t_cl.graphics.drawRect(img.width/2-15,4,30,3);
					}else if(rat==3){
						t_cl.graphics.drawRect(4,4,30,3);
					}else if(rat==4){
						t_cl.graphics.drawRect(img.width/2-15,4,30,3);
					}
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
					if(rat==1){
						t_cl.graphics.drawRect(img.width/2-(img.width-30)/2,4,30,3);
					}else if(rat==2){
						t_cl.graphics.drawRect(img.width/2-15,4,30,3);
					}else if(rat==3){
						t_cl.graphics.drawRect(4,4,30,3);
					}else if(rat==4){
						t_cl.graphics.drawRect(img.width/2-15,4,30,3);
					}
					t_cl.graphics.beginFill(0xff0000,1);
					t_cl.graphics.lineStyle(1, 0x4e1602, 1);
				}
				if(rat==1){
					t_cl.graphics.drawRect(img.width/2-(img.width-30)/2,4,(health/health1)*30,3);
				}else if(rat==2){
					t_cl.graphics.drawRect(img.width/2-15,4,(health/health1)*30,3);
				}else if(rat==3){
					t_cl.graphics.drawRect(4,4,(health/health1)*30,3);
				}else if(rat==4){
					t_cl.graphics.drawRect(img.width/2-15,4,(health/health1)*30,3);
				}
			}
		}
		
		public function activate(event:Event){
			removeEventListener(Event.ADDED_TO_STAGE, activate);
			set_fx();
		}
		
		public function set_fx(){
			if(efx!=null){
				return;
			}
			efx=new MovieClip();
			var _l:int=0;
			//trace(myStage.objs.length+"   "+myStage.obj_id.length);
			for(var i:int=0;i<myStage.objs.length;i++){
				//trace(myStage.objs[i]+"   "+myStage.obj_obj[i]+"   "+myStage.obj_num[i]+"   "+gr);
				if(myStage.objs[i]!=null&&myStage.obj_obj[i]==7&&myStage.obj_num[i]==gr&&myStage.obj_id[i]!=_num){
					//myStage.wall.createLaser(i,1);
					gr_n=i;
					if(x_pos==myStage.objs[i]["x_pos"]){
						_l=Math.abs(y_pos-myStage.objs[i]["y_pos"])-2;
					}else{
						_l=Math.abs(x_pos-myStage.objs[i]["x_pos"])-2;
					}
					//trace(_l);
					break;
				}
			}
			if(_l==0){
				if(rat==1){
					_l=x_pos;
				}else if(rat==2){
					_l=y_pos;
				}else if(rat==3){
					_l=Math.abs(x_pos-myStage.lWidth)-2;
				}else if(rat==4){
					_l=Math.abs(y_pos-myStage.lHeight)-2;
				}
			}
			fx_pos=new Array();
			for(i=0;i<_l;i++){
				efx["cl"+i]=new myStage.laser_fx();
				var _fr:int=i%6;
				if(_fr==0){
					_fr=6;
				}
				efx["cl"+i].gotoAndPlay(_fr);
				efx["cl"+i].x=i*24;
				efx["cl"+i].y=0-12;
				efx._cnt=i;
				efx.addChild(efx["cl"+i]);
				var _ar:Array=new Array();
				var _b:Boolean=false;
				var _pos:int=0;
				if(rat==1){
					_pos=pos_in_map-i-1;
				}else if(rat==2){
					_pos=pos_in_map-i*myStage.lWidth-myStage.lWidth;
				}else if(rat==3){
					_pos=pos_in_map+i+2;
				}else if(rat==4){
					_pos=pos_in_map+i*myStage.lWidth+2*myStage.lWidth;
				}
				if(myStage.teslaes[_pos]!=null){
					_ar=myStage.teslaes[_pos];
					for(var q:int=0;q<_ar.length;q++){
						if(_ar[q][2]==_num){
							_b=true;
							break;
						}
					}
				}
				if(!_b){
					fx_pos.push(_pos);
					_ar.push([myStage.obj_type[_num],2,_num]);
					myStage.teslaes[_pos]=_ar;
					if(int(Tank.free_pos[_pos])>0&&myStage.objs[Tank.free_pos[_pos]]!=null){
						trgts_fix("t"+Tank.free_pos[_pos],myStage.objs[Tank.free_pos[_pos]]);
					}
					//myStage.panel.graphics.beginFill(0xffffff,.3);
					//myStage.panel.graphics.drawRect((_pos%myStage.lWidth)*24-myStage.panel.x+4,int(_pos/myStage.lWidth)*24+4,24,24);
				}
			}
			if(rat==1){
				efx.rotation=180;
				efx.x=x;
				efx.y=y;
			}else if(rat==2){
				efx.rotation=270;
				efx.x=x+24;
				efx.y=y;
			}else if(rat==3){
				efx.rotation=0;
				efx.x=x+48;
				efx.y=y+24;
			}else if(rat==4){
				efx.rotation=90;
				efx.x=x;
				efx.y=y+48;
			}
			myStage.expls.addChild(efx);
			try{
				myStage.objs[gr_n]["gr_n"]=_num;
				myStage.objs[gr_n]["efx"]=efx;
				myStage.objs[gr_n]["fx_pos"]=fx_pos;
			}catch(er:Error){}
		}
		
		public function trgts_fix(str:String,cl:MovieClip){
			//trace("fix   "+str);
			cl["efx_ar"][1]=1;
			if(trgts["t"+str]==null){
				trgts["t"+str]=cl;
				if(gr_n>-1&&myStage.objs[gr_n]!=null){
					myStage.objs[gr_n]["trgts"]["t"+str]=cl;
				}
			}
		}
		
		public function trgts_unfix(str:String){
			trgts["t"+str]=null;
			delete trgts["t"+str];
			if(gr_n>-1&&myStage.objs[gr_n]!=null){
				myStage.objs[gr_n]["trgts"]["t"+str]=null;
				delete myStage.objs[gr_n]["trgts"]["t"+str];
			}
		}
		
		public function efx_del(){
			for(var str:String in trgts){
				try{
					trgts[str].reset_fx(1);
				}catch(er:Error){}
				trgts[str]=null;
				delete trgts[str];
			}
			if(gr_n>-1&&myStage.objs[gr_n]!=null){
				for(str in myStage.objs[gr_n]["trgts"]){
					try{
						myStage.objs[gr_n]["trgts"][str].reset_fx(1);
					}catch(er:Error){}
					myStage.objs[gr_n]["trgts"][str]=null;
					delete myStage.objs[gr_n]["trgts"][str];
				}
			}
			try{
				myStage.expls.removeChild(efx);
			}catch(er:Error){}
			efx=null;
			if(gr_n>-1&&myStage.objs[gr_n]!=null){
				myStage.objs[gr_n]["efx"]=null;
			}
			
			for(var i:int=0;i<fx_pos.length;i++){
				myStage.self.newEX(int(fx_pos[i]%myStage.lWidth)*24+4,int(fx_pos[i]/myStage.lWidth)*24+4,0,myStage.bm_count,0);
				var _ar:Array=new Array();
				if(myStage.teslaes[fx_pos[i]]!=null){
					_ar=myStage.teslaes[fx_pos[i]];
				}
				//_ar.push([myStage.obj_type[num],1,num]);
				if(_ar.length>1){
					for(var q:int=0;q<_ar.length;q++){
						if(_ar[q][2]==_num||_ar[q][2]==gr_n){
							_ar.splice(q,1);
						}
					}
					myStage.teslaes[fx_pos[i]]=_ar;
				}else if(_ar.length>0){
					if(_ar[0][2]==_num||_ar[0][2]==gr_n){
						myStage.teslaes[fx_pos[i]]=null;
					}
				}else{
					myStage.teslaes[fx_pos[i]]=null;
				}
			}
			fx_pos=new Array();
			if(gr_n>-1&&myStage.objs[gr_n]!=null){
				myStage.objs[gr_n]["fx_pos"]=new Array();
			}
		}
	}
	
}