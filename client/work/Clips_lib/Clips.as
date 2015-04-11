package{
	
	import flash.display.MovieClip;
	import flash.system.Security;
	
	public class Clips extends MovieClip{

		public function Clips(){
			super();
			Security.allowDomain("*");
			stop();
		}

	}
	
}
