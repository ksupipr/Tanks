package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;
  import flash.net.*;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.*;
	import flash.xml.*;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	
	public class map_btn extends MovieClip{
		
		public static var stg_cl:MovieClip;
		public static var stg_class:Class;
		public static var serv_url:String="";
		
		public function urlInit(url:String,cl:MovieClip){
			serv_url=url;
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public static var _timer:Timer=new Timer(40,25*30);
		
		public function map_btn(){
			super();
			Security.allowDomain("*");
			stop();
			if(name=="list_vkl2"){
				visible=false;
				_timer.addEventListener(TimerEvent.TIMER, timeCount);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timeReady);
			}
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
		}
		
		public function timeCount(event:TimerEvent){
			root["map_win"]["fill"].graphics.clear();
			root["map_win"]["fill"].graphics.beginFill(0xC0351D);
			root["map_win"]["fill"].graphics.drawRect(0,0,_timer.currentCount/_timer.repeatCount*195,8);
		}
		
		public function timeReady(event:TimerEvent){
			root["map_win"]["fill"].graphics.clear();
			var id_str:String="<query id=\"3\"><action id=\"11\">";
			id_str+="<battle id=\""+root["map_win"]["battle_go"]["ID"]+"\" />";
			id_str+="</action></query>";
			sendCombats(id_str,true,0);
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}else if(stg_cl["wall_win"]){
				return;
			}else if(currentFrameLabel=="empty"){
				return;
			}
			Mouse.cursor=MouseCursor.BUTTON;
			try{
				gotoAndStop("over");
			}catch(er:Error){}
		}
		
		public function m_out(event:MouseEvent){
			Mouse.cursor=MouseCursor.AUTO;
			if(currentFrameLabel=="empty"){
				return;
			}
			try{
				gotoAndStop("out");
			}catch(er:Error){}
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}else if(stg_cl["wall_win"]){
				return;
			}else if(currentFrameLabel=="empty"){
				return;
			}
			try{
				gotoAndStop("press");
			}catch(er:Error){}
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}else if(stg_cl["wall_win"]){
				return;
			}else if(currentFrameLabel=="empty"){
				return;
			}
			if(name.slice(0,2)=="go"){
				var id_str:String="<query id=\"3\"><action id=\"13\">";
				id_str+="<battle id=\""+event.currentTarget["id"]+"\" />";
				id_str+="</action></query>";
				sendCombats(id_str,true,1);
			}else if(name=="battle_go"){
				var id_str:String="<query id=\"3\"><action id=\"11\">";
				id_str+="<battle id=\""+event.currentTarget["ID"]+"\" />";
				id_str+="</action></query>";
				sendCombats(id_str,true,0);
			}else if(name=="close_cl"||name=="exit_cl"){
				if(root["map_win"]["map_cl"]._type==1){
					if(root["map_win"]["map_cl"]._ep!=1){
						root["map_win"]["warn_cl"].visible=true;
					}else{
						stg_cl.createMode(1);
						root["map_win"]["close_cl"].sendRequest(["query","action"],[["id"],["id"]],[["3"],["10"]]);
					}
				}
			}else if(name=="out_yes"){
				stg_cl.createMode(1);
				root["map_win"]["close_cl"].sendRequest(["query","action"],[["id"],["id"]],[["3"],["10"]]);
			}else if(name=="out_no"){
				root["map_win"]["warn_cl"].visible=false;
			}else if(name=="inst_out"){
				stg_cl.createMode(1);
				//root["map_win"]["close_cl"].sendRequest(["query","action"],[["id"],["id"]],[["3"],["10"]]);
			}
			try{
				gotoAndStop("over");
			}catch(er:Error){}
		}
		
		public function sendCombats(strXML:String, vis:Boolean, tst:int){
			stopTimer();
			var rqs:URLRequest;
			if(tst==0){
				rqs=new URLRequest(serv_url+"?query="+3+"&action="+11);
			}else if(tst==1){
				rqs=new URLRequest(serv_url+"?query="+3+"&action="+13);
			}
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			var list:XML;
			list=new XML(strXML);
			////trace("send "+list);
			if(tst==0){
				loader.addEventListener(Event.COMPLETE, addBattle);
			}else if(tst==1){
				loader.addEventListener(Event.COMPLETE, addMission);
			}
			var variables:URLVariables = new URLVariables();
			variables.query = list;
			variables.send = "send";
			//trace("sendCombats "+list);
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			if(vis){
				stg_cl.warn_f(10,"");
			}
			loader.load(rqs);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function sendRequest(names:Array, attr:Array, idies:Array, _i:int=0){
			var b:int=0;
			var rqs:URLRequest=new URLRequest(serv_url+"?query="+idies[0][0]+"&action="+idies[1][0]);
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			var list:XML;
			var strXML:String="";
			if(names.length==2){
				strXML+="<"+names[0];
				for(var i:int=0;i<attr[0].length;i++){
					strXML+=" "+attr[0][i]+"=\""+idies[0][i]+"\"";
				}
				strXML+=">";
				strXML+="<"+names[1];
				for(var i:int=0;i<attr[1].length;i++){
					strXML+=" "+attr[1][i]+"=\""+idies[1][i]+"\"";
				}
				strXML+="/>";
				strXML+="</"+names[0]+">";
				if(int(idies[0][0])==3){
					if(int(idies[1][0])==10){
						loader.addEventListener(Event.COMPLETE, list_battles);
					}
				}
			}else if(names.length==3){
				strXML+="<"+names[0];
				for(var i:int=0;i<attr[0].length;i++){
					strXML+=" "+attr[0][i]+"=\""+idies[0][i]+"\"";
				}
				strXML+=">";
				strXML+="<"+names[1];
				for(var i:int=0;i<attr[1].length;i++){
					strXML+=" "+attr[1][i]+"=\""+idies[1][i]+"\"";
				}
				strXML+=">";
				strXML+="<"+names[2];
				for(var i:int=0;i<attr[2].length;i++){
					strXML+=" "+attr[2][i]+"=\""+idies[2][i]+"\"";
				}
				strXML+="/>";
				strXML+="</"+names[1]+">";
				strXML+="</"+names[0]+">";
				/*if(int(idies[1][0])==2){
					loader.addEventListener(Event.COMPLETE, addCombat);
				}*/
			}
			////trace(int(idies[1][0]));
			////trace("str\n"+strXML);
			list=new XML(strXML);
			//trace("s_xml\n"+list+"\n");
			var variables:URLVariables = new URLVariables();
			variables.query = list;
			variables.send = "send";
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			//trace("variables");
			//trace(variables);
			if(b==0){
				stg_cl.warn_f(10,"");
			}else if(b==2){
				stg_cl.warn_f(14,"");
			}
			loader.load(rqs);
			try{System.disposeXML(list);}catch(er:Error){}
		}
	
		public function onError(event:IOErrorEvent):void{
			//trace("Select+php2: "+event);
			stg_cl.warn_f(4,"Каскадные бои.");
		}
		
		public function addBattle(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("addMission   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВступление в бой.");
				stg_cl.erTestReq(3,13,str);
				return;
			}
			
			//trace("addMission\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			//stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function addMission(event:*):void{
			var str:String;
			if(event.constructor == Event){
				str="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			}else{
				str=event;
			}
			//trace("addMission   "+event.constructor+"\n"+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВыбор миссии.");
				stg_cl.erTestReq(3,11,str);
				return;
			}
			
			//trace("addMission\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			stopTimer();
			try{
				root["map_win"]["map_cl"].removeChild(root["map_win"]["map_cl"].clip);
			}catch(er:Error){}
			root["map_win"]["name_tx"].text=list.child("battle")[0].attribute("name");
			root["map_win"]["type_tx"].text=["","Прохождение","Исследование"][int(list.child("battle")[0].attribute("type"))];
			root["map_win"]["ep_tx"].text=list.child("battle")[0].attribute("ep_num");
			root["map_win"]["ep_name"].text=list.child("battle")[0].attribute("ep_name");
			root["map_win"]["cmd_tx"].text="";
			for(var i:int=0;i<list.child("battle")[0].child("targets")[0].child("target").length();i++){
				root["map_win"]["cmd_tx"].text+=list.child("battle")[0].child("targets")[0].child("target")[i].attribute("text")+"\n";
			}
			root["map_win"]["is_m_tx"].text=list.child("battle")[0].attribute("money_i");
			root["map_win"]["m_z_tx"].text=list.child("battle")[0].attribute("money_z");
			root["map_win"]["m_m_tx"].text=list.child("battle")[0].attribute("money_m");
			root["map_win"]["battle_go"].ID=list.child("battle")[0].attribute("id");
			
			root["map_win"]["map_cl"]._type=int(list.child("battle")[0].attribute("type"));
			root["map_win"]["map_cl"]._ep=int(root["map_win"]["ep_tx"].text);
			root["map_win"].visible=true;
			root["list_win"].visible=false;
			if(int(root["map_win"]["ep_tx"].text)>1){
				_timer.start();
			}
			LoadMap(stg_class.res_url+"/"+list.child("battle")[0].attribute("map"));
			root["map_win"]["warn_cl"].visible=false;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		private var map_loader:Loader;
		
		public function LoadMap(ur:String){
			try{
				map_loader.close();
			}catch(er:Error){}
			map_loader = new Loader();
			map_loader.contentLoaderInfo.addEventListener(Event.OPEN, openMap );
			map_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressMap);
			map_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeMap);
			map_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, er_map);
			map_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, er_map);
      map_loader.addEventListener(IOErrorEvent.IO_ERROR, er_map);
			
			map_loader.load(new URLRequest(ur));
		}
		
		public function openMap(event:Event):void{
			var _tx:TextField=new TextField();
			_tx.text="Загрузка...";
			_tx.width=_tx.textWidth+5;
			_tx.height=_tx.textHeight+5;
			_tx.textColor=0xffffff;
			var _bmd:BitmapData=new BitmapData(_tx.width, _tx.height, true, 0x00FFFFFF);
			_bmd.draw(_tx);
			var mtrx:Matrix = new Matrix();
  		mtrx.translate(376/2-_bmd.width/2,272/2-_bmd.height/2);
			root["map_win"]["map_cl"].graphics.clear();
			root["map_win"]["map_cl"].graphics.beginBitmapFill(_bmd,mtrx,false);
			root["map_win"]["map_cl"].graphics.drawRect(0, 0, 376, 272);
      root["map_win"]["map_cl"].graphics.endFill();
		}
		
		public function progressMap(event:ProgressEvent):void{
			root["map_win"]["map_cl"].graphics.clear();
			root["map_win"]["map_cl"].graphics.lineStyle(1,0x000033);
			root["map_win"]["map_cl"].graphics.beginFill(0x0066CC,0);
			root["map_win"]["map_cl"].graphics.drawRect(376/2-50,272/2-2,100,5);
			root["map_win"]["map_cl"].graphics.beginFill(0x0066CC,1);
			root["map_win"]["map_cl"].graphics.lineStyle(1,0x0066CC);
			root["map_win"]["map_cl"].graphics.drawRect(376/2-50,272/2-2,(event.bytesLoaded/event.bytesTotal)*100,5);
		}
		
		public function completeMap(event:Event):void{
			root["map_win"]["map_cl"].graphics.clear();
			root["map_win"]["map_cl"].clip=event.currentTarget.content;
			root["map_win"]["map_cl"].addChild(root["map_win"]["map_cl"].clip);
			if(root["map_win"]["map_cl"]._type==1){
				for(var i:int=0;i<25;i++){
					if(root["map_win"]["map_cl"].clip["ter"+i]!=null){
						if(i<root["map_win"]["map_cl"]._ep-1){
							var color_cl:ColorTransform=new ColorTransform();
							color_cl.color=0xB5FEA5;
							root["map_win"]["map_cl"].clip["ter"+i].transform.colorTransform = color_cl;
							root["map_win"]["map_cl"].clip["front"+i].visible=true;
						}else if(i==root["map_win"]["map_cl"]._ep-1){
							var color_cl:ColorTransform=new ColorTransform();
							color_cl.color=0xFF9933;
							root["map_win"]["map_cl"].clip["ter"+i].transform.colorTransform = color_cl;
							root["map_win"]["map_cl"].clip["front"+i].visible=true;
						}else{
							var color_cl:ColorTransform=new ColorTransform();
							color_cl.color=0xEAC195;
							root["map_win"]["map_cl"].clip["ter"+i].transform.colorTransform = color_cl;
							root["map_win"]["map_cl"].clip["front"+i].visible=false;
						}
					}else{
						break;
					}
				}
			}
		}
		
		public function er_map(event:Event):void{
			//trace("Er   "+event);
			var _tx:TextField=new TextField();
			_tx.text="Ошибка...";
			_tx.width=_tx.textWidth+5;
			_tx.height=_tx.textHeight+5;
			_tx.textColor=0xff0000;
			var _bmd:BitmapData=new BitmapData(_tx.width, _tx.height, true, 0x00FFFFFF);
			_bmd.draw(_tx);
			var mtrx:Matrix = new Matrix();
  		mtrx.translate(376/2-_bmd.width/2,272/2-_bmd.height/2);
			root["map_win"]["map_cl"].graphics.clear();
			root["map_win"]["map_cl"].graphics.beginBitmapFill(_bmd,mtrx,false);
			root["map_win"]["map_cl"].graphics.drawRect(0, 0, 376, 272);
      root["map_win"]["map_cl"].graphics.endFill();
		}
		
		public function list_battles(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nСписок сценариев.");
				stg_cl.erTestReq(3,10,str);
				return;
			}
			
			//trace("list_battles\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			stopTimer();
			var s1:String="battles";
			var s2:String="battle";
			di_id=[new Array(),new Array(),new Array()];
			di_tx=[new Array(),new Array(),new Array()];
			di_hide=[new Array(),new Array(),new Array()];
			stg_class.wind["empt_cl"].visible=false;
			if(int(list.child(s1)[0].attribute("fuel"))<int(list.child(s1)[0].attribute("fuel_need"))){
				stg_cl.createMode(1);
				stg_class.wind["warn_cl"].visible=true;
				stg_class.wind["win_cl"].visible=false;
				stg_class.wind["win_cl1"].visible=false;
				stg_class.wind["ready_cl"].visible=false;
				stg_class.wind["wait_cl"].visible=false;
				stg_class.wind["warn_cl"].visible=true;
				stg_class.wind["empt_cl"].visible=false;
				stg_class.wind["diff_win"].visible=false;
				stg_class.wind["arena_cl"].visible=false;
				stg_cl.warn_f(9,"");
				return;
			}
			
			for(var i:int=0;i<13;i++){
				root["list_win"]["go"+i].visible=false;
				root["list_win"]["tx"+i].visible=false;
			}
			root["map_win"].visible=false;
			root["list_win"].visible=true;
			var diff_lev:int=0;
			for(var i:int=0;i<list.child(s1)[0].child(s2).length();i++){
				di_id[0].push(list.child(s1)[0].child(s2)[i].attribute("id"));
				di_tx[0].push(list.child(s1)[0].child(s2)[i].attribute("name"));
				di_hide[0].push(list.child(s1)[0].child(s2)[i].attribute("hidden"));
			}
			for(var i:int=0;i<di_id.length;i++){
				if(di_id[i].length>0){
					root["list_win"]["list_vkl"+i].visible=true;
					root["list_win"]["list_vkl"+i].gotoAndStop("out");
					if(diff_lev==0){
						root["list_win"]["list_vkl"+i].gotoAndStop("empty");
						root["list_win"]["scroll_cl"]["sc"].y=root["list_win"]["scroll_cl"]["rect"].y;
						di_cnt=0;
						di_type=i;
						drawDiff();
						root["list_win"].visible=true;
						diff_lev=1;
					}
				}else{
					root["list_win"]["list_vkl"+i].visible=false;
				}
			}
			if(stg_class.kaskad.stage==null){
				stg_cl.createMode(9);
			}
					
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var di_id:Array=new Array();
		public static var di_tx:Array=new Array();
		public static var di_hide:Array=new Array();
		public static var di_type:int=0;
		public static var di_cnt:int=0;
		
		public function drawDiff(){
			//trace(di_cnt+"   "+di_type+"   "+di_id[di_type].length);
			try{
				for(var i:int=0;i<13;i++){
					if(i+di_cnt<di_id[di_type].length){
						root["list_win"]["tx"+i].visible=true;
						root["list_win"]["go"+i].visible=true;
						root["list_win"]["go"+i]["id"]=di_id[di_type][i+di_cnt];
						if(int(di_hide[di_type][i+di_cnt])!=0||int(di_id[di_type][i+di_cnt])==0){
							root["list_win"]["go"+i].gotoAndStop("empty");
						}else{
							root["list_win"]["go"+i].gotoAndStop("out");
						}
						root["list_win"]["tx"+i].text=di_tx[di_type][i+di_cnt];
					}else{
						root["list_win"]["go"+i].visible=false;
						root["list_win"]["tx"+i].visible=false;
					}
				}
			}catch(er:Error){
				
			}
		}
		
		public function stopTimer(){
			try{
				_timer.reset();
			}catch(er:Error){}
			root["map_win"]["fill"].graphics.clear();
		}
		
	}
}
