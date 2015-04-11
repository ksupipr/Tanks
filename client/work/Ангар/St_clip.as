package{
	
	import flash.display.*;
	
	public class St_clip extends MovieClip{
		
		public static var self:MovieClip;
		public static var stg_cl:MovieClip;
		public var stg:MovieClip=new MovieClip();
		
		public function St_clip(){
			super();
			stg_cl=this;
			self=new MovieClip();
			addChild(self);
		}
	}
}