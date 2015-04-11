package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;
	//import flash.accessibility.*;
	
	//[SWF(width="800", height="600", frameRate="40")]
	public class myStage extends MovieClip{
		
		public static var prnt_cl:MovieClip;
		public static var self:MovieClip;
		public static var shop:MovieClip;
		public static var panel:MovieClip;
		public static var wind:MovieClip;
		public static var warn_cl:MovieClip;
		public static var contur:MovieClip;
		public static var win_cl:MovieClip;
		public static var exp_cl:MovieClip;
		public static var chat_cl:MovieClip;
		public static var stat_cl:MovieClip;
		public static var svodka_cl:MovieClip;
		public static var wall_cl:MovieClip;
		public static var games_cl:MovieClip;
		public static var help_cl:MovieClip;
		public static var opt_cl:MovieClip;
		public static var polk_st_cl:MovieClip;
		//public static var inv_cl:MovieClip;
		public static var vip_cl:MovieClip;
		public static var akadem_cl:MovieClip;
		public static var kaskad:MovieClip;
		public static var frst_nws:MovieClip;
		public static var info_help:MovieClip;
		public static var clips_lib:MovieClip;
		public static var p2p_client:MovieClip;
		
		public static var p2p_on:Boolean=false; // p2p module on/off
		public static var can_p2p:Boolean=false;
		public static var p2p_ar:Array=new Array();
		
		public var cl_lib_dmn:ApplicationDomain = new ApplicationDomain();
		
		//public static var txt:TextField=new TextField();
		//public static var tf:TextFormat=new TextFormat("Verdana", 12, 0x000000, true, false);
		//public static var progressBar:MovieClip=new MovieClip();
		public static var pl_clip:MovieClip;
		
		public static var cont:MovieClip;
		public static var bull:MovieClip;
		public static var ground:MovieClip;
		public static var wall:MovieClip;
		public static var expls:MovieClip;
		public static var curs:MovieClip;
		
		public static var electro_fx,laser_fx,expl_efx1,emi,expld1,expld2,expld3,expld4,tral:Class;
		public static var mini_pre:Class;
		public static var pict_links:Object=new Object();
		public static var vip_weap:Class;
		
		public static var grounds:Array=new Array();
		public static var mines:Array=new Array();
		public static var base:Array=new Array();
		public static var base_pos:Array=new Array();
		public static var m_names:Array=new Array();
		public static var m_rangs:Array=new Array();
		public static var m_skins:Array=new Array();
		public static var m_ava:Array=new Array();
		public static var m_idies:Array=new Array();
		public static var m_nums:Array=new Array(20);
		public static var b_names:Array=new Array();
		public static var b_rangs:Array=new Array();
		public static var b_skins:Array=new Array();
		public static var b_nums:Array=new Array();
		
		public static var teslaes:Array=new Array(lWidth*lHeight);
		public static var walls:Array=new Array();
		public static var objs:Array=new Array();
		public static var obj1:Array=new Array();
		public static var obj_id:Array=new Array();
		public static var obj_vect:Array=new Array();
		public static var obj_heal:Array=new Array();
		public static var obj_heal1:Array=new Array();
		public static var obj_gun:Array=new Array();
		public static var obj_speed:Array=new Array();
		public static var obj_pos:Array=new Array();
		public static var obj_name:Array=new Array();
		public static var obj_resp:Array=new Array();
		public static var obj_R:Array=new Array();
		public static var obj_type:Array=new Array();
		public static var obj_time:Array=new Array();
		public static var obj_pict:Array=new Array();
		public static var obj_c:Array=new Array();
		public static var obj_pow:Array=new Array();
		public static var obj_step:Array=new Array();
		public static var obj_rand:Array=new Array();
		public static var obj_num:Array=new Array();
		public static var obj_obj:Array=new Array();
		public static var obj_tail:Array=new Array();
		
		public static var bonuses:Array=new Array();
		public static var bon_id:Array=new Array();
		public static var bon_pos:Array=new Array();
		public static var bon_time:Array=new Array();
		public static var bon_type:Array=new Array();
		public static var bon_pow:Array=new Array();
		public static var bon_step:Array=new Array();
		public static var bon_pict:Array=new Array();
		public static var bon_c:Array=new Array();
		
		public static var lWidth:int=25;
		public static var lHeight:int=19;
		//public static var mWidth:int=25*24;
		//public static var mHeight:int=19*24;
		public static var baseWidth:int=0;
		public static var bonWidth:int=0;
		public static var gunWidth:int=0;
		public static var tanksWidth:int=0;
		public static var waiting:int=0;
		public static var b_count:int=0;
		public static var bm_count:int=0;
		public static var ammo:int=100;
		public static var tr_count:int=0;
		public static var sm_count:int=0;
		public static var stels_c:int=0;
		public static var basic_dm:int=20;
		public static var steps:int=0;
		
		public static var myCode:Array=new Array(6);
		public static var map_id:Array=new Array(0,0,0,0);
		public static var ammo_dm:Array=new Array(0,0,0,0,0,0);
		public static var ammo_sp:Array=new Array(0,0,0,0,0,0);
		public static var mines_dm:Array=new Array(0,0,0,0);
		public static var tracks:Array=new Array(100);
		public static var track_c:Array=new Array(100);
		public static var track_c1:Array=new Array(100);
		public static var track_pos:Array=new Array(100);
		public static var smokes:Array=new Array(100);
		public static var smoke_c:Array=new Array(100);
		public static var smoke_c1:Array=new Array(100);
		public static var smoke_x:Array=new Array(100);
		public static var smoke_y:Array=new Array(100);
		public static var booms:Array=new Array(100);
		public static var boom_t:Array=new Array(100);
		public static var boom_c:Array=new Array(100);
		public static var boom_c1:Array=new Array(100);
		public static var boom_x:Array=new Array(100);
		public static var boom_y:Array=new Array(100);
		public static var hides:Array=new Array(100);
		public static var hide_c:Array=new Array(100);
		public static var hide_c1:Array=new Array(100);
		public static var hide_x:Array=new Array(100);
		public static var hide_y:Array=new Array(100);
		public static var roc_c:Array=new Array();
		public static var roc_x:Array=new Array();
		public static var roc_y:Array=new Array();
		public static var air_c:Array=new Array();
		public static var air_x:Array=new Array();
		public static var air_y:Array=new Array();
		
		public var i:int=0;
		public var j:int=0;
		public var n:int=0;
		public var k:int=0;
		public static var mWidth:int=600;
		public static var mHeight:int=456;
		public static var board_x:int;
		public static var board_y:int;
		public static var tank_id:int;
		public static var tank_num:int;
		public static var tank_type:int;
		public static var tank_skin:int=0;
		public static var next_go:int;
		public static var ex_count:int=1;
		public static var m_mode:int=0;
		public static var f_cd:int=17;
		public static var f_cd1:int=12;
		public static var fire_cd:int=17;
		public static var lifes:int=0;
		public static var plus_xp:int=0;
		public static var xp_time:int=0;
		public static var norm_sp:Number=0;
		public static var fast_sp:Number=0;
		public static var m1_time:int=0;
		public static var m2_time:int=0;
		public static var m3_time:int=0;
		public static var steps1:Number=0;
		public static var steps2:Number=0;
		public static var steps3:Number=0;
		public static var m1_left:int=0;
		public static var m2_left:int=0;
		public static var m3_left:int=0;
		public static var m1_do:Boolean=false;
		public static var m2_do:Boolean=false;
		public static var m3_do:Boolean=false;
		public static var f_shot:Boolean=false;
		public static var rang_st:String="";
		public static var rang_name:String="";
		public static var pl_name:String="";
		public var g_num:int=-1;
		public var f_num:Number;
		
		public function get rang_jbr():String{
			return rang_st.split("/").join("|");
		}
		
		//public static var myByteArray:ByteArray=new ByteArray();
		//public var my_map:String="";
		
		public static var url_count:int=0;
		public static var any_count:int=0;
		public static var count:int=0;
		public static var fcount:int=0;
		public static var time_c:int=0;
		public static var step_c:int=0;
		public static var xp_count:int=0;
		public static var wall_load:Boolean=false;
		public static var wall_mess:Boolean=true;
		public var wall_win:Boolean=false;
		public var drag_cl:MovieClip;
		
		public function showWall(){
			prnt_cl.output("client showWall\n",1);
			try{
				wind["choise_cl"].stopStatus();
			}catch(er:Error){}
			prnt_cl.wallImage();
		}
		
		public var upl_mess:String="";
		public var upl_mess1:String="";
		public var upl_name:String="";
		public var upl:Array=new Array(4);
		public var holly:Array=new Array("1","2");
		
		public function newMedal(a:String,b:String,c:String,d:String){
				warn_f(10,"Соединение...");
				var rqs:URLRequest=new URLRequest(scr_url+"?query="+2+"&action="+7);
				rqs.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader(rqs);
				var strXML:String="<query id=\"2\"><action id=\"7\"  idm=\""+a+"\" /></query>";
				//trace(strXML);
				var variables:URLVariables = new URLVariables();
				variables.query = strXML;
				variables.send = "send";
				rqs.data = variables;
				loader.addEventListener(IOErrorEvent.IO_ERROR, se12ndEr);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, se12Er);
				loader.addEventListener(Event.COMPLETE, MedalReady);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(rqs);
				//errTest(strXML,50);
		}
		
		public function se12Er(event:SecurityErrorEvent){
			warn_f(3,"Публикация на стену");
		}
		
		public function se12ndEr(event:IOErrorEvent){
			warn_f(4,"Публикация на стену\n"+event.text);
		}
		
		public function MedalReady(event:Event){
			var mstr:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("MedalReady   "+str);
			try{
				var list:XML=new XML(mstr);
				list=list.child("result")[0];
			}catch(er:Error){
				warn_f(5,"Неверный формат полученных данных. \nМедаль.");
				erTestReq(2,7,mstr);
				return;
			}
			//trace("list   "+list);
			if(int(list.child("err")[0].attribute("code"))==0){
				//trace(list.child("err")[0].attribute("comm"));
				prnt_cl._sendImage();
				wall_cl["close_cl"].reset();
				warn_f(9,"");
			}else{
				//trace(list.child("err")[0].attribute("comm"));
				warn_f(5,list.child("err")[0].attribute("comm"));
			}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public var buy_send:Array=new Array();
		public var buy_fc:int=0;
		
		public static var pl_songs:Array=new Array();
		public static var last_songs:Array=new Array();
		public static var pl_song:int=0;
		public static var pl_er:int=0;
		
		public function next_song(event:Event){
			//trace("pl_song   "+pl_song);
			try{
				s_m_pl.close();
			}catch(er:Error){
				//trace("close   "+er);
			}
			try{
				channel1.stop();
			}catch(er:Error){
				//trace("stop   "+er);
			}
			last_songs.push(pl_song);
			if(last_songs.length>100){
				last_songs.shift();
			}
			if(!pl_rand){
				pl_song++;
			}else{
				pl_song=Math.floor(Math.random()*pl_songs.length);
			}
			if(pl_song>=pl_songs.length){
				pl_song=0;
			}else if(pl_song<0){
				pl_song=pl_songs.length-1;
			}
			if(music_on){
				try{
					s_m_pl=new Sound(pl_songs[pl_song]);
					channel1 = new SoundChannel();
					s_m_pl.addEventListener(IOErrorEvent.IO_ERROR, ioErrors);
					channel1 = s_m_pl.play();
					channel1.addEventListener(Event.SOUND_COMPLETE, next_song);
				}catch(er:Error){
					
				}
			}
		}
		
		public function song(s_num:int){
			if(pl_songs.length==0){
				return;
			}
			try{
				s_m_pl.close();
			}catch(er:Error){
				//trace("close   "+er);
			}
			try{
				channel1.stop();
			}catch(er:Error){
				//trace("stop   "+er);
			}
			last_songs.push(pl_song);
			if(last_songs.length>100){
				last_songs.shift();
			}
			pl_song=s_num;
			if(pl_song>=pl_songs.length){
				pl_song=0;
			}else if(pl_song<0){
				pl_song=pl_songs.length-1;
			}
			//trace("pl_song   "+pl_song);
			try{
				s_m_pl=new Sound(pl_songs[pl_song]);
				channel1 = new SoundChannel();
				s_m_pl.addEventListener(IOErrorEvent.IO_ERROR, ioErrors);
				channel1 = s_m_pl.play();
				channel1.addEventListener(Event.SOUND_COMPLETE, next_song);
			}catch(er:Error){
				
			}
		}
		
		public function prev_song(){
			if(pl_songs.length==0){
				return;
			}
			try{
				s_m_pl.close();
			}catch(er:Error){
				//trace("close   "+er);
			}
			try{
				channel1.stop();
			}catch(er:Error){
				//trace("stop   "+er);
			}
			if(last_songs.length>100){
				last_songs.shift();
			}
			pl_song=last_songs[last_songs.length-1];
			if(pl_song>=pl_songs.length){
				pl_song=0;
			}else if(pl_song<0){
				pl_song=pl_songs.length-1;
			}
			//trace("pl_song   "+pl_song);
			try{
				s_m_pl=new Sound(pl_songs[pl_song]);
				channel1 = new SoundChannel();
				s_m_pl.addEventListener(IOErrorEvent.IO_ERROR, ioErrors);
				channel1 = s_m_pl.play();
				channel1.addEventListener(Event.SOUND_COMPLETE, next_song);
				last_songs.pop();
			}catch(er:Error){
				
			}
		}
		
		public function ioErrors(event:IOErrorEvent):void {
      //trace("ioErrorHandler: " + event);
			pl_er++;
			if(pl_er==3){
				pl_er=0;
				pl_song++;
				song(pl_song);
			}else{
				song(pl_song);
			}
    }
		
		public function stop_song(){
			try{
				s_m_pl.close();
			}catch(er:Error){
				trace("close   "+er);
			}
			try{
				channel1.stop();
			}catch(er:Error){
				trace("stop   "+er);
			}
		}
		
		public var s_m_pl:Sound;
		public var pl_music:Boolean=false;
		public var pl_rand:Boolean=false;
		
		public var channel:SoundChannel = new SoundChannel();
		public var channel1:SoundChannel = new SoundChannel();
		
		public function tik_tak(event:Event){
			if(sound_on[0]){
				if(m1_do){
					try{
						channel = new SoundChannel();
						channel = lib.mp3["time"].play();
						channel.addEventListener(Event.SOUND_COMPLETE, tik_tak);
					}catch(er:Error){}
				}
			}
		}
		
		public function tik(){
			if(sound_on[0]){
				try{
					channel = new SoundChannel();
					channel = lib.mp3["time"].play();
					channel.addEventListener(Event.SOUND_COMPLETE, tik_tak);
				}catch(er:Error){
					
				}
			}
		}
		
		public function start_loop(_name:String,_type:int):SoundChannel{
			if(sound_on[_type]){
				try{
					var _ch = new SoundChannel();
					_ch = lib.mp3["time"].play(0,int.MAX_VALUE);
				}catch(er:Error){
					
				}
				return _ch;
			}
			return null;
		}
		
		public function stop_loop(_ch:SoundChannel){
			try{
				_ch.stop();
			}catch(er:Error){}
		}
		
		public function snd_test(event:MouseEvent){
			myStage.self.playSound("gun"+(Math.floor(Math.random()*3)+16),0);
			//m1_do=true;
			//tik();
		}
		
		public function playSound(_name:String,_type:int):*{
			if(!sound_on[_type]){
				return null;
			}
			try{
				var s_ch:SoundChannel=new SoundChannel();
				s_ch=lib.mp3[_name].play();
				return s_ch;
			}catch(er:Error){
				prnt_cl.output("Sound error   "+_name+"\n"+er+"\n",1);
			}
			return null;
		}
		
		public var api_url:String="";
		public var signature:String="";
		public var autor_id:Number=0;
		public var app_user:Number=0;
		public var expl_on:Boolean=true;
		public var track_on:Boolean=true;
		public var smoke_on:Boolean=true;
		public var rad_on:Boolean=true;
		public var bull_on:Boolean=true;
		public var expl_norm:Boolean=true;
		
		public var bl_r:int=0;
		public var bl_time:int=0;
		public var bl_timer:Timer;
		
		public function setBlur(_i:int,_time:int){
			if(!expl_on){
				bl_r=0;
				bl_time=0;
				return;
			}
			if(bl_r<_i){
				bl_r=_i
			}
			var bl_f:BlurFilter=new BlurFilter(1+bl_r,1+bl_r,1);
			cont.filters=[bl_f];
			bl_time=_time-bl_time;
			try{
				bl_timer.stop();
			}catch(er:Error){}
			bl_timer=new Timer(25, bl_time);
			bl_timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent) {
				var _perc:Number=1+bl_r*(1-Math.abs(bl_timer.currentCount/bl_timer.repeatCount-.5)*2);
				//trace(_perc);
				var bl_f:BlurFilter=new BlurFilter(_perc,_perc,1);
				cont.filters=[bl_f];
			});
			bl_timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent) {
				cont.filters=[];
				bl_r=0;
				bl_time=0;
			});
			bl_timer.start();
		}
		
		public function errN(xml:XML,tms:int,_tx:String){
			Errors[0][1]=(_tx);
			warn_f(25,Errors[0][1]+"\n"+"Ожидание "+0+" сек.");
			var TM:Timer=new Timer(1000, tms);
			//trace(xml+"   "+tms);
			TM.addEventListener(TimerEvent.TIMER, function(event:TimerEvent) {
				//trace(tms+"   "+event.currentTarget.currentCount);
				warn_f(25,Errors[0][1]+"\n"+"Ожидание "+event.currentTarget.currentCount+" сек.");
			});
			TM.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent) {
				/*trace(xml);
				trace(scr_url);
				trace(xml.attribute("id"));
				trace(xml.child("action")[0].attribute("id"));*/
				var rqs:URLRequest=new URLRequest(scr_url+"?query="+xml.attribute("id")+"&action="+xml.child("action")[0].attribute("id"));
				rqs.method=URLRequestMethod.POST;
				var loader:URLLoader=new URLLoader(rqs);
				loader.addEventListener(Event.COMPLETE, Errors[0][0]);
				var variables:URLVariables = new URLVariables();
				variables.query = xml;
				variables.send = "send";
				rqs.data = variables;
				loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadHandler);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(rqs);
			});
			TM.start();
		}
		
		public static var Errors:Array=new Array(new Array());
		
		public function newSvodka(sv1:Array,sv2:Array){
			svodka_cl["m_cl"]["closer_cl"].newS(sv1,sv2);
		}
		
		public function myStage(){
			super();
			Security.allowDomain("*");
			self=this;
			stop();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.DEACTIVATE, Deactivated);
			//addEventListener(MouseEvent.MOUSE_DOWN, testClick);
			Errors[0][0]=(overWind);
		}
		
		public static var test_cnt:int=1;
		
		public function testClick(event:MouseEvent){
			if(m_mode==3){
				/*new Impuls(cont.mouseX,cont.mouseY,cont,this,test_cnt);
				test_cnt++;
				if(test_cnt>12){
					test_cnt=1;
				}*/
				
				pl_clip.teslaOn(7,pl_clip["pos_in_map"],250);
			}
		}
		
		public function Activated(event:Event):void{ 
			//errTest("Активировано",int(300/2));
			stage.focus=stage;
		}
		
		public function Deactivated(event:Event):void{ 
			//errTest("Потеря фокуса",int(600/2));
			try{
				stage.focus=stage;
			}catch(er:Error){}
			try{
				myCode=new Array(6);
				hot_keys=new Array(21);
				esc_press=false;
			}catch(er:Error){}
			try{
				chat_cl["_ctrl"]=0;
			}catch(er:Error){}
			
			//errTest("Потеря фокуса   "+buy_fc,int(300/2)-buy_fc*100);
		}
		
		public function resumeF(event:MouseEvent){
			if(socket!=null&&socket.connected&&stage.focus!=stage&&stage.focus!=null){
				stage.focus=stage;
				myCode=new Array(6);
				hot_keys=new Array(21);
				esc_press=false;
			}else{
				
			}
		}
		
		public function onAddedToStage(event:Event):void{ 
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			doLoad();
		}
		
		public function init_f(par_ar:Array,_prnt_cl:MovieClip){ 
			autor_id=par_ar[0];
			u_id=par_ar[0];
			gr_id=par_ar[1];
			v_id=par_ar[2];
			//trace(v_id+"   "+par_ar[2]);
			reff=par_ar[3];
			signature=par_ar[4];
			app_id=par_ar[5];
			api_url=par_ar[6];
			app_user=par_ar[7];
			
			app_code=par_ar[8];
			chat_url=par_ar[9];
			nav_url=par_ar[10];
			
			scr_url=par_ar[11];
			res_url=par_ar[12];
			v_name=par_ar[14];
			tested=par_ar[15];
			poster_id=par_ar[16];
			
			if(app_id==1888415){
				chat_url=("http://cs4686.vkontakte.ru/u68749263/e8e4c859546ce6.zip");    //norm
			}else if(app_id==1891834){
				chat_url=("http://cs4686.vkontakte.ru/u68749263/186aab43c17130.zip");    //test
			}
			if(tested){
				chat_url="res/chat.swf";
			}
			
			prnt_cl=_prnt_cl;
			prnt_cl.initPar();
			
		}
		
		public var poster_id:Number=0;
		public var test_id:Number=0;
		public var app_id:Number=0;
		public var app_code:String="";
		public var chat_url:String="";
		public var nav_url:String="";
		public static var tested:Boolean=false;
		public static var antilag:Boolean=true;
		public static var lag_mess:Boolean=true;
		public static var lag_test:int=0;
		public static var lag_c:int=0;
		public var link_ver:String="";
		
		public static var res_url:String="";
		public static var scr_url:String="";
		public static var serv_url:String="";
		public static var port_num:int=0;
		public static var res_try:int=0;
		
		private function openHandler(event:Event):void {
			////trace("Загрузка карты началась");
		}
		
		private function progressHandler(event:ProgressEvent):void {
			
		}
		
		private function unLoadHandler(event:IOErrorEvent):void {
			errTest("Сервер временно недоступен\n"+event.text,int(600/2));
		}
		
		public static var wall_loaded:Boolean=true;
		public static var mrepeated:Boolean=false;
		public static var was_send:Boolean=false;
		public static var rocket:Boolean=false;
		public static var plane:Boolean=false;
		public static var bomb:Boolean=false;
		public static var new_xp:Boolean=false;
		public static var self_battle:Boolean=false;
		public var game_over:Boolean=false;
		public var wmess:Boolean=false;
		public var sound_on:Array=new Array(true,true);
		public var music_on:Boolean=true;
		
		public static var explode:Boolean=false;
		public static var explode1:Boolean=false;
		public static var explode2:Boolean=false;
		public static var explode3:Boolean=false;
		public static var explode4:Boolean=false;
		
		public static var mdate:Date=new Date();
		public static var millis:Number=0;
		public static var millis1:Number=0;
		
		public var kurs:int=0;
		public var dov_e:Number=0;
		
		public function gameReset(){
			//Ground.self=null;
			try{
				Ground.m_buff=new Array(myStage.lWidth*myStage.lHeight);
				Ground.Mines=new Array(myStage.lWidth*myStage.lHeight);
				Ground.ms=new Array(myStage.lWidth*myStage.lHeight);
				Ground.ms_pos=new Array(myStage.lWidth*myStage.lHeight);
				Ground.ms_heal=new Array(myStage.lWidth*myStage.lHeight);
				Ground.tr_frames=new Array();
				
				Wall.objects=new Array(myStage.lWidth*myStage.lHeight);
				Wall.completed=false;
				
				Tank.free_pos=new Array(myStage.lWidth*myStage.lHeight);
				Tank.sm_frames=new Array();
				Tank.m_frames=new Array();
				Tank.b_frames=new Array();
				Tank.b1_frames=new Array();
				Tank.b2_frames=new Array();
				Tank.ex_frames=new Array();
				Tank.bu_frames=new Array();
				Tank.ra_frames=new Array();
				Tank.tu_frames0=new Array();
				Tank.tu_frames1=new Array();
				Tank.pw_frames=new Array();
				Tank.tsl_frames=new Array();
				Tank.big_tu_fr=new Array();
				Tank.pw_frames=new Array();
				Tank.stels_fr=new Array();
				Tank.b3_frames=new Array();
				
				try{
					bl_timer.stop();
				}catch(er:Error){}
				try{
					cont.filters=[];
				}catch(er:Error){}
				bl_r=0;
				bl_time=0;
				
				for(n=0;n<objs.length;n++){
					if(objs[n]!=null){
						try{
							objs[n].efx_del();
						}catch(e:Error){}
						try{
							objs[n].removeEventListener(Event.ENTER_FRAME, objs[n].render);
						}catch(e:Error){}
						try{
							wall.removeChild(objs[n]["t_cl"]);
						}catch(e:Error){}
						try{
							ground.removeChild(objs[n]["p_cl"]);
						}catch(e:Error){}
						try{
							wall.removeChild(objs[n]);
						}catch(e:Error){}
						try{
							bull.removeChild(objs[n]);
						}catch(e:Error){}
						try{
							cont.removeChild(objs[n]);
						}catch(e:Error){}
					}
				}
				try{
					cont.removeChild(ground);
				}catch(e:Error){}
				try{
					cont.removeChild(wall);
				}catch(e:Error){}
				try{
					cont.removeChild(bull);
				}catch(e:Error){}
				try{
					cont.removeChild(expls);
				}catch(e:Error){}
				try{
					cont.removeChild(curs);
				}catch(e:Error){}
				try{
					removeChild(fon_cl);
				}catch(e:Error){}
				try{
					removeChild(cont);
				}catch(e:Error){}
				ground=null;
				wall=null;
				cont=null;
				bull=null;
				expls=null;
				try{
					socket.close();
				}catch(e:Error){
					//trace("socket reset "+e);
				}
				try{
					if(socket!=null){
						socket=null;
					}
				}catch(e:Error){
					//trace("socket reset "+e);
				}
				//trace("socket "+(socket==null));
				//socket.loading=false;
				//socket.mloaded=false;
				try{
					if(pl_clip!=null){
						pl_clip=null;
					}
				}catch(e:Error){
					//trace("pl_clip reset "+e);
				}
				
				grounds=new Array();
				teslaes=new Array();
				walls=new Array();
				mines=new Array();
				base=new Array();
				base_pos=new Array();
				
				objs=new Array();
				obj1=new Array();
				obj_id=new Array();
				obj_vect=new Array();
				obj_heal=new Array();
				obj_heal1=new Array();
				obj_gun=new Array();
				obj_speed=new Array();
				obj_pos=new Array();
				obj_name=new Array();
				obj_resp=new Array();
				obj_R=new Array();
				obj_type=new Array();
				obj_time=new Array();
				obj_tail=new Array();
				obj_pict=new Array();
				obj_c=new Array();
				obj_pow=new Array();
				obj_step=new Array();
				obj_rand=new Array();
				obj_num=new Array();
				obj_obj=new Array();
				
				bonuses=new Array();
				bon_id=new Array();
				bon_pos=new Array();
				bon_pow=new Array();
				bon_step=new Array();
				bon_time=new Array();
				bon_type=new Array();
				bon_pict=new Array();
				bon_c=new Array();
				
				myCode=new Array(6);
				map_id=new Array(0,0,0,0);
				ammo_dm=new Array(0,0,0,0,0,0);
				ammo_sp=new Array(0,0,0,0,0,0);
				mines_dm=new Array(0,0,0,0);
				tracks=new Array(100);
				track_c=new Array(100);
				track_c1=new Array(100);
				track_pos=new Array(100);
				smokes=new Array(100);
				smoke_c=new Array(100);
				smoke_c1=new Array(100);
				smoke_x=new Array(100);
				smoke_y=new Array(100);
				hides=new Array(100);
				hide_c=new Array(100);
				hide_c1=new Array(100);
				hide_x=new Array(100);
				hide_y=new Array(100);
				booms=new Array(100);
				boom_t=new Array(100);
				boom_c=new Array(100);
				boom_c1=new Array(100);
				boom_x=new Array(100);
				boom_y=new Array(100);
				m_names=new Array();
				m_rangs=new Array();
				m_skins=new Array();
				m_ava=new Array();
				m_idies=new Array();
				m_nums=new Array(20);
				b_names=new Array();
				b_rangs=new Array();
				b_skins=new Array();
				b_nums=new Array();
				roc_c=new Array();
				roc_x=new Array();
				roc_y=new Array();
				air_c=new Array();
				air_x=new Array();
				air_y=new Array();
				
				explode=false;
				explode1=false;
				explode2=false;
				explode3=false;
				explode4=false;
				wall_load=false;
				wall_loaded=true;
				mrepeated=false;
				was_send=false;
				at_press=false;
				new_xp=false;
				m1_do=false;
				m2_do=false;
				m3_do=false;
				art_exp=false;
				f_shot=false;
				
				oil_c=new Array();
				oil_x=new Array();
				oil_y=new Array();
				oil_exp=false;
				
				ex_count=1;
				xp_count=0;
				b_count=0;
				bm_count=0;
				url_count=0;
				any_count=0;
				count=0;
				fcount=0;
				time_c=0;
				step_c=0;
				steps=0;
				art_c=0;
				
				lag_c=0;
				lag_test=0;
				b_ov_count=0;
				//antilag=true;
				try{
					myStage.cont.removeChild(myStage.lag_tx);
				}catch(er:Error){}
				
				CustomSocket.timestep=-1;
				CustomSocket.timestep1=-1;
				CustomSocket.map_id=false;
				
				try{
					resetAir();
				}catch(e:Error){
					//trace("air reset "+e);
				}
				
				x=0;
				y=0;
				try{
					panel.x=px;
					panel.y=py;
					contur.x=rx;
					contur.y=ry;
					fon_cl.x=4;
					fon_cl.y=4;
					chat_cl.x=chx;
					chat_cl.y=chy;
					exp_cl.x=0;
					exp_cl.y=465;
				}catch(e:Error){
					//trace("panel reset "+e);
				}
				panel["ammo0"].reset_cd();
				myStage.chat_cl.hideAvas();
				createMode(1,1);
				win_cl["win_cl"]["show_st"].setNum(0);
				try{
					panel["ammo0"].sendRequest([["query"],["action"]],[["id"],["id"]],[["2"],["21"]]);   // обновить панель
					shop["exit"].sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["2"],["1","0","0","0"]]);
				}catch(e:Error){
					//trace("shop reset "+e);
				}
				/*try{
					wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["1"]]);
				}catch(e:Error){
					//trace("wind reset "+e);
				}*/
				if(can_p2p){
					try{
						p2p_client.onDisconnect();
					}catch(er:Error){
						trace("Error hang-up call");
					}
				}
				game_over=false;
				SoundMixer.stopAll();
				if(help_on){
					if(help_st<3){
						if(help_fnc==null){
							help_fnc=function(){
								help_cl["lesson1"]["win"]["leave_cl"].set_type(2);
								Lesson(2);
								help_fnc=null;
							}
						}
					}else if(help_st>7&&help_st<12){
						if(help_fnc==null){
							help_fnc=function(){
								help_cl["lesson1"]["win"]["leave_cl"].set_type(10);
								Lesson(10);
								help_fnc=null;
							}
						}
					}
				}
				help_fnc.call();
				System.gc();
			}catch(gEr:Error){
				trace("game reset "+gEr);
			}
		}
		
		public var opt_on:Boolean=false;
		public var port_now:int=-1;
		public var ports_ar:Array=new Array();
		public var ports_ch:Array=new Array();
		
		public function getPorts(){
			var rqs:URLRequest=new URLRequest(scr_url+"?query="+2+"&action="+20);
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			var strXML:String="<query id=\"2\"><action id=\"20\"/></query>";
			//trace(strXML);
			var variables:URLVariables = new URLVariables();
			variables.query = strXML;
			variables.send = "send";
			rqs.data = variables;
			loader.addEventListener(Event.COMPLETE, function(event:Event){
				var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
				//trace(str);
				try{
					var list:XML=new XML(str);
					list=list.child("result")[0];
				}catch(er:Error){
					return;
				}
				//trace(list);
				for(var m:int=0;m<4;m++){
					opt_cl["win1"]["port_tx"+m].text!="empty";
				}
				ports_ar=new Array();
				for(var m:int=0;m<list.child("ports")[0].child("port").length();m++){
					if(m<4){
						try{
							ports_ar[m]=int(list.child("ports")[0].child("port")[m].attribute("id"));
							opt_cl["win1"]["port_tx"+m].text=list.child("ports")[0].child("port")[m].attribute("id");
							if(ports_ch[m]){
								port_now=int(opt_cl["win1"]["port_tx"+m].text);
								opt_cl["win1"]["port"+m]["press_cl"].visible=true;
								opt_cl["win1"]["port"+4]["press_cl"].visible=false;
							}else{
								opt_cl["win1"]["port"+m]["press_cl"].visible=false;
							}
						}catch(er:Error){
							return;
						}
					}
				}
			});
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
		}
		
		public function showOpt(_i:int=0){
			if(_i==0){
				if(!opt_on){
					var _b:Boolean=false;
					opt_cl["win1"]["port"+4]["press_cl"].visible=true;
					for(var m:int=0;m<4;m++){
						//trace(opt_cl["win1"]["port_tx"+m].text+"   "+opt_cl["win1"]["port"+m]["press_cl"].visible+"   "+opt_cl["win1"]["port"+m].getVar(m));
						if(opt_cl["win1"]["port_tx"+m].text!="empty"){
							if(int(opt_cl["win1"]["port_tx"+m].text)==port_now){
								opt_cl["win1"]["port"+m]["press_cl"].visible=true;
								opt_cl["win1"]["port"+4]["press_cl"].visible=false;
							}else{
								opt_cl["win1"]["port"+m]["press_cl"].visible=false;
							}
							_b=true;
						}
					}
					if(!_b){
						getPorts();
					}
					addChild(opt_cl);
					opt_on=true;
				}else{
					try{
						removeChild(opt_cl);
					}catch(er:Error){}
					opt_cl["win1"]["close_all"].saveAr();
					opt_on=false;
				}
			}else{
				if(opt_on){
					try{
						removeChild(opt_cl);
					}catch(er:Error){}
					opt_cl["win1"]["close_all"].saveAr();
					opt_on=false;
				}
			}
		}
		
		public function newSmoke(pos_x:int,pos_y:int,frame:int,num:int){
			smoke_c[num]=0;
			smoke_c1[num]=0;
			smokes[num]=1;
			smoke_x[num]=pos_x;
			smoke_y[num]=pos_y;
			var matrix:Matrix = new Matrix();
      matrix.translate(int(smoke_x[num]), int(smoke_y[num]));
			expls.graphics.beginBitmapFill(Tank.sm_frames[frame].bitmapData,matrix);
			expls.graphics.drawRect(int(smoke_x[num]), int(smoke_y[num]), Tank.sm_frames[frame].width,  Tank.sm_frames[frame].height);
		}
		
		public function setSmoke(frame:int,num:int){
			if(frame>9){
				smokes[num]=0;
			}else{
				smoke_x[num]-=(frame*.15);
				smoke_y[num]-=1;
				var matrix:Matrix = new Matrix();
     		matrix.translate(int(smoke_x[num]), int(smoke_y[num]));
				expls.graphics.beginBitmapFill(Tank.sm_frames[frame].bitmapData,matrix);
				expls.graphics.drawRect(int(smoke_x[num]), int(smoke_y[num]), Tank.sm_frames[frame].width,  Tank.sm_frames[frame].height);
			}
		}
		
		public function newHide(pos_x:int,pos_y:int,frame:int,num:int){
			if(stels_c<hides.length){
				stels_c++;
			}else{
				stels_c=0;
			}
			hide_c[num]=0;
			hide_c1[num]=0;
			hides[num]=1;
			hide_x[num]=pos_x-10;
			hide_y[num]=pos_y-10;
			var matrix:Matrix = new Matrix();
      matrix.translate((hide_x[num]), (hide_y[num]));
			expls.graphics.beginBitmapFill(Tank.stels_fr[frame].bitmapData,matrix);
			expls.graphics.drawRect((hide_x[num]), (hide_y[num]), Tank.stels_fr[frame].width,  Tank.stels_fr[frame].height);
		}
		
		public function setHide(frame:int,num:int){
			if(frame>6){
				hides[num]=0;
			}else{
				//hide_x[num]-=(frame*.15);
				//hide_y[num]-=1;
				var matrix:Matrix = new Matrix();
     		matrix.translate((hide_x[num]), (hide_y[num]));
				expls.graphics.beginBitmapFill(Tank.stels_fr[frame].bitmapData,matrix);
				expls.graphics.drawRect((hide_x[num]), (hide_y[num]), Tank.stels_fr[frame].width,  Tank.stels_fr[frame].height);
			}
		}
		
		public function newEX(pos_x:int,pos_y:int,frame:int,num:int,ind:int,_t:int=0){
			if(bm_count<booms.length){
				bm_count++;
			}else{
				bm_count=0;
			}
			boom_c[num]=0;
			boom_c1[num]=0;
			boom_t[num]=_t;
			if(boom_t[num]>2){
				boom_t[num]=0;
			}
			booms[num]=ind+1;
			boom_x[num]=pos_x;
			boom_y[num]=pos_y;
			/*var matrix:Matrix = new Matrix();
      matrix.translate(int(boom_x[num]), int(boom_y[num]));
			if(ind==0){
				expls.graphics.beginBitmapFill(Tank.b_frames[frame].bitmapData,matrix);
				expls.graphics.drawRect(int(boom_x[num]), int(boom_y[num]), 22,  22);
			}else if(ind==1){
				expls.graphics.beginBitmapFill(Tank.b1_frames[frame].bitmapData,matrix);
				expls.graphics.drawRect(int(boom_x[num]), int(boom_y[num]), 32,  32);
			}else if(ind==2){
				expls.graphics.beginBitmapFill(Tank.b2_frames[frame].bitmapData,matrix);
				expls.graphics.drawRect(int(boom_x[num]), int(boom_y[num]), 48,  48);
			}else if(ind==3){
				expls.graphics.beginBitmapFill(Tank.b3_frames[frame].bitmapData,matrix);
				expls.graphics.drawRect(int(boom_x[num]), int(boom_y[num]), 64,  64);
			}*/
		}
		
		public function setEX(frame:int,num:int){
			if(booms[num]==1){
				if(frame>6){
					booms[num]=0;
					return;
				}
			}else if(booms[num]==2){
				if(frame>9){
					booms[num]=0;
					return;
				}
			}else if(booms[num]==3){
				if(frame>6){
					booms[num]=0;
					return;
				}
			}else if(booms[num]==4){
				if(frame>11){
					booms[num]=0;
					return;
				}
			}
			if(expl_norm&&boom_t[num]>0){
				if(booms[num]==1){
					if(frame>3){
						booms[num]=0;
						newEX(boom_x[num]-5,boom_y[num]-5,0,bm_count,boom_t[num],boom_t[num]+1);
						return;
					}
				}/*else if(booms[num]==2){
					if(frame>5){
						booms[num]=0;
						newEX(boom_x[num]-8,boom_y[num]-8,0,bm_count,boom_t[num],boom_t[num]+1);
						return;
					}
				}*/
			}
			if(booms[num]<4){
				boom_x[num]-=(frame*.15);
				boom_y[num]-=1;
			}
			var matrix:Matrix = new Matrix();
			matrix.translate(int(boom_x[num]), int(boom_y[num]));
			if(booms[num]==1){
				expls.graphics.beginBitmapFill(Tank.b_frames[frame].bitmapData,matrix);
				expls.graphics.drawRect(int(boom_x[num]), int(boom_y[num]), 22,  22);
			}else if(booms[num]==2){
				expls.graphics.beginBitmapFill(Tank.b1_frames[frame].bitmapData,matrix);
				expls.graphics.drawRect(int(boom_x[num]), int(boom_y[num]), 32,  32);
			}else if(booms[num]==3){
				expls.graphics.beginBitmapFill(Tank.b2_frames[frame].bitmapData,matrix);
				expls.graphics.drawRect(int(boom_x[num]), int(boom_y[num]), 48,  48);
			}else if(booms[num]==4){
				expls.graphics.beginBitmapFill(Tank.b3_frames[frame].bitmapData,matrix);
				expls.graphics.drawRect(int(boom_x[num]), int(boom_y[num]), 64,  64);
			}
		}
		
		public function air_expl(X:int,Y:int,type:int,slx:int,sly:int){
				if(((X+2)>=0&&(X+2)<lWidth)&&((Y+2)>=0&&(Y+2)<lHeight)){
					var p:int=(X+2)+(Y+2)*lWidth;
					if(type==3){
						newEX(int(p%lWidth)*24+board_x-12+slx,int(p/lWidth)*24+board_y-12+sly,0,bm_count,2,1);
					}else if(type==2){
						newEX(int(p%lWidth)*24+board_x-4+slx,int(p/lWidth)*24+board_y-4+sly,0,bm_count,1,1);
					}else if(type==1){
						newEX(int(p%lWidth)*24+board_x+1+slx,int(p/lWidth)*24+board_y+1+sly,0,bm_count,0,1);
					}
					air_c.push(0);
					air_x.push(X);
					air_y.push(Y);
					explode=true;
				}
			}
			
			public function air_move(_c:int){
				if(air_c[_c]==0){
					newEX(int(air_x[_c]-3)*24+board_x-12,int((air_y[_c]+2))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==1){
					newEX(int(air_x[_c]-1)*24+board_x-12,int((air_y[_c]+2))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==2){
					newEX(int(air_x[_c]-2)*24+board_x-12,int((air_y[_c]+1))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==3){
					newEX(int(air_x[_c])*24+board_x-12,int((air_y[_c]+1))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==4){
					newEX(int(air_x[_c]-1)*24+board_x-12,int((air_y[_c]))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==5){
					newEX(int(air_x[_c]+1)*24+board_x-12,int((air_y[_c]))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==6){
					newEX(int(air_x[_c])*24+board_x-12,int((air_y[_c]-1))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==7){
					newEX(int(air_x[_c]+2)*24+board_x-12,int((air_y[_c]-1))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==8){
					newEX(int(air_x[_c]+1)*24+board_x-12,int((air_y[_c]-2))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==9){
					newEX(int(air_x[_c]+3)*24+board_x-12,int((air_y[_c]-2))*24+board_y-12,0,bm_count,2,1);
				}else if(air_c[_c]==10){
					air_c.splice(_c, 1);
				}
				//cont.setChildIndex(plane_cl, cont.getChildIndex(plane_cl)-1);
				explode=true;
				air_c[_c]++;
			}
			
			public var _effect1:Array=[[20, 32],[32, 1],[1, 1, 1, .5, 128, 128, 128],[3, 3, [.3, .3, .3, .3, 5, .3, .3, .3, .3],4]];
			
			public function Rocket(p:int){
				roc_c.push(0);
				roc_x.push(p%lWidth);
				roc_y.push(p/lWidth);
				self.playSound("rocket",0);
				//var _rippler:Rippler=new Rippler(cont, (p%lWidth)*24, (p/lWidth)*24, _effect1, p);
			}
			
			public function roc_move(_c:int){
				//trace(pos+"  "+(int((pos-lWidth-1)%lWidth)+board_x+2));
				//var m_pos:Array=new Array();
				//var m_pos:Array=new Array();
				if(roc_c[_c]==0){
					newEX(roc_x[_c]*24+board_x-12,roc_y[_c]*24+board_y-12,0,bm_count,2);
				}else if(expl_norm&&roc_c[_c]==1){
					if(roc_x[_c]>0)newEX(int(roc_x[_c]-1)*24+board_x-4,int(roc_y[_c])*24+board_y-4,0,bm_count,2);
					if(roc_x[_c]<lWidth-1)newEX(int(roc_x[_c]+1)*24+board_x-4,int(roc_y[_c])*24+board_y-4,0,bm_count,2);
					if(roc_y[_c]>0)newEX(int(roc_x[_c])*24+board_x-4,int(roc_y[_c]-1)*24+board_y-4,0,bm_count,2);
					if(roc_y[_c]<lHeight-1)newEX(int(roc_x[_c])*24+board_x-4,int(roc_y[_c]+1)*24+board_y-4,0,bm_count,2);
					
					myStage.self.newEX(roc_x[_c]*24+board_x-20,roc_y[_c]*24+board_y-30,0,myStage.bm_count,3);
				}else if(expl_norm&&roc_c[_c]==3){
					if(roc_x[_c]>0&&roc_y[_c]>1)newEX(int(roc_x[_c]-1)*24+board_x+2,int(roc_y[_c]-2)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-1&&roc_y[_c]>1)newEX(int(roc_x[_c]+1)*24+board_x+2,int(roc_y[_c]-2)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]>0&&roc_y[_c]<lHeight-2)newEX(int(roc_x[_c]-1)*24+board_x+2,int(roc_y[_c]+2)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-1&&roc_y[_c]<lHeight-2)newEX(int(roc_x[_c]+1)*24+board_x+2,int(roc_y[_c]+2)*24+board_y+2,0,bm_count,1);
					
					if(roc_x[_c]>1&&roc_y[_c]>0)newEX(int(roc_x[_c]-2)*24+board_x+2,int(roc_y[_c]-1)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-2&&roc_y[_c]>0)newEX(int(roc_x[_c]+2)*24+board_x+2,int(roc_y[_c]-1)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]>1&&roc_y[_c]<lHeight-1)newEX(int(roc_x[_c]-2)*24+board_x+2,int(roc_y[_c]+1)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-2&&roc_y[_c]<lHeight-1)newEX(int(roc_x[_c]+2)*24+board_x+2,int(roc_y[_c]+1)*24+board_y+2,0,bm_count,1);
				}else if(expl_norm&&roc_c[_c]==4){
					if(roc_x[_c]>2)newEX(int(roc_x[_c]-3)*24+board_x-4,int(roc_y[_c])*24+board_y-4,0,bm_count,2);
					if(roc_x[_c]<lWidth-3)newEX(int(roc_x[_c]+3)*24+board_x-4,int(roc_y[_c])*24+board_y-4,0,bm_count,2);
					if(roc_y[_c]>2)newEX(int(roc_x[_c])*24+board_x-4,int(roc_y[_c]-3)*24+board_y-4,0,bm_count,2);
					if(roc_y[_c]<lHeight-3)newEX(int(roc_x[_c])*24+board_x-4,int(roc_y[_c]+3)*24+board_y-4,0,bm_count,2);
				}else if(roc_c[_c]==5){
					if(roc_x[_c]>0&&roc_y[_c]>3)newEX(int(roc_x[_c]-1)*24+board_x+2,int(roc_y[_c]-3)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-1&&roc_y[_c]>3)newEX(int(roc_x[_c]+1)*24+board_x+2,int(roc_y[_c]-3)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]>0&&roc_y[_c]<lHeight-3)newEX(int(roc_x[_c]-1)*24+board_x+2,int(roc_y[_c]+3)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-1&&roc_y[_c]<lHeight-3)newEX(int(roc_x[_c]+1)*24+board_x+2,int(roc_y[_c]+3)*24+board_y+2,0,bm_count,1);
					
					if(roc_x[_c]>2&&roc_y[_c]>2)newEX(int(roc_x[_c]-3)*24+board_x+2,int(roc_y[_c]-1)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-3&&roc_y[_c]>2)newEX(int(roc_x[_c]+3)*24+board_x+2,int(roc_y[_c]-1)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]>2&&roc_y[_c]<lHeight-3)newEX(int(roc_x[_c]-3)*24+board_x+2,int(roc_y[_c]+1)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-3&&roc_y[_c]<lHeight-3)newEX(int(roc_x[_c]+3)*24+board_x+2,int(roc_y[_c]+1)*24+board_y+2,0,bm_count,1);
					
					if(roc_x[_c]>1&&roc_y[_c]>1)newEX(int(roc_x[_c]-2)*24+board_x+2,int(roc_y[_c]-2)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-2&&roc_y[_c]>1)newEX(int(roc_x[_c]+2)*24+board_x+2,int(roc_y[_c]-2)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]>1&&roc_y[_c]<lHeight-2)newEX(int(roc_x[_c]-2)*24+board_x+2,int(roc_y[_c]+2)*24+board_y+2,0,bm_count,1);
					if(roc_x[_c]<lWidth-2&&roc_y[_c]<lHeight-2)newEX(int(roc_x[_c]+2)*24+board_x+2,int(roc_y[_c]+2)*24+board_y+2,0,bm_count,1);
				}else if(roc_c[_c]==6){
					roc_c.splice(_c, 1);
					roc_x.splice(_c, 1);
					roc_y.splice(_c, 1);
					return;
				}
				explode=true;
				roc_c[_c]++;
			}
		
		public function explodes(){
			if(!expl_on){
				explode=false;
				ex_count=1;
				return;
			}
			//setChildIndex(contur, numChildren-1);
			if(explode4){
				
			}else if(explode3){
				
			}else if(explode2){
				
			}else if(explode1){
				
			}else if(explode){
				////trace("explodes   "+getChildIndex(ground)+"   "+getChildIndex(contur)+"   "+getChildIndex(wall));
				if(ex_count<7){
					if(ex_count==1){
						cont.x-=4;
						cont.y-=4;
					}else if(ex_count==2){
						cont.x+=8;
						cont.y+=6;
					}else if(ex_count==3){
						cont.x-=8;
						cont.y+=2;
					}else if(ex_count==4){
						cont.x+=7;
						cont.y-=5;
					}else if(ex_count==5){
						cont.x-=3;
						cont.y+=5;
					}else if(ex_count==6){
						cont.x-=1;
						cont.y-=4;
					}
					////trace(x+"   "+y+"   "+ex_count);
					ex_count++;
				}else{
					explode=false;
					cont.x=0;
					cont.y=0;
					ex_count=1;
				}
			}
		}
		
		private function multicolor(_cl:MovieClip):void {
			var fltrs:Array = new Array();
			var cl_fltr:Array=_cl.filters;
			for(var i:int=0;i<cl_fltr.length;i++){
				//trace(i+"   "+cl_fltr[i]+"   "+over_fltr+"   "+(cl_fltr[i]==over_fltr)+"   "+(cl_fltr[i]!=over_fltr));
				if((cl_fltr[i].constructor==ColorMatrixFilter)&&(cl_fltr[i].matrix.toString().substr(50,30)=="4202385,0,0,0.2126709967851638")){
					continue;
				}else{
					fltrs.push(cl_fltr[i]);
				}
			}
			_cl.filters = fltrs;
		}
		
		public function b_and_w(_cl:MovieClip,_b_w:int=0):void {
			multicolor(_cl);
			if(_b_w==1){
				var filter:ColorMatrixFilter = b_and_w_f();
				var fltrs:Array = new Array();
				fltrs.push(filter);
				_cl.filters = fltrs;
			}
		}
		
		private function b_and_w_f() {
			var t:Number = 1;
			var r:Number = 0.212671;
			var g:Number = 0.715160;
			var b:Number = 0.072169;
			/*var matrix:Array = new Array();[, , , ]
			matrix = matrix.concat([t*r+1-t, t*g, t*b, 0, 0]); // red
			matrix = matrix.concat([t*r, t*g+1-t, t*b, 0, 0]); // green
			matrix = matrix.concat([t*r, t*g, t*b+1-t, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha 4-й элемент из 5-ти от 0 до 1*/
			var fltr:ColorMatrixFilter=new ColorMatrixFilter([t*r+1-t, t*g, t*b, 0, 0, t*r, t*g+1-t, t*b, 0, 0, t*r, t*g, t*b+1-t, 0, 0, 0, 0, 0, 1, 0]);
			//trace(fltr.matrix.toString().substr(50,30));
			return fltr;
		}
		
		public var px:Number=0;
		public var py:Number=0;
		public var rx:Number=0;
		public var ry:Number=0;
		public var chx:Number=0;
		public var chy:Number=0;
		
		public static var ov_ar:Array=[[0xFF9900,0xFF9900,0xFF9900],[.2,.3,.4],[0, 200, 255]];
		public static var ov_ar1:Array=[[0xFF9900,0xFF9900,0xFF9900],[.2,.3,.4],[0, 200, 255]];
		
		public static var over_fltr:GlowFilter=new GlowFilter(0xFFFF00,1,32,32,2,1,true,false);
		public static var sel_fltr:GlowFilter= new GlowFilter(0x660099,1,6,6,2,1,true,false);
		
		public function light_col(_cl:MovieClip,_col:int=-1){
			var _fltr:Array=new Array();
			var cl_fltr:Array=_cl.filters;
			for(var i:int=0;i<cl_fltr.length;i++){
				//trace(i+"   "+cl_fltr[i].constructor+"   "+cl_fltr[i].color+"   "+GlowFilter+"   "+0xFFFF66);
				if((cl_fltr[i].constructor==GlowFilter)&&(cl_fltr[i].color==_cl.light_col)){
					continue;
				}else{
					_fltr.push(cl_fltr[i]);
				}
			}
			if(_col>-1){
				_fltr.push(new GlowFilter(_col,1,6,6,2,1,true,false));
			}
			_cl.filters=_fltr;
			//trace(_cl+"   "+_cl.filters);
		}
		
		public function light_col1(_cl:MovieClip,_col:int=-1){
			var re_cl:Sprite=(_cl.getChildByName("light_cl") as Sprite);
			if(re_cl!=null){
				_cl.removeChild(re_cl);
			}
			if(_col>-1){
				var ov_cl:Sprite=new Sprite();
				ov_cl.mouseEnabled=false;
				ov_cl.name="light_cl";
				ov_cl.graphics.clear();
				ov_cl.graphics.lineStyle(2,_col);
				ov_cl.graphics.drawRect(2,2,_cl.width-4,_cl.height-4);
				_cl.addChild(ov_cl);
			}
		}
		
		public function overTest(_cl:MovieClip,_over:int=0){
			var _fltr:Array=new Array();
			var cl_fltr:Array=_cl.filters;
			for(var i:int=0;i<cl_fltr.length;i++){
				//trace(i+"   "+cl_fltr[i].constructor+"   "+cl_fltr[i].color+"   "+GlowFilter+"   "+0xFFFF66);
				if((cl_fltr[i].constructor==GlowFilter)&&(cl_fltr[i].color==0xFFFF00)){
					continue;
				}else{
					_fltr.push(cl_fltr[i]);
				}
			}
			if(_over==1){
				_fltr.push(over_fltr);
			}
			_cl.filters=_fltr;
			//trace(_cl+"   "+_cl.filters);
		}
		
		public function overTest1(_cl:MovieClip,_over:int=0){
			var re_cl:Sprite=(_cl.getChildByName("ov_cl") as Sprite);
			if(re_cl!=null){
				_cl.removeChild(re_cl);
			}
			if(_over==1){
				var ov_cl:Sprite=new Sprite();
				ov_cl.mouseEnabled=false;
				ov_cl.name="ov_cl";
				ov_cl.graphics.clear();
				ov_cl.graphics.lineStyle(2,0xFFFF00);
				ov_cl.graphics.drawRect(2,2,_cl.width-4,_cl.height-4);
				_cl.addChild(ov_cl);
			}
		}
		
		public function canDrag(_cl:MovieClip,_over:int=0){
			for(var j:int=0;j<_cl["can_put"].length;j++){
				if(int(_cl["can_put"][j].name.slice(3,4))<2){
					continue;
				}
				var _fltr:Array=new Array();
				var cl_fltr:Array=_cl["can_put"][j].filters;
				for(var i:int=0;i<cl_fltr.length;i++){
					//trace(i+"   "+cl_fltr[i].constructor+"   "+cl_fltr[i].color+"   "+GlowFilter+"   "+0xFFFF66);
					if((cl_fltr[i].constructor==GlowFilter)&&(cl_fltr[i].color==0x660099)){
						continue;
					}else{
						_fltr.push(cl_fltr[i]);
					}
				}
				//if(_cl["can_put"][j]!=_cl){
					if(_over==1){
						_fltr.push(sel_fltr);
					}
					_cl["can_put"][j].filters=_fltr;
				//}
			}
			//trace(_cl+"   "+_cl.filters);
		}
		
		public function dragBegin(_cl:MovieClip){
			var _mw:int=_cl["bmd"].width;
			var _mh:int=_cl["bmd"].height;
			drag_cl=new MovieClip();
			drag_cl.prnt=_cl;
			drag_cl.graphics.clear();
			drag_cl.graphics.beginBitmapFill(_cl.bmd);
			drag_cl.graphics.drawRect(0, 0, _mw, _mh);
			var pnt:Point=_cl.parent.localToGlobal(new Point(_cl.x,_cl.y));
			//trace(_cl.parent.localToGlobal(new Point(_cl.x,_cl.y))+"   "+_cl.localToGlobal(new Point(_cl.x,_cl.y)));
			drag_cl.x=int(pnt.x);
			drag_cl.y=int(pnt.y);
			drag_cl.alpha=.5;
			drag_cl.mouseEnabled=false;
			addChild(drag_cl);
			stage.addEventListener(MouseEvent.MOUSE_UP, Drop);
			_cl.clearBtn(2);
			light_col(_cl);
			overTest1(_cl,1);
			drag_cl.i_name=_cl["i_name"];
			//_cl.i_name="";
			drag_cl.startDrag();
			Mouse.cursor=MouseCursor.HAND;
		}
		
		public function unDrag(_cl:MovieClip){
			var rtrn:int=0;
			if(_cl==null){
				rtrn=1;
			}else if(_cl.name=="tank_win"){
				rtrn=1;
				if(int(drag_cl["prnt"].name.slice(3,4))==6){
					if(drag_cl["prnt"].name!="sl_6_0"){
						rtrn=3;
					}else if(vip_cl["exit_cl"].tanks_count!=0){
						//trace("_tanks_count="+vip_cl["exit_cl"].tanks_count);
						rtrn=3;
					}
				}else if(int(drag_cl["prnt"].name.slice(3,4))==2){
					//trace(_cl.weightTest(1)+"   "+drag_cl["prnt"].mass);
					var _ars:MovieClip=drag_cl["prnt"].getStaticVar("arsnl_cl");
					if(drag_cl["prnt"].weightTest(1)+_cl.mass>_ars["mass_lim"]){
						rtrn=1;
						_ars["warn_win"].visible=true;
					}
				}
			}else if(!drag_cl["prnt"].canTest(_cl)){
				rtrn=1;
			}else{
				if(int(_cl.name.slice(3,4))==7){
					rtrn=1;
					if(int(_cl.name.slice(5,7))==1){
						// подтверждение продажи
						drag_cl["prnt"].sellConf();
					}
				}else if(int(_cl.name.slice(3,4))==2){
					//trace(_cl.weightTest(1)+"   "+drag_cl["prnt"].mass);
					var _ars:MovieClip=_cl.getStaticVar("arsnl_cl");
					if(_cl.weightTest(1)+drag_cl["prnt"].mass>_ars["mass_lim"]){
						rtrn=1;
						_ars["warn_win"].visible=true;
					}
				}else if(int(_cl.name.slice(3,4))==4){
					if(_cl["i_name"]!=""){
						if(drag_cl["prnt"]["lev"]>_cl["lev"]){
							rtrn=2;
						}else{
							rtrn=1;
						}
					}
				}else if(int(_cl.name.slice(3,4))==6){
					if(int(drag_cl["prnt"].name.slice(3,4))==6){
						rtrn=1;
					}
				}
			}
			if(rtrn>0){
				drag_cl["prnt"].drawPict(drag_cl["prnt"]["bmd"]);
				if(_cl!=null&&_cl.name=="tank_win"){
					overTest(_cl,0);
				}else{
					overTest1(drag_cl["prnt"],0);
				}
				drag_cl["prnt"]["i_name"]=drag_cl["i_name"];
				light_col(drag_cl["prnt"],drag_cl["prnt"]["light_col"]);
				if(rtrn==2){
					drag_cl["prnt"].replConf(2,_cl);
				}else if(rtrn==3){
					drag_cl["prnt"].replConf(1);
				}
			}else{
<<<<<<< HEAD:client/work/fps test1/game/myStage.as
				drag_cl["prnt"].replaceSlot(drag_cl["prnt"],_cl,drag_cl.i_name,true);
=======
				var _r_fnc:Function=function(){
					drag_cl["prnt"].replaceSlot(drag_cl["prnt"],_cl,drag_cl.i_name,true);
				};
				if(_cl["i_name"]!=""&&drag_cl["prnt"].ID==_cl.ID&&_cl.max_qntty>=(_cl.quantity+drag_cl["prnt"].quantity)){
					drag_cl["prnt"].iterateSlot(drag_cl["prnt"],_cl,true,_r_fnc);
				}else{
					_r_fnc();
				}
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/game/myStage.as
			}
			canDrag(drag_cl["prnt"]);
			Mouse.cursor=MouseCursor.AUTO;
			try{
				removeChild(drag_cl);
			}catch(e:Error){}
			drag_cl=null;
			stage.removeEventListener(MouseEvent.MOUSE_UP, Drop);
		}
		
		public function Drop(event:MouseEvent){
			unDrag(null);
		}
		
		public function parseSinhro(){
				/*try{
					removeChild(txt);
					removeChild(progressBar);
				}catch(e:Error){}*/
				cont=new MovieClip();
				bull=new MovieClip();
				expls=new MovieClip();
				bull.mouseEnabled=false;
				expls.mouseEnabled=false;
				ground=new Ground();
				//ground["stg"]=this;
				wall=new Wall();
				cont.addChild(ground);
				cont.addChild(wall);
				cont.addChild(bull);
				cont.addChild(expls);
				addChild(cont);
				cont.x=0;
				cont.y=0;
				bull.x=board_x;
				bull.y=board_y;
				ground.x=board_x;
				ground.y=board_y;
				wall.x=board_x;
				wall.y=board_y;
				expls.x=board_x;
				expls.y=board_y;
				//trace(ground.x);
				for(n=0;n<objs.length;n++){
					if(objs[n]!=null){
						if(obj_obj[n]>0){
							wall.addChild(objs[n]);
						}
					}
				}
				for(n=0;n<objs.length;n++){
					if(objs[n]!=null){
						if(obj_obj[n]==1){
							objs[n]["t_cl"].x=objs[n].x+4;
							objs[n]["t_cl"].y=objs[n].y+4;
							objs[n]["p_cl"].x=objs[n].x-15;
							objs[n]["p_cl"].y=objs[n].y-15;
							cont.addChild(objs[n]["t_cl"]);
							ground.addChild(objs[n]["p_cl"]);
						}
						////trace(keepers[n]+"   "+n);
					}
				}
				//setChildIndex(contur, numChildren-1);
				lifes--;
				panel["ammo0"].drawLifes();
				socket.loading=false;
				createMode(3);
		}
		
		public var arr1:Array=new Array(35,50,width-70,height);
		public var arr2:Array=new Array(0,0,width,height-80);
		public var arr3:Array=new Array(1.3,6,11,1);
		
		public var load_c:int=21;
		
		public function completeInit():void {
			try{
				help_cl.x=0;
				help_cl.y=0;
				help_cl["lesson1"]["win"]["leave_cl"].urlInit(scr_url,self);
				//stat_cl["ch1"].eventsInit();
			}catch(e:Error){
				prnt_cl.output("Lesson load error: "+e);
			}
			curs=new MovieClip();
			curs.addChild(lib.png.cursor);
			exp_cl=new expo_bar();
			exp_cl.x=0;
			exp_cl.y=465;
			contur=new ramka();
			contur.x=0;
			contur.y=0;
			addChild(chat_cl);
			chat_cl.visible=false;
			
			addChild(exp_cl);
			addChild(panel);
			chat_cl.visible=true;
			//addChildAt(chat_cl,numChildren-2);
			shop["stg"]=this;
			shop["exit"].sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["1"],["1","0","0","0"]]);
			//inv_cl["tank_sl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["1"],["5"]]);   обновить инвентарь
			wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["6"]]);
			panel["ammo0"].sendRequest([["query"],["action"]],[["id"],["id"]],[["2"],["21"]]);
			createMode(1);
			all_ready=true;
		}
		
		public var all_ready:Boolean=false;
		
		public function initLesson(_num:int){
			if(m_mode==3){
				return
			}else if(help_st!=_num){
				if(help_st==2&&_num==1){
					return;
				}else if(help_st==9&&_num==8){
					wind["win_cl"].visible=true;
					for(var i:int=1;i<8;i++){
						wind["win_cl"]["b"+i]["press_cl"].visible=false;
						wind["win_cl"]["b"+i]["id"]=-1;
					}
					wind["win_cl"]["b8"]["press_cl"].visible=true;
					return;
				}else if(help_st==10&&_num==8){
					return;
				}else if(help_st==10&&_num==9){
					return;
				}else{
					Lesson(_num);
				}
			}
		}
		
		public function Lesson(_num:int){
			try{
				removeChild(help_cl);
			}catch(er:Error){
				
			}
			trace("Lesson   "+_num+"   "+m_mode);
			if(_num==0){
				help_cl["lesson1"]["win"]["leave_cl"].set_type(_num);
				help_on=false;
				help_st=_num;
				return;
			}else if(_num<4){
				windClear();
				if(m_mode!=1){
					createMode(1);
				}
			}else if(_num<7){
				if(m_mode!=2){
					createMode(2);
				}
			}else if(_num<12){
				windClear();
				if(m_mode!=1){
					createMode(1);
				}
				if(_num==8){
					help_st=_num;
					wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["1"]]);
				}else if(_num==9){
					help_st=_num;
					wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["1"]]);
				}
			}
			help_cl["empt_cl"].visible=false;
			help_cl["out_win"].visible=false;
			for(var i:int=1;i<45;i++){
				try{
					help_cl["lesson"+i].visible=false;
				}catch(er:Error){
					break;
				}
			}
			//var _txfd:TextField=help_cl["lesson"+_num]["win"]["mess_tx"];
			//_txfd.htmlText=prnt_cl.format_tx(prnt_cl["lang"].child("training")[0].child("step")[_num-1],_txfd,null);
			addChild(help_cl);
			help_cl["lesson"+_num].visible=true;
			help_cl["lesson1"]["win"]["leave_cl"].set_type(_num);
			help_on=true;
			help_st=_num;
		}
		
		public static var help_on:Boolean=false;
		public static var help_st:int=0;
		
		public function errTest(er:String,Y:int){
			var txt:TextField=new TextField();
			var tfm:TextFormat=new TextFormat("Times New Roman",19,0xFFFFFF);
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
		
		
		
		public var v_name:String="";
		public var send_pl:Boolean=false;
		public var send1:Boolean=false;
		
		public function erTestReq(a:int,b:int,c:String){
			prnt_cl.erTestReq(a,b,c);
		}
		
		public function linkTo(req:URLRequest){
			prnt_cl.linkTo1(req);
		}
		
		public function linkTo1(req:URLRequest){
			prnt_cl.linkTo(req);
		}
		
		public function expoInit(a:int, b:int, c:int, _str){
			//trace("exp_cl "+exp_cl);
			exp_cl["bar"].graphics.clear();
			exp_cl["bar"].graphics.beginFill(0xFFFF00);
			var _w:int=0;
			if((b==0&&c==0)&&a==4){
				exp_cl["level_tx"].text=_str;
				exp_cl["exp_tx"].text=c+"/"+c;
				_w=440;
			}else{
				if(a<4){
					//exp_cl["level_tx"].text="Уровень "+a;
					exp_cl["level_tx"].text=_str;
				}else{
					exp_cl["level_tx"].text=_str;
				}
				if(c!=1){
					exp_cl["exp_tx"].text=b+"/"+c;
					_w=(b/c)*440;
				}else{
					exp_cl["exp_tx"].text="";
					_w=440;
					exp_cl["bar"].graphics.beginFill(0x990700);
				}
			}
			exp_cl["bar"].graphics.drawRect(0,0,_w,9);
		}
		
		public function m_press(event:MouseEvent){
			at_press=true;
		}
		
		public function m_release(event:MouseEvent){
				if(at_press){
					at_press=false;
					if((mouseX>0&&mouseX<lWidth*24)&&(mouseY>0&&mouseY<lHeight*24)){
						if(rocket){
							rocket=false;
							//trace(((int(mouseX/24)+1)+(int(mouseY/24))*lWidth));
							//new Rocket(((int(mouseX/24))+(int(mouseY/24))*lWidth));
							playSound("target",0);
							socket.sendEvent1(22,((int(mouseX/24)+1)+(int(mouseY/24))*lWidth));
							resetAir();
						}else if(plane){
							plane=false;
							new Plane(((int(mouseX/24))+(int(mouseY/24))*lWidth),70);
							//socket.sendEvent1(23,((int(mouseX/24)+1)+(int(mouseY/24))*lWidth));
							resetAir();
						}
					}
				}
		}
		
		public var art_c:int=0;
		public var art_time:int=15;
		public var art_num:int=5;
		public var art_exp:Boolean=false;
		
		public function artBomding(){
			if(art_exp){
				explode=true;
				for(var b:int=0;b<art_num;b++){
					newEX(int((Math.random()*(lWidth*lHeight))%lWidth)*24+board_x-4,int((Math.random()*(lWidth*lHeight))/lWidth)*24+board_y-4,0,bm_count,1);
				}
				art_c++;
				if(art_c>art_time){
					art_c=0;
					art_exp=false;
				}
			}
		}
		
		public var oil_c:Array=new Array();
		public var oil_time:int=5;
		public var oil_num:int=5;
		public var oil_x:Array=new Array();
		public var oil_y:Array=new Array();
		public var oil_exp:Boolean=false;
		
		public function oilBomding(){
			if(oil_c.length==0){
				oil_exp=false;
				return;
			}
			if(oil_exp){
				explode=true;
				for(var c:int=0;c<oil_c.length;c++){
					for(var b:int=0;b<oil_num;b++){
						var _ra:Number=(Math.random());
						var _rb:Number=(Math.random());
						var _rx:int=oil_x[c][1]-oil_x[c][0];
						var _ry:int=oil_y[c][1]-oil_y[c][0];
						if(((int(_ra*_rx)==0||Math.ceil(_ra*_rx)==_rx)&&(int(_rb*_ry)==0||Math.ceil(_rb*_ry)==_ry))){
							continue;
						}
						var _a:int=(_ra*(_rx))+oil_x[c][0];
						var _b:int=(_rb*(_ry))+oil_y[c][0];
						newEX(_a*24+board_x-4,_b*24+board_y-4,0,bm_count,1);
					}
					oil_c[c]++;
					if(oil_c[c]>oil_time){
						oil_c.splice(c,1);
						oil_x.splice(c,1);
						oil_y.splice(c,1);
						if(oil_c.length==0){
							oil_exp=false;
						}
					}
				}
			}
		}
		
		public function createAir(ev:int){
			
			//curs.x=(lWidth/2)*24;
			//curs.y=(lHeight/2)*24;
			//curs.visible=false;
			if(ev==1){
				addEventListener(MouseEvent.MOUSE_DOWN, m_press);
				addEventListener(MouseEvent.MOUSE_UP, m_release);
				Mouse.hide();
				cont.addChild(curs);
				m_hide=true;
				rocket=true;
			}else if(ev==2){
				/*addEventListener(MouseEvent.MOUSE_DOWN, m_press);
				addEventListener(MouseEvent.MOUSE_UP, m_release);
				Mouse.hide();
				addChild(curs);
				m_hide=true;
				plane=true;*/
				socket.sendEvent1(23,((int(mouseX/24)+1)+(int(mouseY/24))*lWidth));
			}
		}
		
		public function resetAir(){
			try{
				removeEventListener(MouseEvent.MOUSE_DOWN, m_press);
				removeEventListener(MouseEvent.MOUSE_UP, m_release);
			}catch(e:Error){}
			try{
				cont.removeChild(curs);
			}catch(e:Error){}
			Mouse.show();
			m_hide=false;
			rocket=false;
			plane=false;
		}
		
		public var m_hide:Boolean=false;
		public var at_press:Boolean=false;
		public var warn_er:Boolean=false;
		public var stat_w:Boolean=false;
		public var help_fnc:Function=null;
		
		public function game_ov(a:int,b:int,c:int,d:int,e:int,f:int,g:int,h:Array,p:int,u:int,bl:Number){
			win_cl["win_cl"].gotoAndStop(g);
			help_fnc=null;
			if(help_on){
				if(help_st<3){
<<<<<<< HEAD:client/work/fps test1/game/myStage.as
					if(g!=1){
						help_fnc=function(){
							help_cl["lesson1"]["win"]["leave_cl"].set_type(2);
							Lesson(2);
							help_fnc=null;
						}
					}else{
						help_fnc=function(){
							help_cl["lesson1"]["win"]["leave_cl"].set_type(3);
							help_cl["lesson1"]["win"]["leave_cl"].sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",3+""]]);
							help_fnc=null;
						}
					}
				}else if((help_st>7&&help_st<11)){
					if(g!=1){
						help_fnc=function(){
=======
					if(g!=1){
						help_fnc=function(){
							help_cl["lesson1"]["win"]["leave_cl"].set_type(2);
							Lesson(2);
							help_fnc=null;
						}
					}else{
						help_fnc=function(){
							help_cl["lesson1"]["win"]["leave_cl"].set_type(3);
							help_cl["lesson1"]["win"]["leave_cl"].sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",3+""]]);
							help_fnc=null;
						}
					}
				}else if((help_st>7&&help_st<11)){
					if(g!=1){
						help_fnc=function(){
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/game/myStage.as
							help_cl["lesson1"]["win"]["leave_cl"].set_type(10);
							Lesson(10);
							help_fnc=null;
						}
					}else{
						help_fnc=function(){
							help_cl["lesson1"]["win"]["leave_cl"].set_type(11);
							help_cl["lesson1"]["win"]["leave_cl"].sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",11+""]]);
							help_fnc=null;
						}
					}
				}
			}
			win_cl["win_cl"]["walls_dm"].text="Урон: "+(a+b)+" ед.";
			win_cl["win_cl"]["tanks_dm"].text="Убито врагов: "+c;
			win_cl["win_cl"]["znakov"].text="Получено опыта: "+d;
			if(bl>=0){
				win_cl["win_cl"]["kills"].text="Доверие: +"+bl;
			}else{
				win_cl["win_cl"]["kills"].text="Доверие: "+bl;
			}
			if(u!=0){
				win_cl["win_cl"]["znak_cl"].gotoAndStop(2);
				if(u<0){
					win_cl["win_cl"]["znaki"].text=0;
				}else{
					win_cl["win_cl"]["znaki"].text=u;
				}
			}else{
				win_cl["win_cl"]["znak_cl"].gotoAndStop(1);
				win_cl["win_cl"]["znaki"].text=e;
			}
			win_cl["win_cl"]["money"].text=f;
			if(p>=0){
				win_cl["win_cl"]["top_tx"].text="Очков рейтинга: +"+p;
			}else{
				win_cl["win_cl"]["top_tx"].text="Очков рейтинга: "+p;
			}
			if(h[0]){
				win_cl["priz_cl"]["pr_info"]["pr_str"]=h[2];
				win_cl["priz_cl"].visible=true;
				win_cl["priz_cl"]["name_tx"].text=h[1];
				if(h[3]==0){
					win_cl["priz_cl"]["tx_tx"].visible=false;
				}else{
					win_cl["priz_cl"]["tx_tx"].visible=true;
				}
			}else{
				win_cl["priz_cl"].visible=false;
			}
			addChild(win_cl);
		}
		
		public function warn_f(er_num:int,err_tx:String,_code:int=0){
			if(er_num!=9&&er_num>3&&_code==0){
				if(socket!=null){
					//if(!socket["loading"]&&socket["mloaded"]){
						if(!game_over){
							warn_er=false;
							return;
						}
					//}
				}
			}
			stat_w=false;
			warn_cl["warn_cl"]["close_cl"].set_type(0);
			warn_cl["warn_cl"]["close_cl"].set_break(0);
			if(reff=="wall_post_inline"||reff=="wall_view_inline"){
				warn_cl.x=756/2-warn_cl["warn_cl"].width/2;
				warn_cl.y=600/2-warn_cl["warn_cl"].height/2;
			}else{
				warn_cl.x=304-190;
				warn_cl.y=232-55;
			}
			if(er_num!=13){
				warn_cl["cl_win"]["cl_call"].resetImage();
				warn_cl["cl_win"].visible=false;
			}
			warn_cl["warn_cl"].visible=true;
			warn_cl["warn_cl"]["out_cl"].visible=false;
			warn_cl["call_cl"].visible=false;
			warn_cl["kontrakt"].visible=false;
			warn_cl["big_wait"].visible=false;
			warn_cl["big_win1"].visible=false;
			warn_cl["gr_win1"].visible=false;
			
			if(er_num==1){
				try{
					wind["choise_cl"].setSt(-13);
				}catch(er:Error){}
				warn_cl["warn_cl"]["close_cl"].visible=true;
				warn_cl["warn_cl"]["warn_tx"].text="Внимание!\n По неизвестным причинам произошёл разрыв соединения с сервером.\n"+err_tx;
			}else if(er_num==2){
				try{
					wind["choise_cl"].setSt(0);
				}catch(er:Error){}
				
				gameReset();
				warn_cl["warn_cl"]["close_cl"].visible=false;
				warn_cl["warn_cl"]["warn_tx"].text="Внимание!\n Соединение с сервером потеряно.\nБой прерван, потраченные боеприпасы восстановлены.";
				wind["choise_cl"].startStatus();
			}else if(er_num==3){
				try{
					wind["choise_cl"].setSt(-13);
				}catch(er:Error){}
				warn_cl["warn_cl"]["close_cl"].visible=true;
				warn_cl["warn_cl"]["warn_tx"].text="Внимание!\n Не удалось получить корректную кросс доменную политику безопасности.\n"+err_tx;
			}else if(er_num==4){
				try{
					wind["choise_cl"].setSt(-13);
				}catch(er:Error){}
				warn_cl["warn_cl"]["close_cl"].visible=true;
				warn_cl["warn_cl"]["warn_tx"].text="Внимание!\n Сервер не отвечает.\n"+err_tx;
			}else if(er_num==5){
				if(_code==5){
					warn_cl["warn_cl"]["close_cl"].set_break(1);
				}
				try{
					wind["choise_cl"].setSt(-12);
				}catch(er:Error){}
				warn_cl["warn_cl"]["close_cl"].visible=true;
				warn_cl["warn_cl"]["warn_tx"].text=""+err_tx;
			}else if(er_num==6){
				try{
					wind["choise_cl"].setSt(-12);
				}catch(er:Error){}
				warn_cl["warn_cl"]["close_cl"].visible=false;
				warn_cl["warn_cl"]["warn_tx"].text="\n Битва завершена, дождитесь загрузки статистики.\n"+err_tx;
				stat_w=true;
			}else if(er_num==7){
				try{
					wind["choise_cl"].setSt(-12);
				}catch(er:Error){}
				warn_cl.x=756/2-warn_cl["warn_cl"].width/2;
				warn_cl.y=600/2-warn_cl["warn_cl"].height/2;
				warn_cl["warn_cl"]["close_cl"].visible=false;
				warn_cl["warn_cl"]["warn_tx"].text="Внимание!\n Дождитесь завершения авторизации.\n"+err_tx;
			}else if(er_num==8){
				try{
					wind["choise_cl"].setSt(-13);
				}catch(er:Error){}
				warn_cl.x=756/2-warn_cl["warn_cl"].width/2;
				warn_cl.y=600/2-warn_cl["warn_cl"].height/2;
				warn_cl["warn_cl"]["close_cl"].visible=false;
				warn_cl["warn_cl"]["warn_tx"].text=err_tx;
			}else if(er_num==9){
				warn_cl["warn_cl"]["warn_tx"].text="";
				warn_er=false;
				try{
					removeChild(warn_cl);
				}catch(e:Error){
					
				}
				return;
			}else if(er_num==10){
				warn_cl["warn_cl"]["close_cl"].visible=false;
				warn_cl["warn_cl"]["warn_tx"].text="Внимание!\n Дождитесь ответа сервера.\n"+err_tx;
			}else if(er_num==11){
				warn_cl["warn_cl"]["close_cl"].visible=false;
				warn_cl["warn_cl"]["out_cl"].visible=true;
				warn_cl["warn_cl"]["out_cl"].gotoAndStop(1);
				stage.focus=stage;
			}else if(er_num==12){
				warn_cl["warn_cl"]["close_cl"].visible=false;
				warn_cl["warn_cl"]["out_cl"].visible=true;
				warn_cl["warn_cl"]["out_cl"].gotoAndStop(2);
				stage.focus=stage;
			}else if(er_num==13){
				if(cl_ar[0]<0){
					return;
				}
				var n_b:Boolean=false;
				//trace(warn_er);
				//trace(warn_cl["cl_win"].currentFrame);
				if(warn_er&&warn_cl["cl_win"].visible&&warn_cl["cl_win"].currentFrame==cl_ar[0]){
					if(warn_cl["cl_win"]["class_tx"].text==cl_ar[1]&&warn_cl["cl_win"]["m_tx"].text==cl_ar[2]){
						if(warn_cl["cl_win"]["txt"].text==cl_ar[4]){
							n_b=true;
						}
					}
				}
				warn_cl["cl_win"].visible=true;
				warn_cl["cl_win"].gotoAndStop(cl_ar[0]);
				warn_cl["cl_win"]["class_tx"].text=cl_ar[1];
				warn_cl["cl_win"]["m_tx"].text=cl_ar[2];
				warn_cl["cl_win"]["txt"].text=cl_ar[4];
				//trace(cl_ar);
				if(cl_ar[0]==1){
					warn_cl["cl_win"]["class_tx"].y=46;
					warn_cl["cl_win"]["class_tx"].x=91;
					warn_cl["cl_win"]["m_tx"].visible=false;
				}else if(cl_ar[0]==1){
					warn_cl["cl_win"]["class_tx"].y=21;
					warn_cl["cl_win"]["class_tx"].x=86;
					warn_cl["cl_win"]["m_tx"].textColor=0xffffff;
					warn_cl["cl_win"]["m_tx"].visible=true;
				}else if(cl_ar[0]==1){
					warn_cl["cl_win"]["class_tx"].y=46;
					warn_cl["cl_win"]["class_tx"].x=91;
					warn_cl["cl_win"]["m_tx"].textColor=0xffffff;
					warn_cl["cl_win"]["m_tx"].visible=true;
				}
				if(!n_b){
					warn_cl["cl_win"]["cl_call"].resetImage();
					warn_cl["cl_win"]["cl_call"].LoadImage(res_url+"/"+cl_ar[3]);
				}
			}else if(er_num==14){
				warn_cl["call_cl"].visible=true;
			}else if(er_num==15){
				warn_cl["warn_cl"]["close_cl"].set_type(3);
				warn_cl["warn_cl"]["close_cl"].visible=true;
				warn_cl["warn_cl"]["warn_tx"].text="Уведомление!\n"+err_tx;
			}else if(er_num==16){
				warn_cl["warn_cl"].visible=false;
				warn_cl["kontrakt"].visible=true;
			}else if(er_num==17){
				warn_cl["warn_cl"].visible=false;
				warn_cl["big_wait"].visible=true;
			}else if(er_num==18){
				warn_cl["warn_cl"].visible=false;
				warn_cl["big_win1"].visible=true;
			}else if(er_num==19){
				warn_cl["warn_cl"].visible=false;
				warn_cl["gr_win1"].visible=true;
			}else if(er_num==25){
				try{
					wind["choise_cl"].setSt(-12);
				}catch(er:Error){}
				warn_cl["warn_cl"]["close_cl"].visible=false;
				warn_cl["warn_cl"]["warn_tx"].text=err_tx;
			}
			if(!(er_num==5&&_code==5)){
				showOpt(1);
			}
			warn_er=true;
			addChild(warn_cl);
		}
		
		public static var cl_ar:Array=new Array(4);
		
		public function getClass(obj:Object):Class {
      return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
		public var fon_cl:MovieClip;
		
		public function windClear(){
			wind["win_cl"].visible=false;
			wind["win_cl1"].visible=false;
			wind["ready_cl"].visible=false;
			wind["wait_cl"].visible=false;
			wind["warn_cl"].visible=false;
			wind["empt_cl"].visible=false;
			wind["diff_win"].visible=false;
			wind["arena_cl"].visible=false;
			wind["set_polk"].visible=false;
			wind["auto_win"].visible=false;
			wind["set_polk"]["vznos_cl"].visible=false;
			wind["set_polk"]["ready_win"].visible=false;
			wind["a_re_win"].visible=false;
			wind["au_gr_win1"].visible=false;
			wind["choise_cl"].resetPolkWin();
			wind["polk_win"].visible=false;
		}
		
		public function windOut(){
			windClear();
			removeChild(wind);
		}
		
		public static var exit_on:Boolean=true;
		public var polk_id:int=0;
		
		public function clearMode(grst:int=0):void{
			if(m_mode==1){
				windOut();
			}else if(m_mode==2){
				removeChild(shop);
			}else if(m_mode==3){
				if(grst==0){
					gameReset();
				}
			}else if(m_mode==4){
				removeChild(stat_cl);
			}else if(m_mode==5){
				removeChild(wind);
				removeChild(svodka_cl);
			}else if(m_mode==6){
				games_cl["ch1"].stopTimer1();
				removeChild(games_cl);
			}else if(m_mode==7){
				removeChild(polk_st_cl);
			}else if(m_mode==8){
				removeChild(akadem_cl);
			}else if(m_mode==9){
				removeChild(kaskad);
			}else if(m_mode==10){
				removeChild(info_help);
			}else if(m_mode==11){
				panel["arsenal_b"].gotoAndStop("out");
				removeChild(vip_cl);
			}
		}
		
		public function createMode(ch:int,grst:int=0):void{
			vip_cl["exit_cl"].tStop();
			panel["ammo0"].tStop();
			showOpt(1);
			//wind["group_win"].visible=false;
			if(ch!=m_mode){
				frst_nws.sc_reset();
				panel["leave_cl"].visible=false;
				kaskad["map_win"]["close_cl"].stopTimer();
				try{
					shop["fuel_win"].visible=false;
					wind["choise_cl"].stopAr();
				}catch(e:Error){}
				games_cl["ch1"].clearGame2();
				games_cl["ch1"].f_wins();
				/*try{
					removeChild(panel);
				}catch(e:Error){}*/
				/*try{
					addChild(panel);
				}catch(e:Error){}*/
				if(ch!=3&&ch!=9){
					panel["buy_val"].gotoAndStop("out");
					panel["arsenal_b"].gotoAndStop("out");
				}
				clearMode(grst);
				if(ch==1){
					addChild(wind);
					//setChildIndex(contur, numChildren-1);
					//shop["exit"].sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["2"],["1","0","1","1"]]);
					m_mode=1;
					try{shop["exit"].buy_mem("showWind1");}catch(er:Error){}
				}else if(ch==2){
					try{
						removeChild(contur);
					}catch(e:Error){}
					shop["buy_cred_win"].visible=false;
					shop["exit"].sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["1"],["1","1","1","1"]]);
					addChild(shop);
					//setChildIndex(contur, numChildren-1);
					m_mode=2;
				}else if(ch==3){
					try{
						removeChild(help_cl);
					}catch(er:Error){
						
					}
					try{
						wind["choise_cl"].stopAr();
					}catch(er:Error){}
					wind["choise_cl"].stopStatus();
					addChild(contur);
					drawFon();
					setChildIndex(chat_cl, numChildren-1);
					setChildIndex(panel, numChildren-1);
					setChildIndex(contur, numChildren-1);
					if(exit_on){
						panel["leave_cl"].visible=true;
					}
					panel["buy_val"].gotoAndStop("empty");
					stage.focus=stage;
					m_mode=3;
				}else if(ch==4){
					if(m_mode==10){
						stat_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id"]],[["2"],["4"]]);
						m_mode=-1;
					}
					if(m_mode>-1){
						try{
							removeChild(contur);
						}catch(e:Error){}
						//stat_cl["item_b0_0_0"].sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["1"],["1","0","0","0"]]);
						stat_cl["ch1"].setWind(1);
						stat_cl["ch1"].de_active();
						stat_cl["ch1"]["name_tx"].textColor=0x0F3C06;
						stat_cl["ch1"].gotoAndStop("press");
						stat_cl["ch1"]["m_active"]=true;
						if(!sv_wall){
							stat_cl["ch1"].setNamePl(rang_name+" "+pl_name);
						}
						addChild(stat_cl);
						m_mode=4;
					}else{
						m_mode=0;
					}
				}else if(ch==5){
					if(m_mode!=1){
						addChild(wind);
					}
					addChild(svodka_cl);
					//setChildIndex(contur, numChildren-1);
					m_mode=5;
				}else if(ch==6){
					try{
						removeChild(contur);
					}catch(e:Error){}
					//stat_cl["item_b0_0_0"].sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["1"],["1","0","0","0"]]);
					games_cl["ch1"].setWind(1);
					games_cl["ch1"].de_active();
					games_cl["ch1"]["name_tx"].textColor=0x0F3C06;
					games_cl["ch1"].gotoAndStop("press");
					games_cl["ch1"]["m_active"]=true;
					addChild(games_cl);
					warn_f(10,"");
					//shop["exit"].resetRkl();
					games_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id","action_type","type"]],[["6"],["1","0","1"]]);
					m_mode=6;
				}else if(ch==7){
					addChild(polk_st_cl);
					m_mode=7;
				}else if(ch==8){
					if(m_mode!=1){
						addChild(wind);
					}
					addChild(akadem_cl);
					m_mode=8;
				}else if(ch==9){
					if(m_mode==10){
						kaskad["map_win"]["close_cl"].sendRequest(["query","action"],[["id"],["id"]],[["3"],["10"]]);
						m_mode=0;
					}else if(m_mode==1){
						addChild(kaskad);
						m_mode=9;
					}else{
						addChild(kaskad);
						m_mode=9;
					}
				}else if(ch==10){
					addChild(info_help);
					info_help.drawList();
					m_mode=10;
				}else if(ch==11){
					addChild(vip_cl);
					m_mode=11;
				}
				if(help_on){
					try{
						setChildIndex(help_cl, numChildren-1);
					}catch(er:Error){
						
					}
				}
				if(warn_cl.stage==null){
					try{
						setChildIndex(chat_cl, numChildren-1);
					}catch(er:Error){
						
					}
				}else{
					try{
						setChildIndex(chat_cl, getChildIndex(warn_cl)-1);
					}catch(er:Error){
						
					}
				}
			}
			if(ch!=3){
				//if(!help_on){
					wind["choise_cl"].startStatus();
				//}
			}
			sv_wall=false;
		}
		
		public var sv_wall:Boolean=false;
		
		private function drawFon(){
			fon_cl=new MovieClip();
			var x1:int=0;
			var rect1:Rectangle=new Rectangle(0,0,24,24);
			var rect:Rectangle;
			var bmd:BitmapData;
			var myBitmap:Bitmap;
			for(var i=0;i<lWidth;i++){
				x1=0;
				try{
					rect=new Rectangle(x1,0,24,24);
					bmd=new BitmapData(24,24,false,0xFFFFFFFF);
					myBitmap=new Bitmap(bmd, "auto", true);
					myBitmap.bitmapData.setVector(rect1,lib.png.ground.bitmapData.getVector(rect));
					myBitmap.x=i*24;
					myBitmap.y=0;
					fon_cl.addChild(myBitmap);
					bmd=new BitmapData(24,24,false,0xFFFFFFFF);
					myBitmap=new Bitmap(bmd, "auto", true);
					myBitmap.bitmapData.setVector(rect1,lib.png.ground.bitmapData.getVector(rect));
					myBitmap.x=i*24;
					myBitmap.y=(lHeight-1)*24;
					fon_cl.addChild(myBitmap);
				}catch(e:Error){
					//trace("Fon1 error: "+e);
				}
			}
			for(var i=0;i<lHeight;i++){
				x1=0;
				try{
					rect=new Rectangle(x1,0,24,24);
					bmd=new BitmapData(24,24,false,0xFFFFFFFF);
					myBitmap=new Bitmap(bmd, "auto", true);
					myBitmap.bitmapData.setVector(rect1,lib.png.ground.bitmapData.getVector(rect));
					myBitmap.x=0;
					myBitmap.y=i*24;
					fon_cl.addChild(myBitmap);
					bmd=new BitmapData(24,24,false,0xFFFFFFFF);
					myBitmap=new Bitmap(bmd, "auto", true);
					myBitmap.bitmapData.setVector(rect1,lib.png.ground.bitmapData.getVector(rect));
					myBitmap.x=(lWidth-1)*24;
					myBitmap.y=i*24;
					fon_cl.addChild(myBitmap);
				}catch(e:Error){
					//trace("Fon2 error: "+e);
				}
			}
			fon_cl.x=4;
			fon_cl.y=4;
			addChildAt(fon_cl,getChildIndex(cont)-1);
		}
		
		public static function get lib():Object{
			return prnt_cl.lib;
		}
		public var socket:CustomSocket;
		public var u_id:String;
		public var gr_id:String;
		public var v_id:String;
		public var fr_ar:Array;
		public var reff:String="empty";
		//public var reff:String="wall_post_inline";
		//public var reff:String="wall_view_inline";
		
		public function doLoad(){
				self=this;
					
				lWidth=25;
				lHeight=19;
				grounds=new Array(lWidth*lHeight);
				walls=new Array(lWidth*lHeight);
				mines=new Array((lWidth)*(lHeight));
				tracks=new Array(100);
				for(i=0;i<grounds.length;i++){
					//grounds[i]=0;
					walls[i]=0;
					mines[i]=0;
				}
				//oils=new Array(lWidth*lHeight);
				//radars=new Array(lWidth*lHeight);
				//turrels=new Array(lWidth*lHeight);
				//trace(stage);
				board_x=4;
				board_y=4;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
				addEventListener(Event.ENTER_FRAME, render);
		}
		
		public var hot_keys:Array=new Array(21);
		public var esc_press:Boolean=false;
		
		public function keyPressed(event:KeyboardEvent){
			//trace(event.keyCode);
			//myStage.self["send_tx"].text=event.keyCode+"";
			if(m_mode!=3){
				if(event.keyCode==Keyboard.CONTROL){
					if(chat_cl!=null){
						chat_cl["_ctrl"]=1;
					}
				}
				return;
			}
			if(event.keyCode==Keyboard.UP||event.keyCode==87){
				//trace("up");
				if(wmess)return;
				myCode[1]=0;
				myCode[2]=1;
				myCode[3]=0;
				myCode[4]=0;
			}else if(event.keyCode==Keyboard.DOWN||event.keyCode==83){
				//trace("down");
				if(wmess)return;
				myCode[1]=0;
				myCode[2]=0;
				myCode[3]=0;
				myCode[4]=1;
			}else if(event.keyCode==Keyboard.LEFT||event.keyCode==65){
				//trace("left");
				if(wmess)return;
				myCode[1]=1;
				myCode[2]=0;
				myCode[3]=0;
				myCode[4]=0;
			}else if(event.keyCode==Keyboard.RIGHT||event.keyCode==68){
				//trace("right");
				if(wmess)return;
				myCode[1]=0;
				myCode[2]=0;
				myCode[3]=1;
				myCode[4]=0;
			}else if(event.keyCode==Keyboard.SPACE){
				if(wmess)return;
				myCode[5]=1;
			}else if(event.keyCode>48&&event.keyCode<55){
				if(wmess)return;
				if(hot_keys[(event.keyCode-48)+10]!=1){
					if(panel["ammo"+(event.keyCode-49)]["quantity"]>0){
						socket.sendEvent((event.keyCode-49)+10,0);
					}
					hot_keys[(event.keyCode-48)+10]=1;
				}
			}else if(event.keyCode==81){
				if(wmess)return;
				if(hot_keys[17]!=1){
					var _cl:MovieClip=panel["ammo0"].find_sl1(8);
					if(_cl!=null&&_cl["quantity"]>0&&!_cl["cd_now"]){
						socket.sendEvent(8,0);
					}
					hot_keys[17]=1;
				}
			}else if(event.keyCode==69){
				if(wmess)return;
				if(hot_keys[18]!=1){
					var _cl:MovieClip=panel["ammo0"].find_sl1(9);
					if(_cl!=null&&_cl["quantity"]>0&&!_cl["cd_now"]){
						socket.sendEvent(9,0);
					}
					hot_keys[18]=1;
				}
			}else if(event.keyCode==70){
				if(wmess)return;
				if(hot_keys[19]!=1){
					var _cl:MovieClip=panel["ammo0"].find_sl1(19);
					if(_cl!=null&&_cl["quantity"]>0&&!_cl["cd_now"]){
						socket.sendEvent(19,0);
					}
					hot_keys[19]=1;
				}
			}else if(event.keyCode==90){
				if(wmess)return;
				if(hot_keys[0]!=1){
					var _cl:MovieClip=panel["ammo0"].find_sl1(21);
					if(_cl!=null&&_cl["quantity"]>0&&!_cl["cd_now"]){
						socket.sendEvent(21,0);
					}
					hot_keys[0]=1;
				}
			}else if(event.keyCode==88){
				if(wmess)return;
				if(hot_keys[1]!=1){
					var _cl:MovieClip=panel["ammo0"].find_sl1(22);
					if(_cl!=null&&_cl["quantity"]>0&&!_cl["cd_now"]){
						//trace(rocket);
						if(rocket){
							resetAir();
						}else{
							createAir(1);
						}
					}
					hot_keys[1]=1;
				}
			}else if(event.keyCode==67){
				if(wmess)return;
				if(hot_keys[2]!=1){
					var _cl:MovieClip=panel["ammo0"].find_sl1(23);
					if(_cl!=null&&_cl["quantity"]>0&&!_cl["cd_now"]){
						createAir(2);
					}
					hot_keys[2]=1;
				}
			}else if(event.keyCode==82){
				if(wmess)return;
				if(hot_keys[3]!=1){
					var _cl:MovieClip=panel["ammo0"].find_sl1(24);
					if(_cl!=null&&_cl["quantity"]>0&&!_cl["cd_now"]){
						socket.sendEvent(24,0);
					}
					hot_keys[3]=1;
				}
			}else if(event.keyCode==84){
				if(wmess)return;
				if(hot_keys[4]!=1){
					var _cl:MovieClip=panel["ammo0"].find_sl1(25);
					if(_cl!=null&&_cl["quantity"]>0&&!_cl["cd_now"]){
						socket.sendEvent(25,0);
					}
					hot_keys[4]=1;
				}
			}else if(event.keyCode==Keyboard.ESCAPE){
				if(!esc_press){
					esc_press=true;
					/*if(chat_cl!=null){
						chat_cl.chatOut();
					}*/
				}
			}
		}
		
		public function keyReleased(event:KeyboardEvent){
			if(event.keyCode==Keyboard.UP||event.keyCode==87){
				////trace("up Release");
				myCode[2]=0;
			}else if(event.keyCode==Keyboard.DOWN||event.keyCode==83){
				////trace("down Release");
				myCode[4]=0;
			}else if(event.keyCode==Keyboard.LEFT||event.keyCode==65){
				////trace("left Release");
				myCode[1]=0;
			}else if(event.keyCode==Keyboard.RIGHT||event.keyCode==68){
				////trace("right Release");
				myCode[3]=0;
			}else if(event.keyCode==Keyboard.SPACE){
				////trace("fire Release");
				myCode[5]=0;
			}else if(event.keyCode>48&&event.keyCode<55){
				hot_keys[(event.keyCode-48)+10]=0;
			}else if(event.keyCode==81){
				hot_keys[17]=0;
			}else if(event.keyCode==69){
				hot_keys[18]=0;
			}else if(event.keyCode==70){
				hot_keys[19]=0;
			}else if(event.keyCode==90){
				hot_keys[0]=0;
			}else if(event.keyCode==88){
				hot_keys[1]=0;
			}else if(event.keyCode==67){
				hot_keys[2]=0;
			}else if(event.keyCode==82){
				hot_keys[3]=0;
			}else if(event.keyCode==84){
				hot_keys[4]=0;
			}else if(event.keyCode==Keyboard.ESCAPE){
				//shop["exit"].sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["1"],["1","0","0","0"]]);
				//wind["choise_cl"].hideNews();
				esc_press=false;
			}else if(event.keyCode==Keyboard.CONTROL){
				//prnt_cl.showMoneyWin(110);
				//pl_clip.teslaOn(7,pl_clip.pos_in_map,200);
				if(chat_cl!=null){
					chat_cl["_ctrl"]=0;
				}
			}
		}
		
		public function keyCodes(){
			if(pl_clip["go"]){
				time_c=0;
				next_go=0;
			}
			if(!pl_clip["del"]){
				if(time_c>5){
						//time_c=0;
					//trace("move");
					if(!warn_er){
						if(pl_clip["commands"].length==0){
							if(!m1_do&&!m3_do){
								if(myCode[1]>0){
									////trace("notfree   "+1);
									mrepeated=false;
									next_go=0;
									socket.sendEvent(1,0);
								}else if(myCode[3]>0){
									////trace("notfree   "+2);
									mrepeated=false;
									next_go=0;
									socket.sendEvent(3,0);
								}else if(myCode[2]>0){
									////trace("notfree   "+3);
									mrepeated=false;
									next_go=0;
									socket.sendEvent(2,0);
								}else if(myCode[4]>0){
									////trace("notfree   "+4);
									mrepeated=false;
									next_go=0;
									socket.sendEvent(4,0);
								}
							}
						}
					}
				}else{
					/*if(myCode[1]>0){
							next_go=1;
					}else if(myCode[3]>0){
							next_go=3;
					}else if(myCode[2]>0){
							next_go=2;
					}else if(myCode[4]>0){
							next_go=4;
					}*/
					time_c++;
				}
				if(fcount>fire_cd){
					//trace(fcount+"   "+fire_cd);
					if(!warn_er){
						if(myCode[5]>0){
							if(pl_clip["fire_type"]>-1){
								//if(myStage.panel["ammo"+pl_clip["fire_type"]]["quantity"]>0){
									//trace("shut1   "+fire_cd);
									socket.sendEvent(5,0);
									fcount=0;
								//}
							}else{
								//trace("shut    "+fire_cd);
								socket.sendEvent(5,0);
								fcount=0;
							}
						}
					}
				}else{
					//trace(fcount);
					fcount++;
				}
			}
		}
		
		public static var lag_tx:TextField=new TextField();
		
		public static var ammo_do:Boolean=false;
		public static var ammo_left:int=0;
		public static var ammo_steps:int=0;
		public static var ammo_time:int=0;
		public function m_cd(){
			var mz:int=panel["leave_cl"].MZ;
			var step_time:int=panel["leave_cl"].getStep();
			
			if(ammo_do){
				var _t:int=(ammo_time+ammo_steps)-step_time;
				if(_t>0){
					ammo_left++;
				}else{
					Bullet.last_efx=0;
				}
			}
			
			if(m1_do){
				var _t:int=(m1_time+steps1)-step_time;
				if(_t>0){
					m1_left++;
					if(_t<80&&pl_clip!=null){
						if(_t%15==0){
							if(!pl_clip["stoped"]){
								pl_clip["stoped"]=true;
								b_and_w(pl_clip,1);
							}else{
								pl_clip["stoped"]=false;
								b_and_w(pl_clip);
							}
						}
					}
				}/*else{
				try{
				channel.stop();
				}catch(er:Error){
				
				}
				m1_left=0;
				m1_do=false;
				if(stg_class["pl_clip"]!=null){
				stg_class["pl_clip"]["stoped"]=false;
				b_and_w(stg_class["pl_clip"]);
				}
				}*/
			}
			/*if(m3_do){
			var _t:int=(m3_time+steps3)-step_time;
			if(_t>0){
			m3_left++;
			
			}else{
			stg_class["pl_clip"].teslaOff();
			}
			}*/
			if(m2_do){
				if(step_time<m2_time+steps2){
					m2_left++;
				}else{
					fire_cd=f_cd;
					m2_left=0;
					m2_do=false;
				}
			}
			
			for(mz=0;mz<bonuses.length;mz++){
				if(bonuses[mz]!=null){
					//trace(bon_step[mz]+"   "+step_time);
					if(bon_step[mz]+4>step_time){
						bon_time[mz]--;
						////trace(bon_c[i]);
						if(bon_time[mz]%3==0){
							bon_pict[mz][bon_c[mz]].visible=false;
							if(bon_c[mz]<2){
								bon_c[mz]++;
							}else{
								bon_c[mz]=0;
							}
							////trace(bon_c[mz]);
							bon_pict[mz][bon_c[mz]].visible=true;
						}
					}else{
						try{
							ground.removeChild(bonuses[mz]);
							bonuses[mz]=null;
							bon_id[mz]=null;
							bon_pos[mz]=null;
							bon_time[mz]=null;
							bon_type[mz]=null;
							bon_pow[mz]=null;
							bon_step[mz]=null;
							bon_pict[mz]=null;
							bon_c[mz]=null;
						}catch(er:Error){
							
						}
					}
				}
			}
		}
		
		private var last_date:Vector.<Number>=new Vector.<Number>();
		private var test_fps:int=25;
		private var test_time:Number=1000/test_fps;
		
		public function render(event:Event){
			last_date.push(new Date().time);
			if(last_date.length>100){
				if(stage.frameRate>test_fps){
					try{
						socket.close();
					}catch(er:Error){
						
					}
					warn_f(5,"Wrong application fps.");
				}else{
					var _c:Number=0;
					j=0;
					for(i=1;i<last_date.length;i++){
						_c+=test_time-(last_date[i]-last_date[j]);
						j++;
					}
					if(_c>1000){
						try{
							socket.close();
						}catch(er:Error){
							
						}
						warn_f(5,"Wrong application fps.");
					}
					last_date=new Vector.<Number>();
				}
			}
			
			if(socket!=null){
				//socket.parsePack();
				if(!socket["loading"]&&socket["mloaded"]){
					if(panel!=null){
						panel["ammo0"].render();
						m_cd();
					}
						if(lag_mess&&!game_over){
							lag_c++;
							if(lag_test==0){
								if(lag_c>70){
									//trace("lag");
									//antilag=false;
									socket.sendEvent(30,0);
									lag_c=0;
									lag_tx.width=300;
									lag_tx.height=30;
									//lag_tx.
									lag_tx.text="Идёт ожидание ответа от сервера "+0+" сек...";
									lag_tx.textColor=0xff0000;
									cont.addChild(lag_tx);
									lag_test=1;
								}
							}
							if(lag_test==1){
								if(lag_c>0){
									if(int(lag_c/24)*24==lag_c){
										socket.sendEvent(30,0);
									}
								}
								lag_tx.text="Идёт ожидание ответа от сервера "+int(lag_c/24)+" сек...";
							}
						}
						explodes();
						/*if(CustomSocket.timestep>-1){
							CustomSocket.timestep++;
						}*/
						//if(!socket["loading"]&&socket["mloaded"]){
							if(pl_clip!=null&&!pl_clip["del"]){
								keyCodes();
							}
						//}
						//if(ground!=null){
							artBomding();
							oilBomding();
							if(plane||rocket){
								if((mouseX>0&&mouseX<lWidth*24)&&(mouseY>0&&mouseY<lHeight*24)){
									if(!m_hide){
										Mouse.hide();
										m_hide=true;
										curs.visible=true;
									}
									//curs.x=(int(mouseX/24))*24+6;
									//curs.y=(int(mouseY/24))*24+6;
									curs.x=int(mouseX);
									curs.y=int(mouseY);
								}else{
									if(m_hide){
										Mouse.show();
										m_hide=false;
										curs.visible=false;
									}
								}
							}
							ground.track.graphics.clear();
							expls.graphics.clear();
							for(i=0;i<tracks.length;i++){
								if(tracks[i]>0){
									track_c[i]++;
									if(track_c[i]>30){
										track_c1[i]++;
										tracks[i]++;
										track_c[i]=0;
									}
									ground.setTrack(track_pos[i],track_c1[i],i);
								}
								if(smokes[i]>0){
									smoke_c[i]++;
									if(smoke_c[i]>3){
										smoke_c1[i]++;
										smoke_c[i]=0;
									}
									setSmoke(smoke_c1[i],i);
								}
								if(booms[i]>0){
									setEX(boom_c1[i],i);
									boom_c1[i]++;
								}
								if(hides[i]>0){
									hide_c1[i]++;
									setHide(hide_c1[i],i);
								}
							}
							/*for(i=0;i<air_c.length;i++){
								air_move(i);
							}*/
							for(i=0;i<roc_c.length;i++){
								roc_move(i);
							}
						//}
					
				}
			}else{
				if(all_ready&&m_mode!=3&&!wind["ready_cl"].visible){
					lag_c++;
					if(lag_c>70){
						if(!wind["choise_cl"].getStatSt()){
							wind["choise_cl"].startStatus();
						}
						lag_c=0;
					}
				}
			}
		}
		
		public function log_pack(_num:int){
			CustomSocket.trace_st=_num; // 1-send 3-catch
		}
		
		public function LoadMap(){
			kaskad["map_win"]["close_cl"].stopTimer();
			socket = new CustomSocket(serv_url, port_num);
		}
		
		public var metka:Number;
		public var b_ov_count:int=0;
		
		public function getBattleOver():void{
			metka=map_id[0]*(Math.pow(256,3))+map_id[1]*(Math.pow(256,2))+map_id[2]*256+map_id[3];
			var xml_str="<query id=\"3\"><action id=\"4\" metka1=\""+metka+"\" /></query>";
			var xml:XML=new XML(xml_str);
			var s_link:String=scr_url+"?query="+3+"&action="+4;
			var rqs:URLRequest=new URLRequest(s_link);
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			loader.addEventListener(Event.COMPLETE, Errors[0][0]);
			var variables:URLVariables = new URLVariables();
			variables.query = xml;
			variables.send = "send";
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErOver);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErOver);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
			warn_f(10,"");
		}
		
		public function onErOver(event:Event):void{
			if(b_ov_count==2){
				warn_f(5,"Результаты битвы ещё не готовы и защитаются позднее.");
				return;
			}
			getBattleOver();
			b_ov_count++;
		}
		
		public function overWind(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				//trace(str);
				warn_f(5,"Неверный формат полученных данных. \nЗавершение боя.");
				erTestReq(3,4,str);
				return;
			}
			//trace("overWind   "+list);
			if(int(list.attribute("type"))==1){
				gameReset();
				createMode(9);
				panel["arsenal_b"].gotoAndStop("empty");
				kaskad["map_win"]["close_cl"].addMission(str);
				warn_f(9,"");
				try{System.disposeXML(list);}catch(er:Error){}
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))==10){
						var list1:XML=new XML(String(list.child("err")[0].child("query")));
						errN(list1,int(list.child("err")[0].attribute("time")),list.child("err")[0].attribute("comm")+"");
						return;
					}
					warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			warn_f(9,"");
			//trace(list);
			cl_ar=new Array(5);
			cl_ar[0]=-1;
			if(list.child("new_zp").length()>0){
				cl_ar[0]=2;
				cl_ar[1]=list.child("new_zp")[0].attribute("name");
				cl_ar[2]="монеты войны "+list.child("new_zp")[0].attribute("zp")+" шт.";
				cl_ar[3]=list.child("new_zp")[0].attribute("img");
				cl_ar[4]="";
			}
			if(list.child("new_class").length()>0){
				cl_ar[0]=1;
				cl_ar[1]=list.child("new_class")[0].attribute("name");
				cl_ar[2]="монеты войны "+list.child("new_class")[0].attribute("zp")+" шт.";
				cl_ar[3]=list.child("new_class")[0].attribute("img");
				cl_ar[4]="Вам присвоена классность:";
			}
			win_cl["win_cl"]["show_st"].setNum(Number(list.child("end_battle")[0].attribute("battle_num")));
			var win_ini:int=0;
			if(int(list.child("end_battle")[0].attribute("win"))==2){
				win_ini=1;
			}else if(int(list.child("end_battle")[0].attribute("win"))==3){
				win_ini=3;
			}else if(int(list.child("end_battle")[0].attribute("win"))==0){
				win_ini=4;
			}else{
				win_ini=2;
			}
			var ar12:Array=new Array(4);
			
			try{
				ar12[0]=(String(list.child("gifts")[0].child("gift")[0].attribute("name")).length>0);
				ar12[1]=(list.child("gifts")[0].child("gift")[0].attribute("name"));
				ar12[2]=(list.child("gifts")[0].child("gift")[0].attribute("descr"));
				ar12[3]=(0);
			}catch(er:Error){
				ar12=new Array(false,"","",0);
			}
			try{
				ar12[0]=(String(list.child("achievements")[0].child("achievement")[0].attribute("name")).length>0);
				ar12[1]=(list.child("achievements")[0].child("achievement")[0].attribute("name"));
				ar12[2]=(list.child("achievements")[0].child("achievement")[0].attribute("descr"));
				ar12[3]=(1);
			}catch(er:Error){
				//ar12=new Array(false,"","",0);
			}
			//trace(ar25);
			
			//trace(ar12);
			game_ov(int(list.child("end_battle")[0].attribute("damage_to_environment")),
													 int(list.child("end_battle")[0].attribute("damage_to_bot"))+int(list.child("end_battle")[0].attribute("damage_to_tank")),
													 int(list.child("end_battle")[0].attribute("killed_players"))+int(list.child("end_battle")[0].attribute("killed_bots")),
													 int(list.child("end_battle")[0].attribute("exp")),
													 int(list.child("end_battle")[0].attribute("money_z")),
													 int(list.child("end_battle")[0].attribute("money_m")),
													 win_ini,
													 ar12,
													 int(list.child("end_battle")[0].attribute("top")),
													 int(list.child("end_battle")[0].attribute("money_a")),
													 Number(list.child("end_battle")[0].attribute("addDov")));
			try{System.disposeXML(list);}catch(er:Error){}
		}
	}
	
}
import flash.display.*;
import flash.errors.*;
import flash.events.*;
import flash.geom.ColorTransform;
import flash.net.*;
import flash.system.Security;
import flash.system.System;
import flash.text.*;
import flash.utils.*;
import flash.utils.Timer;
class CustomSocket extends Socket {
    //public var target:MovieClip;
		public var str0:String="";
		public var str:String="";
		public var mlag:Boolean=false;
		public var mloaded:Boolean=false;
		public var loading:Boolean=false;
		public var new_obj:Boolean=false;
		public var sinhro:Boolean=false;
		public var wait1:Boolean=false;
		public var count:int=0;
		public var sr_count:int=0;
		public var ba1:Array = new Array();
		public var ba2:Array = new Array();
		public var buff:Array = new Array();
		public var buff1:ByteArray = new ByteArray();
		public var br:ByteArray = new ByteArray();
		public var stg:DisplayObject;
		public var k:int=0;
		public var m:int=0;
		public var r:int=0;
		//public var t:int=0;
		//public var q:int=0;
		public var v:int=0;
		public var id_obj:int=0;
		public var id_obj1:int=0;
		public var obj_num:int=0;
		public var obj_type:int=0;
		public var gr_type:int=0;
		public var banum:int=0;
		public var bacount:int=0;
		public var bacount1:int=0;
		public var current:int=0;
		public var mavailible:int=0;
		public var ping:int=0;
		public var type_er:int=0;
		public static var timestep:Number=-1;
		public static var timestep1:Number=-1;
		public static var map_id:Boolean=false;
		
		public static var trace_st:int=0;
		
    public function CustomSocket(host:String = null, port:uint = 0) {
        super();
				//myStage.txt.text="Попытка соединения";
				System.gc();
				myStage.self["b_ov_count"]=0;
				configureListeners();
				if(myStage.self["port_now"]>0){
					Security.loadPolicyFile("xmlsocket://"+host+":"+myStage.self["port_now"]);
					super.connect(host, myStage.self["port_now"]);
				}else{
					Security.loadPolicyFile("xmlsocket://"+host+":"+port);
					super.connect(host, port);
				}
    }
		
    private function configureListeners():void {
        addEventListener(Event.CLOSE, closeHandler);
        addEventListener(Event.CONNECT, connectHandler);
        addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
    }
		
		private var trace_queue:String="";
		private var trace_count:int=0;
		private function tracePack(tr:*,_len:int, _n_s:String="any pack",_type:int=0):void {
			if(trace_st!=_type&&trace_st>-1){
				return;
			}
			trace_queue+=_n_s+" ";
			for(var i:int=0;i<_len;i++){
				if(int(tr[i])<10){
					trace_queue+="  ";
				}else if(int(tr[i])<100){
					trace_queue+=" ";
				}
				trace_queue+=(tr[i])+"|";
<<<<<<< HEAD:client/work/fps test1/game/myStage.as
			}
			trace_queue+=" ";
			for(var i:int=trace_queue.length;i<70;i++){
				trace_queue+=" ";
			}
=======
			}
			trace_queue+=" ";
			for(var i:int=trace_queue.length;i<70;i++){
				trace_queue+=" ";
			}
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/game/myStage.as
			trace_queue+="< parse_length="+_len+" pack_length="+tr.length+" >\n";
			trace_count++;
			if(trace_count>20){
				trace_count=0;
				myStage.prnt_cl.output(trace_queue,1);
				//trace(trace_queue);
				trace_queue="";
			}
			//trace(s_tr);
		}
		
    private function sendRequest():void {
				if(!map_id){
					map_id=true;
					br=new ByteArray();
					//trace("send metka1   "+myStage.map_id);
					br.writeByte(myStage.map_id[0]);
					br.writeByte(myStage.map_id[1]);
					br.writeByte(myStage.map_id[2]);
					br.writeByte(myStage.map_id[3]);
					try {
							tracePack(br,4,"battle  ",1);
							//trace("Битва    :  "+br[0]+"  "+br[1]+"  "+br[2]+"  "+br[3]);
							writeBytes(br,0,br.length);
							myStage.time_c=0;
							flush();
							myStage.chat_cl.outRooms();
							myStage.chat_cl.closePochta();
							myStage.self.stage.focus=myStage.self.stage;
							System.gc();
					}catch(e:IOError) {
						myStage.prnt_cl.output("sendRequest: Не вышло отправить событие игрока: "+e+"\n",1);
					}
					//myStage.self.testReq();
				}
        //flush();
    }
		
		public function sendEvent(code:int, lag:int){
			br=new ByteArray();
			br.writeByte(code);
			br.writeByte(Math.floor(Math.floor((myStage.steps+lag))/256));
			br.writeByte(Math.floor(Math.floor((myStage.steps+lag))%256));
			try {
				if(code<5){
					if(myStage.antilag){
						try{
							if(/*myStage.pl_clip["commands1"].length==0&&*/myStage.pl_clip["commands"].length==0){
								if(!myStage.pl_clip["go"]||lag!=0){
									if(myStage.pl_clip["rat"]==code){
										myStage.pl_clip["commands1"].push(code+4);
										myStage.pl_clip["pos_ar1"].push(myStage.pl_clip["next_pos"]);
										myStage.pl_clip["com_buff"].push(code+4);
										myStage.pl_clip["pos_buff"].push(myStage.pl_clip["next_pos"]);
									}else{
										myStage.pl_clip["commands1"].push(code);
										myStage.pl_clip["pos_ar1"].push(myStage.pl_clip["next_pos"]);
										myStage.pl_clip["com_buff"].push(code);
										myStage.pl_clip["pos_buff"].push(myStage.pl_clip["next_pos"]);
									}
								}
							}
						}catch(er:Error){}
					}
					myStage.time_c=0;
				}else if(code==5){
					//gun_shots
					if(myStage.antilag){
						if(!myStage.f_shot){
							myStage.pl_clip["fire_power"]=myStage.basic_dm;
							myStage.pl_clip["fire_type"]=-1;
							for(var _f:int=0;_f<6;_f++){
								if(myStage.panel["ammo"+_f]["quantity"]>0){
									myStage.pl_clip["fire_type"]=_f;
									myStage.pl_clip["fire_power"]=myStage.ammo_dm[myStage.pl_clip["fire_type"]];
								}
							}
							if(myStage.pl_clip["fire_type"]>=0){
								myStage.self.playSound("gun"+(Math.floor(Math.random()*3)+1),0);
								myStage.panel["ammo0"].ch_ammo(myStage.pl_clip["fire_type"]);
							}
							myStage.f_shot=true;
						}
						Tank.dofire(Tank(myStage.pl_clip),myStage.pl_clip["rat"],myStage.pl_clip["next_pos"]+1,-1);
					}
					/*var arr:Array=new Array();
					for(var _i:int=0;_i<br.length;_i++){
						arr.push(br[_i]);
					}
					trace("send   "+timestep1+"   "+arr);*/
				}
				//trace("sendEvent   "+br);
				tracePack(br,br.length,"send    ",2);
				writeBytes(br,0,br.length);
				flush();
      }catch(e:IOError) {
				myStage.prnt_cl.output("sendEvent: Не вышло отправить событие игрока: "+e+"\n",1);
      }
			//return;
		}
		
		public function sendEvent1(code:int, code1:int){
			br=new ByteArray();
			br.writeByte(code);
			br.writeByte(int((code1)/256));
			br.writeByte(int((code1)%256));
			try {
				//trace("Отправка события   "+br[0]+"   "+(br[1]*256+br[2])+"   "+code1);
				//myStage.self["send_tx"].text="Отправка события   "+br[0]+"   "+(br[1]*256+br[2])+"   "+(lag!=0);
				//trace("sendEvent1  "+br);
				tracePack(br,br.length,"send1   ",2);
				writeBytes(br,0,br.length);
				//mchange=true;
				//myStage.time_c=0;
				flush();
      }catch(e:IOError) {
        myStage.prnt_cl.output("sendEvent1: Не вышло отправить событие игрока: "+e+"\n",1);
      }
			//return;
		}
		
		public function sendTest(code:int){
			br=new ByteArray();
			br.writeByte(int(code/(Math.pow(256,2))));
			br.writeByte(int((code)/256));
			br.writeByte(int((code)%256));
			try {
				//trace("Отправка события   "+br[0]+"   "+(br[1]*256+br[2])+"   "+code1);
				//myStage.self["send_tx"].text="Отправка события   "+br[0]+"   "+(br[1]*256+br[2])+"   "+(lag!=0);
				//trace("sendTest    "+br);
				tracePack(br,br.length,"test    ",2);
				writeBytes(br,0,br.length);
				//trace(br[0]+"   "+br[1]+"   "+br[2]);
				//myStage.time_c=0;
				flush();
      }catch(e:IOError) {
        myStage.prnt_cl.output("sendTest: Не вышло отправить событие игрока: "+e+"\n",1);
      }
			//return;
		}
		
		private function firstSynhro(){
			//today=new Date();
			////trace("start="+today.getTime());
							
							//if(!mloaded)//trace("id="+myStage.tank_id);
							////trace("package length="+mavailible);
							if(!mloaded){
								loading=true;
								myStage.tank_id=ba1[1]*256+ba1[2];
								timestep=ba1[5]*256+ba1[6];
								myStage.steps=timestep;
								myStage.panel["ammo0"].timeStep(timestep);
								//trace("tank_id   "+myStage.tank_id);
							}
							//trace("size   "+mavailible+"   "+ba1.length+"   "+myStage.tank_id);
							/*//trace("Synchro start");
							for(var i:int=0;i<ba1.length;i++){
								if(ba1[i]>450){
									break;
								}
								//trace(ba1[i]);
							}
							//trace("Synchro end");*/
							////trace("timestep="+timestep);
								for(var i:int=7;i<mavailible+7;i++){
									if(bacount1==0){
										current=(ba1[i]*256+ba1[i+1])-1;
										bacount1++;
										count++;
										i++;continue;
									}else if(bacount1==1){
										//trace(current+"   "+ba1[i]+"   "+ba1[i+1]);
										if(ba1[i]>0){
											bacount1++;
										}else{
											bacount1=0;
										}
										gr_type=ba1[i];
										i++;
										myStage.grounds[current]=ba1[i];
										continue;
									}else if(bacount1==2){
										id_obj=ba1[i]*256+ba1[i+1];
										bacount1++;
										i++;continue;
									}else if(bacount1==3){
										////trace(mavailible+"   "+ba1.length+"   "+current+"   "+id_obj+"   "+ba1[i]+" "+ba1[i+1]+" "+ba1[i+2]+" "+ba1[i+3]+" "+ba1[i+4]+" "+ba1[i+5]+" "+ba1[i+6]+" "+ba1[i+7]);
										if(ba1[i]>0){
											if(ba1[i]<13){
												//trace("tank "+current+"   "+id_obj+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]);
												myStage.obj_vect[id_obj]=(ba1[i]);
												myStage.obj_pos[id_obj]=(current);
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_heal[id_obj]=(ba1[i+1]*256+ba1[i+2]);
												myStage.obj_heal1[id_obj]=(ba1[i+4]*256+ba1[i+5]);
												myStage.obj_speed[id_obj]=ba1[i+3];
												myStage.obj_gun[id_obj]=ba1[i+6]-2;
												if(myStage.tank_id==id_obj){
													myStage.obj_resp[id_obj]=myStage.lifes-1;
												}else{
													myStage.obj_resp[id_obj]=(2);
												}
												myStage.obj_num[id_obj]=int((ba1[i]-9)/4);
												while(ba1[i]>12)ba1[i]-=4;
												if(ba1[i]<5){
													myStage.obj_type[id_obj]=(1);
													if(myStage.tank_id==myStage.obj_id[id_obj]){
														myStage.tank_type=1;
													}
												}else if(ba1[i]<9){
													//trace("enemy "+current+"   "+id_obj+"   "+ba1[i-3]+"   "+ba1[i-2]+"   "+ba1[i-1]+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]+"   "+ba1[i+5]);
													myStage.obj_type[id_obj]=(2);
													if(myStage.tank_id==myStage.obj_id[id_obj]){
														myStage.tank_type=2;
													}
												}else{
													//trace("bot "+current+"   "+id_obj+"   "+ba1[i-3]+"   "+ba1[i-2]+"   "+ba1[i-1]+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]+"   "+ba1[i+5]);
													myStage.obj_type[id_obj]=(3);
												}
												myStage.obj_obj[id_obj]=1;
												while(myStage.obj_vect[id_obj]>4)myStage.obj_vect[id_obj]-=4;
												bacount1=0;
												i+=6;
												continue;
											}else if(ba1[i]>19&&ba1[i]<22){
												////trace("wall "+current+"   "+ba1[i-3]+"   "+ba1[i-2]+"   "+ba1[i-1]+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]+"   "+ba1[i+5]);
												myStage.objs[id_obj]=(ba1[i]);
												myStage.obj1[id_obj]=(ba1[i]);
												myStage.obj_pos[id_obj]=(current);
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_heal[id_obj]=(ba1[i+1]);
												myStage.obj_heal1[id_obj]=(0);
												if(ba1[i]==20){
													myStage.walls[current]=(9+ba1[i+2]);
												}else if(ba1[i]==21){
													myStage.walls[current]=(19+ba1[i+2]);
												}
												////trace("wall1 "+ba1[i-3]+"   "+ba1[i-2]+"   "+ba1[i-1]+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]+"   "+ba1[i+5]);
												//i+=2;
												myStage.obj_obj[id_obj]=-1;
												bacount1=0;
												i+=4;
												continue;
											}else if(ba1[i]>21&&ba1[i]<26){
												//trace("anywall "+current+"   "+id_obj+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]);
												var frame:int=int((ba1[i+1]/ba1[i+3])*8);
												var rand:int=0;
												if(int(frame/2)*2==frame){
													rand=0;
												}else{
													rand=1;
												}
												myStage.objs[id_obj]=(ba1[i]);
												myStage.obj1[id_obj]=(ba1[i]);
												myStage.obj_pos[id_obj]=(current);
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_heal[id_obj]=(ba1[i+1]);
												myStage.obj_heal1[id_obj]=(ba1[i+3]);
												myStage.obj_rand[id_obj]=(rand);
												
												r=(9-frame);
												if(ba1[i+2]==0){
													if(r<9){
														myStage.walls[current]=r;
													}else{
														myStage.walls[current]=8;
													}
												}else{
													if(r<9){
														myStage.walls[current]=r+10;
													}else{
														myStage.walls[current]=18;
													}
												}
												myStage.obj_obj[id_obj]=-2;
												bacount1=0;
												i+=4;
												continue;
											}else if(ba1[i]==18){
												//trace("Mine "+current+"   "+id_obj+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]);
												Ground.Mines[current]=10+(ba1[i+1]-6);
												bacount1=0;
												i+=4;
												continue;
											}else if(ba1[i]==41){
												//trace("turrel "+current+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]+"   "+ba1[i+5]);
												//myStage.turr_vect.push(ba1[i]);
												myStage.obj_pos[id_obj]=(current);
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_heal[id_obj]=(ba1[i+1]);
												myStage.obj_heal1[id_obj]=(ba1[i+3]);
												myStage.obj_gun[id_obj]=(ba1[i+4]-2);
												myStage.obj_R[id_obj]=(ba1[i+2]);
												myStage.obj_speed[id_obj]=(ba1[i+4]);
												myStage.obj_obj[id_obj]=2;
												myStage.obj_tail[id_obj]=(ba1[i+5]);
												bacount1=0;
												i+=5;
												continue;
											}else if(ba1[i]>30&&ba1[i]<34){
												//trace("flag "+current+"   "+id_obj+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]);
												myStage.obj_pos[id_obj]=(current);
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_num[id_obj]=(ba1[i+1]);
												myStage.obj_type[id_obj]=(ba1[i]-30);
												myStage.obj_obj[id_obj]=-3;
												bacount1=0;
												i+=4;
												continue;
											}else if(ba1[i]==19){
												//trace("Base "+current+"   "+id_obj+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]);
												if(myStage.base_pos.length<1){
													myStage.base.push(2);
													myStage.base_pos.push(current);
												}else{
													for(r=0;r<myStage.base_pos.length;r++){
														if(myStage.base_pos[r]==current){
															break;
														}else{
															myStage.base.push(2);
															myStage.base_pos.push(current);
															break;
														}
													}
												}
												bacount1=0;
												i+=4;
												continue;
											}else if(ba1[i]>27&&ba1[i]<31){
												//trace("Radar "+current+"   "+id_obj+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]);
												if(myStage.obj_pos[id_obj]==null){
													myStage.obj_pos[id_obj]=(current);
												}
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_heal[id_obj]=(ba1[i+1]);
												myStage.obj_heal1[id_obj]=100;
												myStage.obj_type[id_obj]=(ba1[i]-28)+1;
												myStage.obj_obj[id_obj]=3;
												bacount1=0;
												i+=2;
												continue;
											}else if(ba1[i]>45&&ba1[i]<48){
												//trace("Oil "+current+"   "+id_obj+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]);
												if(myStage.obj_pos[id_obj]==null){
													myStage.obj_pos[id_obj]=(current);
												}
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_heal[id_obj]=(ba1[i+1]);
												myStage.obj_heal1[id_obj]=100;
												myStage.obj_type[id_obj]=(ba1[i+2])-1;
												if(myStage.obj_type[id_obj]<=0){
													myStage.obj_type[id_obj]=3;
												}
												myStage.obj_obj[id_obj]=4;
												myStage.obj_rand[id_obj]=(ba1[i]-46);
												bacount1=0;
												i+=2;
												continue;
											}else if(ba1[i]==48){
												//trace("Big turrel "+current+"   "+id_obj+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]+"   "+ba1[i+5]);
												//myStage.turr_vect.push(ba1[i]);
												if(myStage.obj_pos[id_obj]==null){
													myStage.obj_pos[id_obj]=(current);
												}
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_heal[id_obj]=(ba1[i+1]);
												myStage.obj_heal1[id_obj]=(100);
												myStage.obj_gun[id_obj]=(ba1[i+4]-2);
												myStage.obj_type[id_obj]=(ba1[i+2])-1;
												if(myStage.obj_type[id_obj]<=0){
													myStage.obj_type[id_obj]=3;
												}
												myStage.obj_speed[id_obj]=(ba1[i+4]);
												myStage.obj_obj[id_obj]=5;
												myStage.obj_R[id_obj]=25;
												bacount1=0;
												i+=4;
												continue;
											}else if(ba1[i]==49){
												//trace("Tesla "+current+"   "+id_obj+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]);
												//myStage.turr_vect.push(ba1[i]);
												if(myStage.obj_pos[id_obj]==null){
													myStage.obj_pos[id_obj]=(current);
												}
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_heal[id_obj]=(ba1[i+1]);
												myStage.obj_heal1[id_obj]=(100);
												myStage.obj_type[id_obj]=(ba1[i+2])-1;
												if(myStage.obj_type[id_obj]<=0){
													myStage.obj_type[id_obj]=3;
												}
												myStage.obj_obj[id_obj]=6;
												myStage.obj_R[id_obj]=ba1[i+3];
												bacount1=0;
												i+=3;
												continue;
											}else if(ba1[i]==50){
												//trace("Laser "+current+"   "+id_obj+"   "+ba1[i+1]+"   "+ba1[i+2]+"   "+ba1[i+3]+"   "+ba1[i+4]);
												//myStage.turr_vect.push(ba1[i]);
												if(myStage.obj_pos[id_obj]==null){
													myStage.obj_pos[id_obj]=(current);
												}
												myStage.obj_id[id_obj]=(id_obj);
												myStage.obj_heal[id_obj]=(ba1[i+1]);
												myStage.obj_heal1[id_obj]=(100);
												myStage.obj_type[id_obj]=(ba1[i+2])-1;
												if(myStage.obj_type[id_obj]<=0){
													myStage.obj_type[id_obj]=3;
												}
												myStage.obj_obj[id_obj]=7;
												myStage.obj_vect[id_obj]=ba1[i+3];
												myStage.obj_num[id_obj]=ba1[i+4];
												bacount1=0;
												i+=4;
												continue;
											}else{
												bacount1=0;
												i+=4;
												/*if(gr_type==2){
													i+=5;
												}*/
												trace("secret "+ba1[i-3]+"   "+ba1[i-2]+"   "+ba1[i-1]+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]);
												continue;
											}
										}else{
											bacount1=0;
											i+=4;
											trace("zero type "+ba1[i-3]+"   "+ba1[i-2]+"   "+ba1[i-1]+"   "+ba1[i]+"   "+ba1[i+1]+"   "+ba1[i+2]);
											continue;
										}
									}
								}
				tracePack(ba1,mavailible+7,"sinhro  ",3);
				ba1.splice(0,mavailible+7);
				banum=0;
				bacount=0;
				bacount1=0;
				current=0;
				mavailible=0;
				if(!mloaded){
					mloaded=true;
					myStage.self.parseSinhro();
					getNames();
				}
		}
		
		private function miniPackage(){
			//trace("miniPackage "+br);
			/*try{
				if(ba1[1]*256+ba1[2]==myStage.tank_id){
					trace("player   "+ba1);
				}
			}catch(er:Error){}*/
			/*if(ba1[0]>9){
				trace("catch   "+timestep1+"   "+ba1);
			}*/
			if(ba1[0]<5){
				id_obj=ba1[1]*256+ba1[2];
				timestep1=ba1[8]*256+ba1[9];
				myStage.panel["ammo0"].timeStep(timestep1);
				////trace(timestep1+"   "+myStage.st_count/4);
				//trace("Игрок #"+id_obj+" движется   "+ba1);
				if(myStage.objs[id_obj]!=null){
					
					if(myStage.objs[id_obj]["stoped"]){
						myStage.objs[id_obj]["stoped"]=false;
						myStage.self.b_and_w(myStage.objs[id_obj]);
					}
					
					myStage.obj_pos[id_obj]=(ba1[3]*256+ba1[4])-1;
					var _hlth:uint=ba1[5]*256+ba1[6];
					if(myStage.objs[id_obj]["health"]!=_hlth){
						myStage.objs[id_obj]["health"]=_hlth;
						myStage.objs[id_obj].healthTest();
					}
					myStage.obj_vect[id_obj]=ba1[0];
					var _com:int=0;
					if(ba1[7]>3){
						myStage.obj_speed[id_obj]=ba1[7];
						if(myStage.obj_speed[id_obj]==4){
							myStage.objs[id_obj]["SPEED"]=myStage.norm_sp;
						}else if(myStage.obj_speed[id_obj]==5){
							myStage.objs[id_obj]["SPEED"]=myStage.fast_sp;
						}
						_com=(4+myStage.obj_vect[id_obj]);
					}else{
						_com=(myStage.obj_vect[id_obj]);
					}
					myStage.objs[id_obj].com_test([_com,myStage.obj_pos[id_obj]]);
					/*if(myStage.objs[id_obj]["commands"].length>1){
						if(myStage.objs[id_obj]["pos_in_map"]!=(ba1[3]*256+ba1[4])-1){
							//trace(target["pos_in_map"]+"   "+((ba1[3]*256+ba1[4])-1));
							myStage.objs[id_obj]["new_pos"]=true;
						}
					}*/
				}
				tracePack(ba1,10,"move    ",3);
				ba1.splice(0,10);
				return;
<<<<<<< HEAD:client/work/fps test1/game/myStage.as
=======
			}else if(ba1[0]==43){
				timestep1=ba1[5]*256+ba1[6];
				myStage.panel["ammo0"].timeStep(timestep1);
				
				var a_type:uint=ba1[1]*256+ba1[2];
				var b_type:uint=0;
				
				if(a_type>100){
					b_type=a_type/100;
				}
				
				if(b_type!=0){
					myStage.ammo_time=ba1[3]*256+ba1[4];
					myStage.ammo_steps=timestep1;
					myStage.ammo_do=true;
				}else{
					myStage.ammo_do=false;
					myStage.ammo_time=0;
				}
				
				Bullet.last_efx=b_type;
				
				tracePack(ba1,9,"move    ",3);
				ba1.splice(0,9);
				return;
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/game/myStage.as
			}else if(ba1[0]<9){
				id_obj=ba1[5]*256+ba1[6];
				id_obj1=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				if(ba1[7]*256+ba1[8]>0){
					timestep1=ba1[7]*256+ba1[8];
					myStage.panel["ammo0"].timeStep(timestep1);
				}
				
				var a_type:uint=ba1[9]*256+ba1[10];
				//trace("Игрок #id "+id_obj+" выстрелил снарядом #id "+id_obj1+"   "+ba1);
				if(myStage.objs[id_obj]!=null){
					var b_type:uint=0;
					
					if(a_type%100>0){
						var _ar:Array=new Array();
						if(a_type<10000){
							_ar[1]=0;
						}else{
							_ar[1]=1;
							a_type-=10000;
						}
						if(a_type>100){
							b_type=a_type/100;
						}
						while(a_type>100){
							a_type-=100;
						}
						while(a_type>10){
							a_type-=10;
						}
						
						if(myStage.obj_obj[id_obj]==1&&a_type-2!=myStage.objs[id_obj]["fire_type"]){
							if(a_type==1){
								myStage.objs[id_obj]["fire_power"]=myStage.basic_dm;
								myStage.objs[id_obj]["fire_type"]=-1;
								if(myStage.objs[id_obj]["player"]){
									if(!myStage.f_shot){
										myStage.f_shot=true;
									}
									for(var q:int=0;q<6;q++){
										myStage.panel["ammo"+q]["quantity"]=0;
									}
									//myStage.fire_cd=myStage.f_cd;
									myStage.self.playSound("gun"+(Math.floor(Math.random()*3)+1),0);
									myStage.panel["ammo0"].resetAmmo();
								}
							}else{
								myStage.objs[id_obj]["fire_type"]=a_type-2;
								myStage.objs[id_obj]["fire_power"]=myStage.ammo_dm[myStage.objs[id_obj]["fire_type"]];
								if(myStage.objs[id_obj]["player"]){
									if(!myStage.f_shot){
										myStage.f_shot=true;
									}
									//myStage.fire_cd=myStage.ammo_sp[target["fire_type"]];
									myStage.self.playSound("gun"+(Math.floor(Math.random()*3)+1),0);
									myStage.panel["ammo0"].ch_ammo(myStage.objs[id_obj]["fire_type"]);
								}
							}
						}
						if(myStage.obj_obj[id_obj]==1){
							Tank.dofire(myStage.objs[id_obj],ba1[0]-4,ba1[3]*256+ba1[4],id_obj1,_ar,b_type);
						}else if(myStage.obj_obj[id_obj]==2){
							Turrel.dofire(myStage.objs[id_obj],ba1[0]-4,ba1[3]*256+ba1[4],id_obj1,_ar,b_type);
						}else if(myStage.obj_obj[id_obj]==5){
							bigTurr.dofire(myStage.objs[id_obj],ba1[0]-4,ba1[3]*256+ba1[4],id_obj1,_ar,b_type);
						}
						if(myStage.objs[id_obj]["player"]){
							if(!myStage.f_shot){
								myStage.f_shot=true;
							}
							if(myStage.objs[id_obj]["fire_type"]>-1){
								myStage.panel["ammo"+myStage.objs[id_obj]["fire_type"]]["quantity"]--;
								if(myStage.panel["ammo"+myStage.objs[id_obj]["fire_type"]]["quantity"]<10000){
									myStage.panel["ammo_tx"+myStage.objs[id_obj]["fire_type"]].text=myStage.panel["ammo"+myStage.objs[id_obj]["fire_type"]]["quantity"]+"";
								}else{
									myStage.panel["ammo_tx"+myStage.objs[id_obj]["fire_type"]].text="xxxx";
								}
							}
							//myStage.panel["ammo0"].resetAmmo();
						}
					}
				}
				tracePack(ba1,11,"fire    ",3);
				ba1.splice(0,11);
				return;
			}else if(ba1[0]==9){
				id_obj=ba1[5]*256+ba1[6];
				id_obj1=ba1[1]*256+ba1[2];
				//trace("В игрока #"+id_obj+"попал снаряд #"+id_obj1);
				
					if(myStage.objs[id_obj]!=null){
						if(myStage.obj_obj[id_obj]>0){
							myStage.objs[id_obj]["health"]=ba1[7]*256+ba1[8];
							if(myStage.objs[id_obj1]!=null){
								if(!myStage.objs[id_obj1]["not_expl"]){
									myStage.self.newEX(int(myStage.objs[id_obj1].x+4),int(myStage.objs[id_obj1].y+4),0,myStage.bm_count,0);
								}
								if(myStage.obj_obj[id_obj]==1){
									if(myStage.objs[id_obj]["player"]){
										myStage.explode=true;
									}
								}
							}
							myStage.objs[id_obj].healthTest();
							if(myStage.obj_obj[id_obj]==3){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetRadar(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==2){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetTurrel(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==4){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetOil(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==5){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetB_Turr(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==6){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetTesla(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==7){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetLaser(id_obj);
								}
							}
						}else if(myStage.obj_obj[id_obj]==0){
							if(myStage.objs[id_obj1]!=null){
								if(!myStage.objs[id_obj1]["not_expl"]){
									myStage.self.newEX(int(myStage.objs[id_obj1].x)+4,int(myStage.objs[id_obj1].y)+4,0,myStage.bm_count,0);
								}
							}else{
								myStage.self.newEX(int(myStage.objs[id_obj].x)+4,int(myStage.objs[id_obj].y)+4,0,myStage.bm_count,0);
							}
							try{
								myStage.objs[id_obj].removeEventListener(Event.ENTER_FRAME, myStage.objs[id_obj].render);
							}catch(er:Error){
								
							}
							myStage.bull.removeChild(myStage.objs[id_obj]);
							myStage.objs[id_obj]=null;
						}else{
							try{
								if(myStage.objs[id_obj1]!=null){
									if(!myStage.objs[id_obj1]["not_expl"]){
										myStage.self.newEX(int(myStage.objs[id_obj1].x)+4,int(myStage.objs[id_obj1].y)+4,0,myStage.bm_count,0);
									}
								}else{
									myStage.self.newEX(int(myStage.objs[id_obj].x)+5,int(myStage.objs[id_obj].y)+5,0,myStage.bm_count,0);
								}
								if(myStage.obj_obj[id_obj]==1){
									if(myStage.objs[id_obj]["player"]){
										myStage.explode=true;
									}
								}
							}catch(er:Error){}
							if(myStage.walls[myStage.obj_pos[id_obj]]<9){
								myStage.obj_heal[id_obj]=ba1[7]*256+ba1[8];
								myStage.walls[myStage.obj_pos[id_obj]]=(9-int(((myStage.obj_heal[id_obj]/myStage.obj_heal1[id_obj])*8)));
								if(myStage.obj_rand[id_obj]==0){
									myStage.walls[myStage.obj_pos[id_obj]]=int(myStage.walls[myStage.obj_pos[id_obj]]/2)*2;
								}else{
									myStage.walls[myStage.obj_pos[id_obj]]=int(myStage.walls[myStage.obj_pos[id_obj]]/2)*2-1;
								}
								if(myStage.walls[myStage.obj_pos[id_obj]]>8){
									myStage.walls[myStage.obj_pos[id_obj]]=8;
								}
								if(myStage.walls[myStage.obj_pos[id_obj]]<1){
									myStage.walls[myStage.obj_pos[id_obj]]=1;
								}
								if(myStage.obj_heal[id_obj]<=0){
									myStage.walls[myStage.obj_pos[id_obj]]=0;
								}
								myStage.wall.createOne(myStage.obj_pos[id_obj],myStage.walls[myStage.obj_pos[id_obj]]);
							}else if(myStage.walls[myStage.obj_pos[id_obj]]<19&&myStage.walls[myStage.obj_pos[id_obj]]>10){
								myStage.obj_heal[id_obj]=ba1[7]*256+ba1[8];
								myStage.walls[myStage.obj_pos[id_obj]]=(19-int(((myStage.obj_heal[id_obj]/myStage.obj_heal1[id_obj])*8)));
								if(myStage.obj_rand[id_obj]==0){
									myStage.walls[myStage.obj_pos[id_obj]]=int(myStage.walls[myStage.obj_pos[id_obj]]/2)*2;
								}else{
									myStage.walls[myStage.obj_pos[id_obj]]=int(myStage.walls[myStage.obj_pos[id_obj]]/2)*2-1;
								}
								if(myStage.walls[myStage.obj_pos[id_obj]]>18){
									myStage.walls[myStage.obj_pos[id_obj]]=18;
								}
								if(myStage.walls[myStage.obj_pos[id_obj]]<11){
									myStage.walls[myStage.obj_pos[id_obj]]=11;
								}
								if(myStage.obj_heal[id_obj]<=0){
									myStage.walls[myStage.obj_pos[id_obj]]=0;
								}
								myStage.wall.createOne(myStage.obj_pos[id_obj],myStage.walls[myStage.obj_pos[id_obj]]);
							}
						}
					}
					
				if(myStage.objs[id_obj1]!=null){
					try{
						myStage.objs[id_obj1].removeEventListener(Event.ENTER_FRAME, myStage.objs[id_obj1].render);
					}catch(er:Error){
						
					}
					myStage.bull.removeChild(myStage.objs[id_obj1]);
					myStage.objs[id_obj1]=null;
				}
				tracePack(ba1,9,"hit     ",3);
				ba1.splice(0,9);
				return;
			}else if(ba1[0]==20){
				id_obj=ba1[1]*256+ba1[2];
				//trace("Игрок #"+id_obj+"выходит");
				if(myStage.objs[id_obj]!=null){
					myStage.obj_pos[id_obj]=(ba1[3]*256+ba1[4])-1;
					try{
						if(myStage.obj_type[id_obj]<3){
							for(var j:int=0;j<3;j++){
								myStage.chat_cl["avas"]["ava"+myStage.m_nums[myStage.objs[id_obj]["_num1"]]]["l"+j].gotoAndStop(2);
							}
							myStage.chat_cl["avas"]["ava"+myStage.m_nums[myStage.objs[id_obj]["_num1"]]]["lenta_cl"].visible=true;
							myStage.chat_cl["avas"]["ava"+myStage.m_nums[myStage.objs[id_obj]["_num1"]]].setChildIndex(myStage.chat_cl["avas"]["ava"+myStage.m_nums[myStage.objs[id_obj]["_num1"]]]["lenta_cl"],myStage.chat_cl["avas"]["ava"+myStage.m_nums[myStage.objs[id_obj]["_num1"]]].numChildren-1);
						}
					}catch(er:Error){}
					//myStage.self.newEX(int(myStage.objs[id_obj].x-4),int(myStage.objs[id_obj].y-4),0,myStage.bm_count,1);
					var exp_cl:MovieClip=new myStage.expld1();
					exp_cl.x=myStage.objs[id_obj].x+myStage.objs[id_obj].width/2;
					exp_cl.y=myStage.objs[id_obj].y+myStage.objs[id_obj].height/2;
					myStage.expls.addChild(exp_cl);
					myStage.self.playSound("wall_break",0);
					myStage.explode=true;
					myStage.ground.createOne(int(myStage.objs[id_obj].x+1),int(myStage.objs[id_obj].y+1), Math.floor(Math.random()*3)+1);
					//myStage.ground.createOne(int(myStage.objs[id_obj].x+1)-18,int(myStage.objs[id_obj].y+1)-18,5);
					myStage.objs[id_obj].teslaOff();
					if(myStage.objs[id_obj]["player"]){
						Bullet.last_efx=0;
						myStage.m1_do=false;
						myStage.m3_do=false;
						/*if(myStage.lifes==0){
							myStage.self.warn_f(12,"");
						}*/
						myStage.lifes--;
						myStage.panel["ammo0"].drawLifes();
						myStage.pl_clip=null;
					}
					try{
						myStage.objs[id_obj].removeEventListener(Event.ENTER_FRAME, myStage.objs[id_obj].render);
					}catch(er:Error){
						
					}
					if(Tank.free_pos[myStage.objs[id_obj]["pos_in_map"]]==id_obj)Tank.free_pos[myStage.objs[id_obj]["pos_in_map"]]=0;
					if(Tank.free_pos[myStage.objs[id_obj]["last_pos"]]==id_obj)Tank.free_pos[myStage.objs[id_obj]["last_pos"]]=0;
					if(Tank.free_pos[myStage.objs[id_obj]["next_pos"]]==id_obj)Tank.free_pos[myStage.objs[id_obj]["next_pos"]]=0;
					myStage.cont.removeChild(myStage.objs[id_obj]["t_cl"]);
					myStage.ground.removeChild(myStage.objs[id_obj]["p_cl"]);
					myStage.wall.removeChild(myStage.objs[id_obj]);
					myStage.objs[id_obj].removeEventListener(Event.ENTER_FRAME, myStage.objs[id_obj].render);
					myStage.objs[id_obj]=null;
					myStage.obj_id[id_obj]=null;
					myStage.obj_vect[id_obj]=null;
					myStage.obj_heal[id_obj]=null;
					myStage.obj_heal1[id_obj]=null;
					myStage.obj_gun[id_obj]=null;
					myStage.obj_speed[id_obj]=null;
					myStage.obj_pos[id_obj]=null;
					myStage.obj_resp[id_obj]=null;
				}
				tracePack(ba1,9,"die     ",3);
				ba1.splice(0,9);
				return;
			}else if(ba1[0]==22){
				id_obj=ba1[1]*256+ba1[2];
				//trace("Игрок #"+id_obj+" респаун   "+ba1);
				var _vect:int=ba1[9];
				myStage.obj_id[id_obj]=(id_obj);
				myStage.obj_pos[id_obj]=(ba1[3]*256+ba1[4]-1);
				myStage.obj_vect[id_obj]=(_vect);
				myStage.obj_heal[id_obj]=(ba1[5]*256+ba1[6]);
				myStage.obj_heal1[id_obj]=(ba1[7]*256+ba1[8]);
				myStage.obj_gun[id_obj]=(ba1[10]-2);
				myStage.obj_resp[id_obj]=(ba1[11]);
				myStage.obj_num[id_obj]=int((_vect-9)/4);
				while(_vect>12){
					_vect-=4;
				}
				if(_vect<5){
					myStage.obj_type[id_obj]=(1);
				}else if(_vect<9){
					myStage.obj_type[id_obj]=(2);
				}else if(_vect<13){
					myStage.obj_type[id_obj]=(3);
				}
				myStage.obj_obj[id_obj]=(1);
				while(myStage.obj_vect[id_obj]>4)myStage.obj_vect[id_obj]-=4;
				myStage.ground.createOneTank(id_obj, myStage.obj_type[id_obj]);
				tracePack(ba1,12,"resp    ",3);
				ba1.splice(0,12);
				return;
			}else if(ba1[0]==18){
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				//trace("Игрок #"+id_obj+" ставит мину   "+ba1);
				if(id_obj==myStage.tank_id){
					//trace([18,0,0,0,0,ba1[5]]);
					myStage.panel["ammo0"].find_sl([18,0,0,0,0,ba1[5]]).q_iter();
				}
				if(ba1[5]==32){
					ba1[5]=10;
				}
				if(myStage.self_battle){
					if(id_obj!=myStage.tank_id){
						Ground.Mines[current]=10+(ba1[5]-6);
					}else{
						Ground.Mines[current]=20+(ba1[5]-6);
					}
				}else{
					if(ba1[6]>1&&ba1[6]<4){
						if(myStage.tank_type!=myStage.objs[id_obj]["_type"]){
							Ground.Mines[current]=10+(ba1[5]-6);
						}else{
							Ground.Mines[current]=20+(ba1[5]-6);
						}
					}else{
						if(id_obj!=myStage.tank_id){
							Ground.Mines[current]=10+(ba1[5]-6);
						}else{
							Ground.Mines[current]=20+(ba1[5]-6);
						}
					}
				}
				if(myStage.pl_clip!=null){
					if(id_obj==myStage.obj_id[myStage.pl_clip["_num"]]){
						myStage.ground.createMine(current%myStage.lWidth, current/myStage.lWidth, 1);
					}
				}
				tracePack(ba1,9,"mine    ",3);
				ba1.splice(0,9);
				return;
			}else if(ba1[0]==10){
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				//trace("Игрок #"+id_obj+" подорвался на мине   "+ba1);
				if(ba1[9]==102){
					if(myStage.obj_id[id_obj]!=null){
						if(myStage.objs[id_obj]["player"]){
							myStage.objs[id_obj]["correct"]=false;
							if(myStage.m1_do){
								try{
									myStage.self.channel.stop();
								}catch(er:Error){
									
								}
								myStage.m1_left=0;
								myStage.m1_do=false;
							}
						}
						if(myStage.objs[id_obj]["stoped"]){
							myStage.objs[id_obj]["stoped"]=false;
							myStage.self.b_and_w(myStage.objs[id_obj]);
						}
					}
					tracePack(ba1,11,"unfreeze",3);
					ba1.splice(0,11);
					return;
				}
				
				myStage.self.playSound("mine",0);
				if((ba1[10]-6)==3){
					//trace("z m");
					if(id_obj==myStage.tank_id){
						myStage.m1_time=ba1[7]*256+ba1[8];
						myStage.steps1=myStage.panel["leave_cl"].getStep();
						myStage.self.playSound("slow",0);
						myStage.self.tik();
						myStage.m1_do=true;
					}
					try{
						myStage.objs[id_obj].com_test([myStage.objs[id_obj]["rat"],current],1);
					}catch(er:Error){}
					myStage.objs[id_obj]["stoped"]=true;
					myStage.self.b_and_w(myStage.objs[id_obj],1);
				}/*else{
					timestep1=ba1[7]*256+ba1[8];
					myStage.panel["ammo0"].timeStep(timestep1);
				}*/
				Ground.Mines[current]=0;
				myStage.ground.createMine(current%myStage.lWidth, current/myStage.lWidth, 0);
				//tral
				if(myStage.obj_id[id_obj]!=null){
					myStage.objs[id_obj]["health"]=ba1[5]*256+ba1[6];
					myStage.self.newEX(int(current%myStage.lWidth)*24+myStage.board_x-4,int(current/myStage.lWidth)*24+myStage.board_y-4,0,myStage.bm_count,1);
					myStage.ground.createOne(int(current%myStage.lWidth)*24,int(current/myStage.lWidth)*24,Math.floor(Math.random()*3)+1);
					if(myStage.objs[id_obj]["player"]){
						myStage.explode=true;
						if(ba1[9]<101){
							var cd_cl:MovieClip=myStage.panel["ammo0"].find_sl1(253);
							if(cd_cl!=null){
								cd_cl.set_reg(ba1[9]);
							}
							var tral_cl:MovieClip=new myStage.tral();
							tral_cl.x=int(current%myStage.lWidth)*24+12;
							tral_cl.y=int(current/myStage.lWidth)*24+12;
							if(tral_cl.y<12){
								tral_cl.y=12;
							}
							myStage.ground.addChild(tral_cl);
						}
					}else{
						if(ba1[9]<101){
							var tral_cl:MovieClip=new myStage.tral();
							tral_cl.x=int(current%myStage.lWidth)*24+12;
							tral_cl.y=int(current/myStage.lWidth)*24+12;
							if(tral_cl.y<12){
								tral_cl.y=12;
							}
							myStage.ground.addChild(tral_cl);
						}
					}
					myStage.objs[id_obj].healthTest();
				}
				tracePack(ba1,11,"hit mine",3);
				ba1.splice(0,11);
				return;
			}else if(ba1[0]>23&&ba1[0]<31){
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				if(ba1[0]==24){
					if(myStage.objs[id_obj]!=null){
						myStage.objs[id_obj]["fire_power"]=myStage.basic_dm;
						myStage.objs[id_obj]["fire_type"]=-1;
						if(myStage.objs[id_obj]["player"]){
							if(!myStage.f_shot){
								myStage.f_shot=true;
							}
							for(var q:int=0;q<6;q++){
								myStage.panel["ammo"+q]["quantity"]=0;
							}
							//myStage.fire_cd=myStage.f_cd;
							myStage.self.playSound("gun"+(Math.floor(Math.random()*3)+1),0);
							myStage.panel["ammo0"].resetAmmo();
						}
					}
				}else{
					if(myStage.objs[id_obj]!=null){
						myStage.objs[id_obj]["fire_type"]=ba1[0]-25;
						myStage.objs[id_obj]["fire_power"]=myStage.ammo_dm[myStage.objs[id_obj]["fire_type"]];
						if(myStage.objs[id_obj]["player"]){
							if(!myStage.f_shot){
								myStage.f_shot=true;
							}
							//myStage.fire_cd=myStage.ammo_sp[target["fire_type"]];
							myStage.self.playSound("gun"+(Math.floor(Math.random()*3)+1),0);
							myStage.panel["ammo0"].ch_ammo(myStage.objs[id_obj]["fire_type"]);
						}
					}
				}
				tracePack(ba1,5,"new ammo",3);
				ba1.splice(0,5);
				return;
			}else if(ba1[0]==254){
				//trace("ошибка");
				//myStage.smokes=new Array(300);
				myStage.self.game_over=true;
				myStage.self.warn_f(5,"Команда 254");
				tracePack(ba1,20,"serv err",3);
				ba1.splice(0,20);
				return;
			}else if(ba1[0]==255){
				//trace("Всё");
				myStage.smokes=new Array(100);
				myStage.self.game_over=true;
				myStage.self.warn_er=true;
				//trace("1   "+myStage.self.game_over);
				//myStage.self.warn_f(6);
				//myStage.self.game_ov(a,b,c,d,e,f,g);
				
				myStage.self.getBattleOver();
				
				map_id=false;
				/*var ch_timer:Timer=new Timer(3000,1);
				ch_timer.addEventListener(TimerEvent.TIMER_COMPLETE, ch_old);
				ch_timer.start();*/
				//trace("2   "+myStage.self.game_over);
				//sendEvent(253,0);
				try{
					close();
				}catch(er:Error){
					
				}
				tracePack(ba1,20,"over    ",3);
				ba1.splice(0,20);
				return;
			}else if(ba1[0]==36){
				//trace("bon2   "+ba1);
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				if(ba1[6]==1){
					if(id_obj==myStage.tank_id){
						myStage.panel["ammo0"].find_sl([36,0,0,0,0,26]).q_iter(1);
					}
					try{
						myStage.ground.removeChild(myStage.bonuses[current]);
						myStage.bonuses[current]=null;
						myStage.bon_id[current]=null;
						myStage.bon_pos[current]=null;
						myStage.bon_time[current]=null;
						myStage.bon_type[current]=null;
						myStage.bon_pow[current]=null;
						myStage.bon_step[current]=null;
						myStage.bon_pict[current]=null;
						myStage.bon_c[current]=null;
					}catch(er:Error){
						
					}
				}else{
					if(id_obj==myStage.tank_id){
						if(ba1[5]==26){
							myStage.panel["ammo0"].find_sl([36,0,0,0,0,26]).q_iter();
							myStage.lifes++;
							myStage.panel["ammo0"].drawLifes();
						}else if(ba1[5]==25){
							myStage.panel["ammo0"].find_sl([36,0,0,0,0,25]).q_iter();
							//trace(myStage.fire_cd+"   "+myStage.f_cd+"   "+myStage.f_cd1);
							//trace(ba1);
							myStage.m2_time=ba1[7]*256+ba1[8];
							myStage.fire_cd=myStage.f_cd1;
							myStage.panel["ammo0"].m_begin(2);
						}else if(ba1[5]==31){
							myStage.panel["ammo0"].find_sl([36,0,0,0,0,31]).q_iter();
						}
					}
				}
				tracePack(ba1,9,"bon     ",3);
				ba1.splice(0,9);
				return;
			}else if(ba1[0]==12){
				//trace("rem   "+ba1);
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				if(myStage.objs[id_obj]!=null){
					var _hlth:uint=ba1[5]*256+ba1[6];
					if(myStage.objs[id_obj]["health"]!=_hlth){
						myStage.objs[id_obj]["health"]=_hlth;
						myStage.objs[id_obj].healthTest();
					}
					if(ba1[7]==0){
						if(myStage.objs[id_obj]["player"]){
							myStage.panel["ammo0"].find_sl([12]).q_iter();
							try{
								myStage.self["channel"].stop();
							}catch(er:Error){
								
							}
							myStage.m1_left=0;
							myStage.m1_do=false;
							//myStage.pl_clip.teslaOff();
						}
					}else{
						try{
							myStage.ground.removeChild(myStage.bonuses[current]);
							myStage.bonuses[current]=null;
							myStage.bon_id[current]=null;
							myStage.bon_pos[current]=null;
							myStage.bon_time[current]=null;
							myStage.bon_type[current]=null;
							myStage.bon_pow[current]=null;
							myStage.bon_step[current]=null;
							myStage.bon_pict[current]=null;
							myStage.bon_c[current]=null;
						}catch(er:Error){
							
						}
					}
				}
				tracePack(ba1,9,"remont  ",3);
				ba1.splice(0,9);
				return;
			}else if(ba1[0]==11){
				//trace("rem1   "+ba1);
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				if(myStage.objs[id_obj]!=null){
					var _hlth:uint=ba1[5]*256+ba1[6];
					if(ba1[7]==0){
						if(myStage.objs[id_obj]["player"]){
							myStage.panel["ammo0"].find_sl([11,0,0,0,0,0,0,0,ba1[9]]).q_iter();
						}
						if(ba1[9]==20){
							if(myStage.objs[id_obj]["health1"]<_hlth){
								myStage.objs[id_obj]["h_last"]=myStage.objs[id_obj]["health1"];
								myStage.objs[id_obj]["health1"]=_hlth;
							}
						}
					}else{
						try{
							myStage.ground.removeChild(myStage.bonuses[current]);
							myStage.bonuses[current]=null;
							myStage.bon_id[current]=null;
							myStage.bon_pos[current]=null;
							myStage.bon_time[current]=null;
							myStage.bon_type[current]=null;
							myStage.bon_pow[current]=null;
							myStage.bon_step[current]=null;
							myStage.bon_pict[current]=null;
							myStage.bon_c[current]=null;
						}catch(er:Error){
							
						}
					}
					myStage.objs[id_obj]["health"]=_hlth;
					myStage.objs[id_obj].healthTest();
				}
				tracePack(ba1,10,"remont1 ",3);
				ba1.splice(0,10);
				return;
			}else if(ba1[0]<18){
				//trace("bon1   "+ba1);
				//trace((myStage.self.stage.focus).name);
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				if(ba1[7]==1){
					if(ba1[0]==15){
						myStage.self.playSound("art",0);
						myStage.self.art_c=0;
						myStage.self.art_exp=true;
						myStage.self.setBlur(7,7);
					}else if(ba1[0]==14){
						if(myStage.objs[id_obj]!=null){
							myStage.objs[id_obj]["pow_count"]=0;
							myStage.objs[id_obj]["pow_time"]=ba1[5]*256+ba1[6];
							myStage.objs[id_obj]["pow_step"]=myStage.panel["leave_cl"].getStep();
							myStage.objs[id_obj]["f_armor"]=true;
							myStage.ground.setChildIndex(myStage.objs[id_obj]["p_cl"],myStage.ground.numChildren-1);
						}
					}
					try{
						myStage.ground.removeChild(myStage.bonuses[current]);
						myStage.bonuses[current]=null;
						myStage.bon_id[current]=null;
						myStage.bon_pos[current]=null;
						myStage.bon_time[current]=null;
						myStage.bon_type[current]=null;
						myStage.bon_pow[current]=null;
						myStage.bon_step[current]=null;
						myStage.bon_pict[current]=null;
						myStage.bon_c[current]=null;
					}catch(er:Error){
						
					}
				}else{
					if(ba1[0]==14){
						//trace(id_obj+"   "+myStage.tank_id);
						if(id_obj==myStage.tank_id){
							myStage.panel["ammo0"].find_sl([14]).q_iter();
						}
						if(myStage.objs[id_obj]!=null){
							myStage.objs[id_obj]["pow_count"]=0;
							myStage.objs[id_obj]["pow_time"]=ba1[5]*256+ba1[6];
							myStage.objs[id_obj]["pow_step"]=myStage.panel["leave_cl"].getStep();
							myStage.objs[id_obj]["f_armor"]=true;
							myStage.ground.setChildIndex(myStage.objs[id_obj]["p_cl"],myStage.ground.numChildren-1);
							//trace(target+"   "+myStage.m3_time+"   "+target["pow_step"]+"   "+target["f_armor"]);
						}
					}else if(ba1[0]==13){
						if(id_obj==myStage.tank_id){
							myStage.panel["ammo0"].find_sl([13]).q_iter();
							/*if(myStage.objs[id_obj]!=null){
								//ba1[5]*256+ba1[6] время цействия
							}*/
						}
					}else if(ba1[0]==15){
						if(id_obj==myStage.tank_id){
							myStage.panel["ammo0"].find_sl([15]).q_iter();
						}
						myStage.self.playSound("art",0);
						myStage.self.art_c=0;
						myStage.self.art_exp=true;
						myStage.self.setBlur(7,7);
					}else if(ba1[0]==16){
						if(id_obj==myStage.tank_id){
							myStage.panel["ammo0"].find_sl([16]).q_iter();
						}
						new Plane(((ba1[5]*256+ba1[6])-1),ba1[8]);
					}else if(ba1[0]==17){
						if(id_obj==myStage.tank_id){
							myStage.panel["ammo0"].find_sl([17]).q_iter();
						}
						myStage.self.Rocket(((ba1[5]*256+ba1[6])-1));
					}
				}
				tracePack(ba1,9,"bon1    ",3);
				ba1.splice(0,9);
				return;
			}else if(ba1[0]==37){
				//trace("bon_dmg   "+ba1);
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				if(myStage.objs[id_obj]!=null){
					if(myStage.obj_obj[id_obj]>0){
						myStage.objs[id_obj]["health"]=ba1[5]*256+ba1[6];
						if(myStage.obj_obj[id_obj]==1){
							//trace("bon_dmg1   "+ba1);
							if(ba1[7]==20){
								myStage.objs[id_obj]["health1"]=myStage.objs[id_obj]["h_last"];
							}
							myStage.objs[id_obj].healthTest();
						}else{
							myStage.objs[id_obj].healthTest();
							if(myStage.obj_obj[id_obj]==3){
								//trace("bon_dmg2   "+ba1);
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetRadar(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==2){
								//trace("bon_dmg3   "+ba1);
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetTurrel(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==4){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetOil(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==5){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetB_Turr(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==6){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetTesla(id_obj);
								}
							}else if(myStage.obj_obj[id_obj]==7){
								if(myStage.objs[id_obj]["health"]<=0){
									Wall.resetLaser(id_obj);
								}
							}
						}
					}else if(myStage.obj_obj[id_obj]<0){
							//trace("bon_dmg4   "+ba1);
							if(myStage.walls[myStage.obj_pos[id_obj]]<9){
								myStage.obj_heal[id_obj]=ba1[5]*256+ba1[6];
								myStage.walls[myStage.obj_pos[id_obj]]=(9-int(((myStage.obj_heal[id_obj]/myStage.obj_heal1[id_obj])*8)));
								if(myStage.obj_rand[id_obj]==0){
									myStage.walls[myStage.obj_pos[id_obj]]=int(myStage.walls[myStage.obj_pos[id_obj]]/2)*2;
								}else{
									myStage.walls[myStage.obj_pos[id_obj]]=int(myStage.walls[myStage.obj_pos[id_obj]]/2)*2-1;
								}
								if(myStage.walls[myStage.obj_pos[id_obj]]>8){
									myStage.walls[myStage.obj_pos[id_obj]]=8;
								}
								if(myStage.walls[myStage.obj_pos[id_obj]]<1){
									myStage.walls[myStage.obj_pos[id_obj]]=1;
								}
								if(myStage.obj_heal[id_obj]<=0){
									myStage.walls[myStage.obj_pos[id_obj]]=0;
								}
								myStage.wall.createOne(myStage.obj_pos[id_obj],myStage.walls[myStage.obj_pos[id_obj]]);
							}else if(myStage.walls[myStage.obj_pos[id_obj]]<19&&myStage.walls[myStage.obj_pos[id_obj]]>10){
								myStage.obj_heal[id_obj]=ba1[5]*256+ba1[6];
								myStage.walls[myStage.obj_pos[id_obj]]=(19-int(((myStage.obj_heal[id_obj]/myStage.obj_heal1[id_obj])*8)));
								if(myStage.obj_rand[id_obj]==0){
									myStage.walls[myStage.obj_pos[id_obj]]=int(myStage.walls[myStage.obj_pos[id_obj]]/2)*2;
								}else{
									myStage.walls[myStage.obj_pos[id_obj]]=int(myStage.walls[myStage.obj_pos[id_obj]]/2)*2-1;
								}
								if(myStage.walls[myStage.obj_pos[id_obj]]>18){
									myStage.walls[myStage.obj_pos[id_obj]]=18;
								}
								if(myStage.walls[myStage.obj_pos[id_obj]]<11){
									myStage.walls[myStage.obj_pos[id_obj]]=11;
								}
								if(myStage.obj_heal[id_obj]<=0){
									myStage.walls[myStage.obj_pos[id_obj]]=0;
								}
								myStage.wall.createOne(myStage.obj_pos[id_obj],myStage.walls[myStage.obj_pos[id_obj]]);
							}
					}
				}
				tracePack(ba1,10,"bon_dmg ",3);
				ba1.splice(0,10);
				return;
			}else if(ba1[0]==38){
				if(ba1.length<12){
					return;
				}
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				//trace("Объект #"+id_obj+" изменён "+ba1);
				if(myStage.objs[id_obj]!=null){
					if(myStage.obj_obj[id_obj]==1){
						myStage.self.newEX(int(myStage.objs[id_obj].x-4),int(myStage.objs[id_obj].y-4),0,myStage.bm_count,1);
						myStage.explode=true;
						myStage.ground.createOne(int(myStage.objs[id_obj].x+1)-myStage.board_x,int(myStage.objs[id_obj].y+1)-myStage.board_y,Math.floor(Math.random()*3)+1);
						if(myStage.objs[id_obj]["player"]){
							myStage.m1_do=false;
							myStage.pl_clip.teslaOff();
							/*if(myStage.lifes==0){
								myStage.self.warn_f(12,"");
							}*/
							myStage.lifes--;
							myStage.panel["ammo0"].drawLifes();
							myStage.pl_clip=null;
						}
						try{
							myStage.objs[id_obj].removeEventListener(Event.ENTER_FRAME, myStage.objs[id_obj].render);
						}catch(er:Error){
							
						}
						if(Tank.free_pos[myStage.objs[id_obj]["pos_in_map"]]==id_obj)Tank.free_pos[myStage.objs[id_obj]["pos_in_map"]]=0;
						if(Tank.free_pos[myStage.objs[id_obj]["last_pos"]]==id_obj)Tank.free_pos[myStage.objs[id_obj]["last_pos"]]=0;
						if(Tank.free_pos[myStage.objs[id_obj]["next_pos"]]==id_obj)Tank.free_pos[myStage.objs[id_obj]["next_pos"]]=0;
						myStage.cont.removeChild(myStage.objs[id_obj]["t_cl"]);
						myStage.ground.removeChild(myStage.objs[id_obj]["p_cl"]);
						myStage.wall.removeChild(myStage.objs[id_obj]);
						myStage.objs[id_obj].removeEventListener(Event.ENTER_FRAME, myStage.objs[id_obj].render);
						myStage.objs[id_obj]=null;
						myStage.obj_id[id_obj]=null;
						myStage.obj_vect[id_obj]=null;
						myStage.obj_heal[id_obj]=null;
						myStage.obj_heal1[id_obj]=null;
						myStage.obj_gun[id_obj]=null;
						myStage.obj_speed[id_obj]=null;
						myStage.obj_pos[id_obj]=null;
						myStage.obj_resp[id_obj]=null;
					}else if(myStage.obj_obj[id_obj]==3){
						//trace("bon_dmg2   "+ba1);
						Wall.resetRadar(id_obj);
					}else if(myStage.obj_obj[id_obj]==2){
						//trace("bon_dmg3   "+ba1);
						Wall.resetTurrel(id_obj);
					}else if(myStage.obj_obj[id_obj]==4){
						Wall.resetOil(id_obj);
					}else if(myStage.obj_obj[id_obj]==5){
						Wall.resetB_Turr(id_obj);
					}else if(myStage.obj_obj[id_obj]==6){
						Wall.resetTesla(id_obj);
					}else if(myStage.obj_obj[id_obj]==7){
						Wall.resetLaser(id_obj);
					}else if(myStage.obj_obj[id_obj]<0){
						//trace("bon_dmg4   "+ba1);
						myStage.walls[myStage.obj_pos[id_obj]]=0;
						myStage.wall.createOne(myStage.obj_pos[id_obj],myStage.walls[myStage.obj_pos[id_obj]]);
					}
				}
				id_obj=ba1[5]*256+ba1[6];
				if(ba1[7]==41){
					myStage.obj_pos[id_obj]=(current);
					myStage.obj_id[id_obj]=(id_obj);
					myStage.obj_heal[id_obj]=(ba1[7+1]);
					myStage.obj_heal1[id_obj]=(ba1[7+3]);
					myStage.obj_gun[id_obj]=(ba1[7+4]-2);
					myStage.obj_R[id_obj]=(ba1[7+2]);
					myStage.obj_speed[id_obj]=(ba1[7+4]);
					myStage.obj_obj[id_obj]=2;
					myStage.wall.createTurr(id_obj);
				}else if(ba1[7]==48){
					myStage.obj_pos[id_obj]=(current);
					myStage.obj_id[id_obj]=(id_obj);
					myStage.obj_heal[id_obj]=(ba1[7+1]);
					myStage.obj_heal1[id_obj]=(100);
					myStage.obj_gun[id_obj]=(ba1[7+4]-2);
					myStage.obj_type[id_obj]=(ba1[7+2])-1;
					if(myStage.obj_type[id_obj]<=0){
						myStage.obj_type[id_obj]=3;
					}
					myStage.obj_speed[id_obj]=(ba1[7+4]);
					myStage.obj_obj[id_obj]=5;
					myStage.obj_R[id_obj]=25;
					myStage.wall.createB_Turr(id_obj);
				}else if(ba1[7]>19&&ba1[7]<22){
					myStage.objs[id_obj]=(ba1[7]);
					myStage.obj1[id_obj]=(ba1[7]);
					myStage.obj_pos[id_obj]=(current);
					myStage.obj_id[id_obj]=(id_obj);
					myStage.obj_heal[id_obj]=(ba1[7+1]);
					myStage.obj_heal1[id_obj]=(0);
					if(ba1[7]==20){
						myStage.walls[current]=(9+ba1[7+2]);
					}else if(ba1[7]==21){
						myStage.walls[current]=(19+ba1[7+2]);
					}
					myStage.obj_obj[id_obj]=-1;
					myStage.wall.createOne(current,myStage.walls[current]);
				}else if(ba1[7]>45&&ba1[7]<48){
					myStage.obj_pos[id_obj]=(current);
					myStage.obj_id[id_obj]=(id_obj);
					myStage.obj_heal[id_obj]=(ba1[7+1]);
					myStage.obj_heal1[id_obj]=100;
					myStage.obj_type[id_obj]=(ba1[7+2])-1;
					if(myStage.obj_type[id_obj]<=0){
						myStage.obj_type[id_obj]=3;
					}
					myStage.obj_obj[id_obj]=4;
					myStage.obj_rand[id_obj]=(ba1[7]-46);
					myStage.wall.createOil(id_obj);
				}else if(ba1[7]>27&&ba1[7]<31){
					myStage.obj_pos[id_obj]=(current);
					myStage.obj_id[id_obj]=(id_obj);
					myStage.obj_heal[id_obj]=(ba1[7+1]);
					myStage.obj_heal1[id_obj]=(ba1[7+2]);
					myStage.obj_type[id_obj]=(ba1[7]-28)+1;
					myStage.obj_obj[id_obj]=3;
					myStage.wall.createRadar(id_obj);
				}else if(ba1[7]>21&&ba1[7]<26){
					//22,30,0,30,0
					var frame:int=int((ba1[7+1]/ba1[7+3])*8);
					var rand:int=0;
					if(int(frame/2)*2==frame){
						rand=0;
					}else{
						rand=1;
					}
					myStage.objs[id_obj]=(ba1[7]);
					myStage.obj1[id_obj]=(ba1[7]);
					myStage.obj_pos[id_obj]=(current);
					myStage.obj_id[id_obj]=(id_obj);
					myStage.obj_heal[id_obj]=(ba1[7+1]);
					myStage.obj_heal1[id_obj]=(ba1[7+3]);
					myStage.obj_rand[id_obj]=(rand);
					
					r=(9-frame);
					if(ba1[7+2]==0){
						if(r<9){
							myStage.walls[current]=r;
						}else{
							myStage.walls[current]=8;
						}
					}else{
						if(r<9){
							myStage.walls[current]=r+10;
						}else{
							myStage.walls[current]=18;
						}
					}
					myStage.obj_obj[id_obj]=-2;
					myStage.wall.createOne(current,myStage.walls[current]);
				}else if(ba1[7]>0&&ba1[7]<13){
					myStage.obj_vect[id_obj]=(ba1[7]);
					myStage.obj_pos[id_obj]=(current);
					myStage.obj_id[id_obj]=(id_obj);
					myStage.obj_heal[id_obj]=(ba1[7+1]);
					myStage.obj_heal1[id_obj]=(ba1[7+3]);
					myStage.obj_speed[id_obj]=ba1[7+2];
					myStage.obj_gun[id_obj]=ba1[7+4]-2;
					myStage.obj_resp[id_obj]=(2);
					myStage.obj_num[id_obj]=int((ba1[7]-9)/4);
					while(ba1[7]>12)ba1[7]-=4;
					if(ba1[7]<5){
						myStage.obj_type[id_obj]=(1);
					}else if(ba1[7]<9){
						myStage.obj_type[id_obj]=(2);
					}else{
						myStage.obj_type[id_obj]=(3);
					}
					myStage.obj_obj[id_obj]=(1);
					while(myStage.obj_vect[id_obj]>4)myStage.obj_vect[id_obj]-=4;
					myStage.ground.createOneTank(id_obj, myStage.obj_type[id_obj]);
				}
				tracePack(ba1,12,"change  ",3);
				ba1.splice(0,12);
				return;
			}else if(ba1[0]==39){
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				timestep1=ba1[7]*256+ba1[8];
				myStage.panel["ammo0"].timeStep(timestep1);
				//trace("Игрок #"+id_obj+" стелс   "+ba1);
				if(myStage.objs[id_obj]!=null){
					if(ba1[5]*256+ba1[6]>0){
						myStage.objs[id_obj]["stels"]=1;
						if(myStage.objs[id_obj]["player"]){
							myStage.panel["ammo0"].find_sl([39]).q_iter();
							myStage.objs[id_obj].alpha=.2;
							myStage.objs[id_obj]["pow_fr"]=0;
							myStage.objs[id_obj]["stels"]=2;
							myStage.objs[id_obj]["pow_count"]=0;
							myStage.objs[id_obj]["pow_time"]=ba1[5]*256+ba1[6];
							myStage.objs[id_obj]["pow_step"]=myStage.panel["leave_cl"].getStep();
							myStage.objs[id_obj]["f_armor"]=true;
							myStage.ground.setChildIndex(myStage.objs[id_obj]["p_cl"],myStage.ground.numChildren-1);
						}else{
							//trace(myStage.tank_type+"   "+myStage.objs[id_obj]["_type"]+"   "+myStage.objs[id_obj]["ebot"]);
							if(!myStage.self_battle&&(myStage.tank_type==myStage.objs[id_obj]["_type"]&&!myStage.objs[id_obj]["ebot"])){
								myStage.objs[id_obj]["stels"]=2;
								myStage.objs[id_obj].alpha=.2;
								myStage.objs[id_obj]["pow_fr"]=0;
								myStage.objs[id_obj]["pow_count"]=0;
								myStage.objs[id_obj]["pow_time"]=ba1[5]*256+ba1[6];
								myStage.objs[id_obj]["pow_step"]=myStage.panel["leave_cl"].getStep();
								myStage.objs[id_obj]["f_armor"]=true;
								myStage.ground.setChildIndex(myStage.objs[id_obj]["p_cl"],myStage.ground.numChildren-1);
							}else{
								myStage.objs[id_obj]["t_cl"].visible=false;
								myStage.objs[id_obj].visible=false;
							}
						}
					}else{
						myStage.objs[id_obj]["stels"]=0;
						myStage.objs[id_obj].alpha=1;
						myStage.objs[id_obj]["t_cl"].visible=true;
						myStage.objs[id_obj].visible=true;
						myStage.objs[id_obj]["p_cl"].graphics.clear();
						myStage.objs[id_obj]["f_armor"]=false;
					}
					myStage.self.newHide(myStage.objs[id_obj].x,myStage.objs[id_obj].y,0,myStage.stels_c);
				}
				tracePack(ba1,9,"stels   ",3);
				ba1.splice(0,9);
				return;
			}else if(ba1[0]==40){
				//trace("tesla "+ba1+" "+myStage.tank_id);
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				if(myStage.objs[id_obj]!=null){
					myStage.objs[id_obj]["pow_count"]=0;
					myStage.objs[id_obj]["pow_time"]=ba1[5]*256+ba1[6];
					myStage.objs[id_obj]["pow_step"]=myStage.panel["leave_cl"].getStep();
					myStage.objs[id_obj]["f_armor"]=true;
					if(myStage.objs[id_obj]["pow_time"]>0){
						myStage.self.playSound("mine",0);
						myStage.self.newEX(int(current%myStage.lWidth)*24+myStage.board_x-4,int(current/myStage.lWidth)*24+myStage.board_y-4,0,myStage.bm_count,1);
						myStage.ground.createOne(int(current%myStage.lWidth)*24,int(current/myStage.lWidth)*24,Math.floor(Math.random()*3)+1);
						
						myStage.ground.setChildIndex(myStage.objs[id_obj]["p_cl"],myStage.ground.numChildren-1);
						myStage.objs[id_obj].teslaOn(ba1[7],current, myStage.objs[id_obj]["pow_time"]);
						myStage.self.b_and_w(myStage.objs[id_obj],1);
						
						if(id_obj==myStage.tank_id){
							myStage.panel["ammo0"].find_sl([40]).q_iter();
							myStage.m3_do=true;
						}
					}else{
						myStage.self.b_and_w(myStage.objs[id_obj]);
						myStage.objs[id_obj].teslaOff();
						if(id_obj==myStage.tank_id){
							myStage.m3_do=false;
						}
					}
				}
				tracePack(ba1,9,"tesla   ",3);
				ba1.splice(0,9);
				return;
			}else if(ba1[0]==41){
				//trace("emi "+ba1+" "+myStage.tank_id);
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				var _xc:int=int(current%myStage.lWidth)*24+12+4;
				var _yc:int=int(current/myStage.lWidth)*24+12+4;
				myStage.self.playSound("emi",0);
				if(ba1[5]!=0){
					new Impuls(_xc,_yc,myStage.cont,myStage.self,ba1[5]);
					if(id_obj==myStage.tank_id){
						myStage.panel["ammo0"].find_sl([41]).q_iter();
					}
				}else if(myStage.objs[id_obj]!=null&&id_obj==myStage.tank_id){
					var cd_ar:Array=new Array();
					cd_ar[0]=[11,0,0,0,0,0,0,0,16];
					cd_ar[1]=[11,0,0,0,0,0,0,0,17];
					cd_ar[2]=[11,0,0,0,0,0,0,0,18];
					cd_ar[3]=[11,0,0,0,0,0,0,0,19];
					cd_ar[4]=[11,0,0,0,0,0,0,0,20];
					
					for(var q:int=0;q<cd_ar.length;q++){
						var cd_cl:MovieClip=myStage.panel["ammo0"].find_sl(cd_ar[q]);
						//myStage.panel["ammo0"].find_sl([18,0,0,0,0,ba1[5]]).q_iter();
						if(cd_cl!=null){
							cd_cl.one_cd();
						}
					}
					myStage.panel["ammo0"].find_sl([36,0,0,0,0,25]).begin_cd();
				}
				tracePack(ba1,9,"emi     ",3);
				ba1.splice(0,9);
				return;
<<<<<<< HEAD:client/work/fps test1/game/myStage.as
=======
			}else if(ba1[0]==42){
				
				var _spec__id:uint=ba1[1]*16777216+ba1[2]*65536+ba1[3]*256+ba1[4];
				myStage.panel["ammo0"].find_sl2(_spec__id).q_iter();
				
				tracePack(ba1,5,"spec    ",3);
				ba1.splice(0,5);
				return;
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/game/myStage.as
			}else if(ba1[0]>30){
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				if(ba1[0]==31){
					myStage.ground.createBonus(current, 1);
				}else if(ba1[0]==32){
					myStage.ground.createBonus(current, 3);
				}else if(ba1[0]==33){
					myStage.ground.createBonus(current, 0);
				}else if(ba1[0]==34){
					myStage.ground.createBonus(current, 6);
				}else if(ba1[0]==35){
					myStage.ground.createBonus(current, 4);
				}
				myStage.bon_id[current]=(id_obj);
				myStage.bon_time[current]=(ba1[5]);
				myStage.bon_pow[current]=(ba1[6]);
				myStage.bon_step[current]=(myStage.panel["leave_cl"].getStep()+ba1[5]);
				//trace(myStage.panel["leave_cl"].getStep()+"   "+ba1[5]);
				tracePack(ba1,9,"new bon ",3);
				ba1.splice(0,9);
				return;
			}else if(ba1[0]==19){
				//trace("flag event   "+ba1);
				id_obj=ba1[1]*256+ba1[2];
				current=ba1[3]*256+ba1[4]-1;
				myStage.obj_pos[id_obj]=(current);
				myStage.obj_num[id_obj]=(ba1[6]);
				myStage.obj_type[id_obj]=(ba1[5]-30);
				myStage.ground.createOneFlag(id_obj);
				
				tracePack(ba1,9,"flag    ",3);
				ba1.splice(0,9);
				return;
			}else{
				/*var str_0:String="?????";
				if(!loading){
					for(var i:int=0;i<ba1.length;i++){
						////trace(ba1[i]);
						str_0+=" "+ba1[i];
					}
				}
				trace(str_0);*/
				tracePack(ba1,ba1.length,"err pack",3);
				try{
					if(myStage.self["warn_er"]){
						myStage.self.warn_f(5,"Внимание!\nНеизвестный пакет данных...");
					}
				}catch(er:Error){
					myStage.self.warn_f(5,"Внимание!\nНеизвестный пакет данных...");
				}
				var err:String="http://tanks.xlab.su/admin/log.php?"+"event=0001"+"&"+"game_over="+myStage.self.game_over+"&"+"bytesAvailable="+bytesAvailable+"&"+"step="+myStage.steps+"&"+"connected="+connected+"&"+"ba1_length="+ba1.length+"&"+"buff1_length="+buff1.length+"&"+"metka1=["+myStage.map_id[0]+"]["+myStage.map_id[1]+"]["+myStage.map_id[2]+"]["+myStage.map_id[3]+"]";
				if(ba1.length>0){
					for(var mz:int=0;mz<ba1.length;mz++){
						if(mz>9){
							break;
						}
						err+="&ba1["+mz+"]="+ba1[mz];
					}
				}
				if(buff1.length>0){
					for(var mz:int=0;mz<buff1.length;mz++){
						if(mz>9){
							break;
						}
						err+="&buff1["+mz+"]="+buff1[mz];
					}
				}
				var rqs:URLRequest=new URLRequest(err);
				rqs.method=URLRequestMethod.GET;
				var loader:URLLoader=new URLLoader(rqs);
				//loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadHandler);
				loader.load(rqs);
				ba1.splice(0,ba1.length);
			}
		}
		
		public function getNames(){
			var xml_str:String="<query id=\"3\"><action id=\"5\"/></query>";
			var xml:XML=new XML(xml_str);
			var rqs:URLRequest=new URLRequest(myStage.scr_url+"?query="+3+"&action="+5);
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			/*try{
				myStage.self["send_tx"].text=xml_str;
			}catch(e:Error){}*/
			loader.addEventListener(Event.COMPLETE, setNames);
			var variables:URLVariables = new URLVariables();
			variables.query = xml;
			variables.send = "send";
			rqs.data = variables;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(rqs);
		}
		
		public function setNames(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("setNames str   "+str);
			try{
				var list:XML=new XML(str);
			}catch(er:Error){
				trace("errXml12   "+str);
				//myStage.self.warn_f(5,"Неверный формат полученных данных. \nУчастники боя.");
				myStage.self.erTestReq(3,5,str);
				return;
			}
			if(list.child("result").length()>0){
				list=list.child("result")[0];
			}else if(list.child("users").length()>0){
				list=list.child("users")[0];
			}
			//trace("setNames   "+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					myStage.self.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			var s1:String="user";
			var s2:String="bot";
			if(myStage.can_p2p){
				try{
					myStage.p2p_client.onConnect("testGroup");
				}catch(er:Error){
					myStage.prnt_cl.output(er+"\n",1);
				}
			}
			for(var i:int=0;i<list.child(s1).length();i++){
				/*if(myStage.can_p2p){
					try{
						if(int(list.child(s1)[i].attribute("id"))==myStage.tank_id){
							if(list.child(s1)[i].child("players").length()>0){
								for(var j:int=0;j<list.child(s1)[i].child("players")[0].child("player").length();j++){
									var _ar:Array=new Array();
									_ar[0]=[list.child(s1)[i].child("players")[0].child("player")[j].attribute("p2p_name")];
									_ar[1]=[list.child(s1)[i].child("players")[0].child("player")[j].attribute("p2p_id")];
									_ar[2]=[list.child(s1)[i].child("players")[0].child("player")[j].attribute("call")];
									myStage.p2p_ar[j]=_ar;
									if(_ar[2]=="true"){
										//myStage.p2p_client.onCall(_ar[0]);
										//myStage.p2p_client.simulateEvent(_ar[0],_ar[1]);
									}
								}
							}
						}
					}catch(er:Error){
						myStage.prnt_cl.output(er+"\n",1);
					}
				}*/
				if(myStage.m_idies.length>0){
					for(var j:int=0;j<myStage.m_names.length;j++){
						if(int(list.child(s1)[i].attribute("id"))==myStage.m_idies[j]){
							myStage.m_rangs[j]=(list.child(s1)[i].attribute("rang"));
							myStage.m_names[j]=(list.child(s1)[i].attribute("name"));
<<<<<<< HEAD:client/work/fps test1/game/myStage.as
=======
							myStage.m_idies[j]=(int(list.child(s1)[i].attribute("id")));
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/game/myStage.as
							myStage.m_skins[j]=list.child(s1)[i].attribute("skin_img");
							myStage.m_ava[j]=(myStage.res_url+"/"+list.child(s1)[i].attribute("ava"));
							break;
						}else if(j==myStage.m_idies.length-1){
							myStage.m_rangs.push(list.child(s1)[i].attribute("rang"));
							myStage.m_names.push(list.child(s1)[i].attribute("name"));
							myStage.m_idies.push(int(list.child(s1)[i].attribute("id")));
							myStage.m_skins.push(list.child(s1)[i].attribute("skin_img"));
							myStage.m_ava.push(myStage.res_url+"/"+list.child(s1)[i].attribute("ava"));
							break;
						}
					}
				}else{
					myStage.m_rangs.push(list.child(s1)[i].attribute("rang"));
					myStage.m_names.push(list.child(s1)[i].attribute("name"));
					myStage.m_idies.push(int(list.child(s1)[i].attribute("id")));
					myStage.m_skins.push(list.child(s1)[i].attribute("skin_img"));
					myStage.m_ava.push(myStage.res_url+"/"+list.child(s1)[i].attribute("ava"));
				}
			}
			//b_nums
			myStage.b_names=new Array();
			myStage.b_skins=new Array();
			for(var i:int=0;i<list.child("bots").child(s2).length();i++){
				myStage.b_names.push(list.child("bots").child(s2)[i].attribute("name"));
				myStage.b_skins.push(list.child("bots").child(s2)[i].attribute("skin_img"));
<<<<<<< HEAD:client/work/fps test1/game/myStage.as
=======
				myStage.m_idies.push(int(list.child("bots").child(s2)[i].attribute("id")));
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/game/myStage.as
			}
			
			//trace(myStage.m_names);
			//trace(myStage.m_idies);
			//trace(myStage.m_ava);
			/*if(myStage.tank_skin==0){
					setFrames(myStage.images[5]);
				}else{
					setFrames(myStage.images[mskin]);
				}*/
			namesTest();
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function namesTest(){
			var is_test:Boolean=false;
			for(var i:int=0;i<myStage.m_idies.length;i++){
				is_test=false;
				try{
					myStage.objs[myStage.m_idies[i]].setTankName(myStage.m_rangs[i]+" "+myStage.m_names[i],myStage.m_skins[i]);
					myStage.objs[myStage.m_idies[i]]["_num1"]=i;
				}catch(er:Error){}
				is_test=true;
			}
			var k:int=0;
			var k1:int=0;
			if(myStage.self_battle){
				for(var i:int=0;i<myStage.m_idies.length;i++){
					try{
						if(!myStage.objs[myStage.m_idies[i]]["player"]){
							avaTest(2,(9-k),i);
							k++;
						}else{
							avaTest(1,0,i);
						}
					}catch(er:Error){}
				}
			}else{
				if(myStage.tank_type==1){
					for(var i:int=0;i<myStage.m_idies.length;i++){
						try{
							if(myStage.obj_type[myStage.m_idies[i]]==1){
								avaTest(1,k1,i);
								k1++;
							}else if(myStage.obj_type[myStage.m_idies[i]]==2){
								avaTest(2,(9-k),i);
								k++;
							}
						}catch(er:Error){}
					}
				}else if(myStage.tank_type==2){
					for(var i:int=0;i<myStage.m_idies.length;i++){
						try{
							if(myStage.obj_type[myStage.m_idies[i]]==2){
								avaTest(1,k1,i);
								k1++;
							}else if(myStage.obj_type[myStage.m_idies[i]]==1){
								avaTest(2,(9-k),i);
								k++;
							}
						}catch(er:Error){}
					}
				}
			}
			//myStage.chat_cl["mainLayer"].visible=false;
			myStage.chat_cl.showAvas();
		}
		
		public function avaTest(a:int,b:int,c:int){
			if(a==1){
				color_cl.color=0x00ff00;
			}else{
				color_cl.color=0xff0000;
			}
			for(var j:int=0;j<2;j++){
				myStage.chat_cl["avas"]["ava"+b]["l"+j].gotoAndStop(1);
			}
			myStage.m_nums[c]=b;
			myStage.chat_cl["avas"]["ava"+b]["xp_bar"]["fill"].transform.colorTransform = color_cl;
			myStage.chat_cl["avas"]["ava"+b]["name_tx"].text=myStage.m_names[c];
			myStage.chat_cl["dscr"][b]=(myStage.m_rangs[c]+" "+myStage.m_names[c]);
			myStage.chat_cl["avas"]["ava"+b]["lenta_cl"].visible=false;
			myStage.chat_cl["avas"]["ava"+b]["xp_bar"]["fill"].width=52;
			myStage.chat_cl["avas"]["ava"+b].visible=true;
			LoadImage(myStage.m_ava[c],myStage.chat_cl["avas"]["ava"+b]);
		}
		
		public function LoadImage(ur:String,cl:MovieClip){
			var loader:Loader = new Loader();
			//trace(loader+"   "+loader.contentLoaderInfo);
			var mc:MovieClip=new pre1();
			mc.x=11;
			mc.y=37+23;
			mc.gotoAndPlay(int(Math.random()*15)+1);
			mc.name="pre_cl";
			cl.addChild(mc);
			cl.addChild(loader);
			myStage.chat_cl["pict"].push(loader);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openImage );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressImage);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeImage);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadImage);
			
			loader.load(new URLRequest(ur));
		}
		
		public function openImage(event:Event){
			
		}
		
		public function progressImage(event:ProgressEvent){
			
		}
		
		public function completeImage(event:Event){
			try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}
			event.currentTarget.content.x=0;
			event.currentTarget.content.y=23;
			//event.currentTarget.content.name="pict";
		}
		
		public function accessError(event:SecurityErrorEvent){
			
		}
		
		public function unLoadImage(event:IOErrorEvent){
			
		}
		
		public static var color_cl:ColorTransform=new ColorTransform();
		
		public function onError(event:IOErrorEvent):void{
			//trace("Game+php: "+event);
			myStage.self.warn_f(4,"К скрипту по завершении битвы\n"+event.text);
		}
		
    private function readResponse():void {
      try{
				if(myStage.lag_test==1){
					myStage.cont.removeChild(myStage.lag_tx);
				}
			}catch(er:Error){}
			myStage.lag_c=0;
			myStage.lag_test=0;
			//myStage.antilag=true;
			buff1=new ByteArray();
			readBytes(buff1,0,bytesAvailable);
			for(m=0;m<buff1.length;m++){
				ba1.push(buff1[m]);
			}
			parsePack();
    }
		
		public function parsePack(){
			if(ba1[0]==21){
				sinhro=true;
			}else{
				sinhro=false
			}
			if(sinhro){
				if(ba1.length<5){
					return;
				}else{
					mavailible=ba1[3]*256+ba1[4];
				}
				if(ba1.length<mavailible+7){
					return;
				}else{
					firstSynhro();
				}
			}else{
				while(ba1.length>8){
					if(ba1[0]==21){
						sinhro=true;
						//trace("ba1 empty");
						mavailible=ba1[3]*256+ba1[4];
						if(ba1.length<mavailible+7){
							return;
						}else{
							firstSynhro();
						}
						return;
					}
					/*var _c:Number=0;
					while(_c<1000000){
						_c+=1;
					}*/
					//trace("bytes   "+ba1);
					try{
						miniPackage();
<<<<<<< HEAD:client/work/fps test1/game/myStage.as
					}catch(er:Error){
						tracePack(ba1,ba1.length,"ERROR    ",3);
						ba1.splice(0,ba1.length);
					}
=======
					/*}catch(er:Error){
						tracePack(ba1,ba1.length,"ERROR    "+er,3);
						ba1.splice(0,ba1.length);
					}*/
>>>>>>> 30fae066c93055f97636bde84d43213d4b3def29:client/work/fps test1/game/myStage.as
					//trace("size "+ba1.length);
				}
			}
		}
		
    private function closeHandler(event:Event):void {
        //trace("Зарытие соединения: " + event);
				/*trace("game_over   "+myStage.self.game_over);
				trace("connected   "+connected);
				trace("currentTarget   "+event.currentTarget);
				trace("target   "+event.target);
				trace("bytesAvailable   "+bytesAvailable);*/
				if(!myStage.self.game_over){
					myStage.self.warn_f(2,"Socket close");
				}
				var err:String="http://tanks.xlab.su/admin/log.php?"+"event=Socket_close"+"&"+"game_over="+myStage.self.game_over+"&"+"bytesAvailable="+bytesAvailable+"&"+"step="+myStage.steps+"&"+"connected="+connected+"&"+"ba1_length="+ba1.length+"&"+"buff1_length="+buff1.length+"&"+"metka1=["+myStage.map_id[0]+"]["+myStage.map_id[1]+"]["+myStage.map_id[2]+"]["+myStage.map_id[3]+"]";
				if(ba1.length>0){
					for(var mz:int=0;mz<ba1.length;mz++){
						if(mz>9){
							break;
						}
						err+="&ba1["+mz+"]="+ba1[mz];
					}
				}
				if(buff1.length>0){
					for(var mz:int=0;mz<buff1.length;mz++){
						if(mz>9){
							break;
						}
						err+="&buff1["+mz+"]="+buff1[mz];
					}
				}
				trace(err);
				var rqs:URLRequest=new URLRequest(err);
				rqs.method=URLRequestMethod.GET;
				var loader:URLLoader=new URLLoader(rqs);
				//loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadHandler);
				loader.load(rqs);
    }
    private function connectHandler(event:Event):void {
        //trace("Подключение: ");
				//myStage.self["send_tx"].text=="Подключение: ";
        sendRequest();
    }
    private function ioErrorHandler(event:IOErrorEvent):void {
        //trace("Ошибка передачи данных: " + event);
				//myStage.smokes=new Array(300);
				//if(!myStage.self.game_over){
					type_er=1;
					myStage.self.warn_f(3,"При регулярном возникновении ошибки - попробуйте в настройках установить другой порт соединения либо порт по умолчанию.");
					var rqs:URLRequest=new URLRequest("http://tanks.xlab.su/admin/log.php?"+"event=Socket_IOError"+"&"+"game_over="+myStage.self.game_over+"&"+"bytesAvailable="+bytesAvailable+"&"+"step="+myStage.steps+"&"+"metka1=["+myStage.map_id[0]+"]["+myStage.map_id[1]+"]["+myStage.map_id[2]+"]["+myStage.map_id[3]+"]");
					rqs.method=URLRequestMethod.GET;
					var loader:URLLoader=new URLLoader(rqs);
					loader.load(rqs);
					try{
						close();
					}catch(er:Error){
						
					}
				//}
    }
    private function securityErrorHandler(event:SecurityErrorEvent):void {
        //trace("Ошибка допуска: " + event);
				//if(!myStage.self.game_over){
					if(type_er!=1){
						myStage.self.warn_f(3,"При регулярном возникновении ошибки - попробуйте в настройках установить другой порт соединения либо порт по умолчанию.");
						type_er=2;
					}
					var rqs:URLRequest=new URLRequest("http://tanks.xlab.su/admin/log.php?"+"event=Socket_Secure"+"&"+"game_over="+myStage.self.game_over+"&"+"bytesAvailable="+bytesAvailable+"&"+"step="+myStage.steps+"&"+"metka1=["+myStage.map_id[0]+"]["+myStage.map_id[1]+"]["+myStage.map_id[2]+"]["+myStage.map_id[3]+"]");
					rqs.method=URLRequestMethod.GET;
					var loader:URLLoader=new URLLoader(rqs);
					loader.load(rqs);
					try{
						close();
					}catch(er:Error){
						
					}
				//}
    }
    private function socketDataHandler(event:ProgressEvent):void {
        ////trace("Получение данных: " + event);
				//myStage.self["catch_tx"].text="Получение данных";
        readResponse();
    }
}




















