package com.api.forticom
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.external.ExternalInterface;
import flash.system.Security;
	
	public class ForticomAPIJS extends Sprite 
	{
		
		public function ForticomAPIJS() 
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			Security.allowDomain("*") ;
			Security.allowInsecureDomain("*");
			
			ForticomAPI.addEventListener(ForticomAPI.CONNECTED, this.apiIsReady);
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, this.handleApiCallback);
			ForticomAPI.connection = this.stage.loaderInfo.parameters["apiconnection"];
			
			//bind methods
			ExternalInterface.addCallback("FAPI_send", ForticomAPI.send);
		}
		
		protected function handleApiCallback(event : ApiCallbackEvent) : void
		{
			ExternalInterface.call("API_callback", event.method, event.result, event.data);
		}
		
		protected function apiIsReady(event : Event) : void
		{
			trace("API Connected");
			ExternalInterface.call("API_initialized");
		}
		
		
	}
}