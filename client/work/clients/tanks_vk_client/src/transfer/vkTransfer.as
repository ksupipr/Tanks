package transfer{
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.system.Security;
	
	import api.MultipartURLLoader;
	import api.JPGEncoder;
	import api.PNGEncoder;
	import api.serialization.json.*;
	
	public class vkTransfer extends MovieClip{
		
		public function init(_cl:MovieClip,url:String,pct:Bitmap,upl_url:String,_class:Class){
			trace("Transfer init");
			
			var serv_url=url;
			var stg_cl=_cl;
			var stg_class:Class=_class;
			
			try{
				var byteArray : ByteArray = PNGEncoder.encode(pct.bitmapData);
				var mpLoader:MultipartURLLoader=new MultipartURLLoader();
				mpLoader.addEventListener(Event.COMPLETE, stg_cl.imageForWallUploaded);
				mpLoader.addFile(byteArray, "photo.png", "photo");
				mpLoader.load(upl_url);
				
			}catch(er:Error){
				stg_cl.errTest("Try error   "+er+"\n"+upl_url,int(600/2));
			}
		}
		
		public function vkTransfer(){
			super();
			Security.allowDomain("*");
			stop();
		}

	}
	
}
