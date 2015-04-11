package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.system.System;
	import flash.text.StyleSheet;
	
	public class info extends MovieClip{
		
		public static var _self:MovieClip;
		public static var stg_cl:MovieClip;
		public static var stg_class:Class;
		private var list_ar:Array=new Array();
		private var sheet:StyleSheet = new StyleSheet();
		
		public function init_f(cl:MovieClip){
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
			root["exit_cl"].init_f(stg_cl);
			root["exit_cl"].setParCl(this);
			newCss();
		}
		
		public function info(){
			super();
			stop();
			Security.allowDomain("*");
			_self=this;
			
			root["info_win"]["sc_mess"]["sc_rect"].graphics.clear();
			root["info_win"]["sc_mess"]["sc_rect"].graphics.lineStyle(1,0x9A0700);
			root["info_win"]["sc_mess"]["sc_rect"].graphics.beginFill(0xFCE3C5);
			root["info_win"]["sc_mess"]["sc_rect"].graphics.drawRect(root["info_win"]["sc_mess"]["to_left"].width+2,1,410-(root["info_win"]["sc_mess"]["to_left"].width*2+3),root["info_win"]["sc_mess"]["to_left"].height-1);
			root["info_win"]["sc_mess"]["to_right"].x=root["info_win"]["sc_mess"]["sc_rect"].width+root["info_win"]["sc_mess"]["to_right"].width*2+3;
			
			root["list_win"].scrollRect=new Rectangle(0,0,root["list_win"].width,root["list_win"].height);
			root["info_win"]["info_cl"]["info_tx"].addEventListener(TextEvent.LINK, clickText);
			list_reset();
		}
		
		public function newCss(){
			var rqs:URLRequest=new URLRequest(stg_class.res_url+"/res/help.css?"+stg_cl["link_ver"]+Math.random());
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			loader.addEventListener(IOErrorEvent.IO_ERROR, se12ndEr);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, se12Er);
			loader.addEventListener(Event.COMPLETE, cssReady);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
			//errTest(strXML,50);
		}
		
		public function cssReady(event:Event):void {
			sheet.parseCSS(event.target.data);
			root["info_win"]["info_cl"]["info_tx"].styleSheet = sheet;
			newList();
		}
		
		public function newList(){
			var rqs:URLRequest=new URLRequest(stg_class.res_url+"/res/help.xml?"+stg_cl["link_ver"]+Math.random());
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			loader.addEventListener(IOErrorEvent.IO_ERROR, se12ndEr);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, se12Er);
			loader.addEventListener(Event.COMPLETE, listReady);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
			//errTest(strXML,50);
		}
		
		public function se12Er(event:SecurityErrorEvent){
			stg_cl.warn_f(3,"Info");
		}
		
		public function se12ndEr(event:IOErrorEvent){
			stg_cl.warn_f(4,"Info\n"+event.text);
		}
		
		public function listReady(event:Event){
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("list str\n"+str);
			try{
				var list:XML=new XML(str);
				list=list.child("list")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nInfo.");
				return;
			}
			//trace("list xml\n"+list);
			//XML.prettyPrinting=false;
			list_ar=new Array();
			for(var i=0;i<list.child("punkt").length();i++){
				list_ar[i]=new Array();
				list_ar[i][1]=new Array();
				list_ar[i][0]=list.child("punkt")[i].attribute("name");
				if(list.child("punkt")[i].child("pod_punkt").length()>0){
					for(var j=0;j<list.child("punkt")[i].child("pod_punkt").length();j++){
						list_ar[i][1][j]=new Array();
						list_ar[i][1][j][0]=list.child("punkt")[i].child("pod_punkt")[j].attribute("name");
						var _xml:XML=list.child("punkt")[i].child("pod_punkt")[j];
						//_xml.prettyPrinting=false;
						list_ar[i][1][j][1]=_xml+"";
						list_ar[i][1][j][1]=new_line_f(list_ar[i][1][j][1]);
					}
				}else{
					var _xml:XML=list.child("punkt")[i];
					//_xml.prettyPrinting=false;
					list_ar[i][2]=_xml+"";
					list_ar[i][2]=new_line_f(list_ar[i][2]);
				}
			}
			drawList();
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function drawList(_num:int=-1,_pod:int=-1){
			list_reset();
			var Y:Number=21.5;
			for(var i=0;i<list_ar.length;i++){
				var cl:MovieClip=new punkt();
				cl.name="punkt"+i;
				cl["name_tx"].text=list_ar[i][0];
				cl["back_cl"].gotoAndStop(1);
				cl.y=Y;
				cl.x=.5;
				Y+=14;
				root["list_win"].addChild(cl);
				list_ar[i][3]=cl;
				if(list_ar[i][1].length>0){
					cl["open_btn"].visible=true;
					if(_num==i){
						drawInfo("Для просмотра справки, выберите интересующую ВАС категорию в содержании (левая колонка)!");
						cl["back_cl"].gotoAndStop(3);
						cl["name_tx"].textColor=0xffffff;
						cl["name_tx"].x=cl["open_btn"].x;
						for(var j=0;j<list_ar[i][1].length;j++){
							var _cl:MovieClip=new punkt();
							_cl.name="podpunkt_"+i+"_"+j;
							_cl["name_tx"].text=list_ar[i][1][j][0];
							_cl["back_cl"].gotoAndStop(1);
							_cl["open_btn"].visible=false;
							_cl.y=Y;
							_cl.x=.5;
							Y+=14;
							root["list_win"].addChild(_cl);
							list_ar[i][1][j][3]=_cl;
							if(_pod==j){
								cl["back_cl"].gotoAndStop(1);
								_cl["back_cl"].gotoAndStop(3);
								cl["name_tx"].textColor=0x009900;
								_cl["name_tx"].textColor=0xffffff;
								drawInfo(list_ar[i][1][j][1]);
							}
						}
						cl["open_btn"].visible=false;
					}
				}else{
					cl["open_btn"].visible=false;
					cl["name_tx"].x=cl["open_btn"].x;
					if(_num==i){
						cl["back_cl"].gotoAndStop(3);
						cl["name_tx"].textColor=0xffffff;
						drawInfo(list_ar[i][2]);
					}
				}
			}
		}
		
		public static var myPattern:RegExp =  /\r\n/gi;
		public static var myPattern1:RegExp = /\r\r/gi;
		public static var myPattern2:RegExp = /\n\n/gi;
		public static var myPattern3:RegExp = /\n\r/gi;
		public static var myPattern4:RegExp = /\\n/gi;
		public static var myPattern5:RegExp = /\n  </gi;
		public static var myPattern6:RegExp = /~\n  </gi;
		public static var myPattern7:RegExp = />\n  ~/gi;
		public static var myPattern8:RegExp = /~~\n  </gi;
		public static var myPattern9:RegExp = /~\s*</gi;
		public static var myPattern10:RegExp = />\s*~/gi;
		
		public function new_line_f(_s:String):String{
			var _text:String=_s;
			//trace(_s);
			_text=_text.substr(_text.search(">")+1);
			_text=_text.replace("</punkt>", "");
			//trace(_text);
			_text=_text.replace(myPattern9, "<");
			_text=_text.replace(myPattern10, ">");
			_text=_text.replace(myPattern, "\n");
			_text=_text.replace(myPattern1, "\n");
			_text=_text.replace(myPattern2, "\n");
			_text=_text.replace(myPattern3, "\n");
			//trace(_text);
			while(_text.charAt(0).search(/\s/gi)>=0){
				_text=_text.substr(1);
			}
			return _text;
		}
		
		public function drawInfo(_str:String){
			root["info_win"]["info_cl"]["info_tx"].htmlText=_str;
			root["info_win"]["info_cl"]["info_tx"].height=root["info_win"]["info_cl"]["info_tx"].textHeight+5;
			if(root["info_win"]["info_cl"]["info_tx"].height>410){
				root["info_win"]["info_cl"]["info_tx"].height=410;
			}
			/*var gr:Graphics=root["info_win"]["info_cl"].graphics;
			gr.clear();
			gr.beginFill(0x999999);
			gr.drawRect(0,1,381,root["info_win"]["info_cl"]["info_tx"].height+3);*/
			//trace(root["info_win"]["info_cl"]["info_tx"].height+"   "+root["info_win"]["info_cl"]["info_tx"].textHeight);
			try{
				root["info_win"]["info_cl"]["info_tx"].addEventListener(Event.SCROLL, scrollMess);
			}catch(er:Error){}
			
			var _w:int=(root["info_win"]["info_cl"]["info_tx"].height/root["info_win"]["info_cl"]["info_tx"].textHeight)*(root["info_win"]["sc_mess"]["sc_rect"].width-4);
			if(_w<9){
				_w=9;
			}
			if(_w<root["info_win"]["sc_mess"]["sc_rect"].width-4){
				root["info_win"]["info_cl"]["info_tx"].width=mess_w-root["info_win"]["sc_mess"].width-2;
				_w=(root["info_win"]["info_cl"]["info_tx"].height/root["info_win"]["info_cl"]["info_tx"].textHeight)*(root["info_win"]["sc_mess"]["sc_rect"].width-4);
				if(_w<9){
					_w=9;
				}
				root["info_win"]["sc_mess"].visible=true;
				root["info_win"]["sc_mess"]["sc_mover"]["sc_fill"].graphics.clear();
				root["info_win"]["sc_mess"]["sc_mover"]["sc_fill"].graphics.beginFill(0x990000);
				root["info_win"]["sc_mess"]["sc_mover"]["sc_fill"].graphics.drawRect(0,2,_w,11);
				root["info_win"]["sc_mess"]["sc_mover"]["sc_zn"].x=Math.round(_w/2)-.5;
				/*if(_b==1){
					root["info_win"]["sc_mess"]["sc_mover"].x=int(((root["info_win"]["info_cl"]["info_tx"].scrollV-1)/(root["info_win"]["info_cl"]["info_tx"].maxScrollV-1))*(root["info_win"]["sc_mess"]["sc_rect"].width-(root["info_win"]["sc_mess"]["sc_mover"].width+3))+root["info_win"]["sc_mess"]["to_left"].width+3);
					if(root["info_win"]["sc_mess"]["sc_mover"].x<root["info_win"]["sc_mess"]["to_left"].width+4){
						root["info_win"]["sc_mess"]["sc_mover"].x=root["info_win"]["sc_mess"]["to_left"].width+4;
					}else if(root["info_win"]["sc_mess"]["sc_mover"].x+root["info_win"]["sc_mess"]["sc_mover"].width>root["info_win"]["sc_mess"].height-root["info_win"]["sc_mess"]["to_left"].width-2){
						root["info_win"]["sc_mess"]["sc_mover"].x=root["info_win"]["sc_mess"].height-root["info_win"]["sc_mess"]["to_left"].width-root["info_win"]["sc_mess"]["sc_mover"].width-2;
					}
				}*/
				root["info_win"]["info_cl"]["info_tx"].addEventListener(Event.SCROLL, scrollMess);
			}else{
				root["info_win"]["info_cl"]["info_tx"].width=mess_w;
				root["info_win"]["sc_mess"].visible=false;
			}
		}
		
		private var mess_w:int=363;
		
		public function moveMessText(X:Number){
			root["info_win"]["info_cl"]["info_tx"].scrollV=((X-root["info_win"]["sc_mess"]["to_left"].width-4)/(root["info_win"]["sc_mess"]["sc_rect"].width-root["info_win"]["sc_mess"]["sc_mover"].width))*root["info_win"]["info_cl"]["info_tx"].numLines;
		}
		
		private function scrollMess(event:Event){
			//trace(event.currentTarget.scrollV);
			if(root["info_win"]["sc_mess"]["sc_mover"].x_coor!=null){
				return;
			}
			//trace((root["info_win"]["info_cl"]["info_tx"].scrollV));
			root["info_win"]["sc_mess"]["sc_mover"].x=int(((root["info_win"]["info_cl"]["info_tx"].scrollV-1)/(root["info_win"]["info_cl"]["info_tx"].maxScrollV-1))*(root["info_win"]["sc_mess"]["sc_rect"].width-(root["info_win"]["sc_mess"]["sc_mover"].width+3))+root["info_win"]["sc_mess"]["to_left"].width+3);
			if(root["info_win"]["sc_mess"]["sc_mover"].x<root["info_win"]["sc_mess"]["to_left"].width+4){
				root["info_win"]["sc_mess"]["sc_mover"].x=root["info_win"]["sc_mess"]["to_left"].width+4;
				//trace("a");
			}else if(root["info_win"]["sc_mess"]["sc_mover"].x+root["info_win"]["sc_mess"]["sc_mover"].width>root["info_win"]["sc_mess"].height-root["info_win"]["sc_mess"]["to_left"].width-2){
				root["info_win"]["sc_mess"]["sc_mover"].x=root["info_win"]["sc_mess"].height-root["info_win"]["sc_mess"]["to_left"].width-root["info_win"]["sc_mess"]["sc_mover"].width-2;
			}
		}
		
		public function list_reset(_num:int=-1){
			for(var i=0;i<list_ar.length;i++){
				try{
					root["list_win"].removeChild(list_ar[i][3]);
				}catch(er:Error){}
				if(list_ar[i][1].length>0){
					for(var j=0;j<list_ar[i][1].length;j++){
						try{
							root["list_win"].removeChild(list_ar[i][1][j][3]);
						}catch(er:Error){}
					}
				}
			}
			drawInfo("<p align=\""+"center"+"\">Для просмотра справки, выберите интересующую ВАС категорию в содержании (левая колонка)!</p>");
		}
		
		private function clickText(event:TextEvent):void{
			var _ar:Array=event.text.split(',');
			if(int(_ar[0])==0){
				stg_cl.createMode(int(_ar[1]));
			}else if(int(_ar[0])==1){
				drawList(int(_ar[1])-1,int(_ar[2])-1);
			}
		}
		
	}
	
}
