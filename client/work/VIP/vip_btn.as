package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.*;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class vip_btn extends MovieClip{
		
		public static var stg_cl:MovieClip=new MovieClip();
		public static var serv_url:String="empty";
		public static var stg_class:Class;
		public static var loads:Array=new Array();
		
		public static var weap_cl:MovieClip;
		public static var lev_cl:MovieClip;
		public static var lev_ar_cl:MovieClip;
		public static var avas_cl:MovieClip;
		public static var packs_cl:MovieClip;
		public static var arsnl_cl:MovieClip;
		
		public var sl_type:int=0;
		
		public var dragger:Boolean=false;
		public var empty:Boolean=false;
		public var closed:Boolean=false;
		public var uni:Boolean=false;
		
		public static var mT:Timer;
		public static var send_ar:Array=new Array();
		public static var now_ar:Array=new Array();
		public static var clips:Array=new Array();
		
		public function weap_win():MovieClip{
			try{
				weap_cl.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollVip);
			}catch(er:Error){}
			weap_cl=new weapons();
			return weap_cl;
		}
		
		public function LoadImage(ur:String){
			var _this:MovieClip=this;
			try{
				clearTimeout(_this.stm);
			}catch(er:Error){}
			try{
				_this._ldr.close();
			}catch(er:Error){}
			
			if(stg_class.pict_links.hasOwnProperty(ur.split("/").join("_"))){
				//trace("in cache   "+ur);
				try{
					_this.removeChild(_this["pre_cl"]);
				}catch(er:Error){}
				if(name=="pict"){
					drawPict1(stg_class.pict_links[ur.split("/").join("_")].clone());
				}else{
					drawPict(stg_class.pict_links[ur.split("/").join("_")].clone());
				}
				loads.shift();
				if(loads.length>0){
					loads[0][0].LoadImage(loads[0][1]);
				}else{
					tanksSlots();
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
				try{
					_this.removeChild(_this["pre_cl"]);
				}catch(er:Error){}
				if(name=="pict"){
					drawPict1(event.currentTarget.content.bitmapData);
				}else{
					drawPict(event.currentTarget.content.bitmapData);
				}
				stg_class.pict_links[ur.split("/").join("_")]=_this.bmd.clone();
				loads.shift();
				if(loads.length>0){
					loads[0][0].LoadImage(loads[0][1]);
				}else{
					tanksSlots();
				}
			});
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:Event){
				loader.name="ready";
				errCount();
			});
      loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event){
				loader.name="ready";
				errCount();
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event){
				loader.name="ready";
				errCount();
			});
			//errTest("Test...   "+url_count+"   "+ur,100);
			loader.load(new URLRequest(stg_class.res_url+"/"+ur));
			//loader.load(new URLRequest("http://85709.dyn.ufanet.ru"+"/"+ur));
			_this.stm=setTimeout(function(){
				if(loader!=null){
					if(loader.name=="wait"){
						//trace(loader.name+"   "+loader.contentLoaderInfo.url);
						loader.close();
						this["load_er"]=15;
						errCount();
					}
				}
			}, 8000);
		}
		
		public function errCount(){
			//trace("errIcon   "+this["load_er"]);
			if(this["load_er"]<2){
				this["load_er"]++;
				LoadImage(this["_link"]);
			}else{
				erPict();
				loads.shift();
				if(loads.length>0){
					loads[0][0].LoadImage(loads[0][1]);
				}else{
					tanksSlots();
				}
			}
		}
		
		public function erPict(){
			if(name!="pict"){
				clearBtn(1);
			}
			try{
				this.removeChild(this["pre_cl"]);
			}catch(er:Error){}
			var tx:TextField=new TextField();
			tx.text="er";
			tx.textColor=0xff0000;
			var bmd:BitmapData=new BitmapData(30,30,true);
			var mtrx:Matrix=new Matrix();
			mtrx.translate(width/2-tx.textWidth/2,height/2-tx.textHeight/2);
			bmd.draw(tx);
			graphics.beginBitmapFill(bmd,mtrx,false);
			try{
				graphics.drawRect(.5,.5,this["_w"]-1,this["_h"]-1);
			}catch(er:Error){
				graphics.drawRect(.5,.5,this.width-1,this.height-1);
			}
		}
		
		public function drawPict(_bmd:BitmapData){
			var _this:MovieClip=this;
			_this.bmd=_bmd.clone();
			clearBtn(1);
			graphics.beginBitmapFill(_this.bmd);
			graphics.drawRect(.5,.5,_this._w-1,_this._h-1);
			//trace(empty);
			if(empty){
				stg_cl.b_and_w(_this,1);
			}else{
				stg_cl.b_and_w(_this);
			}
		}
		
		public function drawPict1(_bmd:BitmapData){
			var _this:MovieClip=this;
			_this.bmd=_bmd.clone();
			var mtrx:Matrix=new Matrix();
			var _x:int=_this.width/2-_bmd.width/2;
			var _y:int=_this.height/2-_bmd.height/2;
			mtrx.translate(_x,_y);
			graphics.beginBitmapFill(_this.bmd,mtrx,false);
			graphics.drawRect(_x,_y,_bmd.width,_bmd.height);
		}
		
		public function clearBtn(_type:int=0){
			graphics.clear();
			graphics.lineStyle(1,990000);
			graphics.beginFill(this["_clr"]);
			graphics.drawRect(0.5,0.5,this["_w"]-1,this["_h"]-1);
			
			if(_type!=1){
				if(_type==0){
					try{
						this["max_qntty"]=0;
						this["quantity"]=0;
						this["num1"].visible=false;
						this["num2"].visible=false;
					}catch(er:Error){}
				}else{
					try{
						this["num1"].visible=false;
						this["num2"].visible=false;
					}catch(er:Error){}
				}
			}
		}
		
		public function resetBtn(){
			// сбрасывает все кнопки
			for(var i:int=0;i<clips.length;i++){
				var _a:int=int(clips[i].name.slice(3,4));
				var _b:int=int(clips[i].name.slice(5,7));
				
				clips[i].clearBtn();
				clips[i].i_text="";
				clips[i].i_name="";
				clips[i].light_col=-1;
				stg_cl.light_col1(clips[i],clips[i].light_col);
				clips[i].old_pos=[_a,_b];
				clips[i].can_put=new Array();
				clips[i].mass=0;
				clips[i].empty=true;
			}
		}
		
		public function weightTest(_i:int):Number{
			var _mass:int=0;
			for(var j:int=0;j<5;j++){
				if(arsnl_cl["sl_2_"+j]["i_name"]!=""){
					_mass+=int(arsnl_cl["sl_2_"+j].mass);
					//trace(_mass+"   "+Number(root["sl_0_"+j].sl_mass));
				}
			}
			if(_i==0)arsnl_cl["weight_tx2"].text="Вес: "+(_mass/1000);
			return (_mass);//arsnl_cl.mass_lim
		}
		
		public function sendPos(_send:String){
			/*if(!arsnl_cl["conf_win"].visible&&!arsnl_cl["warn_win"].visible&&!arsnl_cl["sell_cl"].visible){
				arsnl_cl["sell_cl"]["_clip"]=null;
				arsnl_cl["sell_cl"].visible=false;
				sendRequest([["query"],["action"]],[["id"],["id","slots"]],[["1"],["9",send_ar.join("*")]]);
			}*/
			arsnl_cl["sell_cl"]["_clip"]=null;
			arsnl_cl["sell_cl"].visible=false;
			arsnl_cl["conf_win"].visible=false;
			
			if(int(_send.substr(2,1))==6){
				var _num:int=int(_send.substr(4,1));
				_send=_send.substr(0,4)+(_num+_tanks_count)+_send.substr(5);
			}
			last_send=_send.slice(2,_send.length-2).split("},{");
			sendRequest([["query"],["action"]],[["id"],["id","slots"]],[["1"],["9",_send]]);
		}
		public var last_send:Array=null;
		
		public function replConf(_i:int,_trg:MovieClip=null){
			arsnl_cl["conf_win"].visible=true;
			arsnl_cl["conf_win"].gotoAndStop(_i);
			arsnl_cl["conf_win"]["name_tx"].text=this["i_name"];
			if(_i==2){
				arsnl_cl["conf_win"]._rp=this;
				arsnl_cl["conf_win"]._trg=_trg;
			}else{
				arsnl_cl["conf_win"]._rp=this;
				arsnl_cl["conf_win"]._trg=arsnl_cl["sl_6_0"];
			}
		}
		
		public function sellConf():void{
			arsnl_cl["sell_cl"].visible=true;
			arsnl_cl["sell_cl"]["name_tx"].text=stg_cl["drag_cl"]["i_name"]+"";
			arsnl_cl["sell_cl"]["m_m_tx"].text=this["price"]+"";
			var _mw=this["bmd"].width;
			var _mh=this["bmd"].height;
			arsnl_cl["sell_cl"]["pict_cl"].graphics.clear();
			arsnl_cl["sell_cl"]["pict_cl"].graphics.beginBitmapFill(this["bmd"]);
			arsnl_cl["sell_cl"]["pict_cl"].graphics.drawRect(0, 0, _mw, _mh);
			arsnl_cl["sell_cl"]._clip=this;
		}
		
		public function dopInv(_i:int):void{
			for(var i:int=0;i<36;i++){
				if(i<_i){
					arsnl_cl["sl_1_"+i]._clr=0xffffff;
					if((i+1)%12==0){
						arsnl_cl["sl_1_"+i].visible=true;
					}
				}else{
					arsnl_cl["sl_1_"+i]._clr=0xB6B6B6;
					if((i+1)%12==0){
						arsnl_cl["sl_1_"+i].visible=false;
					}
				}
				if(arsnl_cl["sl_1_"+i]["i_name"]==""){
					arsnl_cl["sl_1_"+i].clearBtn();
				}
			}
			for(i=0;i<3;i++){
				if(i<_i/12){
					arsnl_cl["dop_sl"+i].visible=false;
				}else{
					arsnl_cl["dop_sl"+i].visible=true;
				}
			}
		}
		
		public function canTest(_cl:MovieClip):Boolean{
			/*if(int(_cl.name.slice(3,4))<2){
				if(int(name.slice(3,4))<2){
					if(_cl._clr!=0xB6B6B6){
						return true;
					}
				}
			}*/
			for(var n:int=0;n<this["can_put"].length;n++){
				if(this["can_put"][n]==_cl){
					if(_cl._clr==0xB6B6B6){
						return false;
					}
					return true;
				}
			}
			return false;
		}
		
		public function urlInit(url:String,cl:MovieClip){
			serv_url=url;
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public function tStop(){
			try{mT.stop()}catch(er:Error){}
			hideInfo();
		}
		
		public function vip_btn(){
			super();
			Security.allowDomain("*");
			stop();
			
			if(name.slice(0,3)=="sl_"){
				var _cl:MovieClip=this;
				try{
					_cl["num1"].stop();
					_cl["num2"].stop();
					_cl["num1"].visible=false;
					_cl["num2"].visible=false;
				}catch(er:Error){}
				var _a:int=int(_cl.name.slice(3,4));
				var _b:int=int(_cl.name.slice(5,7));
				_cl.i_text="";
				_cl.i_name="";
				_cl.light_col=-1;
				stg_cl.light_col1(_cl,_cl.light_col);
				_cl.old_pos=[_a,_b];
				_cl.can_put=new Array();
				_cl.mass=0;
				dragger=true;
				empty=true;
				if(int(name.slice(3,4))==0){
					_cl._w=_cl._h=30;
					_cl._clr=0xffffff;
					//sl_type=2;
				}else if(int(name.slice(3,4))==1){
					_cl._w=_cl._h=30;
					_cl._clr=0xB6B6B6;
					if((int(name.slice(5,8))+1)%12==0){
						visible=false;
					}
					//sl_type=3;
				}else if(int(name.slice(3,4))==2){
					_cl._w=_cl._h=30;
					_cl._clr=0xffffff;
					//sl_type=4;
				}else if(int(name.slice(3,4))==3){
					_cl._w=_cl._h=30;
					_cl._clr=0xffffff;
					//sl_type=4;
				}else if(int(name.slice(3,4))==4){
					_cl._w=_cl._h=30;
					_cl._clr=0xffffff;
					//sl_type=4;
				}else if(int(name.slice(3,4))==5){
					_cl._w=_cl._h=30;
					_cl._clr=0xB6B6B6;
					//sl_type=4;
				}else if(int(name.slice(3,4))==6){
					_cl._w=80;
					_cl._h=38;
					_cl._clr=0xffffff;
					//sl_type=4;
				}
				if(int(name.slice(3,4))!=7){
					clips.push(this);
					clearBtn();
				}
			}else if(name=="vkl0"){
				vipTmUp.addEventListener(TimerEvent.TIMER, arrowUpVip);
				vipTmDn.addEventListener(TimerEvent.TIMER, arrowDnVip);
			}
			
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
		}
		
		public static function ch_num(_cl:MovieClip){
			// меняет число вналичии для слота
			try{
				if(_cl.quantity>1){
					_cl.num1.visible=true;
					_cl.num2.visible=true;
				}else{
					_cl.num1.visible=false;
					_cl.num2.visible=false;
					return;
				}
				////trace("panel num "+_cl.num1.visible);
				if(_cl.quantity<100){
					if(_cl.quantity>=0){
						_cl.num1.gotoAndStop((int(_cl.quantity/10))+1);
						_cl.num2.gotoAndStop((int(_cl.quantity%10))+1);
					}
				}else{
					_cl.num1.gotoAndStop(11);
					_cl.num2.gotoAndStop(11);
				}
				//trace("ch_num ready: "+_cl.calc+"   "+_cl.quantity+"   "+_cl.num1);
			}catch(er:Error){
				//trace("ch_num error: "+_cl.name+"   "+er);
			}
		}
		
		public function tw_over(event:MouseEvent){
			//trace("tw_over");
			var _this:MovieClip=(event.currentTarget as MovieClip);
			//trace(_this);
			if(stg_cl["wall_win"]){
				return;
			}
			if(stg_cl["warn_er"]){
				return;
			}
			if(stg_cl["drag_cl"]!=null){
				if(int(stg_cl["drag_cl"]["prnt"].name.slice(3,4))==6){
					stg_cl.overTest(_this,1);
				}
			}
			//trace(stg_cl["drag_cl"]);
		}
		
		public function tw_out(event:MouseEvent){
			var _this:MovieClip=(event.currentTarget as MovieClip);
			if(stg_cl["drag_cl"]!=null){
				if(int(stg_cl["drag_cl"]["prnt"].name.slice(3,4))==6){
					stg_cl.overTest(_this,0);
				}
			}
		}
		
		public function tw_release(event:MouseEvent){
			var _this:MovieClip=(event.currentTarget as MovieClip);
			if(stg_cl["wall_win"]){
				return;
			}
			if(stg_cl["warn_er"]){
				return;
			}
			if(stg_cl["drag_cl"]!=null){
				stg_cl.unDrag(_this);
			}
		}
		
		public function showInfo(info_str:String,X:int,Y:int,H:int,_do:DisplayObject=null){
			//trace("c   "+stg_cl+"   "+stg_class.vip_cl);
			//stg_cl.setChildIndex(stg_class.vip_cl,stg_cl.numChildren-1);
			//trace("a");
			var txf:TextField=stg_class.vip_cl["info_tx"];
			var _dsp:MovieClip=MovieClip(stg_class.vip_cl["exit_cl"].root);
			if(_do!=null){
				_dsp=MovieClip(_do);
				txf=_dsp["info_tx"];
			}
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
			if(txf.x<0){
				txf.x=10;
			}else if(txf.x+txf.width+10>_dsp.width){
				txf.x=_dsp.width-(txf.width+10);
			}
			var info_w:int=txf.width;
			var info_h:int=txf.height;
			var info_rw:int=10;
			var info_rh:int=10;
			_dsp["stg"].mouseEnabled=txf.mouseEnabled=false;
			_dsp["stg"].graphics.lineStyle(1, 0x000000, 1, true);
			_dsp["stg"].graphics.beginFill(0x990700,1);
			_dsp["stg"].graphics.drawRoundRect(txf.x-3, txf.y, info_w+10, info_h+2, info_rw, info_rh);
			_dsp.setChildIndex(_dsp["stg"],_dsp.numChildren-1);
			_dsp.setChildIndex(txf,_dsp.numChildren-1);
			//trace("b");
			txf.visible=true;
		}
		
		public function hideInfo(_do:DisplayObject=null){
			var txf:TextField=stg_class.vip_cl["info_tx"];
			var _dsp:MovieClip=MovieClip(stg_class.vip_cl["exit_cl"].root);
			if(_do!=null){
				_dsp=MovieClip(_do);
				txf=_dsp["info_tx"];
			}
			txf.visible=false;
			_dsp["stg"].graphics.clear();
		}
		
		public function setVkl(_i:int){
			for(var i:int=0;i<4;i++){
				if(root["vkl"+i]!=this){
					root["vkl"+i].gotoAndStop("out");
				}else{
					root["vkl"+i].gotoAndStop("press");
					if(_i==1){
						if(i==1){
							sendRequest(["query","action"],[["id"],["id"]],[["1"],["4"]]);
						}else if(i==3){
							sendRequest(["query","action"],[["id"],["id"]],[["1"],["10"]]);
						}else if(i==0){
							sendRequest(["query","action"],[["id"],["id","type"]],[["2"],["11","-1"]]);
						}else if(i==2){
							sendRequest(["query","action"],[["id"],["id","type"]],[["1"],["5"]]);
						}
					}
				}
			}
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["wall_win"]){
				return;
			}
			if(closed){
				return;
			}
			if(stg_cl["warn_er"]){
				return;
			}
			if(stg_cl["drag_cl"]!=null){
				if(name.slice(0,3)=="sl_"){
					if(this["_clr"]!=0xB6B6B6){
						stg_cl.overTest1(this,1);
						return;
					}else{
						return;
					}
				}else{
					return;
				}
			}
			Mouse.cursor=MouseCursor.BUTTON;
			//try{
				if(name.slice(0,2)=="sl"){
					if(this["_clr"]!=0xB6B6B6){
						stg_cl.overTest1(this,1);
						//stg_cl.canDrag(this,1);
						if(this["i_name"]!=""){
							var _mc:MovieClip=this;
							mT=new Timer(200, 1);
							mT.addEventListener(TimerEvent.TIMER_COMPLETE, function(){
								showInfo(_mc["i_text"]+"",_mc.x+_mc.parent.x-12,_mc.y+_mc.parent.y+7,_mc.height);
							});
							mT.start();
						}
					}else{
						Mouse.cursor=MouseCursor.AUTO;
					}
					return;
				}else if(name.slice(0,5)=="info_"){
					showInfo(this["i_text"]+"",x+parent.x-15,y+parent.y,height);
				}else if(name=="pict"){
					var _pnt:Point=localToGlobal(new Point(x,y));
					showInfo(this["i_text"]+"",_pnt.x-15,_pnt.y-15,height,this.root);
				}else if(name=="info"){
					var _pnt:Point=localToGlobal(new Point(x,y));
					showInfo(this["i_text"]+"",_pnt.x-15,_pnt.y,height,this.root);
				}else if(name.slice(0,3)!="vkl"){
					if(currentFrameLabel!="empty"){
						gotoAndStop("over");
					}
				}else{
					if(currentFrameLabel!="press"){
						gotoAndStop("over");
					}
				}
			//}catch(er:Error){}
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["wall_win"]){
				return;
			}
			if(closed){
				return;
			}
			if(stg_cl["warn_er"]){
				return;
			}
			if(stg_cl["drag_cl"]!=null){
				if(name.slice(0,3)=="sl_"){
					stg_cl.overTest1(this,0);
					return;
				}else{
					return;
				}
			}
			Mouse.cursor=MouseCursor.AUTO;
			//try{
				if(name.slice(0,2)=="sl"){
					stg_cl.overTest1(this,0);
					//stg_cl.canDrag(this,0);
					tStop();
				}else if(name.slice(0,5)=="info_"){
					hideInfo();
				}else if(name=="pict"){
					hideInfo(this.root);
				}else if(name=="info"){
					hideInfo(this.root);
				}else if(name.slice(0,3)!="vkl"){
					if(currentFrameLabel!="empty"){
						gotoAndStop("out");
					}
				}else{
					if(currentFrameLabel!="press"){
						gotoAndStop("out");
					}
				}
			//}catch(er:Error){}
		}
		
		public function stop_iter(event:MouseEvent){
			try{
				stage.removeEventListener(Event.ENTER_FRAME, obm_iter);
			}catch(er:Error){}
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, stop_iter);
			}catch(er:Error){}
			iter_c=0;
		}
		
		public function start_iter(){
			stop_iter(new MouseEvent(MouseEvent.MOUSE_UP));
			stage.addEventListener(MouseEvent.MOUSE_UP, stop_iter);
			stage.addEventListener(Event.ENTER_FRAME, obm_iter);
		}
		
		public function obm_iter(event:Event){
			if(iter_c>30){
				iter_fund.apply(iter_clip);
			}else if(iter_c>15&&iter_c%2==0){
				iter_fund.apply(iter_clip);
			}else if(iter_c>5&&iter_c%5==0){
				iter_fund.apply(iter_clip);
			}else if(iter_c%10==0){
				iter_fund.apply(iter_clip);
			}
			iter_c++;
		}
		
		public static var iter_fund:Function;
		public static var iter_clip:MovieClip;
		public static var iter_c:int=0;
		
		public function m_press(event:MouseEvent){
			if(stg_cl["wall_win"]){
				return;
			}
			if(closed){
				return;
			}
			if(stg_cl["warn_er"]){
				return;
			}
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(name.slice(0,3)=="sl_"){
				//arsnl_cl["sell_cl"].visible=false;
				if(this["i_name"]!=""){
					if(!arsnl_cl["conf_win"].visible&&!arsnl_cl["warn_win"].visible&&!arsnl_cl["sell_cl"].visible){
						arsnl_cl["sell_cl"]["_clip"]=null;
						tStop();
						stg_cl.dragBegin(this);
						stg_cl.canDrag(this,1);
					}
				}
			}else if(name=="left_iter"){
				stg_cl.addEventListener(Event.ENTER_FRAME, lev_cl._l_num);
			}else if(name=="right_iter"){
				stg_cl.addEventListener(Event.ENTER_FRAME, lev_cl._r_num);
			}else if(name=="sc_rect"){
				parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
				if(event.currentTarget.parent.name=="sc_vip"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scVipStop);
					stage.addEventListener(Event.ENTER_FRAME, btn_scrollVip);
				}
			}else if(name=="sc_mover"){
				event.currentTarget.x_coor=event.currentTarget.mouseX;
				if(event.currentTarget.parent.name=="sc_vip"){
					stage.addEventListener(MouseEvent.MOUSE_UP, scVipStop);
					stage.addEventListener(Event.ENTER_FRAME, btn_scrollVip);
				}
			}else if(name=="to_left"){
				if(event.currentTarget.parent.name=="sc_vip"){
					if(!vipTmUp.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowVipStop);
						vipTmUp.start();
					}
				}
			}else if(name=="to_right"){
				if(event.currentTarget.parent.name=="sc_vip"){
					if(!vipTmDn.running){
						parent["sc_mover"].x_coor=parent["sc_mover"].width/2;
						stage.addEventListener(MouseEvent.MOUSE_UP, arrowVipStop);
						vipTmDn.start();
					}
				}
			}else if(name=="tank_scr_r"){
				tanksSlotsChng(1);
			}else if(name=="tank_scr_l"){
				tanksSlotsChng(-1);
			}else{
				try{
					if(name.slice(0,3)!="vkl"){
						if(currentFrameLabel!="empty"){
							if(name.slice(0,8)=="left_obm"){
								iter_clip=this;
								iter_fund=function(){
									parent["num_tx"+int(name.slice(8,10))].text=int(parent["num_tx"+int(name.slice(8,10))].text)-this["_step"];
									if(int(parent["num_tx"+int(name.slice(8,10))].text)<0){
										parent["num_tx"+int(name.slice(8,10))].text=0;
									}
									parent["num1_tx"+int(name.slice(8,10))].text=int(parent["num_tx"+int(name.slice(8,10))].text)/this["_step"];
								}
								start_iter();
							}else if(name.slice(0,9)=="right_obm"){
								iter_clip=this;
								iter_fund=function(){
									parent["num_tx"+int(name.slice(9,11))].text=int(parent["num_tx"+int(name.slice(9,11))].text)+this["_step"];
									if(int(parent["num_tx"+int(name.slice(9,11))].text)>stg_class.shop["exit"].getMoneys(this["_type"])){
										parent["num_tx"+int(name.slice(9,11))].text=stg_class.shop["exit"].getMoneys(this["_type"]);
									}
									parent["num1_tx"+int(name.slice(9,11))].text=int(parent["num_tx"+int(name.slice(9,11))].text)/this["_step"];
								}
								start_iter();
							}
							gotoAndStop("press");
						}
					}else{
						if(currentFrameLabel!="press"){
							/*if(name=="vkl2"){
								return;
							}*/
							setVkl(1);
						}
					}
				}catch(er:Error){}
			}
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["wall_win"]){
				return;
			}
			if(closed){
				return;
			}
			if(stg_cl["warn_er"]){
				return;
			}
			if(currentFrameLabel=="empty"){
				return;
			}
			if(stg_cl["drag_cl"]!=null){
				if(name.slice(0,3)=="sl_"){
					stg_cl.unDrag(this);
				}else{
					return;
				}
			}
			if(name=="exit_cl"||name=="exit_cl1"){
				vipReset();
			}else if(name=="help_cl"){
				stg_cl.createMode(10);
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
			}else if(name=="conf_y"){
=======
			}/*else if(name=="help_cl"){
				stg_cl.createMode(10);
			}*/else if(name=="conf_y"){
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
				var _rp:MovieClip=arsnl_cl["conf_win"]._rp;
				var _trg:MovieClip=arsnl_cl["conf_win"]._trg;
				sendPos("{{"+_rp.old_pos.join(",")+"},{"+_trg.old_pos.join(",")+"},{"+_rp.ID+","+_rp.quantity+"}}");
			}else if(name=="exit_obm"){
				root["obmen"].visible=false;
			}else if(name=="close_lev"||name=="close_lev1"){
				parent.parent.removeChild(parent);
				try{
					weap_cl["lev_line_b"].graphics.clear();
					weap_cl.parent.addChild(weap_cl["sc_clip"]);
					try{
						weap_cl.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollVip);
					}catch(er:Error){}
					/*var _rct:Rectangle=weap_cl.scrollRect;
					_rct.y=weap_cl["_sc_y"];
					weap_cl.scrollRect=_rct;*/
					weap_cl.addEventListener(MouseEvent.MOUSE_WHEEL, scrollVip);
				}catch(er:Error){}
			}else if(name=="close_ar_lev"||name=="close_ar_lev1"){
				root["exit_cl"].setArend();
			}else if(name=="left_cl"){
				if(parent["moveTm"]==null){
					(parent as MovieClip).moveTm=new Timer(5,25);
				}
				if(!parent["moveTm"].running){
					parent["_vect"]=0;
					(parent as MovieClip).moveTm=new Timer(5,25);
					var tm_fnc:Function=function(event:TimerEvent){
						var _tm:Timer=(event.currentTarget as Timer);
						var _X:int=parent["_pos"]*parent["sc_w"];
						if(parent["_vect"]==0){
							_X-=(_tm.currentCount/_tm.repeatCount)*parent["sc_w"];
						}else{
							_X+=(_tm.currentCount/_tm.repeatCount)*parent["sc_w"];
						}
						if(event.type==TimerEvent.TIMER_COMPLETE){
							if(parent["_vect"]==0){
								parent["_pos"]--;
							}else{
								parent["_pos"]++;
							}
							_X=parent["_pos"]*parent["sc_w"];
							if(parent["_pos"]>=parent["_len"]-parent["_lim"]){
								parent["right_cl"].gotoAndStop("empty");
							}else{
								parent["right_cl"].gotoAndStop("out");
							}
							if(parent["_pos"]==0){
								parent["left_cl"].gotoAndStop("empty");
							}else{
								parent["left_cl"].gotoAndStop("out");
							}
							//trace(parent["_pos"]);
						}
						if(parent["rzd_type"]==0){
							parent["rect"].scrollRect=new Rectangle(_X,0,(parent["sc_w"]*3-3),parent["sc_h"]+1);
						}else{
							parent["rect"].scrollRect=new Rectangle(_X,0,(parent["sc_w"]*6-3),parent["sc_h"]+1);
						}
					}
					parent["moveTm"].addEventListener(TimerEvent.TIMER, tm_fnc);
					parent["moveTm"].addEventListener(TimerEvent.TIMER_COMPLETE, tm_fnc);
					parent["moveTm"].start();
				}
			}else if(name=="right_cl"){
				if(parent["moveTm"]==null){
					(parent as MovieClip).moveTm=new Timer(5,25);
				}
				if(!parent["moveTm"].running){
					parent["_vect"]=1;
					(parent as MovieClip).moveTm=new Timer(5,25);
					var tm_fnc:Function=function(event:TimerEvent){
						var _tm:Timer=(event.currentTarget as Timer);
						var _X:int=parent["_pos"]*parent["sc_w"];
						if(parent["_vect"]==0){
							_X-=(_tm.currentCount/_tm.repeatCount)*parent["sc_w"];
						}else{
							_X+=(_tm.currentCount/_tm.repeatCount)*parent["sc_w"];
						}
						if(event.type==TimerEvent.TIMER_COMPLETE){
							if(parent["_vect"]==0){
								parent["_pos"]--;
							}else{
								parent["_pos"]++;
							}
							_X=parent["_pos"]*parent["sc_w"];
							if(parent["_pos"]>=parent["_len"]-parent["_lim"]){
								parent["right_cl"].gotoAndStop("empty");
							}else{
								parent["right_cl"].gotoAndStop("out");
							}
							if(parent["_pos"]==0){
								parent["left_cl"].gotoAndStop("empty");
							}else{
								parent["left_cl"].gotoAndStop("out");
							}
							//trace(parent["_pos"]);
						}
						if(parent["rzd_type"]==0){
							parent["rect"].scrollRect=new Rectangle(_X,0,(parent["sc_w"]*3-3),parent["sc_h"]+1);
						}else{
							parent["rect"].scrollRect=new Rectangle(_X,0,(parent["sc_w"]*6-3),parent["sc_h"]+1);
						}
					}
					parent["moveTm"].addEventListener(TimerEvent.TIMER, tm_fnc);
					parent["moveTm"].addEventListener(TimerEvent.TIMER_COMPLETE, tm_fnc);
					parent["moveTm"].start();
				}
			}else if(name=="show_info"){
				sendRequest(["query","action"],[["id"],["id","id_mod"]],[["1"],[6+"",this["ID"]+""]]);
				gotoAndStop("out");
			}else if(name=="buy_mod"){
				//sendRequest(["query","action"],[["id"],["id","id_mod","val_type"]],[["1"],[7+"",this["ID"]+"",this["vals"]]]);
				if(this["tank"]==0){
					weap_cl["win_cl"].y=71+weap_cl.scrollRect.y;
					weap_cl["win_cl"].visible=true;
					weap_cl.setChildIndex(weap_cl["win_cl"],weap_cl.numChildren-1);
					
					weap_cl["win_cl"]["mod_ar"].ID=weap_cl["win_cl"]["mod_ot"].ID=weap_cl["win_cl"]["mod_sn"].ID=this["ID"];
					weap_cl["win_cl"]["name_tx"].text=parent["name_tx"].text;
					for(var i:int=1;i<5;i++){
						if(this["dscr"+i]!=null){
							weap_cl["win_cl"]["param"+i].text=this["dscr"+i];
						}
					}
					weap_cl["win_cl"]["param1"].text=this["info_ar"][0];
					weap_cl["win_cl"]["param2"].text=this["info_ar"][1];
					weap_cl["win_cl"]["param3"].text=this["info_ar"][2];
					weap_cl["win_cl"]["param4"].text=this["info_ar"][3];
					if(this["vals"][2]>0){
						weap_cl["win_cl"]["mod_ar"].visible=true;
					}else{
						weap_cl["win_cl"]["mod_ar"].visible=false;
					}
					weap_cl["win_cl"]["mod_ar"].vals=weap_cl["win_cl"]["mod_ot"].vals=[this["vals"][0],this["vals"][1],this["vals"][2],0];
					weap_cl["win_cl"]["mod_sn"].vals=[0,0,0,1];
					
					weap_cl["win_cl"]["val"+1+"_tx"].text=weap_cl["win_cl"]["m_"+1+"_tx"].text="";
					weap_cl["win_cl"]["val"+2+"_tx"].text=weap_cl["win_cl"]["m_"+2+"_tx"].text="";
					var _c:int=0;
					for(var i:int=0;i<this["price"].length;i++){
						if(this["price"][i]>0){
							weap_cl["win_cl"]["val"+(_c+1)+"_tx"].text="Цена в "+stg_class.shop["exit"].m_name(0,i,2)+": ";
							weap_cl["win_cl"]["m_"+(_c+1)+"_tx"].text=this["price"][i];
							if(_c==0){
								if(stg_class.shop["exit"].getMoneys(i)>=this["price"][i]){
									weap_cl["win_cl"]["mod_ar"].gotoAndStop("out");
								}else{
									weap_cl["win_cl"]["mod_ar"].gotoAndStop("empty");
								}
							}else{
								break;
							}
							_c++;
						}
					}
					try{
						weap_cl["win_cl"]["pict_cl"].graphics.clear();
						weap_cl["win_cl"]["pict_cl"].graphics.beginBitmapFill(parent["pict"]["bmd"]);
						weap_cl["win_cl"]["pict_cl"].graphics.drawRect(0,0,parent["pict"]["bmd"].width,parent["pict"]["bmd"].height);
					}catch(er:Error){}
				}else{
					
					//weap_cl["buy_tank"]["m_ar_tx"].text=vip_ar[0][this["_num"]][3];
					weap_cl["buy_tank"]["tank_ar"].alpha=1;
					weap_cl["buy_tank"]["tank_ar"]["closed"]=false;
					
					//weap_cl["buy_tank"]["m_val_tx"].text=vip_ar[0][this["_num"]][4];
					weap_cl["buy_tank"]["tank_sn"].alpha=1;
					weap_cl["buy_tank"]["tank_sn"]["closed"]=false;
					
					weap_cl["buy_tank"].y=71+weap_cl.scrollRect.y;
					weap_cl["buy_tank"].visible=true;
					weap_cl.setChildIndex(weap_cl["buy_tank"],weap_cl.numChildren-1);
					weap_cl["buy_tank"]["tank_ar"].ID=weap_cl["buy_tank"]["tank_sn"].ID=this["ID"];
					weap_cl["buy_tank"]["name_tx"].text=parent["name_tx"].text;
					weap_cl["buy_tank"]["tx0"].text=this["info_ar"][0];
					weap_cl["buy_tank"]["tx1"].text=this["info_ar"][1];
					weap_cl["buy_tank"]["tx2"].text=this["info_ar"][2];
					weap_cl["buy_tank"]["tank_ar"].vals=[this["vals"][0],this["vals"][1],this["vals"][2],0];
					weap_cl["buy_tank"]["tank_sn"].vals=[0,0,0,1];
					
					weap_cl["buy_tank"]["val"+1+"_tx"].text=weap_cl["buy_tank"]["m_"+1+"_tx"].text="";
					weap_cl["buy_tank"]["val"+2+"_tx"].text=weap_cl["buy_tank"]["m_"+2+"_tx"].text="";
					var _c:int=0;
					for(var i:int=0;i<this["price"].length;i++){
						if(this["price"][i]>0){
							weap_cl["buy_tank"]["val"+(_c+1)+"_tx"].text="Цена в "+stg_class.shop["exit"].m_name(0,i,2)+": ";
							weap_cl["buy_tank"]["m_"+(_c+1)+"_tx"].text=this["price"][i];
							if(_c==0){
								if(stg_class.shop["exit"].getMoneys(i)>=this["price"][i]){
									weap_cl["buy_tank"]["tank_ar"].gotoAndStop("out");
								}else{
									weap_cl["buy_tank"]["tank_ar"].gotoAndStop("empty");
								}
							}else{
								break;
							}
							_c++;
						}
					}
					try{
						weap_cl["buy_tank"]["pict_cl"].graphics.clear();
						weap_cl["buy_tank"]["pict_cl"].graphics.beginBitmapFill(parent["pict"]["bmd"]);
						weap_cl["buy_tank"]["pict_cl"].graphics.drawRect(0,0,parent["pict"]["bmd"].width,parent["pict"]["bmd"].height);
					}catch(er:Error){}
				}
				try{
					weap_cl["buy_over"]["name_tx"].text=parent["name_tx"].text;
					weap_cl["buy_over"]["pict_cl"].graphics.clear();
					weap_cl["buy_over"]["pict_cl"].graphics.beginBitmapFill(parent["pict"]["bmd"]);
					weap_cl["buy_over"]["pict_cl"].graphics.drawRect(0,0,parent["pict"]["bmd"].width,parent["pict"]["bmd"].height);
				}catch(er:Error){}
			}else if(name=="left_iter"){
				lev_cl._rem_num();
			}else if(name=="right_iter"){
				lev_cl._rem_num();
			}else if(name=="close_iter"){
				lev_cl["spets_weap"].visible=false;
			}else if(name=="iter_buy"){
				lev_cl._buy_fnc(lev_cl["spets_weap"].iter_num.text);
			}else if(name=="buy_ar"){
				if(parent.parent==lev_cl){
					if(lev_cl._counted){
						var _this:MovieClip=this;
						lev_cl._buy_fnc=function(_fnc_cnt:int){
							lev_cl["spets_weap"].visible=false;
							sendRequest(["query","action"],[["id"],["id","id_mod","val_type","qntty"]],[["1"],[7+"",_this["ID"]+"",_this["vals"].join("|"),_fnc_cnt]]);
						};
						var _spec_price:Array=this["val_tx"].split(" ");
						
						var _spec_tx:TextField=lev_cl["spets_weap"].iter_num;
						var _fnc:Function=function(e1:Event=null){
							lev_cl._buy_num(0);
						};
						lev_cl._l_num=function(e1:Event=null){
							lev_cl._buy_num(-1);
						};
						lev_cl._r_num=function(e1:Event=null){
							lev_cl._buy_num(1);
						};
						var _fnc1:Function=function(e1:Event=null){
							lev_cl.removeEventListener(Event.REMOVED_FROM_STAGE, _fnc1);
							_spec_tx.removeEventListener(Event.CHANGE, _fnc);
							lev_cl._rem_num();
						};
						lev_cl._rem_num=function(e1:Event=null){
							try{stg_cl.removeEventListener(Event.ENTER_FRAME, lev_cl._l_num);}catch(er:Error){}
							try{stg_cl.removeEventListener(Event.ENTER_FRAME, lev_cl._r_num);}catch(er:Error){}
						};
						_spec_tx.addEventListener(Event.CHANGE, _fnc);
						lev_cl.addEventListener(Event.REMOVED_FROM_STAGE, _fnc1);
						//trace("_spec_price="+_spec_price);
						var _num_price:Number=_spec_price[1];
						var _name_price:String=_spec_price.slice(2).join(" ");
						lev_cl._buy_num=function(_fnc_num:int){
							_fnc_num=int(_spec_tx.text)+_fnc_num;
							if(_fnc_num<1){
								_fnc_num=1;
							}else if(_fnc_num>9999){
								_fnc_num=9999;
							}
							_spec_tx.text=_fnc_num+"";
							lev_cl["spets_weap"].iter_price.text=(_num_price*_fnc_num);
						};
						lev_cl["spets_weap"].visible=true;
						lev_cl.setChildIndex(lev_cl["spets_weap"],lev_cl.numChildren-1);
						_spec_tx.text="1";
						lev_cl["spets_weap"].name_tx.text=parent["tx0"].text;
						lev_cl["spets_weap"].iter_name.text="шт.";
						lev_cl["spets_weap"].iter_price.text=_num_price;
						gotoAndStop("over");
						return;
					}
				}
				parent.parent["win_cl"].visible=true;
				parent.parent["win_cl"].y=71/*+weap_cl.scrollRect.y*/;
				parent.parent.setChildIndex(parent.parent["win_cl"],parent.parent.numChildren-1);
				parent.parent["win_cl"].ID=this["ID"];
				parent.parent["win_cl"].vals=this["vals"].join("|");
				parent.parent["win_cl"]["name_tx"].text=parent["tx0"].text;
				parent.parent["win_cl"]["val_tx"].text=this["val_tx"];
				//parent.parent["win_cl"]["price_tx"].text=this["pr_num"];
				parent.parent["win_cl"]["pict_cl"].graphics.clear();
				parent.parent["win_cl"]["pict_cl"].graphics.beginBitmapFill(parent["pict"].bitmapData);
				parent.parent["win_cl"]["pict_cl"].graphics.drawRect(0,0,parent["pict"].width,parent["pict"].height);
				try{
					weap_cl["buy_over"]["name_tx"].text=parent["tx0"].text;
					weap_cl["buy_over"]["pict_cl"].graphics.clear();
					weap_cl["buy_over"]["pict_cl"].graphics.beginBitmapFill(parent["pict"].bitmapData);
					weap_cl["buy_over"]["pict_cl"].graphics.drawRect(0,0,parent["pict"].width,parent["pict"].height);
				}catch(er:Error){}
			}else if(name=="buy_val"){
				if(parent.parent==lev_cl){
					if(lev_cl._counted){
						var _this:MovieClip=this;
						lev_cl._buy_fnc=function(_fnc_cnt:int){
							lev_cl["spets_weap"].visible=false;
							sendRequest(["query","action"],[["id"],["id","id_mod","val_type","qntty"]],[["1"],[7+"",_this["ID"]+"",_this["vals"].join("|"),_fnc_cnt]]);
						};
						var _spec_tx:TextField=lev_cl["spets_weap"].iter_num;
						var _fnc:Function=function(e1:Event=null){
							lev_cl._buy_num(0);
						};
						lev_cl._l_num=function(e1:Event=null){
							lev_cl._buy_num(-1);
						};
						lev_cl._r_num=function(e1:Event=null){
							lev_cl._buy_num(1);
						};
						var _fnc1:Function=function(e1:Event=null){
							lev_cl.removeEventListener(Event.REMOVED_FROM_STAGE, _fnc1);
							_spec_tx.removeEventListener(Event.CHANGE, _fnc);
							lev_cl._rem_num();
						};
						lev_cl._rem_num=function(e1:Event=null){
							try{stg_cl.removeEventListener(Event.ENTER_FRAME, lev_cl._l_num);}catch(er:Error){}
							try{stg_cl.removeEventListener(Event.ENTER_FRAME, lev_cl._r_num);}catch(er:Error){}
						};
						_spec_tx.addEventListener(Event.CHANGE, _fnc);
						lev_cl.addEventListener(Event.REMOVED_FROM_STAGE, _fnc1);
						//trace("_spec_price="+_spec_price);
						var _num_price:Number=this["pr_num"];
						lev_cl._buy_num=function(_fnc_num:int){
							_fnc_num=int(_spec_tx.text)+_fnc_num;
							if(_fnc_num<1){
								_fnc_num=1;
							}else if(_fnc_num>9999){
								_fnc_num=9999;
							}
							_spec_tx.text=_fnc_num+"";
							lev_cl["spets_weap"].iter_price.text=(_num_price*_fnc_num);
						};
						lev_cl["spets_weap"].visible=true;
						lev_cl.setChildIndex(lev_cl["spets_weap"],lev_cl.numChildren-1);
						_spec_tx.text="1";
						lev_cl["spets_weap"].name_tx.text=parent["tx0"].text;
						lev_cl["spets_weap"].iter_name.text="шт.";
						lev_cl["spets_weap"].iter_price.text=_num_price;
						gotoAndStop("over");
						return;
					}
				}
				parent.parent["win_cl"].visible=true;
				parent.parent["win_cl"].y=71/*+weap_cl.scrollRect.y*/;
				parent.parent.setChildIndex(parent.parent["win_cl"],parent.parent.numChildren-1);
				parent.parent["win_cl"].ID=this["ID"];
				parent.parent["win_cl"].vals="0|0|0|1";
				parent.parent["win_cl"]["name_tx"].text=parent["tx0"].text;
				parent.parent["win_cl"]["val_tx"].text="Цена в "+stg_class.shop["exit"].m_name(0,3,2)+": "+this["pr_num"];
				//parent.parent["win_cl"]["price_tx"].text=this["pr_num"];
				parent.parent["win_cl"]["pict_cl"].graphics.clear();
				parent.parent["win_cl"]["pict_cl"].graphics.beginBitmapFill(parent["pict"].bitmapData);
				parent.parent["win_cl"]["pict_cl"].graphics.drawRect(0,0,parent["pict"].width,parent["pict"].height);
				try{
					weap_cl["buy_over"]["name_tx"].text=parent["tx0"].text;
					weap_cl["buy_over"]["pict_cl"].graphics.clear();
					weap_cl["buy_over"]["pict_cl"].graphics.beginBitmapFill(parent["pict"].bitmapData);
					weap_cl["buy_over"]["pict_cl"].graphics.drawRect(0,0,parent["pict"].width,parent["pict"].height);
				}catch(er:Error){}
			}else if(name=="buy_cl"){
				weap_cl["buy_tank"]["val1_tx"].text="Цена в "+stg_class.shop["exit"].m_name(0,2,2)+": ";
				
				//weap_cl["buy_tank"]["m_ar_tx"].text=vip_ar[0][this["_num"]][3];
				weap_cl["buy_tank"]["tank_ar"].alpha=1;
				weap_cl["buy_tank"]["tank_ar"]["closed"]=false;
				
				weap_cl["buy_tank"]["val2_tx"].text="Цена в "+stg_class.shop["exit"].m_name(0,3,2)+": ";
				
				//weap_cl["buy_tank"]["m_val_tx"].text=vip_ar[0][this["_num"]][4];
				weap_cl["buy_tank"]["tank_sn"].alpha=1;
				weap_cl["buy_tank"]["tank_sn"]["closed"]=false;
				
				weap_cl["buy_tank"].visible=true;
				weap_cl["buy_tank"].y=71+weap_cl.scrollRect.y;
				weap_cl.setChildIndex(weap_cl["buy_tank"],weap_cl.numChildren-1);
				weap_cl["buy_tank"]["tank_ar"].ID=weap_cl["buy_tank"]["tank_sn"].ID=this["ID"];
				weap_cl["buy_tank"]["name_tx"].text=parent["name_tx"].text;
				weap_cl["buy_tank"]["tx0"].text=parent["t_tx0"].text;
				weap_cl["buy_tank"]["tx1"].text=parent["t_tx1"].text;
				weap_cl["buy_tank"]["pict_cl"].graphics.clear();
				weap_cl["buy_tank"]["pict_cl"].graphics.beginBitmapFill(parent["pict"].bitmapData);
				weap_cl["buy_tank"]["pict_cl"].graphics.drawRect(0,0,parent["pict"].width,parent["pict"].height);
				try{
					weap_cl["buy_over"]["name_tx"].text=parent["name_tx"].text;
					weap_cl["buy_over"]["pict_cl"].graphics.clear();
					weap_cl["buy_over"]["pict_cl"].graphics.beginBitmapFill(parent["pict"].bitmapData);
					weap_cl["buy_over"]["pict_cl"].graphics.drawRect(0,0,parent["pict"].width,parent["pict"].height);
				}catch(er:Error){}
			}else if(name=="yes_cl"){
				if(parent.name=="win_cl"){
					//trace(parent["ID"]+"   "+parent["vals"]);
					if(parent.parent==lev_cl||parent.parent==weap_cl){
						
						//trace(parent["ID"]+"   "+parent["vals"]);
						sendRequest(["query","action"],[["id"],["id","id_mod","val_type"]],[["1"],[7+"",parent["ID"]+"",parent["vals"]]]);
					}
				}else if(parent.name=="sell_cl"){
					sendPos("{{"+parent["_clip"]["old_pos"].join(",")+"},{100,0},{"+parent["_clip"].ID+","+parent["_clip"].quantity+"}}");
					//sendRequest([["query"],["action"]],[["id"],["id","id_mod","movie_from","movie_to","movie_to_point"]],[["1"],["8",parent["_clip"]["ID"]+"",parent["_clip"]["old_pos"].join(":"),100+"",0+""]]);
				}
			}else if(name=="mod_ar"||name=="mod_ot"){
				//trace("mod_ar   "+parent["ID"]+"   "+parent["vals"]+"   "+this["ID"]+"   "+String(this["vals"]).split(",").join("|"));
				sendRequest(["query","action"],[["id"],["id","id_mod","val_type"]],[["1"],[7+"",this["ID"]+"",String(this["vals"]).split(",").join("|")]]);
			}else if(name=="mod_sn"){
				//trace("mod_sn   "+parent["ID"]+"   "+parent["vals"]+"   "+this["ID"]+"   "+String(this["vals"]).split(",").join("|"));
				sendRequest(["query","action"],[["id"],["id","id_mod","val_type"]],[["1"],[7+"",this["ID"]+"",String(this["vals"]).split(",").join("|")]]);
			}else if(name=="no_cl"){
				parent.visible=false;
			}else if(name=="close_cl"){
				parent.visible=false;
			}else if(name=="tank_ar"){
				//trace("tank_ar   "+parent["ID"]+"   "+parent["vals"]+"   "+this["ID"]+"   "+this["vals"]);
				//sendRequest(["query","action"],[["id"],["id","skin_id","val"]],[["2"],[13+"",parent["ID"]+"",0+""]]);
				//trace("tank_ar   "+parent["ID"]+"   "+parent["vals"]+"   "+this["ID"]+"   "+String(this["vals"]).split(",").join("|"));
				sendRequest(["query","action"],[["id"],["id","id_mod","val_type"]],[["1"],[7+"",this["ID"]+"",String(this["vals"]).split(",").join("|")]]);
			}else if(name=="tank_sn"){
				//trace("tank_sn   "+parent["ID"]+"   "+parent["vals"]+"   "+this["ID"]+"   "+this["vals"]);
				//sendRequest(["query","action"],[["id"],["id","skin_id","val"]],[["2"],[13+"",parent["ID"]+"",1+""]]);
				//trace("tank_sn   "+parent["ID"]+"   "+parent["vals"]+"   "+this["ID"]+"   "+String(this["vals"]).split(",").join("|"));
				sendRequest(["query","action"],[["id"],["id","id_mod","val_type"]],[["1"],[7+"",this["ID"]+"",String(this["vals"]).split(",").join("|")]]);
			}else if(name.slice(0,8)=="buy_pack"){
				parent["win_cl"].visible=true;
				parent["win_cl"].ID=this["ID"];
				parent["win_cl"]["name_tx"].text=parent["rang_tx"+name.slice(8,9)].text;
				parent["win_cl"]["price_tx"].text="Цена в "+stg_class.shop["exit"].m_name(0,3,2)+": "+this["price"];
				var _bm:BitmapData;
				if(int(name.slice(8,9))==4){
					_bm=new rang1();
				}else if(int(name.slice(8,9))==6){
					_bm=new rang2();
				}else if(int(name.slice(8,9))==8){
					_bm=new rang3();
				}else if(int(name.slice(8,9))==9){
					_bm=new rang4();
				}
				parent["win_cl"]["rang_cl"].graphics.clear();
				parent["win_cl"]["rang_cl"].graphics.beginBitmapFill(_bm);
				parent["win_cl"]["rang_cl"].graphics.drawRect(0,0,_bm.width,_bm.height);
			}else if(name=="yes_pack"){
				sendRequest(["query","action"],[["id"],["id","sp_id"]],[["1"],[11+"",parent["ID"]+""]]);
			}else if(name=="all_avas"){
				sendRequest(["query","action"],[["id"],["id","type"]],[["2"],["11","1"]]);
			}else if(name=="last_ava"){
				a_page--;
				setAva1();
			}else if(name=="next_ava"){
				a_page++;
				setAva1();
			}else if(name.slice(0,4)=="ava_"){
				try{
					avas_cl["buy_ava"].visible=true;
					avas_cl["buy_ava"].ID=this["ID"];
					avas_cl["buy_ava"]["price_tx"].text=this["price"];
					avas_cl["buy_ava"]["pict_cl"].graphics.clear();
					avas_cl["buy_ava"]["pict_cl"].graphics.beginBitmapFill(this["pict"].bitmapData);
					avas_cl["buy_ava"]["pict_cl"].graphics.drawRect(0,0,this["pict"].width,this["pict"].height);
				}catch(er:Error){}
			}else if(name=="yes_ava"){
				sendRequest(["query","action"],[["id"],["id","ava_id"]],[["2"],["12",parent["ID"]+""]]);
			}else if(name=="buy_sc"){
				sendRequest(["query","action"],[["id"],["id","skin_id","val"]],[["2"],["13",parent["ID"]+"","1"]]);
			}else if(name=="obmen_b"){
				sendRequest([["query"],["action"]],[["id"],["id"]],[["1"],["27"]]);
			}else if(name.slice(0,8)=="konv_val"){
				sendRequest(["query","action"],[["id"],["id","id_conv","qntty"]],[["1"],[29+"",this["ID"]+"",parent["num1_tx"+int(name.slice(8,10))].text]]);
			}
			
			try{
				if(name.slice(0,3)!="vkl"){
					if(currentFrameLabel!="empty"){
						gotoAndStop("over");
					}
				}else{
					if(currentFrameLabel!="press"){
						gotoAndStop("over");
					}
				}
			}catch(er:Error){}
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
				if(int(idies[0][0])==1){
					if(int(idies[1][0])==4){
						loader.addEventListener(Event.COMPLETE, getVip);
					}else if(int(idies[1][0])==6){
						loader.addEventListener(Event.COMPLETE, getLev);
					}else if(int(idies[1][0])==7){
						loader.addEventListener(Event.COMPLETE, buyLev);
						stg_class.wind["choise_cl"].setSt(-2);
						if(idies[1][2]=="0|0|0|1"&&_i==0)stg_cl["buy_send"]=[names, attr, idies, 1];
					}else if(int(idies[1][0])==10){
						loader.addEventListener(Event.COMPLETE, getPacks);
					}/*else if(int(idies[1][0])==26){
						loader.addEventListener(Event.COMPLETE, buyLev);
						if(_i==0)stg_cl["buy_send"]=[names, attr, idies, 1];
					}*/else if(int(idies[1][0])==11){
						loader.addEventListener(Event.COMPLETE, buyPacks);
						stg_class.wind["choise_cl"].setSt(-2);
						if(_i==0)stg_cl["buy_send"]=[names, attr, idies, 1];
					}else if(int(idies[1][0])==27){
						loader.addEventListener(Event.COMPLETE, getObmen);
					}else if(int(idies[1][0])==29){
						loader.addEventListener(Event.COMPLETE, obmenVal);
					}else if(int(idies[1][0])==5){
						loader.addEventListener(Event.COMPLETE, getArsenal);
						if(ign_er){
							b=1;
						}
					}else if(int(idies[1][0])==9){
						loader.addEventListener(Event.COMPLETE, slChange1);
						b=1;
					}
				}else if(int(idies[0][0])==2){
					if(int(idies[1][0])==13){
						if(int(idies[1][2])==0){
							loader.addEventListener(Event.COMPLETE, addWeapAr);
							stg_class.wind["choise_cl"].setSt(-2);
						}else if(int(idies[1][2])==1){
							loader.addEventListener(Event.COMPLETE, addWeapSn);
							stg_class.wind["choise_cl"].setSt(-2);
							if(_i==0)stg_cl["buy_send"]=[names, attr, idies, 1];
						}
					}else if(int(idies[1][0])==12){
						loader.addEventListener(Event.COMPLETE, addAva);
						stg_class.wind["choise_cl"].setSt(-2);
						if(_i==0)stg_cl["buy_send"]=[names, attr, idies, 1];
					}else if(int(idies[1][0])==11){
						if(int(idies[1][1])==1){
							loader.addEventListener(Event.COMPLETE, getAva1);
						}else{
							loader.addEventListener(Event.COMPLETE, getAva);
						}
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
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
			stg_class.prnt_cl.output("vip send\n"+list+"\n\n",1);
=======
			//stg_class.prnt_cl.output("vip send\n"+list+"\n\n",1);
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
			if(b==0){
				stg_cl.warn_f(10,"");
			}else if(b==2){
				stg_cl.warn_f(14,"");
			}
			loader.load(rqs);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var ign_er:Boolean=false;
		
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
		public static var reverseSlot:Function=null;
		public function replaceSlot(_trgt:MovieClip,_cl:MovieClip,_i_name:String,_reverse:Boolean):void{
=======
		public function iterateSlot(_move:MovieClip,_trgt:MovieClip,_reverse:Boolean,_r_fnc:Function=null):void{
			trace("iterateSlot");
			var _old:String=_move.old_pos.join(",");
			var _new:String=_trgt.old_pos.join(",");
			
			if(_old==_new){
				_r_fnc();
				return;
			}
			
			var _id:String=_move.ID+"";
			var _qntt:int=_move.quantity;
			_trgt.quantity+=_qntt;
			ch_num(_trgt);
			
			var _ar:Array=[
				_move.ID,
				_move.calc,
				_move.empty,
				_move.i_text,
				_move.i_name,
				_move.quantity,
				_move.lev,
				_move.color,
				_move.lyr,
				_move.mass,
				_move.stab,
				_move.mod_link,
				_move.price,
				_move.can_put,
				_move.old_pos,
				_move.bmd.clone(),
				_move.light_col,
				_move.max_qntty
			];
			
			stg_cl.overTest1(_move,0);
			stg_cl.canDrag(_move);
			_move.i_text="";
			_move.i_name="";
			_move.light_col=-1;
			stg_cl.light_col1(_move,_move.light_col);
			_move.can_put=new Array();
			_move.mass=0;
			_move.empty=true;
			_move.bmd=null;
			_move.clearBtn();
			
			
			
			if(_reverse){
				reverseSlot=function(){
					_trgt.quantity=_qntt;
					ch_num(_trgt);
					
					_move.ID=_ar[0];
					_move.calc=_ar[1];
					_move.empty=_ar[2];
					_move.i_text=_ar[3];
					_move.i_name=_ar[4];
					_move.quantity=_ar[5];
					_move.lev=_ar[6];
					_move.color=_ar[7];
					_move.lyr=_ar[8];
					_move.mass=_ar[9];
					_move.stab=_ar[10];
					_move.mod_link=_ar[11];
					_move.price=_ar[12];
					_move.can_put=_ar[13];
					_move.max_qntty=_ar[17];
					//_move.old_pos=_ar[14];
					//trace(_ar);
					
					ch_num(_move);
					
					if(_ar[15]){
						_move.drawPict(_ar[15]);
					}else{
						_move.bmd=null;
						_move.clearBtn();
					}
					_move.light_col=_ar[16];
					stg_cl.light_col(_move,_move.light_col);
					if(_move.name!="tank_win"){
						stg_cl.overTest1(_move,1);
					}else{
						stg_cl.overTest(_move,0);
					}
					_move.weightTest(0);
					stg_cl.canDrag(_move);
				};
				sendPos("{{"+_old+"},{"+_new+"},{"+_id+","+_qntt+"}}");
			}
			
		}
		
		public static var reverseSlot:Function=null;
		public function replaceSlot(_trgt:MovieClip,_cl:MovieClip,_i_name:String,_reverse:Boolean):void{
			trace("replaceSlot");
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
			var _send:Boolean=false;
			var _tank:Boolean=false;
			var _old:String=_trgt.old_pos.join(",");
			var _new:String=_cl.old_pos.join(",");
			var _id:String=_trgt.ID+"";
			var _qntt:String=_trgt.quantity+"";
			
			if(!_reverse){
				if(_cl.old_pos[0]==6){
					_cl=_tanks_objs[_cl.old_pos[1]];
					_tank=true;
				}
				if(_trgt.old_pos[0]==6){
					_trgt=_tanks_objs[_trgt.old_pos[1]+_tanks_count];
					_i_name=_trgt.i_name;
					_tank=true;
				}
			}
			
			if(_old!=_new){
				_send=true;
			}
			var _ar:Array=[
				_trgt.ID,
				_trgt.calc,
				_trgt.empty,
				_trgt.i_text,
				_trgt.i_name,
				_trgt.quantity,
				_trgt.lev,
				_trgt.color,
				_trgt.lyr,
				_trgt.mass,
				_trgt.stab,
				_trgt.mod_link,
				_trgt.price,
				_trgt.can_put,
				_trgt.old_pos,
				_trgt.bmd.clone(),
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
				_trgt.light_col
=======
				_trgt.light_col,
				_trgt.max_qntty
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
			];
			var _mw=_trgt["bmd"].width;
			var _mh=_trgt["bmd"].height;
			if(_cl["i_name"]!=""){
				_trgt.ID=_cl.ID;
				_trgt.calc=_cl.calc;
				_trgt.empty=_cl.empty;
				_trgt.i_text=_cl.i_text;
				_trgt.i_name=_cl.i_name;
				_trgt.quantity=_cl.quantity;
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
=======
				_trgt.max_qntty=_cl.max_qntty;
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
				_trgt.lev=_cl.lev;
				_trgt.color=_cl.color;
				_trgt.lyr=_cl.lyr;
				_trgt.mass=_cl.mass;
				_trgt.stab=_cl.stab;
				_trgt.mod_link=_cl.mod_link;
				_trgt.price=_cl.price;
				_trgt.can_put=_cl.can_put;
				//_trgt.old_pos=_cl.old_pos;
				_trgt.light_col=_cl.light_col;
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
=======
				ch_num(_trgt);
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
				if(_cl.bmd){
					_trgt.drawPict(_cl.bmd);
				}else{
					_trgt.bmd=null;
					_trgt.clearBtn();
				}
				stg_cl.overTest1(_trgt,0);
				_trgt["i_name"]=_cl["i_name"];
			}else{
				_trgt.i_text="";
				_trgt.i_name="";
				_trgt.light_col=-1;
				stg_cl.light_col1(_trgt,_trgt.light_col);
				_trgt.can_put=new Array();
				_trgt.mass=0;
				_trgt.empty=true;
				_trgt.bmd=null;
				_trgt.clearBtn();
			}
			_cl.ID=_ar[0];
			_cl.calc=_ar[1];
			_cl.empty=_ar[2];
			_cl.i_text=_ar[3];
			_cl.i_name=_ar[4];
			_cl.quantity=_ar[5];
			_cl.lev=_ar[6];
			_cl.color=_ar[7];
			_cl.lyr=_ar[8];
			_cl.mass=_ar[9];
			_cl.stab=_ar[10];
			_cl.mod_link=_ar[11];
			_cl.price=_ar[12];
			_cl.can_put=_ar[13];
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
			//_cl.old_pos=_ar[14];
			//trace(_ar);
=======
			_cl.max_qntty=_ar[17];
			//_cl.old_pos=_ar[14];
			//trace(_ar);
			
			ch_num(_cl);
			
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
			if(_ar[15]){
				_cl.drawPict(_ar[15]);
			}else{
				_cl.bmd=null;
				_cl.clearBtn();
			}
			_cl.light_col=_ar[16];
			stg_cl.light_col(_cl,_cl.light_col);
			if(_cl.name!="tank_win"){
				stg_cl.overTest1(_cl,1);
			}else{
				stg_cl.overTest(_cl,0);
			}
			_cl["i_name"]=_i_name;
			_cl.weightTest(0);
			stg_cl.canDrag(_cl);
			
			if(_tank){
				tanksSlots();
			}
			
			if(_reverse&&_send){
				reverseSlot=function(){
					replaceSlot(_cl,_trgt,_cl["i_name"],false);
				};
				sendPos("{{"+_old+"},{"+_new+"},{"+_id+","+_qntt+"}}");
			}
			
		}
		
		public function slChange1(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
			stg_class.prnt_cl.output("vip send\n"+str+"\n\n",1);
=======
			//stg_class.prnt_cl.output("vip send\n"+str+"\n\n",1);
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nИнвентарь1.");
				stg_cl.erTestReq(1,8,str);
				last_send=null;
				return;
			}
			//trace("slChange1\n"+list);
			if(int(list.err[0].@code)!=0){
				/*var list1:XML=list.child("rPanel")[0];
				var list2:XML=list.child("arsenal")[0];
				
				stg_class.panel["ammo0"].parsePanel(list1);
				stg_class.vip_cl["exit_cl"].parseArsenal(list2);
				
				if(int(list.child("err")[0].attribute("code"))!=4){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
				}else{
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
				}*/
				if(reverseSlot!=null){
					if(arsnl_cl!=null&&arsnl_cl.stage!=null){
						reverseSlot();
					}
					reverseSlot=null;
				}
				last_send=null;
				stg_cl.warn_f(5,"Ошибка перемещения.\n CODE "+int(list.child("err")[0].attribute("code"))+"\n"+
					"TEXT: "+list.err[0].attribute("comm"));
				return;
			}else{
				reverseSlot=null;
				var _mods:XMLList=list.err[0].mod;
				var _len:int=_mods.length();
				var _show_chng:Boolean=false;
				if(arsnl_cl!=null&&arsnl_cl.stage!=null){
					_show_chng=true;
				}
				var _replaced:Array=new Array();
				var _last0:String="-1:-1";
				var _last1:String="-1:-1";
				var _last2:String="-1:-1";
				if(last_send!=null){
					_last0=last_send[0].split(",").join(":");
					_last1=last_send[1].split(",").join(":");
					_last2=last_send[2].split(",").join(":");
				}
				last_send=null;
				for(var i:int=0;i<_len;i++){
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
					var _type:int=_mods[i].mtype;
=======
					var _type:int=_mods[i].@mtype;
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
					var _data:Array=_mods[i].@from.split("|");
					
					var _data0:Array=_data[0].split(":");
					var _data1:Array=_data[1].split(":");
					var _data2:Array=_data[2].split(":");
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
					if(_show_chng){
						var _move:MovieClip=arsnl_cl["sl_"+_data0[0]+"_"+_data0[1]];
=======
					//trace("move1 "+_type+" "+_data[0]+" "+_data[1]+" "+_data[2]);
					//trace("move2 "+_type+" "+_last0+" "+_last1+" "+_last2);
					//trace("move3 "+_type+" "+_data0+" "+_data1+" "+_data2);
					if(_show_chng){
						var _move:MovieClip=arsnl_cl["sl_"+_data0[0]+"_"+_data0[1]];
						var _trgt:MovieClip=arsnl_cl["sl_"+_data1[0]+"_"+_data1[1]];
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
						if(int(_data2[0])==0||int(_data2[1])==0){
							_move.old_pos=[_data0[0],_data0[1]];
							_move.i_text="";
							_move.i_name="";
							_move.light_col=-1;
							stg_cl.light_col1(_move,_move.light_col);
							_move.can_put=new Array();
							_move.mass=0;
							_move.empty=true;
							_move.bmd=null;
							_move.clearBtn();
							_move=null;
						}else if(int(_data1[0])==100){
							if(int(_data0[0])!=6&&int(_data1[1])==0){
								_move.old_pos=[_data0[0],_data0[1]];
								_move.i_text="";
								_move.i_name="";
								_move.light_col=-1;
								stg_cl.light_col1(_move,_move.light_col);
								_move.can_put=new Array();
								_move.mass=0;
								_move.empty=true;
								_move.bmd=null;
								_move.clearBtn();
								_move=null;
							}
						}else if(int(_data0[0])==6){
							/*if(_replaced.indexOf(_data[1]+""+_data[0])>-1){
								continue;
							}
							_replaced.push(_data[0]+""+_data[1]);
							replaceSlot(_move,arsnl_cl["sl_"+_data1[0]+"_"+_data1[1]],_move["i_name"],false);*/
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
						}else if(_last0==_data[0]&&_last1==_data[1]){
							
						}else if(_last0==_data[1]&&_last1==_data[0]){
							
						}else{
							replaceSlot(_move,arsnl_cl["sl_"+_data1[0]+"_"+_data1[1]],_move["i_name"],false);
						} 
					}
				}
				
				var _moneys:XMLList=list.err[0].money;
				_len=_moneys.length();
				var _ar:Array=[0,0,0,0,0,0];
				for(var i:int=0;i<_len;i++){
					var _money:XML=_moneys[i];
					_ar[0]+=int(_money.@money_m);
					_ar[1]+=int(_money.@money_z);
					_ar[2]+=int(_money.@money_a);
					_ar[3]+=int(_money.@sn_val);
				}
				if(_len>0){
					stg_class.shop["exit"].addMoneys(_ar);
				}
				
=======
						}else if(_type!=2&&_last0==_data[0]&&_last1==_data[1]){
							
						}else if(_type!=2&&_last0==_data[1]&&_last1==_data[0]){
							
						}else{
							replaceSlot(_move,arsnl_cl["sl_"+_data1[0]+"_"+_data1[1]],_move["i_name"],false);
						}
					}
				}
				
				var _moneys:XMLList=list.err[0].money;
				_len=_moneys.length();
				var _ar:Array=[0,0,0,0,0,0];
				for(var i:int=0;i<_len;i++){
					var _money:XML=_moneys[i];
					_ar[0]+=int(_money.@money_m);
					_ar[1]+=int(_money.@money_z);
					_ar[2]+=int(_money.@money_a);
					_ar[3]+=int(_money.@sn_val);
				}
				if(_len>0){
					stg_class.shop["exit"].addMoneys(_ar);
				}
				
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
				var _razdels:XMLList=list.err[0].razdel;
				var _tank:XMLList=list.err[0].tank;
				if(_tank.length()==0){
					_tank=null;
				}
				if(_show_chng){
					parseRazdel(_razdels,_tank);
				}
				
				var _panel:XMLList=list.err[0].panel;
				stg_class.panel["ammo0"].parseRazdel(_panel);
				
				var _health:XMLList=list.err[0].health;
				if(_health.length()>0){
					stg_class.panel["ammo0"].addHealth(int(_health.@hp),int(_health.@full_hp));
				}
			}
			
			var _rp:MovieClip=arsnl_cl["conf_win"]._rp;
			var _trg:MovieClip=arsnl_cl["conf_win"]._trg;
			if(_rp!=null){
				try{
					replaceSlot(_rp,_trg,_rp["i_name"],false);
					arsnl_cl["conf_win"]._rp=null;
					arsnl_cl["conf_win"]._trg=null;
				}catch(er:Error){
					
				}
			}
			
			arsnl_cl["sell_cl"]["_clip"]=null;
			arsnl_cl["sell_cl"].visible=false;
			
			weightTest(0);
			
			//stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getStaticVar(str:String):*{
			return vip_btn[str];
		}
		
		public function getArsenal(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("getArsenal   "+str);
			
			if(arsnl_cl!=null){
				arsnl_cl["conf_win"]._rp=null;
				arsnl_cl["conf_win"]._trg=null;
			}
			
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nАрсенал.");
				stg_cl.erTestReq(1,5,str);
				return;
			}
			
			//trace("getArsenal\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			
			parseArsenal(list);
			if(!ign_er){
				stg_cl.warn_f(9,"");
			}else{
				ign_er=false;
				try{stg_cl.setChildIndex(stg_class.warn_cl,stg_cl.numChildren-1);}catch(er:Error){}
			}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function parseRazdel(list:XMLList,_tank:XMLList=null):void{
			if(_tank!=null){
				arsnl_cl["tank_tx"].text=(_tank.attribute("name"));
				arsnl_cl["gs_tx"].text=(_tank.attribute("gs"));
				arsnl_cl["pb_tx"].text=(_tank.attribute("public"));
				arsnl_cl["info_tank"].i_text=(_tank.attribute("descr"));
				arsnl_cl.mass_lim=int(_tank.attribute("drag_mass"));
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
				for(var i:int=0;i<8;i++){
=======
				/*for(var i:int=0;i<8;i++){
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
					if(i<int(_tank.attribute("free_slots"))){
						arsnl_cl["sl_"+5+"_"+i]._clr=0xffffff;
						arsnl_cl["sl_"+5+"_"+i].clearBtn();
					}
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
				}
=======
				}*/
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
			}
			
			for(var i:int=0;i<list.length();i++){
				var _num:int=int(list[i].attribute("num"));
				if(_num!=1&&_num!=7){
					//arsnl_cl["sl_gr_tx"+_num].text=(list[i].attribute("name"));
					
					if(_num==6){
						_tanks_objs=new Array();
						_tanks_count=0;
					}
					
					var _lim:int=int(list[i].attribute("ready"));
					var n:int=0;
					while(arsnl_cl["sl_"+_num+"_"+n]!=null){
						var _cl_slot:MovieClip=arsnl_cl["sl_"+_num+"_"+n];
						_cl_slot.ID=0;
						_cl_slot.i_text="";
						_cl_slot.i_name="";
						_cl_slot.light_col=-1;
						stg_cl.light_col1(_cl_slot,_cl_slot.light_col);
						if(n<_lim){
							_cl_slot._clr=0xffffff;
							_cl_slot.clearBtn();
							_cl_slot.visible=true;
						}else{
							if(_num!=3){
								_cl_slot._clr=0xB6B6B6;
								_cl_slot.clearBtn();
								_cl_slot.visible=true;
							}else{
								_cl_slot._clr=0xffffff;
								_cl_slot.clearBtn();
								_cl_slot.visible=false;
							}
						}
						_cl_slot.can_put=new Array();
						_cl_slot.mass=0;
						_cl_slot.empty=true;
						_cl_slot.bmd=null;
						n++;
					}
				}else if(_num==1){
					dopInv(int(list[i].attribute("ready")));
				}
				//arsnl_cl["info_sl"+_num].i_text=(list[i].attribute("descr"));
				//if(list[i].child("slot")!=null){
				for(var j:int=0;j<list[i].child("slot").length();j++){
					var _sl_gr:int=list[i].child("slot")[j].attribute("sl_gr");
					var _sl_num:int=list[i].child("slot")[j].attribute("sl_num");
					var _cl:MovieClip;
					if(_sl_gr==6){
						_cl=new Slot2();
						_cl._w=80;
						_cl._h=38;
						if(_sl_num<6){
							_cl._clr=0xffffff;
						}else{
							_cl._clr=0xB6B6B6;
						}
						_tanks_objs[_sl_num]=_cl;
						//trace("_tanks_objs.length="+_tanks_objs.length);
					}else{
						_cl=arsnl_cl["sl_"+_sl_gr+"_"+_sl_num];
					}
					_cl.ID=(list[i].child("slot")[j].attribute("id"));
					_cl.calc=int(list[i].child("slot")[j].attribute("calculated"));
					_cl.empty=!Boolean(int(list[i].child("slot")[j].attribute("ready")));
					_cl.i_text=(list[i].child("slot")[j].attribute("descr"));
					_cl.i_name=(list[i].child("slot")[j].attribute("name"));
					_cl.quantity=int(list[i].child("slot")[j].attribute("num"));
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
=======
					_cl.max_qntty=int(list[i].child("slot")[j].attribute("max_qntty"));
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
					_cl.lev=int(list[i].child("slot")[j].attribute("level"));
					_cl.color=int(list[i].child("slot")[j].attribute("color"));
					_cl.lyr=int(list[i].child("slot")[j].attribute("layer"));
					_cl.mass=int(list[i].child("slot")[j].attribute("weight"));
					_cl.stab=int(list[i].child("slot")[j].attribute("durability"));
					_cl.mod_link=(list[i].child("slot")[j].attribute("src1"));
					_cl.price=int(list[i].child("slot")[j].attribute("price"));
					_cl.old_pos=[int(list[i].child("slot")[j].attribute("sl_gr")),int(list[i].child("slot")[j].attribute("sl_num"))];
					if((list[i].child("slot")[j].attribute("light_col"))!=""){
						_cl.light_col=int(list[i].child("slot")[j].attribute("light_col"));
					}else{
						_cl.light_col=-1;
					}
					stg_cl.light_col1(_cl,_cl.light_col);
					_cl._try=0;
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
					
=======
					ch_num(_cl);
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
					var _ar:Array=(list[i].child("slot")[j].attribute("replace")).split("*");
					var _gr:Array=new Array();
					//trace("a   "+_ar+"   "+_ar.length);
					for(var n:int=0;n<_ar.length;n++){
						var _ar1:Array=(_ar[n]).split(":");
						//trace("b   "+_ar1+"   "+_ar1.length);
						if(_ar1.length<2){
							continue;
						}
						/*if(int(_ar1[0])<2){
						if(_num<2){
						_ar1[1]="s";
						}
						}*/
						var _ar2:Array=(_ar1[1]).split("|");
						//trace("c   "+_ar2+"   "+_ar2.length);
						if(_ar2[0]=="s"){
							var m:int=0;
							while(arsnl_cl.getChildByName("sl_"+_ar1[0]+"_"+m)!=null){
								_gr.push(arsnl_cl["sl_"+_ar1[0]+"_"+m]);
								m++;
							}
						}else{
							for(var k:int=0;k<_ar2.length;k++){
								_gr.push(arsnl_cl["sl_"+_ar1[0]+"_"+_ar2[k]]);
							}
						}
					}
					//trace("e");
					_cl.can_put=_gr;
					
					_cl.load_er=0;
					var pre_cl:MovieClip=new (stg_class.mini_pre)();
					pre_cl.x=(_cl.width-pre_cl.width)/2;
					pre_cl.y=(_cl.height-pre_cl.height)/2;
					_cl.pre_cl=pre_cl;
					_cl.addChild(_cl.pre_cl);
					loads.push([_cl,(list[i].child("slot")[j].attribute("src"))]);
				}
				//}
			}
			
			if(loads.length>0){
				loads[0][0].LoadImage(loads[0][1]);
			}else{
				tanksSlots();
			}
		}
		
		public static var _tanks_objs:Array=new Array();
		public static var _tanks_count:int=0;
		public function get tanks_count():int{
			return _tanks_count;
		}
		public static function tanksSlots():void{
			//trace("tanksSlots "+_tanks_count+" "+_tanks_objs.length);
			if(_tanks_count==0){
				arsnl_cl.tank_scr_l.gotoAndStop("empty");
			}else{
				arsnl_cl.tank_scr_l.gotoAndStop("out");
			}
			if(_tanks_count>=8){
				arsnl_cl.tank_scr_r.gotoAndStop("empty");
			}else{
				arsnl_cl.tank_scr_r.gotoAndStop("out");
			}
			for(var i:int=0;i<4;i++){
				var _trgt:MovieClip=arsnl_cl["sl_"+6+"_"+i];
				var _num:int=_tanks_count+i;
				if(_num>5){
					_trgt._clr=0xB6B6B6;
				}else{
					_trgt._clr=0xffffff;
				}
				if(_num<_tanks_objs.length&&_tanks_objs[_num]!=null){
					var _cl:MovieClip=_tanks_objs[_num];
					_trgt.ID=_cl.ID;
					_trgt.calc=_cl.calc;
					_trgt.empty=_cl.empty;
					_trgt.i_text=_cl.i_text;
					_trgt.i_name=_cl.i_name;
					_trgt.quantity=_cl.quantity;
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
=======
					_trgt.max_qntty=_cl.max_qntty;
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
					_trgt.lev=_cl.lev;
					_trgt.color=_cl.color;
					_trgt.lyr=_cl.lyr;
					_trgt.mass=_cl.mass;
					_trgt.stab=_cl.stab;
					_trgt.mod_link=_cl.mod_link;
					_trgt.price=_cl.price;
					_trgt.can_put=_cl.can_put;
					//_trgt.old_pos=_cl.old_pos;
					_trgt.light_col=_cl.light_col;
					if(_cl.bmd){
						_trgt.drawPict(_cl.bmd);
					}else{
						_trgt.bmd=null;
						_trgt.clearBtn();
					}
					stg_cl.overTest1(_trgt,0);
					_trgt["i_name"]=_cl["i_name"];
				}else{
					_trgt.i_text="";
					_trgt.i_name="";
					_trgt.light_col=-1;
					stg_cl.light_col1(_trgt,_trgt.light_col);
					_trgt.can_put=new Array();
					_trgt.mass=0;
					_trgt.empty=true;
					_trgt.bmd=null;
					_trgt.clearBtn();
				}
			}
		}
		
		public static function tanksSlotsChng(_num:int):void{
			for(var i:int=0;i<4;i++){
				var _cl:MovieClip=arsnl_cl["sl_"+6+"_"+i];
				var _trgt:MovieClip=new Slot2();
				_trgt._w=80;
				_trgt._h=38;
				_trgt._clr=0xffffff;
				var _num1:int=_tanks_count+i;
				if(_trgt.i_name!=""){
					_trgt.ID=_cl.ID;
					_trgt.calc=_cl.calc;
					_trgt.empty=_cl.empty;
					_trgt.i_text=_cl.i_text;
					_trgt.i_name=_cl.i_name;
					_trgt.quantity=_cl.quantity;
<<<<<<< HEAD:client/work/fps test1/VIP/vip_btn.as
=======
					_trgt.max_qntty=_cl.max_qntty;
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/VIP/vip_btn.as
					_trgt.lev=_cl.lev;
					_trgt.color=_cl.color;
					_trgt.lyr=_cl.lyr;
					_trgt.mass=_cl.mass;
					_trgt.stab=_cl.stab;
					_trgt.mod_link=_cl.mod_link;
					_trgt.price=_cl.price;
					_trgt.can_put=_cl.can_put;
					//_trgt.old_pos=_cl.old_pos;
					_trgt.light_col=_cl.light_col;
					if(_cl.bmd){
						_trgt.bmd=_cl.bmd.clone();
					}else{
						_trgt.bmd=null;
						_trgt.clearBtn();
					}
					stg_cl.overTest1(_trgt,0);
					_trgt["i_name"]=_cl["i_name"];
				}else{
					_trgt.i_text="";
					_trgt.i_name="";
					_trgt.light_col=-1;
					stg_cl.light_col1(_trgt,_trgt.light_col);
					_trgt.can_put=new Array();
					_trgt.mass=0;
					_trgt.empty=true;
					_trgt.bmd=null;
					_trgt.clearBtn();
				}
				
				_tanks_objs[_num1]=_trgt;
			}
			
			_tanks_count+=_num*4;
			if(_tanks_count>8){
				_tanks_count=8;
			}
			if(_tanks_count<0){
				_tanks_count=0;
			}
			
			tanksSlots();
		}
		
		public function parseArsenal(list:XML):void{
			_tanks_objs=new Array();
			_tanks_count=0;
			vipReset();
			arsnl_cl=new arsenal();
			stg_cl.createMode(11);
			arsnl_cl["warn_win"].visible=false;
			arsnl_cl["conf_win"].visible=false;
			arsnl_cl["tank_win"].addEventListener(MouseEvent.MOUSE_OVER, tw_over);
			arsnl_cl["tank_win"].addEventListener(MouseEvent.MOUSE_OUT, tw_out);
			arsnl_cl["tank_win"].addEventListener(MouseEvent.MOUSE_UP, tw_release);
			arsnl_cl["ac_tank_b"].gotoAndStop("empty");
			arsnl_cl["prm_tank_b"].gotoAndStop("empty");
			arsnl_cl["dop_sl0"].gotoAndStop("empty");
			arsnl_cl["dop_sl1"].gotoAndStop("empty");
			arsnl_cl["dop_sl2"].gotoAndStop("empty");
			arsnl_cl.x=10;
			arsnl_cl.y=60;
			St_clip["stg_cl"].addChild(arsnl_cl);
			
			arsnl_cl["tank_tx"].text=(list.child("tank")[0].attribute("name"));
			arsnl_cl["gs_tx"].text=(list.child("tank")[0].attribute("gs"));
			arsnl_cl["pb_tx"].text=(list.child("tank")[0].attribute("public"));
			arsnl_cl["info_tank"].i_text=(list.child("tank")[0].attribute("descr"));
			arsnl_cl.mass_lim=int(list.child("tank")[0].attribute("drag_mass"));
			for(var i:int=0;i<8;i++){
				if(i<int(list.child("tank")[0].attribute("free_slots"))){
					arsnl_cl["sl_"+5+"_"+i]._clr=0xffffff;
					arsnl_cl["sl_"+5+"_"+i].clearBtn();
				}
			}
			
			for(i=0;i<list.child("razdel").length();i++){
				var _num:int=int(list.child("razdel")[i].attribute("num"));
				if(_num!=1&&_num!=7){
					arsnl_cl["sl_gr_tx"+_num].text=(list.child("razdel")[i].attribute("name"));
					var _lim:int=int(list.child("razdel")[i].attribute("ready"));
					var n:int=0;
					while(arsnl_cl["sl_"+_num+"_"+n]!=null){
						arsnl_cl["sl_"+_num+"_"+n].ID=0;
						if(n<_lim){
							arsnl_cl["sl_"+_num+"_"+n]._clr=0xffffff;
							arsnl_cl["sl_"+_num+"_"+n].clearBtn();
						}else{
							if(_num!=3){
								arsnl_cl["sl_"+_num+"_"+n]._clr=0xB6B6B6;
								arsnl_cl["sl_"+_num+"_"+n].clearBtn();
							}else{
								arsnl_cl["sl_"+_num+"_"+n].visible=false;
							}
						}
						n++;
					}
				}else if(_num==1){
					dopInv(int(list.child("razdel")[i].attribute("ready")));
				}
				arsnl_cl["info_sl"+_num].i_text=(list.child("razdel")[i].attribute("descr"));
				//if(list.child("razdel")[i].child("slot")!=null){
					for(var j:int=0;j<list.child("razdel")[i].child("slot").length();j++){
						var _sl_gr:int=list.child("razdel")[i].child("slot")[j].attribute("sl_gr");
						var _sl_num:int=list.child("razdel")[i].child("slot")[j].attribute("sl_num");
						var _cl:MovieClip;
						if(_sl_gr==6){
							_cl=new Slot2();
							_cl._w=80;
							_cl._h=38;
							if(_sl_num<6){
								_cl._clr=0xffffff;
							}else{
								_cl._clr=0xB6B6B6;
							}
							_tanks_objs[_sl_num]=_cl;
							//trace("_tanks_objs.length="+_tanks_objs.length);
						}else{
							_cl=arsnl_cl["sl_"+_sl_gr+"_"+_sl_num];
						}
						_cl.ID=(list.child("razdel")[i].child("slot")[j].attribute("id"));
						_cl.calc=int(list.child("razdel")[i].child("slot")[j].attribute("calculated"));
						_cl.empty=!Boolean(int(list.child("razdel")[i].child("slot")[j].attribute("ready")));
						_cl.i_text=(list.child("razdel")[i].child("slot")[j].attribute("descr"));
						_cl.i_name=(list.child("razdel")[i].child("slot")[j].attribute("name"));
						_cl.quantity=int(list.child("razdel")[i].child("slot")[j].attribute("num"));
						_cl.max_qntty=int(list.child("razdel")[i].child("slot")[j].attribute("max_qntty"));
						_cl.lev=int(list.child("razdel")[i].child("slot")[j].attribute("level"));
						_cl.color=int(list.child("razdel")[i].child("slot")[j].attribute("color"));
						_cl.lyr=int(list.child("razdel")[i].child("slot")[j].attribute("layer"));
						_cl.mass=int(list.child("razdel")[i].child("slot")[j].attribute("weight"));
						_cl.stab=int(list.child("razdel")[i].child("slot")[j].attribute("durability"));
						_cl.mod_link=(list.child("razdel")[i].child("slot")[j].attribute("src1"));
						_cl.price=int(list.child("razdel")[i].child("slot")[j].attribute("price"));
						_cl.old_pos=[int(_sl_gr),int(_sl_num)];
						if((list.child("razdel")[i].child("slot")[j].attribute("light_col"))!=""){
							_cl.light_col=int(list.child("razdel")[i].child("slot")[j].attribute("light_col"));
						}else{
							_cl.light_col=-1;
						}
						stg_cl.light_col1(_cl,_cl.light_col);
						_cl._try=0;
						ch_num(_cl);
						
						var _ar:Array=(list.child("razdel")[i].child("slot")[j].attribute("replace")).split("*");
						var _gr:Array=new Array();
						//trace("a   "+_ar+"   "+_ar.length);
						for(var n:int=0;n<_ar.length;n++){
							var _ar1:Array=(_ar[n]).split(":");
							//trace("b   "+_ar1+"   "+_ar1.length);
							if(_ar1.length<2){
								continue;
							}
							/*if(int(_ar1[0])<2){
								if(_num<2){
									_ar1[1]="s";
								}
							}*/
							var _ar2:Array=(_ar1[1]).split("|");
							//trace("c   "+_ar2+"   "+_ar2.length);
							if(_ar2[0]=="s"){
								var m:int=0;
								while(arsnl_cl.getChildByName("sl_"+_ar1[0]+"_"+m)!=null){
									_gr.push(arsnl_cl["sl_"+_ar1[0]+"_"+m]);
									m++;
								}
							}else{
								for(var k:int=0;k<_ar2.length;k++){
									_gr.push(arsnl_cl["sl_"+_ar1[0]+"_"+_ar2[k]]);
								}
							}
						}
						//trace("e");
						_cl.can_put=_gr;
						
						_cl.load_er=0;
						var pre_cl:MovieClip=new (stg_class.mini_pre)();
						pre_cl.x=(_cl.width-pre_cl.width)/2;
						pre_cl.y=(_cl.height-pre_cl.height)/2;
						_cl.pre_cl=pre_cl;
						_cl.addChild(_cl.pre_cl);
						loads.push([_cl,(list.child("razdel")[i].child("slot")[j].attribute("src"))]);
					}
				//}
			}
			weightTest(0);
			//trace("a");
			root["obmen_b"].visible=false;
			root["exit_cl1"].visible=false;
			arsnl_cl["sell_cl"]["_clip"]=null;
			arsnl_cl["sell_cl"].visible=false;
			if(loads.length>0){
				loads[0][0].LoadImage(loads[0][1]);
			}else{
				tanksSlots();
			}
			root["vkl2"].setVkl(0);
			stg_class.panel["arsenal_b"].gotoAndStop("empty");
		}
		
		public function obmenVal(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nОбмен по курсу.");
				stg_cl.erTestReq(1,29,str);
				return;
			}
			
			//trace("obmenVal\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			
			var _ar:Array=new Array();
			_ar.push(list.child("err")[0].attribute("money_m"));
			_ar.push(list.child("err")[0].attribute("money_z"));
			_ar.push(list.child("err")[0].attribute("money_a"));
			_ar.push(stg_class.shop["exit"].getMoneys(3));
			_ar.push(list.child("err")[0].attribute("money_za"));
			_ar.push(list.child("err")[0].attribute("money_i"));
			stg_class.shop["exit"].setMoneys(_ar);
			for(var i:int=0;i<1;i++){
				root["obmen"]["num_tx"+i].text="0";
				root["obmen"]["num1_tx"+i].text="0";
			}
					
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getObmen(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолковой обменник.");
				stg_cl.erTestReq(1,27,str);
				return;
			}
			
			//trace("getObmen\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			
			for(var i:int=0;i<1;i++){
				root["obmen"]["num_tx"+i].text="0";
				root["obmen"]["num1_tx"+i].text="0";
				root["obmen"]["konv_val"+i].gotoAndStop("empty");
				root["obmen"]["left_obm"+i].gotoAndStop("empty");
				root["obmen"]["right_obm"+i].gotoAndStop("empty");
			}
			
			for(var i:int=0;i<list.child("convert")[0].child("conv").length();i++){
				if(int(list.child("convert")[0].child("conv")[i].attribute("money_z"))<0){
					root["obmen"]["left_obm"+0]._step=Math.abs(int(list.child("convert")[0].child("conv")[i].attribute("money_z")));
					root["obmen"]["right_obm"+0]._step=root["obmen"]["left_obm"+0]._step;
					root["obmen"]["right_obm"+0]._type=1;
					root["obmen"]["left_obm"+0].gotoAndStop("out");
					root["obmen"]["right_obm"+0].gotoAndStop("out");
					root["obmen"]["konv_val"+0].ID=int(list.child("convert")[0].child("conv")[i].attribute("id"));
					root["obmen"]["num_tx"+0].text="0";
					root["obmen"]["num1_tx"+0].text="0";
					if(int(list.child("convert")[0].child("conv")[i].attribute("hidden"))==0){
						root["obmen"]["konv_val"+0].gotoAndStop("out");
					}
				}
			}
			
			St_clip["stg_cl"].setChildIndex(root["obmen"],St_clip["stg_cl"].numChildren-1);
			root["obmen"].visible=true;
					
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function buyPacks(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nVip buy pack.");
				stg_cl.erTestReq(1,11,str);
				return;
			}
			//trace("buyPacks\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("sn_val_need"))!=0){
						stg_cl.warn_f(9,"");
						var _ar:Array=new Array();
						_ar[0]=function(){
							stg_class.vip_cl["exit_cl"].vipReset();
							stg_cl.createMode(2);
							try{stg_class.shop["exit"].buy_mem("listShop");}catch(er:Error){trace(er);}
						};
						_ar[1]=[function(){
							stg_class.vip_cl["exit_cl"].sendRequest(["query","action"],[["id"],["id"]],[["1"],[10+""]]);
						},"buy"];
						_ar[2]=[function(){
							stg_class.shop["exit"].clear_buy_ar();
						},"end"];
						_ar[3]=[function(){
							stg_class.vip_cl["exit_cl"].sendRequest(stg_cl["buy_send"][0],stg_cl["buy_send"][1],stg_cl["buy_send"][2]);
						},"re_try"];
						stg_class.shop["exit"].needMoney(_ar,int(list.child("err")[0].attribute("sn_val_need")));
						return;
					}
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			//stg_cl.warn_f(9,"");
			var list1:XML=list.child("rPanel")[0];
			stg_class.panel["ammo0"].parsePanel(list1);
			stg_cl["buy_send"]=new Array();
			packs_cl["win_cl"].visible=false;
			vipReset();
			stg_cl.createMode(1);
			//root["vkl3"].setVkl(0);
			
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getPacks(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nVip packs.");
				stg_cl.erTestReq(1,10,str);
				return;
			}
			//trace("getPacks\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			
			vipReset();
			packs_cl=new vip_pack();
			for(var j:int=0;j<list.child("paks")[0].child("item").length();j++){
				packs_cl["price_tx"+list.child("paks")[0].child("item")[j].attribute("rang")].text=list.child("paks")[0].child("item")[j].attribute("sn_val")+" "+stg_class.shop["exit"].m_name(list.child("paks")[0].child("item")[j].attribute("sn_val"),3);
				packs_cl["buy_pack"+list.child("paks")[0].child("item")[j].attribute("rang")].ID=list.child("paks")[0].child("item")[j].attribute("id");
				packs_cl["buy_pack"+list.child("paks")[0].child("item")[j].attribute("rang")].price=int(list.child("paks")[0].child("item")[j].attribute("sn_val"));
				if(int(list.child("paks")[0].child("item")[j].attribute("hidden"))==0){
					packs_cl["buy_pack"+list.child("paks")[0].child("item")[j].attribute("rang")].visible=true;
				}else{
					packs_cl["buy_pack"+list.child("paks")[0].child("item")[j].attribute("rang")].visible=false;
				}
			}
			stg_cl.createMode(11);
			packs_cl.x=6;
			packs_cl.y=64;
			St_clip["stg_cl"].addChild(packs_cl);
			packs_cl["win_cl"].visible=false;
			root["vkl3"].setVkl(0);
			
			stg_cl.warn_f(9,"");
			try{
				stg_class.shop["exit"].buy_mem("weapons");
			}catch(er:Error){
				try{stg_class.shop["exit"].buy_mem("re_try");}catch(er:Error){}
				try{stg_class.shop["exit"].buy_mem("end");}catch(er:Error){}
			}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function addWeapAr(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nVIP: покупка вооружения за "+stg_class.shop["exit"].m_name(0,2,1)+".");
				stg_cl.getClass(St_clip["stg_cl"]["stg"]).wind["choise_cl"].erTestReq(2,13,str);
			}
			//trace("addWeapAr   "+list);
			weap_cl["buy_tank"].visible=false;
			try{
				if(list.child("err")[0].attribute("code")==1){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else if(list.child("err")[0].attribute("code")==2){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
				}else{
					var list1:XML=list.child("rPanel")[0];
					stg_class.panel["ammo0"].parsePanel(list1);
					try{
						weap_cl["buy_over"].visible=true;
						weap_cl["buy_tank"].visible=false;
						weap_cl["win_cl"].visible=false;
						weap_cl["buy_over"].y=112+weap_cl.scrollRect.y;
						weap_cl.setChildIndex(weap_cl["buy_over"],weap_cl.numChildren-1);
						//weap_cl["buy_over"]["name_tx"].text=list.child("err")[0].attribute("comm")+"";
					}catch(er:Error){}
					//stg_class.inv_cl["tank_sl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["1"],["5"]]);  обновить инвентарь
				}
			}catch(er:Error){
				
			}
			Mouse.cursor=MouseCursor.AUTO;
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function addWeapSn(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nVIP: покупка вооружения.");
				stg_class.wind["choise_cl"].erTestReq(2,13,str);
				return;
			}
			//trace("addWeapSn   "+list);
			try{weap_cl["buy_tank"].visible=false;}catch(er:Error){}
			try{
				if(list.child("err")[0].attribute("code")!=0){
					if(int(list.child("err")[0].attribute("sn_val_need"))!=0){
						stg_cl.warn_f(9,"");
						var _ar:Array=new Array();
						_ar[0]=function(){
							stg_class.vip_cl["exit_cl"].vipReset();
							stg_cl.createMode(2);
							try{stg_class.shop["exit"].buy_mem("listShop");}catch(er:Error){trace(er);}
						};
						_ar[1]=[function(){
							stg_class.vip_cl["exit_cl"].sendRequest(["query","action"],[["id"],["id"]],[["1"],["4"]]);
						},"buy"];
						_ar[2]=[function(){
							stg_class.shop["exit"].clear_buy_ar();
						},"end"];
						_ar[3]=[function(){
							stg_class.vip_cl["exit_cl"].sendRequest(stg_cl["buy_send"][0],stg_cl["buy_send"][1],stg_cl["buy_send"][2]);
						},"re_try"];
						stg_class.shop["exit"].needMoney(_ar,int(list.child("err")[0].attribute("sn_val_need")));
						return;
					}
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
				stg_cl["buy_send"]=new Array();
				if(list.child("err")[0].attribute("code")==2){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					return;
				}else{
					var list1:XML=list.child("rPanel")[0];
					stg_class.panel["ammo0"].parsePanel(list1);
					try{
						weap_cl["buy_over"].visible=true;
						weap_cl["buy_tank"].visible=false;
						weap_cl["win_cl"].visible=false;
						weap_cl["buy_over"].y=112+weap_cl.scrollRect.y;
						weap_cl.setChildIndex(weap_cl["buy_over"],weap_cl.numChildren-1);
						weap_cl["buy_over"]["name_tx"].text=list.child("err")[0].attribute("comm")+"";
					}catch(er:Error){}
					//stg_class.inv_cl["tank_sl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["1"],["5"]]);   обновить инвентарь
					//stg_cl.warn_f(5,"Куплено!",5);
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl["buy_send"]=new Array();
			Mouse.cursor=MouseCursor.AUTO;
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getAva1(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nVip ava1.");
				stg_cl.erTestReq(1,7,str);
				return;
			}
			//trace("getAva1\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			
			a_page=0;
			a_ar=new Array();
			a_pages=Math.ceil(int(list.child("avatars")[0].attribute("from"))/30);
			for(var i=0;i<list.child("avatars")[0].child("ava").length();i++){
				var _ar:Array=new Array();
				_ar.push(list.child("avatars")[0].child("ava")[i].attribute("img"));
				_ar.push(list.child("avatars")[0].child("ava")[i].attribute("price"));
				_ar.push(list.child("avatars")[0].child("ava")[i].attribute("id"));
				a_ar.push(_ar);
			}
			setAva1();
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function setAva1(){
			try{
				for(var i:int=0;i<30;i++){
					avas_cl["all_win"]["ava_"+i].graphics.clear();
				}
				if(a_page>0){
					avas_cl["all_win"]["last_ava"].visible=true;
				}else{
					avas_cl["all_win"]["last_ava"].visible=false;
				}
				if(30+(a_page*30)<a_ar.length){
					avas_cl["all_win"]["next_ava"].visible=true;
				}else{
					avas_cl["all_win"]["next_ava"].visible=false;
				}
				for(var i:int=0;i<30;i++){
					if(i+(a_page*30)<a_ar.length){
						avas_cl["all_win"]["ava_"+i].price=a_ar[i+(a_page*30)][1];
						avas_cl["all_win"]["ava_"+i].ID=a_ar[i+(a_page*30)][2];
						newPict(a_ar[i+(a_page*30)][0],avas_cl["all_win"]["ava_"+i],2);
						avas_cl["all_win"]["tx"+i].text=a_ar[i+(a_page*30)][1]+" "+stg_class.shop["exit"].m_name(a_ar[i+(a_page*30)][1],3);
						avas_cl["all_win"]["ava_"+i].visible=true;
					}else{
						avas_cl["all_win"]["tx"+i].text="";
						avas_cl["all_win"]["ava_"+i].visible=false;
					}
				}
				avas_cl["all_win"]["page_tx"].text="Страница: "+(a_page+1)+" из "+a_pages;
				avas_cl["buy_ava"].visible=false;
				avas_cl["all_win"].visible=true;
			}catch(er:Error){
				
			}
		}
		
		public static var a_page:int=0;
		public static var a_pages:int=0;
		public static var a_ar:Array=new Array();
		
		public function getAva(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nVip ava.");
				stg_cl.erTestReq(1,7,str);
				return;
			}
			//trace("getAva\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			
			vipReset();
			avas_cl=new avatars();
			for(var i=0;i<list.child("avatars").length();i++){
				if(i==1){
					avas_cl["rand_tx"].text="Случайный аватар: "+list.child("avatars")[i].attribute("number")+" из "+list.child("avatars")[i].attribute("from");
				}
				for(var j=0;j<list.child("avatars")[i].child("ava").length();j++){
					avas_cl["ava_"+i+"_"+j].price=int(list.child("avatars")[i].child("ava")[j].attribute("price"));
					avas_cl["ava_"+i+"_"+j].ID=int(list.child("avatars")[i].child("ava")[j].attribute("id"));
					newPict(list.child("avatars")[i].child("ava")[j].attribute("img"),avas_cl["ava_"+i+"_"+j],2);
					if(i==1){
						avas_cl["tx"+j].text=list.child("avatars")[i].child("ava")[j].attribute("price")+stg_class.shop["exit"].m_name(list.child("avatars")[i].child("ava")[j].attribute("price"),3);
					}
				}
			}
			stg_cl.createMode(11);
			avas_cl.x=6;
			avas_cl.y=64;
			St_clip["stg_cl"].addChild(avas_cl);
			avas_cl["all_win"].visible=false;
			avas_cl["buy_ava"].visible=false;
			root["vkl0"].setVkl(0);
			
			stg_cl.warn_f(9,"");
			try{stg_class.shop["exit"].buy_mem("re_try");}catch(er:Error){}
			try{stg_class.shop["exit"].buy_mem("end");}catch(er:Error){}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function addAva(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных.\nVIP: Покупка аватара.");
				stg_class.wind["choise_cl"].erTestReq(2,12,str);
				return;
			}
			//trace(list);
			try{
				avas_cl["buy_ava"].visible=false;
			}catch(er:Error){}
			try{
				stg_cl["buy_send"]=new Array();
				if(list.child("err")[0].attribute("code")==1){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else if(list.child("err")[0].attribute("code")==2){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("sn_val_need"))!=0){
						stg_cl.warn_f(9,"");
						var _ar:Array=new Array();
						_ar[0]=function(){
							stg_class.vip_cl["exit_cl"].vipReset();
							stg_cl.createMode(2);
							try{stg_class.shop["exit"].buy_mem("listShop");}catch(er:Error){trace(er);}
						};
						_ar[1]=[function(){
							stg_class.vip_cl["exit_cl"].sendRequest(["query","action"],[["id"],["id","type"]],[["2"],["11","-1"]]);
						},"buy"];
						_ar[2]=[function(){
							stg_class.shop["exit"].clear_buy_ar();
							stg_class.stat_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id"]],[["2"],["4"]]);
						},"end"];
						_ar[3]=[function(){
							stg_class.vip_cl["exit_cl"].sendRequest(stg_cl["buy_send"][0],stg_cl["buy_send"][1],stg_cl["buy_send"][2]);
						},"re_try"];
						stg_class.shop["exit"].needMoney(_ar,int(list.child("err")[0].attribute("sn_val_need")));
						return;
					}
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
				}else{
					stg_class.shop["exit"].sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["2"],["1","0","1","1"]]);
				}
			}catch(er:Error){}
			
			stg_cl["buy_send"]=new Array();
			Mouse.cursor=MouseCursor.AUTO;
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function buyLev(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nVip2.");
				stg_cl.erTestReq(1,7,str);
				return;
			}
			//trace("buyLev\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("sn_val_need"))!=0){
						stg_cl.warn_f(9,"");
						var _ar:Array=new Array();
						_ar[0]=function(){
							stg_class.vip_cl["exit_cl"].vipReset();
							stg_cl.createMode(2);
							try{stg_class.shop["exit"].buy_mem("listShop");}catch(er:Error){trace(er);}
						};
						_ar[1]=[function(){
							stg_class.vip_cl["exit_cl"].sendRequest(["query","action"],[["id"],["id"]],[["1"],["4"]]);
						},"buy"];
						_ar[2]=[function(){
							stg_class.shop["exit"].clear_buy_ar();
						},"end"];
						_ar[3]=[function(){
							stg_class.vip_cl["exit_cl"].sendRequest(stg_cl["buy_send"][0],stg_cl["buy_send"][1],stg_cl["buy_send"][2]);
						},"re_try"];
						stg_class.shop["exit"].needMoney(_ar,int(list.child("err")[0].attribute("sn_val_need")));
						return;
					}
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl["buy_send"]=new Array();
			if(list.child("rPanel").length()>0){
				var list1:XML=list.child("rPanel")[0];
				stg_class.panel["ammo0"].parsePanel(list1);
			}
			
			try{lev_cl["win_cl"].visible=false;lev_cl["spets_weap"].visible=false;}catch(er:Error){}
			try{
				weap_cl.removeChild(lev_cl);
			}catch(er:Error){}
			try{
				weap_cl["lev_line_b"].graphics.clear();
				weap_cl.parent.addChild(weap_cl["sc_clip"]);
				try{
					weap_cl.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollVip);
				}catch(er:Error){}
				/*var _rct:Rectangle=weap_cl.scrollRect;
				_rct.y=weap_cl["_sc_y"];
				weap_cl.scrollRect=_rct;
				trace(weap_cl["_sc_y"]+"   "+weap_cl.scrollRect.y);*/
				weap_cl.addEventListener(MouseEvent.MOUSE_WHEEL, scrollVip);
			}catch(er:Error){}
			try{
				weap_cl["buy_over"].visible=true;
				weap_cl["buy_tank"].visible=false;
				weap_cl["win_cl"].visible=false;
				weap_cl["buy_over"].y=112+weap_cl.scrollRect.y;
				weap_cl.setChildIndex(weap_cl["buy_over"],weap_cl.numChildren-1);
				weap_cl["buy_over"]["name_tx"].text=list.child("err")[0].attribute("comm")+"";
			}catch(er:Error){}
			//stg_class.inv_cl["tank_sl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["1"],["5"]]);   обновить инвентарь
			var _ar:Array=new Array();
			_ar.push(list.child("err")[0].attribute("money_m"));
			_ar.push(list.child("err")[0].attribute("money_z"));
			_ar.push(list.child("err")[0].attribute("money_a"));
			_ar.push(list.child("err")[0].attribute("sn_val"));
			stg_class.shop["exit"].setMoneys(_ar);
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getLev(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("getLev   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nVIP1.");
				stg_cl.erTestReq(1,6,str);
				return;
			}
			//trace("getLev\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			
			//trace(this["vals"]);
			lev_cl=new mod_win();
			var _pos:int=24;
			lev_cl["win_cl"].visible=false;
			lev_cl["spets_weap"].visible=false;
			lev_cl["name_tx"].text=list.child("info")[0].attribute("name");
			lev_cl._counted=int(list.child("info")[0].attribute("counted"));
			for(var j:int=0;j<4;j++){
				if(list.child("info")[0].attribute("mess"+j)+""!=""){
					lev_cl["mess"+j]["mess_tx"].text=list.child("info")[0].attribute("mess"+j);
					lev_cl["mess"+j].y=_pos;
					if(j==3)lev_cl["mess"+j].y+=2;
					lev_cl["mess"+j].visible=true;
					_pos+=lev_cl["mess"+j].height;
				}else{
					lev_cl["mess"+j].visible=false;
				}
			}
			_pos+=2;
			for(var j:int=0;j<list.child("mods")[0].child("mod").length();j++){
				var _mc:MovieClip=new mod_lev();
				if(list.child("mods")[0].child("mod")[j].attribute("descr2")+""==""){
					_mc["tx2"].visible=false;
					_mc["tx3"].y-=10;
					_mc["tx4"].y-=10;
				}
				var _ar:Array=new Array(0,0,0,1);
				var _ar1:Array=new Array(0,0,0,0);
				var _top:int=int(list.child("mods")[0].child("mod")[j].attribute("polk_top"));
				var _top_n:int=int(list.child("mods")[0].child("mod")[j].attribute("polk_top_now"));
				if(_top!=0){
					_mc["top_tx"].text="Репутация: "+_top;
					//_mc["buy_ar"].textColor=0x990000;
				}else{
					_mc["top_tx"].visible=false;
				}
				var dub_m:Array=(String(list.child("mods")[0].child("mod")[j].attribute("dub_m")).split(","));
				_mc["buy_ar"].price_dub=dub_m;
				//trace("a "+_mc["buy_ar"].price_dub);
				_mc["tx0"].text=list.child("mods")[0].child("mod")[j].attribute("name");
				_mc["tx1"].text=list.child("mods")[0].child("mod")[j].attribute("descr");
				_mc["tx2"].text=list.child("mods")[0].child("mod")[j].attribute("descr2");
				_mc["tx4"].text="Цена в "+stg_class.shop["exit"].m_name(0,3,2)+": "+list.child("mods")[0].child("mod")[j].attribute("sn_val");
				_mc["level_tx"].text="Уровень "+list.child("mods")[0].child("mod")[j].attribute("level");
				_mc["buy_ar"].price=[int(list.child("mods")[0].child("mod")[j].attribute("money_m")),int(list.child("mods")[0].child("mod")[j].attribute("money_z")),int(list.child("mods")[0].child("mod")[j].attribute("money_a"))];
				_mc["buy_val"].price=int(list.child("mods")[0].child("mod")[j].attribute("sn_val"));
				_mc["buy_val"].ID=_mc["buy_ar"].ID=list.child("mods")[0].child("mod")[j].attribute("id");
				for(var i:int=0;i<_mc["buy_ar"].price.length;i++){
					//trace(_mc["buy_ar"].price[i]+"   "+stg_class.shop["exit"].getMoneys(i));
					if(_mc["buy_ar"].price[i]<=0){
						_ar[i]=0;
						_mc["buy_ar"].visible=false;
						_mc["tx3"].text="За "+stg_class.shop["exit"].m_name(0,2,1)+" и "+stg_class.shop["exit"].m_name(0,0,1)+" не продаётся";
						_mc["tx3"].textColor=0x999999;
					}else{
						//trace("b");
						if(_mc["buy_ar"].price_dub.length<2){
							//trace("c");
							_mc["buy_ar"].price_dub[0]=i;
							_mc["buy_ar"].visible=true;
						}
						
						//trace("d");
						var _str_v:String="Цена:";
						var _b_m:int=0;
						for(var n:int=0;n<_mc["buy_ar"].price_dub.length;n++){
							//trace("e");
							_str_v+=" "+_mc["buy_ar"].price[_mc["buy_ar"].price_dub[n]]+" "+stg_class.shop["exit"].m_name(0,_mc["buy_ar"].price_dub[n]);
							if(n<_mc["buy_ar"].price_dub.length-1){
								_str_v+="+";
							}
							_mc["tx3"].text=_str_v;
							//trace("f");
							if(_mc["buy_ar"].price[_mc["buy_ar"].price_dub[n]]>stg_class.shop["exit"].getMoneys(_mc["buy_ar"].price_dub[n])){
								_b_m=1;
								_mc["buy_ar"].alpha=.5;
								_mc["tx3"].textColor=0x999999;
								_mc["buy_ar"]["closed"]=true;
							}else if(_top!=0&&_top>_top_n){
								_b_m=2;
								_mc["buy_ar"].alpha=.5;
								_mc["tx3"].textColor=0x999999;
								_mc["buy_ar"]["closed"]=true;
								_mc["buy_ar"].textColor=0x990000;
							}else if(_b_m==0){
								_mc["tx3"].textColor=0x006600;
								_mc["buy_ar"]["closed"]=false;
							}
							//trace("g");
							//_mc["buy_ar"].pr_num=_mc["buy_ar"].price[i];
							_ar1[_mc["buy_ar"].price_dub[n]]=1;
						}
						_mc["buy_ar"].val_tx=_str_v;
						
						break;
					}
				}
				_mc["buy_val"].pr_num=_mc["buy_val"].price;
				_mc["buy_ar"].vals=_ar1;
				_mc["buy_val"].vals=_ar;
				if(int(list.child("mods")[0].child("mod")[j].attribute("sn_val"))>stg_class.shop["exit"].getMoneys(3)){
					_mc["tx4"].textColor=0x999999;
				}else{
					_mc["tx4"].textColor=0x006600;
				}
				if(int(list.child("mods")[0].child("mod")[j].attribute("sn_val"))<=0){
					_mc["buy_val"].visible=false;
					_mc["tx4"].text="За "+stg_class.shop["exit"].m_name(0,3,1)+" не продаётся";
					_mc["tx4"].textColor=0x999999;
				}
				if(int(list.child("mods")[0].child("mod")[j].attribute("level"))<3){
					_mc["tx1"].textColor=_mc["tx2"].textColor=0x330099;
				}else if(int(list.child("mods")[0].child("mod")[j].attribute("level"))<5){
					_mc["tx1"].textColor=_mc["tx2"].textColor=0x990000;
				}else{
					_mc["tx1"].textColor=_mc["tx2"].textColor=0xFF0000;
				}
				if(int(list.child("mods")[0].child("mod")[j].attribute("hidden"))==1){
					_mc["buy_ar"].visible=false;
					_mc["buy_val"].visible=false;
				}else if(int(list.child("mods")[0].child("mod")[j].attribute("hidden"))>0){
					_mc["buy_ar"].alpha=.5;
					_mc["buy_val"].alpha=.5;
					_mc["buy_val"]["closed"]=true;
					_mc["buy_ar"]["closed"]=true;
				}
				newPict(list.child("mods")[0].child("mod")[j].attribute("img"),_mc,1);
				_mc.x=5;
				_mc.y=_pos;
				_pos+=_mc.height;
				lev_cl.addChild(_mc);
			}
			
			lev_cl.x=3;
			lev_cl.y=3;
			if(lev_cl["close_lev1"].y+lev_cl["close_lev1"].height+7>(_sc_wd+2)){
				lev_cl["close_lev1"].y=(_sc_wd+2)-(lev_cl["close_lev1"].height+7);
			}
			//trace((_sc_wd+2)+"   "+lev_cl["close_lev1"].y);
			Mouse.cursor=MouseCursor.AUTO;
			try{
				weap_cl.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollVip);
			}catch(er:Error){}
			weap_cl.addChild(lev_cl);
			weap_cl.setChildIndex(weap_cl["lev_line_b"],weap_cl.numChildren-1);
			var w_l_gr:Graphics=weap_cl["lev_line_b"].graphics;
			w_l_gr.clear();
			if(lev_cl.y+lev_cl.height>_sc_wd+1){
				w_l_gr.lineStyle(2,0x195F1E);
				w_l_gr.moveTo(lev_cl.x,_sc_wd+1);
				w_l_gr.lineTo(lev_cl.x+lev_cl.width-2,_sc_wd+1);
			}
			try{
				weap_cl.parent.removeChild(weap_cl["sc_clip"]);
				var _rct:Rectangle=weap_cl.scrollRect;
				weap_cl._sc_y=_rct.y;
				_rct.y=0;
				weap_cl.scrollRect=_rct;
			}catch(er:Error){}
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getVip(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("getVip str   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nVIP.");
				stg_cl.erTestReq(1,4,str);
				return;
			}
			//trace("getVip\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))!=4){
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"",5);
					}
					return;
				}
			}catch(er:Error){
				
			}
			
			vipReset();
			weap_cl=new weapons();
			setVip(list,St_clip["stg_cl"],weap_cl,394);
			weap_cl.x=6;
			weap_cl.y=60;
			weap_cl.sc_clip.x=weap_cl.scrollRect.width+weap_cl.x;
			weap_cl.sc_clip.y=weap_cl.y+1;
			
			stg_cl.createMode(11);
			root["obmen_b"].visible=false;
			root["exit_cl1"].visible=false;
			try{root["vkl1"].setVkl(0);}catch(e:Error){}
			stg_cl.warn_f(9,"");
			try{stg_class.shop["exit"].buy_mem("re_try");}catch(er:Error){}
			try{stg_class.shop["exit"].buy_mem("end");}catch(er:Error){}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var _sc_wd:int=394;
		
		public function setVip(list:XML,_cont:MovieClip,_child:MovieClip,_sc_rw):void{
			_sc_wd=_sc_rw;
			var rzd_y:int=0;
			var clr_tr:ColorTransform=new ColorTransform();
			for(var i:int=0;i<list.child("mods")[0].child("razdel").length();i++){
				var group_y:int=14;
				var group_x:int=7;
				var rzd_clr:int=int(list.child("mods")[0].child("razdel")[i].attribute("color"));
				var rzd_type:int=int(list.child("mods")[0].child("razdel")[i].attribute("type"));
				var rzd_w:int=568;
				var razdel:MovieClip;
				if(rzd_type==0){
					razdel=new razdel_mod();
				}else{
					razdel=new razdel_tank();
				}
				razdel["name_tx"].text=list.child("mods")[0].child("razdel")[i].attribute("name");
				razdel["info"].i_text=list.child("mods")[0].child("razdel")[i].attribute("descr");
				
				if(int(list.child("mods")[0].child("razdel")[i].attribute("not_work"))==0){
					razdel.removeChild(razdel["not_work"]);
				}
				razdel.x=3;
				razdel.y=(rzd_y);
				_child.addChild(razdel);
				for(var j:int=0;j<list.child("mods")[0].child("razdel")[i].child("group").length();j++){
					var group:MovieClip;
					if(rzd_type==0){
						group=new mod_rzd();
						group._lim=3;
						if(int(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod").length())<4){
							group["right_cl"].gotoAndStop("empty");
						}
					}else{
						group=new tank_rzd();
						group._lim=6;
						if(int(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod").length())<7){
							group["right_cl"].gotoAndStop("empty");
						}
					}
					group._len=int(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod").length());
					group["left_cl"].gotoAndStop("empty");
					group.rzd_type=rzd_type;
					group.moveTm=new Timer(40,25);
					group._vect=1;
					group._pos=0;
					group.sc_w=0;
					group["name_tx"].text=list.child("mods")[0].child("razdel")[i].child("group")[j].attribute("name");
					group["info"].i_text=list.child("mods")[0].child("razdel")[i].child("group")[j].attribute("descr");
					group["num_tx"].text=list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod").length();
					group.x=(group_x);
					group.y=(group_y);
					if(rzd_w<group.x+group.width){
						rzd_w=group.x+group.width;
					}
					var gr_clr:int=int(list.child("mods")[0].child("razdel")[i].child("group")[j].attribute("color"));
					var gr_clr1:int=int(list.child("mods")[0].child("razdel")[i].child("group")[j].attribute("color1"));
					var gr_clr2:int=int(list.child("mods")[0].child("razdel")[i].child("group")[j].attribute("color2"));
					var mod_y:int=0;
					var mod_x:int=0;
					clr_tr.color=gr_clr;
					group["top"].transform.colorTransform = clr_tr;
					clr_tr.color=gr_clr1;
					group["back_gr"].transform.colorTransform = clr_tr;
					razdel.addChild(group);
					if(rzd_type==0){
						if(group_x==7){
							group_x+=group.width+3;
						}else{
							group_x=7;
							if(j>0){
								group_y+=group.height+1.5;
							}
						}
					}else{
						group_y+=group.height+4.5;
					}
					if(int(list.child("mods")[0].child("razdel")[i].child("group")[j].attribute("new"))==0){
						group.removeChild(group["new_cl"]);
					}
					for(var n:int=0;n<list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod").length();n++){
						var mod_type:int=int(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("type"));
						var mod:MovieClip;
						if(rzd_type==0){
							mod=new cl_rzd_mod();
							mod["show_info"].tank=mod["buy_mod"].tank=0;
						}else{
							mod=new cl_tank();
							mod["show_info"].tank=mod["buy_mod"].tank=1;
						}
						group.sc_w=mod.width+3;
						mod["pict"].i_text=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("descr"));
						/*mod["pict"].addEventListener(MouseEvent.MOUSE_OVER, function(){
							var _pnt:Point=localToGlobal(new Point(mod.x,mod.y));
							showInfo(mod["pict"]["i_text"]+"",_pnt.x-15,_pnt.y,height);
						});
						mod.removeEventListener(MouseEvent.MOUSE_OUT, function(){
							hideInfo();
						});*/
						mod["show_info"].dscr1=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("descr1"));
						mod["show_info"].dscr2=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("descr2"));
						mod["show_info"].dscr3=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("descr3"));
						mod["show_info"].dscr4=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("descr4"));
						mod["name_tx"].text=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("name"));
						mod["show_info"].ID=mod["buy_mod"].ID=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("id"));
						mod["show_info"].lvl=mod["buy_mod"].lvl=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("level"));
						mod["show_info"].mass=mod["buy_mod"].mass=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("mass"));
						mod["show_info"].stab=mod["buy_mod"].stab=(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("prochnost"));
						mod["show_info"].price_m=mod["buy_mod"].price_m=int(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("money_m"));
						mod["show_info"].price_z=mod["buy_mod"].price_z=int(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("money_z"));
						mod["show_info"].price_a=mod["buy_mod"].price_a=int(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("money_a"));
						mod["show_info"].price_sn=mod["buy_mod"].price_sn=int(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("sn_val"));
						mod["show_info"].price=mod["buy_mod"].price=[int(mod["show_info"].price_m),int(mod["show_info"].price_z),int(mod["show_info"].price_a),int(mod["show_info"].price_sn)];
						mod["show_info"].vals=mod["buy_mod"].vals=[int(Boolean(mod["show_info"].price_m)),int(Boolean(mod["show_info"].price_z)),int(Boolean(mod["show_info"].price_a)),int(Boolean(mod["show_info"].price_sn))];
						mod["show_info"].info_ar=mod["buy_mod"].info_ar=[list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("descr1"),
																														 list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("descr2"),
																														 list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("descr3"),
																														 list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("descr4")];
						if(int(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("hidden"))!=0){
							mod["show_info"].gotoAndStop("empty");
							mod["buy_mod"].gotoAndStop("empty");
						}
						clr_tr.color=gr_clr2;
						mod["top"].transform.colorTransform = clr_tr;
						group.sc_h=mod.height;
						if(n==0){
							if(rzd_type==0){
								group["rect"].scrollRect=new Rectangle(0,0,(mod.width*3+3*2),mod.height+1);
							}else{
								group["rect"].scrollRect=new Rectangle(0,0,(mod.width*6+3*5),mod.height+1);
							}
						}
						if(mod_type==0){
							mod.removeChild(mod["show_info"]);
						}else{
							mod.removeChild(mod["buy_mod"]);
						}
						mod.x=(mod_x);
						mod.y=(mod_y);
						mod_x+=mod.width+3;
						group["rect"].addChild(mod);
						mod["pict"].load_er=0;
						var pre_cl:MovieClip=new (stg_class.mini_pre)();
						pre_cl.x=(mod["pict"].width-pre_cl.width)/2;
						pre_cl.y=(mod["pict"].height-pre_cl.height)/2;
						mod["pict"].pre_cl=pre_cl;
						mod["pict"].addChild(mod["pict"].pre_cl);
						loads.push([mod["pict"],(list.child("mods")[0].child("razdel")[i].child("group")[j].child("mod")[n].attribute("img"))]);
					}
				}
				razdel.graphics.clear();
				razdel.graphics.beginFill(0xFFCC33);
				razdel.graphics.lineStyle(1,rzd_clr);
				razdel.graphics.drawRect(.5,13.5,rzd_w+3,razdel.height-10);
				clr_tr.color=rzd_clr;
				razdel["top"].transform.colorTransform = clr_tr;
				rzd_y+=razdel.height+3;
			}
			_child.graphics.clear();
			_child.graphics.beginFill(0x000000,0);
			_child.graphics.drawRect(0,0,_child.width,_child.height);
			_child._H=_child.height;
			var sc_clip:MovieClip=new scroll_prds();
			sc_clip.name="sc_vip";
			try{
				_child.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollVip);
			}catch(er:Error){}
			var _w:int=0;
			var rect:Rectangle=_child.scrollRect;
			if(_child._H>_sc_wd){
				sc_clip.visible=true;
				sc_clip["sc_rect"].graphics.clear();
				sc_clip["sc_rect"].graphics.lineStyle(1,0x9A0700);
				sc_clip["sc_rect"].graphics.beginFill(0xFCE3C5);
				sc_clip["sc_rect"].graphics.drawRect(sc_clip["to_left"].width+2,1,_sc_wd-(sc_clip["to_left"].width*2+3),sc_clip["to_left"].height-1);
				sc_clip["to_right"].x=sc_clip["sc_rect"].width+sc_clip["to_right"].width*2+3;
				_w=(_sc_wd/_child._H)*(sc_clip["sc_rect"].width-4);
				if(_w<9){
					_w=9;
				}
				sc_clip["sc_mover"]["sc_fill"].graphics.clear();
				sc_clip["sc_mover"]["sc_fill"].graphics.beginFill(0x990000);
				sc_clip["sc_mover"]["sc_fill"].graphics.drawRect(0,2,_w,11);
				sc_clip["sc_mover"]["sc_zn"].x=Math.round(_w/2)-.5;
				sc_clip["sc_mover"].x=sc_clip["to_left"].width+4;
				_child.addEventListener(MouseEvent.MOUSE_WHEEL, scrollVip);
			}else{
				if(rect!=null){
					rect.y=0;
				}
				sc_clip.visible=false;
			}
			
			_child.scrollRect=new Rectangle(0,0,594,_sc_wd+2);
			sc_clip.rotation=90;
			_child.sc_clip=sc_clip;
			if(loads.length>0){
				loads[0][0].LoadImage(loads[0][1]);
			}else{
				tanksSlots();
			}
			
			_child["buy_over"].visible=false;
			_child["buy_tank"].visible=false;
			_child["win_cl"].visible=false;
			_cont.addChild(_child);
			_cont.addChild(_child.sc_clip);
		}
		
		public static var vipTmUp:Timer=new Timer(100);
		public static var vipTmDn:Timer=new Timer(100);
		
		public function scrollVipWin(Y:Number,_i:int=0):void{
			var rect:Rectangle=weap_cl.scrollRect;
			rect.y=(((Y-weap_cl.sc_clip["to_left"].width-4)/(weap_cl.sc_clip["sc_rect"].width-weap_cl.sc_clip["sc_mover"].width))*(weap_cl._H-rect.height))*1.035;
			weap_cl.scrollRect=rect;
			var rect1:Rectangle=weap_cl.scrollRect;
			if(weap_cl["win_cl"].visible){
				weap_cl["win_cl"].y=71+rect1.y;
			}else if(weap_cl["buy_tank"].visible){
				weap_cl["buy_tank"].y=71+rect1.y;
			}else if(weap_cl["buy_over"].visible){
				weap_cl["buy_over"].y=112+rect1.y;
			}
			if(lev_cl!=null){
				lev_cl.y=3+rect1.y;
			}
			/*if(Y==weap_cl.sc_clip["sc_rect"].x+weap_cl.sc_clip["sc_rect"].width){
				trace("move   "+rect.y+"   "+weap_cl._H);
			}*/
		}
		
		public function scVipStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, scVipStop);
				stage.removeEventListener(Event.ENTER_FRAME, btn_scrollVip);
			}catch(er:Error){}
			weap_cl.sc_clip["sc_mover"].x_coor=null;
			/*Mouse.cursor=MouseCursor.BUTTON;
			try{
				gotoAndStop("over");
			}catch(er:Error){}*/
		}
		
		public function btn_scrollVip(event:Event){
			if(weap_cl.sc_clip.mouseX-weap_cl.sc_clip["sc_mover"]["x_coor"]<weap_cl.sc_clip["to_left"].width+4){
				weap_cl.sc_clip["sc_mover"].x=weap_cl.sc_clip["to_left"].width+4;
			}else if(weap_cl.sc_clip.mouseX+weap_cl.sc_clip["sc_mover"].width-weap_cl.sc_clip["sc_mover"]["x_coor"]>weap_cl.sc_clip.height-weap_cl.sc_clip["to_left"].width-2){
				weap_cl.sc_clip["sc_mover"].x=weap_cl.sc_clip.height-weap_cl.sc_clip["to_left"].width-weap_cl.sc_clip["sc_mover"].width-2;
			}else{
				weap_cl.sc_clip["sc_mover"].x=weap_cl.sc_clip.mouseX-weap_cl.sc_clip["sc_mover"]["x_coor"];
			}
			scrollVipWin(weap_cl.sc_clip["sc_mover"].x);
			//trace(root["sc_mess"]["sc_mover"].x+"   "+root["sc_mess"]["to_left"].width);
			/*Mouse.cursor=MouseCursor.AUTO;
			try{
				gotoAndStop("out");
			}catch(er:Error){}*/
		}
		
		public function arrowVipStop(event:MouseEvent){
			try{
				stage.removeEventListener(MouseEvent.MOUSE_UP, arrowVipStop);
			}catch(er:Error){}
			try{
				vipTmUp.reset();
			}catch(er:Error){}
			try{
				vipTmDn.reset();
			}catch(er:Error){}
			weap_cl.sc_clip["sc_mover"].x_coor=null;
		}
		
		public function arrowUpVip(event:TimerEvent){
			if(weap_cl.sc_clip["sc_mover"].x-weap_cl.sc_clip["sc_mover"].width/8<weap_cl.sc_clip["to_left"].width+4){
				weap_cl.sc_clip["sc_mover"].x=weap_cl.sc_clip["to_left"].width+4;
			}else{
				weap_cl.sc_clip["sc_mover"].x-=weap_cl.sc_clip["sc_mover"].width/8;
			}
			scrollVipWin(weap_cl.sc_clip["sc_mover"].x,1);
		}
		
		public function arrowDnVip(event:TimerEvent){
			if(weap_cl.sc_clip["sc_mover"].x+weap_cl.sc_clip["sc_mover"].width/8>weap_cl.sc_clip.height-weap_cl.sc_clip["to_left"].width-weap_cl.sc_clip["sc_mover"].width-2){
				weap_cl.sc_clip["sc_mover"].x=weap_cl.sc_clip.height-weap_cl.sc_clip["to_left"].width-weap_cl.sc_clip["sc_mover"].width-2;
			}else{
				weap_cl.sc_clip["sc_mover"].x+=weap_cl.sc_clip["sc_mover"].width/8;
			}
			scrollVipWin(weap_cl.sc_clip["sc_mover"].x,1);
		}
		
		public function scrollVip(event:MouseEvent):void{
			//trace(event.delta); weap_cl.scrollRect=new Rectangle(0,0,594,395);
			if(lev_cl!=null&&lev_cl.stage!=null){
				return;
			}
			var rect:Rectangle=weap_cl.scrollRect;
			var _sc:int=rect.y-event.delta*((weap_cl._H/rect.height)*3);
			//trace(rect.y+"   "+event.delta+"   "+_sc+"   "+weap_cl.width+"   "+weap_cl.scrollRect.width);
			if(_sc<0){
				_sc=0;
			}else if(_sc>weap_cl._H-rect.height){
				_sc=weap_cl._H-rect.height;
			}
			//trace(event.delta+"   "+_sc);
			if(weap_cl["win_cl"].visible){
				weap_cl["win_cl"].y+=_sc-rect.y;
			}else if(weap_cl["buy_tank"].visible){
				weap_cl["buy_tank"].y+=_sc-rect.y;
			}else if(weap_cl["buy_over"].visible){
				weap_cl["buy_over"].y+=_sc-rect.y;
			}
			if(lev_cl!=null){
				lev_cl.y+=_sc-rect.y;
			}
			rect.y=_sc;
			weap_cl.scrollRect=rect;
			weap_cl.sc_clip["sc_mover"].x=(rect.y/weap_cl._H)*((weap_cl.sc_clip["sc_rect"].width-8))+weap_cl.sc_clip["to_left"].width+4;
			//trace("scroll   "+rect.y+"   "+weap_cl._H);
		}
		
		public function vipReset(){
			root["obmen"].visible=false;
			root["obmen_b"].visible=true;
			root["exit_cl1"].visible=true;
			try{
				weap_cl.removeChild(lev_cl);
			}catch(er:Error){}
			try{
				St_clip["stg_cl"].removeChild(weap_cl);
			}catch(er:Error){}
			try{
				St_clip["stg_cl"].removeChild(weap_cl.sc_clip);
			}catch(er:Error){}
			try{
				St_clip["stg_cl"].removeChild(avas_cl);
			}catch(er:Error){}
			try{
				St_clip["stg_cl"].removeChild(packs_cl);
			}catch(er:Error){}
			try{
				St_clip["stg_cl"].removeChild(arsnl_cl);
			}catch(er:Error){}
			stg_cl.createMode(1);
		}
		
		public function newPict(_str:String,_cl:MovieClip,_i:int=0){
			var loader:Loader = new Loader();
			loader.name="us_ava";
			loader.x=3;
			loader.y=32;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event){
				//trace(event.currentTarget.content)
				if(_i!=2){
					try{
						_cl.removeChild(_cl.getChildByName("pict_cl"));
					}catch(er:Error){}
					var _clip:MovieClip=new MovieClip();
					_clip.graphics.clear();
					_clip.graphics.beginBitmapFill(event.currentTarget.content.bitmapData);
					_clip.graphics.drawRect(0,0,event.currentTarget.content.width,event.currentTarget.content.height);
					_clip.name="pict_cl";
					if(_i==0){
						_clip.y=25;
						_clip.x=_cl.width/2-_clip.width/2;
					}else if(_i==1){
						_clip.y=6;
						_clip.x=76-_clip.width/2;
					}else if(_i==3){
						_clip.y=17;
						_clip.x=_cl.width/2-_clip.width/2;
					}
					_cl.addChild(_clip);
					_cl.pict=event.currentTarget.content;
				}else{
					_cl.graphics.clear();
					_cl.graphics.beginBitmapFill(event.currentTarget.content.bitmapData);
					_cl.graphics.drawRect(0,0,event.currentTarget.content.width,event.currentTarget.content.height);
					_cl.pict=event.currentTarget.content;
				}
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, unLoadPict);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadPict);
			
			loader.load(new URLRequest(stg_class.res_url+"/"+_str));
		}
		
		public function unLoadPict(event:IOErrorEvent):void{
			//stg_cl.warn_f(4,"VIP");
		}
		
		public function accessError(event:SecurityErrorEvent):void{
			//stg_cl.warn_f(4,"VIP");
		}
		
		public function onError(event:Event):void{
			//trace("Select+php2: "+event);
			if(arsnl_cl!=null){
				arsnl_cl["conf_win"]._rp=null;
				arsnl_cl["conf_win"]._trg=null;
			}
			last_send=null;
			stg_cl.warn_f(4,"VIP");
		}
		
	}
}