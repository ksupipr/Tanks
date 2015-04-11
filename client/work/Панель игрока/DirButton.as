package{
	
	//import flash.media.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.net.*;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	//[SWF(width="800", height="600", frameRate="40")]
	public class DirButton extends MovieClip{
		
		public var clip:MovieClip;
		public static var stg_cl:MovieClip;
		public static var serv_url:String="empty";
		public static var stg_class:Class;
		public static var loads:Array=new Array();
		
		public static var lev_tx:String="";
		public static var lev_s:int=0;
		public static var lev_m:int=0;
		public static var mz:int=0;
		
		public var quantity:int=0;
		
		public var cd_time:int=100;
		public var cd_left:int=0;
		public var wait1:int=0;
		
		public var cd_now:Boolean=false;
		
		public static var clips:Array=new Array();
		public static var air_time:int=(3*60);
		public static var air_left:int=0;
		public static var lev_time:int=(7*60);
		public static var lev_left:int=0;
		
		public static var myPattern:RegExp =  /\r\n/gi;
		public static var myPattern1:RegExp = /\r\r/gi;
		public static var myPattern2:RegExp = /\n\n/gi;
		public static var myPattern3:RegExp = /\n\r/gi;
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
		
		public function urlInit(url:String,cl:MovieClip){
			serv_url=url;
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
			for(var i:int=0;i<6;i++){
				root["ammo_tx"+i].mouseEnabled=false;
				root["patron"+i].gotoAndStop(i+1);
			}
		}
		
		public function LoadImage(ur:String){
			var _this:MovieClip=this;
			//trace("c   "+_this["name"]+"   "+_this["empty"]+"   "+ur);
			try{
				clearTimeout(_this.stm);
			}catch(er:Error){}
			try{
				_this._ldr.close();
			}catch(er:Error){}
			
			if(loads.length>0){
				if(loads[0][0].ID==0){
					try{
						_this.removeChild(_this["pre_cl"]);
					}catch(er:Error){}
					loads.shift();
					if(loads.length>0){
						loads[0][0].LoadImage(loads[0][1]);
					}
					return;
				}
			}
			
			if(stg_class.pict_links.hasOwnProperty(ur.split("/").join("_"))){
				//trace("in cache   "+ur);
				try{
					_this.removeChild(_this["pre_cl"]);
				}catch(er:Error){}
				_this.drawPict(stg_class.pict_links[ur.split("/").join("_")].clone());
				loads.shift();
				if(loads.length>0){
					loads[0][0].LoadImage(loads[0][1]);
				}
				return;
			}
			
			_this._link=ur;
			var loader:Loader = new Loader();
			_this._ldr=loader;
			loader.name="wait";
			//loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, errorConnection);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, function(event:Event){
				//trace("open   "+ur);
				loader.name="ready";
			});
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, function(event:Event){
				loader.name="ready";
			});
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event){
				loader.name="ready";
				//trace("d   "+_this["name"]+"   "+_this["empty"]+"   "+ur);
				try{
					_this.removeChild(_this["pre_cl"]);
				}catch(er:Error){}
				_this.drawPict(event.currentTarget.content.bitmapData);
				stg_class.pict_links[ur.split("/").join("_")]=_this.bmd.clone();
				loads.shift();
				if(loads.length>0){
					loads[0][0].LoadImage(loads[0][1]);
				}
			});
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:Event){
				loader.name="ready";
				_this.errCount();
			});
      loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event){
				loader.name="ready";
				_this.errCount();
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event){
				loader.name="ready";
				_this.errCount();
			});
			//errTest("Test...   "+url_count+"   "+ur,100);
			loader.load(new URLRequest(stg_class.res_url+"/"+ur));
			//loader.load(new URLRequest("http://85709.dyn.ufanet.ru"+"/"+ur));
			_this.stm=setTimeout(function(){
				if(loader!=null){
					if(loader.name=="wait"){
						//trace(loader.name+"   "+loader.contentLoaderInfo.url);
						loader.close();
						_this["load_er"]=15;
						_this.errCount();
					}
				}
			}, 8000);
		}
		
		public function errCount(){
			//trace("errIcon   "+this["load_er"]);
			var _this:MovieClip=this;
			if(_this["load_er"]<2){
				_this["load_er"]++;
				_this.LoadImage(_this["_link"]);
			}else{
				_this.erPict();
				loads.shift();
				if(loads.length>0){
					loads[0][0].LoadImage(loads[0][1]);
				}
			}
		}
		
		public function erPict(){
			var _this:MovieClip=this;
			try{
				_this.removeChild(_this["pre_cl"]);
			}catch(er:Error){}
			_this.clearBtn();
			var tx:TextField=new TextField();
			tx.text="er";
			tx.textColor=0xff0000;
			var bmd:BitmapData=new BitmapData(30,30,true);
			var mtrx:Matrix=new Matrix();
			mtrx.translate(width/2-tx.textWidth/2,height/2-tx.textHeight/2);
			bmd.draw(tx);
			_this.drawPict(bmd);
		}
		
		public function drawPict(_bmd:BitmapData){
			var _this:MovieClip=this;
			_this.bmd=_bmd.clone();
			_this.clearBtn();
			_this.graphics.beginBitmapFill(_this.bmd);
			_this.graphics.drawRect(.5,.5,29,29);
			//trace(empty);
			if(_this["empty"]){
				stg_cl.b_and_w(_this,1);
			}else{
				stg_cl.b_and_w(_this);
			}
			//trace("e   "+_this.name+"   "+_this["empty"]);
		}
		
		public function setLevTime(t:int){
			lev_time=t;
			lev_left=0;
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
				if(int(idies[0][0])==2){
					if(int(idies[1][0])==21){
						loader.addEventListener(Event.COMPLETE, getPanel);
					}else if(int(idies[1][0])==25){
						loader.addEventListener(Event.COMPLETE, getCheks);
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
			list=new XML(strXML);
			//trace("s_xml\n"+list+"\n");
			var variables:URLVariables = new URLVariables();
			variables.query = list;
			variables.send = "send";
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
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
			stg_cl.warn_f(4,"VIP");
		}
		
		public function getCheks(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("getPanel   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \n getCheks.");
				stg_cl.erTestReq(2,21,str);
				return;
			}
			
			try{
				var _balance:XMLList=list.balance;
				var _len:int=_balance.length();
				var _ar:Array=[0,0,0,0,0,0];
				for(var i:int=0;i<_len;i++){
					var _money:XML=_balance[i];
					_ar[0]+=int(_money.@money_m);
					_ar[1]+=int(_money.@money_z);
					_ar[2]+=int(_money.@money_a);
					_ar[3]+=int(_money.@sn_val);
				}
				if(_len>0){
					stg_class.shop["exit"].setMoneys(_ar);
				}
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \n getCheks1.");
				stg_cl.erTestReq(2,21,str);
				return;
			}
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getPanel(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("getPanel   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \n getPanel.");
				stg_cl.erTestReq(2,21,str);
				return;
			}
			//trace("getPanel\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			parsePanel(list);
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function parseRazdel(list:XMLList):void{
			stg_class.prnt_cl.output("parseRazdel\n"+list+"\n\n",1);
			
			var _len:int=list.length();
			
			for(var i:int=0;i<_len;i++){
				//var _free:int=int(list[i].attribute("free"));
				var _n:int=int(list[i].attribute("num"));
				/*var _l:int=int(list[i].attribute("len"));
				for(var j:int=0;j<_l;j++){
					var _slot:MovieClip=root["sl_"+_n+"_"+j];
					_slot.clearBtn();
					_slot.i_text="";
					_slot.i_name="";
					_slot.empty=true;
					_slot.gr_slots=new Array();
					root["sl_"+_n+"_"+j]["num1"].visible=false;
					root["sl_"+_n+"_"+j]["num2"].visible=false;
					if(j>=_free){
						root["sl_"+_n+"_"+j].free=false;
					}else{
						root["sl_"+_n+"_"+j].free=true;
					}
				}*/
				
				var _len1:int=list[i].child("slot").length();
				
				//root["slots_tx"+list[i].attribute("num")].text=(list[i].attribute("name"));
				//root["info_sl"+list[i].attribute("num")].i_text=new_line_f(list[i].attribute("descr"));
				
				for(var j:int=0;j<_len1;j++){
					var _slot_obj:XML=list[i].child("slot")[j];
					var _cl:MovieClip=root["sl_"+_slot_obj.attribute("sl_gr")+"_"+_slot_obj.attribute("sl_num")];
					if(int(_slot_obj.attribute("num"))==0){
						if(int(_slot_obj.attribute("id"))==int(_cl.ID)){
							_cl.clearBtn();
							_cl.ID=0;
							_cl.i_text="";
							_cl.i_name="";
							_cl.empty=true;
							_cl.gr_slots=new Array();
							_cl["num1"].visible=false;
							_cl["num2"].visible=false;
						}
						continue;
					}
					
					_cl.ID=(_slot_obj.attribute("id"));
					_cl.cd_time=int(_slot_obj.attribute("cd"));
					_cl.calc=int(_slot_obj.attribute("calculated"));
					_cl.allow=int(_slot_obj.attribute("allow"));
					_cl.empty=!Boolean(int(_slot_obj.attribute("ready")));
					_cl.send_id=int(_slot_obj.attribute("send_id"));
					_cl.back_id=(_slot_obj.attribute("back_id")).split(",");
					_cl.i_text=(_slot_obj.attribute("descr"));
					_cl.i_name=(_slot_obj.attribute("name"));
					_cl.quantity=(_slot_obj.attribute("num"));
					_cl.lev=(_slot_obj.attribute("level"));
					_cl.reg=(_slot_obj.attribute("reg")).split("/");
					if(_cl.allow==0){
						_cl._try=1;
					}else{
						_cl._try=0;
					}
					//trace("a   "+_cl.name+"   "+_cl.empty+"   "+(_slot_obj.attribute("src")));
					var _gr:Array=new Array();
					if((_slot_obj.attribute("group"))!=""){
						_gr=(_slot_obj.attribute("group")).split("|");
					}else{
						_gr.push(_cl["ID"]);
					}
					_cl.gr_slots=_gr;
					_cl.ch_num();
					_cl.load_er=0;
					var pre_cl:MovieClip=new (stg_class.mini_pre)();
					pre_cl.x=(_cl.width-pre_cl.width)/2;
					pre_cl.y=(_cl.height-pre_cl.height)/2;
					_cl.pre_cl=pre_cl;
					_cl.addChild(_cl.pre_cl);
					loads.push([_cl,(_slot_obj.attribute("src"))]);
				}
			}
			
			if(loads.length>0){
				loads[0][0].LoadImage(loads[0][1]);
			}
		}
		
		public function parsePanel(list:XML):void{
			//stg_class.prnt_cl.output("parsePanel\n"+list+"\n\n",1);
			
			stg_class.f_cd=int(list.child("lifes")[0].attribute("ws"));
			stg_class.fire_cd=int(list.child("lifes")[0].attribute("ws"));
			stg_class.f_cd1=int(list.child("lifes")[0].attribute("ws1"));
			for(var i:int=0;i<stg_class.ammo_sp.length;i++){
				stg_class.ammo_sp[i]=int(list.child("lifes")[0].attribute("ws"));
			}
			var _hp:int=(list.child("lifes")[0].attribute("hp"));
			var _hp_max:int=(list.child("lifes")[0].attribute("hp_max"));
			if(_hp<0){
				_hp=0;
			}
			if(_hp_max<1){
				_hp_max=1;
				if(_hp_max<_hp){
					_hp=_hp_max;
				}
			}
			root["health_tx"].text=_hp+"/"+_hp_max;
			root["health_bar"].graphics.clear();
			root["health_bar"].graphics.beginFill(0x00ff00);
			root["health_bar"].graphics.drawRect(.5,.5,(_hp/_hp_max)*87,3);
			stg_class.lifes=int(list.child("lifes")[0].attribute("life_num"));
			drawLifes();
			
			//trace("b");
			root["gun_ammo_tx"].text=(list.child("ammo")[0].attribute("name"));
			root["info_ammo"].i_text=(list.child("ammo")[0].attribute("descr"));
			for(i=0;i<list.child("ammo")[0].child("patron").length();i++){
				var _cl:MovieClip=root["ammo"+i];
				_cl.ID=(list.child("ammo")[0].child("patron")[i].attribute("id"));
				_cl.i_text=new_line_f(list.child("ammo")[0].child("patron")[i].attribute("descr"));
				_cl.i_name=(list.child("ammo")[0].child("patron")[i].attribute("name"));
				_cl.quantity=int(list.child("ammo")[0].child("patron")[i].attribute("num"));
				_cl.dmg=(list.child("ammo")[0].child("patron")[i].attribute("dmg"));
				_cl.empty=!Boolean(int(list.child("ammo")[0].child("patron")[i].attribute("ready")));
			}
			resetAmmo();
			//trace("c");
			var _fl:int=(list.child("fuel")[0].attribute("now"));
			var _fl_max:int=(list.child("fuel")[0].attribute("max"));
			if(_fl<0){
				_fl=0;
			}
			if(_fl_max<1){
				_fl_max=1;
				if(_fl_max<_fl){
					_fl=_fl_max;
				}
			}
			root["fuel_name"].text=(list.child("fuel")[0].attribute("name"));
			root["info_fuel"].i_text=new_line_f(list.child("fuel")[0].attribute("descr"));
			root["fuel_tx"].text=(_fl)+"/"+(_fl_max);
			root["fuel_bar"].graphics.clear();
			root["fuel_bar"].graphics.beginFill(0x00ff00);
			root["fuel_bar"].graphics.drawRect(.5,.5,(_fl/_fl_max)*87,3);
			
			root["timer_name"].text=(list.child("timer")[0].attribute("name"));
			root["info_time"].i_text=new_line_f(list.child("timer")[0].attribute("descr"));
			root["time_bar"].graphics.clear();
			root["time_tx"].text="00:00";
			
			root["skills_tx"].text=(list.child("moneys")[0].attribute("money_z"));
			root["money_tx"].text=(list.child("moneys")[0].attribute("money_m"));
			root["ar_tx"].text=(list.child("moneys")[0].attribute("money_a"));
			root["is_m_tx"].text=(list.child("moneys")[0].attribute("money_i"));
			root["credits_tx"].text=(list.child("moneys")[0].attribute("sn_val"));
			
			stg_class.shop["fuel_win"]["buy_fuel"]["min_party"]=_fl_max;
			stg_class.shop["fuel_win"]["fuel_tx"].text=_fl+"/"+_fl_max;
			stg_class.shop["fuel_win"]["fill_cl"].height=(_fl/_fl_max)*96;
			stg_class.shop["exit"].setVar([_fl]);
			
			stg_class.shop["exit"].setMoneys([root["money_tx"].text,root["skills_tx"].text,root["ar_tx"].text,root["credits_tx"].text]);
			
			for(var i:int=0;i<clips.length;i++){
				clips[i].free=false;
			}
			
			for(i=0;i<list.child("razdel").length();i++){
				var _free:int=int(list.child("razdel")[i].attribute("free"));
				var _n:int=int(list.child("razdel")[i].attribute("num"));
				var _l:int=int(list.child("razdel")[i].attribute("len"));
				for(var j:int=0;j<_l;j++){
					root["sl_"+_n+"_"+j]["num1"].visible=false;
					root["sl_"+_n+"_"+j]["num2"].visible=false;
					if(j>=_free){
						root["sl_"+_n+"_"+j].free=false;
					}else{
						root["sl_"+_n+"_"+j].free=true;
					}
				}
			}
			resetBtn();
			//trace("e");
			for(i=0;i<list.child("razdel").length();i++){
				root["slots_tx"+list.child("razdel")[i].attribute("num")].text=(list.child("razdel")[i].attribute("name"));
				root["info_sl"+list.child("razdel")[i].attribute("num")].i_text=new_line_f(list.child("razdel")[i].attribute("descr"));
				for(var j:int=0;j<list.child("razdel")[i].child("slot").length();j++){
					var _cl:MovieClip=root["sl_"+list.child("razdel")[i].child("slot")[j].attribute("sl_gr")+"_"+list.child("razdel")[i].child("slot")[j].attribute("sl_num")];
					_cl.ID=(list.child("razdel")[i].child("slot")[j].attribute("id"));
					_cl.cd_time=int(list.child("razdel")[i].child("slot")[j].attribute("cd"));
					_cl.calc=int(list.child("razdel")[i].child("slot")[j].attribute("calculated"));
					_cl.allow=int(list.child("razdel")[i].child("slot")[j].attribute("allow"));
					_cl.empty=!Boolean(int(list.child("razdel")[i].child("slot")[j].attribute("ready")));
					_cl.send_id=int(list.child("razdel")[i].child("slot")[j].attribute("send_id"));
					_cl.back_id=(list.child("razdel")[i].child("slot")[j].attribute("back_id")).split(",");
					_cl.i_text=(list.child("razdel")[i].child("slot")[j].attribute("descr"));
					_cl.i_name=(list.child("razdel")[i].child("slot")[j].attribute("name"));
					_cl.quantity=(list.child("razdel")[i].child("slot")[j].attribute("num"));
					_cl.lev=(list.child("razdel")[i].child("slot")[j].attribute("level"));
					_cl.reg=(list.child("razdel")[i].child("slot")[j].attribute("reg")).split("/");
					if(_cl.allow==0){
						_cl._try=1;
					}else{
						_cl._try=0;
					}
					//trace("a   "+_cl.name+"   "+_cl.empty+"   "+(list.child("razdel")[i].child("slot")[j].attribute("src")));
					var _gr:Array=new Array();
					if((list.child("razdel")[i].child("slot")[j].attribute("group"))!=""){
						_gr=(list.child("razdel")[i].child("slot")[j].attribute("group")).split("|");
					}else{
						_gr.push(_cl["ID"]);
					}
					_cl.gr_slots=_gr;
					_cl.ch_num();
					_cl.load_er=0;
					var pre_cl:MovieClip=new (stg_class.mini_pre)();
					pre_cl.x=(_cl.width-pre_cl.width)/2;
					pre_cl.y=(_cl.height-pre_cl.height)/2;
					_cl.pre_cl=pre_cl;
					_cl.addChild(_cl.pre_cl);
					loads.push([_cl,(list.child("razdel")[i].child("slot")[j].attribute("src"))]);
				}
			}
			/*for(i=0;i<loads.length;i++){
				trace("b   "+loads[i][0]["name"]+"   "+loads[i][0]["empty"]+"   "+loads[i][1]);
			}*/
			for(i=0;i<clips.length;i++){
				var _gr:Array=new Array();
				for(var n:int=0;n<clips.length;n++){
					for(var j:int=0;j<clips[i]["gr_slots"].length;j++){
						if(int(clips[n]["ID"])==int(clips[i]["gr_slots"][j])){
							_gr.push(clips[n]);
							break;
						}
					}
				}
				clips[i]["gr_slots"]=_gr;
				/*trace("a   "+clips[i]["i_name"]);
				for(var n:int=0;n<clips[i]["gr_slots"].length;n++){
					trace(clips[i]["gr_slots"][n]["i_name"]);
				}*/
			}
			loads[0][0].LoadImage(loads[0][1]);
		}
		
		public function DirButton(){
			super();
			Security.allowDomain("*");
			stop();
			
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
			
			//addEventListener(MouseEvent.MOUSE_OUT, m_click);
			if(name.slice(0,3)=="sl_"){
				clip=new MovieClip();
				clip.x=0;
				clip.y=0;
				clip.graphics.clear();
				addChild(clip);
				clearBtn();
				clips.push(this);
				this["num1"].stop();
				this["num2"].stop();
				this["num1"].visible=false;
				this["num2"].visible=false;
				var _cl:MovieClip=this;
				_cl.i_text="";
				_cl.i_name="";
				_cl.empty=true;
				_cl.gr_slots=new Array();
				/*_cl.load_er=0;
				loads.push([_cl, "images/icons/m-radar.png"]);
				if(name=="sl_0_0"){
					setTimeout(function(){
						loads[0][0].LoadImage(loads[0][1]);
					}, 1000);
				}*/
			}else if(name.slice(0,4)=="ammo"){
				gotoAndStop("empty");
			}
		}
		
		public function clearBtn(){
			graphics.clear();
			if(this["free"]){
				graphics.lineStyle(1,0x990000);
				graphics.beginFill(0xB6B6B6);
				graphics.drawRect(0.5,0.5,29,29);
			}else{
				/*graphics.lineStyle(1,0xff0000);
				graphics.beginFill(0xffffff);
				graphics.drawRect(0.5,0.5,29,29);
				graphics.lineStyle(2,0xff0000);
				graphics.moveTo(2, 2);
				graphics.lineTo(width-2, height-2);
				graphics.moveTo(2, height-2);
				graphics.lineTo(width-2, 2);*/
				
				this["num1"].visible=false;
				this["num2"].visible=false;
			}
		}
		
		public function resetBtn(){
			//trace("resetBtn");
			for(var i:int=0;i<clips.length;i++){
				clips[i].clearBtn();
				clips[i].ID=0;
				clips[i].i_text="";
				clips[i].i_name="";
				clips[i].empty=true;
				clips[i].gr_slots=new Array();
			}
		}
		
		public function drawLifes(){
			// stg_class.lifes
			for(var i:int=0;i<4;i++){
				if(i<stg_class.lifes){
					root["life"+i].alpha=1;
				}else{
					root["life"+i].alpha=.5;
				}
			}
		}
		
		public function addHealth(_add:int,_full:int=-1){
			if(_full>-1){
				drawHealth(_full,_full);
			}else{
				var _h_ar:Array=root["health_tx"].text.split("/");
				_full=int(_h_ar[0])+_add;
				drawHealth(_full,_full);
			}
		}
		
		public function drawHealth(_a:int,_b:int){
			// stg_class.lifes
			root["health_tx"].text=_a+"/"+_b;
			root["health_bar"].graphics.clear();
			root["health_bar"].graphics.beginFill(0x00ff00);
			root["health_bar"].graphics.drawRect(.5,.5,(_a/_b)*87,3);
		}
		
		public function clearAmmo(){
			gotoAndStop("empty");
			root["ammo_tx"+name.slice(4,5)].text="";
		}
		
		public function resetAmmo(){
			// урон базовым stg_class.basic_dm
			for(var i:int=0;i<6;i++){
				if(root["ammo"+i].empty){
					root["ammo"+i].clearAmmo();
				}else{
					root["ammo"+i].gotoAndStop("out");
					if(root["ammo"+i].quantity<10000){
						root["ammo_tx"+i].text=root["ammo"+i].quantity;
					}else{
						root["ammo_tx"+i].text="xxxx";
					}
					root["ammo_tx"+i].textColor=0xffffff;
				}
			}
		}
		
		public function ch_ammo(num:int){
			// урон stg_class.ammo_dm[num]
			resetAmmo();
			root["ammo"+num].gotoAndStop("press");
			root["ammo_tx"+num].textColor=0x000000;
		}
		
		public function ch_num(){
			// меняет число вналичии для слота
			if(this["_try"]==this["allow"]){
				this["empty"]=true;
				stg_cl.b_and_w(this,1);
			}
			if(this["calc"]==1){
				this["num1"].visible=true;
				this["num2"].visible=true;
			}else{
				this["num1"].visible=false;
				this["num2"].visible=false;
				return;
			}
			////trace("panel num "+this["num1"].visible);
			if(quantity<100){
				if(quantity>=0){
					this["num1"].gotoAndStop((int(quantity/10))+1);
					this["num2"].gotoAndStop((int(quantity%10))+1);
				}
			}else{
				this["num1"].gotoAndStop(11);
				this["num2"].gotoAndStop(11);
			}
		}
		
		public function find_sl(_code:Array):MovieClip{
			var _b:int=0;
			for(var i:int=0;i<clips.length;i++){
				_b=0;
				if(clips[i]["back_id"]!=null){
					for(var j:int=0;j<clips[i]["back_id"].length;j++){
						if(int(_code[j])!=int(clips[i]["back_id"][j])){
							_b=1;
							break;
						}
					}
					if(_b==0){
						return clips[i];
					}
				}
			}
			return root["ammo0"];
		}
		
		public function find_sl1(_code:int):MovieClip{
			for(var i:int=0;i<clips.length;i++){
				if(_code==clips[i]["send_id"]){
					return clips[i];
				}
			}
			return null;
		}
		
		public function find_sl2(_id:int):MovieClip{
			for(var i:int=0;i<clips.length;i++){
				if(_id==clips[i]["ID"]){
					return clips[i];
				}
			}
			for(i=0;i<6;i++){
				if(_id==root["ammo"+i]["ID"]){
					return root["ammo"+i];
				}
			}
			return null;
		}
		
		public function set_reg(_pr:int):void{
			try{
				removeEventListener(Event.ENTER_FRAME, drawMyRect);
			}catch(er:Error){}
			var _this:MovieClip=this as MovieClip;
			var _i:int=0;
			if(step_time>0){
				_i=step_time;
			}
			quantity=_pr;
			ch_num();
			_this["cd_time"]=100*(int(_this["reg"][0])/int(_this["reg"][1]));
			cd_left=_pr*(int(_this["reg"][0])/int(_this["reg"][1]));
			steps=_i-cd_left;
			cd_now=true;
			addEventListener(Event.ENTER_FRAME, drawMyRect);
		}
		
		public function teg_slot(list:XML,_i:int=0):void{
			//trace(list.toXMLString());
			//trace(list.attribute("send_id")+"   "+list.attribute("back_id"));
			var _cl:MovieClip=this;
			_cl.ID=(list.attribute("id"));
			if(int(list.attribute("cd"))>0){
				_cl.cd_time=int(list.attribute("cd"));
			}
			_cl.calc=int(list.attribute("calculated"));
			_cl.allow=int(list.attribute("allow"));
			_cl.empty=!Boolean(int(list.attribute("ready")));
			_cl.quantity=(list.attribute("num"));
			_cl.reg=(list.attribute("reg")).split("/");
			if(_i==0){
				_cl.send_id=int(list.attribute("send_id"));
				_cl.back_id=(list.attribute("back_id")).split(",");
				_cl.i_text=(list.attribute("descr"));
				_cl.i_name=(list.attribute("name"));
				_cl.lev=(list.attribute("level"));
				if(_cl.allow==0){
					_cl._try=1;
				}else{
					_cl._try=0;
				}
				//trace("a   "+_cl.name+"   "+_cl.empty+"   "+(list.attribute("src")));
				var _gr:Array=new Array();
				if((list.attribute("group"))!=""){
					_gr=(list.attribute("group")).split("|");
				}else{
					_gr.push(_cl["ID"]);
				}
				_cl.gr_slots=_gr;
				_cl.ch_num();
				var _gr1:Array=new Array();
				for(var n:int=0;n<clips.length;n++){
					for(var j:int=0;j<_cl["gr_slots"].length;j++){
						if(int(clips[n]["ID"])==int(_cl["gr_slots"][j])){
							_gr1.push(clips[n]);
							break;
						}
					}
				}
				_cl["gr_slots"]=_gr1;
				
				if(_cl["empty"]){
					stg_cl.b_and_w(_cl,1);
				}else{
					stg_cl.b_and_w(_cl);
				}
			}else{
				_cl.ch_num();
				if(_cl["empty"]){
					stg_cl.b_and_w(_cl,1);
				}else{
					stg_cl.b_and_w(_cl);
				}
			}
		}
		
		public function q_iter(iter:int=0,_num:int=1){
			if(name=="ammo0"){
				return;
			}else if(iter==0){
				if(this["calc"]==1){
					quantity-=_num;
				}
				this["_try"]+=_num;
			}else{
				if(this["calc"]==1){
					quantity+=_num;
				}
			}
			ch_num();
			if(iter==0){
				begin_cd();
			}
		}
		
		public function begin_cd(){
			// запускает кд
			//trace("begin_cd");
			var _i:int=0;
			if(step_time>0){
				_i=step_time;
			}
			//trace(this["gr_slots"]);
			if(this["gr_slots"].length>0){
				for(var t:int=0;t<this["gr_slots"].length;t++){
					if(!this["gr_slots"][t]["empty"]){
						this["gr_slots"][t]["steps"]=_i;
						this["gr_slots"][t]["cd_now"]=true;
						this["gr_slots"][t]["cd_left"]=0;
						try{
							this["gr_slots"][t].removeEventListener(Event.ENTER_FRAME, drawMyRect);
						}catch(er:Error){}
						this["gr_slots"][t].addEventListener(Event.ENTER_FRAME, drawMyRect);
					}
				}
			}else if(!this["empty"]){
				steps=_i;
				cd_now=true;
				cd_left=0;
				try{
					this.removeEventListener(Event.ENTER_FRAME, drawMyRect);
				}catch(er:Error){}
				this.addEventListener(Event.ENTER_FRAME, drawMyRect);
			}
		}
		
		public function one_cd(){
			var _i:int=0;
			if(step_time>0){
				_i=step_time;
			}
			if(!this["empty"]){
				steps=_i;
				cd_now=true;
				cd_left=0;
				try{
					this.removeEventListener(Event.ENTER_FRAME, drawMyRect);
				}catch(er:Error){}
				this.addEventListener(Event.ENTER_FRAME, drawMyRect);
			}
		}
		
		public function reset_cd(){
			//trace("reset_cd   "+clips.length);
			for(var n:int=0;n<clips.length;n++){
				try{
					clips[n].removeEventListener(Event.ENTER_FRAME, drawMyRect);
				}catch(er:Error){}
				
				clips[n]["cd_now"]=false;
				clips[n]["cd_left"]=0;
				clips[n]["clip"].graphics.clear();
			}
		}
		
		public function showInfo(info_str:String,X:int,Y:int,H:int){
			if(stg_class.help_on){
				return;
			}
			stg_cl.setChildIndex(stg_class.panel,stg_cl.numChildren-1);
			var txf:TextField=stg_class.panel["info_tx"];
			txf.selectable=false;
			txf.multiline=true;
			txf.autoSize=TextFieldAutoSize.LEFT;
			txf.wordWrap=false;
			txf.textColor=0xF0DB7D;
			txf.text=info_str;
			txf.x=X-txf.width;
			txf.y=Y-txf.height-H/2;
			while(txf.y<0){
				txf.y+=5;
			}
			if(txf.x+txf.parent.x<0){
				txf.x=10-txf.parent.x;
			}else if(txf.x+txf.width+10>stg_cl.width){
				txf.x=stg_cl.width-(txf.width+10)-txf.parent.x;
			}
			var info_w:int=txf.width;
			var info_h:int=txf.height;
			var info_rw:int=10;
			var info_rh:int=10;
			St_clip.self.mouseEnabled=txf.mouseEnabled=false;
			St_clip.self.graphics.lineStyle(1, 0x000000, 1, true);
			St_clip.self.graphics.beginFill(0x990700,1);
			St_clip.self.graphics.drawRoundRect(txf.x-3, txf.y, info_w+10, info_h+2, info_rw, info_rh);
			txf.parent.setChildIndex(txf,txf.parent.numChildren-1);
			txf.visible=true;
		}
		
		public function hideInfo(){
			var txf:TextField=stg_class.panel["info_tx"];
			txf.visible=false;
			St_clip.self.graphics.clear();
		}
		
		public static var mT:Timer;
		
		public function tStop(){
			try{mT.stop()}catch(er:Error){}
			hideInfo();
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(stg_cl["wall_win"]){
				return;
			}
			if(!stg_cl["warn_er"]){
				Mouse.cursor=MouseCursor.BUTTON;
				if(currentFrameLabel=="empty"){
					return;
				}else if(name.slice(0,5)=="info_"){
					if(stg_class.m_mode!=3){
						showInfo(this["i_text"],x-width-5,y,height);
					}
					return;
				}else if(name.slice(0,4)=="ammo"){
					if(currentFrameLabel=="press"){
						return;
					}
					if(stg_class.m_mode!=3){
						var _cl:MovieClip=this;
						tStop();
						mT=new Timer(200, 1);
						mT.addEventListener(TimerEvent.TIMER_COMPLETE, function(){
							 showInfo(_cl["i_text"],_cl.x-_cl.width/2,_cl.y+_cl.height/2,_cl.height);
						});
						mT.start();
					}
				}else if(stg_class.m_mode!=3){
					if(name.slice(0,2)=="sl"){
						var _cl:MovieClip=this;
						//trace(this["i_text"]);
						if(_cl["i_text"]!=""){
							if(!this["empty"]){
								stg_cl.overTest1(_cl,1);
							}else{
								Mouse.cursor=MouseCursor.AUTO;
							}
							tStop();
							mT=new Timer(200, 1);
							mT.addEventListener(TimerEvent.TIMER_COMPLETE, function(){
								 showInfo(_cl["i_text"],_cl.x-_cl.width/2,_cl.y+_cl.height/2,_cl.height);
							});
							mT.start();
						}else{
							Mouse.cursor=MouseCursor.AUTO;
						}
						return;
					}
				}else if(name.slice(0,2)=="sl"){
					if(this["i_text"]!=""){
						if(!this["empty"]){
							stg_cl.overTest1(this,1);
						}else{
							Mouse.cursor=MouseCursor.AUTO;
						}
					}
				}
				gotoAndStop("over");
				
			}
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			Mouse.cursor=MouseCursor.AUTO;
			if(currentFrameLabel=="empty"){
				return;
			}else if(name.slice(0,5)=="info_"){
				hideInfo();
				return;
			}else if(name.slice(0,4)=="ammo"){
				tStop();
				if(currentFrameLabel=="press"){
					return;
				}
			}else if(stg_class.m_mode!=3){
				if(name.slice(0,2)=="sl"){
					stg_cl.overTest1(this,0);
					tStop();
					return;
				}
			}else if(name.slice(0,2)=="sl"){
				stg_cl.overTest1(this,0);
				return;
			}
			gotoAndStop("out");
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl==null){
				stg_cl=this.parent.parent as MovieClip;
			}
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(stg_cl["wall_win"]){
				return;
			}
			if(!stg_cl["warn_er"]){
				////trace(cd_now+"   "+empty+"   "+quantity+"   "+empty);
				if(name=="waiting_cl"){
					stg_class.wind["choise_cl"].stopAutoWait();
					gotoAndStop("press");
				}else if(name=="opt_b"){
					stg_cl.showOpt();
					gotoAndStop("press");
				}else if(name=="arsenal_b"&&currentFrameLabel!="empty"){
					stg_class.vip_cl["exit_cl"].sendRequest(["query","action"],[["id"],["id","type"]],[["1"],["5"]]);
					gotoAndStop("press");
				}else if(name=="buy_val"&&currentFrameLabel!="empty"){
					var _ar:Array=new Array();
					if(stg_class.m_mode==2){
						//stg_class.vip_cl["exit_cl"].vipReset();
						stg_class.shop["exit"].showMWin(5);
					}else{
						_ar[0]=function(){
							stg_cl.createMode(2);
						};
						stg_class.shop["exit"].needMoney(_ar,5,1);
					}
					gotoAndStop("press");
				}else if(stg_class.m_mode==3){
					if(!cd_now){
						if(name=="leave_cl"){
							if(stg_class.lifes<0){
								stg_cl.warn_f(12,"",1);
							}else{
								stg_cl.warn_f(11,"",1);
							}
							gotoAndStop("press");
						}else{
							if(!this["empty"]&&quantity>0){
								if(name.slice(0,4)=="ammo"){
									if(stg_class.pl_clip["fire_type"]!=(int(name.slice(4,5)))){
										var gun:int=(int(name.slice(4,5)));
										stg_cl.socket.sendEvent(gun+10,0);
									}
									////trace(stg_cl);
									//clip.LoadMap();
								}else{
									stg_cl.resetAir();
									if(this["send_id"]==22){
										stg_cl.createAir(1);
									}else if(this["send_id"]==23){
										stg_cl.createAir(2);
									}else if(this["send_id"]!=0&&this["send_id"]<253){
										//trace("send "+this["send_id"]);
										stg_cl.socket.sendEvent(this["send_id"],0);
									}
								}
							}
							return;
						}
					}
				}
			}
		}
		
		public function render(){
			timeCount();
			m_cd();
		}
		
		public var steps:Number=0;
		public static var step_time:Number=0;
		
		public function m_cd(){
			if(stg_class.m1_do){
				var _t:int=(stg_class.m1_time+stg_class.steps1)-step_time;
				if(_t>0){
					stg_class.m1_left++;
					if(_t<80&&stg_class["pl_clip"]!=null){
						if(_t%15==0){
							if(!stg_class["pl_clip"]["stoped"]){
								stg_class["pl_clip"]["stoped"]=true;
								stg_cl.b_and_w(stg_class["pl_clip"],1);
							}else{
								stg_class["pl_clip"]["stoped"]=false;
								stg_cl.b_and_w(stg_class["pl_clip"]);
							}
						}
					}
				}/*else{
					try{
						stg_cl.channel.stop();
					}catch(er:Error){
						
					}
					stg_class.m1_left=0;
					stg_class.m1_do=false;
					if(stg_class["pl_clip"]!=null){
						stg_class["pl_clip"]["stoped"]=false;
						stg_cl.b_and_w(stg_class["pl_clip"]);
					}
				}*/
			}
			/*if(stg_class.m3_do){
				var _t:int=(stg_class.m3_time+stg_class.steps3)-step_time;
				if(_t>0){
					stg_class.m3_left++;
					
				}else{
					stg_class["pl_clip"].teslaOff();
				}
			}*/
			if(stg_class.m2_do){
				if(step_time<stg_class.m2_time+stg_class.steps2){
					stg_class.m2_left++;
				}else{
					stg_class.fire_cd=stg_class.f_cd;
					stg_class.m2_left=0;
					stg_class.m2_do=false;
				}
			}
			
			for(mz=0;mz<stg_class.bonuses.length;mz++){
				if(stg_class.bonuses[mz]!=null){
					//trace(stg_class.bon_step[mz]+"   "+step_time);
					if(stg_class.bon_step[mz]+4>step_time){
						stg_class.bon_time[mz]--;
						////trace(bon_c[i]);
						if(stg_class.bon_time[mz]%3==0){
							stg_class.bon_pict[mz][stg_class.bon_c[mz]].visible=false;
							if(stg_class.bon_c[mz]<2){
								stg_class.bon_c[mz]++;
							}else{
								stg_class.bon_c[mz]=0;
							}
							////trace(bon_c[mz]);
							stg_class.bon_pict[mz][stg_class.bon_c[mz]].visible=true;
						}
					}else{
						try{
							stg_class.ground.removeChild(stg_class.bonuses[mz]);
							stg_class.bonuses[mz]=null;
							stg_class.bon_id[mz]=null;
							stg_class.bon_pos[mz]=null;
							stg_class.bon_time[mz]=null;
							stg_class.bon_type[mz]=null;
							stg_class.bon_pow[mz]=null;
							stg_class.bon_step[mz]=null;
							stg_class.bon_pict[mz]=null;
							stg_class.bon_c[mz]=null;
						}catch(er:Error){
							
						}
					}
				}
			}
		}
		
		public function m_begin(step:int){
			if(step==1){
				stg_class.steps1=step_time;
				stg_class.m1_left=0;
				stg_class.m1_do=true;
			}else if(step==2){
				stg_class.steps2=step_time;
				stg_class.m2_left=0;
				stg_class.m2_do=true;
			}/*else if(step==3){
				stg_class.steps3=step_time;
				stg_class.m3_left=0;
				stg_class.m3_do=true;
			}*/
		}
		
		public function getStep(){
			//trace("r   "+step_time);
			return step_time;
		}
		
		public function timeStep(step:Number){
			//if(lev_left<(step*40)/1000){
				step_time=step;
				stg_class.steps=step;
				lev_left=(step*40)/1000;
			//}
		}
		
		public function timeCount(){
			step_time++;
			stg_class.steps++;
			if(wait1<25){
				wait1++;
			}else{
				wait1=0;
				if(lev_left<lev_time){
					lev_left++;
					//timeStep();
					lev_s=(int((lev_time-lev_left)%60));
					lev_m=(int((lev_time-lev_left)/60));
					lev_tx="";
					if(lev_m<10){
						lev_tx+="0"+lev_m+":";
					}else{
						lev_tx+=lev_m+":";
					}
					if(lev_s<10){
						lev_tx+="0"+lev_s;
					}else{
						lev_tx+=lev_s;
					}
					root["time_tx"].text=lev_tx;
					root["time_bar"].graphics.clear();
					root["time_bar"].graphics.beginFill(0x960C00);
					root["time_bar"].graphics.drawRect(.5,.5,(lev_left/lev_time)*105,3);
				}
				/*if(stg_class.rocket||stg_class.plane||stg_class.bomb){
					if(air_left<air_time){
						air_left++;
						air_s=(int((air_time-air_left)%60));
						air_m=(int((air_time-air_left)/60));
						air_tx="";
						if(lev_m<10){
							air_tx+="0"+air_m+":";
						}else{
							air_tx+=air_m+":";
						}
						if(lev_s<10){
							air_tx+="0"+air_s;
						}else{
							air_tx+=air_s;
						}
						root["air_time_tx"].text=air_tx;
						root["air_bar"].width=(air_left/air_time)*100;
					}
				}*/
				////trace(air_left+"   "+lev_left);
			}
		}
		
		private static var cd_col:int=0x003366;
		private static var cd_alpha:Number=.6;
		
		public function drawMyRect(event:Event){
			//step_time++;
			var _cl:MovieClip=event.currentTarget as MovieClip;
			if(!_cl["cd_now"]){
				_cl["clip"].graphics.clear();
				_cl["cd_left"]=0;
				_cl["cd_now"]=false;
				_cl.removeEventListener(Event.ENTER_FRAME, drawMyRect);
				return;
			}
			if(step_time<0){
				return;
			}else if(_cl["steps"]>step_time){
				return;
			}
			var cd_num:Number=((step_time-_cl["steps"])/(_cl["cd_time"]))*100;
			if(_cl["reg"].length>1){
				_cl["quantity"]=cd_num;
				_cl.ch_num();
			}
			if(cd_num<100){
				//var cd_num:Number=(_cl["cd_left"]/_cl["cd_time"])*100;
				if(cd_num>0){
					_cl["clip"].graphics.clear();
					if(cd_num<12.5){
						var commands:Vector.<int> = new Vector.<int>(8, true);
						commands[0] = 1;
						commands[1] = 2;
						commands[2] = 2;
						commands[3] = 2;
						commands[4] = 2;
						commands[5] = 2;
						commands[6] = 2;
						commands[7] = 2;
						var coord:Vector.<Number> = new Vector.<Number>(16, true);
						coord[0] = _cl.width/2;
						coord[1] = _cl.height/2;
						coord[2] = _cl.width/2;
						coord[3] = 0;
						coord[4] = 0;
						coord[5] = 0;
						coord[6] = 0;
						coord[7] = _cl.height;
						coord[8] = _cl.width;
						coord[9] = _cl.height;
						coord[10] = _cl.width;
						coord[11] = 0;
						coord[12] = _cl.width/2+((cd_num)/12.5)*_cl.width/2;
						coord[13] = 0;
						coord[14] = _cl.width/2;
						coord[15] = _cl.height/2;
						_cl["clip"].graphics.beginFill(cd_col,cd_alpha);
						_cl["clip"].graphics.drawPath(commands, coord, GraphicsPathWinding.NON_ZERO);
					}else if(cd_num<37.5){
						var commands:Vector.<int> = new Vector.<int>(7, true);
						commands[0] = 1;
						commands[1] = 2;
						commands[2] = 2;
						commands[3] = 2;
						commands[4] = 2;
						commands[5] = 2;
						commands[6] = 2;
						var coord:Vector.<Number> = new Vector.<Number>(14, true);
						coord[0] = _cl.width/2;
						coord[1] = _cl.height/2;
						coord[2] = _cl.width/2;
						coord[3] = 0;
						coord[4] = 0;
						coord[5] = 0;
						coord[6] = 0;
						coord[7] = _cl.height;
						coord[8] = _cl.width;
						coord[9] = _cl.height;
						coord[10] = _cl.width;
						coord[11] = ((cd_num-12.5)/25)*_cl.height;
						coord[12] = _cl.width/2;
						coord[13] = _cl.height/2;
						_cl["clip"].graphics.beginFill(cd_col,cd_alpha);
						_cl["clip"].graphics.drawPath(commands, coord, GraphicsPathWinding.NON_ZERO);
					}else if(cd_num<62.5){
						var commands:Vector.<int> = new Vector.<int>(6, true);
						commands[0] = 1;
						commands[1] = 2;
						commands[2] = 2;
						commands[3] = 2;
						commands[4] = 2;
						commands[5] = 2;
						var coord:Vector.<Number> = new Vector.<Number>(12, true);
						coord[0] = _cl.width/2;
						coord[1] = _cl.height/2;
						coord[2] = _cl.width/2;
						coord[3] = 0;
						coord[4] = 0;
						coord[5] = 0;
						coord[6] = 0;
						coord[7] = _cl.height;
						coord[8] = _cl.width-((cd_num-37.5)/25)*_cl.width;
						coord[9] = _cl.height;
						coord[10] = _cl.width/2;
						coord[11] = _cl.height/2;
						_cl["clip"].graphics.beginFill(cd_col,cd_alpha);
						_cl["clip"].graphics.drawPath(commands, coord, GraphicsPathWinding.NON_ZERO);
					}else if(cd_num<87.5){
						var commands:Vector.<int> = new Vector.<int>(5, true);
						commands[0] = 1;
						commands[1] = 2;
						commands[2] = 2;
						commands[3] = 2;
						commands[4] = 2;
						var coord:Vector.<Number> = new Vector.<Number>(10, true);
						coord[0] = _cl.width/2;
						coord[1] = _cl.height/2;
						coord[2] = _cl.width/2;
						coord[3] = 0;
						coord[4] = 0;
						coord[5] = 0;
						coord[6] = 0;
						coord[7] = _cl.height-((cd_num-62.5)/25)*_cl.height;
						coord[8] = _cl.width/2;
						coord[9] = _cl.height/2;
						_cl["clip"].graphics.beginFill(cd_col,cd_alpha);
						_cl["clip"].graphics.drawPath(commands, coord, GraphicsPathWinding.NON_ZERO);
					}else{
						var commands:Vector.<int> = new Vector.<int>(4, true);
						commands[0] = 1;
						commands[1] = 2;
						commands[2] = 2;
						commands[3] = 2;
						var coord:Vector.<Number> = new Vector.<Number>(8, true);
						coord[0] = _cl.width/2;
						coord[1] = _cl.height/2;
						coord[2] = _cl.width/2;
						coord[3] = 0;
						coord[4] = ((cd_num-87.5)/25)*_cl.width;
						coord[5] = 0;
						coord[6] = _cl.width/2;
						coord[7] = _cl.height/2;
						_cl["clip"].graphics.beginFill(cd_col,cd_alpha);
						_cl["clip"].graphics.drawPath(commands, coord, GraphicsPathWinding.NON_ZERO);
					}
					//_cl["clip"].graphics.drawRect(0,0,_cl.width,_cl.height);
					////trace(commands+"   "+coord);
				}else if(_cl["reg"].length>1){
					_cl["clip"].graphics.clear();
					_cl["clip"].graphics.beginFill(cd_col,cd_alpha);
					_cl["clip"].graphics.drawRect(0,0,_cl.width,_cl.height);
				}
				_cl["cd_left"]++;
			}else{
				/*if(_cl["str"].slice(0,5)=="radio"){
					if(stg_class.plane||stg_class.rocket){
						stg_cl.resetAir();
					}
				}*/
				_cl["clip"].graphics.clear();
				_cl["cd_left"]=0;
				_cl["cd_now"]=false;
				////trace(clips[i]+"   "+i);
				_cl.removeEventListener(Event.ENTER_FRAME, drawMyRect);
			}
			//steps=0;
		}
		
		public function m_release(event:MouseEvent){
			if(currentFrameLabel=="empty"){
				return;
			}else if(name=="waiting_cl"){
				gotoAndStop("over");
			}else if(name=="opt_b"){
				gotoAndStop("over");
			}else if(name=="leave_cl"){
				gotoAndStop("over");
			}else if(name=="buy_val"){
				gotoAndStop("over");
			}
		}
		
	}
	
}















