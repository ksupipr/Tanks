package com.api.forticom//.ForticomAPIProxy 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	/**
	 * @author Erik <erya14@gmail.com>
	 * @date 22/02/2010 08:16
	 * @description
	 */
	public class ForticomAPIProxy extends Sprite
	{
		public static const DEBUG : Boolean = true;
		
		private var _connection : LocalConnection = new LocalConnection;
		private var _connectionName : String;
		private var _eventsPool : Array = [];
		private var _connected : Boolean = false;
		
		private var _timer : Timer = new Timer(200);
		
		public function ForticomAPIProxy() 
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			this._timer.addEventListener(TimerEvent.TIMER, this.timer);
						
			if (ExternalInterface.available)
				ExternalInterface.addCallback("__FAPI__CallBack", this.handleCallBack);
			
			this.createConnection();
			this.connect(this._connectionName);		
		}
		
		protected function createConnection() : void
		{
			this._connection.allowDomain("*");
			this._connection.addEventListener(StatusEvent.STATUS, this.handleOutStatus);
			this._connection.client = this;
			this._connectionName = this.stage.loaderInfo.parameters["apiconnection"];
			
			if (!this._connectionName)
				throw new Error("Error: apiconnection parameter is undefined!");
		}
		
		public function makeReconnect() : void
		{
			establishConnection();
		}
		
		/**
		 * т.к. обратный вызов происходит только после вызова какого-то метода
		 * через API - значит соединение уже установлено и не нужно его
		 * проверять и складывать запросы в очередь в случае, если оно не установлено
		 */ 
		protected function handleCallBack(methodName : String, result : String, params : String) : void
		{
			this._connection.send("_api_" + this._connectionName, "apiCallBack", methodName, result, params);
		}
		
		private function handleOutStatus(event : StatusEvent) : void
		{
			if (event.level != StatusEvent.STATUS)
			{
				if (!this._connected)
				{
					// retry to establish connection
					this._timer.start();
				}
				else
				{
					// simple send error
				}
			}
			else
			{
				if (!this._connected)
				{
					// Connection established
					this._connected = true;
				}
			}
		}
		
		private function timer(event : Event) : void
		{
			this._timer.stop();
			this.establishConnection();
		}
		
		private function establishConnection() : void
		{
			if (DEBUG) trace("Trying to establish connection to client "+this._connectionName);
			this._connection.send("_api_" + this._connectionName, "establishConnection");
		}
		
		public function showInstall() : void
		{
			this.sendToJS("__FAPI__ShowInstall");
		}
		
		public function showPermissions(permissions : String) : void
		{
			this.sendToJS("__FAPI__ShowPermissions", permissions);
		}
		
		public function showFeed(uid : String = null, attachment : String = null, actionLinks : String = null) : void
		{
			this.sendToJS("__FAPI__ShowFeed", uid, attachment, actionLinks);
		}
		
		public function showInvite(userText : String = "", attributes : String = "") : void
		{
			this.sendToJS("__FAPI__ShowInvite", userText, attributes);
		}
		
		public function showNotification(userText : String, attributes : String = "") : void
		{
			this.sendToJS("__FAPI__ShowNotification", userText, attributes);
		}
		
		public function showPayment(name : String, description : String, code : String, price : int = -1, options : String = null, attributes : String = null, currency : String = "", callback : String = 'false') : void
		{
			this.sendToJS("__FAPI__ShowPayment", name, description, code, price.toString(), options, attributes, currency, callback);
		}
		
		public function showConfirmation(method : String, userText : String, signature : String) : void
		{
			this.sendToJS("__FAPI__ShowWindow", method, userText, signature);
		}
		
		public function setWindowSize(width : String, height : String) : void
		{
			this.sendToJS("__FAPI__SetWindowSize", width, height);
		}
		
		protected function sendToJS(method : String, ...rest) : void
		{
			try
			{
				ExternalInterface.call.apply(null, [method].concat(rest));
			}
			catch (e : Error) { trace(e.message); };
		}
		
		public function connect(name : String) : void
		{
			try
			{
				this._connection.connect("_proxy_" + this._connectionName);
				this.establishConnection();
			}
			catch (e : Error)
			{
				throw new Error("Connection " + name + " is already in use!");
			}
		}
		
	}

}