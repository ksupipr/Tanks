package utils{
	
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	
	public class xColor{
		
		private static function multicolor(_cl:MovieClip):void {
			var fltrs:Array = new Array();
			var cl_fltr:Array=_cl.filters;
			for(var i:int=0;i<cl_fltr.length;i++){
				//trace(i+"   "+cl_fltr[i]+"   "+over_fltr+"   "+(cl_fltr[i]==over_fltr)+"   "+(cl_fltr[i]!=over_fltr));
				if((cl_fltr[i].constructor==ColorMatrixFilter)&&(cl_fltr[i].matrix.toString().substr(50,30)=="4202385,0,0,0.2126709967851638")){
					continue;
				}else{
					fltrs.push(cl_fltr[i]);
				}
			}
			_cl.filters = fltrs;
		}
		
		public static function b_and_w(_cl:MovieClip,_b_w:int=0):void {
			multicolor(_cl);
			if(_b_w==1){
				var filter:ColorMatrixFilter = b_and_w_f();
				var fltrs:Array = new Array();
				fltrs.push(filter);
				_cl.filters = fltrs;
			}
		}
		
		private static function b_and_w_f():ColorMatrixFilter{
			var t:Number = 1;
			var r:Number = 0.212671;
			var g:Number = 0.715160;
			var b:Number = 0.072169;
			/*var matrix:Array = new Array();[, , , ]
			matrix = matrix.concat([t*r+1-t, t*g, t*b, 0, 0]); // red
			matrix = matrix.concat([t*r, t*g+1-t, t*b, 0, 0]); // green
			matrix = matrix.concat([t*r, t*g, t*b+1-t, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha 4-й элемент из 5-ти от 0 до 1*/
			var fltr:ColorMatrixFilter=new ColorMatrixFilter([t*r+1-t, t*g, t*b, 0, 0, t*r, t*g+1-t, t*b, 0, 0, t*r, t*g, t*b+1-t, 0, 0, 0, 0, 0, 1, 0]);
			//trace(fltr.matrix.toString().substr(50,30));
			return fltr;
		}
		
	}
}