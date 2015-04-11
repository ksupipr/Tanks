package 
{
	import com.api.forticom.ApiCallbackEvent;
	import com.api.forticom.ForticomAPI;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			ForticomAPI.addEventListener(ForticomAPI.CONNECTED, this.apiIsReady);
			ForticomAPI.connection = this.stage.loaderInfo.parameters["apiconnection"];
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, this.handleApiEvent);
		}
		
		protected function apiIsReady(event : Event) : void
		{
			this.stage.addEventListener(MouseEvent.CLICK, this.click);
		}
		
		protected function handleApiEvent(event : ApiCallbackEvent) : void
		{
			this.getChildByName("txt")["text"] = event.method + "\n" + event.userText + "\n" + event.signature; 
		}
		
		protected function click(event : Event) : void
		{
			switch(event.target.name)
			{
				case 'btn1':
					ForticomAPI.showInstall();
					break;
				case 'btn2':
					ForticomAPI.showSettings();
					break;
				case 'btn3':
					ForticomAPI.showFeed("123");
					break;
				case 'btn4':
					ForticomAPI.showInvite();
					break;
				case 'btn5':
					ForticomAPI.showPayment("Desc.", "IDDQD", "5");
					break;
			}
		}
		
	}
	
}