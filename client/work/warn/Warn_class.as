package{
	
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.system.Security;
	import flash.net.*;
	
	public class Warn_class extends MovieClip{
		
		public static var par_cl:MovieClip;
		public static var stg_cl:MovieClip;
		public static var stg_class:Class;
		
		public function Warn_class(){
			super();
			Security.allowDomain("*");
			stop();
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
		}
		
		public function m_init(cl:MovieClip,cl1:MovieClip){
			par_cl=cl;
			stg_cl=cl1;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public function m_over(event:MouseEvent){
			gotoAndStop("over");
		}
		
		public function m_out(event:MouseEvent){
			gotoAndStop("out");
		}
		
		public function m_press(event:MouseEvent){
			gotoAndStop("press");
		}
		
		public function m_release(event:MouseEvent){
			if(name=="close_cl"){
				gotoAndStop("out");
				stg_cl["warn_er"]=false;
				if(_break==0){
					try{
						stg_class.wind["ready_cl"].visible=false;
					}catch(er:Error){
						
					}
					if(_type==0){
						stg_cl.gameReset();
					}else{
						stg_class.wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id","type","type_alert"]],[["7"],["10","0",_type+""]]);
						if(_type==3){
							stg_class.wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["7"],["5"]]);
						}
					}
				}
				stg_cl.removeChild(par_cl);
			}else if(name=="no_cl"){
				stg_cl["warn_er"]=false;
				stg_cl.removeChild(par_cl);
			}else if(name=="auto_no"){
				stg_class.wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id","type"]],[["3"],["12",0+""]]);
			}else if(name=="auto_yes"){
				stg_class.wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id","type"]],[["3"],["12",1+""]]);
			}else if(name=="auto_gr_no"){
				stg_class.wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["14"],["3"]]);
			}else if(name=="auto_gr_yes"){
				stg_class.wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["14"],["4"]]);
			}else if(name=="cl_call"){
				gotoAndStop("out");
				stg_class.wind["choise_cl"].reCall(5);
				stg_cl["warn_er"]=false;
				stg_cl.removeChild(par_cl);
			}else if(name=="yes_cl"){
				stg_cl["game_over"]=true;
				stg_cl["warn_er"]=false;
				try{
					stg_cl["socket"].sendEvent(254,0);
					stg_cl["socket"].close();
				}catch(er:Error){
					
				}
				stg_cl.gameReset();
				stg_cl.removeChild(par_cl);
			}else if(name=="y_call"){
				stg_class.wind["choise_cl"].reCall(1);
			}else if(name=="n_call"){
				stg_class.wind["choise_cl"].reCall(0);
			}/*else if(name=="cl_call"){
				var clip:MovieClip=parent.parent.parent as MovieClip;
				clip.getClass(clip).wind["choise_cl"].reCall(0);
			}*/
		}
		
		public static var _type:int=0;
		public static var _break:int=0;
		
		public function set_type(a:int){
			_type=a;
		}
		
		public function set_break(a:int){
			_break=a;
		}
		
		public function resetImage(){
			try{
				root["cl_win"]["pict_cl"].removeChild(img[0]);
			}catch(er:Error){}
			img=new Array();
		}
		
		public function LoadImage(ur:String){
			//trace(ur);
			var loader:Loader = new Loader();
			root["cl_win"]["pict_cl"].addChild(loader);
			img.push(loader);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openImage );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressImage);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeImage);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadImage);
			
			loader.load(new URLRequest(ur));
		}
		
		public function openImage(event:Event){
			
		}
		
		public function progressImage(event:Event){
			
		}
		
		public function completeImage(event:Event){
			//event.currentTarget.content.x+=1;
			//event.currentTarget.content.y+=1;
			//event.currentTarget.content.name="pict";
		}
		
		public static var img:Array=new Array();
		
		public function accessError(event:Event){
			
		}
		
		public function unLoadImage(event:Event){
			
		}
		
	}
	
}
