package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.filters.DisplacementMapFilter;
	
	public class Impuls extends MovieClip{
		
		public var anim:Array=new Array();
		public var exp:BitmapData;
		public var cont:Bitmap;
		public var lvl,dsp:MovieClip;
		//public var fr:Rectangle=new Rectangle(0,0,140,140);
		public var posX,posY,R,_cf:int;
		
		public function Impuls(_x:int,_y:int,_cl:MovieClip,_cl1:MovieClip,_r:int=7){
			super();
			lvl=_cl;
			dsp=_cl1;
			cacheAnim(_r);
			//trace(anim[0]);
			exp=new BitmapData(anim[0].width, anim[0].height, true, 0);
			cont=new Bitmap(exp);
			posX=_x;
			posY=_y;
			_cf=0;
			cont.x=posX-cont.width*.5;
			cont.y=posY-cont.height*.5;
			var idx:int=dsp.getChildIndex(lvl);
			if(idx<dsp.numChildren-1){
				dsp.addChildAt(cont,dsp.getChildIndex(lvl)+1);
			}else{
				dsp.addChild(cont);
			}
			/*var _test:MovieClip=new MovieClip();
			_test.graphics.clear();
			_test.graphics.beginFill(0x00ff00);
			_test.graphics.drawRect(0,0,2,2);
			_test.x=_x-1;
			_test.y=_y-1;
			dsp.addChild(_test);*/
			//trace(cont.x+"   "+cont.y);
			lvl.addEventListener(Event.ENTER_FRAME, explosion);
		}
		
		public function cacheAnim(r:int):void{
			var mc:MovieClip=new MovieClip();
			mc.clip=new myStage.emi();
			mc.clip.width=mc.clip.height=int(mc.clip.height*(r/7));
			if(mc.clip.width%2==1){
				mc.clip.width-=1;
				mc.clip.height-=1;
			}
			mc.addChild(mc.clip);
			var bmd:BitmapData;
			var lim:int=312*(r/7);
			if(lim%2==1){
				lim-=1;
			}
			R=lim/24;
			var matr:Matrix=new Matrix(1, 0, 0, 1, lim*.5, lim*.5);
			mc.graphics.beginFill(0x808080,1);
			mc.graphics.drawRect(-int(lim/2), -int(lim/2),lim, lim);
			for(var i:uint=1; i<=mc.clip.totalFrames; i++){
				mc.clip.gotoAndStop(i);
				bmd=new BitmapData(mc.width, mc.height, true, 0);
				bmd.draw(mc, matr);
				anim.push(bmd);
			}
		}
		
		public function explosion(e:Event):void{
			if(_cf==anim.length){
				_cf=0;
				dsp.removeChild(cont);
				lvl.removeEventListener(Event.ENTER_FRAME, explosion);
				return;
			}
			var frames:BitmapData;
			var src:BitmapData;
			var rect:Rectangle;
			var filt:DisplacementMapFilter;
			
			frames=anim[_cf];
			
			_cf++;
			
			try{
				src=new BitmapData(lvl.width, lvl.height, true, 0);
			}catch(er:Error){
				trace("BitmapData error "+er);
				trace("new BitmapData("+lvl.width+", "+lvl.height+", "+true+", "+0+")");
				src=new BitmapData(myStage.mWidth, myStage.mHeight, true, 0);
			}
			
			rect=new Rectangle(posX-frames.width*.5, posY-frames.height*.5, frames.width, frames.height);
			src.draw(lvl, new Matrix(), new ColorTransform(), null, rect);
			
			exp.lock();
			
			exp.copyPixels(src, rect, new Point(0,0));
			
			rect=new Rectangle(0, 0, exp.width, exp.height);
			filt=new DisplacementMapFilter(frames, null, 1, 1, 6, 6);
			exp.applyFilter(exp, rect, new Point(0,0), filt);
			
			exp.unlock();
		}
		
	}
	
}