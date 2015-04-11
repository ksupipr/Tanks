package {
	
	import api.JPGEncoder;
	import api.MD5;
	import api.MultipartURLLoader;
	import api.PNGEncoder;
	import api.serialization.json.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.system.System;
	import flash.text.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import json.JSON;
	
	import utils.Console;
	import utils.MouseWheelTrap;
	import utils.loadObject;
	import utils.xFormat;
	
	import vk.APIConnection;
	import vk.events.*;
	import vk.ui.VKButton;
	
	[SWF(width="756", height="600", frameRate="24", backgroundColor="#F0DB7D")]
	public class vk_client extends MovieClip{
		
		public function draw_mask(_cl:MovieClip,_x:int,_y:int,_w:int,_h:int,_rw:int,_rh:int, _play:Boolean=true){
			var _width:Number=0;
			var _height:Number=0;
			if(_cl.totalFrames>1){
				for(var i:int=1;i<_cl.totalFrames+1;i++){
					_cl.gotoAndStop(i);
					if(_width<_cl.width){
						_width=_cl.width;
					}
					if(_height<_cl.height){
						_height=_cl.height;
					}
				}
			}else{
				_play=false;
			}
			var _shapes:Array=[new Shape(),new Shape(),new Shape(),new Shape()];
			var _rect:Rectangle=new Rectangle(_width/2-_w/2+_x,_height/2-_h/2+_y,_w,_h);
			//_rect.width+=_rect.x;
			//_rect.height+=_rect.y;
			
			_shapes[0].x=-_rect.width/2;
			_shapes[0].y=-_rect.height/2;
			_shapes[1].x=-_rect.width/2;
			_shapes[1].y=_rect.height/2;
			_shapes[2].x=_rect.width/2;
			_shapes[2].y=_rect.height/2;
			_shapes[3].x=_rect.width/2;
			_shapes[3].y=-_rect.height/2;
			var _test:Sprite=new Sprite();
			_test.x=_rect.x+_rect.width/2;
			_test.y=_rect.y+_rect.height/2;
			_test.addChild(_shapes[0]);
			_test.addChild(_shapes[1]);
			_test.addChild(_shapes[2]);
			_test.addChild(_shapes[3]);
			_cl.addChild(_test);
			_test.rotation=_cl.rotation;
			var pt1:Point=new Point(_shapes[0].x,_shapes[0].y);
			pt1=_test.localToGlobal(pt1);
			pt1=_cl.globalToLocal(pt1);
			var pt2:Point=new Point(_shapes[1].x,_shapes[1].y);
			pt2=_test.localToGlobal(pt2);
			pt2=_cl.globalToLocal(pt2);
			var pt3:Point=new Point(_shapes[2].x,_shapes[2].y);
			pt3=_test.localToGlobal(pt3);
			pt3=_cl.globalToLocal(pt3);
			var pt4:Point=new Point(_shapes[3].x,_shapes[3].y);
			pt4=_test.localToGlobal(pt4);
			pt4=_cl.globalToLocal(pt4);
			_cl.removeChild(_test);
			
			var _rect1:Rectangle=new Rectangle(0,0,_width,_height);
			var r_clip:MovieClip=new MovieClip();
			r_clip.graphics.beginFill(0x000000);
			//r_clip.graphics.lineStyle(1);
			r_clip.graphics.moveTo(pt1.x,pt1.y);
			r_clip.graphics.lineTo(pt2.x,pt2.y);
			r_clip.graphics.lineTo(pt3.x,pt3.y);
			r_clip.graphics.lineTo(pt4.x,pt4.y);
			r_clip.graphics.lineTo(pt1.x,pt1.y-0.0001);
			r_clip.graphics.lineTo(_rect1.x,pt1.y-0.0001);
			r_clip.graphics.lineTo(_rect1.x,_rect1.y);
			r_clip.graphics.lineTo(_rect1.width,_rect1.y);
			r_clip.graphics.lineTo(_rect1.width,_rect1.height);
			r_clip.graphics.lineTo(_rect1.x,_rect1.height);
			r_clip.graphics.lineTo(_rect1.x,pt1.y);
			r_clip.graphics.lineTo(pt1.x,pt1.y);
			
			r_clip.x=-_width/2;
			r_clip.y=-_height/2;
			_cl.addChild(r_clip);
			_cl.mask=r_clip;
			if(_play){
				_cl.play();
			}
		}
		
		public function bytes_to_base64(_ba:ByteArray):String{
			return Base64.encodeByteArray(_ba);
		}
		
		private static var console:Console;
		public function output(_str:String,_num:int=0):void{
			console.status(_str,_num);
		}
		public function output1(_str:String):void{
			console.status(_str+"\n",1);
		}
		public function get logs():String{
			return console.log;
		}
		
		public static var _log:int=-1;
		public static var _deep:int=0;
		public function log(_str:String,_num:int=0,_tp:int=1,_dp:int=0){
			if(_tp==_log||_log<0){
				if(_dp<=_deep){
					output(_str,_num);
				}
			}
		}
		
		public function format_tx(_str:String,_txtf:TextField,_cl:MovieClip=null,_clear:int=0):void{
			if(_clear==1){
				_txtf.htmlText="";
				if(_txtf.styleSheet!=null){
					_txtf.styleSheet.clear();
				}
			}
			xFormat.format(_str,_txtf,_cl);
		}
		public function getFont(_str:String,_cl:MovieClip=null):String{
			var font_obj:Object=new Object();
			var font_str:String="";
			_str=_str.toLowerCase();
			_str=_str.split(" ").join("");
			//trace(_str+"   "+fonts);
			if(_str=="_sans"){
				return "_sans";
			}else if(fonts==null){
				console.status("<b><font color=\"#ff0000\" size=\"11\">Embedded fonts are not loaded</font></b>\n");
				return "_sans";
			}
			if(fonts.hasDefinition(_str+"_reg")){
				font_obj.regular=(_str+"_reg");
			}
			if(fonts.hasDefinition(_str+"_bold")){
				font_obj.bold=(_str+"_bold");
			}
			if(fonts.hasDefinition(_str+"_ita")){
				font_obj.italic=(_str+"_ita");
			}
			if(fonts.hasDefinition(_str+"_ita_b")){
				font_obj.ita_b=(_str+"_ita_b");
			}
			for(var _s:String in font_obj){
				
				if(reg_fonts[font_obj[_s]]==null){
					//Font.registerFont(font_obj[_s]);
					
					var fontClass:Class = fonts_cl.init(font_obj[_s]);
					var font:Font = new fontClass();
					font_str=font.fontName;
					
					output("register: " + font_obj[_s]+" - "+ font_str+"\n");
					reg_fonts[font_obj[_s]]=font;
				}else{
					font_str=reg_fonts[font_obj[_s]].fontName;
				}
				
			}
			//font_str=font_str.substr(0,font_str.length-1);
			/*var fontList : Array = Font.enumerateFonts();
			for ( var _s:String in fontList ){
			trace("font: " + Font(fontList[_s]).fontName);
			}*/
			//_cl.regFonts(font_obj);
			return font_str;
		}
		public function setfonts(_fonts:ApplicationDomain):void{
			fonts=_fonts;
			//trace(fonts+"   "+_fonts);
		}
		
		public function getfonts():ApplicationDomain{
			return fonts;
		}
		
		public function setfontCl(_fonts_cl:MovieClip):void{
			fonts_cl=_fonts_cl;
			//trace(fonts+"   "+_fonts);
		}
		
		public function getfontCl():MovieClip{
			return fonts_cl;
		}
		
		private var fonts_cl:MovieClip;
		
		public function simpleVar(_str:String):String{
			var _var:String="underfined";
			if(text_vars.hasOwnProperty(_str)){
				_var=text_vars[_str];
			}
			return _var;
		}
		
		public function findVar(_str:String,_txtf:TextField,_cl:MovieClip=null,_clear:int=1):void{
			var _var:String="underfined";
			if(text_vars.hasOwnProperty(_str)){
				_var=text_vars[_str];
			}
			format_tx(_var,_txtf,_cl,_clear);
			if(_txtf.stage!=null){
				fieldVar(_txtf,_str);
			}else{
				if(!_txtf.hasEventListener(Event.ADDED_TO_STAGE)){
					_txtf.addEventListener(Event.ADDED_TO_STAGE,function(ev:Event){
						fieldVar(_txtf,_str);
					});
				}
			}
		}
		public function fieldVar(_txtf:TextField,_var:String):void{
			var _cl:MovieClip=_txtf.parent as MovieClip;
			if(xlabFields[_cl.name]==null){
				xlabFields[_cl.name]=new Object();
			}
			xlabFields[_cl.name][_txtf.name]=_var;
		}
		public var xlabFields:Object=new Object();
		public var xlabPicts:Object=new Object();
		
		public function erPict(W:int,H:int):Bitmap{
			var _bm:Bitmap=new Bitmap();
			var _shape:Shape=new Shape();
			var _gr:Graphics=_shape.graphics;
			_gr.beginFill(0xffffff,.5);
			_gr.lineStyle(1,0xff0000,1);
			_gr.drawRect(0,0,W,H);
			_gr.moveTo(0,0);
			_gr.lineTo(W,H);
			_gr.moveTo(0,H);
			_gr.lineTo(W,0);
			_bm.bitmapData=new BitmapData(W,H);
			_bm.bitmapData.draw(_shape);
			return _bm;
		}
		
		public var lang:XML;
		private var fonts:ApplicationDomain;
		private var reg_fonts:Object=new Object();
		private var text_vars:Object=new Object();
		
		private var prfx:String="vk";
		private var par_ar:Array;
		private var sn_names:Array;
		private var vl_names:Array;
		private var sn_p:Number;
		private var vl_p:Number;
		private var world_n:String;
		private var world_id:Number;
		
		public function get army_n():String{
			return (world_n);
		}
		
		public function get army_id():Number{
			return (world_id);
		}
		
		public function get sn_price():Number{
			return (sn_p);
		}
		
		public function get vl_price():Number{
			return (vl_p);
		}
		
		public function get vl_name():Array{
			return (vl_names);
		}
		
		public function get sn_name():Array{
			return (sn_names);
		}
		
		public function val_conv(_type:int,_n:Number):Number{
			if(_type==0){
				return (_n/sn_p)*vl_p;
			}
			return (_n/vl_p)*sn_p;
		}
		
		private static var _self:MovieClip;
		public static function get self():MovieClip{
			return (_self);
		}
		
		private var auto_tx:TextField=new TextField();
		public function vk_client(){
			Security.allowDomain("*");
			auto_tx.width=stage.stageWidth;
			//auto_tx.x=auto_tx.width/2;
			auto_tx.height=100;
			auto_tx.y=stage.stageHeight/2-auto_tx.height/2;
			auto_tx.autoSize=TextFieldAutoSize.CENTER;
			auto_tx.defaultTextFormat=new TextFormat("_sans",20,0x777777);
			auto_tx.multiline=true;
			auto_tx
			addChild(auto_tx);
			var versionString:String = Capabilities.version;
			var pattern:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/;
			var result:Object = pattern.exec(versionString);
			var vers:Array=new Array();
			if(result!=null){
				trace("Плеер: " + result.input);
				trace("Платформа: " + result[1]);
				trace("Версия плеера: " + result[2]);
				trace("Промежуточная версия: " + result[3]);
				trace("Номер сборки: " + result[4]);
				trace("Внутренний номер сборки: " + result[5]);
				vers[0]=result[1];
				vers[1]=int(result[2]);
				vers[2]=int(result[3]);
				vers[3]=int(result[4]);
				vers[3]=int(result[5]);
				//trace(vers);
				if(int(vers[1])<11){
					auto_tx.text="Ваша версия флэш плеера меньше необходимой\nСкачать его можно здесь http://get.adobe.com/ru/flashplayer/";
					return;
				}else{
					
					//_sendRequest("wall.getPhotoUploadServer");
				}
			}
			_self=this;
			xFormat.initFormat(_self,vk_client);
			console=new Console();
			re_req.addEventListener(TimerEvent.TIMER_COMPLETE, re_request);
			if(stage){
				getAppParams();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		public function onAddedToStage(event:Event):void{ 
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			getAppParams();
		}
		
		public function initPar(){
			if(!tested){
				stage.frameRate=25;
				stage.scaleMode=StageScaleMode.EXACT_FIT;
			}
		}
		
		private static var tested:Boolean=false;
		private var cl_url:String="game_test.swf";
		private var VK: APIConnection;
		
		public static var activated_st:Boolean=false;
		public static function activate_fnc(_var:Boolean):void{
			activated_st=_var;
		}
		
		public function getAppParams(){
			MouseWheelTrap.setup(stage,vk_client);
			stage.scaleMode="noScale";
			contextMenu = new ContextMenu();
      contextMenu.hideBuiltInItems();
      var ciVkontakteRu:ContextMenuItem = new ContextMenuItem("Tanchiki 2");
      ciVkontakteRu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e) { 
        navigateToURL(new URLRequest("http://vkontakte.ru/club18236003"), "_blank")
      });
      var ciAuthor:ContextMenuItem = new ContextMenuItem("X-LAB Studio");
      ciAuthor.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e) { 
        navigateToURL(new URLRequest("http://xlab.su"),    "_blank")
      });
			contextMenu.customItems.push(ciVkontakteRu);
      contextMenu.customItems.push(ciAuthor);
			
			par_ar=new Array();
			var flashVars:Object=null;
			flashVars = stage.loaderInfo.parameters as Object;
			
			/*for(var str:String in flashVars){
				trace(str+"="+flashVars[str]);
			}*/
			
			us_data.ref=(flashVars['referrer']);
			us_data.poster=(flashVars['poster_id']);
			us_data.post=(flashVars['post_id']);
			us_data.is_app=(flashVars['is_app_user']);
			
			par_ar[0]=(flashVars['user_id']);
			par_ar[1]=(flashVars['group_id']);
			par_ar[2]=(flashVars['viewer_id']);
			par_ar[3]=(flashVars['referrer']);
			par_ar[4]=(flashVars['auth_key']);
			par_ar[5]=(flashVars['api_id']);
			par_ar[6]=(flashVars['api_url']);
			par_ar[7]=(flashVars['is_app_user']);
			par_ar[8]=(flashVars['access_token']);
			par_ar[16]=flashVars['poster_id'];
			
			if(par_ar[0]==0){
				par_ar[0]=68749263;
			}
			
			if(par_ar[5]==1888415){
				par_ar[9]="";    //norm   1888415
				par_ar[10]=("http://tanks.xlab.su/loc/index.php?");
				Security.loadPolicyFile("http://tanks.xlab.su/crossdomain.xml");
			}else if(par_ar[5]==1891834){
				par_ar[9]="";    //test   1891834
				par_ar[10]=("http://unlexx.no-ip.org/loc/index.php?");
				Security.loadPolicyFile("http://unlexx.no-ip.org/crossdomain.xml");
			}
			
			VK = new APIConnection(flashVars);
			
			try{
				auto_tx.text="Инициализация приложения...";
			}catch(er:Error){}
			// Example of API request
			//VK.api('getProfiles', { uids: flashVars['viewer_id'] }, fetchUserInfo, onApiRequestFail);
			try{
				VK.callMethod("setTitle","Танчики 2");
			}catch(er:Error){
				errTest("Ошибка 1Api.", 150);
				return;
			}
			
			VK.addEventListener('onConnectionInit', function(): void{
				output("Connection initialized\n");
    	});
    	/*VK.addEventListener('onWindowBlur', function(): void{
    	  trace("Window blur\n");
    	});
    	VK.addEventListener('onWindowFocus', function(): void{
    	  trace("Window focus\n");
    	});*/
    	VK.addEventListener('onApplicationAdded', function(): void{
    	  output("Application added\n");
				
				//loadCl();
    	});
    	VK.addEventListener('onBalanceChanged', function(e:CustomEvent): void{
				output("Balance changed: "+e.params[0]+"\n");
				
				//cl_class.shop["exit"].rebuyCredits();
    	});
			
			VK.addEventListener('onOrderCancel', function(e:CustomEvent): void{
				output("OrderCancel: "+e.params[0]+"\n");
				
				cl_class.shop["exit"].clear_buy_ar();
			});
			VK.addEventListener('onOrderSuccess', function(e:CustomEvent): void{
				output("OrderSuccess: "+e.params[0]+"\n");
				
				cl_class.shop["exit"].rebuyCredits();
			});
			VK.addEventListener('onOrderFail', function(e:CustomEvent): void{
				output("OrderFail: "+e.params[0]+"\n");
				
				cl_class.shop["exit"].clear_buy_ar();
			});
			
    	VK.addEventListener('onSettingsChanged', function(e:CustomEvent): void{
				output("Settings changed: "+e.params[0]+"\n");
				
				cl_class.shop["exit"].clear_buy_ar();
				/*if(Boolean(e.settings & 8)){
					if(set_mus){
						set_mus=false;
						_sendRequest("audio.get");
					}
				}*/
    	});
			LoadLink();
		}
		
		public function linkTo1(req:URLRequest){
			navigateToURL(req, "_blank");
		}
		
		public function linkTo(req:URLRequest){
			navigateToURL(req, "_self");
		}
		
		public function showMoneyWin(_num:Number){
			var params = {
				type: "item",
				item: "credits_"+_num
			};
			VK.callMethod("showOrderBox", params);
			//VK.callMethod("showPaymentBox", _num);
		}
		
		public function callFriends(){
			VK.callMethod("showInviteBox");
		}
		
		private function openHandler(event:Event):void {
			
		}
		
		private function progressHandler(event:ProgressEvent):void {
			//draw_bar(event.bytesLoaded,event.bytesTotal);
		}
		
		public function draw_bar(_a:Number,_b:Number){
			var X:int=756/2-50;
			var Y:int=auto_tx.y+auto_tx.textHeight+10;
			graphics.clear();
			graphics.lineStyle(1,0x000000,0);
			graphics.beginFill(0x009900);
			graphics.drawRect(X,Y,(_a/_b)*100,5);
			graphics.lineStyle(1,0x000000);
			graphics.beginFill(0x009900,0);
			graphics.drawRect(X,Y,100,5);
		}
		
		public function LoadLink(){
			try{
				auto_tx.text="Идёт подключение...";
			}catch(er:Error){}
			var loader:URLLoader = new URLLoader();
			var r_req:URLRequest=new URLRequest(par_ar[10]+""+(Math.random()*1000000000000));
			r_req.method=URLRequestMethod.POST;
			var strXML:String="<loc sn_prefix=\""+prfx+"\" sn_id=\""+par_ar[2]+"\" auth_key=\""+par_ar[4]+"\" />";
			//trace("first   "+strXML);
			var variables:URLVariables = new URLVariables();
			variables.query = strXML;
			variables.send = "send";
			r_req.data = variables;
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
			output("ErLink   "+link_er);
			if(e_count<2){
				link_er++;
				LoadLink();
			}else{
				if(_j==0){
					errTest("Ошибка 4Lcn.", 100);
				}else{
					errTest("Ошибка 5Lcn.", 100);
				}
			}
		}
		
		private var _urls:Array=new Array();
		private var _res:Array=new Array();
		private function completeHandler(event:Event):void {
			console.status("LoadLink\n"+event.target.data+"\n");
			var _str:String=event.target.data+"";
			//trace(_str);
			try{
				var test_obj:Object=json.JSON.decode(_str);
			}catch(er:Error){
				try{
					removeChild(auto_tx);
				}catch(er:Error){}
				console.status("<b><font color=\"#ff0000\" size=\"11\">PARSE ERROR</font></b>\n");
				errTest("Ошибка 1Lcn",int(600/2));
				return;
			}
			//trace("asd  "+test_obj);
			//trace("asdw "+test_obj["error"]);
			if(test_obj["error"]==null){
				try{
					par_ar[11]=test_obj["resource"]["script_url"];
					_urls=test_obj["resource"]["reshosts"];
					par_ar[12]=_urls[0];
					_res=test_obj["resource"]["res"];
					sn_names=test_obj["resource"]["m_names"].split(',');
					vl_names=test_obj["resource"]["val_names"].split(',');
					sn_p=Number(String(test_obj["resource"]["m_price"]).split('/')[0]);
					vl_p=Number(String(test_obj["resource"]["m_price"]).split('/')[1]);
					world_n=test_obj["resource"]["world_name"];
					world_id=test_obj["resource"]["world_num"];
					//trace(_res[0].url);
					//trace(_urls[0].url);
				}catch(er:Error){
					try{
						removeChild(auto_tx);
					}catch(er:Error){}
					errTest("Ошибка 2Lcn",int(600/2));
					return;
				}
			}else{
				try{
					removeChild(auto_tx);
				}catch(er:Error){}
				errTest("Ошибка 3Lcn. \n"+"type="+test_obj["error"]["type"]+" val="+test_obj["error"]["val"],int(600/2));
				return;
			}
			
			Security.loadPolicyFile(par_ar[11]+"/crossdomain.xml");
			par_ar[11]+="/sendQuery.php";
			//trace("script   "+par_ar[11]+"   "+_str);
			Security.loadPolicyFile(par_ar[13]+"/crossdomain.xml");
			try{
				auto_tx.text="Дождитесь завершения авторизации...";
			}catch(er:Error){}
			par_ar[14]="";
			firstInit(par_ar[2],par_ar[14],1,1);
			var send_obj:Object={
				uids:par_ar[2],
				name_case:"nom",
				fields:"uid,first_name,last_name,nickname,domain,sex,bdate,city,country,timezone,photo,photo_medium,photo_big,has_mobile,rate,contacts,education"
			};
			_sendRequest("getProfiles",send_obj);
		}
		
		private var ldr_cl:MovieClip;
		private var load_c:int=0;
		
		public function drawLoadBar(event:Event):void{
			var W:int=279;
			var H:int=9;
			var X:int=0;
			var Y:int=0;
			var A:Number=0;
			var B:Number=0;
			for(var i:int=0;i<_res.length;i++){
				B++;
				if(_res[i].hasOwnProperty("buffer")){
					A+=_res[i].buffer.percent;
				}
			}
			var _gr:Graphics=ldr_cl["bar"].graphics;
			_gr.clear();
			//_gr.lineStyle(1,0x000000,0);
			_gr.beginFill(0xFF3333);
			_gr.drawRect(X,Y,(A/B)*W,H);
			//_gr.lineStyle(1,0x000000);
			//_gr.beginFill(0x009900,0);
			//_gr.drawRect(X,Y,W,H);
			_gr.beginFill(0x993333);
			_gr.drawRect(X,Y,(loadObject.cypher_state()/B)*W,H);
			allreadyLoaded();
		}
		
		public var cypher_on:Boolean=false;
		public function startLoad(_url:String,_target:MovieClip,_hosts:Array=null,_cache:Object=null,_result:Function=null,_params:Array=null,_max_retry:int=3):void{
			new loadObject(_url,_target,_hosts,_cache,_result,_params,_max_retry);
		}
		
		private function loadLog(_log:String):void {
			console.status(_log+"\n",1);
		}
		
		public function loadEvents(_name:String,_obj:loadObject,_data:*,_params:Array):void{
			var _st:int=_params[0];
			if(_name=="start"){
				_res[_st].buffer=_obj;
				loadLog("LOAD FILE("+(_st+1)+"/"+_res.length+"):[host="+_obj.hosts[_obj.host_num]+"  link="+_obj.url+"]");
			}else if(_name=="open"){
				
			}else if(_name=="progress"){
				
			}else if(_name=="try_url"){
				loadLog("TRY "+_obj.url+"("+_obj.retry+"/"+_obj.max_retry+"): "+_data);
			}else if(_name=="change_host"){
				loadLog("CHANGE HOST "+_obj.url+"("+_obj.host_num+"/"+_obj.hosts.length+"): "+_data);
			}else if(_name=="error"){
				if(_data.substr(0,7)=="finally"){
					console.status("<font color=\"#ff0000\" size=\"11\">Cant load file: "+_obj.hosts[_obj.host_num]+"/"+_obj.url+"</font>\n");
					try{
						removeChild(auto_tx);
					}catch(er:Error){}
					errTest("Ошибка 1res. \n"+_obj._name+"."+_obj._type+"\n"+_obj.hosts[_obj.host_num]+"/"+_obj.url,int(200));
					return;
				}else if(_data=="security"){
					console.status("<font color=\"#ff0000\" size=\"11\">ERROR state="+_obj.state+" ID="+_st+" hosr="+_obj.hosts[_obj.host_num]+" url="+_obj.url+" Security</font>\n");
				}else if(_data=="io"){
					console.status("<font color=\"#ff0000\" size=\"11\">ERROR state="+_obj.state+" ID="+_st+" hosr="+_obj.hosts[_obj.host_num]+" url="+_obj.url+" IOError</font>\n");
				}else if(_data=="parse"){
					console.status("<font color=\"#ff0000\" size=\"11\"><b>PARSE ERROR</b>  hosr="+_obj.hosts[_obj.host_num]+"  url="+_obj.url+" </font>\n");
				}else{
					console.status("<font color=\"#000000\" size=\"11\"><b>DECRYPT ERROR:</b>  <b>host</b>="+_obj.hosts[_obj.host_num]+"  <b>url</b>="+_obj.url+"  text="+_data.text+"</font>\n");
				}
			}else if(_name=="loaded"){
				console.status("<font color=\"#009900\" size=\"11\">LOAD COMPLETE</font>:[  <b>host</b>="+_obj.hosts[_obj.host_num]+"  <b>url</b>="+_obj.url+"  <b>file_type</b>="+_obj._type+"  <b>file_name</b>="+_obj._name+"  ]\n");
			}else if(_name=="decrypt"){
				if(_data.type=="progress"){
					//console.status("<font color=\"#000000\" size=\"11\"><b>DECRYPT PROGRESS</b>  <b>host</b>="+_obj.hosts[_obj.host_num]+"  <b>url</b>="+_obj.url+"  loaded="+_data.bytesParsed+"/"+_data.bytesTotal+"  code="+_data.code+"  inProcess="+_data.inProcess+"</font>\n");
				}else if(_data.type=="complete"){
					console.status("<font color=\"#000000\" size=\"11\"><b>DECRYPT COMPLETE</b>  <b>host</b>="+_obj.hosts[_obj.host_num]+"  <b>url</b>="+_obj.url+"  loaded="+_data.bytesParsed+"/"+_data.bytesTotal+"</font>\n");
				}
			}else if(_name=="complete"){
				console.status("<font color=\"#009900\" size=\"11\">PARSE COMPLETE</font>("+(_st+1)+"/"+(_res.length)+"):[  <b>host</b>="+_obj.hosts[_obj.host_num]+"  <b>url</b>="+_obj.url+"  <b>file_type</b>="+_obj._type+"  <b>file_name</b>="+_obj._name+"  ]\n");
				_res[_st].f_type=_obj._type;
				_res[_st].f_name=_obj._name;
				_res[_st].data=_data;
				_res[_st].app_dmn=_obj.app_dmn;
				load_c++;
			}else if(_name=="from_cache"){
				
			}
		}
		
		public static var cl_class:Class;
		public static var cl_clip:MovieClip;
		private static var kit:Object={allready:false,func:[]};
		public function get lib():Object{
			return kit;
		}
		public function get res_ready():Boolean{
			return kit["allready"];
		}
		private function allreadyLoaded():void {
			if(load_c==_res.length){
				console.status("<b><font color=\"#009999\" size=\"11\">COMPLETE RESOURCES</font></b>\n");
				removeEventListener(Event.ENTER_FRAME, drawLoadBar);
				removeChild(ldr_cl);
			}else{
				return;
			}
			for(var i:int=0;i<_res.length;i++){
				if(_res[i].f_type=="swf"){
					if(!kit.hasOwnProperty("swf")){
						kit.swf=new Object();
					}
					if(!kit.hasOwnProperty("swf_lib")){
						kit.swf_lib=new Object();
					}
					try{
						var clip:MovieClip=_res[i].data;
					}catch(er:Error){
						console.status("<b><font color=\"#ff0000\" size=\"11\">"+_res[i].f_name+"."+_res[i].f_type+" file is corrupt or has an incorrect format:</font></b> "+er+"\n");
						try{
							removeChild(auto_tx);
						}catch(er:Error){}
						errTest("Ошибка 2.1res. \n"+_res[i].f_name,int(100));
						return;
					}
					//trace(_res[i].f_name+"   "+_res[i].app_dmn);
					kit.swf[_res[i].f_name]=clip;
					kit.swf_lib[_res[i].f_name]=_res[i].app_dmn;
				}else if(_res[i].f_type=="png"){
					if(!kit.hasOwnProperty("png")){
						kit.png=new Object();
					}
					if(!kit.hasOwnProperty("png_lib")){
						kit.png_lib=new Object();
					}
					try{
						var bm:Bitmap=_res[i].data;
					}catch(er:Error){
						console.status("<b><font color=\"#ff0000\" size=\"11\">"+_res[i].f_name+"."+_res[i].f_type+" file is corrupt or has an incorrect format:</font></b> "+er+"\n");
						try{
							removeChild(auto_tx);
						}catch(er:Error){}
						errTest("Ошибка 2.2res. \n"+_res[i].f_name,int(100));
						return;
					}
					kit.png[_res[i].f_name]=bm;
					kit.png_lib[_res[i].f_name]=_res[i].app_dmn;
				}else if(_res[i].f_type=="jpg"){
					if(!kit.hasOwnProperty("jpg")){
						kit.jpg=new Object();
					}
					if(!kit.hasOwnProperty("jpg_lib")){
						kit.jpg_lib=new Object();
					}
					try{
						var bm:Bitmap=_res[i].data;
					}catch(er:Error){
						console.status("<b><font color=\"#ff0000\" size=\"11\">"+_res[i].f_name+"."+_res[i].f_type+" file is corrupt or has an incorrect format:</font></b> "+er+"\n");
						try{
							removeChild(auto_tx);
						}catch(er:Error){}
						errTest("Ошибка 2.3res. \n"+_res[i].f_name,int(100));
						return;
					}
					kit.jpg[_res[i].f_name]=bm;
					kit.jpg_lib[_res[i].f_name]=_res[i].app_dmn;
				}else if(_res[i].f_type=="mp3"){
					if(!kit.hasOwnProperty("mp3")){
						kit.mp3=new Object();
					}
					kit.mp3[_res[i].f_name]=_res[i].data;
					//_res[i].data.play();
				}else if(_res[i].f_type=="xml"){
					if(!kit.hasOwnProperty("xml")){
						kit.xml=new Object();
					}
					kit.xml[_res[i].f_name]=_res[i].data;
					//_res[i].data.play();
				}else if(_res[i].f_type=="txt"){
					if(!kit.hasOwnProperty("txt")){
						kit.txt=new Object();
					}
					kit.txt[_res[i].f_name]=_res[i].data;
					//trace("txt   "+_res[i].f_name+"   "+kit.txt[_res[i].f_name]);
					//_res[i].data.play();
				}
			}
			console.status("<b><font color=\"#009999\" size=\"11\">RESOURCES PARSED</font></b>\n");
			try{
				kit.swf["utils"].init({self:this,self_class:vk_client});
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">utils init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n utils.xlab",int(100));
				return;
			}
			try{
				cl_clip=kit.swf["game_test"];
				cl_class=cl_clip.constructor;
				cl_clip.init_f(par_ar,this);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">utils game error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n game file",int(100));
				return;
			}
			try{
				setfonts(kit.swf_lib["fonts"]);
				setfontCl(kit.swf["fonts"]);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">fonts init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n fonts file",int(100));
				return;
			}
			try{
				lang=kit.xml["lang"];
				text_vars=xFormat.parseVars(lang.child("stat_vars")[0]);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">lang init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n lang file",int(100));
				return;
			}
			
			try{
				cl_class.shop=kit.swf["shop"];
				cl_class.shop.x=0;
				cl_class.shop.y=0;
				try{
					cl_class.shop["fuel_win"].visible=false;
				}catch(e:Error){}
				cl_class.shop["exit"].urlInit(cl_clip,par_ar[11]);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">shop.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n shop.swf file",int(100));
				return;
			}
			try{
				cl_class.panel=kit.swf["dir_panel"];
				cl_clip.px=cl_class.panel.x=609;//603.5
				cl_clip.py=cl_class.panel.y=0;
				cl_class.panel["ammo0"].urlInit(par_ar[11],cl_clip);
				cl_class.panel["waiting_cl"].visible=false;
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">dir_panel.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n dir_panel.swf file",int(100));
				return;
			}
			try{
				cl_class.wind=kit.swf["combat_select"];
				cl_class.wind.x=0;
				cl_class.wind.y=0;
				cl_class.wind["win_cl"].visible=false;
				cl_class.wind["win_cl1"].visible=false;
				cl_class.wind["ready_cl"].visible=false;
				cl_class.wind["wait_cl"].visible=false;
				cl_class.wind["warn_cl"].visible=false;
				cl_class.wind["empt_cl"].visible=false;
				cl_class.wind["diff_win"].visible=false;
				cl_class.wind["group_win"].visible=false;
				cl_class.wind["set_polk"].visible=false;
				cl_class.wind["auto_win"].visible=false;
				cl_class.wind["set_polk"]["vznos_cl"].visible=false;
				cl_class.wind["set_polk"]["ready_win"].visible=false;
				cl_class.wind["a_re_win"].visible=false;
				cl_class.wind["au_gr_win1"].visible=false;
				cl_class.wind["choise_cl"].resetPolkWin();
				cl_class.wind["polk_win"].visible=false;
				cl_class.wind["choise_cl"].rollInit();
				cl_class.wind["choise_cl"].urlInit(par_ar[11],cl_clip);
				cl_class.wind["arena_cl"].visible=false;
				cl_class.wind["arm_name_tx"].text=army_n;
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">combat_select.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n combat_select.swf file",int(100));
				return;
			}
			try{
				cl_class.warn_cl=kit.swf["warn"];
				cl_class.warn_cl.x=304-cl_class.warn_cl["warn_cl"].width/2;
				cl_class.warn_cl.y=232-cl_class.warn_cl["warn_cl"].height/2;
				cl_class.warn_cl["warn_cl"]["close_cl"].m_init(cl_class.warn_cl,cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">warn.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n warn.swf file",int(100));
				return;
			}
			try{
				cl_class.win_cl=kit.swf["Win_wind"];
				cl_class.win_cl["priz_cl"].visible=false;
				cl_class.win_cl.x=304-cl_class.win_cl["win_cl"].width/2;
				cl_class.win_cl.y=232-cl_class.win_cl["win_cl"].height/2;
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">Win_wind.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n Win_wind.swf file",int(100));
				return;
			}
			try{
				cl_class.chat_cl=kit.swf["myChat"];
				cl_class.chat_cl.x=0;//603.5
				cl_class.chat_cl.y=83;
				cl_clip.chx=cl_class.chat_cl.x;
				cl_clip.chy=cl_class.chat_cl.y;
				cl_class.chat_cl.urlInit(par_ar[11],cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">myChat.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n myChat.swf file",int(100));
				return;
			}
			try{
				cl_class.stat_cl=kit.swf["stat"];
				cl_class.stat_cl.x=0;
				cl_class.stat_cl.y=0;
				cl_class.stat_cl["to_game"].visible=false;
				cl_class.stat_cl["ch1"].urlInit(par_ar[11],cl_clip);
				cl_class.stat_cl["ch1"].eventsInit();
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">stat.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n stat.swf file",int(100));
				return;
			}
			try{
				cl_class.svodka_cl=kit.swf["svodka"];
				cl_class.svodka_cl.x=10;
				cl_class.svodka_cl.y=49;
				cl_class.svodka_cl["m_cl"]["closer_cl"].urlInit(par_ar[11],cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">svodka.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n svodka.swf file",int(100));
				return;
			}
			try{
				cl_class.wall_cl=kit.swf["wall"];
				cl_class.wall_cl.x=304-int(cl_class.wall_cl.width/4);
				cl_class.wall_cl.y=232-int(cl_class.wall_cl.height/2);
				cl_class.wall_cl["close_cl"].urlInit(par_ar[11],cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">wall.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n wall.swf file",int(100));
				return;
			}
			try{
				cl_class.games_cl=kit.swf["motor1"];
				cl_class.games_cl.x=0;
				cl_class.games_cl.y=0;
				cl_class.games_cl["ch1"].urlInit(par_ar[11],cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">motor1.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n motor1.swf file",int(100));
				return;
			}
			try{
				cl_class.help_cl=kit.swf["Help_1"];
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">Help_1.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n Help_1.swf file",int(100));
				return;
			}
			try{
				cl_class.opt_cl=kit.swf["properties"];
				cl_class.opt_cl.x=304-int(cl_class.opt_cl.width/2);
				cl_class.opt_cl.y=232-int(cl_class.opt_cl.height/2);
				cl_class.opt_cl["win1"]["close_all"].urlInit(par_ar[11],cl_clip);
				cl_clip.getPorts();
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">properties.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n properties.swf file",int(100));
				return;
			}
			try{
				cl_class.polk_st_cl=kit.swf["reit_polkov"];
				cl_class.polk_st_cl.x=0;
				cl_class.polk_st_cl.y=0;
				cl_class.polk_st_cl["ch1"].urlInit(par_ar[11],cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">reit_polkov.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n reit_polkov.swf file",int(100));
				return;
			}
			try{
				cl_class.vip_cl=kit.swf["vip"];
				cl_class.vip_cl["exit_cl"].urlInit(par_ar[11],cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">vip.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n vip.swf file",int(100));
				return;
			}
			try{
				cl_class.akadem_cl=kit.swf["akademy"];
				cl_class.akadem_cl.x=int(cl_class.wind.width/2-cl_class.akadem_cl.width/2);
				cl_class.akadem_cl.y=int(cl_class.wind.height/2-cl_class.akadem_cl.height/2);
				cl_class.akadem_cl["begin_cl"]["close_cl"].urlInit(par_ar[11],cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">akademy.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n akademy.swf file",int(100));
				return;
			}
			try{
				cl_class.kaskad=kit.swf["map1"];
				cl_class.kaskad["map_win"]["close_cl"].urlInit(par_ar[11],cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">map1.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n map1.swf file",int(100));
				return;
			}
			try{
				cl_class.frst_nws=kit.swf["first_list"];
				cl_class.wind["info_win"].addChildAt(cl_class.frst_nws,0);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">first_list.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n first_list.swf file",int(100));
				return;
			}
			try{
				cl_class.info_help=kit.swf["help"];
				cl_class.info_help.init_f(cl_clip);
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">help.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n help.swf file",int(100));
				return;
			}
			try{
				cl_class.clips_lib =  kit.swf["clips"];
				cl_class.electro_fx = kit.swf_lib["clips"].getDefinition('electro') as Class;
				cl_class.laser_fx =   kit.swf_lib["clips"].getDefinition('laser') as Class;
				cl_class.expl_efx1 =  kit.swf_lib["clips"].getDefinition('exp_efx1') as Class;
				cl_class.emi =        kit.swf_lib["clips"].getDefinition('impuls') as Class;
				cl_class.expld1 =     kit.swf_lib["clips"].getDefinition('explode_1') as Class;
				cl_class.expld2 =     kit.swf_lib["clips"].getDefinition('explode_2') as Class;
				cl_class.expld3 =     kit.swf_lib["clips"].getDefinition('explode_3') as Class;
				cl_class.expld4 =     kit.swf_lib["clips"].getDefinition('explode_4') as Class;
				cl_class.mini_pre =   kit.swf_lib["clips"].getDefinition('preload') as Class;
				cl_class.tral =       kit.swf_lib["clips"].getDefinition('tral_cl') as Class;
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">clips.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n clips.swf file",int(100));
				return;
			}
			try{
				cl_class.p2p_client=kit.swf["autoPhone"];
				try{
					cl_class.p2p_client.init(p2p_name,par_ar[11],cl_clip);
				}catch(er2:Error){
					cl_class.can_p2p=false;
					console.status("<b><font color=\"#ff0000\" size=\"11\">p2p_client load error: "+er2+"</font></b> \n");
				}
			}catch(er:Error){
				console.status("<b><font color=\"#ff0000\" size=\"11\">autoPhone.swf init error:</font></b> "+er+"\n");
				try{
					removeChild(auto_tx);
				}catch(er1:Error){}
				errTest("Ошибка 3res. \n"+er.errorID+"\n autoPhone.swf file",int(100));
				return;
			}
			
			cl_clip.completeInit();
			addChild(cl_clip);
			kit.allready=true;
		}
		
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
		
		public function getURLLoader(_i:int=0,ldr1:Object=null){
			if(_i==0){
				var loader:URLLoader=new URLLoader();
				return loader;
			}else if(_i==1){
				var mpLoader:MultipartURLLoader = new MultipartURLLoader();
				return mpLoader;
			}else{
				var mpLoader1 = MultipartURLLoader(ldr1);
				return mpLoader1;
			}
		}
		
		public function setURLLoader(ldr:URLLoader,req:URLRequest,_i:int=0,ldr1:MultipartURLLoader=null,_s:String=null){
			if(_i==0){
				var loader:URLLoader=ldr;
				loader.load(req);
			}else{
				var loader1:MultipartURLLoader=ldr1;
				loader1.load(_s);
			}
			//return loader;
		}
		
		public var set_mus:Boolean=false;
		public var upl_url:String="";
		public var upl_pict:String="";
		
		private var us_data:Object=new Object();
		
		
		private var re_req:Timer=new Timer(2000,1);
		private var requests:Array=new Array();
		public function re_request(event:TimerEvent):void{
			console.status("<b><font color=\"#333333\" size=\"11\">VK API Timer</font></b>\n");
			if(re_req.running){
				re_req.stop();
			}
			if(requests.length>0){
				for(var i:int=0;i<requests.length;i++){
					if(requests[i]!=null){
						if(requests[i][2]==0){
							_sendRequest(requests[i][0],requests[i][1],i);
							return;
						}
					}
				}
			}
			requests=new Array();
		}
		
		public function _sendRequest(method:String,send_obj:Object=null,_num:int=-1):void{
			if(_num<0){
				requests.push([method,send_obj,0]);
			}
			if(re_req.running){
				return;
			}
			console.status("<b><font color=\"#000000\" size=\"11\">VK API Request:</font></b> "+method+"\n");
			if(_num>=0){
				requests[_num][2]=1;
			}else{
				_num=requests.length-1;
				requests[_num][2]=1;
			}
			var request:URLRequest = new URLRequest();
			request.url ="https://api.vk.com/method/"+method;
			//request.method = URLRequestMethod.GET;
			var variables:URLVariables=new URLVariables();
			if(send_obj!=null){
				for(var _s:String in send_obj){
					variables[_s]=send_obj[_s];
				}
			}
			variables.access_token=par_ar[8];
			request.data = variables;
			var loader:URLLoader=new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			//trace(loader.data);
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
				console.status("<b><font color=\"#ff0000\" size=\"11\">VK API Connect Error:</font></b> "+method+": "+e+"\n");
				if(method=="getProfiles"){
					if(_num>=0){
						requests[_num][2]=0;
						if(!re_req.running){
							re_req.start();
						}
					}
					return;
				}else if(method=="friends.get"){
					if(_num>=0){
						requests[_num][2]=0;
						if(!re_req.running){
							re_req.start();
						}
					}
					return;
				}
			});
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void{
				console.status("<b><font color=\"#ff0000\" size=\"11\">VK API Connect Error:</font></b> "+method+": "+e+"\n");
				if(method=="getProfiles"){
					if(_num>=0){
						requests[_num][2]=0;
						if(!re_req.running){
							re_req.start();
						}
					}
					return;
				}else if(method=="friends.get"){
					if(_num>=0){
						requests[_num][2]=0;
						if(!re_req.running){
							re_req.start();
						}
					}
					return;
				}
			});
			
			loader.addEventListener(Event.COMPLETE, function(e:Event):void{
				var loader:URLLoader = URLLoader(e.target);
				var data:Object = json.JSON.decode(loader.data+"");
				if(data.error){
					console.status("<b><font color=\"#ff0000\" size=\"11\">VK API Error:</font></b> "+method+":\n");
					if(method=="audio.get"){
						if(data.error=="Permission to perform this action is denied by user"){
							set_mus=true;
							VK.callMethod("showSettingsBox", 8);
						}
					}else if(method=="getProfiles"){
						if(_num>=0){
							requests[_num][2]=0;
							if(!re_req.running){
								re_req.start();
							}
						}
					}else if(method=="friends.get"){
						if(_num>=0){
							requests[_num][2]=0;
							if(!re_req.running){
								re_req.start();
							}
						}
					}else{
						
					}
				}else if(data.response){
					console.status("<b><font color=\"#009900\" size=\"11\">VK API Answer:</font></b> "+method+":\n");
					requests[_num]=null;
					requests.splice(_num,1);
					if(method=="audio.get"){
						for(var mz:int=0;mz<data.response.length;mz++){
							cl_clip["pl_songs"].push(new URLRequest(data.response[mz].audio.url));
						}
						if(!cl_clip["pl_rand"]){
							cl_clip.song(0);
						}else{
							cl_clip.song(Math.floor(Math.random()*cl_clip["pl_songs"].length));
						}
					}else if(method=="getProfiles"){
						var us_prof:Object=data.response[0]["user"];
						if(us_prof==null){
							us_prof=data.response[0];
						}
						if(par_ar[2]==Number(us_prof.uid)){
							us_data.was_burn=us_prof.bdate;
							us_data.nick=us_prof.nickname;
							us_data.sex=us_prof.sex;
							us_data.city=us_prof.city;
							us_data.country=us_prof.country;
							us_data.rate=us_prof.rate;
							try{
								us_data.m_phone=us_prof.contacts.mobile_phone;
							}catch(er:Error){
								us_data.m_phone="";
							}
							try{
								us_data.h_phone=us_prof.contacts.home_phone;
							}catch(er:Error){
								us_data.h_phone="";
							}
							try{
								us_data.friends=us_prof.counters.friends;
							}catch(er:Error){
								us_data.friends="";
							}
							us_data.email="";
							/*for(var str:String in us_data){
							trace(str+"="+us_data[str]);
							}*/
							//var myPattern:RegExp =  /"/gi;
							var _s_n:String=(us_prof.first_name+" "+us_prof.last_name);
							var re:RegExp =  /\"/gi;
							_s_n=_s_n.replace(re, "'");
							par_ar[14]=_s_n;
							_link="http://vkontakte.ru/"+us_prof.domain;
							firstInit(par_ar[2],par_ar[14],1);
						}
					}else if(method=="friends.get"){
						
					}else if(method=="photos.getWallUploadServer"){
						//console.status(kit.swf["utils"].traceObject(data,"uploadServer"),1);
						upl_url=data.response.upload_url;
						uploadWall(upl_pct);
					}else if(method=="photos.saveWallPhoto"){
						//console.status(kit.swf["utils"].traceObject(data,"saveWallPhoto"),1);
						saveWall(data.response);
					}else if(method=="wall.post"){
						console.status("<b><font color=\"#009900\" size=\"11\">WALL POST DONE</font></b>\n");
					}else if(method=="wall.getPhotoUploadServer"){
						upl_url=data.response.upload_url;
						uploadWall(upl_pct);
					}else if(method=="wall.savePost"){
						saveWall(data.response.post_hash);
					}else if(method=="getAds"){
						//trace("getAds");
						//trace(data.response+"   "+data.response.length);
						try{
							var arkl:Array=new Array();
							//trace(data.response[r_rand].ad.photo);
							arkl.push(data.response[0].ad.title);
							arkl.push(data.response[0].ad.description);
							arkl.push(data.response[0].ad.link);
							cl_clip.getClass(cl_clip).shop["item_b0_0_0"].Reklame(data.response[0].ad.photo,0,0,arkl);
						}catch(er:Error){}
					}
				}else{
					console.status("<b><font color=\"#009900\" size=\"11\">VK API Unknown:</font></b> "+method+":\n");
				}
			});
			try {
				loader.load(request);
				if(re_req.running){
					re_req.stop();
				}
				re_req.start();
			}catch (error:Error) {
				console.status("<b><font color=\"#ff0000\" size=\"11\">VK API Send Error:</font></b> "+method+": "+error+"\n");
				//wind["info_cl"].showInfo("er2  "+error.message);
				if(_num>=0){
					requests[_num][2]=0;
					if(!re_req.running){
						re_req.start();
					}
				}
			}
		}
		
		public var upl_pct:Bitmap;
		public function uploadWall(pct:Bitmap){
			output("uploadWall\n",1);
			//ExternalInterface.call("uploadSend",upl_pict);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event){
				console.status("<b><font color=\"#009900\" size=\"11\">WALL POST Ready</font></b>\n");
				var _cl:MovieClip=event.currentTarget.content;
				_cl.init(_self,"", pct,upl_url,vk_client);
			});
			//loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(){cl_clip.warn_f(5,"IOError1 ошибка загрузки посредника. \nМедаль.");});
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(){cl_clip.warn_f(5,"Security ошибка загрузки посредника. \nМедаль.");});
      loader.addEventListener(IOErrorEvent.IO_ERROR, function(){cl_clip.warn_f(5,"IOError ошибка загрузки посредника. \nМедаль.");});
			
			if(par_ar[5]==1888415){
				loader.load(new URLRequest("http://cs11433.vkontakte.ru/u68749263/076ecce4f59fed.zip"));    //norm   1888415
			}else if(par_ar[5]==1891834){
				loader.load(new URLRequest("http://cs11433.vkontakte.ru/u68749263/92e8a8dd4fcae0.zip"));    //test   1891834
			}
		}
		
		public function imageForWallUploaded(event:Event):void{
			output("imageForWallUploaded\n",1);
			var loader:URLLoader=(event.target.loader);
			
			//output("data   "+loader.data+"\n",1);
			var data:Object = json.JSON.decode(loader.data);
			
			var _title:String="Медаль: «"+cl_clip["upl_name"]+"»";
			var _text:String="Владелец: "+par_ar[14]+"\n"+cl_clip["upl_mess"];
			data.wall_id=par_ar[2];
			data.message=_title+_text;
			_sendRequest("wall.savePost",data);
		}
		
		public function saveWall(_hash:String):void{
			console.status("<b><font color=\"#009900\" size=\"11\">SAVE WALL PHOTO</font></b>\n");
			VK.callMethod("saveWallPost", _hash);
		}
		
		public static function sendReq(_req:URLRequest){
			trace("sendReq\n");
			//ExternalInterface.call("uploadSend",upl_pict);
			
			var str:String="<query id=\"1\">";
			str+="<action id=\"34\" serv=\""+_self.upl_url+"\"  url_img=\""+_self.upl_pict+"\" />";
			str+="</query>";
			
			_self.clip.getClass(_self.clip).wind["choise_cl"].setSt(-2);
			_self.clip.warn_f(10,"Соединение...");
			
			var rqs:URLRequest=new URLRequest(_self.par_ar[11]+"?query="+1+"&action="+34);
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			var variables:URLVariables = new URLVariables();
			variables.query = new XML(str);
			variables.send = "send";
			for(var s:String in _req){
				//trace(s+"="+_req[s]);
				variables[s]=_req[s];
			}
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, _self.sendEr);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _self.seEr);
			loader.addEventListener(Event.COMPLETE, _self.uploadReady);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
		}
		
		public function uploadReady(event:Event){
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			output("uploadReady   "+str+"\n",1);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				cl_clip.warn_f(5,"Неверный формат полученных данных. \nМедаль.");
				erTestReq(2,7,str);
				return;
			}
			output("list   "+list+"\n",1);
			if(int(list.child("err")[0].attribute("code"))==0){
				cl_clip["upl"][1]=list.child("err")[0].attribute("server");
				cl_clip["upl"][2]=list.child("err")[0].attribute("photo");
				cl_clip["upl"][3]=list.child("err")[0].attribute("hash");
				//_sendImage("wall.savePost",data.server,data.photo,data.hash);
				cl_clip.newMedal(cl_clip["upl"][0]+"",cl_clip["upl"][1]+"",cl_clip["upl"][2]+"",cl_clip["upl"][3]+"");
			}else{
				//trace(list.child("err")[0].attribute("comm"));
				cl_clip.warn_f(5,list.child("err")[0].attribute("comm"));
			}
			try{System.disposeXML(list);}catch(er:Error){}
			cl_clip.warn_f(9,"");
		}
		
		public function showWall(){
			output("showWall\n",1);
			_sendRequest("wall.getPhotoUploadServer");
		}
		
		public function wallImage(){
			//trace("wallImage");
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = true;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeWall);
			var r_req:URLRequest=new URLRequest(upl_pict);
			loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
			loader.load(r_req, loaderContext);
		}
		
		public function completeWall(event: Event): void {
			//var loader:Loader = new Loader();
			//trace(event.currentTarget.content);
			//trace(wall_cl);
			//trace(wall_cl["close_cl"]);
			if(cl_clip["reff"]=="wall_post_inline"){
				cl_class.wall_cl["fr_cl"].visible=false;
			}else{
				
			}
			cl_clip["wall_win"]=true;
			cl_class.wall_cl["close_cl"].newPict(event.currentTarget.content);
			cl_class.wall_cl["name_tx"].text=cl_clip["upl_name"];
			cl_class.wall_cl["m_tx"].text=cl_clip["upl_mess"];
			if(cl_clip["holly"][0]!="no holly"&&cl_clip["holly"][0]!=""){
				cl_class.wall_cl["holly_cl"]["name_tx"].text=cl_clip["holly"][0];
				cl_class.wall_cl["holly_cl"]["tx"].text=cl_clip["holly"][1];
				cl_class.wall_cl["holly_cl"].visible=true;
			}else{
				cl_class.wall_cl["holly_cl"].visible=false;
			}
			cl_clip.addChild(cl_class.wall_cl);
		}
		
		private function unLoadHandler(event:IOErrorEvent):void {
			//errTest("Сервер временно недоступен\n"+event.text,int(600/2));
		}
		
		private function accessError(event:SecurityErrorEvent):void {
			//errTest("Сервер временно недоступен\n"+event.text,int(600/2));
		}
		
		private var send_pl,send_pl1:Boolean=false;
		private var send1,send11:Boolean=false;
		
		private var _prefix:String="";
		private var _link:String="";
		private var _jabb:String="";
		private var _conf:String="";
		private var j_login:String="";
		private var j_pass:String="";
		private var gr_room:String="";
		private var _jport:String="";
		private var _br:String="";
		private var j_log:int=0;
		
		public function get link_group():String{
			return "http://vkontakte.ru/tanks2";
		}
		
		public function get br():int{
			return int(_br);
		}
		
		public function get jport():String{
			return _jport;
		}
		
		public function get root_gr():String{
			return gr_room;
		}
		
		public function get jlogin():String{
			return j_login;
		}
		
		public function get jpass():String{
			return j_pass;
		}
		
		public function get sn_prefix():String{
			return _prefix;
		}
		
		public function get link():String{
			return _link;
		}
		
		public function get jabb():String{
			return _jabb;
		}
		
		public function get conf():String{
			return _conf;
		}
		
		public function get chat_log():int{
			return j_log;
		}
		public function set chat_log(_log:int):void{
			j_log=_log;
			try{
				cl_class.chat_cl.setLog(j_log);
			}catch(er:Error){}
		}
		
		private var p2p_id:String="";
		public function get p2p_name():String{
			return world_id+"_"+j_login.split("_")[1];
		}
		
		public function firstInit(a:String,b:String,_init:int=0,ans:int=0){
				//warn_f(7,"Соединение...");
				if(ans>0){
					if(_init>0){
						send1=false;
						send_pl=false;
					}
					if(send_pl){
						send1=true;
					}
					send_pl=true;
				}else{
					if(_init>0){
						send11=false;
						send_pl1=false;
					}
					if(send_pl1){
						send11=true;
					}
					send_pl1=true;
				}
				
				var rqs:URLRequest=new URLRequest(par_ar[11]+"?query="+100+"&action="+0);
				rqs.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader(rqs);
				var strXML:String="<query id=\"100\" sn_prefix=\""+prfx+"\" sn_id=\""+a+"\" link=\""+_link+"\" sn_name=\""+b+"\" auth_key=\""+par_ar[4]+"\" />";
				//trace(strXML);
				var variables:URLVariables = new URLVariables();
				variables.query = strXML;
				variables.send = "send";
				for(var str:String in us_data){
					//trace(str+"="+us_data[str]);
					variables[str]=us_data[str]
				}
				rqs.data = variables;
				if(ans>0){
					loader.addEventListener(IOErrorEvent.IO_ERROR, sendEr);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, seEr);
					loader.addEventListener(Event.COMPLETE, initReady);
				}else{
					loader.addEventListener(IOErrorEvent.IO_ERROR, sendEr1);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, sendEr1);
				}
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(rqs);
				//errTest(strXML,50);
		}
		
		public function sendEr1(event:Event){
			if(send1){
				try{
					removeChild(auto_tx);
				}catch(er:Error){}
				errTest("Ошибка 2Auth.", 300);
			}else{
				var a_timer:Timer=new Timer(3000,1);
				a_timer.addEventListener(TimerEvent.TIMER_COMPLETE, secd_query1);
				a_timer.start();
			}
		}
		
		public function seEr(event:SecurityErrorEvent){
			if(send1){
				try{
					removeChild(auto_tx);
				}catch(er:Error){}
				errTest("Ошибка 1.1Auth.", 300);
			}else{
				var a_timer:Timer=new Timer(3000,1);
				a_timer.addEventListener(TimerEvent.TIMER_COMPLETE, secd_query);
				a_timer.start();
			}
		}
		
		public function sendEr(event:IOErrorEvent){
			if(send1){
				try{
					removeChild(auto_tx);
				}catch(er:Error){}
				errTest("Ошибка 1Auth.", 300);
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
					removeChild(auto_tx);
				}catch(er:Error){}
				errTest("Ошибка 3Auth.", 300);
				erTestReq(100,0,mstr);
				return;
			}
			//trace("init\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))==0){
					if(j_login==""){
						_prefix=list.child("err")[0].attribute("prefix");
						j_login=list.child("err")[0].attribute("login");
						j_pass=list.child("err")[0].attribute("pass");
						_jabb=list.child("err")[0].attribute("xmpp_host");
						_jport=list.child("err")[0].attribute("xmpp_port");
						_conf=list.child("err")[0].attribute("xmpp_conf_host");
						gr_room=list.child("err")[0].attribute("room");
						_br=list.child("err")[0].attribute("br");
						
						console.init(_self,vk_client);
						/*if(!(stage.loaderInfo.parameters as Object).is_app_user ){
							VK.callMethod("showInstallBox");
						}else{*/
						//loadLang();
						//}
						
						try{
							removeChild(auto_tx);
						}catch(er:Error){}
						
						ldr_cl=new pre_clip();
						ldr_cl.x=375;
						ldr_cl.y=300;
						ldr_cl["bar"].scaleX=1;
						addChild(ldr_cl);
						addEventListener(Event.ENTER_FRAME, drawLoadBar);
						for(var i:int=0;i<_res.length;i++){
							startLoad(_res[i].url+"?"+_res[i].vers,this,_urls,null,loadEvents,[i]);
						}
					}
				}else{
					if(send1){
						try{
							removeChild(auto_tx);
						}catch(er:Error){}
						errTest("Ошибка 4Auth.\n"+list.child("err")[0].attribute("comm"), 300);
					}else{
						var a_timer:Timer=new Timer(3000,1);
						a_timer.addEventListener(TimerEvent.TIMER_COMPLETE, secd_query);
						a_timer.start();
					}
				}
			}catch(er:Error){
				try{
					removeChild(auto_tx);
				}catch(er:Error){}
				errTest("Ошибка 5Auth.", 300);
				erTestReq(100,0,mstr);
				return;
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
			firstInit(par_ar[2],par_ar[14],0,1);
		}
		
		public function secd_query1(event:TimerEvent){
			firstInit(par_ar[2],par_ar[14]);
		}
		
	}
}
