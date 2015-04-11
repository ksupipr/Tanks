package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.*;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class Tank extends MovieClip{
		
		public var mname:String="wait...";
		public var t1_frames:Vector.<BitmapData>=new Vector.<BitmapData>();
		public var txt:TextField=new TextField();
		public static var tf:TextFormat=new TextFormat("Verdana", 10, 0x000000, false);
		
		public static var free_pos:Array=new Array(myStage.lWidth*myStage.lHeight);
		
		public static var sm_frames:Array=new Array();
		public static var m_frames:Array=new Array();
		public static var b_frames:Array=new Array();
		public static var b1_frames:Array=new Array();
		public static var b2_frames:Array=new Array();
		public static var ex_frames:Array=new Array();
		public static var bu_frames:Array=new Array();
		public static var ra_frames:Array=new Array();
		public static var tu_frames0:Array=new Array();
		public static var tu_frames1:Array=new Array();
		public static var big_tu_fr:Array=new Array();
		public static var pw_frames:Array=new Array();
		public static var stels_fr:Array=new Array();
		public static var b3_frames:Array=new Array();
		public static var tsl_frames:Array=new Array();
		public var t_cl:MovieClip=new MovieClip();
		public var p_cl:MovieClip=new MovieClip();
		
		public var gun_shots:Array=new Array();
		public var last_pack:Array=new Array();
		public var commands:Array=new Array();
		public var pos_ar:Array=new Array();
		public var commands1:Array=new Array();
		public var pos_ar1:Array=new Array();
		public var com_buff:Array=new Array();
		public var pos_buff:Array=new Array();
		public var heal_bar:MovieClip=new MovieClip();
		public var pole:MovieClip=new MovieClip();
		public var wait_c:int=0;
		public var wait_c1:int=0;
		public var wait_c2:int=0;
		public var pow_time:int=30;
		public var pow_step:Number=0;
		public var sm_c:int=0;
		
		public var rand:int=0;
		//public var colr:Array=[0x000000,0x000000,0x0000ff];
		
		public var rat:int=4;
		public var frame:int=0;
		public var X:Number;
		public var Y:Number;
		public var x_pos:int;
		public var y_pos:int;
		public var pos_in_map:int;
		public var next_pos:int;
		public var last_pos:int;
		
		public var h_last:int=0;
		public var health:int=0;
		public var health1:int=0;
		public var fire_power:int=0;
		public var fire_type:int=-1;
		public var fire_speed:int=20;
		public var speed:Number=2/4;       // 2/4
		public var SPEED:Number=2;
		public var _type:int;            // команда
		public var _num:int;
		
		public var i:int;
		public var j:int;
		public var step_count:int=0;
		public var max_step:int=0;
		public var pow_count:int;
		public var pow_fr:int=0;
		public var last_tr:int=0;
		public var mskin:String="";
		
		public var stoped:Boolean;
		public var correct:Boolean;
		public var at_left:Boolean;
		public var at_right:Boolean;
		public var   at_up:Boolean;
		public var at_down:Boolean;
		public var fire:Boolean;
		public var mround:Boolean;
		public var f_armor:Boolean;
		public var go:Boolean=false;
		public var mmove:Boolean=false;
		public var player:Boolean;
		public var stels:int=0;
		
		public var ebot:Boolean;
		public var del:Boolean;
		public var _over:int=0;
		
		public function Tank(vect:int,type:int,mnum:int,bot:Boolean){
			super();
			stop();
			if(vect<4){
				frame=(vect)*3;
			}else{
				frame=0;
			}
			_type=type;
			rat=vect;
			max_step=24/speed;
			//trace(type+"   "+bot);
			if(type==1){
				setFrames("t34.png");
				//myStage.keep_cl.push(t_cl);
				if(mnum!=myStage.tank_id){
					//mname="Союзный#"+mnum;
				}else{
					//mname="Ваш танк#"+mnum;
					player=true;
					try{
						for(i=0;i<Ground.Mines.length;i++){
							if(Ground.Mines[i]>100){
								if(Ground.m_buff[i]!=mnum){
									Ground.Mines[i]=10+((Ground.Mines[i]-100)-6);
								}else{
									Ground.Mines[i]=20+((Ground.Mines[i]-100)-6);
								}
							}
						}
						for(i=0;i<Ground.ms.length;i++){
							if(Ground.ms[i]!=null){
								myStage.ground.removeChild(Ground.ms[i]);
								Ground.ms[i]=null;
							}
						}
						
					}catch(e:Error){
						//trace("Load Tank "+e);
					}
				}
			}else{
				setFrames("enemy.png");
				if(!bot){
					//myStage.enem_cl.push(t_cl);
					if(mnum!=myStage.tank_id){
						//mname="Вражеский#"+mnum;
					}else{
						//mname="Ваш танк#"+mnum;
						player=true;
						try{
							for(i=0;i<Ground.Mines.length;i++){
								if(Ground.Mines[i]>100){
									if(Ground.m_buff[i]!=mnum){
										Ground.Mines[i]=20+((Ground.Mines[i]-100)-6);
									}else{
										Ground.Mines[i]=10+((Ground.Mines[i]-100)-6);
									}
								}
							}
							for(i=0;i<Ground.ms.length;i++){
								if(Ground.ms[i]!=null){
									myStage.ground.removeChild(Ground.ms[i]);
									Ground.ms[i]=null;
								}
							}
							
						}catch(e:Error){
							//trace("Load Tank "+e);
						}
					}
				}else{
					//myStage.ebot_cl.push(t_cl);
					//mname="Комп "+mnum;
					//ebot=true;
					//m_num=bot_c;
					//bot_c++;
				}
			}
			
			t_cl.mouseEnabled=false;
			/*addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent){
				_over=2;
				Mouse.cursor=MouseCursor.BUTTON;
			});
			addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent){
				_over=1;
				Mouse.cursor=MouseCursor.AUTO;
			});*/
		}
		
		public var efx1_f:GlowFilter=new GlowFilter(0xFF9900, 1, 32, 32, 1, 1, true, false);
		public var efx1_l:Array=[255,153,0];
		public var efx1_i:Number=.05;
		public var efx1_li:int=6;
		public var efx1_v,efx1_lv:int=0;
		
		public var efx_ar:Array=new Array();
		
		public function overTest(){
			if(_over>0){
				var _mw=t1_frames[frame].width;
				var _mh=t1_frames[frame].height;
				if(_over==2){
					//trace(_mw+"   "+_mh+"   "+width+"   "+height+"   "+myStage.ov_ar[0]+"   "+myStage.ov_ar[1]+"   "+myStage.ov_ar[2]);
					var shp:Shape = new Shape();
					var mtrx:Matrix = new Matrix();
					mtrx.createGradientBox(_mw, _mh, 0, 0, 0);
					shp.graphics.beginGradientFill(GradientType.RADIAL, myStage.ov_ar[0], myStage.ov_ar[1], myStage.ov_ar[2], mtrx, "pad", "rgb", 0);
					shp.graphics.drawRect(0, 0, _mw, _mh);
					shp.graphics.endFill();
					var bmd2:BitmapData = new BitmapData(_mw, _mh, true, 0x00ffffff);
					var bmd3:BitmapData = t1_frames[frame].clone();
					bmd2.draw(shp);
					var pt:Point = new Point(0, 0);
					var mult:uint = 0xff; // 0x80 = 50%
					bmd3.copyPixels(bmd2, new Rectangle(0,0,_mw, _mh), pt, bmd3, pt, true);
					graphics.clear();
					graphics.beginBitmapFill(bmd3);
					graphics.drawRect(0, 0, _mw, _mh);
				}else{
					graphics.clear();
					graphics.beginBitmapFill(t1_frames[frame]);
					graphics.drawRect(0, 0, _mw, _mh);
					_over=0;
				}
			}
			if(int(efx_ar[0])>0||int(efx_ar[1])>0){
				if(efx1_v==0){
					efx1_f.strength+=efx1_i;
				}else{
					efx1_f.strength-=efx1_i;
				}
				if(efx1_f.strength>.6){
					efx1_f.strength=.6;
					efx1_v=1;
				}else if(efx1_f.strength<.2){
					efx1_f.strength=.2;
					efx1_v=0;
				}
				if(efx1_lv==0){
					efx1_l[1]+=efx1_li;
					efx1_l[2]+=efx1_li;
				}else{
					efx1_l[1]-=efx1_li;
					efx1_l[2]-=efx1_li;
				}
				if(efx1_l[1]>255){
					efx1_l[1]=255;
					efx1_lv=1;
				}else if(efx1_l[1]<153){
					efx1_l[1]=153;
					efx1_lv=0;
				}
				efx1_f.color=toHEX(efx1_l);
				var _source:BitmapData=t1_frames[frame].clone();
				var _rect:Rectangle=new Rectangle(0,0,_source.width,_source.height);
				var _mw=_rect.width;
				var _mh=_rect.height;
				//var bm:Bitmap=new Bitmap(_source);
				//bm.filters=[efx1_f];
				_source.applyFilter(_source,_rect,new Point(0,0),efx1_f);
				graphics.clear();
				graphics.beginBitmapFill(_source);
				//graphics.beginBitmapFill(bm.bitmapData);
				graphics.drawRect(0, 0, _mw, _mh);
			}else if(mround){
				var _source:BitmapData=t1_frames[frame];
				var _mw=_source.width;
				var _mh=_source.height;
				graphics.clear();
				graphics.beginBitmapFill(_source);
				graphics.drawRect(0, 0, _mw, _mh);
			}
		}
		
		public function teslaOff(){
			tsl=false;
			/*var _x:int=(tsl_pos%myStage.lWidth);
			var _y:int=(tsl_pos/myStage.lWidth);
			var _w:int=1;
			var _h:int=1;
			var _x1:int=_x-this["tsl_r"];
			var _y1:int=_y-this["tsl_r"];
			var _x2:int=_x+this["tsl_r"]+1;
			var _y2:int=_y+this["tsl_r"]+1;
			efx_del();
			for(var n:int=0;n<_w;n++){
				for(var k:int=0;k<_h;k++){
					for(var i:int=(_x1+n);i<(_x2+n);i++){
						if(i>-1&&i<myStage.lWidth){
							for(var j:int=(_y1+k);j<(_y2+k);j++){
								if(j>-1&&j<myStage.lHeight){
									//trace((Math.abs(i-_x)+Math.abs(j-_y))+"   "+i+"   "+j+"   "+myStage.lWidth+"   "+(i+j*myStage.lWidth));
									if((Math.abs(i-(_x+n))+Math.abs(j-(_y+k)))<=this["tsl_r"]){
										var _ar:Array=new Array();
										if(myStage.teslaes[i+j*myStage.lWidth]!=null){
											_ar=myStage.teslaes[i+j*myStage.lWidth];
										}
										//_ar.push([myStage.obj_type[_num],1,_num]);
										if(_ar.length>1){
											for(var q:int=0;q<_ar.length;q++){
												if(_ar[q][2]==_num){
													_ar.splice(q,1);
												}
											}
											myStage.teslaes[i+j*myStage.lWidth]=_ar;
										}else if(_ar.length>0){
											if(_ar[0][2]==_num){
												myStage.teslaes[i+j*myStage.lWidth]=null;
											}
										}else{
											myStage.teslaes[i+j*myStage.lWidth]=null;
										}
									}
								}
							}
						}
					}
				}
			}*/
			efx_del();
			for(var i:int=0;i<myStage.teslaes.length;i++){
				var _ar:Array=new Array();
				if(myStage.teslaes[i]!=null){
					_ar=myStage.teslaes[i];
				}
				//_ar.push([myStage.obj_type[_num],1,_num]);
				if(_ar.length>1){
					for(var q:int=0;q<_ar.length;q++){
						if(_ar[q][2]==_num){
							_ar.splice(q,1);
						}
					}
					myStage.teslaes[i]=_ar;
				}else if(_ar.length>0){
					if(_ar[0][2]==_num){
						myStage.teslaes[i]=null;
					}
				}else{
					myStage.teslaes[i]=null;
				}
			}
			//com_reset();
		}
		
		public function teslaOn(tsl_R:int, _coor:int, _time:int){
			//trace("teslaOn   "+tsl_R+"   "+_coor+"   "+_time);
			
			if(tsl){
				teslaOff();
			}
			if(_time==0){
				teslaOff();
				return;
			}
			//tsl_c=_time;
			//tsl_st=myStage.panel["leave_cl"].getStep();
			tsl_pos=_coor;
			tsl=true;
			tsl_r=tsl_R;
			try{
				com_test([rat,_coor],1);
			}catch(er:Error){}
			var _x:int=(tsl_pos%myStage.lWidth);
			var _y:int=(tsl_pos/myStage.lWidth);
			var _w:int=1;
			var _h:int=1;
			var _x1:int=_x-tsl_R;
			var _y1:int=_y-tsl_R;
			var _x2:int=_x+tsl_R+1;
			var _y2:int=_y+tsl_R+1;
			
			for(var n:int=0;n<_w;n++){
				for(var k:int=0;k<_h;k++){
					for(var i:int=(_x1+n);i<(_x2+n);i++){
						if(i>-1&&i<myStage.lWidth){
							for(var j:int=(_y1+k);j<(_y2+k);j++){
								if(j>-1&&j<myStage.lHeight){
									//trace((Math.abs(i-_x)+Math.abs(j-_y))+"   "+i+"   "+j+"   "+myStage.lWidth+"   "+(i+j*myStage.lWidth));
									if((Math.abs(i-(_x+n))+Math.abs(j-(_y+k)))<=tsl_R){
										var _ar:Array=new Array();
										var _b:Boolean=false;
										var _pos:int=i+j*myStage.lWidth;
										if(myStage.teslaes[_pos]!=null){
											_ar=myStage.teslaes[_pos];
											for(var q:int=0;q<_ar.length;q++){
												if(_ar[q][2]==_num){
													_b=true;
													break;
												}
											}
										}
										//trace("b     "+_pos+"   "+Tank.free_pos[_pos]+"   "+myStage.objs[Tank.free_pos[_pos]]+"   "+_num);
										if(!_b){
											_ar.push([_type,1,_num]);
											myStage.teslaes[_pos]=_ar;
											//trace("try   "+_pos+"   "+Tank.free_pos[_pos]+"   "+myStage.objs[Tank.free_pos[_pos]]+"   "+_num);
											if(int(Tank.free_pos[_pos])>0&&myStage.objs[Tank.free_pos[_pos]]!=null&&int(Tank.free_pos[_pos])!=_num&&myStage.objs[Tank.free_pos[_pos]]["_type"]!=_type){
												//trace("find   "+_pos+"   "+Tank.free_pos[_pos]+"   "+myStage.objs[Tank.free_pos[_pos]]);
												trgts_fix("t"+Tank.free_pos[_pos],myStage.objs[Tank.free_pos[_pos]]);
												/*if(!myStage.objs[Tank.free_pos[_pos]]["mmove"]){
													wayTest();
												}*/
											}else if(!player&&myStage.pl_clip!=null&&myStage.pl_clip["pos_in_map"]==_pos&&myStage.pl_clip["_type"]!=_type){
												trgts_fix("t"+myStage.pl_clip["_num"],myStage.pl_clip);
											}
											//myStage.panel.graphics.beginFill(0xffffff,.3);
											//myStage.panel.graphics.drawRect(i*24-myStage.panel.x+4,j*24+4,24,24);
										}
									}
								}
							}
						}
					}
				}
			}
			//efx_move(1);
		}
		
		public var trgts:Object = new Object();
		public var snds:Object = new Object();
		public var efx:Object = new Object();
		public var tsl_r:int = 0;
		
		public function efx_move(_bg:int=0){
			for(var str:String in trgts){
				if(trgts[str].stage!=null){
					if(trgts[str].mmove||mmove||_bg==1){
						efx["fx"+str].x=x+13;
						efx["fx"+str].y=y+13;
						var _sx:int=(trgts[str].x)-(x);
						var _sy:int=(trgts[str].y)-(y);
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
				var _sx:Number=(trgts["t"+str].x)-(x);
				var _sy:Number=(trgts["t"+str].y)-(y);
				var _s:int=Math.sqrt(Math.pow(_sx,2)+Math.pow(_sy,2));
				var _c:int=Math.round(_s/24);
				efx["fxt"+str]=new MovieClip();
				efx["fxt"+str].x=x+13;
				efx["fxt"+str].y=y+13;
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
		
		public function reset_fx(_i:int){
			efx_ar[_i]=0;
			for(var i:int=0;i<efx_ar.length;i++){
				if(int(efx_ar[i])>0){
					return;
				}
			}
			var _source:BitmapData=t1_frames[frame];
			var _mw=_source.width;
			var _mh=_source.height;
			graphics.clear();
			graphics.beginBitmapFill(_source);
			graphics.drawRect(0, 0, _mw, _mh);
		}
		
		public function toHEX(clr:Array):int{
			var colorHexString:String="";
			var ar:Array=new Array((clr[0]).toString(16),(clr[1]).toString(16),(clr[2]).toString(16));
			for(var i:int=0;i<ar.length;i++){
				if(ar[i].length<2){
					ar[i]="0"+ar[i];
				}
				colorHexString+=ar[i];
			}
			//trace(colorHexString);
			return parseInt(colorHexString,16);
		}
		
		public function healthTest(){
			if(health1>0){
				t_cl.graphics.clear();
				if(health>(health1/3)*2){
					//graphics.beginFill(0x00ff36,1);
					sm_c=0;
				}else if(health>health1/3){
					//graphics.beginFill(0xfffc00,1);
					sm_c=6;
				}else{
					//graphics.beginFill(0xff0000,1);
					sm_c=3;
				}
				if(health<0){
					health=0;
				}
				////trace("health   "+health1+"   "+health+"   "+myStage.tank_type+"   "+_type);
				if(!myStage.self_battle){
					if(myStage.tank_type!=_type||ebot){
						t_cl.graphics.beginFill(0x4e1602,.4);
						t_cl.graphics.lineStyle(1, 0x4e1602, 1);
					}else{
						t_cl.graphics.beginFill(0x143306,.4);
						t_cl.graphics.lineStyle(1, 0x143306, 1);
					}
					t_cl.graphics.drawRect(-2,-5,30,3);
					if(myStage.tank_type!=_type||ebot){
						t_cl.graphics.beginFill(0xff0000,1);
						t_cl.graphics.lineStyle(1, 0x4e1602, 1);
					}else{
						t_cl.graphics.beginFill(0x00ff36,1);
						t_cl.graphics.lineStyle(1, 0x143306, 1);
					}
				}else{
					if(!player){
						t_cl.graphics.beginFill(0x4e1602,.4);
						t_cl.graphics.lineStyle(1, 0x4e1602, 1);
					}else{
						t_cl.graphics.beginFill(0x143306,.4);
						t_cl.graphics.lineStyle(1, 0x143306, 1);
					}
					t_cl.graphics.drawRect(-2,-5,30,3);
					if(!player){
						t_cl.graphics.beginFill(0xff0000,1);
						t_cl.graphics.lineStyle(1, 0x4e1602, 1);
					}else{
						t_cl.graphics.beginFill(0x00ff36,1);
						t_cl.graphics.lineStyle(1, 0x143306, 1);
					}
				}
				t_cl.graphics.drawRect(-2,-5,(health/health1)*30,3);
				if(!ebot){
					//trace(myStage.m_nums[_num1]+"   "+_num1);
					try{
						myStage.chat_cl["avas"]["ava"+myStage.m_nums[_num1]]["xp_bar"]["fill"].width=52*(health/health1);
					}catch(e:Error){
						//trace(e);
					}
				}
				if(player){
					if(myStage.panel!=null){
						myStage.panel["ammo0"].drawHealth(health,health1);
					}
				}
			}
		}
		
		public static function createSmoke(){
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,15,15);
			var rect:Rectangle;
			var bmd:BitmapData;
			var myBitmap:Bitmap;
			for(var i=0;i<10;i++){
				////trace(myStage.grounds[i]);
				x1=i*15;
				////trace(x1);
				rect=new Rectangle(x1,0,15,15);
				bmd=new BitmapData(15,15,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.smoke.bitmapData.getVector(rect));
				sm_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,24,24);
			for(var i=0;i<3;i++){
				////trace(myStage.grounds[i]);
				x1=i*24;
				////trace(x1);
				rect=new Rectangle(x1,0,24,24);
				bmd=new BitmapData(24,24,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.mine.bitmapData.getVector(rect));
				m_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,22,22);
			for(var i=0;i<7;i++){
				////trace(myStage.grounds[i]);
				x1=i*22;
				////trace(x1);
				rect=new Rectangle(x1,0,22,22);
				bmd=new BitmapData(22,22,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.small_boom.bitmapData.getVector(rect));
				b_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,32,32);
			for(var i=0;i<10;i++){
				////trace(myStage.grounds[i]);
				x1=i*32;
				////trace(x1);
				rect=new Rectangle(x1,0,32,32);
				bmd=new BitmapData(32,32,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.big_boom.bitmapData.getVector(rect));
				b1_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,48,48);
			for(var i=0;i<7;i++){
				////trace(myStage.grounds[i]);
				x1=i*48;
				////trace(x1);
				rect=new Rectangle(x1,0,48,48);
				bmd=new BitmapData(48,48,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.bada_boom.bitmapData.getVector(rect));
				b2_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,24,24);
			for(var i=0;i<3;i++){
				////trace(myStage.grounds[i]);
				x1=i*24;
				////trace(x1);
				rect=new Rectangle(x1,0,24,24);
				bmd=new BitmapData(24,24,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.expl.bitmapData.getVector(rect));
				ex_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,20,20);
			for(var i=0;i<16;i++){
				//trace(i);
				x1=i*20;
				////trace(x1);
				rect=new Rectangle(x1,0,20,20);
				bmd=new BitmapData(20,20,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.bullets.bitmapData.getVector(rect));
				bu_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,48,48);
			for(var i=0;i<12;i++){
				////trace(myStage.grounds[i]);
				x1=i*48;
				////trace(x1);
				rect=new Rectangle(x1,0,48,48);
				bmd=new BitmapData(48,48,false,0xFFFFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.radar.bitmapData.getVector(rect));
				ra_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,30,30);
			for(var i=0;i<16;i++){
				////trace(myStage.grounds[i]);
				x1=i*30;
				////trace(x1);
				rect=new Rectangle(x1,0,30,30);
				bmd=new BitmapData(30,30,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.turrel.bitmapData.getVector(rect));
				tu_frames0.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,30,30);
			for(var i=0;i<16;i++){
				////trace(myStage.grounds[i]);
				x1=i*30;
				////trace(x1);
				rect=new Rectangle(x1,0,30,30);
				bmd=new BitmapData(30,30,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.turrel3.bitmapData.getVector(rect));
				tu_frames1.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,56,56);
			for(var i=0;i<3;i++){
				////trace(myStage.grounds[i]);
				x1=i*56;
				////trace(x1);
				rect=new Rectangle(x1,0,56,56);
				bmd=new BitmapData(56,56,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.pow.bitmapData.getVector(rect));
				pw_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,46,46);
			for(var i=0;i<7;i++){
				////trace(myStage.grounds[i]);
				x1=i*46;
				////trace(x1);
				rect=new Rectangle(x1,0,46,46);
				bmd=new BitmapData(46,46,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.invis.bitmapData.getVector(rect));
				stels_fr.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,64,64);
			for(var i=0;i<12;i++){
				////trace(myStage.grounds[i]);
				x1=i*64;
				////trace(x1);
				rect=new Rectangle(x1,0,64,64);
				bmd=new BitmapData(64,64,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.exp3.bitmapData.getVector(rect));
				b3_frames.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,54,54);
			for(var i=0;i<16;i++){
				////trace(myStage.grounds[i]);
				x1=i*54;
				////trace(x1);
				rect=new Rectangle(x1,0,54,54);
				bmd=new BitmapData(54,54,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.tur2.bitmapData.getVector(rect));
				big_tu_fr.push(myBitmap);
			}
			x1=0;
			rect1=new Rectangle(0,0,48,48);
			for(var i=0;i<6;i++){
				////trace(myStage.grounds[i]);
				x1=i*48;
				////trace(x1);
				rect=new Rectangle(x1,0,48,48);
				bmd=new BitmapData(48,48,true,0x00FFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.reactor.bitmapData.getVector(rect));
				tsl_frames.push(myBitmap);
			}
		}
		
		public function setTankSkin(_name:String){
<<<<<<< HEAD:client/work/fps test1/game/Tank.as
=======
			if(_name==null){
				_name="enemy.png";
			}
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/game/Tank.as
			var _ar:Array=_name.split(".");
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,26,26);
			for(var i=0;i<12;i++){
				////trace(myStage.grounds[i]);
				x1=i*26;
				////trace(x1);
				var rect:Rectangle=new Rectangle(x1,0,26,26);
				var bmd:BitmapData=new BitmapData(26,26,true,0x00FFFFFF);
				var myBitmap:Bitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib[_ar[1]][_ar[0]].bitmapData.getVector(rect));
				t1_frames[i]=myBitmap.bitmapData;
			}
		}
		
		public function setFrames(_name:String){
			setTankSkin(_name);
			graphics.beginBitmapFill(t1_frames[frame]);
			graphics.drawRect(0, 0, 26, 26);
			p_cl.x=x-15;
			p_cl.y=y-15;
			//graphics.beginFill(0x00ff36,1);
			//graphics.drawRect(-2,-5,30,2);
			tf.align=TextFormatAlign.CENTER;
			txt.defaultTextFormat=tf;
			txt.autoSize=TextFieldAutoSize.CENTER;
			txt.selectable=false;
			txt.text=mname;
			txt.x=int(-txt.textWidth/2+13);
			txt.y=-20;
			txt.mouseEnabled=false;
			t_cl.addChild(txt);
			try{
				removeEventListener(Event.ENTER_FRAME, render);
			}catch(er:Error){}
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		public function setTankName(str_name:String,skn:String){
			if(str_name!=null){
				mname=str_name;
			}
			mskin=skn;
			//trace(skn);
			setFrames(skn);
			//trace("nameTank   "+str_name+"   "+skn);
			tf.align=TextFormatAlign.CENTER;
			txt.defaultTextFormat=tf;
			txt.autoSize=TextFieldAutoSize.CENTER;
			txt.selectable=false;
			txt.text=mname;
			txt.x=int(-txt.textWidth/2+13);
			txt.y=-20;
		}
		
		public function setNewName(){
			//trace("numTank   "+m_num+"   "+ebot);
			if(ebot){
				//trace("nameBot   "+myStage.b_names[m_num]+"   "+myStage.b_skins[m_num]+"   "+m_num+"   "+ebot);
				setTankName(myStage.b_names[m_num],myStage.b_skins[m_num]);
			}else{
				for(var t:int=0;t<myStage.m_idies.length;t++){
					try{
						if(_type==1){
							if(myStage.obj_id[_num]==myStage.m_idies[t]){
								setTankName(myStage.m_rangs[t]+" "+myStage.m_names[t],myStage.m_skins[t]);
								_num1=t;
								for(var j:int=0;j<3;j++){
									if(j<myStage.obj_resp[_num]){
										myStage.chat_cl["avas"]["ava"+myStage.m_nums[_num1]]["l"+j].gotoAndStop(1);
									}else{
										myStage.chat_cl["avas"]["ava"+myStage.m_nums[_num1]]["l"+j].gotoAndStop(2);
									}
								}
								myStage.chat_cl["avas"]["ava"+myStage.m_nums[_num1]]["lenta_cl"].visible=false;
								break;
							}
						}else{
							if(myStage.obj_id[_num]==myStage.m_idies[t]){
								setTankName(myStage.m_rangs[t]+" "+myStage.m_names[t],myStage.m_skins[t]);
								_num1=t;
								for(var j:int=0;j<3;j++){
									if(j<myStage.obj_resp[_num]){
										myStage.chat_cl["avas"]["ava"+myStage.m_nums[_num1]]["l"+j].gotoAndStop(1);
									}else{
										myStage.chat_cl["avas"]["ava"+myStage.m_nums[_num1]]["l"+j].gotoAndStop(2);
									}
								}
								myStage.chat_cl["avas"]["ava"+myStage.m_nums[_num1]]["lenta_cl"].visible=false;
								break;
							}
						}
					}catch(er:Error){}
				}
			}
		}
		
	public var _num1:int=-1;
	public var m_num:int=0;
		
  public static function dofire(tank:Tank, at_vect:int,pos:int,ident:int,_ar:Array=null,_efx:int=-1){
		//trace("fire tank  "+pos+"   "+at_vect+"   "+_ar+"   "+_efx);
		var _b:Boolean=false;
		if(ident>0){
			for(var m:int=0;m<tank["gun_shots"].length;m++){
				if(tank["gun_shots"][m][0]==tank&&tank["gun_shots"][m][1]==at_vect){
					/*if(tank["player"]){
						trace([tank,at_vect,pos,null]+"    "+myStage.steps+"    "+_b+"    "+ident);
						trace(tank["gun_shots"][m]);
					}*/
					tank["gun_shots"][m][3]["ID"]=ident;
					tank["gun_shots"][m][3].setSkin1(_efx);
					tank["gun_shots"].splice(0, m+1);
					//if(tank["player"])trace(tank["gun_shots"].length);
					if(_ar==null||_ar[1]==0){
						_b=true;
					}
					break;
				}
			}
		}
		//if(tank["player"]&&ident>0)trace([tank,at_vect,pos,null]+"    "+myStage.steps+"    "+_b+"    "+ident);
		if(_b){
			return;
		}else{
			if(ident>0){
				//trace([tank,at_vect,pos,null]+"   serv");
				for(var m:int=0;m<tank["gun_shots"].length;m++){
					//trace(tank["gun_shots"][m]+"   "+m);
					try{
						tank["gun_shots"][m][3].removeEventListener(Event.ENTER_FRAME,tank["gun_shots"][m][3].render);
						tank["gun_shots"][m][3].parent.removeChild(tank["gun_shots"][m][3]);
						myStage.objs[tank["gun_shots"][m][3]["_num"]]=null;
					}catch(er:Error){
						
					}
				}
				tank["gun_shots"]=new Array();
			}
		}
    myStage.objs[ident]=(new Bullet());
		if(ident<0){
			//trace("fire tank  "+pos+"   "+tank.x+"   "+tank.y);
			tank["gun_shots"].push([tank,at_vect,pos,myStage.objs[ident]]);
			myStage.objs[ident].x=int(tank.x+myStage.board_x)+2;
			myStage.objs[ident].y=int(tank.y+myStage.board_y)+2;
		}else{
			myStage.objs[ident].x=int(int((pos-1)%myStage.lWidth)*24+myStage.board_x)+2;
			myStage.objs[ident].y=int(int((pos-1)/myStage.lWidth)*24+myStage.board_y)+2;
			//trace("fire pos  "+pos+"   "+myStage.objs[ident].x+"   "+myStage.objs[ident].y);
		}
    myStage.objs[ident].rat=at_vect;
    myStage.objs[ident]._num=ident;
    myStage.objs[ident].tank=tank;
    myStage.objs[ident]._type=tank._type;
    myStage.objs[ident].power=tank.fire_power/10;
    myStage.objs[ident].player=tank.player;
		myStage.objs[ident].ID=ident;
		myStage.objs[ident].ebot=tank.ebot;
		myStage.objs[ident].step_b=myStage.steps;
		myStage.objs[ident].x-=4;
		myStage.objs[ident].y-=4;
		myStage.objs[ident].X=myStage.objs[ident].x;
		myStage.objs[ident].Y=myStage.objs[ident].y;
		myStage.obj_obj[ident]=0;
		/*if(at_vect==1||at_vect==3){
			myStage.objs[ident].y-=2;
		}*/
		if(at_vect!=4){
    	myStage.objs[ident]["frame"]=at_vect;
    }else{
      myStage.objs[ident]["frame"]=0;
    }
		if(tank.fire_type>1&&tank.fire_type<4){
			myStage.objs[ident]["frame"]+=4;
			myStage.self.playSound("shot3",0);
		}else if(tank.fire_type>3){
			myStage.objs[ident]["frame"]+=8;
			myStage.self.playSound("plazma",0);
		}else if(tank.fire_type<0){
			myStage.self.playSound("shot1",0);
		}else{
			myStage.self.playSound("shot2",0);
		}
		myStage.objs[ident].setFrames(_efx);
		//myStage.objs[ident]["clip"][myStage.objs[ident]["frame"]].visible=true;
  }
	
	public function tracks(){
		if(!myStage.self["track_on"]){
			return;
		}
		if(last_tr>0){
			if(myStage.tr_count<myStage.tracks.length-1){
				myStage.tr_count++;
			}else{
				myStage.tr_count=0;
			}
			if(rat==1){
				if(last_tr==1){
					myStage.ground.newTrack(pos_in_map,0,myStage.tr_count);
				}else if(last_tr==2){
					myStage.ground.newTrack(pos_in_map,20,myStage.tr_count);
				}else if(last_tr==3){
					myStage.ground.newTrack(pos_in_map,0,myStage.tr_count);
				}else if(last_tr==4){
					myStage.ground.newTrack(pos_in_map,8,myStage.tr_count);
				}
			}else if(rat==2){
				if(last_tr==1){
					myStage.ground.newTrack(pos_in_map,12,myStage.tr_count);
				}else if(last_tr==2){
					myStage.ground.newTrack(pos_in_map,4,myStage.tr_count);
				}else if(last_tr==3){
					myStage.ground.newTrack(pos_in_map,8,myStage.tr_count);
				}else if(last_tr==4){
					myStage.ground.newTrack(pos_in_map,4,myStage.tr_count);
				}
			}else if(rat==3){
				if(last_tr==1){
					myStage.ground.newTrack(pos_in_map,0,myStage.tr_count);
				}else if(last_tr==2){
					myStage.ground.newTrack(pos_in_map,16,myStage.tr_count);
				}else if(last_tr==3){
					myStage.ground.newTrack(pos_in_map,0,myStage.tr_count);
				}else if(last_tr==4){
					myStage.ground.newTrack(pos_in_map,12,myStage.tr_count);
				}
			}else if(rat==4){
				if(last_tr==1){
					myStage.ground.newTrack(pos_in_map,16,myStage.tr_count);
				}else if(last_tr==2){
					myStage.ground.newTrack(pos_in_map,4,myStage.tr_count);
				}else if(last_tr==3){
					myStage.ground.newTrack(pos_in_map,20,myStage.tr_count);
				}else if(last_tr==4){
					myStage.ground.newTrack(pos_in_map,4,myStage.tr_count);
				}
			}
		}
		last_tr=rat;
	}
  
  public function wayTest(){
		//if(free_pos[pos_in_map]==_num)free_pos[pos_in_map]=0;
		//if(free_pos[last_pos]==_num)free_pos[last_pos]=0;
		if(last_pos!=pos_in_map&&myStage.teslaes[last_pos]!=null){
			for(var n:int=0;n<myStage.teslaes[last_pos].length;n++){
				if(myStage.teslaes[last_pos][n]!=null){
					try{
						if(myStage.teslaes[last_pos][n][2]!=myStage.teslaes[pos_in_map][n][2]){
							myStage.objs[myStage.teslaes[last_pos][n][2]].trgts_unfix("t"+_num);
						}
					}catch(er:Error){
						myStage.objs[myStage.teslaes[last_pos][n][2]].trgts_unfix("t"+_num);
					}
				}
			}
		}
		last_pos=pos_in_map;
		x_pos=Math.floor((int(x)+width/2)/24);
    y_pos=Math.floor((int(y)+height/2)/24);
		pos_in_map=(x_pos+y_pos*myStage.lWidth);
		if(!player){
			free_pos[pos_in_map]=_num;
		}
		//free_pos[pos_in_map]=_num;
		if(myStage.bon_pos[pos_in_map]!=null){
			try{
				myStage.ground.removeChild(myStage.bonuses[pos_in_map]);
				myStage.bonuses[pos_in_map]=null;
				myStage.bon_id[pos_in_map]=null;
				myStage.bon_pos[pos_in_map]=null;
				myStage.bon_time[pos_in_map]=null;
				myStage.bon_type[pos_in_map]=null;
				myStage.bon_pow[pos_in_map]=null;
				myStage.bon_step[pos_in_map]=null;
				myStage.bon_pict[pos_in_map]=null;
				myStage.bon_c[pos_in_map]=null;
			}catch(er:Error){
				
			}
		}
		if(last_pos!=pos_in_map&&myStage.teslaes[last_pos]!=null){
			for(var n:int=0;n<myStage.teslaes[last_pos].length;n++){
				if(myStage.teslaes[last_pos][n]!=null){
					try{
						if(myStage.teslaes[last_pos][n][2]!=myStage.teslaes[pos_in_map][n][2]){
							myStage.objs[myStage.teslaes[last_pos][n][2]].trgts_unfix("t"+_num);
						}
					}catch(er:Error){
						myStage.objs[myStage.teslaes[last_pos][n][2]].trgts_unfix("t"+_num);
					}
				}
			}
		}
		var re_fx:Array=new Array();
		for(var n:int=0;n<efx_ar.length;n++){
			if(int(efx_ar[n])!=0){
				re_fx[n]=1;
			}
			efx_ar[n]=0;
		}
		if(myStage.teslaes[pos_in_map]!=null){
			for(var n:int=0;n<myStage.teslaes[pos_in_map].length;n++){
				if(myStage.teslaes[pos_in_map][n]!=null){
					if(myStage.teslaes[pos_in_map][n][0]!=_type){
						myStage.objs[myStage.teslaes[pos_in_map][n][2]].trgts_fix("t"+_num,this);
					}
				}
			}
		}
		for(var n:int=0;n<re_fx.length;n++){
			if(int(re_fx[n])!=0&&int(efx_ar[n])==0){
				reset_fx(n);
			}
		}
		x=X=x_pos*24-1;
		y=Y=y_pos*24-1;
		//self_go();
		try{
			if(player){
				if(x_pos+2<myStage.lWidth&&Ground.Mines[pos_in_map+2]>0){
          myStage.ground.createMine(x_pos+2, y_pos, 1);
        }
        if(x_pos-2>-1&&Ground.Mines[pos_in_map-2]>0){
          myStage.ground.createMine(x_pos-2, y_pos, 1);
        }
        if(y_pos+2<myStage.lHeight&&Ground.Mines[pos_in_map+myStage.lWidth*2]>0){
          myStage.ground.createMine(x_pos, y_pos+2, 1);
        }
        if(y_pos-2>-1&&Ground.Mines[pos_in_map-myStage.lWidth*2]>0){
          myStage.ground.createMine(x_pos, y_pos-2, 1);
        }
        if(x_pos+1<myStage.lWidth&&y_pos+1<myStage.lHeight&&Ground.Mines[pos_in_map+1+myStage.lWidth*1]>0){
          myStage.ground.createMine(x_pos+1, y_pos+1, 1);
        }
        if(x_pos-1>-1&&y_pos-1>-1&&Ground.Mines[pos_in_map-1-myStage.lWidth*1]>0){
          myStage.ground.createMine(x_pos-1, y_pos-1, 1);
        }
        if(y_pos-1>-1&&x_pos+1<myStage.lWidth&&Ground.Mines[pos_in_map-myStage.lWidth*1+1]>0){
          myStage.ground.createMine(x_pos+1, y_pos-1, 1);
        }
        if(y_pos+1<myStage.lHeight&&x_pos-1>-1&&Ground.Mines[pos_in_map+myStage.lWidth*1-1]>0){
          myStage.ground.createMine(x_pos-1, y_pos+1, 1);
        }
        if(x_pos+1<myStage.lWidth&&Ground.Mines[pos_in_map+1]>0){
          myStage.ground.createMine(x_pos+1, y_pos, (Ground.Mines[pos_in_map+1]/10)+1);
        }
        if(x_pos-1>-1&&Ground.Mines[pos_in_map-1]>0){
          myStage.ground.createMine(x_pos-1, y_pos, (Ground.Mines[pos_in_map-1]/10)+1);
        }
        if(y_pos+1<myStage.lHeight&&Ground.Mines[pos_in_map+myStage.lWidth*1]>0){
          myStage.ground.createMine(x_pos, y_pos+1, (Ground.Mines[pos_in_map+myStage.lWidth*1]/10)+1);
        }
        if(y_pos-1>-1&&Ground.Mines[pos_in_map-myStage.lWidth*1]>0){
          myStage.ground.createMine(x_pos, y_pos-1, (Ground.Mines[pos_in_map-myStage.lWidth*1]/10)+1);
        }
        if(x_pos+3<myStage.lWidth&&Ground.Mines[pos_in_map+3]>0){
          myStage.ground.createMine(x_pos+3, y_pos, 0);
        }
        if(x_pos-3>-1&&Ground.Mines[pos_in_map-3]>0){
          myStage.ground.createMine(x_pos-3, y_pos, 0);
        }
        if(y_pos+3<myStage.lHeight&&Ground.Mines[pos_in_map+myStage.lWidth*3]>0){
          myStage.ground.createMine(x_pos, y_pos+3, 0);
        }
        if(y_pos-3>-1&&Ground.Mines[pos_in_map-myStage.lWidth*3]>0){
          myStage.ground.createMine(x_pos, y_pos-3, 0);
        }
        if(x_pos+2<myStage.lWidth&&y_pos-1>-1&&Ground.Mines[pos_in_map+2-myStage.lWidth]>0){
          myStage.ground.createMine(x_pos+2, y_pos-1, 0);
        }
        if(x_pos+2<myStage.lWidth&&y_pos+1<myStage.lHeight&&Ground.Mines[pos_in_map+2+myStage.lWidth]>0){
          myStage.ground.createMine(x_pos+2, y_pos+1, 0);
        }
        if(x_pos-2>-1&&y_pos-1>-1&&Ground.Mines[pos_in_map-2-myStage.lWidth]>0){
          myStage.ground.createMine(x_pos-2, y_pos-1, 0);
        }
        if(x_pos-2>-1&&y_pos+1<myStage.lHeight&&Ground.Mines[pos_in_map-2+myStage.lWidth]>0){
          myStage.ground.createMine(x_pos-2, y_pos+1, 0);
        }
        if(y_pos+2<myStage.lHeight&&x_pos-1>-1&&Ground.Mines[pos_in_map+myStage.lWidth*2-1]>0){
          myStage.ground.createMine(x_pos-1, y_pos+2, 0);
        }
        if(y_pos+2<myStage.lHeight&&x_pos+1<myStage.lWidth&&Ground.Mines[pos_in_map+myStage.lWidth*2+1]>0){
          myStage.ground.createMine(x_pos+1, y_pos+2, 0);
        }
        if(y_pos-2>-1&&x_pos-1>-1&&Ground.Mines[pos_in_map-myStage.lWidth*2-1]>0){
          myStage.ground.createMine(x_pos-1, y_pos-2, 0);
        }
        if(y_pos-2>-1&&x_pos+1<myStage.lWidth&&Ground.Mines[pos_in_map-myStage.lWidth*2+1]>0){
          myStage.ground.createMine(x_pos+1, y_pos-2, 0);
        }
      }
		}catch(e:Error){
      //trace("Tank&Mines Error   "+e);
			//trace("Pos  "+x_pos+"   "+y_pos+"   "+pos_in_map);
    }
  }
	
	public function to_send(){
		if(player&&commands.length==0&&!myStage.m3_do&&!myStage.m1_do){
			for(i=1;i<5;i++){
				if(myStage.myCode[i]>0){
					//if(step_count==max_step-Math.floor(myStage.self.socket["ping"]/2)){
						myStage.self.socket.sendEvent(i,+24);
						break;
					//}
				}else if(i==myStage.myCode.length-2){
					myStage.time_c=5;
				}
			}
		}
	}
	
	public function com_test(_ar:Array,_corr:int=0){
		var _b:Boolean=false;
		for(i=0;i<commands1.length;i++){
			if(_ar[0]==commands1[i]&&_ar[1]==pos_ar1[i]){
				commands1.splice(0, i+1);
				pos_ar1.splice(0, i+1);
				last_pack=[_ar[0],_ar[1]];
				_b=true;
				break;
			}
		}
		if(correct||_corr>0){
			_b=false;
			correct=false;
		}
		if(_corr>0){
			_b=false;
			correct=true;
		}
		if(!_b){
			if(commands1.length>0){
				commands1=new Array();
				pos_ar1=new Array();
			}
			com_buff=new Array();
			pos_buff=new Array();
			commands.push(_ar[0]);
			pos_ar.push(_ar[1]);
		}
	}
	
	public function com_reset(){
		commands1=new Array();
		pos_ar1=new Array();
		com_buff=new Array();
		pos_buff=new Array();
		commands=new Array();
		pos_ar=new Array();
	}
	
	public function self_go(){
		if(commands.length>0||com_buff.length==0){
			//com_buff=new Array();
			//pos_buff=new Array();
			return;
		}
		//if(player)trace(com_buff.length+"   "+pos_in_map+"   "+next_pos+"   "+pos_buff[0]+"   "+com_buff[0]+"   "+rat+"   "+mmove);
		if(com_buff[0]<5){
			if(!mround&&!mmove){
				if(com_buff[0]==1){
					at_left=true;
					mround=true;
					go=true;
				}else if(com_buff[0]==2){
					at_up=true;
					mround=true;
					go=true;
				}else if(com_buff[0]==3){
					at_right=true;
					mround=true;
					go=true;
				}else if(com_buff[0]==4){
					at_down=true;
					mround=true;
					go=true;
				}
				com_buff.shift();
				pos_buff.shift();
			}
		}else{
			//trace("self   "+SPEED+"   "+pos_in_map+"   "+X+"   "+Y);
			speed=SPEED;
			max_step=24/speed;
			if(!mmove&&!mround){
				rat=com_buff[0]-4;
				var n_p:int=0;
				var x_p:int=0;
				var y_p:int=0;
				if(rat==1){
					n_p=pos_in_map-1;
					x_p=x_pos-1;
				}else if(rat==2){
					n_p=pos_in_map-myStage.lWidth;
					y_p=y_pos-1;
				}else if(rat==3){
					n_p=pos_in_map+1;
					x_p=x_pos+1;
				}else if(rat==4){
					n_p=pos_in_map+myStage.lWidth;
					y_p=y_pos+1;
				}
				if((x_p<0||x_p>myStage.lWidth-1)||(y_p<0||y_p>myStage.lHeight-1)){
					com_buff.shift();
					pos_buff.shift();
					return;
				}
				if(int(myStage.walls[n_p])!=0){
					com_buff.shift();
					pos_buff.shift();
					return;
				}
				if(int(free_pos[n_p])!=0){
					if(!myStage.objs[free_pos[n_p]]["mmove"]){
						com_buff.shift();
						pos_buff.shift();
						return;
					}else{
						if(n_p==myStage.objs[free_pos[n_p]]["next_pos"]){
							com_buff.shift();
							pos_buff.shift();
							return;
						}
					}
				}
				
				if(free_pos[pos_in_map]==_num)free_pos[pos_in_map]=0;
				if(free_pos[last_pos]==_num)free_pos[last_pos]=0;
				next_pos=n_p;
				graphics.clear();
				if(com_buff[0]-4==1){
					frame=3;
				}else if(com_buff[0]-4==2){
					frame=6;
				}else if(com_buff[0]-4==3){
					frame=9;
				}else if(com_buff[0]-4==4){
					frame=0;
				}
				graphics.beginBitmapFill(t1_frames[frame]);
				graphics.drawRect(0, 0, 26, 26);
				
				if(rat==1){
					X+=(rat-2)*speed;
					step_count++;
					mmove=true;
					go=true;
				}else if(rat==2){
					Y+=(rat-3)*speed;
					step_count++;
					mmove=true;
					go=true;
				}else if(rat==3){
					X+=(rat-2)*speed;
					step_count++;
					mmove=true;
					go=true;
				}else if(rat==4){
					Y+=(rat-3)*speed;
					step_count++;
					mmove=true;
					go=true;
				}
				x=int(X);
				y=int(Y);
				t_cl.x=x+4;
				t_cl.y=y+4;
				p_cl.x=x-15;
				p_cl.y=y-15;
				
				com_buff.shift();
				pos_buff.shift();
			}
		}
	}
	
	public function f_repeat(){
			if(go){
				return;
			}
			if(commands.length>0){
				//if(player)trace(commands.length+"   "+pos_in_map+"   "+next_pos+"   "+pos_ar[0]+"   "+mmove);
				if(commands.length>1){
					mmove=go=false;
					if(free_pos[pos_in_map]==_num)free_pos[pos_in_map]=0;
					if(free_pos[last_pos]==_num)free_pos[last_pos]=0;
					free_pos[pos_ar[0]]=_num;
					pos_in_map=pos_ar[0];
					next_pos=pos_ar[0];
					x_pos=(pos_in_map%myStage.lWidth);
					y_pos=(pos_in_map/myStage.lWidth);
					x=X=x_pos*24-1;
					y=Y=y_pos*24-1;
					t_cl.x=x+4;
					t_cl.y=y+4;
					p_cl.x=x-15;
					p_cl.y=y-15;
					step_count=0;
					commands.shift();
					pos_ar.shift();
					wayTest();
					return;
				}else{
					if(commands[0]<5){
						if(!mmove){
							if(pos_in_map!=pos_ar[0]){
								//if(player)trace(commands.length+"   "+pos_in_map+"   "+next_pos+"   "+pos_ar[0]+"   "+"round");
								if(free_pos[pos_in_map]==_num)free_pos[pos_in_map]=0;
								if(free_pos[last_pos]==_num)free_pos[last_pos]=0;
								free_pos[pos_ar[0]]=_num;
								pos_in_map=pos_ar[0];
								next_pos=pos_ar[0];
								x_pos=(pos_in_map%myStage.lWidth);
								y_pos=(pos_in_map/myStage.lWidth);
								x=X=x_pos*24-1;
								y=Y=y_pos*24-1;
								t_cl.x=x+4;
								t_cl.y=y+4;
								p_cl.x=x-15;
								p_cl.y=y-15;
								wayTest();
							}
						}
						if(commands[0]==1){
							at_left=true;
							mround=true;
							go=true;
						}else if(commands[0]==2){
							at_up=true;
							mround=true;
							go=true;
						}else if(commands[0]==3){
							at_right=true;
							mround=true;
							go=true;
						}else if(commands[0]==4){
							at_down=true;
							mround=true;
							go=true;
						}
						commands.shift();
						pos_ar.shift();
					}else{
						rat=commands[0]-4;
						if(pos_in_map!=pos_ar[0]){
							//if(player)trace(commands.length+"   "+pos_in_map+"   "+next_pos+"   "+pos_ar[0]+"   "+"move");
							if(free_pos[pos_in_map]==_num)free_pos[pos_in_map]=0;
							if(free_pos[last_pos]==_num)free_pos[last_pos]=0;
							free_pos[pos_ar[0]]=_num;
							pos_in_map=pos_ar[0];
							next_pos=pos_ar[0];
							x_pos=(pos_in_map%myStage.lWidth);
							y_pos=(pos_in_map/myStage.lWidth);
							x=X=x_pos*24-1;
							y=Y=y_pos*24-1;
							t_cl.x=x+4;
							t_cl.y=y+4;
							p_cl.x=x-15;
							p_cl.y=y-15;
						}
						var n_p:int=0;
						var x_p:int=0;
						var y_p:int=0;
						if(rat==1){
							n_p=pos_in_map-1;
							x_p=x_pos-1;
						}else if(rat==2){
							n_p=pos_in_map-myStage.lWidth;
							y_p=y_pos-1;
						}else if(rat==3){
							n_p=pos_in_map+1;
							x_p=x_pos+1;
						}else if(rat==4){
							n_p=pos_in_map+myStage.lWidth;
							y_p=y_pos+1;
						}
						if(int(myStage.walls[n_p])!=0){
							myStage.walls[n_p]=0;
							myStage.wall.createOne(n_p,0);
						}
						if(myStage.pl_clip!=null){
							if(!myStage.pl_clip["mmove"]){
								if(n_p==myStage.pl_clip["pos_in_map"]){
									var t_p:int=free_pos[n_p];
									var t_r:int=0;
									var t_n_p:int=0;
									if(free_pos[myStage.pl_clip["pos_in_map"]]==myStage.pl_clip["_num"])free_pos[myStage.pl_clip["pos_in_map"]]=0;
									if(free_pos[myStage.pl_clip["next_pos"]]==myStage.pl_clip["_num"])free_pos[myStage.pl_clip["next_pos"]]=0;
									if(free_pos[myStage.pl_clip["last_pos"]]==myStage.pl_clip["_num"])free_pos[myStage.pl_clip["last_pos"]]=0;
									myStage.pl_clip["step_count"]=0;
									myStage.pl_clip["com_buff"]=new Array();
									myStage.pl_clip["pos_buff"]=new Array();
									myStage.pl_clip["commands1"]=new Array();
									myStage.pl_clip["pos_ar1"]=new Array();
									if(myStage.pl_clip["last_pack"][0]<5){
										t_r=myStage.pl_clip["last_pack"][0];
										t_n_p=myStage.pl_clip["last_pack"][1];
									}else{
										myStage.pl_clip["rat"]=myStage.pl_clip["last_pack"][0]-4;
										if(myStage.pl_clip["rat"]==1){
											t_n_p=myStage.pl_clip["last_pack"][1]-1;
										}else if(myStage.pl_clip["rat"]==2){
											t_n_p=myStage.pl_clip["last_pack"][1]-myStage.lWidth;
										}else if(myStage.pl_clip["rat"]==3){
											t_n_p=myStage.pl_clip["last_pack"][1]+1;
										}else if(myStage.pl_clip["rat"]==4){
											t_n_p=myStage.pl_clip["last_pack"][1]+myStage.lWidth;
										}
									}
									if(t_n_p!=n_p){
										myStage.pl_clip["mmove"]=myStage.pl_clip["go"]=false;
										myStage.pl_clip["commands"]=new Array();
										myStage.pl_clip["pos_ar"]=new Array();
										myStage.pl_clip["rat"]=t_r;
										myStage.pl_clip["pos_in_map"]=t_n_p;
										myStage.pl_clip["next_pos"]=t_n_p;
										myStage.pl_clip["x_pos"]=(myStage.pl_clip["pos_in_map"]%myStage.lWidth);
										myStage.pl_clip["y_pos"]=(myStage.pl_clip["pos_in_map"]/myStage.lWidth);
										myStage.pl_clip.x=myStage.pl_clip["X"]=myStage.pl_clip["x_pos"]*24-1;
										myStage.pl_clip.y=myStage.pl_clip["Y"]=myStage.pl_clip["y_pos"]*24-1;
										myStage.pl_clip["t_cl"].x=myStage.pl_clip.x+4;
										myStage.pl_clip["t_cl"].y=myStage.pl_clip.y+4;
										myStage.pl_clip["p_cl"].x=myStage.pl_clip.x-15;
										myStage.pl_clip["p_cl"].y=myStage.pl_clip.y-15;
										if(myStage.pl_clip["rat"]==1){
											myStage.pl_clip["frame"]=3;
										}else if(myStage.pl_clip["rat"]==2){
											myStage.pl_clip["frame"]=6;
										}else if(myStage.pl_clip["rat"]==3){
											myStage.pl_clip["frame"]=9;
										}else if(myStage.pl_clip["rat"]==4){
											myStage.pl_clip["frame"]=0;
										}
										graphics.clear();
										graphics.beginBitmapFill(myStage.pl_clip.t1_frames[myStage.pl_clip.frame]);
										graphics.drawRect(0, 0, 26, 26);
										myStage.pl_clip.wayTest();
									}else{
										correct=true;
									}
								}
							}else{
								if(n_p==myStage.pl_clip["next_pos"]){
									var t_p:int=free_pos[n_p];
									var t_r:int=0;
									var t_n_p:int=0;
									if(free_pos[myStage.pl_clip["pos_in_map"]]==myStage.pl_clip["_num"])free_pos[myStage.pl_clip["pos_in_map"]]=0;
									if(free_pos[myStage.pl_clip["next_pos"]]==myStage.pl_clip["_num"])free_pos[myStage.pl_clip["next_pos"]]=0;
									if(free_pos[myStage.pl_clip["last_pos"]]==myStage.pl_clip["_num"])free_pos[myStage.pl_clip["last_pos"]]=0;
									myStage.pl_clip["step_count"]=0;
									myStage.pl_clip["com_buff"]=new Array();
									myStage.pl_clip["pos_buff"]=new Array();
									myStage.pl_clip["commands1"]=new Array();
									myStage.pl_clip["pos_ar1"]=new Array();
									if(myStage.pl_clip["last_pack"][0]<5){
										t_r=myStage.pl_clip["last_pack"][0];
										t_n_p=myStage.pl_clip["last_pack"][1];
									}else{
										myStage.pl_clip["rat"]=myStage.pl_clip["last_pack"][0]-4;
										if(myStage.pl_clip["rat"]==1){
											t_n_p=myStage.pl_clip["last_pack"][1]-1;
										}else if(myStage.pl_clip["rat"]==2){
											t_n_p=myStage.pl_clip["last_pack"][1]-myStage.lWidth;
										}else if(myStage.pl_clip["rat"]==3){
											t_n_p=myStage.pl_clip["last_pack"][1]+1;
										}else if(myStage.pl_clip["rat"]==4){
											t_n_p=myStage.pl_clip["last_pack"][1]+myStage.lWidth;
										}
									}
									if(t_n_p!=n_p){
										myStage.pl_clip["mmove"]=myStage.pl_clip["go"]=false;
										myStage.pl_clip["commands"]=new Array();
										myStage.pl_clip["pos_ar"]=new Array();
										myStage.pl_clip["rat"]=t_r;
										myStage.pl_clip["pos_in_map"]=t_n_p;
										myStage.pl_clip["next_pos"]=t_n_p;
										myStage.pl_clip["x_pos"]=(myStage.pl_clip["pos_in_map"]%myStage.lWidth);
										myStage.pl_clip["y_pos"]=(myStage.pl_clip["pos_in_map"]/myStage.lWidth);
										myStage.pl_clip.x=myStage.pl_clip["X"]=myStage.pl_clip["x_pos"]*24-1;
										myStage.pl_clip.y=myStage.pl_clip["Y"]=myStage.pl_clip["y_pos"]*24-1;
										myStage.pl_clip["t_cl"].x=myStage.pl_clip.x+4;
										myStage.pl_clip["t_cl"].y=myStage.pl_clip.y+4;
										myStage.pl_clip["p_cl"].x=myStage.pl_clip.x-15;
										myStage.pl_clip["p_cl"].y=myStage.pl_clip.y-15;
										if(myStage.pl_clip["rat"]==1){
											myStage.pl_clip["frame"]=3;
										}else if(myStage.pl_clip["rat"]==2){
											myStage.pl_clip["frame"]=6;
										}else if(myStage.pl_clip["rat"]==3){
											myStage.pl_clip["frame"]=9;
										}else if(myStage.pl_clip["rat"]==4){
											myStage.pl_clip["frame"]=0;
										}
										graphics.clear();
										graphics.beginBitmapFill(myStage.pl_clip.t1_frames[myStage.pl_clip.frame]);
										graphics.drawRect(0, 0, 26, 26);
										myStage.pl_clip.wayTest();
									}else{
										correct=true;
									}
								}
							}
						}
						next_pos=n_p;
						if(!player){
							free_pos[next_pos]=_num;
						}else{
							if(free_pos[pos_in_map]==_num)free_pos[pos_in_map]=0;
							if(free_pos[last_pos]==_num)free_pos[last_pos]=0;
						}
						speed=SPEED;
						max_step=24/speed;
						graphics.clear();
						if(commands[0]-4==1){
							frame=3;
						}else if(commands[0]-4==2){
							frame=6;
						}else if(commands[0]-4==3){
							frame=9;
						}else if(commands[0]-4==4){
							frame=0;
						}
						graphics.beginBitmapFill(t1_frames[frame]);
						graphics.drawRect(0, 0, 26, 26);
						
						if(rat==1){
							X+=(rat-2)*speed;
							step_count++;
							mmove=true;
							go=true;
						}else if(rat==2){
							Y+=(rat-3)*speed;
							step_count++;
							mmove=true;
							go=true;
						}else if(rat==3){
							X+=(rat-2)*speed;
							step_count++;
							mmove=true;
							go=true;
						}else if(rat==4){
							Y+=(rat-3)*speed;
							step_count++;
							mmove=true;
							go=true;
						}
						x=int(X);
						y=int(Y);
						t_cl.x=x+4;
						t_cl.y=y+4;
						p_cl.x=x-15;
						p_cl.y=y-15;
						commands.shift();
						pos_ar.shift();
					}
				}
			}
	}
	
	//public var tsl_c,tsl_st:int=0;
	public var tsl_pos:int=0;
	public var tsl:Boolean=false;
		
	public function render(event:Event){
		/*if(tsl){
			if(tsl_st+tsl_c<myStage.panel["leave_cl"].getStep()){
				teslaOff();
			}
		}*/
			/*if(wait_c1<4){
				wait_c1++;
			}else{*/
				wait_c1=0;
				if(myStage.self["smoke_on"]&&(sm_c>0&&!myStage.self.warn_er)){
					if(wait_c2<sm_c){
						wait_c2++;
					}else{
						wait_c2=0;
						if(stels!=1){
							if(Math.abs(rat-2)==1){
								myStage.self.newSmoke(x+(2-rat)*5+6,y,0,myStage.sm_count);
							}else if(Math.abs(rat-3)==1){
								myStage.self.newSmoke(x+6,y+(3-rat)*5+6,0,myStage.sm_count);
							}
						}
						if(myStage.sm_count<myStage.smokes.length-1){
							myStage.sm_count++;
						}else{
							myStage.sm_count=0;
						}
					}
				}
				if(f_armor){
					p_cl.graphics.clear();
					/*if(pow_count==0){
						trace(pow_step+"   "+pow_time+"   "+myStage.steps);
					}*/
					if(stels==0){
						pow_fr++;
						if(pow_fr>2){
							pow_fr=0;
						}
						p_cl.graphics.beginBitmapFill(Tank.pw_frames[pow_fr].bitmapData);
						p_cl.graphics.drawRect(0, 0, 56, 56);
					}else if(stels==2){
						if((pow_step+pow_time)-myStage.steps<75){
							if(alpha>.9){
								pow_fr=1;
							}else if(alpha<.2){
								pow_fr=0;
							}
							if(pow_fr==0){
								alpha+=.1;
							}else{
								alpha-=.1;
							}
						}
					}
					//p_cl.graphics.endFill();
					pow_count++;
					if(!(pow_step+pow_time>myStage.steps)){
						p_cl.graphics.clear();
						pow_count=0;
						f_armor=false;
						/*if(!player){
							alpha=.6;
						}*/
					}
				}
			//}
			
			////trace(sleep+"   "+mround+"   "+fire_count+"   "+fire_speed);
			/*if(!sleep){
				if(!mround){
				  if(fire_count<fire_speed){
					fire_count++;
				  }else{
					if(player){
					  if(myStage.ammo>0){
						////trace("fire_ready");
						fire_ready=true;
					  }
					}else{
					  fire_ready=true;
					}
					fire_count=0;
					//System.out.println(7/5);
				  }
				  //dofire();
				}
			}*/
			
				
				if(mmove){
				  //if(player)trace(rat+"   "+step_count+"   "+max_step);
					if(step_count<max_step){
						if(stels==0&&step_count==1){
							tracks();
						}
						if(step_count==int((max_step/4)*3)){
							to_send();
							////trace("was go "+speed+"   "+max_step+"   "+rat+"   "+myStage.keep_pos[_num]+"   "+pos_in_map+"   "+x+"   "+y);
						}/*else if(step_count==int(max_step/2)&&!player){
							if(free_pos[pos_in_map]==_num)free_pos[pos_in_map]=0;
							if(free_pos[last_pos]==_num)free_pos[last_pos]=0;
						}*/
						if(Math.abs(rat-2)==1){
							X+=(rat-2)*speed;
							//next_x=x_pos+(rat-2);
						}else if(Math.abs(rat-3)==1){
							Y+=(rat-3)*speed;
							//next_y=y_pos+(rat-3);
						}else{
							//trace("error "+rat);
						}
						step_count++;
						x=int(X);
						y=int(Y);
						t_cl.x=x+4;
						t_cl.y=y+4;
						p_cl.x=x-15;
						p_cl.y=y-15;
						if(player&&int(free_pos[next_pos])!=0&&int(free_pos[next_pos])!=_num){
							if(!myStage.objs[free_pos[next_pos]]["mmove"]||next_pos==myStage.objs[free_pos[next_pos]]["next_pos"]){
								//trace(free_pos[next_pos]);
								mmove=go=false;
								if(free_pos[pos_in_map]==_num)free_pos[pos_in_map]=0;
								if(free_pos[last_pos]==_num)free_pos[last_pos]=0;
								if(free_pos[next_pos]==_num)free_pos[next_pos]=0;
								//free_pos[pos_ar[0]]=_num;
								x=X=x_pos*24-1;
								y=Y=y_pos*24-1;
								t_cl.x=x+4;
								t_cl.y=y+4;
								p_cl.x=x-15;
								p_cl.y=y-15;
								step_count=0;
								com_buff=new Array();
								pos_buff=new Array();
								commands1.shift();
								pos_ar1.shift();
							}
						}
				  }else{
						if(!player){
							if(free_pos[pos_in_map]==_num)free_pos[pos_in_map]=0;
							if(free_pos[last_pos]==_num)free_pos[last_pos]=0;
						}
						wayTest();
						//to_send();
						mmove=false;
					  go=false;
					  step_count=0;
						////trace(x_pos+"   "+y_pos+"   "+pos_in_map+"   "+myStage.keep_pos[_num]);
						
				  }
				}else if(mround){
						/*if(wait_c<4){
							wait_c++;
							return;
						}else{
							wait_c=0;
						}*/
					if(at_left){
						if(frame!=3){
							if(frame>10||frame<3){
								frame++;
							}else{
								frame--;
							}
							if(frame<0){
								frame=11;
							}
							if(frame>11){
								frame=0;
							}
						}else{
							rat=1;
							at_left=false;
							mround=false;
							go=false;
							to_send();
							return;
						}
					}else if(at_right){
						if(frame!=9){
							if(frame<3||frame>9){
								frame--;
								//prevFrame();
							}else{
								frame++;
								//nextFrame();
							}
							if(frame<0){
								frame=11;
							}
							if(frame>11){
								frame=0;
							}
						}else{
							rat=3;
							at_right=false;
							mround=false;
							go=false;
							to_send();
							return;
						}
					}else if(at_up){
						if(frame!=6){
							if(frame>6){
								frame--;
							}else{
								frame++;
							}
							if(frame<0){
								frame=11;
							}
							if(frame>11){
								frame=0;
							}
						}else{
							rat=2;
							at_up=false;
							mround=false;
							go=false;
							to_send();
							return;
						}
					}else if(at_down){
						if(frame!=0){
							if(frame>6){
								frame++;
							}else{
								frame--;
							}
							if(frame<0){
								frame=11;
							}
							if(frame>11){
								frame=0;
							}
						}else{
							rat=4;
							at_down=false;
							mround=false;
							go=false;
							to_send();
							return;
						}
					}
				}
				self_go();
				f_repeat();
				overTest();
				efx_move();
		}
	}
}