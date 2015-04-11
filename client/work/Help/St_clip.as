package{
	
	import flash.display.*;
	
	public class St_clip extends MovieClip{
		
		public static var self:MovieClip;
		public static var stg:MovieClip;
		
		public function St_clip(){
			super();
			stg=this;
			self=new MovieClip();
			addChild(self);
			//stg["lesson"+2].visible=true;
		}
	}
}