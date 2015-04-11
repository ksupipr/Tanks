package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.text.*;
	
	public class Ground extends MovieClip{
		
		//public static var url:String="res/ground.png";
		public var track:MovieClip;
		public var mine:MovieClip;
		public var mloaded:Boolean=false;
		public static var m_buff:Array=new Array(myStage.lWidth*myStage.lHeight);
		public static var Mines:Array=new Array(myStage.lWidth*myStage.lHeight);
		public static var ms:Array=new Array(myStage.lWidth*myStage.lHeight);
		public static var ms_pos:Array=new Array(myStage.lWidth*myStage.lHeight);
		public static var ms_heal:Array=new Array(myStage.lWidth*myStage.lHeight);
		
		public static var tr_frames:Array=new Array();
		
		public function Ground(){
			super();
			//self=this;
			mine=new MovieClip();
			track=new MovieClip();
			Tank.createSmoke();
			createTrack();
			createGround(myStage.lib.png.ground);
			addChild(mine);
			addChild(track);
			createBase(myStage.lib.png.base);
			createTank();
			//createBonus(0, 0);
		}
		
		public function newTrack(pos:int,frame:int,num:int){
			myStage.track_c[num]=0;
			myStage.track_c1[num]=frame;
			myStage.track_pos[num]=pos;
			myStage.tracks[num]=1;
			var matrix:Matrix = new Matrix();
      matrix.translate(int(pos%myStage.lWidth)*24, int(pos/myStage.lWidth)*24);
			track.graphics.beginBitmapFill(tr_frames[frame].bitmapData,matrix);
			track.graphics.drawRect(int(pos%myStage.lWidth*24), int(pos/myStage.lWidth)*24, tr_frames[frame].width,  tr_frames[frame].height);
		}
		
		public function setTrack(pos:int,frame:int,num:int){
			if(myStage.tracks[num]>4){
				myStage.tracks[num]=0;
			}else{
				var matrix:Matrix = new Matrix();
				matrix.translate(int(pos%myStage.lWidth)*24, int(pos/myStage.lWidth)*24);
				track.graphics.beginBitmapFill(tr_frames[frame].bitmapData,matrix);
				track.graphics.drawRect(int(pos%myStage.lWidth)*24, int(pos/myStage.lWidth)*24, tr_frames[frame].width,  tr_frames[frame].height);
			}
		}
		
		public function createTrack(){
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,24,24);
			var rect:Rectangle;
			var bmd:BitmapData;
			var myBitmap:Bitmap;
			for(var i=0;i<24;i++){
				////trace(myStage.grounds[i]);
				x1=i*24;
				////trace(x1);
				rect=new Rectangle(x1,0,24,24);
				bmd=new BitmapData(24,24,true,0xFFFFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.tracks.bitmapData.getVector(rect));
				tr_frames.push(myBitmap);
			}
		}
		
		public function createBonus(pos:int, mtype:int){
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,20,20);
			var rect:Rectangle;
			var bmd:BitmapData;
			var myBitmap:Bitmap;
			var bon_cl:MovieClip=new MovieClip();
			var ar:Array=new Array();
			myStage.bon_c[pos]=(0);
			for(var i=0;i<3;i++){
				////trace(myStage.grounds[i]);
				x1=(i+mtype*3)*20;
				////trace(x1);
				rect=new Rectangle(x1,0,20,20);
				bmd=new BitmapData(20,20,false,0xFFFFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.bonus1.bitmapData.getVector(rect));
				bon_cl.addChild(myBitmap);
				ar.push(myBitmap);
				if(i>0){
					myBitmap.visible=false;
				}else{
					myBitmap.visible=true;
				}
			}
			bon_cl.x=int(pos%myStage.lWidth)*24+2;
			bon_cl.y=int(pos/myStage.lWidth)*24+2;
			addChild(bon_cl);
			//trace(ar);
			myStage.bon_pict[pos]=(ar);
			//myStage.bon_time[pos]=(6000);
			myStage.bonuses[pos]=(bon_cl);
			myStage.bon_type[pos]=(mtype);
			myStage.bon_pos[pos]=(pos);
		}
		
		public function createOne(pos_x:int,pos_y:int,num:int){
				if(num>0){
					var matrix:Matrix = new Matrix();
          matrix.translate(pos_x, pos_y);
					if(num<4){
						graphics.beginBitmapFill(Tank.ex_frames[num-1].bitmapData,matrix);
						graphics.drawRect(pos_x, pos_y, 24, 24);
					}else if(num==4){
						graphics.beginBitmapFill(myStage.lib.png.dirt2.bitmapData,matrix);
						graphics.drawRect(pos_x, pos_y, 80, 80);
					}else if(num==5){
						graphics.beginBitmapFill(myStage.lib.png.dirt1.bitmapData,matrix);
						graphics.drawRect(pos_x, pos_y, 60, 60);
					}
				}
		}
		
		public function createMine(pos_x:int,pos_y:int,num:int){
				//if(Mines[pos]>0){
				//trace("mine   "+pos_x+"   "+pos_y+"   "+num);
					var pos:int=(pos_x+pos_y*myStage.lWidth);
					if(ms[pos]!=null){
						removeChild(ms[pos]);
						ms[pos]=null;
					}
					if(num>0){
						//trace("num "+num);
						if(num>3){
							num=2;
						}
						var x1:int=(num-1)*24;
						var rect:Rectangle=new Rectangle(x1,0,24,24);
						var rect1:Rectangle=new Rectangle(0,0,24,24);
						var bmd:BitmapData=new BitmapData(24,24,true,0xFFFFFFFF);
						var myBitmap:Bitmap=new Bitmap(bmd, "auto", false);
						myBitmap.bitmapData.setVector(rect1,myStage.lib.png.mine.bitmapData.getVector(rect));
						myBitmap.x=pos_x*24;
						myBitmap.y=pos_y*24;
						ms[pos]=(myBitmap);
						addChild(myBitmap);
					}/*else if(ms[pos]!=null){
						removeChild(ms[pos]);
						ms[pos]=null;
					}*/
				//}
				////trace("2   "+pos_x+"   "+pos_y+"   "+num);
		}
		
		public function createGround(bm:Bitmap){
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,24,24);
			var rect:Rectangle;
			var bmd:BitmapData;
			var myBitmap:Bitmap;
			graphics.clear();
			for(var i=0;i<myStage.grounds.length;i++){
				x1=(myStage.grounds[i]-1)*24;
				//trace(bm.width);
				try{
					rect=new Rectangle(x1,0,24,24);
					bmd=new BitmapData(24,24,false,0xFFFFFFFF);
					myBitmap=new Bitmap(bmd, "auto", false);
					myBitmap.bitmapData.setVector(rect1,bm.bitmapData.getVector(rect));
					graphics.beginBitmapFill(myBitmap.bitmapData);
					graphics.drawRect(int(i%myStage.lWidth)*24, int(i/myStage.lWidth)*24, 24, 24);
				}catch(e:Error){
					trace("Ground error0: "+e);
					trace(i+"   "+myStage.grounds[i]);
					break;
				}
			}
			//graphics.endFill();
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,24,24);
			var rect:Rectangle;
			var bmd:BitmapData;
			var myBitmap:Bitmap;
			for(var i=0;i<myStage.obj_id.length;i++){
				if(myStage.obj_obj[i]==-3){
					if((myStage.tank_type+1)==myStage.obj_num[i]){
						x1=0;
					}else if(myStage.obj_num[i]==1){
						x1=2*24;
					}else{
						x1=24;
					}
					//trace(myStage.flag_num[i]+"   "+myStage.tank_type);
					try{
						rect=new Rectangle(x1,0,24,24);
						bmd=new BitmapData(24,24,true,0xFFFFFFFF);
						myBitmap=new Bitmap(bmd, "auto", false);
						myBitmap.bitmapData.setVector(rect1,myStage.lib.png.flag.bitmapData.getVector(rect));
						myBitmap.x=int(myStage.obj_pos[i]%myStage.lWidth)*24;
						myBitmap.y=int(myStage.obj_pos[i]/myStage.lWidth)*24;
						myStage.objs[i]=(myBitmap);
						addChild(myStage.objs[i]);
					}catch(e:Error){
						trace("Ground error1: "+e);
						trace(i);
						break;
					}
				}
			}
		}
		
		public function createOneFlag(num:int){
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,24,24);
			var rect:Rectangle;
			var bmd:BitmapData;
			var myBitmap:Bitmap;
			try{
				removeChild(myStage.objs[num]);
			}catch(er:Error){}
			if((myStage.tank_type+1)==myStage.obj_num[num]){
				x1=0;
			}else if(myStage.obj_num[num]==1){
				x1=2*24;
			}else{
				x1=24;
			}
			//trace(myStage.flag_num[num]+"   "+myStage.tank_type);
			try{
				rect=new Rectangle(x1,0,24,24);
				bmd=new BitmapData(24,24,true,0xFFFFFFFF);
				myBitmap=new Bitmap(bmd, "auto", false);
				myBitmap.bitmapData.setVector(rect1,myStage.lib.png.flag.bitmapData.getVector(rect));
				myBitmap.x=int(myStage.obj_pos[num]%myStage.lWidth)*24;
				myBitmap.y=int(myStage.obj_pos[num]/myStage.lWidth)*24;
				myStage.objs[num]=(myBitmap);
				addChild(myStage.objs[num]);
			}catch(e:Error){
				trace("Flag error: "+e);
				trace(num+"   "+myStage.obj_num[num]);
			}
		}
		
		public function createOneTank(num:int, type:int){
			var tank:MovieClip;
			//trace(myStage.ammo_dm);
			var bot:Boolean=false;
			if(myStage.obj_type[num]==3){
				bot=true;
			}
			tank=new Tank(myStage.obj_vect[num],myStage.obj_type[num],myStage.obj_id[num],bot);
			tank._num=num;
			tank["m_num"]=myStage.obj_num[num];
			myStage.objs[num]=(tank);
			//trace("a");
			tank["health1"]=myStage.obj_heal1[num];
			tank["health"]=myStage.obj_heal[num];
			if(myStage.obj_gun[num]>-1){
				tank["fire_power"]=myStage.ammo_dm[myStage.obj_gun[num]];
			}else{
				tank["fire_power"]=myStage.basic_dm;
			}
			tank["fire_type"]=myStage.obj_gun[num];
			tank.x=tank["X"]=int(myStage.obj_pos[num]%myStage.lWidth)*24-1;
			tank.y=tank["Y"]=int(myStage.obj_pos[num]/myStage.lWidth)*24-1;
			tank.pos_in_map=tank.next_pos=myStage.obj_pos[num];
			Tank.free_pos[tank.pos_in_map]=num;
			tank._type=type;
			//trace("b");
			if(myStage.obj_id[num]==myStage.tank_id){
				myStage.tank_num=num;
				myStage.tank_type=tank._type;
				tank.player=true;
				if(tank["fire_type"]>-1){
					myStage.fire_cd=myStage.ammo_sp[tank["fire_type"]];
					tank["fire_power"]=myStage.ammo_dm[tank["fire_type"]];
					myStage.panel["ammo0"].resetAmmo();
					myStage.panel["ammo0"].ch_ammo(tank["fire_type"]);
				}else{
					myStage.fire_cd=myStage.f_cd;
					myStage.panel["ammo0"].resetAmmo();
				}
				myStage.pl_clip=tank;
				//tank.wayTest();
			}
			//trace("c");
			if(type==3){
				tank._type=3;
				tank.ebot=true;
				//tank.setTankName(tank["mname"],0);
			}
			//trace("d");
			tank["pow_step"]=myStage.panel["leave_cl"].getStep();
			//if(type!=3){
				tank.f_armor=true;
			//}
			tank.setNewName();
			tank.healthTest();
			tank["t_cl"].x=tank.x+4;
			tank["t_cl"].y=tank.y+4;
			tank["p_cl"].x=tank.x-15;
			tank["p_cl"].y=tank.y-15;
			myStage.cont.addChild(tank["t_cl"]);
			myStage.ground.addChild(tank["p_cl"]);
			myStage.wall.addChild(tank);
			//trace("e");
			for(var n:int=0;n<myStage.objs.length;n++){
				if(myStage.objs[n]!=null){
					if(myStage.obj_obj[n]==1){
						myStage.cont.setChildIndex(myStage.objs[n]["t_cl"], myStage.cont.numChildren-1);
					}
				}
			}
			//trace("f");
			tank.wayTest();
			//myStage.self.setChildIndex(myStage.panel, myStage.self.numChildren-1);
			//myStage.self.setChildIndex(myStage.contur, myStage.self.numChildren-1);
		}
		
		public function createTank(){
			for(var i=0;i<myStage.obj_id.length;i++){
				if(myStage.obj_id[i]!=null){
					if(myStage.obj_obj[i]==1){
						var bot:Boolean=false;
						if(myStage.obj_type[i]==3){
							 bot=true;
						}
						var tank:MovieClip=new Tank(myStage.obj_vect[i],myStage.obj_type[i],myStage.obj_id[i],bot);
						tank._num=i;
						tank["m_num"]=myStage.obj_num[i];
						myStage.objs[i]=(tank);
						tank["health1"]=myStage.obj_heal1[i];
						tank["health"]=myStage.obj_heal[i];
						if(myStage.obj_gun[i]>-1){
							tank["fire_power"]=myStage.ammo_dm[myStage.obj_gun[i]];
						}else{
							tank["fire_power"]=myStage.basic_dm;
						}
						tank["fire_type"]=myStage.obj_gun[i];
						if(myStage.obj_speed[i]>3){
							tank["SPEED"]=myStage.obj_speed[i]-2;
						}else{
							tank["SPEED"]=myStage.obj_speed[i];
						}
						//trace(myStage.obj_speed[i]+"   "+tank["SPEED"]);
						tank.x=tank["X"]=int(myStage.obj_pos[i]%myStage.lWidth)*24-1;
						tank.y=tank["Y"]=int(myStage.obj_pos[i]/myStage.lWidth)*24-1;
						tank["p_cl"].x=tank.x-15;
						tank["p_cl"].y=tank.y-15;
						//trace(tank.x);
						tank.pos_in_map=tank.next_pos=myStage.obj_pos[i];
						Tank.free_pos[tank.pos_in_map]=i;
						tank._type=myStage.obj_type[i];
						tank["pow_step"]=0;
						tank.f_armor=true;
						if(tank._type<3){
							if(myStage.obj_id[i]==myStage.tank_id){
								myStage.tank_num=i;
								myStage.tank_type=tank._type;
								tank.player=true;
								if(tank["fire_type"]>-1){
									myStage.fire_cd=myStage.ammo_sp[tank["fire_type"]];
									myStage.pl_clip["fire_power"]=myStage.ammo_dm[myStage.pl_clip["fire_type"]];
									myStage.panel["ammo0"].resetAmmo();
									myStage.panel["ammo0"].ch_ammo(tank["fire_type"]);
								}else{
									myStage.fire_cd=myStage.f_cd;
									myStage.panel["ammo0"].resetAmmo();
								}
								/*for(var a:int=5;a>-2;a--){
									if(a>-1){
										if(myStage.panel["ammo"+a]["quantity"]>0){
											myStage.self.socket.sendEvent(a+10,0);
											break;
										}
									}else{
										myStage.self.socket.sendEvent(27,0);
									}
								}*/
								myStage.pl_clip=tank;
								//tank.wayTest();
							}
						}else{
							tank._type=3;
							tank.ebot=true;
							//tank.setTankName(tank["mname"],0);
						}
						tank.setNewName();
						tank.healthTest();
						tank.wayTest();
					}
				}
			}
		}
		
		public function createBase(bm:Bitmap){
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,33,34);
			var rect:Rectangle;
			var bmd:BitmapData;
			var myBitmap:Bitmap;
			for(var i=0;i<myStage.base.length;i++){
				//trace(myStage.base[i]+"   "+myStage.base_pos[i]);
				if(myStage.base[i]<3){
					x1=(myStage.base[i]-1)*33;
					////trace(x1);
					rect=new Rectangle(x1,0,33,34);
					bmd=new BitmapData(33,34,true,0x00FFFFFF);
					myBitmap=new Bitmap(bmd, "auto", false);
					myBitmap.bitmapData.setVector(rect1,bm.bitmapData.getVector(rect));
					var matrix:Matrix = new Matrix();
          matrix.translate(int(myStage.base_pos[i]%myStage.lWidth)*24-5, int(myStage.base_pos[i]/myStage.lWidth)*24-5);
					graphics.beginBitmapFill(myBitmap.bitmapData,matrix);
					graphics.drawRect(int(myStage.base_pos[i]%myStage.lWidth)*24-5, int(myStage.base_pos[i]/myStage.lWidth)*24-5, 33, 34);
				}
			}
			//graphics.endFill();
		}
	}
	
}