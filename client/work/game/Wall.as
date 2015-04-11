package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	
	public class Wall extends MovieClip{
		
		public static var objects:Array=new Array(myStage.lWidth*myStage.lHeight);
		public static var overs:Array=new Array();
		public static var completed:Boolean=false;
		public static var ov_pos:int=0;
		
		public function Wall(){
			super();
			createGround(myStage.lib.png.walls);
			/*addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent){
			//trace((int(mouseX/24)+1)+(int(mouseY/24))*myStage.lWidth));
				addEventListener(Event.ENTER_FRAME, overTest);
				Mouse.cursor=MouseCursor.BUTTON;
			});
			addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent){
				removeEventListener(Event.ENTER_FRAME, overTest);
				overs=new Array();
				createOne(ov_pos,myStage.walls[ov_pos],1);
				Mouse.cursor=MouseCursor.AUTO;
			});*/
		}
		
		public static function exp_efx(_x:int,_y:int,_type:int){
			if(_type==1){
				var _cl:MovieClip=new myStage.expld2();
			}else if(_type==2){
				var _cl:MovieClip=new myStage.expld3();
			}else if(_type==3){
				var _cl:MovieClip=new myStage.expld4();
			}
			//trace(_type+"   "+_cl.width/2+"   "+_cl.height/2);
			_cl.x=_x;
			_cl.y=_y;
			myStage.expls.addChild(_cl);
		}
		
		public function overTest(event:Event){
			overs=new Array();
			createOne(ov_pos,myStage.walls[ov_pos],1);
			ov_pos=((int(mouseX/24))+(int(mouseY/24))*myStage.lWidth);
			overs[ov_pos]=1;
			createOne(ov_pos,myStage.walls[ov_pos],1);
		}
		
		public function createOne(pos:int,num:int,_ov:int=0){
			if(objects[pos]!=null){
				objects[pos].parent.removeChild(objects[pos]);
				objects[pos]=null;
			}
				if(num>0){
					var x1:int=(num-1)*24;
					var rect:Rectangle=new Rectangle(x1,0,24,24);
					var rect1:Rectangle=new Rectangle(0,0,24,24);
					var bmd:BitmapData=new BitmapData(24,24,true,0xFFFFFFFF);
					var myBitmap:Bitmap=new Bitmap(bmd, "auto", false);
					myBitmap.bitmapData.setVector(rect1,myStage.lib.png.walls.bitmapData.getVector(rect));
					if(overs[pos]>0){
						var shp:Shape = new Shape();
						var mtrx:Matrix = new Matrix();
						mtrx.createGradientBox(24, 24, 0, 0, 0);
						shp.graphics.beginGradientFill(GradientType.RADIAL, myStage.ov_ar[0], myStage.ov_ar[1], myStage.ov_ar[2], mtrx, "pad", "rgb", 0);
						shp.graphics.drawRect(0, 0, 24, 24);
						shp.graphics.endFill();
						var bmd2:BitmapData = new BitmapData(24, 24, true, 0x00ffffff);
						bmd2.draw(shp);
						var pt:Point = new Point(0, 0);
						var mult:uint = 0xff; // 0x80 = 50%
						myBitmap.bitmapData.copyPixels(bmd2, new Rectangle(0,0,24,24), pt, myBitmap.bitmapData, pt, true);
					}
					myBitmap.x=int(pos%myStage.lWidth)*24;
					myBitmap.y=int(pos/myStage.lWidth)*24;
					objects[pos]=myBitmap;
					if(num<19){
						addChild(myBitmap);
					}else{
						myStage.ground.addChild(myBitmap);
					}
				}else if(_ov==0){
					myStage.self.playSound("wall_break",0);
					myStage.self.newEX(int(pos%myStage.lWidth)*24+myStage.board_x-4,int(pos/myStage.lWidth)*24+myStage.board_y-4,0,myStage.bm_count,1);
					myStage.explode=true;
				}
			//}
		}
		
		public function createTurr(num:int,_i:int=0){
			var turr:MovieClip=new Turrel(myStage.obj_id[num],myStage.obj_tail[num]);
			myStage.objs[num]=(turr);
			turr["health1"]=myStage.obj_heal1[num];
			turr["health"]=myStage.obj_heal[num];
			turr["R"]=myStage.obj_R[num];
			if(myStage.obj_gun[num]>-1){
				turr["fire_power"]=myStage.ammo_dm[myStage.obj_gun[num]];
			}else{
				turr["fire_power"]=myStage.basic_dm;
			}
			turr["fire_type"]=myStage.obj_gun[num];
			turr.healthTest();
			turr["fire_speed"]=myStage.obj_speed[num];
			turr.x=int(myStage.obj_pos[num]%myStage.lWidth)*24;
			turr.y=int(myStage.obj_pos[num]/myStage.lWidth)*24;
			turr.x-=3;
			turr.y-=3;
			turr._num=num;
			turr.pos_in_map=myStage.obj_pos[num];
			turr.x_pos=turr.pos_in_map%myStage.lWidth;
			turr.y_pos=turr.pos_in_map/myStage.lWidth;
			turr._type=3;
			turr["p_cl"].x=turr.x-13;
			turr["p_cl"].y=turr.y-13;
			if(_i==0){
				myStage.wall.addChild(turr);
			}
			myStage.ground.addChild(turr["p_cl"]);
			myStage.walls[myStage.obj_pos[num]]=-1;
		}
		
		public function createB_Turr(num:int,_i:int=0){
			var b_turr:MovieClip=new bigTurr(myStage.obj_id[num]);
			myStage.objs[num]=(b_turr);
			b_turr["_type"]=myStage.obj_type[num];
			//trace(b_turr["_type"]+"   "+);
			b_turr["health1"]=myStage.obj_heal1[num];
			b_turr["health"]=myStage.obj_heal[num];
			b_turr["R"]=myStage.obj_R[num];
			if(myStage.obj_gun[num]>-1){
				b_turr["fire_power"]=myStage.ammo_dm[myStage.obj_gun[num]];
			}else{
				b_turr["fire_power"]=myStage.basic_dm;
			}
			b_turr["fire_type"]=myStage.obj_gun[num];
			b_turr.healthTest();
			b_turr["fire_speed"]=myStage.obj_speed[num];
			b_turr.x=int(myStage.obj_pos[num]%myStage.lWidth)*24;
			b_turr.y=int(myStage.obj_pos[num]/myStage.lWidth)*24;
			b_turr.x-=3;
			b_turr.y-=3;
			b_turr._num=num;
			b_turr.pos_in_map=myStage.obj_pos[num];
			b_turr.x_pos=b_turr.pos_in_map%myStage.lWidth;
			b_turr.y_pos=b_turr.pos_in_map/myStage.lWidth;
			if(_i==0){
				myStage.wall.addChild(b_turr);
			}
			myStage.walls[myStage.obj_pos[num]]=-1;
			myStage.walls[myStage.obj_pos[num]+1]=-1;
			myStage.walls[myStage.obj_pos[num]+myStage.lWidth]=-1;
			myStage.walls[myStage.obj_pos[num]+myStage.lWidth+1]=-1;
		}
		
		public function createOil(num:int,_i:int=0){
			var oil:MovieClip=new Oil(myStage.obj_rand[num]);
			myStage.objs[num]=(oil);
			oil["_type"]=myStage.obj_type[num];
			oil["health1"]=myStage.obj_heal1[num];
			oil["health"]=myStage.obj_heal[num];
			oil.healthTest();
			oil.x=int(myStage.obj_pos[num]%myStage.lWidth)*24;
			oil.y=int(myStage.obj_pos[num]/myStage.lWidth)*24;
			oil._num=num;
			oil.pos_in_map=myStage.obj_pos[num];
			oil.x_pos=oil.pos_in_map%myStage.lWidth;
			oil.y_pos=oil.pos_in_map/myStage.lWidth;
			oil._type=myStage.obj_type[num];
			if(_i==0){
				myStage.wall.addChild(oil);
			}
			for(var i:int=0;i<oil["pict"].width/24;i++){
				for(var j:int=0;j<oil["pict"].height/24;j++){
					myStage.walls[myStage.obj_pos[num]+i+myStage.lWidth*j]=-1;
				}
			}
		}
		
		public function createRadar(num:int,_i:int=0){
			var rad_cl:MovieClip=new Radar();
			rad_cl.x=int(myStage.obj_pos[num]%myStage.lWidth)*24;
			rad_cl.y=int(myStage.obj_pos[num]/myStage.lWidth)*24;
			rad_cl["_type"]=myStage.obj_type[num];
			rad_cl["health"]=myStage.obj_heal[num];
			rad_cl["health1"]=myStage.obj_heal1[num];
			rad_cl["pos_in_map"]=myStage.obj_pos[num];
			rad_cl["x_pos"]=rad_cl["pos_in_map"]%myStage.lWidth;
			rad_cl["y_pos"]=rad_cl["pos_in_map"]/myStage.lWidth;
			rad_cl.healthTest();
			myStage.objs[num]=(rad_cl);
			myStage.walls[myStage.obj_pos[num]]=-1;
			myStage.walls[myStage.obj_pos[num]+1]=-1;
			myStage.walls[myStage.obj_pos[num]+myStage.lWidth]=-1;
			myStage.walls[myStage.obj_pos[num]+myStage.lWidth+1]=-1;
			if(_i==0){
				myStage.wall.addChild(rad_cl);
			}
		}
		
		public function createTesla(num:int,_i:int=0){
			var tsl_cl:MovieClip=new Tesla();
			tsl_cl.x=int(myStage.obj_pos[num]%myStage.lWidth)*24;
			tsl_cl.y=int(myStage.obj_pos[num]/myStage.lWidth)*24;
			tsl_cl["_type"]=myStage.obj_type[num];
			tsl_cl["health"]=myStage.obj_heal[num];
			tsl_cl["health1"]=myStage.obj_heal1[num];
			tsl_cl["pos_in_map"]=myStage.obj_pos[num];
			tsl_cl["R"]=myStage.obj_R[num];
			tsl_cl["x_pos"]=tsl_cl["pos_in_map"]%myStage.lWidth;
			tsl_cl["y_pos"]=tsl_cl["pos_in_map"]/myStage.lWidth;
			tsl_cl.healthTest();
			myStage.objs[num]=(tsl_cl);
			myStage.walls[myStage.obj_pos[num]]=-1;
			myStage.walls[myStage.obj_pos[num]+1]=-1;
			myStage.walls[myStage.obj_pos[num]+myStage.lWidth]=-1;
			myStage.walls[myStage.obj_pos[num]+myStage.lWidth+1]=-1;
			
			var _x:int=(myStage.obj_pos[num]%myStage.lWidth);
			var _y:int=(myStage.obj_pos[num]/myStage.lWidth);
			var _w:int=2;
			var _h:int=2;
			var _x1:int=_x-myStage.obj_R[num];
			var _y1:int=_y-myStage.obj_R[num];
			var _x2:int=_x+myStage.obj_R[num]+1;
			var _y2:int=_y+myStage.obj_R[num]+1;
			//trace(myStage.obj_R[num]);
			for(var n:int=0;n<_w;n++){
				for(var k:int=0;k<_h;k++){
					for(var i:int=(_x1+n);i<(_x2+n);i++){
						if(i>-1&&i<myStage.lWidth){
							for(var j:int=(_y1+k);j<(_y2+k);j++){
								if(j>-1&&j<myStage.lHeight){
									//trace((Math.abs(i-_x)+Math.abs(j-_y))+"   "+i+"   "+j+"   "+myStage.lWidth+"   "+(i+j*myStage.lWidth));
									if((Math.abs(i-(_x+n))+Math.abs(j-(_y+k)))<=myStage.obj_R[num]){
										var _ar:Array=new Array();
										var _b:Boolean=false;
										var _pos:int=i+j*myStage.lWidth;
										if(myStage.teslaes[_pos]!=null){
											_ar=myStage.teslaes[_pos];
											for(var q:int=0;q<_ar.length;q++){
												if(_ar[q][2]==num){
													_b=true;
													break;
												}
											}
										}
										if(!_b){
											_ar.push([myStage.obj_type[num],1,num]);
											myStage.teslaes[_pos]=_ar;
											if(int(Tank.free_pos[_pos])>0&&myStage.objs[Tank.free_pos[_pos]]!=null){
												tsl_cl.trgts_fix("t"+Tank.free_pos[_pos],myStage.objs[Tank.free_pos[_pos]]);
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
			if(_i==0){
				myStage.wall.addChild(tsl_cl);
			}
		}
		
		public function createLaser(num:int,_i:int=0){
			var laser:MovieClip=new Laser();
			laser.x=int(myStage.obj_pos[num]%myStage.lWidth)*24;
			laser.y=int(myStage.obj_pos[num]/myStage.lWidth)*24;
			laser["_type"]=myStage.obj_type[num];
			laser["health"]=myStage.obj_heal[num];
			laser["health1"]=myStage.obj_heal1[num];
			laser["pos_in_map"]=myStage.obj_pos[num];
			laser["gr"]=myStage.obj_num[num];
			laser["rat"]=myStage.obj_vect[num];
			laser["x_pos"]=laser["pos_in_map"]%myStage.lWidth;
			laser["y_pos"]=laser["pos_in_map"]/myStage.lWidth;
			laser["_num"]=num;
			laser.setFrames();
			laser.healthTest();
			myStage.objs[num]=(laser);
			myStage.walls[myStage.obj_pos[num]]=-1;
			if(int(laser["rat"]/2)*2==laser["rat"]){
				myStage.walls[myStage.obj_pos[num]+myStage.lWidth]=-1;
			}else{
				myStage.walls[myStage.obj_pos[num]+1]=-1;
			}
			
			if(_i==0){
				myStage.wall.addChild(laser);
			}
		}
		
		public static function resetLaser(num:int,_i:int=0){
			myStage.self.playSound("wall_break",0);
			myStage.explode=true;
			try{
				myStage.objs[num].removeEventListener(Event.ENTER_FRAME, myStage.objs[num].render);
			}catch(er:Error){
				
			}
			myStage.objs[num].efx_del();
			
			//myStage.self.newEX(int(myStage.objs[num].x)+4,int(myStage.objs[num].y)+4,0,myStage.bm_count,1);
			
			myStage.ground.createOne(myStage.objs[num].x,myStage.objs[num].y,2);
			myStage.walls[myStage.obj_pos[num]]=0;
			if(int(myStage.objs[num]["rat"]/2)*2==myStage.objs[num]["rat"]){
				//myStage.self.newEX(int(myStage.objs[num].x)+4,int(myStage.objs[num].y+12)+4,0,myStage.bm_count,1);
				exp_efx(myStage.objs[num].x+12,myStage.objs[num].y+24,1);
				myStage.ground.createOne(myStage.objs[num].x,myStage.objs[num].y+24,2);
				myStage.ground.createOne(myStage.objs[num].x,myStage.objs[num].y+12,3);
				myStage.walls[myStage.obj_pos[num]+myStage.lWidth]=0;
			}else{
				//myStage.self.newEX(int(myStage.objs[num].x+12)+4,int(myStage.objs[num].y)+4,0,myStage.bm_count,1);
				exp_efx(myStage.objs[num].x+24,myStage.objs[num].y+12,1);
				myStage.ground.createOne(myStage.objs[num].x+24,myStage.objs[num].y,2);
				myStage.ground.createOne(myStage.objs[num].x+12,myStage.objs[num].y,3);
				myStage.walls[myStage.obj_pos[num]+1]=0;
			}
			
			myStage.wall.removeChild(myStage.objs[num]);
			myStage.objs[num]=null;
			myStage.obj_id[num]=null;
			myStage.obj_heal[num]=null;
			myStage.obj_heal1[num]=null;
			myStage.obj_pos[num]=null;
			myStage.obj_type[num]=null;
			myStage.obj_num[num]=null;
			myStage.obj_vect[num]=null;
		}
		
		public static function resetOil(num:int,_i:int=0){
			try{
				myStage.objs[num].removeEventListener(Event.ENTER_FRAME, myStage.objs[num].render);
			}catch(er:Error){
				
			}
			for(var i:int=0;i<myStage.objs[num]["pict"].width/24;i++){
				for(var j:int=0;j<myStage.objs[num]["pict"].height/24;j++){
					myStage.walls[myStage.objs[num]["pos_in_map"]+i+myStage.lWidth*j]=0;
					myStage.self.newEX(int(myStage.objs[num].x+8+12*i)+4,int(myStage.objs[num].y+8+20*j)+4,0,myStage.bm_count,1);
				}
			}
			myStage.self.playSound("art",0);
			if(myStage.obj_rand[num]==0){
				exp_efx(myStage.objs[num].x+36,myStage.objs[num].y+24,3);
				
				myStage.self.oil_x.push([myStage.objs[num]["x_pos"]-2,myStage.objs[num]["x_pos"]+5]);
				myStage.self.oil_y.push([myStage.objs[num]["y_pos"]-2,myStage.objs[num]["y_pos"]+4]);
				myStage.ground.createOne(myStage.objs[num].x-4,myStage.objs[num].y-16,4);
				
				myStage.ground.createOne(myStage.objs[num].x,myStage.objs[num].y,1);
				myStage.ground.createOne(myStage.objs[num].x,myStage.objs[num].y+24,1);
				myStage.ground.createOne(myStage.objs[num].x+48,myStage.objs[num].y,1);
				myStage.ground.createOne(myStage.objs[num].x+48,myStage.objs[num].y+24,1);
			}else if(myStage.obj_rand[num]==1){
				exp_efx(myStage.objs[num].x+24,myStage.objs[num].y+36,3);
				
				myStage.self.oil_x.push([myStage.objs[num]["x_pos"]-2,myStage.objs[num]["x_pos"]+4]);
				myStage.self.oil_y.push([myStage.objs[num]["y_pos"]-2,myStage.objs[num]["y_pos"]+5]);
				myStage.ground.createOne(myStage.objs[num].x-16,myStage.objs[num].y-4,4);
				
				myStage.ground.createOne(myStage.objs[num].x,myStage.objs[num].y,1);
				myStage.ground.createOne(myStage.objs[num].x+24,myStage.objs[num].y,1);
				myStage.ground.createOne(myStage.objs[num].x,myStage.objs[num].y+48,1);
				myStage.ground.createOne(myStage.objs[num].x+24,myStage.objs[num].y+48,1);
			}
			myStage.self.oil_c.push(0);
			myStage.self.oil_exp=true;
			
			myStage.wall.removeChild(myStage.objs[num]);
			myStage.objs[num]=null;
			myStage.obj_id[num]=null;
			myStage.obj_heal[num]=null;
			myStage.obj_heal1[num]=null;
			myStage.obj_pos[num]=null;
			myStage.obj_type[num]=null;
			myStage.obj_rand[num]=null;
		}
		
		public static function resetRadar(num:int,_i:int=0){
			myStage.self.newEX(int(myStage.objs[num].x+8)+4,int(myStage.objs[num].y+8)+4,0,myStage.bm_count,1);
			myStage.self.newEX(int(myStage.objs[num].x+20)+4,int(myStage.objs[num].y+20)+4,0,myStage.bm_count,1);
			myStage.self.newEX(int(myStage.objs[num].x+20)+4,int(myStage.objs[num].y+8)+4,0,myStage.bm_count,1);
			myStage.self.newEX(int(myStage.objs[num].x+8)+4,int(myStage.objs[num].y+20)+4,0,myStage.bm_count,1);
			//myStage.self.newEX(int(myStage.objs[num].x-8),int(myStage.objs[num].y-8),0,myStage.bm_count,3);
			exp_efx(myStage.objs[num].x+24,myStage.objs[num].y+24,2);
			myStage.ground.createOne(myStage.objs[num].x-16,myStage.objs[num].y-16,4);
			myStage.self.playSound("wall_break",0);
			myStage.explode=true;
			try{
				myStage.objs[num].removeEventListener(Event.ENTER_FRAME, myStage.objs[num].render);
			}catch(er:Error){
				
			}
			
			myStage.walls[myStage.objs[num]["pos_in_map"]]=0;
			myStage.walls[myStage.objs[num]["pos_in_map"]+1]=0;
			myStage.walls[myStage.objs[num]["pos_in_map"]+myStage.lWidth]=0;
			myStage.walls[myStage.objs[num]["pos_in_map"]+myStage.lWidth+1]=0;
			myStage.wall.removeChild(myStage.objs[num]);
			myStage.objs[num]=null;
			myStage.obj_id[num]=null;
			myStage.obj_heal[num]=null;
			myStage.obj_heal1[num]=null;
			myStage.obj_pos[num]=null;
			myStage.obj_type[num]=null;
		}
		
		public static function resetTesla(num:int,_i:int=0){
			myStage.self.newEX(int(myStage.objs[num].x+8)+4,int(myStage.objs[num].y+8)+4,0,myStage.bm_count,1);
			myStage.self.newEX(int(myStage.objs[num].x+20)+4,int(myStage.objs[num].y+20)+4,0,myStage.bm_count,1);
			myStage.self.newEX(int(myStage.objs[num].x+20)+4,int(myStage.objs[num].y+8)+4,0,myStage.bm_count,1);
			myStage.self.newEX(int(myStage.objs[num].x+8)+4,int(myStage.objs[num].y+20)+4,0,myStage.bm_count,1);
			//myStage.self.newEX(int(myStage.objs[num].x-8),int(myStage.objs[num].y-8),0,myStage.bm_count,3);
			exp_efx(myStage.objs[num].x+24,myStage.objs[num].y+24,2);
			myStage.ground.createOne(myStage.objs[num].x-16,myStage.objs[num].y-16,4);
			myStage.self.playSound("wall_break",0);
			myStage.explode=true;
			try{
				myStage.objs[num].removeEventListener(Event.ENTER_FRAME, myStage.objs[num].render);
			}catch(er:Error){
				
			}
			myStage.objs[num].efx_del();
			myStage.walls[myStage.objs[num]["pos_in_map"]]=0;
			myStage.walls[myStage.objs[num]["pos_in_map"]+1]=0;
			myStage.walls[myStage.objs[num]["pos_in_map"]+myStage.lWidth]=0;
			myStage.walls[myStage.objs[num]["pos_in_map"]+myStage.lWidth+1]=0;
			
			var _x:int=(myStage.objs[num]["pos_in_map"]%myStage.lWidth);
			var _y:int=(myStage.objs[num]["pos_in_map"]/myStage.lWidth);
			var _w:int=2;
			var _h:int=2;
			var _x1:int=_x-myStage.obj_R[num];
			var _y1:int=_y-myStage.obj_R[num];
			var _x2:int=_x+myStage.obj_R[num]+1;
			var _y2:int=_y+myStage.obj_R[num]+1;
			for(var n:int=0;n<_w;n++){
				for(var k:int=0;k<_h;k++){
					for(var i:int=(_x1+n);i<(_x2+n);i++){
						if(i>-1&&i<myStage.lWidth){
							for(var j:int=(_y1+k);j<(_y2+k);j++){
								if(j>-1&&j<myStage.lHeight){
									//trace((Math.abs(i-_x)+Math.abs(j-_y))+"   "+i+"   "+j+"   "+myStage.lWidth+"   "+(i+j*myStage.lWidth));
									if((Math.abs(i-(_x+n))+Math.abs(j-(_y+k)))<=myStage.obj_R[num]){
										var _ar:Array=new Array();
										if(myStage.teslaes[i+j*myStage.lWidth]!=null){
											_ar=myStage.teslaes[i+j*myStage.lWidth];
										}
										//_ar.push([myStage.obj_type[num],1,num]);
										if(_ar.length>1){
											for(var q:int=0;q<_ar.length;q++){
												if(_ar[q][2]==num){
													_ar.splice(q,1);
												}
											}
											myStage.teslaes[i+j*myStage.lWidth]=_ar;
										}else if(_ar.length>0){
											if(_ar[0][2]==num){
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
			}
			
			myStage.wall.removeChild(myStage.objs[num]);
			myStage.objs[num]=null;
			myStage.obj_id[num]=null;
			myStage.obj_heal[num]=null;
			myStage.obj_heal1[num]=null;
			myStage.obj_pos[num]=null;
			myStage.obj_type[num]=null;
			myStage.obj_R[num]=null;
		}
		
		public static function resetB_Turr(num:int,_i:int=0){
			myStage.self.newEX(int(myStage.objs[num].x+8)+4,int(myStage.objs[num].y+8)+4,0,myStage.bm_count,1);
			myStage.self.newEX(int(myStage.objs[num].x+20)+4,int(myStage.objs[num].y+20)+4,0,myStage.bm_count,1);
			myStage.self.newEX(int(myStage.objs[num].x+20)+4,int(myStage.objs[num].y+8)+4,0,myStage.bm_count,1);
			myStage.self.newEX(int(myStage.objs[num].x+8)+4,int(myStage.objs[num].y+20)+4,0,myStage.bm_count,1);
			//myStage.self.newEX(int(myStage.objs[num].x-8),int(myStage.objs[num].y-8),0,myStage.bm_count,3);
			exp_efx(myStage.objs[num].x+24,myStage.objs[num].y+24,2);
			myStage.ground.createOne(myStage.objs[num].x-16,myStage.objs[num].y-16,4);
			myStage.self.playSound("wall_break",0);
			myStage.explode=true;
			try{
				myStage.objs[num].removeEventListener(Event.ENTER_FRAME, myStage.objs[num].render);
			}catch(er:Error){
				
			}
			myStage.walls[myStage.objs[num]["pos_in_map"]]=0;
			myStage.walls[myStage.objs[num]["pos_in_map"]+1]=0;
			myStage.walls[myStage.objs[num]["pos_in_map"]+myStage.lWidth]=0;
			myStage.walls[myStage.objs[num]["pos_in_map"]+myStage.lWidth+1]=0;
			myStage.wall.removeChild(myStage.objs[num]);
			myStage.objs[num]=null;
			myStage.obj_id[num]=null;
			myStage.obj_vect[num]=null;
			myStage.obj_heal[num]=null;
			myStage.obj_heal1[num]=null;
			myStage.obj_gun[num]=null;
			myStage.obj_speed[num]=null;
			myStage.obj_pos[num]=null;
			myStage.obj_R[num]=null;
			myStage.obj_type[num]=null;
		}
		
		public static function resetTurrel(num:int,_i:int=0){
			myStage.self.newEX(int(myStage.objs[num].x-1+4),int(myStage.objs[num].y-1+4),0,myStage.bm_count,1);
			myStage.explode=true;
			myStage.ground.createOne(int(myStage.objs[num].x+3)-18,int(myStage.objs[num].y+3)-18,5);
			myStage.self.playSound("wall_break",0);
			exp_efx(myStage.objs[num].x+15,myStage.objs[num].y+15,1);
			try{
				myStage.objs[num].removeEventListener(Event.ENTER_FRAME, myStage.objs[num].render);
			}catch(er:Error){
				
			}
			myStage.walls[myStage.objs[num]["pos_in_map"]]=0;
			myStage.wall.removeChild(myStage.objs[num]);
			myStage.ground.removeChild(myStage.objs[num]["p_cl"]);
			myStage.objs[num]=null;
			myStage.obj_id[num]=null;
			myStage.obj_vect[num]=null;
			myStage.obj_heal[num]=null;
			myStage.obj_heal1[num]=null;
			myStage.obj_gun[num]=null;
			myStage.obj_speed[num]=null;
			myStage.obj_pos[num]=null;
			myStage.obj_R[num]=null;
		}
		
		public function createGround(bm:Bitmap){
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,24,24);
			var rect:Rectangle;
			var bmd:BitmapData;
			var myBitmap:Bitmap;
			for(var i=0;i<myStage.walls.length;i++){
				////trace(myStage.walls[i]);
				if(myStage.walls[i]>0){
					if(myStage.walls[i]<21){
						////trace(myStage.walls[i]);
						x1=(myStage.walls[i]-1)*24;
						////trace(x1);
						rect=new Rectangle(x1,0,24,24);
						bmd=new BitmapData(24,24,true,0xFFFFFFFF);
						myBitmap=new Bitmap(bmd, "auto", false);
						myBitmap.bitmapData.setVector(rect1,bm.bitmapData.getVector(rect));
						myBitmap.x=int(i%myStage.lWidth)*24;
						myBitmap.y=int(i/myStage.lWidth)*24;
						//myBitmap.pos=i;
						objects[i]=myBitmap;
						if(myStage.walls[i]<19){
							addChild(myBitmap);
						}else{
							myStage.ground.addChild(myBitmap);
						}
					}
				}
			}
			for(var i=0;i<myStage.obj_id.length;i++){
				if(myStage.obj_id[i]!=null){
					if(myStage.obj_obj[i]==2){
						createTurr(i,1);
					}else if(myStage.obj_obj[i]==4){
						createOil(i,1);
					}else if(myStage.obj_obj[i]==3){
						createRadar(i,1);
					}else if(myStage.obj_obj[i]==5){
						createB_Turr(i,1);
					}else if(myStage.obj_obj[i]==6){
						createTesla(i,1);
					}else if(myStage.obj_obj[i]==7){
						createLaser(i,1);
					}
				}
			}
			////trace("completed   "+myStage.oils);
			completed=true;
		}
	}
	
}