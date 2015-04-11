package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	
	public class Turrel extends MovieClip{
		
		public var mskin_s:String="tu_frames";
		public var sc_tp:int=0;
		public var t_cl:MovieClip=new MovieClip();
		public var p_cl:MovieClip=new MovieClip();
		
		public var rat:int;
		public var frame:int=0;
		public var x_pos:int;
		public var y_pos:int;
		public var pos_in_map:int;
		public var ID:int;
		
		public var health:int;
		public var health1:int;
		public var fire_power:int=0;
		public var fire_speed:int=0;
		public var fire_type:int=0;
		public var _type:int;            //команда
		public var _num:int=0;
		public var R:int=0;
		
		public var i:int;
		public var j:int;
		public var pow_count:int;
		public var pow_time:int=30;
		public var pow_step:Number=0;
		public var pow_fr:int=0;
		
		public var at_left:Boolean;
		public var at_right:Boolean;
		public var   at_up:Boolean;
		public var at_down:Boolean;
		public var fire:Boolean;
		public var mround:Boolean;
		public var metal:Boolean;
		public var f_armor:Boolean;
		public var left_free:Boolean;
		public var right_free:Boolean;
		public var up_free:Boolean;
		public var down_free:Boolean;
		//public Boolean free_shot;
		
		public var player:Boolean=false;
		public var ebot:Boolean=true;
		public var del:Boolean;
		public var _over:int=0;
		
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
		
		public function Turrel(b:int,_i:int){
			super();
			stop();
			sc_tp=_i;
			mskin_s="tu_frames"+sc_tp;
			ID=b;
			//rat=Math.floor(Math.abs(Math.random()*4)+1);
			rat=1;
			if(rat<4){
				frame=(rat)*4;
			}else{
				frame=0;
			}
			//trace("rat   "+rat+"   "+frame+"   "+count);
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
			graphics.drawRect(0, 0, 30, 30);
			addChild(t_cl);
			addEventListener(Event.ENTER_FRAME, render);
			//p_cl.x=x-13;
			//p_cl.y=y-13;
		}
		
		public function healthTest(){
			if(health1>0){
				if(health<=0){
					del=true;
				}
				t_cl.graphics.clear();
				t_cl.graphics.beginFill(0x4e1602,.4);
				t_cl.graphics.lineStyle(1, 0x4e1602, 1);
				t_cl.graphics.drawRect(-2,-5,30,3);
				t_cl.graphics.beginFill(0xff0000,1);
				t_cl.graphics.lineStyle(1, 0x4e1602, 1);
				t_cl.graphics.drawRect(-2,-5,(health/health1)*30,2);
			}
		}
		
		public var trgt:MovieClip;
		
		public function wayTest(){
    	metal=false;
			if(trgt!=null){
				if(trgt["stels"]==0){
					if(trgt.x_pos==x_pos){
						if(Math.abs(trgt.y_pos-y_pos)<=R){
							if(trgt.y_pos<y_pos){
								for(j=pos_in_map;j>pos_in_map-(y_pos-trgt.y_pos)*myStage.lWidth;j-=myStage.lWidth){
									if(myStage.walls[j]>8){
										if(myStage.walls[j]<11){
											metal=true;
											break;
										}
									}
								}
								if(!metal||up_free){
									if(rat!=2){
										at_up=true;
										if(!mround){
											if(Math.floor(Math.random()*2)==0){
												myStage.self.playSound("round",0);
											}else{
												myStage.self.playSound("round1",0);
											}
											mround=true;
										}
										return;
									}else{
										//waiting=true;
										return;
									}
								}else{
									return;
								}
							}else{
								for(j=pos_in_map;j<pos_in_map+(trgt.y_pos-y_pos)*myStage.lWidth;j+=myStage.lWidth){
									if(myStage.walls[j]>8){
										if(myStage.walls[j]<11){
											metal=true;
											break;
										}
									}
								}
								if(!metal||down_free){
									if(rat!=4){
										at_down=true;
										if(!mround){
											if(Math.floor(Math.random()*2)==0){
												myStage.self.playSound("round",0);
											}else{
												myStage.self.playSound("round1",0);
											}
											mround=true;
										}
										return;
									}else{
										//waiting=true;
										return;
									}
								}else{
									return;
								}
							}
						}
					}else if(trgt.y_pos==y_pos){
						if(Math.abs(trgt.x_pos-x_pos)<=R){
							if(trgt.x_pos<x_pos){
								for(j=pos_in_map;j>pos_in_map-(x_pos-trgt.x_pos);j--){
									if(myStage.walls[j]>8){
										if(myStage.walls[j]<11){
											metal=true;
											break;
										}
									}
								}
								if(!metal||left_free){
									if(rat!=1){
										at_left=true;
										if(!mround){
											if(Math.floor(Math.random()*2)==0){
												myStage.self.playSound("round",0);
											}else{
												myStage.self.playSound("round1",0);
											}
											mround=true;
										}
										return;
									}else{
										//waiting=true;
										return;
									}
								}else{
									return;
								}
							}else{
								for(j=pos_in_map;j<pos_in_map+Math.abs(trgt.x_pos-x_pos);j++){
									if(myStage.walls[j]>8){
										if(myStage.walls[j]<11){
											metal=true;
											break;
										}
									}
								}
								if(!metal||right_free){
									if(rat!=3){
										at_right=true;
										if(!mround){
											if(Math.floor(Math.random()*2)==0){
												myStage.self.playSound("round",0);
											}else{
												myStage.self.playSound("round1",0);
											}
											mround=true;
										}
										return;
									}else{
										//waiting=true;
										return;
									}
								}else{
									return;
								}
							}
						}
					}
				}
				trgt=null;
			}
			
      for(i=0;i<myStage.objs.length;i++){
      	if(myStage.objs[i]!=null){
					if(myStage.obj_obj[i]==1&&myStage.obj_type[i]<3){
						if(myStage.objs[i]["stels"]==0){
							if(myStage.objs[i].x_pos==x_pos){
								if(Math.abs(myStage.objs[i].y_pos-y_pos)<=R){
									metal=false;
									if(myStage.objs[i].y_pos<y_pos){
										for(j=pos_in_map;j>pos_in_map-(y_pos-myStage.objs[i].y_pos)*myStage.lWidth;j-=myStage.lWidth){
											if(myStage.walls[j]>8){
												if(myStage.walls[j]<11){
													metal=true;
													break;
												}
											}
										}
										if(!metal||up_free){
											trgt=myStage.objs[i];
											if(rat!=2){
												at_up=true;
												if(!mround){
													if(Math.floor(Math.random()*2)==0){
														myStage.self.playSound("round",0);
													}else{
														myStage.self.playSound("round1",0);
													}
													mround=true;
												}
											}else{
												//waiting=true;
											}
											break;
										}
									}else{
										for(j=pos_in_map;j<pos_in_map+(myStage.objs[i].y_pos-y_pos)*myStage.lWidth;j+=myStage.lWidth){
											if(myStage.walls[j]>8){
												if(myStage.walls[j]<11){
													metal=true;
													break;
												}
											}
										}
										if(!metal||down_free){
											trgt=myStage.objs[i];
											if(rat!=4){
												at_down=true;
												if(!mround){
													if(Math.floor(Math.random()*2)==0){
														myStage.self.playSound("round",0);
													}else{
														myStage.self.playSound("round1",0);
													}
													mround=true;
												}
											}else{
												//waiting=true;
											}
											break;
										}
									}
								}
							}else if(myStage.objs[i].y_pos==y_pos){
								if(Math.abs(myStage.objs[i].x_pos-x_pos)<=R){
									if(myStage.objs[i].x_pos<x_pos){
										for(j=pos_in_map;j>pos_in_map-(x_pos-myStage.objs[i].x_pos);j--){
											if(myStage.walls[j]>8){
												if(myStage.walls[j]<11){
													metal=true;
													break;
												}
											}
										}
										if(!metal||left_free){
											trgt=myStage.objs[i];
											if(rat!=1){
												at_left=true;
												if(!mround){
													if(Math.floor(Math.random()*2)==0){
														myStage.self.playSound("round",0);
													}else{
														myStage.self.playSound("round1",0);
													}
													mround=true;
												}
											}else{
												//waiting=true;
											}
											break;
										}
									}else{
										for(j=pos_in_map;j<pos_in_map+Math.abs(myStage.objs[i].x_pos-x_pos);j++){
											if(myStage.walls[j]>8){
												if(myStage.walls[j]<11){
													metal=true;
													break;
												}
											}
										}
										if(!metal||right_free){
											trgt=myStage.objs[i];
											if(rat!=3){
												at_right=true;
												if(!mround){
													if(Math.floor(Math.random()*2)==0){
														myStage.self.playSound("round",0);
													}else{
														myStage.self.playSound("round1",0);
													}
													mround=true;
												}
											}else{
												//waiting=true;
											}
											break;
										}
									}
								}
							}
						}
          }
				}
			}
		}
		
		public static function check_t(pos:int,vect:int,turr:Turrel){
			if(vect==1){
				var lim:int=pos-(pos%myStage.lWidth)-1;
				for(var n:int=pos;n>lim;n--){
					if(Tank.free_pos[n]>0){
						turr["trgt"]=myStage.objs[Tank.free_pos[n]];
						return;
					}
				}
			}else if(vect==3){
				var lim:int=myStage.lWidth*(int(pos/myStage.lWidth)+1);
				for(var n:int=pos;n<lim;n++){
					if(Tank.free_pos[n]>0){
						turr["trgt"]=myStage.objs[Tank.free_pos[n]];
						return;
					}
				}
			}else if(vect==2){
				var lim:int=0;
				for(var n:int=pos;n>lim;n-=myStage.lWidth){
					if(Tank.free_pos[n]>0){
						turr["trgt"]=myStage.objs[Tank.free_pos[n]];
						return;
					}
				}
			}else if(vect==4){
				var lim:int=myStage.lWidth*myStage.lHeight;
				for(var n:int=pos;n<lim;n+=myStage.lWidth){
					if(Tank.free_pos[n]>0){
						turr["trgt"]=myStage.objs[Tank.free_pos[n]];
						return;
					}
				}
			}
			turr["trgt"]=myStage.pl_clip;
		}
		
		public static function dofire(turr:Turrel, at_vect:int,pos:int,ident:int,_ar:Array=null,_efx:int=-1){
		////trace("Turr shut   "+turr+"   "+at_vect+"   "+pos+"   "+ident);
            myStage.objs[ident]=(new Bullet());
            if(Math.abs(at_vect-2)==1){
              myStage.objs[ident].x=(Math.floor((pos-1)%myStage.lWidth)*24+myStage.board_x)+(at_vect-2)*10;
            }else{
              myStage.objs[ident].x=(Math.floor((pos-1)%myStage.lWidth)*24+myStage.board_x)+2;
            }
            if(Math.abs(at_vect-3)==1){
              myStage.objs[ident].y=(Math.floor((pos-1)/myStage.lWidth)*24+myStage.board_y)+(at_vect-3)*10;
            }else{
              myStage.objs[ident].y=(Math.floor((pos-1)/myStage.lWidth)*24+myStage.board_y)+1;
            }
            myStage.objs[ident].rat=at_vect;
            myStage.objs[ident]._num=ident;
            myStage.objs[ident].turrel=turr;
            myStage.objs[ident]._type=turr._type;
            myStage.objs[ident].power=turr.fire_power/10;
            myStage.objs[ident].player=false;
						myStage.objs[ident].ID=ident;
						myStage.objs[ident].ebot=true;
						myStage.objs[ident].step_b=myStage.steps;
						myStage.objs[ident].x-=4;
						myStage.objs[ident].y-=4;
						myStage.objs[ident].X=int(myStage.objs[ident].x);
						myStage.objs[ident].Y=int(myStage.objs[ident].y);
						myStage.obj_obj[ident]=0;
            /*if(at_vect!=4){
              myStage.objs[ident]["frame"]=(at_vect+((tank.fire_power-10)/20)*4);
            }else{
              myStage.objs[ident]["frame"]=(0+((tank.fire_power-10)/20)*4);
            }*/
						if(at_vect!=4){
              myStage.objs[ident]["frame"]=at_vect;
            }else{
              myStage.objs[ident]["frame"]=0;
            }
						if(turr.rat!=at_vect){
							try{
								check_t(turr.pos_in_map,at_vect,turr);
							}catch(er:Error){}
						}
						//trace(turr.fire_type);
						if(turr.fire_type>1&&turr.fire_type<4){
							myStage.objs[ident]["frame"]+=4;
							myStage.self.playSound("shot3",0);
						}else if(turr.fire_type>5){
							myStage.objs[ident]["frame"]+=12;
							myStage.self.playSound("plazma",0);
						}else if(turr.fire_type>3){
							myStage.objs[ident]["frame"]+=8;
							myStage.self.playSound("plazma",0);
						}else if(turr.fire_type<0){
							myStage.self.playSound("shot1",0);
						}else{
							myStage.self.playSound("shot2",0);
						}
						myStage.objs[ident].setFrames(_efx);
  	}
		
		public function render(event:Event){
				
				if(f_armor){
					p_cl.graphics.clear();
					pow_fr++;
					if(pow_fr>2){
						pow_fr=0;
					}
					p_cl.graphics.beginBitmapFill(Tank.pw_frames[pow_fr].bitmapData);
					p_cl.graphics.drawRect(0, 0, 56, 56);
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
			
				/*if(count>50){
					rand=Math.floor(Math.abs(Math.random()*4)+1);
					rat=rand;
					if(rand==1){
						at_left=true;
					}else if(rand==2){
						at_up=true;
					}else if(rand==3){
						at_right=true;
					}else if(rand==4){
						at_down=true;
					}
					count=0;
				}else{
					count++;
				}*/
				
				if(at_left){
				  if(frame!=4){
						graphics.clear();
						//clip[frame].visible=false;
						if(frame>10||frame<4){
							frame++;
							//setFrame(frame);
						}else{
							frame--;
							//setFrame(frame);
						}
						if(frame<0){
							frame=15;
						}
						if(frame>15){
							frame=0;
						}
						graphics.beginBitmapFill(Tank[mskin_s][frame].bitmapData);
						graphics.drawRect(0, 0, 30, 30);
						//graphics.endFill();
						//clip[frame].visible=true;
				  }else{
						rat=1;
						at_left=false;
						mround=false;
						wayTest();
						return;
				  }
				}else if(at_right){
				  if(frame!=12){
						graphics.clear();
						//clip[frame].visible=false;
						if(frame<4||frame>12){
							frame--;
							//prevFrame();
						}else{
							frame++;
							//nextFrame();
						}
						if(frame<0){
							frame=15;
						}
						if(frame>15){
							frame=0;
						}
						graphics.beginBitmapFill(Tank[mskin_s][frame].bitmapData);
						graphics.drawRect(0, 0, 30, 30);
						//graphics.endFill();
						//clip[frame].visible=true;
				  }else{
						rat=3;
						at_right=false;
						mround=false;
						wayTest();
						return;
				  }
				}else if(at_up){
				  if(frame!=8){
						graphics.clear();
						//clip[frame].visible=false;
						if(frame>8){
							frame--;
							//prevFrame();
						}else{
							frame++;
							//nextFrame();
						}
						if(frame<0){
							frame=15;
						}
						if(frame>15){
							frame=0;
						}
						graphics.beginBitmapFill(Tank[mskin_s][frame].bitmapData);
						graphics.drawRect(0, 0, 30, 30);
						//graphics.endFill();
						//clip[frame].visible=true;
				  }else{
						rat=2;
						at_up=false;
						mround=false;
						wayTest();
						return;
				  }
				}else if(at_down){
				  if(frame!=0){
						graphics.clear();
						//clip[frame].visible=false;
						if(frame>8){
							frame++;
							//nextFrame();
						}else{
							frame--;
							//prevFrame();
						}
						if(frame<0){
							frame=15;
						}
						if(frame>15){
							frame=0;
						}
						graphics.beginBitmapFill(Tank[mskin_s][frame].bitmapData);
						graphics.drawRect(0, 0, 30, 30);
						//graphics.endFill();
						//clip[frame].visible=true;
				  }else{
						//frame=0;
						rat=4;
						at_down=false;
						mround=false;
						wayTest();
						return;
				  }
				}else{
					wayTest();
				}
				//overTest();
			/*}else{
			  	count1++;
			}*/
		}
	}
	
}