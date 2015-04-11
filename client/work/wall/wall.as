package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.ui.*;
	import flash.net.*;
	import flash.text.*;
	
	public class wall extends MovieClip{
		
		public static var stg_cl:MovieClip;
		public static var serv_url:String="empty";
		public static var stg_class:Class;
		public static var pict:Bitmap;
		
		public function urlInit(url:String,clip:MovieClip){
			serv_url=url;
			stg_cl=clip;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public function wall(){
			super();
			Security.allowDomain("*");
			stop();
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
		}
		
		public function newPict(pct:Bitmap){
			pict=pct;
			pict.x=51;
			pict.y=58;
			St_clip.stg.addChild(pict);
		}
		
		public function reset(){
			try{
				St_clip.stg.removeChild(pict);
				pict=new Bitmap();
			}catch(er:Error){
				
			}
			try{
				stg_cl.removeChild(St_clip.stg);
			}catch(er:Error){
				
			}
			stg_cl["wall_win"]=false;
			try{
				stg_class.wind["choise_cl"].startStatus();
			}catch(er:Error){
				
			}
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			Mouse.cursor=MouseCursor.BUTTON;
			/*if(name=="fr_cl"){
				St_clip.stg.setChildIndex(root["mess_win"],St_clip.stg.numChildren-1);
				root["mess_win"].visible=true;
			}*/
			gotoAndStop("over");
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			Mouse.cursor=MouseCursor.AUTO;
			/*if(name=="fr_cl"){
				root["mess_win"].visible=false;
			}*/
			gotoAndStop("out");
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			gotoAndStop("press");
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(name=="close_cl"){
				reset();
				var rqs:URLRequest=new URLRequest(serv_url+"?query="+2+"&action="+7);
				rqs.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader(rqs);
				var strXML:String="<query id=\"2\"><action id=\"7\"  idm=\""+stg_cl.upl[0]+"\" /></query>";
				//trace(strXML);
				var variables:URLVariables = new URLVariables();
				variables.query = strXML;
				variables.send = "send";
				rqs.data = variables;
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(rqs);
			}else if(name=="w_cl"){
				stg_class.prnt_cl.upl_pct=(pict);
				stg_class.prnt_cl.showWall();
				var rqs:URLRequest=new URLRequest(serv_url+"?query="+5+"&action="+1);
				rqs.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader(rqs);
				var strXML:String="<query id=\"5\"><action id=\"1\"  viewer_id=\""+""+"\" user_id=\""+""+"\" group_id=\""+""+"\" referrer=\""+"medal_on_wall"+"\" /></query>";
				//trace(strXML);
				var variables:URLVariables = new URLVariables();
				variables.query = strXML;
				variables.send = "send";
				rqs.data = variables;
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(rqs);
			}else if(name=="fr_cl"){
				stg_class.prnt_cl.upl_pct=(pict);
				stg_class.prnt_cl.showWall();
				var rqs:URLRequest=new URLRequest(serv_url+"?query="+5+"&action="+1);
				rqs.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader(rqs);
				var strXML:String="<query id=\"5\"><action id=\"1\"  viewer_id=\""+""+"\" user_id=\""+""+"\" group_id=\""+""+"\" referrer=\""+"medal_for_friend"+"\" /></query>";
				//trace(strXML);
				var variables:URLVariables = new URLVariables();
				variables.query = strXML;
				variables.send = "send";
				rqs.data = variables;
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(rqs);
				stg_class.prnt_cl.upl_pct=(pict);
			}
			gotoAndStop("over");
		}
		
	}
}