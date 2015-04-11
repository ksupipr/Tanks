package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class Bullet extends MovieClip{
		
		//public static var is_load:int=0;
		//public var clip:Array=new Array();
		//public static var clip1:Array=new Array();
		//public static var images:Number=0;
		//public static var percent:Number=0;
		//public var frames:int=0;
		//public var procent:int=0;
		public var frame:int=0;
		
	  public var corr:int;
		public var n:int;
  
	  public var x_coor:Number;
	  public var y_coor:Number;
	  public var x_pos:int;
	  public var y_pos:int;
	  public var pos_in_map:int;
	  public var i:int;
	  public var j:int;
	  public var w_target:int;
	  public var rat:int;
	  
	  public var speed:Number=12/*/(4/(myStage.DELAY/10))*/;
	  public var health:int;
	  public var power:int;
	  public var _class:int;           //разновидность
	  public var _type:int;            //команда
	  public var _num:int;
		public var ID:int;
	  
	  public var pow_buff:int;
		public var step_b:int=0;
		public var step_n:int=0;
		public var steps:int=0;
		public var X:int;
	  public var Y:int;
	  //public var step_n:int=0;
		//public var step_d:int=0;
	  public var max_step:int=Math.floor((24/speed));
	  
	  public var tank:Tank;
	  //public var target:Tank;
	  public var turrel:MovieClip;
	  //public var target1:Turrel;
	  public var boom:Boolean;
	  public var del:Boolean=false;
	  //public static var re:Boolean;
	  public var free_way:Boolean;
		public var ebot:Boolean;
	  
	  public var player:Boolean;
		public var skin1:Sprite;
		public var skin1_vctr:BitmapData;
		
		public var not_expl:Boolean=false;
		
		public function Bullet(){
			super();
			stop();
			myStage.bull.addChild(this);
			boom=false;
			visible=false;
		}
		
		public function setFrames(_efx:int=-1){
			graphics.clear();
			graphics.beginBitmapFill(Tank.bu_frames[frame].bitmapData);
			graphics.drawRect(0, 0, 20, 20);
			
			setSkin1(_efx);
			
			addEventListener(Event.ENTER_FRAME, render);
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);
			
		}
		
		public function dispose(event:Event){
			try{
				myStage.expls.removeChild(skin1);
			}catch(er:Error){}
		}
		
		public static var last_efx:int=0;
		public var drawSkin1:Function=function(){};
		public var draw_efx:int=0;
		
		public function setSkin1(_efx:int=-1){
			if(_efx<0){
				if(player){
					_efx=last_efx;
				}
			}
			
			if(draw_efx==_efx){
				return;
			}else if(_efx==0){
				if(player){
					last_efx=_efx;
				}
				draw_efx=_efx;
				drawSkin1=function(){};
				try{
					myStage.expls.removeChild(skin1);
				}catch(er:Error){}
				return;
			}
			if(player){
				last_efx=_efx;
			}
			draw_efx=_efx;
			
			var _draw:Shape=new Shape();
			var _alpha:Number=0.5;
			var _w:Number=width/2;
			var _h:Number=height/2;
			var _r:uint=30;
			var _color:uint=0xff0000;
			if(_efx==2){
				_color=0xffffff;
			}else if(_efx==3){
				_color=0x00ff00;
			}
			
			var _mtx:Matrix=new Matrix();
			_mtx.createGradientBox(_r*2,_r*2,0,0,0);
			
			var _bmd:BitmapData=new BitmapData(_r*2,_r*2,true,0x00000000);
			
			_draw.graphics.clear();
			_draw.graphics.beginGradientFill(GradientType.RADIAL,[_color,_color],[_alpha,0],[0,127],_mtx);
			_draw.graphics.drawCircle(_r,_r,_r);
			
			_bmd.draw(_draw);
			skin1_vctr=_bmd;
			
			skin1=new Sprite();
			
			skin1.graphics.clear();
			skin1.graphics.beginBitmapFill(skin1_vctr);
			skin1.graphics.drawRect(0,0,skin1_vctr.width,skin1_vctr.height);
			
			drawSkin1=function(){
				skin1.x=x+width/2-skin1.width/2;
				skin1.y=y+height/2-skin1.height/2;
			};
			
			drawSkin1();
			
			myStage.expls.addChild(skin1);
		}
		
		public function anyTest(){
			if(visible){
				if(x>myStage.lWidth*24+10||x<-10){
					visible=false;
					//this.removeEventListener(Event.ENTER_FRAME,render);
					return;
				}else if(y>myStage.lHeight*24+10||y<-10){
					visible=false;
					//this.removeEventListener(Event.ENTER_FRAME,render);
					return;
				}
			}else{
				if(x>myStage.lWidth*24+myStage.board_x+50||x<myStage.board_x-50){
					this.removeEventListener(Event.ENTER_FRAME,render);
					myStage.bull.removeChild(this);
					myStage.objs[_num]=null;
					return;
				}else if(y>myStage.lHeight*24+myStage.board_y+50||y<myStage.board_y-50){
					this.removeEventListener(Event.ENTER_FRAME,render);
					myStage.bull.removeChild(this);
					myStage.objs[_num]=null;
					return;
				}
			}
		}
		
		public function wallTest(){
			if(!boom||visible){
				if(!boom){
					if(step_n>1){
						boom=true;
						visible=true;
					}
				}
				if(myStage.self["bull_on"]){
					if(myStage.wall.hitTestPoint(x+width/2,y+height/2,true)){
						if(tank!=null){
							if(tank.hitTestPoint(x+width/2,y+height/2,true)){
								return;
							}
						}else if(turrel!=null){
							if(turrel.hitTestPoint(x+width/2,y+height/2,true)){
								return;
							}
						}
						not_expl=true;
						visible=false;
						if(skin1){
							skin1.visible=false;
						}
						myStage.self.newEX(int(x-2),int(y-2),0,myStage.bm_count,0);
					}else{
						for(n=0;n<myStage.bull.numChildren;n++){
							if(myStage.bull.getChildAt(n).visible){
								if(myStage.bull.getChildAt(n)!=this){
									if(this.hitTestObject(myStage.bull.getChildAt(n))){
										//trace("bullTest   ");
										not_expl=true;
										myStage.bull.getChildAt(n)["not_expl"]=true;
										visible=false;
										if(skin1){
											skin1.visible=false;
										}
										myStage.bull.getChildAt(n).visible=false;
										if(myStage.bull.getChildAt(n)["skin1"]){
											myStage.bull.getChildAt(n)["skin1"].visible=false;
										}
										myStage.self.newEX(int(x-2),int(y-2),0,myStage.bm_count,0);
									}
								}
							}
						}
					}
				}
			}
		}
		
		public function render(event:Event){
				//trace(speed);
				/*if(rat==1){
					x-=speed;
				}else if(rat==2){
					y-=speed;
				}else if(rat==3){
					x+=speed;
				}else if(rat==4){
					y+=speed;
				}*/
				step_n++;
				if(visible){
					//wallTest();
					//myHitTest();
					//anyTest();
					steps=myStage.steps-step_b;
					if(step_n<steps-1){
						step_n=steps;
					}else if(step_n>steps+1){
						step_n=steps;
					}
				}
				if(rat==1){
					x_coor=X-speed*step_n;
					x=int(x_coor);
				}else if(rat==2){
					y_coor=Y-speed*step_n;
					y=int(y_coor);
				}else if(rat==3){
					x_coor=X+speed*step_n;
					x=int(x_coor);
				}else if(rat==4){
					y_coor=Y+speed*step_n;
					y=int(y_coor);
				}
				
				drawSkin1();
				
				wallTest();
				anyTest();
				//trace(x+"   "+X+"   "+speed+"   "+myStage.steps+"   "+step_n+"   "+steps);
		}
	}
	
}