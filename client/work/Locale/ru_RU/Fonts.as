package  {
	
	import flash.text.Font;
	import flash.display.MovieClip;
	import flash.system.Security;
	import flash.utils.getDefinitionByName;
	import flash.system.ApplicationDomain;
	
	public class Fonts extends MovieClip{
		
		public function Fonts() {
			super();
			Security.allowDomain("*");
			stop();
			//trace(verdana_ar);
		}
		
		public function init(_font:String) : Class{
			var fontClass:Class = getDefinitionByName(_font) as Class;
			
			Font.registerFont(fontClass);
			
			return fontClass;
		}

	}
	
}
