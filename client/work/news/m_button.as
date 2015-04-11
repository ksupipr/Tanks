package{
	
	import flash.display.*;
	import flash.system.Security;
	
	public class m_button extends SimpleButton{
		
		/*public static var self:MovieClip;
		public static var stg_cl:MovieClip;
		public var stg:MovieClip=new MovieClip();*/
		
		public function m_button(){
			super();
			Security.allowDomain("*");
			/*stg_cl=this;
			self=new MovieClip();
			addChild(self);*/
		}
	}
}