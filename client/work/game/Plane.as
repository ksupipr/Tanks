package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
		
		public class Plane extends MovieClip{
			
			public var air_c:int=0;
			public var air_c1:int=0;
			public var air_c2:int=0;
			public var air_time:int=5;
			public var air_step:int=0;
			public var pos:int=0;
			public var posx:int=0;
			public var posy:int=0;
			public var x_coor:int=0;
			public var y_coor:int=0;
			public var X:int=0;
			public var Y:int=0;
			public var Xc:int=0;
			public var Yc:int=0;
			public var wait_c2:int=0;
			
			public var speed:Number=6;
			public var SPEED:Number=5;
			public var was_exp:Boolean=false;
			public var was_s:Boolean=false;
			
			public static var indx:Array=new Array();
			//public static var count:int=0;
			
			public function Plane(p:int,t:int){
				pos=p;
				posx=pos%myStage.lWidth;
				posy=pos/myStage.lWidth;
				x_coor=posx*24;
				y_coor=posy*24;
				x=x_coor-40;
				y=y_coor-40;
        //x-=Math.sqrt(myStage.mWidth*myStage.mWidth+myStage.mHeight*myStage.mHeight);
        //y+=Math.sqrt(myStage.mWidth*myStage.mWidth+myStage.mHeight*myStage.mHeight);
				while(x>-160&&y<myStage.mHeight){
					x-=40;
					y+=40;
				}
				if(y>myStage.mHeight){
					while(y>myStage.mHeight){
						x++;
						y--;
					}
				}
				X=x;
				Y=y;
				air_time=t;
				//var diff=(Math.sqrt(Math.pow((Math.abs(x-x_coor)),2)+Math.pow((Math.abs(y-y_coor)),2)));
				var diff:Number=Math.abs(x-(x_coor));
				var diff1:Number=Math.abs(y-(y_coor));
				/*if(diff<diff1){
					speed=diff/air_time;
				}else{
					speed=diff1/air_time;
				}*/
				SPEED=speed;
				setFrames(myStage.lib.png.plane);
				myStage.cont.addChild(this);
				myStage.self.setChildIndex(myStage.chat_cl, myStage.self.numChildren-1);
				myStage.self.setChildIndex(myStage.panel, myStage.self.numChildren-1);
				myStage.self.setChildIndex(myStage.exp_cl, myStage.self.numChildren-1);
				myStage.self.setChildIndex(myStage.contur, myStage.self.numChildren-1);
				//trace(myStage.steps+"   "+air_time+"   "+diff+"   "+diff1+"   "+speed);
				indx.push(myStage.cont.getChildIndex(this));
				/*if(count==0){
					indx=myStage.self.getChildIndex(this);
				}else if(indx>myStage.self.getChildIndex(this)){
					indx=myStage.self.getChildIndex(this);
				}*/
				//count++;
			}
			
			public function setFrames(pict:Bitmap){
				var rect1:Rectangle=new Rectangle(0,0,160,80);
				var rect:Rectangle;
				var bmd:BitmapData;
				var bm:Bitmap;
				rect=new Rectangle(0,0,160,80);
				bmd=new BitmapData(160,80,true,0xFFFFFFFF);
				bm=new Bitmap(bmd, "auto", false);
				bm.bitmapData.setVector(rect1,pict.bitmapData.getVector(rect));
				graphics.clear();
				graphics.beginBitmapFill(bm.bitmapData);
				graphics.drawRect(0, 0, 160, 80);
				//graphics.endFill();
				air_step=myStage.steps;
				addEventListener(Event.ENTER_FRAME, render);
			}
			
			public function render(event:Event){
				//air_c=myStage.steps-air_step;
				if(myStage.self["socket"]==null||!myStage.self["socket"]["connected"]){
					this.removeEventListener(Event.ENTER_FRAME,render);
					myStage.cont.removeChild(this);
					indx.shift();
				}
				if(air_c<myStage.steps-air_step){
					while(air_c<myStage.steps-air_step){
						if(air_c1>0){
							if(!was_s){
								myStage.self.playSound("plane",0);
								was_s=true;
							}
							x=int(X+speed*air_c1);
							y=int(Y-speed*air_c1);
							if(air_c>=air_time){
								if(air_c2<5){
									//Xc=int((x+40)/24);
									//Yc=int((y-40)/24);
									if(air_c2==0||air_c2==4){
										Xc=int((x+40)/24);
										Yc=int((y-40)/24);
										myStage.self.air_expl((Xc-7),(Yc+2),1,0,0);
										//myStage.expl((Xc-7),(Yc+2),1,24,0);
										//myStage.expl((Xc-5),(Yc+2),1,0,0);
										myStage.self.air_expl((Xc-5),(Yc+2),1,24,0);
										//myStage.expl((Xc-3),(Yc+2),1,0,0);
										//myStage.expl((Xc-3),(Yc+2),1,24,0);
										myStage.self.air_expl((Xc-1),(Yc+2),1,0,0);
										//myStage.expl((Xc-1),(Yc+2),1,24,0);
										//myStage.expl((Xc+1),(Yc+2),1,0,0);
										myStage.self.air_expl((Xc+1),(Yc+2),1,24,0);
									}
									air_c2++;
								}else{
									//myStage.expl((Xc+1),(Yc+2),1,24,0);
									//myStage.expl((Xc  ),(Yc+3),2,24,0);
									//myStage.expl((Xc-1),(Yc+4),3,24,0);
									air_c2=0;
								}
							}
						}
						air_c++;
						air_c1=air_c-(air_time-6);
					}
				}else{
					air_c++;
					air_c1=air_c-(air_time-6);
					if(air_c1>0){
						if(!was_s){
							myStage.self.playSound("plane",0);
							was_s=true;
						}
						x=int(X+speed*air_c1);
						y=int(Y-speed*air_c1);
						if(air_c>=air_time){
							if(air_c2<5){
								//Xc=int((x+40)/24);
								//Yc=int((y-40)/24);
								if(air_c2==0||air_c2==4){
									Xc=int((x+40)/24);
									Yc=int((y-40)/24);
									myStage.self.air_expl((Xc-7),(Yc+2),1,0,0);
									//myStage.expl((Xc-7),(Yc+2),1,24,0);
									//myStage.expl((Xc-5),(Yc+2),1,0,0);
									myStage.self.air_expl((Xc-5),(Yc+2),1,24,0);
									//myStage.expl((Xc-3),(Yc+2),1,0,0);
									//myStage.expl((Xc-3),(Yc+2),1,24,0);
									myStage.self.air_expl((Xc-1),(Yc+2),1,0,0);
									//myStage.expl((Xc-1),(Yc+2),1,24,0);
									//myStage.expl((Xc+1),(Yc+2),1,0,0);
									myStage.self.air_expl((Xc+1),(Yc+2),1,24,0);
								}
								air_c2++;
							}else{
								//myStage.expl((Xc+1),(Yc+2),1,24,0);
								//myStage.expl((Xc  ),(Yc+3),2,24,0);
								//myStage.expl((Xc-1),(Yc+4),3,24,0);
								air_c2=0;
							}
						}
					}
				}
				if(myStage.self["smoke_on"]&&air_c1>0){
					if(wait_c2<1){
						wait_c2++;
					}else{
						myStage.self.newSmoke(x+14,y+14,0,myStage.sm_count);
						if(myStage.sm_count<myStage.smokes.length-1){
							myStage.sm_count++;
						}else{
							myStage.sm_count=0;
						}
						myStage.self.newSmoke(x+52,y+52,0,myStage.sm_count);
						if(myStage.sm_count<myStage.smokes.length-1){
							myStage.sm_count++;
						}else{
							myStage.sm_count=0;
						}
						wait_c2=0;
					}
				}
				if(x>myStage.mWidth*2||y<0-height*2){
					this.removeEventListener(Event.ENTER_FRAME,render);
					myStage.cont.removeChild(this);
					indx.shift();
					//count--;
				}
			}
		}
}