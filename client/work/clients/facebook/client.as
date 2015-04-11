package clients.mail{
	
	import flash.events.*;
	import flash.display.*;
	import flash.system.Security;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenu;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.utils.ByteArray;
	import flash.geom.ColorTransform;
	import flash.external.ExternalInterface;
	
	public class client extends MovieClip{
		
		private var clip:MovieClip;
		private var par_ar:Array;
		private static const CUSTOM_JS_EVENT : String = 'customJSEvent';
		
		public function client(){
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function permissionsChangedHandler ( event : MailruCallEvent ) : void {
			//log ( 'permissionsChangedHandler(): ' + traceObject ( event.data ) );
		}
		
		private function albumCreatedHandler ( event : MailruCallEvent ) : void {
			//log ( 'albumCreatedHandler(): ' + traceObject ( event.data ) );
		}
		
		private function guestbookPublishHandler ( event : MailruCallEvent ) : void {
			//log ( 'guestbookPublishHandler(): ' + traceObject ( event.data ) );
		}
		
		private function streamPublishHandler ( event : MailruCallEvent ) : void {
			//log ( 'streamPublishHandler(): ' + traceObject ( event.data ) );
		}
		
		private function mailruReadyHandler ( event : Event ) : void {
			//log ( 'Mail.ru API ready' );
			LoadLink();
		}
		
		private function customEventHandler ( event : MailruCallEvent ) : void {
			//log ( 'onCustomEvent(): ' + traceObject ( event.data ) );
		}
		
		public function onAddedToStage(event:Event):void{ 
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			Security.allowDomain("*");
			//Security.loadPolicyFile("http://tanks.xlab.su/crossdomain.xml");
			stage.dispatchEvent(new Event(Event.DEACTIVATE));
			stage.dispatchEvent(new Event(Event.ACTIVATE));
			stage.scaleMode="noScale";
			contextMenu = new ContextMenu();
      contextMenu.hideBuiltInItems();
      var ciVkontakteRu:ContextMenuItem = new ContextMenuItem("Tanchiki 2");
      ciVkontakteRu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e) { 
        navigateToURL(new URLRequest("http://my.mail.ru/apps/606636"), "_blank")
      });
      var ciAuthor:ContextMenuItem = new ContextMenuItem("X-LAB Studio");
      ciAuthor.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e) { 
        navigateToURL(new URLRequest("http://xlab.su"),    "_blank")
      });
			contextMenu.customItems.push(ciVkontakteRu);
      contextMenu.customItems.push(ciAuthor);
			getAppParams();
		}
		
		protected static var tested:Boolean=false;
		private var cl_url:String="game_test.swf";
		private var myID:String;
		
		public function getAppParams(){
			par_ar=new Array();
			var params:Object=null;
			if(!tested){
				params = loaderInfo.parameters;
				par_ar[0]=(params['oid']);
				par_ar[1]=(params['group_id']);
				par_ar[2]=(params['vid']);
				par_ar[3]=(params['referer_type']);
				par_ar[4]=(params['sig']);
				par_ar[5]=(params['app_id']);
				par_ar[6]=(params['api_url']);
				par_ar[7]=(params['is_app_user']);
				//par_ar[8]=(params['secret']);
				par_ar[16]=params['referer_id'];
				myID=MailruCall.exec('mailru.session.vid');
			}else{
				par_ar[0]=0;
				par_ar[1]=0;
				par_ar[2]=8790300971262502834;  // 91521807  // 20707807
				par_ar[3]="empty";
				par_ar[4]="b10589bc5aef3c5e5cccad53f9e051f6";
				par_ar[5]=606636;    // norm=1888415 // test=606636
				par_ar[6]="http://api.vkontakte.ru/api.php";
				par_ar[7]=1;
				myID="8790300971262502834";
			}
			if(par_ar[0]==0){
				par_ar[0]=68749263;
			}
			
			if(par_ar[5]==1888415){
				par_ar[8]=("3MOgXmlBdA");
				par_ar[9]="";    //norm
				par_ar[10]=("http://tanks.xlab.su/loc/index.php?");
				Security.loadPolicyFile("http://tanks.xlab.su/crossdomain.xml");
			}else if(par_ar[5]==606636){
				par_ar[8]=('9fc7d9de2daa48e2cb90b0e3d01bb5e7');
				par_ar[9]="";    //test
				par_ar[10]=("http://unlexx.ath.cx/loc/index.php?");
				Security.loadPolicyFile("http://unlexx.ath.cx/crossdomain.xml");
			}
			
			var versionString:String = Capabilities.version;
			var pattern:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/;
			var result:Object = pattern.exec(versionString);
			var vers:Array=new Array();
			if(result!=null){
				/*trace("Результат: " + result.input);
				trace("Платформа: " + result[1]);
				trace("Версия плеера: " + result[2]);
				trace("Промежуточная версия: " + result[3]);
				trace("Номер сборки: " + result[4]);
				trace("Внутренний номер сборки: " + result[5]);*/
				vers[0]=result[1];
				vers[1]=int(result[2]);
				vers[2]=int(result[3]);
				vers[3]=int(result[4]);
				vers[3]=int(result[5]);
				//trace(vers);
				if(vers[1]<10){
					try{
						removeChild(root["auto_tx"]);
					}catch(er:Error){}
					return;
				}else{
					try{
						removeChild(root["player_tx"]);
					}catch(error:Error){
						
					}
					//_sendRequest("wall.getPhotoUploadServer");
					//LoadLink();
				}
			}else{
				//LoadLink();
			}
			
			MailruCall.init ( 'flash-app', par_ar[8] );
			
			MailruCall.addEventListener ( Event.COMPLETE, mailruReadyHandler );
			MailruCall.addEventListener ( CUSTOM_JS_EVENT, customEventHandler );
			
			MailruCall.addEventListener ( MailruCallEvent.PERMISSIONS_CHANGED, permissionsChangedHandler );
			MailruCall.addEventListener ( MailruCallEvent.ALBUM_CREATED, albumCreatedHandler );
			MailruCall.addEventListener ( MailruCallEvent.GUESTBOOK_PUBLISH, guestbookPublishHandler );
			MailruCall.addEventListener ( MailruCallEvent.STREAM_PUBLISH, streamPublishHandler );
		}
		
		public function linkTo(req:URLRequest){
			navigateToURL(req,"_self");
		}
		
		public function showMoneyWin(_num:Number){
			MailruCall.exec ( 'mailru.app.payments.showDialog', showPaymentDialogCallback, {
				service_id: 1,
				service_name: 'валюту', 
				sms_price: -1,
				other_price: _num
			});
		}
		
		private function showPaymentDialogCallback ( ...args ) : void {
			//log ( 'showPaymentDialogCallback(): ' + traceObject ( args ) );
		}
		
		public function callFriends(){
			MailruCall.exec ( 'mailru.app.friends.invite' );
		}
		
		public function initPar(){
			if(!tested){
				stage.frameRate=25;
				stage.scaleMode=StageScaleMode.NO_SCALE;
				//wrapper.external.setTitle("Танчики 2");
			}
		}
		
		private function openHandler(event:Event):void {
			
		}
		
		private function progressHandler(event:ProgressEvent):void {
			
		}
		
		public function LoadLink(){
			try{
				root["auto_tx"].text="Идёт подключение...";
			}catch(er:Error){}
			var loader:URLLoader = new URLLoader();
			var r_req:URLRequest=new URLRequest(par_ar[10]+""+(Math.random()*1000000000000));
			loader.dataFormat=URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.OPEN, openHandler );
			loader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadLink);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessLink);
			loader.load(r_req);
		}
		
		public var link_er:int=0;
		
		private function unLoadLink(event:IOErrorEvent):void {
			ErLink(link_er,0);
		}
		
		private function accessLink(event:SecurityErrorEvent):void {
			ErLink(link_er,1);
		}
		
		public function ErLink(e_count:int,_j:int){
			trace("errCount   "+load_er);
			if(e_count<2){
				link_er++;
				LoadLink();
			}else{
				if(_j==0){
					errTest("Ошибка подключения к серверу", 150);
				}else{
					errTest("Для подключения не удалось получить файл кросс доменной политики безопасности", 100);
				}
			}
		}
		
		public function LoadLink1(){
			try{
				root["auto_tx"].text="Получение адреса...";
			}catch(er:Error){}
			var loader:URLLoader = new URLLoader();
			var r_req:URLRequest=new URLRequest(par_ar[10]+"res="+res_try+"&"+(Math.random()*1000000000000));
			loader.dataFormat=URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.OPEN, openHandler );
			loader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler1);
			loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadLink1);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessLink1);
			loader.load(r_req);
		}
		
		private var link_er1:int=0;
		private var res_try:int=0;
		
		private function unLoadLink1(event:IOErrorEvent):void {
			ErLink1(link_er1,0);
		}
		
		private function accessLink1(event:SecurityErrorEvent):void {
			ErLink1(link_er1,1);
		}
		
		public function ErLink1(e_count:int,_j:int){
			//trace("errCount   "+load_er);
			if(e_count<2){
				link_er1++;
				LoadLink1();
			}else{
				if(_j==0){
					errTest("Ошибка получения адреса", 150);
				}else{
					errTest("Для получения адреса не удалось получить файл кросс доменной политики безопасности", 100);
				}
			}
		}
		
		private function completeHandler(event:Event):void {
			var _str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			var _i:int=0;
			var _j:int=0;
			par_ar[11]="";
			par_ar[12]="";
			try{
				var list:XML=new XML(_str);
				list=list.child("result")[0];
			}catch(er:Error){
				try{
					removeChild(root["auto_tx"]);
				}catch(er:Error){}
				errTest("Неверный формат полученных данных. \nПри подключении.",int(600/2));
				erTestReq(100,0,_str);
				return;
			}
			//trace(list);
			if(int(list.child("err")[0].attribute("code"))==0){
				par_ar[11]=list.child("err")[0].attribute("link1")+"";
				par_ar[12]="?"+list.child("err")[0].attribute("reff")+"";
			}else{
				try{
					removeChild(root["auto_tx"]);
				}catch(er:Error){}
				errTest(list.child("err")[0].attribute("comm")+"",int(600/2));
				return;
			}
			Security.loadPolicyFile(par_ar[11]+"/crossdomain.xml");
			par_ar[11]+="/sendQuery.php";
			//trace("script   "+par_ar[11]+"   "+_str);
			try{
				root["auto_tx"].text="Идёт получение адреса...";
			}catch(er:Error){}
			LoadLink1();
		}
		
		private function completeHandler1(event:Event):void {
			var _str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			try{
				var list:XML=new XML(_str);
				list=list.child("result")[0];
			}catch(er:Error){
				try{
					removeChild(root["auto_tx"]);
				}catch(er:Error){}
				errTest("Неверный формат полученных данных. \nПри подключении.",int(600/2));
				erTestReq(100,0,_str);
				return;
			}
			//trace(list);
			if(int(list.child("err")[0].attribute("code"))==0){
				if(!tested){
					par_ar[13]=list.child("err")[0].attribute("link2")+"";
					cl_url=par_ar[13]+"/res/"+cl_url+""+par_ar[12];
				}else{
					par_ar[13]=list.child("err")[0].attribute("link2")+"";
					//cl_url=par_ar[13]+"/"+cl_url;
				}
			}else{
				try{
					removeChild(root["auto_tx"]);
				}catch(er:Error){}
				errTest(list.child("err")[0].attribute("comm")+"",int(600/2));
				return;
			}
			Security.loadPolicyFile(par_ar[13]+"/crossdomain.xml");
			try{
				root["auto_tx"].text="Идёт получение данных об игроке...";
			}catch(er:Error){}
			MailruCall.exec ( 'mailru.common.users.getInfo', getUserInfoCallback );
		}
		
		private function getUserInfoCallback ( users : Object ) : void {
			//trace('getUserInfoCallback(): ');
			//trace(traceObject(users));
			trace((users[0].uid)+"   "+(users[0].first_name+" "+users[0].last_name));
			if(par_ar[2]==Number(users[0].uid)){
				par_ar[14]=(users[0].first_name+" "+users[0].last_name);
				try{
					root["auto_tx"].text="Дождитесь завершения авторизации...";
				}catch(er:Error){}
				firstInit(par_ar[2],par_ar[14]);
			}
		}
		
		private function openImage(event:Event):void {
			try{event.currentTarget.loader.name="ready";}catch(er:Error){}
		}
		
		private function unLoadImageRes(event:IOErrorEvent):void {
			try{event.currentTarget.loader.name="ready";}catch(er:Error){}
			errCount(load_er);
		}
		
		private function unLoadImageRes1(event:IOErrorEvent):void {
			try{event.currentTarget.loader.name="ready";}catch(er:Error){}
			errCount(load_er);
		}
		
		private function accessErrorRes(event:SecurityErrorEvent):void {
			try{event.currentTarget.loader.name="ready";}catch(er:Error){}
			errCount(load_er);
		}
		
		private function progressImage(event:ProgressEvent):void {
			try{event.currentTarget.loader.name="ready";}catch(er:Error){}
			var percent:Number=event.bytesLoaded/event.bytesTotal;
		}
		
		public var load_er:int=0;
		
		public function errCount(e_count:int){
			//trace("errCount   "+load_er);
			if(e_count<2){
				load_er++;
				loadCl();
			}else{
				errTest("Ошибка загрузки клиента", 100);
			}
		}
		
		public function loadCl(){
			var loader:Loader = new Loader();
			loader.name="wait";
			//loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, errorConnection);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openImage );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressImage);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeImage);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessErrorRes);
			loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadImageRes1);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, unLoadImageRes);
			
			loader.load(new URLRequest(cl_url));
		}
		
		private function completeImage(event:Event):void {
			try{event.currentTarget.loader.name="ready";}catch(er:Error){}
			try{
				clip=event.currentTarget.content;
			}catch(error:Error){
				errCount(load_er);
				return;
			}
			try{
				clip.x=0;
				clip.y=0;
				cl_class=clip.getClass(clip);
				par_ar[15]=tested;
				addChild(clip);
				clip.init_f(par_ar);
			}catch(e:Error){
				errTest(e+"", 100);
			}
		}
		
		private var cl_class:Class;
		
		public function errTest(er:String,Y:int){
			var txt:TextField=new TextField();
			var tfm:TextFormat=new TextFormat("Times New Roman",19,0x000000);
			tfm.align=TextFormatAlign.CENTER;
			txt.multiline=true;
			txt.wordWrap=true;
			txt.text=er;
			txt.width=756;
			txt.autoSize=TextFieldAutoSize.CENTER;
			txt.defaultTextFormat=tfm;
			txt.setTextFormat(txt.defaultTextFormat);
			txt.x=756/2-txt.width/2;
			txt.y=Y-txt.height/2;
			addChild(txt);
		}
		
		public function _sendImage(){
       MailruCall.exec ( 'mailru.common.stream.publish', null, {
				'title': 'Заголовок',
				'text': 'Текст',
				'img_url': 'http://bitman.me/mailru/demo/img/stream_pic.jpeg'
			});
    }
		
		public var set_mus:Boolean=false;
		public var upl_url:String="";
		public var upl_pict:String="";
		
		public function completeWall(event: Event): void {
			//var loader:Loader = new Loader();
			//trace(event.currentTarget.content);
			//trace(wall_cl);
			//trace(wall_cl["close_cl"]);
			if(cl_class.wall_cl["reff"]=="wall_post_inline"){
				cl_class.wall_cl["fr_cl"].visible=false;
			}else{
				
			}
			clip["wall_win"]=true;
			cl_class.wall_cl["close_cl"].newPict(event.currentTarget.content);
			cl_class.wall_cl["name_tx"].text=clip["upl_name"];
			cl_class.wall_cl["m_tx"].text=clip["upl_mess"];
			if(clip["holly"][0]!="no holly"&&clip["holly"][0]!=""){
				cl_class.wall_cl["holly_cl"]["name_tx"].text=clip["holly"][0];
				cl_class.wall_cl["holly_cl"]["tx"].text=clip["holly"][1];
				cl_class.wall_cl["holly_cl"].visible=true;
			}else{
				cl_class.wall_cl["holly_cl"].visible=false;
			}
			clip.addChild(cl_class.wall_cl);
		}
		
		private function unLoadHandler(event:IOErrorEvent):void {
			//errTest("Сервер временно недоступен\n"+event.text,int(600/2));
		}
		
		private function accessError(event:SecurityErrorEvent):void {
			//errTest("Сервер временно недоступен\n"+event.text,int(600/2));
		}
		
		private var send_pl:Boolean=false;
		private var send1:Boolean=false;
		
		private var _prefix:String="ml";
		
		public function get sn_prefix():String{
			return _prefix;
		}
		
		public function firstInit(a:Number,b:String){
				//warn_f(7,"Соединение...");
				if(send_pl){
					send1=true;
				}
				send_pl=true;
				var rqs:URLRequest=new URLRequest(par_ar[11]+"?query="+100+"&action="+0);
				rqs.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader(rqs);
				var strXML:String="<query id=\"100\" sn_prefix=\""+_prefix+"\" sn_id=\""+a+"\" sn_name=\""+b+"\" auth_key=\""+par_ar[4]+"\" />";
				//trace(strXML);
				var variables:URLVariables = new URLVariables();
				variables.query = strXML;
				variables.send = "send";
				rqs.data = variables;
				loader.addEventListener(IOErrorEvent.IO_ERROR, sendEr);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, seEr);
				loader.addEventListener(Event.COMPLETE, initReady);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(rqs);
				//errTest(strXML,50);
		}
		
		public function seEr(event:SecurityErrorEvent){
			if(send1){
				try{
					removeChild(root["auto_tx"]);
				}catch(er:Error){}
				errTest("Security Error 1",int(600/2));
			}else{
				var a_timer:Timer=new Timer(3000,1);
				a_timer.addEventListener(TimerEvent.TIMER_COMPLETE, secd_query);
				a_timer.start();
			}
		}
		
		public function sendEr(event:IOErrorEvent){
			if(send1){
				try{
					removeChild(root["auto_tx"]);
				}catch(er:Error){}
				errTest("Сервер не отвечает 1\n"+event.text,int(600/2));
			}else{
				var a_timer:Timer=new Timer(3000,1);
				a_timer.addEventListener(TimerEvent.TIMER_COMPLETE, secd_query);
				a_timer.start();
			}
		}
		
		public function initReady(event:Event){
			var mstr:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("mstr   "+mstr);
			try{
				var list:XML=new XML(mstr);
				list=list.child("result")[0];
			}catch(er:Error){
				try{
					removeChild(root["auto_tx"]);
				}catch(er:Error){}
				errTest("Неверный формат полученных данных. \nАвторизация.",int(600/2));
				erTestReq(100,0,mstr);
				return;
			}
			if(int(list.child("err")[0].attribute("code"))==0){
				try{
					removeChild(root["auto_tx"]);
				}catch(er:Error){}
				loadCl();
			}else{
				if(send1){
					try{
						removeChild(root["auto_tx"]);
					}catch(er:Error){}
					errTest(""+(list.child("err")[0].attribute("comm")),int(600/2));
				}else{
					var a_timer:Timer=new Timer(3000,1);
					a_timer.addEventListener(TimerEvent.TIMER_COMPLETE, secd_query);
					a_timer.start();
				}
			}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function erTestReq(a:int,b:int,c:String){
			//trace(uid+"   "+a+"   "+b+"   "+c);
			var reslt_s:String=c;
			var strXML:String="<query id=\"111\" id_u=\""+par_ar[2]+"\" query=\"\" log_query="+"\""+a+"\""+" log_action="+"\""+b+"\" />";
			var rqs:URLRequest=new URLRequest(par_ar[11]+"?query="+111+"&action="+0);
			rqs.method=URLRequestMethod.POST;
			//var list:XML=new XML(strXML);
			var variables:URLVariables = new URLVariables();
			variables.query = strXML;
			variables.result = reslt_s;
			variables.send = "send";
			rqs.data = variables;
			//trace(serv_url+"\n");
			//trace(rqs.data);
			var loader:URLLoader=new URLLoader(rqs);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
		}
		
		public function secd_query(event:TimerEvent){
			firstInit(par_ar[2],par_ar[14]);
		}
		
	}
}
