package{
	
	//import flash.media.*;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.Timer;
  import flash.net.*;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.*;
	import flash.xml.*;
	import flash.geom.ColorTransform;
	
	//[SWF(width="800", height="600", frameRate="40")]
	public class WinButton extends MovieClip{
		
		public static var stg_cl:MovieClip;
		public static var stg_class:Class;
		
		public static var m_init:Boolean=false;
		public static var reset:Boolean=false;
		public static var new_inf:Boolean=false;
		public static var serv_url:String="";
		public static var wait_info:String="Вы будете перенесены в бой, как только\nнаберётся нужное число игроков!";
		public static var i_info:String="Помощь временно не работает.\nВы можете получить подсказку,\nнаведя курсор на одну из\nиконок с восклицательным знаком.";
		public var w_roll:Boolean=false;
		public var id:int=-1;
		public var i_text:String="";
		//public var self_battle:Boolean=false;
		
		public static var news_cl:MovieClip=new MovieClip();
		public static var news_loader:Loader = new Loader();
		
		public function iInit(url:String){
			i_info=url;
		}
		
		public static var w_time:int=0;
		public static var m_time:int=0;
		public static var id_map:int=-1;
		
		public static var mTimer:Timer;
		public static var sTimer:Timer;
		public static var cTimer:Timer;
		public static var arTimer:Timer;
		
		public static var sh_news:Boolean=false;
		public static var nws_t:int=0;
		
		public function urlInit(url:String,cl:MovieClip){
			serv_url=url;
			stg_cl=cl;
			stg_class=stg_cl.getClass(stg_cl);
			//trace(stg_cl+"   "+stg_cl);
			//trace((stg_class.res_url+"/res/1nayrndff.swf")+"   init");
			root["info_win"]["kontr_pr"].visible=false;
			LoadNews((stg_class.res_url+"/res/1nayrndff.swf"+stg_cl["link_ver"]),root["info_win"]);
		}
		
		public function showNews(){
			//trace((stg_class.res_url+"/res/1nayrndff.swf")+"   "+sh_news);
			if(!sh_news){
				root["info_win"].addChild(news_cl);
				sh_news=true;
			}else{
				LoadNews((stg_class.res_url+"/res/1nayrndff.swf"+stg_cl["link_ver"]),root["info_win"]);
			}
		}
		
		public function hideNews(){
			try{
				//news_cl.removeChild(news_loader);
				news_cl.removeChild(news_cl.getChildByName("news"));
			}catch(er:Error){
				//trace("1234567890 "+er);
			}
		}
		
		public function WinButton(){
			super();
			Security.allowDomain("*");
			stop();
			if(!m_init){
				//LoadMap();
				//if(this.parent["win_cl"]!=null)this.parent["win_cl"].visible=false;
				m_init=true;
			}
			/*if(name=="alone_cl"){
				this.gotoAndStop("empty");
			}*/
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
		}
		
		public function LoadNews(ur:String,cl:MovieClip){
			//hideNews();
			news_loader = new Loader();
			//trace(loader+"   "+loader.contentLoaderInfo);
			/*var mc:MovieClip=new pre1();
			mc.x=11;
			mc.y=37+23;
			mc.gotoAndPlay(int(Math.random()*15)+1);
			mc.name="pre_cl";
			cl.addChild(mc);*/
			//news_cl.addChild(news_loader);
			//cl.addChild(news_cl);
			news_loader.contentLoaderInfo.addEventListener(Event.OPEN, openNews );
			news_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressNews);
			news_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeNews);
			news_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, unLoadNews);
			news_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      news_loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadNews);
			
			news_loader.load(new URLRequest(ur));
		}
		
		public function openNews(event:Event){
			
		}
		
		public function progressNews(event:ProgressEvent){
			
		}
		
		public function completeNews(event:Event){
			/*try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}*/
			hideNews();
			event.currentTarget.content.x=0;
			event.currentTarget.content.y=0;
			var n_cl:MovieClip=new MovieClip();
			n_cl.addChild(event.currentTarget.content);
			n_cl.name="news";
			news_cl.addChild(n_cl);
			try{
				event.currentTarget.content["kntr_b"].addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent){
					if(stg_cl["drag_cl"]!=null){
						return;
					}
					root["info_win"]["kontr_pr"].visible=true;
					root["info_win"].setChildIndex(root["info_win"]["kontr_pr"],root["info_win"].numChildren-1);
				});
			}catch(er:Error){
				trace("Battle list error: "+er);
			}
			//event.currentTarget.content.name="pict";
		}
		
		public function accessError(event:SecurityErrorEvent){
			trace("Battle list error: "+event);
		}
		
		public function unLoadNews(event:IOErrorEvent){
			trace("Battle list error: "+event);
		}
		
		public function rollInit(){
			for(var i:int=1;i<9;i++){
				root["win_cl"]["b"+i].addEventListener(MouseEvent.ROLL_OVER, m_roll);
				//root["win_cl"]["b"+i].addEventListener(MouseEvent.ROLL_OUT, o_roll);
			}
		}
		
		/*public function o_roll(event:MouseEvent){
			event.currentTarget["w_roll"]=false;
		}*/
		
		public function m_roll(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//trace(event.buttonDown);
			if(!stg_class.help_on){
				if(event.buttonDown){
					if(event.currentTarget["press_cl"].visible){
						event.currentTarget["press_cl"].visible=false;
					}else{
						event.currentTarget["press_cl"].visible=true;
					}
					//event.currentTarget["w_roll"]=true;
				}
			}
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//trace(stg_cl["wall_win"]+"   "+stg_cl["warn_er"]+"   "+root["ready_cl"].visible);
			if(stg_cl["wall_win"]){
				return;
			}
			if(root["arena_cl"].visible&&parent.name!="arena_cl"&&name!="out_ar_wb"){
				return;
			}
			if(stg_class.help_on){
				if(name=="choise_cl"){
					if(stg_class.help_st!=7){
						return;
					}
				}else if(name=="shop_cl"){
					if(stg_class.help_st!=3){
						return;
					}
				}else if(name=="b8"){
					if(stg_class.help_st!=8){
						return;
					}
				}else if(name=="play_cl"){
					if(stg_class.help_st!=9){
						return;
					}
				}else{
					return;
				}
			}
			if(currentFrameLabel=="empty"/*||name=="comand_cl"*/){
				return;
			}
			if(!stg_cl["warn_er"]&&!root["ready_cl"].visible){
				
					Mouse.cursor=MouseCursor.BUTTON;
					if(name=="choise_cl"){
						if(root["win_cl"].visible||!root["wait_cl"].visible){
							gotoAndStop("over");
						}
					}else if(name=="shop_cl"){
						if(!root["wait_cl"].visible){
							gotoAndStop("over");
						}
					}else if(name=="search_b0"||name=="search_b1"){
						if(currentFrameLabel=="out"){
							return;
						}else{
							gotoAndStop("over");
						}
					}else if(name=="ch_info"){
						showInfo(this["i_text"]);
					}else if(name=="ch1_info"){
						showInfo(this["i_text"]);
					}else if(name=="ch2_info"){
						showInfo(this["i_text"]);
					}else if(name=="wt_info"){
						showInfo(wait_info);
						new_inf=true;
					}else if(name.slice(0,9)=="auto_info"){
						showInfo(this["i_text"]);
					}else if(name.slice(0,8)=="bat_info"){
						showInfo(this["i_text"]);
					}else if(name.slice(0,11)=="bat_gr_info"){
						showInfo(this["i_text"]);
					}else if(name.slice(0,8)=="arn_info"){
						showInfo(this["i_text"]);
					}else{
						if(!root["wait_cl"].visible){
							if(parent.name=="arena_cl"){
								if(root["arena_cl"]["out_ar_ww"].visible){
									return;
								}
							}
							gotoAndStop("over");
						}
					}
				
			}
		}
		
		public function showInfo(i_text:String){
			if(i_text==null||i_text=="")return;
			root["info_tx"].selectable=false;
			root["info_tx"].multiline=true;
			root["info_tx"].autoSize=TextFieldAutoSize.LEFT;
			root["info_tx"].wordWrap=false;
			root["info_tx"].textColor=0xF0DB7D;
			root["info_tx"].text=i_text;
			root["info_tx"].x=x+parent.x;
			root["info_tx"].y=y-root["info_tx"].height-height/2+parent.y;
			if(root["info_tx"].y<0){
				root["info_tx"].y=0;
				root["info_tx"].x=x+width+10;
			}
			if(root["info_tx"].x+root["info_tx"].width>756){
				root["info_tx"].x=756-root["info_tx"].width-15;
			}
			var info_w:int=root["info_tx"].width;
			var info_h:int=root["info_tx"].height;
			var info_rw:int=10;
			var info_rh:int=10;
			St_clip.self.graphics.lineStyle(1, 0x000000, 1, true);
			St_clip.self.graphics.beginFill(0x990700,1);
			St_clip.self.graphics.drawRoundRect(root["info_tx"].x-3, root["info_tx"].y, info_w+10, info_h+2, info_rw, info_rh);
			St_clip.stg_cl.setChildIndex(root["info_tx"],St_clip.stg_cl.numChildren-1);
			stg_cl.setChildIndex(St_clip.stg_cl,stg_cl.numChildren-1);
			root["info_tx"].visible=true;
		}
		
		public function hideInfo(){
			root["info_tx"].visible=false;
			St_clip.self.graphics.clear();
			Mouse.cursor=MouseCursor.AUTO;
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//if(!stg_cl["warn_er"]){
			if(currentFrameLabel=="empty"){
				Mouse.cursor=MouseCursor.AUTO;
				return;
			}
			if(name.slice(3,7)=="info"){
				hideInfo();
				new_inf=false;
			}/*else if(name=="info_cl"){
				hideInfo();
				Mouse.cursor=MouseCursor.AUTO;
				gotoAndStop("out");
			}*/else if(name=="ch_info"){
				hideInfo();
			}else if(name=="ch1_info"){
				hideInfo();
			}else if(name=="ch2_info"){
				hideInfo();
			}else if(name.slice(0,9)=="auto_info"){
				hideInfo();
			}else if(name.slice(0,8)=="bat_info"){
				hideInfo();
			}else if(name.slice(0,11)=="bat_gr_info"){
				hideInfo();
			}else if(name.slice(0,8)=="arn_info"){
				hideInfo();
			}else{
				Mouse.cursor=MouseCursor.AUTO;
				if(name=="search_b0"||name=="search_b1"){
					if(currentFrameLabel!="out"){
						gotoAndStop("press");
					}
					return;
				}
				gotoAndStop("out");
			}
			//}
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
			if(stg_class.m_mode!=1){
				return;
			}
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(stg_cl["wall_win"]){
				return;
			}
			if(root["arena_cl"].visible&&parent.name!="arena_cl"&&name!="out_ar_wb"){
				return;
			}
			if(stg_class.help_on){
				if(name=="choise_cl"){
					if(stg_class.help_st!=7){
						return;
					}
				}else if(name=="shop_cl"){
					if(stg_class.help_st!=3){
						return;
					}
				}else if(name=="b8"){
					if(stg_class.help_st!=8){
						return;
					}else{
						try{
							stg_cl.removeChild(stg_class.help_cl);
						}catch(er:Error){
							
						}
						stg_cl.initLesson(9);
					}
				}else if(name=="play_cl"){
					if(stg_class.help_st!=9){
						return;
					}
				}else{
					return;
				}
			}
			if(currentFrameLabel=="empty"/*||name=="comand_cl"*/){
				return;
			}
			if(!stg_cl["warn_er"]&&!root["ready_cl"].visible){
				if(name=="choise_cl"){
					if(!root["wait_cl"].visible){
						gotoAndStop("press");
					}
				}else if(name=="shop_cl"){
					if(!root["wait_cl"].visible){
						gotoAndStop("press");
					}
				}else if(name.slice(0,8)=="left_obm"){
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
				}else if(name=="left_f"){
					iter_clip=this;
					iter_fund=function(){
						parent["numf_tx"].text=int(parent["numf_tx"].text)-this["_step"];
						if(int(parent["numf_tx"].text)<0){
							parent["numf_tx"].text=0;
						}
						parent["numf1_tx"].text=int(parent["numf_tx"].text)/this["_step"];
					}
					start_iter();
				}else if(name=="right_f"){
					iter_clip=this;
					iter_fund=function(){
						parent["numf_tx"].text=int(parent["numf_tx"].text)+this["_step"];
						if(int(parent["numf_tx"].text)>stg_class.shop["exit"].getMoneys(this["_type"])){
							parent["numf_tx"].text=stg_class.shop["exit"].getMoneys(this["_type"]);
						}
						parent["numf1_tx"].text=int(parent["numf_tx"].text)/this["_step"];
					}
					start_iter();
				}else if(name.slice(0,5)=="left_"){
					var m_q:int=1;
					if(name.slice(5,10)=="m_m_"){
						m_q=10;
					}else if(name.slice(5,10)=="m_z_"){
						m_q=2;
					}else if(name.slice(5,10)=="fuel"){
						m_q=10;
					}
					iter_clip=this;
					iter_fund=function(){
						//trace((name.slice(5,10)+"_send"));
						if(int(parent[name.slice(5,10)+"_send"].text)-m_q>m_q){
							parent[name.slice(5,10)+"_send"].text=(int(parent[name.slice(5,10)+"_send"].text)-m_q)+"";
						}else{
							if(m_q<=int(parent[name.slice(5,10)+"_all"].text)){
								parent[name.slice(5,10)+"_send"].text=""+m_q;
							}else{
								parent[name.slice(5,10)+"_send"].text=parent[name.slice(5,10)+"_all"].text;
							}
						}
					}
					start_iter();
				}else if(name.slice(0,6)=="right_"){
					var m_q:int=1;
					if(name.slice(6,11)=="m_m_"){
						m_q=10;
					}else if(name.slice(6,11)=="m_z_"){
						m_q=2;
					}else if(name.slice(6,11)=="fuel"){
						m_q=10;
					}
					iter_clip=this;
					iter_fund=function(){
					//trace((name.slice(6,11)+"_send"));
						if(int(parent[name.slice(6,11)+"_send"].text)+m_q<=int(parent[name.slice(6,11)+"_all"].text)){
							parent[name.slice(6,11)+"_send"].text=(int(parent[name.slice(6,11)+"_send"].text)+m_q)+"";
						}else{
							parent[name.slice(6,11)+"_send"].text=parent[name.slice(6,11)+"_all"].text;
						}
					}
					start_iter();
				}else if(name=="info_cl"){
					stg_cl.createMode(10);
					//gotoAndStop("press");
				}else if(name.slice(0,4)=="page"){
					if(parent==root["polk_win"]["polk_rep"]){
						rep_c=int(name.slice(4,5));
						repPage();
					}else{
						mts_page=int(name.slice(4,5));
						polkOtchet();
					}
				}else if(name=="sc"){
					if(parent.parent==root["diff_win"]){
						stage.addEventListener(MouseEvent.MOUSE_MOVE, m_move);
						stage.addEventListener(MouseEvent.MOUSE_UP, m_Release);
					}else if(parent.parent==root["polk_win"]){
						stage.addEventListener(MouseEvent.MOUSE_MOVE, m_move1);
						stage.addEventListener(MouseEvent.MOUSE_UP, m_Release1);
					}
				}else if(name=="rect"){
					if(parent.parent==root["diff_win"]){
						m_scroll(0);
						stage.addEventListener(MouseEvent.MOUSE_MOVE, m_move);
						stage.addEventListener(MouseEvent.MOUSE_UP, m_Release);
					}else if(parent.parent==root["polk_win"]){
						m_scroll(1);
						stage.addEventListener(MouseEvent.MOUSE_MOVE, m_move1);
						stage.addEventListener(MouseEvent.MOUSE_UP, m_Release1);
					}
				}else if(name.slice(0,8)=="diff_vkl"){
					/*if(name=="diff_vkl1"){
						root["empt_cl"].gotoAndStop(5);
						root["empt_cl"].visible=true;
						return;
					}*/
					for(var i:int=0;i<3;i++){
						if(root["diff_win"]["diff_vkl"+i]!=this){
							root["diff_win"]["diff_vkl"+i].gotoAndStop("out");
						}else{
							root["diff_win"]["scroll_cl"]["sc"].y=root["diff_win"]["scroll_cl"]["rect"].y;
							di_cnt=0;
							di_type=i;
							drawDiff();
							root["diff_win"]["diff_vkl"+i].gotoAndStop("empty");
						}
					}
					return;
				}else{
					if(this["press_cl"]!=null){
						if(!this["press_cl"].visible){
							this["press_cl"].visible=true;
						}else{
							this["press_cl"].visible=false;
						}
						if(parent.parent==root["wait_cl"]){
							var acc:Boolean=false;
							if(!root["group_win"].visible){
								for(var i:int=1;i<9;i++){
									if(root["win_cl"]["b"+i]["id"]==this["id"]){
										root["win_cl"]["b"+i]["press_cl"].visible=this["press_cl"].visible;
										acc=true;
									}
								}
							}
							if(!acc){
								this["press_cl"].visible=false;   //up_opt_b011_u100
							}
						}else if(name.slice(0,8)=="up_opt_b"){
							//trace(name+"   "+name.slice(8,10)+"   "+name.slice(11,18));
							for(var i:int=1;i<5;i++){
								//trace("up_opt_b"+name.slice(8,10)+i+name.slice(11,18));
								if(root["polk_win"]["opt_win"]["up_opt_b"+name.slice(8,10)+i+name.slice(11,18)]!=this){
									root["polk_win"]["opt_win"]["up_opt_b"+name.slice(8,10)+i+name.slice(11,18)]["press_cl"].visible=false;
								}else{
									//root["polk_win"]["opt_win"]["up_opt_b"+name.slice(8,10)+i+name.slice(11,18)]["press_cl"].visible=true;
								}
							}
						}else if(name.slice(0,4)=="reid"){
							//trace(name+"   "+name.slice(8,10)+"   "+name.slice(11,18));
							for(var i:int=0;i<3;i++){
								//trace("up_opt_b"+name.slice(8,10)+i+name.slice(11,18));
								if(root["polk_win"]["reid_win"]["reid"+i]!=this){
									root["polk_win"]["reid_win"]["reid"+i]["press_cl"].visible=false;
								}else{
									//root["polk_win"]["reid_win"]["reid"+i]["press_cl"].visible=true;
								}
							}
						}
					}
					
						if(!root["wait_cl"].visible){
							if(parent.name=="arena_cl"){
								if(root["arena_cl"]["out_ar_ww"].visible){
									return;
								}
							}else if(name=="search_b0"||name=="search_b1"){
								return;
							}
							gotoAndStop("press");
						}
					
				}
			}
		}
		
		public function m_release(event:MouseEvent){
			if(stg_class.m_mode!=1){
				return;
			}
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(stg_cl["wall_win"]){
				return;
			}
			if(root["arena_cl"].visible&&parent.name!="arena_cl"&&name!="out_ar_wb"){
				return;
			}
			if(stg_class.help_on){
				if(name=="choise_cl"){
					if(stg_class.help_st!=7){
						return;
					}else{
						try{
							stg_cl.removeChild(stg_class.help_cl);
						}catch(er:Error){
							
						}
					}
				}else if(name=="shop_cl"){
					if(stg_class.help_st!=3){
						return;
					}else{
						try{
							stg_cl.removeChild(stg_class.help_cl);
						}catch(er:Error){
							
						}
					}
				}else if(name=="b8"){
					if(stg_class.help_st!=8){
						return;
					}
				}else if(name=="play_cl"){
					if(stg_class.help_st!=9){
						return;
					}else{
						try{
							stg_cl.removeChild(stg_class.help_cl);
						}catch(er:Error){
							
						}
					}
				}else{
					return;
				}
			}
			if(currentFrameLabel=="empty"/*||name=="comand_cl"*/){
				return;
			}
			//trace(name);
			if(!stg_cl["warn_er"]&&!root["ready_cl"].visible){
				if(name=="choise_cl"){
					if(!stg_class.panel["waiting_cl"].visible){
						if(root["group_win"].visible){
							if(ldid==stg_cl["v_id"]){
								sendRequest([["query"],["action"]],[["id"],["id"]],[["7"],["7"]]);
							}else{
								root["choise_cl"].call_f([530]);
							}
							return;
						}
						if(!root["wait_cl"].visible){
							root["wait_cl"].visible=false;
							//if(stg_cl["g_num"]!=0){
								sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["1"]]);
							/*}else{
								root["warn_cl"].visible=true;
							}*/
							////trace("press");
						}
					}else{
						root["empt_cl"].gotoAndStop(3);
						root["empt_cl"].visible=true;
					}
				}else if(name=="go_to_ars"){
					stg_class.vip_cl["exit_cl"].sendRequest(["query","action"],[["id"],["id","type"]],[["1"],["5"]]);
				}else if(name=="mod_cl"){
					root["polk_win"]["v_torg"].setChildIndex(root["polk_win"]["v_torg"]["help_cl"],root["polk_win"]["v_torg"].numChildren-1);
					root["polk_win"]["v_torg"]["help_cl"].visible=true;
				}else if(name=="up"){
					if(parent.parent==root["diff_win"]){
						root["diff_win"]["scroll_cl"]["sc"].y-=root["diff_win"]["scroll_cl"]["rect"].height/(di_id.length-13);
						m_scroll(0);
					}else if(parent.parent==root["polk_win"]){
						root["polk_win"]["scroll_cl"]["sc"].y-=root["polk_win"]["scroll_cl"]["rect"].height/6;
						sc_coor(1);
					}
				}else if(name=="down"){
					if(parent.parent==root["diff_win"]){
						root["diff_win"]["scroll_cl"]["sc"].y+=root["diff_win"]["scroll_cl"]["rect"].height/(di_id.length-13);
						m_scroll(0);
					}else if(parent.parent==root["polk_win"]){
						root["polk_win"]["scroll_cl"]["sc"].y+=root["polk_win"]["scroll_cl"]["rect"].height/6;
						sc_coor(1);
					}
				}else if(name=="arena_ch"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["1"]]);
				}else if(name=="close_ar"){
					if(root["arena_cl"]["out_ar_ww"].visible){
						return;
					}
					stopAr();
					root["arena_cl"].visible=false;
				}else if(name=="out_ar_wb"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["4"]]);
				}else if(name=="go_ar_b"){
					if(root["arena_cl"]["out_ar_ww"].visible){
						return;
					}
					sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["3"]]);
				}else if(name=="choise_gr"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["7"],["7"]]);
				}else if(name=="inst_out"){
					if(parent==root["polk_win"]["opt_win"]){
						sendPolkOpt();
					}else{
						parent.visible=false;
					}
				}else if(name=="ustav_b"){
					resetPolkWin();
					root["polk_win"]["ustav_cl"].visible=true;
				}else if(name=="mts_b"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["5"]]);
				}else if(name=="diff_ch"){
					if(root["group_win"].visible){
						//if(root["group_win"]["pr4"].visible){
							sendRequest([["query"],["action"]],[["id"],["id"]],[["7"],["8"]]);
						/*}else{
							root["empt_cl"].alpha=1;
							root["empt_cl"].gotoAndStop(2);
							root["empt_cl"].visible=true;
							try{
								mTimer.stop();
							}catch(e:Error){
							
							}
							t_count=0;
							mTimer=new Timer(40, 100);
							mTimer.addEventListener(TimerEvent.TIMER, waiting1);
							mTimer.addEventListener(TimerEvent.TIMER_COMPLETE, time_over1);
							mTimer.start();
						}*/
					}
				}else if(name.slice(0,2)=="go"){
					var id_str:String="<query id=\"7\"><action id=\"9\">";
					id_str+="<battle id=\""+event.currentTarget["id"]+"\" />";
					id_str+="</action></query>";
					sendCombats(id_str,true,0);
				}else if(name.slice(0,4)=="gr_c"){
					var id_str:String="<query id=\"7\"><action id=\"9\">";
					id_str+="<battle id=\""+this["id"]+"\" />";
					id_str+="</action></query>";
					sendCombats(id_str,true,0);
				}else if(name.slice(0,6)=="status"){
					sendRequest([["query"],["action"]],[["id"],["id","arena_id"]],[["8"],["3",id+""]]);
				}else if(name=="close_cl"){
					if(parent.name=="wait_cl"){
						sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["3"]]);
					}else if(parent.name=="a_re_win"){
						winStop(root["a_re_win"]);
					}else{
						if(currentFrameLabel=="press"){
							if(parent==root["polk_win"]["opt_win"]){
								sendPolkOpt();
							}else{
								this.parent.visible=false;
								root["empt_cl"].visible=false;
							}
						}
					}
				}else if(name=="close_cl1"){
					this.parent.visible=false;
					root["empt_cl"].visible=false;
				}else if(name=="play_cl"){
					if(stg_cl==null){
						stg_cl=root["win_cl"].parent.parent.parent as MovieClip;
					}
					////trace(stg_cl);
					var id_str:String="<query id=\"3\"><action id=\"2\">";
					var ready_pl:Boolean=false;
					if(stg_class.help_on){
						if(stg_class.help_st==9){
							for(var i:int=1;i<8;i++){
								//root["win_cl"]["b"+i].visible=false;
								root["win_cl"]["b"+i]["press_cl"].visible=false;
								//root["win_cl"]["b"+i]["id"]=-1;
							}
							if(root["win_cl"]["b"+8].visible){
								if(root["win_cl"]["b"+8]["press_cl"].visible){
									if(root["win_cl"]["b"+8]["id"]>-1){
										id_str+="<battle id=\""+root["win_cl"]["b"+8]["id"]+"\" />";
										ready_pl=true;
									}
								}
							}
						}
					}else{
						for(var i:int=1;i<9;i++){
							if(root["win_cl"]["b"+i].visible){
								if(root["win_cl"]["b"+i]["press_cl"].visible){
									if(root["win_cl"]["b"+i]["id"]>-1){
										id_str+="<battle id=\""+root["win_cl"]["b"+i]["id"]+"\" />";
										ready_pl=true;
									}
								}
							}
						}
					}
					id_str+="</action></query>";
					if(ready_pl){
						if(stg_class.help_on){
							if(stg_class.help_st==9){
								stg_class.chat_cl.last_bttl=id_str;
							}
						}
						sendCombats(id_str,true,1);
					}else{
						if(stg_class.help_on){
							stg_class.help_cl["empt_cl"].visible=true;
							return;
						}
						root["empt_cl"].alpha=1;
						root["empt_cl"].gotoAndStop(1);
						root["empt_cl"].visible=true;
						try{
							mTimer.stop();
						}catch(e:Error){
						
						}
						t_count=0;
						mTimer=new Timer(40, 100);
						mTimer.addEventListener(TimerEvent.TIMER, waiting1);
						mTimer.addEventListener(TimerEvent.TIMER_COMPLETE, time_over1);
						mTimer.start();
					}
				}else if(name=="shop_cl"||name=="shop_cl1"){
					//trace(name);
					if(!root["wait_cl"].visible){
						try{
							stg_cl.createMode(2);
						}catch(e:Error){
							//trace("Select combat error: "+e);
						}
					}
				}else if(name=="reset_cl"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["3"]]);
				}else if(name=="stat_cl"){
					if(!root["wait_cl"].visible){
						stg_class.stat_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id"]],[["2"],["4"]]);
					}
				}else if(name=="info_cl"){
					if(!root["wait_cl"].visible){
						hideInfo();
					}
				}else if(name=="friend_cl"){
					stg_class.prnt_cl.callFriends();
				}else if(name=="games_cl"){
					stg_cl.createMode(6);
				}else if(name=="link"){
					if(parent.parent==root["group_win"]){
						stg_cl.linkTo(new URLRequest(plkn[int(parent.name.slice(2,3))]));
					}else if(parent.parent==root["polk_win"]){
						stg_cl.linkTo(new URLRequest(polk_ar[int(parent.name.slice(2,4))+polk_sc*5][4]));
					}
				}else if(name=="look"){
					stg_cl["sv_wall"]=true;
					stg_class.stat_cl["ch1"].setNamePl(parent["name_tx"].text);
					if(parent.parent==root["group_win"]){
						stg_class.stat_cl["ch1"].lookSv(pids[int(parent.name.slice(2,3))]);
					}else if(parent.parent==root["polk_win"]){
						stg_class.stat_cl["ch1"].lookSv(polk_ar[int(parent.name.slice(2,4))+polk_sc*5][6]);
					}
				}else if(name=="del_user"){
					//sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["7"],["6",pids[int(parent.name.slice(2,3))]+""]]);
					root["choise_cl"].call_f([527,pids[int(parent.name.slice(2,3))],parent["rang_tx"].text+" "+parent["name_tx"].text]);
				}else if(name=="del_group_cl"){
					//sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["7"],["6",ldid+""]]);
					root["choise_cl"].call_f([528,ldid]);
				}else if(name=="exit_gr_cl"){
					//sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["7"],["6",stg_cl["v_id"]+""]]);
					root["choise_cl"].call_f([529,stg_cl["v_id"]]);
				}else if(name=="comand_cl"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["2"]]);
				}else if(name=="new_polk"){
					root["set_polk"]["vznos_cl"].visible=true;
				}else if(name=="no_polk"){
					root["set_polk"]["vznos_cl"].visible=false;
				}else if(name=="yes_polk"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["1"]]);
				}else if(name=="polk_ok"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["2"]]);
				}else if(name=="us_menu"){
					if(!root["polk_win"]["call_win"].visible){
						root["polk_win"]["set_rang"].visible=false;
						root["polk_win"]["reset_rang"].visible=false;
						polk_us_id=polk_ar[int(parent.name.slice(2,4))+polk_sc*5][6];
						root["polk_win"]["call_win"].x=root["polk_win"].mouseX-width+15;
						root["polk_win"]["call_win"].y=root["polk_win"].mouseY-15;
						if(root["polk_win"]["call_win"].y<0){
							root["polk_win"]["call_win"].y=0;
						}else if(root["polk_win"]["call_win"].y>root["polk_win"].width-root["polk_win"]["call_win"].width){
							root["polk_win"]["call_win"].y=root["polk_win"].width-root["polk_win"]["call_win"].width;
						}
						root["polk_win"]["call_win"]["name_tx"].text=parent["name_tx"].text;
						for(var i:int=0;i<4;i++){
							if(polk_ar[int(parent.name.slice(2,4))+polk_sc*5][9+i]==0){
								root["polk_win"]["call_win"]["call"+i].gotoAndStop("out");
							}else{
								root["polk_win"]["call_win"]["call"+i].gotoAndStop("empty");
							}
						}
						root["polk_win"]["call_win"].visible=true;
						root["polk_win"]["call_win"].addEventListener(MouseEvent.MOUSE_OUT, m_out1);
					}else{
						root["polk_win"]["call_win"].visible=false;
					}
				}else if(name=="polk_out_yes"){
					if(root["polk_win"]["reset_rang"]["_state"]==1){
						sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["9"],["4",stg_cl["v_id"]]]);
					}else if(root["polk_win"]["reset_rang"]["_state"]==2){
						sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["21"]]);
					}else if(root["polk_win"]["reset_rang"]["_state"]==0){
						sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["9"],["4",polk_us_id+""]]);
					}
				}else if(name=="polk_out_no"){
					root["polk_win"]["reset_rang"].visible=false;
				}else if(name=="call3"){
					for(var i:int=0;i<polk_ar.length;i++){
						if(polk_ar[i]==null)break;
						if(polk_ar[i][6]==polk_us_id){
							root["polk_win"]["reset_rang"]["name_tx"].text=polk_ar[i][1]+" "+polk_ar[i][0];
							for(var j:int=0;j<10;j++){
								if(root["polk_win"]["us"+(j)].ava_url==polk_ar[i][3]){
									//trace(root["polk_win"]["us"+(j)].ava_url+"   "+root["polk_win"]["us"+(j)].getChildByName("us_ava").contentLoaderInfo.content);
									root["polk_win"]["reset_rang"]["ava_cl"].graphics.clear();
									root["polk_win"]["reset_rang"]["ava_cl"].graphics.beginBitmapFill(root["polk_win"]["us"+(j)].getChildByName("us_ava").contentLoaderInfo.content.bitmapData);
									root["polk_win"]["reset_rang"]["ava_cl"].graphics.drawRect(0, 0, root["polk_win"]["us"+(j)].getChildByName("us_ava").contentLoaderInfo.content.width, root["polk_win"]["us"+(j)].getChildByName("us_ava").contentLoaderInfo.content.height);
								}
							}
						}
					}
					root["polk_win"]["reset_rang"]._state=0;
					root["polk_win"]["reset_rang"].visible=true;
					root["polk_win"]["reset_rang"]["mess_tx"].text="ИСКЛЮЧИТЬ ИЗ ПОЛКА?";
					root["polk_win"]["reset_rang"]["polk_out_yes"].visible=root["polk_win"]["reset_rang"]["polk_out_no"].visible=true;
					root["polk_win"]["reset_rang"]["to_rang"].visible=root["polk_win"]["reset_rang"]["inst_out"].visible=false;
					//sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["9"],["4",polk_us_id+""]]);
					root["polk_win"]["call_win"].visible=false;
				}else if(name=="call1"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["6"]]);
				}else if(name=="to_rang"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["6"]]);
				}else if(name=="ammo_list"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["8"]]);
				}else if(name.slice(0,4)=="rang"){
					//if(int(int(name.slice(4,7))/10)!=8){
						sendRequest([["query"],["action"]],[["id"],["id","user_id","polk_rang"]],[["9"],["7",polk_us_id+"",int(name.slice(4,7))+""]]);
					/*}else{
						sendRequest([["query"],["action"]],[["id"],["id","user_id","polk_rang"]],[["9"],["7",polk_us_id+"",80+""]]);
					}*/
				}else if(name=="call2"){
					sendRequest([["query"],["action"]],[["id"],["id","user_id","polk_rang"]],[["9"],["7",polk_us_id+"",0+""]]);
					root["polk_win"]["call_win"].visible=false;
				}else if(name=="call0"){
					sendRequest([["query"],["action"]],[["id"],["id","user_id","type_r"]],[["9"],["17",polk_us_id+"",0+""]]);
					root["polk_win"]["call_win"].visible=false;
				}else if(name=="create_reid"){
					var type_r:int=5;
					for(var i:int=0;i<3;i++){
						//trace(root["polk_win"]["reid_win"]["reid"+i]["press_cl"].visible+"   "+root["polk_win"]["reid_win"]["reid"+i]["r_type"]);
						if(root["polk_win"]["reid_win"]["reid"+i].visible&&root["polk_win"]["reid_win"]["reid"+i]["press_cl"].visible){
							type_r=int(root["polk_win"]["reid_win"]["reid"+i]["r_type"]);
						}
					}
					//trace(polk_us_id+"   "+type_r);
					sendRequest([["query"],["action"]],[["id"],["id","user_id","type_r"]],[["9"],["17",polk_us_id+"",type_r+""]]);
					root["polk_win"]["reid_win"].visible=false;
					root["polk_win"]["call_win"].visible=false;
				}else if(name=="mts_res_b"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["11"]]);
				}else if(name.slice(0,7)=="to_mts_"){
					var s_q:int=int(parent[name.slice(7,14)+"_send"].text);
					if(name.slice(7,14)=="m_m_"){
						sendRequest([["query"],["action"]],[["id"],["id","money_m","money_z","fuel","th_id","th_qntty"]],[["9"],["12",s_q+"",0+"",0+"",0+"",0+""]]);
					}else if(name.slice(7,14)=="m_z_"){
						sendRequest([["query"],["action"]],[["id"],["id","money_m","money_z","fuel","th_id","th_qntty"]],[["9"],["12",0+"",s_q+"",0+"",0+"",0+""]]);
					}else if(name.slice(7,14)=="fuel"){
						sendRequest([["query"],["action"]],[["id"],["id","money_m","money_z","fuel","th_id","th_qntty"]],[["9"],["12",0+"",0+"",s_q+"",0+"",0+""]]);
					}else{
						sendRequest([["query"],["action"]],[["id"],["id","money_m","money_z","fuel","th_id","th_qntty"]],[["9"],["12",0+"",0+"",0+"",this["self_id"]+"",s_q+""]]);
					}
				}else if(name=="polk_opt_b"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["13"]]);
				}else if(name=="otchet_b"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["15"]]);
				}else if(name=="reit_p_b"){
					stg_class.polk_st_cl["ch1"].sendRequest([["query"],["action"]],[["id"],["id","page","search_me"]],[["9"],["16",0+"",0+""]]);
				}else if(name=="gr_us_right"){
					gr_us_c++;
					in_group();
					return;
				}else if(name=="gr_us_left"){
					gr_us_c--;
					in_group();
					return;
				}else if(name=="cal_plan"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["18"]]);
				}else if(name=="rpt_b"){
					sendRequest([["query"],["action"]],[["id"],["id","type_r"]],[["9"],["19",0+""]]);
				}else if(name=="rep_look"){
					stg_cl["sv_wall"]=true;
					stg_class.stat_cl["ch1"].lookSv(this["_uid"]);
				}else if(name=="rep_link"){
					stg_cl.linkTo(new URLRequest(this["_uid"]));
				}else if(name=="znamja_b"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["20"]]);
				}else if(name=="delete_polk"){
					root["polk_win"]["reset_rang"]["name_tx"].text="";
					try{
						root["polk_win"]["reset_rang"]["ava_cl"].graphics.clear();
						root["polk_win"]["reset_rang"]["ava_cl"].graphics.beginBitmapFill(root["polk_win"]["reset_rang"]["ldr_ava"].content.bitmapData);
						root["polk_win"]["reset_rang"]["ava_cl"].graphics.drawRect(0, 0, root["polk_win"]["reset_rang"]["ldr_ava"].content.width, root["polk_win"]["reset_rang"]["ldr_ava"].content.height);
					}catch(er:Error){}
					root["polk_win"]["reset_rang"]._state=2;
					root["polk_win"]["reset_rang"].visible=true;
					root["polk_win"]["reset_rang"]["mess_tx"].text="РАСФОРМИРОВАТЬ?";
					root["polk_win"]["reset_rang"]["polk_out_yes"].visible=root["polk_win"]["reset_rang"]["polk_out_no"].visible=true;
					root["polk_win"]["reset_rang"]["to_rang"].visible=root["polk_win"]["reset_rang"]["inst_out"].visible=false;
					//sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["9"],["4",polk_us_id+""]]);
					root["polk_win"]["call_win"].visible=false;
				}else if(name=="leave_polk"){
					root["polk_win"]["reset_rang"]["name_tx"].text="";
					try{
						root["polk_win"]["reset_rang"]["ava_cl"].graphics.clear();
						root["polk_win"]["reset_rang"]["ava_cl"].graphics.beginBitmapFill(root["polk_win"]["reset_rang"]["ldr_ava"].content.bitmapData);
						root["polk_win"]["reset_rang"]["ava_cl"].graphics.drawRect(0, 0, root["polk_win"]["reset_rang"]["ldr_ava"].content.width, root["polk_win"]["reset_rang"]["ldr_ava"].content.height);
					}catch(er:Error){}
					root["polk_win"]["reset_rang"]._state=1;
					root["polk_win"]["reset_rang"].visible=true;
					root["polk_win"]["reset_rang"]["mess_tx"].text="ВЫЙТИ ИЗ ПОЛКА?";
					root["polk_win"]["reset_rang"]["polk_out_yes"].visible=root["polk_win"]["reset_rang"]["polk_out_no"].visible=true;
					root["polk_win"]["reset_rang"]["to_rang"].visible=root["polk_win"]["reset_rang"]["inst_out"].visible=false;
					//sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["9"],["4",polk_us_id+""]]);
					root["polk_win"]["call_win"].visible=false;
				}else if(name=="voentorg_b"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["1"],["20"]]);
				}else if(name=="info_buy"){
					sendRequest([["query"],["action"]],[["id"],["id","id_mod"]],[["1"],["21",this["ID"]+""]]);
				}else if(name=="remove_cl"){
					parent.parent.removeChild(parent as MovieClip);
				}else if(name=="yes_cl"){
					sendRequest(["query","action"],[["id"],["id","id_mod","val_type"]],[["1"],[22+"",parent["ID"]+"",parent["vals"]]]);
				}else if(name=="buy_znamja"){
					root["polk_win"]["znamja_win"]["zn_warn"].visible=false;
					root["polk_win"]["znamja_win"]["buy_zn_win"].visible=true;
				}else if(name=="zn_vikup"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["22"]]);
				}else if(name=="auto_show"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["8"]]);
				}else if(name.slice(0,8)=="auto_bat"){
					sendRequest(["query","action"],[["id"],["id","battle"]],[["3"],[9+"",this["ID"]+""]]);
				}else if(name.slice(0,8)=="out_auto"){
					sendRequest(["query","action"],[["id"],["id","battle"]],[["3"],[9+"",0+""]]);
				}else if(name=="alone_cl"){
					stg_class.kaskad["map_win"]["close_cl"].sendRequest(["query","action"],[["id"],["id"]],[["3"],["10"]]);
				}else if(name=="obmen_b"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["1"],["28"]]);
				}else if(name.slice(0,8)=="konv_val"){
					sendRequest(["query","action"],[["id"],["id","id_conv","qntty"]],[["1"],[31+"",this["ID"]+"",parent["num1_tx"+int(name.slice(8,10))].text]]);
				}else if(name=="konv_f"){
					sendRequest(["query","action"],[["id"],["id","qntty"]],[["1"],[30+"",parent["numf1_tx"].text]]);
				}else if(name=="search_b0"){
					if(currentFrameLabel!="out"){
						sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["8"]]);
					}
					return;
				}else if(name=="search_b1"){
					if(currentFrameLabel!="out"){
						sendRequest([["query"],["action"]],[["id"],["id"]],[["14"],["1"]]);
					}
					return;
				}else if(name=="srch_gr_b"){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["14"],["2"]]);
				}
				
				try{
					gotoAndStop("over");
				}catch(er:Error){}
			}
		}
		
		public static var polk_us_id:String="0";
		
		public function m_out1(event:MouseEvent){
			//trace(root.mouseX+"   "+root["player_cl"].x+"   "+root["player_cl"].width);
			//trace(root.mouseY+"   "+root["player_cl"].y+"   "+root["player_cl"].height);
			if(root["polk_win"].mouseX<=root["polk_win"]["call_win"].x||root["polk_win"].mouseX>=root["polk_win"]["call_win"].x+root["polk_win"]["call_win"].width){
				root["polk_win"]["call_win"].visible=false;
				root["polk_win"]["call_win"].removeEventListener(MouseEvent.MOUSE_OUT, m_out1);
			}
			if(root["polk_win"].mouseY<=root["polk_win"]["call_win"].y||root["polk_win"].mouseY>=root["polk_win"]["call_win"].y+root["polk_win"]["call_win"].height-5){
				root["polk_win"]["call_win"].visible=false;
				root["polk_win"]["call_win"].removeEventListener(MouseEvent.MOUSE_OUT, m_out1);
			}
		}
		
		public function m_Release(event:MouseEvent){
			stage.removeEventListener(MouseEvent.MOUSE_UP, m_Release);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, m_move);
		}
		
		public function m_Release1(event:MouseEvent){
			stage.removeEventListener(MouseEvent.MOUSE_UP, m_Release1);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, m_move1);
		}
		
		//public static var mY:int=0;
		//public static var scroll_sc:Boolean=false;
		
		public function m_move(event:MouseEvent){
				m_scroll(0);
		}
		
		public function m_move1(event:MouseEvent){
				m_scroll(1);
		}
		
		public function m_scroll(_i:int){
			//trace(root["diff_win"]["scroll_cl"]["rect"].mouseY);
			var _s:String="";
			if(_i==0){
				_s="diff_win";
			}else if(_i==1){
				_s="polk_win";
			}
			root[_s]["scroll_cl"]["sc"].y=root[_s]["scroll_cl"]["rect"].mouseY+root[_s]["scroll_cl"]["sc"].height/2;
			sc_coor(_i);
		}
		
		public function sc_coor(_i:int){
			var _s:String="";
			if(_i==0){
				_s="diff_win";
			}else if(_i==1){
				if(root["polk_win"]["set_rang"].visible){
					return;
				}else if(root["polk_win"]["call_win"].visible){
					return;
				}
				_s="polk_win";
			}
			if(root[_s]["scroll_cl"]["sc"].y<root[_s]["scroll_cl"]["rect"].y+1){
				root[_s]["scroll_cl"]["sc"].y=root[_s]["scroll_cl"]["rect"].y+1;
				di_cnt=0;
				polk_sc=int((di_cnt)/5);
				newDiff(_i);
				return;
			}else if(root[_s]["scroll_cl"]["sc"].y>root[_s]["scroll_cl"]["rect"].y+(root[_s]["scroll_cl"]["rect"].height-root[_s]["scroll_cl"]["sc"].height)-2){
				root[_s]["scroll_cl"]["sc"].y=root[_s]["scroll_cl"]["rect"].y+(root[_s]["scroll_cl"]["rect"].height-root[_s]["scroll_cl"]["sc"].height)-2;
				if(_i==0){
					di_cnt=di_id[di_type].length-13;
				}else if(_i==1){
					di_cnt=39;
				}
				polk_sc=int((di_cnt)/5);
				newDiff(_i);
				return;
			}
			if(_i==0){
				di_cnt=int(((root[_s]["scroll_cl"]["sc"].y-root[_s]["scroll_cl"]["rect"].y)/(root[_s]["scroll_cl"]["rect"].height-root[_s]["scroll_cl"]["sc"].height))*(di_id[di_type].length-13));
			}else if(_i==1){
				di_cnt=int(((root[_s]["scroll_cl"]["sc"].y-root[_s]["scroll_cl"]["rect"].y)/(root[_s]["scroll_cl"]["rect"].height-root[_s]["scroll_cl"]["sc"].height))*(39));
			}
			if(di_cnt>0)polk_sc=int((di_cnt)/5);
			//trace(polk_ar.length+"   "+polk_sc+"   "+di_cnt);
			newDiff(_i);
		}
		
		public function newDiff(_i:int){
			if(_i==0){
				drawDiff();
			}else if(_i==1){
				if(polk_sc>6){
					polk_sc=6;
				}
				polk_scroll();
			}
		}
		
		public static var di_cnt:int=0;
		public static var id_str_num:String="0";
		
		public function reCall(a:int):void{
			/*if(st_call==0){
				sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["6"]]);
				return;
			}*/
			//trace(st_call+"   "+a);
			if(a==1){
				if(st_call==1){
					try{
						mTimer.stop();
					}catch(e:Error){
					
					}
					stg_cl.createMode(1);
				}
			}
			if(st_call<-200){
				sendRequest([["query"],["action"]],[["id"],["id","type","type_alert"]],[["7"],["10",a+"",(-st_call)+""]]);
				st_call=0;
				stg_cl.warn_f(9,"");
			}else if(st_call<-29){
				sendRequest([["query"],["action"]],[["id"],["id","type","type_alert"]],[["7"],["10",a+"",(-st_call)+""]]);
				st_call=0;
				stg_cl.warn_f(9,"");
				stg_class.shop["exit"].sendRequest(["query","action"],[["id"],["id","prof","skills","things"]],[["2"],["1","0","0","0"]]);
			}else if(st_call<0){
				if(a==1){
					sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["7"],["6",id_str_num]]);
				}else{
					st_call=0;
					sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["6"]]);
				}
			}else if(st_call>10){
				if(a==1){
					sendRequest([["query"],["action"]],[["id"],["id","user_id"]],[["7"],["6",id_str_num]]);
				}else{
					st_call=0;
					sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["6"]]);
				}
			}else if(st_call<3){
				sendRequest([["query"],["action"]],[["id"],["id","type"]],[["7"],[(st_call*2)+"",a+""]]);
			}else if(st_call==5){
				if(a==5){
					sendRequest([["query"],["action"]],[["id"],["id","type","type_alert"]],[["7"],["10","3",5+""]]);
					stg_class.shop["exit"].sendRequest(["query","action"],[["id"],["id"]],[["1"],["1"]]);
					st_call=0;
				}
			}else if(st_call==6){
				sendRequest([["query"],["action"]],[["id"],["id","type","type_alert"]],[["7"],["10",a+"",6+""]]);
				st_call=0;
				stg_cl.warn_f(9,"");
			}
			//trace(st_call+"   "+a);
		}
		
		public function time_over1(event:TimerEvent):void{
			root["empt_cl"].alpha=1;
			root["empt_cl"].visible=false;
		}
		
		public function waiting1(event:TimerEvent):void{
			if(event.currentTarget.currentCount>75){
				root["empt_cl"].alpha-=1/25;
			}
		}
		
		public function sendCombats(strXML:String, vis:Boolean, tst:int){
			t_count=0;
			var rqs:URLRequest;
			if(tst==1){
				rqs=new URLRequest(serv_url+"?query="+3+"&action="+2+"&level="+stg_class.shop["exit"].my_level);
			}else{
				rqs=new URLRequest(serv_url+"?query="+7+"&action="+9+"&level="+stg_class.shop["exit"].my_level);
			}
			rqs.method=URLRequestMethod.POST;
			var loader:URLLoader=new URLLoader(rqs);
			var list:XML;
			list=new XML(strXML);
			////trace("send "+list);
			if(tst==1){
				loader.addEventListener(Event.COMPLETE, addCombat);
			}else if(tst==0){
				loader.addEventListener(Event.COMPLETE, addCombat1);
			}else if(tst==2){
				loader.addEventListener(Event.COMPLETE, addCombat2);
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
		
		public function stopAr(){
			//trace("stoplist");
			try{
				arTimer.stop();
				arTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, ar_over);
			}catch(e:Error){
				
			}
		}
	
		public function sendRequest(names:Array, attr:Array, idies:Array, _i:int=0){
			t_count=0;
			var b:int=0;
			if(!(int(idies[0][0])==3&&int(idies[1][0])==6)){
				stopAr();
			}else{
				if(st_wait>0){
					return;
				}else{
					st_wait++;
				}
			}
			//trace(idies+"   "+stg_class.m_mode);
			if(stg_class.m_mode==3){
				stopCall();
				stopAr();
				stopStatus();
				return;
			}
			var rqs:URLRequest=new URLRequest(serv_url+"?query="+idies[0][0]+"&action="+idies[1][0]+"&level="+stg_class.shop["exit"].my_level);
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
					if(int(idies[1][0])==1||int(idies[1][0])==3){
						loader.addEventListener(Event.COMPLETE, listCombat);
						if(stg_class.help_on){
							if(stg_class.help_st==7){
								stg_cl.initLesson(8);
								stg_class.help_cl["lesson1"]["win"]["leave_cl"].set_type(8);
								stg_class.help_cl["lesson1"]["win"]["leave_cl"].sendRequest([["query"],["action"]],[["id"],["id","study"]],[["2"],["14",8+""]]);
							}
						}
					}else if(int(idies[1][0])==6){
						loader.addEventListener(Event.COMPLETE, listStatus);
						b=1;
					}else if(int(idies[1][0])==8){
						loader.addEventListener(Event.COMPLETE, auto_search);
					}else if(int(idies[1][0])==9){
						if(idies[1][1]>0){
							loader.addEventListener(Event.COMPLETE, auto_battle);
						}else{
							loader.addEventListener(Event.COMPLETE, out_auto_bat);
						}
					}else if(int(idies[1][0])==12){
						try{
							autoT.stop();
						}catch(er:Error){}
						if(idies[1][1]==0){
							loader.addEventListener(Event.COMPLETE, auto_no);
						}else{
							loader.addEventListener(Event.COMPLETE, auto_yes);
						}
					}
				}else if(int(idies[0][0])==1){
					if(int(idies[1][0])==20){
						loader.addEventListener(Event.COMPLETE, getVip);
					}else if(int(idies[1][0])==28){
						loader.addEventListener(Event.COMPLETE, getObmen);
					}else if(int(idies[1][0])==30){
						loader.addEventListener(Event.COMPLETE, obmenFuel);
					}else if(int(idies[1][0])==31){
						loader.addEventListener(Event.COMPLETE, obmenVal);
					}
				}else if(int(idies[0][0])==7){
					if(int(idies[1][0])==2){
						loader.addEventListener(Event.COMPLETE, conferm1);
						b=1;
					}else if(int(idies[1][0])==4){
						loader.addEventListener(Event.COMPLETE, conferm2);
						b=1;
					}else if(int(idies[1][0])==5){
						loader.addEventListener(Event.COMPLETE, listGroup);
						b=1;
					}else if(int(idies[1][0])==6){
						loader.addEventListener(Event.COMPLETE, conferm2);
						b=1;
					}else if(int(idies[1][0])==7){
						loader.addEventListener(Event.COMPLETE, listCombat1);
					}else if(int(idies[1][0])==8){
						loader.addEventListener(Event.COMPLETE, listCombat1);
					}else if(int(idies[1][0])==10){
						b=1;
					}
				}else if(int(idies[0][0])==8){
					if(int(idies[1][0])==1){
						loader.addEventListener(Event.COMPLETE, conferm3);
					}else if(int(idies[1][0])==2){
						loader.addEventListener(Event.COMPLETE, listCombat2);
						//trace("send arena info");
						if(root["arena_cl"].visible){
							b=1;
						}
					}else if(int(idies[1][0])==3){
						loader.addEventListener(Event.COMPLETE, conferm4);
						//b=1;
					}else if(int(idies[1][0])==4){
						loader.addEventListener(Event.COMPLETE, conferm5);
						//b=1;
					}
				}else if(int(idies[0][0])==9){
					if(int(idies[1][0])==2){
						loader.addEventListener(Event.COMPLETE, getPolk);
					}else if(int(idies[1][0])==1){
						loader.addEventListener(Event.COMPLETE, createPolk);
						if(_i==0)stg_cl["buy_send"]=[names, attr, idies, 2];
					}else if(int(idies[1][0])==5){
						loader.addEventListener(Event.COMPLETE, getMts);
					}else if(int(idies[1][0])==4){
						loader.addEventListener(Event.COMPLETE, outOfPolk);
					}else if(int(idies[1][0])==8){
						loader.addEventListener(Event.COMPLETE, listAmmo);
					}else if(int(idies[1][0])==7){
						loader.addEventListener(Event.COMPLETE, setRang);
					}else if(int(idies[1][0])==11){
						loader.addEventListener(Event.COMPLETE, getMtsRes);
					}else if(int(idies[1][0])==12){
						loader.addEventListener(Event.COMPLETE, setMtsRes);
					}else if(int(idies[1][0])==13){
						loader.addEventListener(Event.COMPLETE, getPolkOpt);
					}else if(int(idies[1][0])==14){
						loader.addEventListener(Event.COMPLETE, setPolkOpt);
					}else if(int(idies[1][0])==15){
						loader.addEventListener(Event.COMPLETE, getPolkOtchet);
					}else if(int(idies[1][0])==17){
						loader.addEventListener(Event.COMPLETE, callReid);
					}else if(int(idies[1][0])==18){
						loader.addEventListener(Event.COMPLETE, calendarP);
					}else if(int(idies[1][0])==19){
						loader.addEventListener(Event.COMPLETE, reputationP);
					}else if(int(idies[1][0])==20){
						loader.addEventListener(Event.COMPLETE, getZnamja);
					}else if(int(idies[1][0])==21){
						loader.addEventListener(Event.COMPLETE, delPolk);
					}else if(int(idies[1][0])==22){
						loader.addEventListener(Event.COMPLETE, Zn_rebuy);
					}else if(int(idies[1][0])==6){
						loader.addEventListener(Event.COMPLETE, Rangs);
					}
				}else if(int(idies[0][0])==14){
					if(int(idies[1][0])==1){
						loader.addEventListener(Event.COMPLETE, auto_search1);
					}else if(int(idies[1][0])==2){
						loader.addEventListener(Event.COMPLETE, srch_gr_start);
					}else if(int(idies[1][0])==3){
						loader.addEventListener(Event.COMPLETE, srch_gr_stop);
					}else if(int(idies[1][0])==4){
						loader.addEventListener(Event.COMPLETE, srch_gr_ready);
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
			stg_cl.warn_f(5,"Нет ответа от сервера. \nПроверьте подключение к интернету.",5);
			/*try{
				mTimer.stop();
			}catch(e:Error){
				
			}
			t_count=0;
			t_over=true;*/
		}
		
		public function obmenVal(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nОбмен по курсу.");
				stg_cl.erTestReq(1,31,str);
				return;
			}
			
			//trace("obmenVal\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
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
			for(var i:int=0;i<2;i++){
				root["polk_win"]["mts_cl"]["obmen"]["num_tx"+i].text="0";
				root["polk_win"]["mts_cl"]["obmen"]["num1_tx"+i].text="0";
			}
			root["polk_win"]["mts_cl"]["obmen"]["numf_tx"].text="0";
			root["polk_win"]["mts_cl"]["obmen"]["numf1_tx"].text="0";
					
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function obmenFuel(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nКомпенсация топлива.");
				stg_cl.erTestReq(1,30,str);
				return;
			}
			
			trace("obmenFuel\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			var _ar:Array=new Array();
			_ar.push(list.child("err")[0].attribute("money_m"));
			_ar.push(stg_class.shop["exit"].getMoneys(1));
			_ar.push(stg_class.shop["exit"].getMoneys(2));
			_ar.push(stg_class.shop["exit"].getMoneys(3));
			_ar.push(stg_class.shop["exit"].getMoneys(4));
			_ar.push(stg_class.shop["exit"].getMoneys(5));
			stg_class.shop["exit"].setMoneys(_ar);
			for(var i:int=0;i<2;i++){
				root["polk_win"]["mts_cl"]["obmen"]["num_tx"+i].text="0";
				root["polk_win"]["mts_cl"]["obmen"]["num1_tx"+i].text="0";
			}
			root["polk_win"]["mts_cl"]["obmen"]["numf_tx"].text="0";
			root["polk_win"]["mts_cl"]["obmen"]["numf1_tx"].text="0";
					
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
				stg_cl.erTestReq(1,28,str);
				return;
			}
			
			//trace("getObmen\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			for(var i:int=0;i<2;i++){
				root["polk_win"]["mts_cl"]["obmen"]["comm_tx"+i].text="Недоступен";
				root["polk_win"]["mts_cl"]["obmen"]["kurs_tx"+i].text="0";
				root["polk_win"]["mts_cl"]["obmen"]["num_tx"+i].text="0";
				root["polk_win"]["mts_cl"]["obmen"]["num1_tx"+i].text="0";
				root["polk_win"]["mts_cl"]["obmen"]["konv_val"+i].gotoAndStop("empty");
				root["polk_win"]["mts_cl"]["obmen"]["left_obm"+i].gotoAndStop("empty");
				root["polk_win"]["mts_cl"]["obmen"]["right_obm"+i].gotoAndStop("empty");
			}
			root["polk_win"]["mts_cl"]["obmen"]["numf_tx"].text="0";
			root["polk_win"]["mts_cl"]["obmen"]["numf1_tx"].text="0";
			
			for(var i:int=0;i<list.child("convert")[0].child("conv").length();i++){
				if(int(list.child("convert")[0].child("conv")[i].attribute("money_z"))<0){
					root["polk_win"]["mts_cl"]["obmen"]["comm_tx"+0].text="Индивидуальный курс";
					root["polk_win"]["mts_cl"]["obmen"]["left_obm"+0]._step=Math.abs(int(list.child("convert")[0].child("conv")[i].attribute("money_z")));
					root["polk_win"]["mts_cl"]["obmen"]["right_obm"+0]._step=root["polk_win"]["mts_cl"]["obmen"]["left_obm"+0]._step;
					root["polk_win"]["mts_cl"]["obmen"]["right_obm"+0]._type=1;
					root["polk_win"]["mts_cl"]["obmen"]["left_obm"+0].gotoAndStop("out");
					root["polk_win"]["mts_cl"]["obmen"]["right_obm"+0].gotoAndStop("out");
					root["polk_win"]["mts_cl"]["obmen"]["konv_val"+0].ID=int(list.child("convert")[0].child("conv")[i].attribute("id"));
					root["polk_win"]["mts_cl"]["obmen"]["kurs_tx"+0].text=Math.abs(int(list.child("convert")[0].child("conv")[i].attribute("money_z")))+":"+Math.abs(int(list.child("convert")[0].child("conv")[i].attribute("money_a")));
					root["polk_win"]["mts_cl"]["obmen"]["num_tx"+0].text="0";
					root["polk_win"]["mts_cl"]["obmen"]["num1_tx"+0].text="0";
					if(int(list.child("convert")[0].child("conv")[i].attribute("hidden"))==0){
						root["polk_win"]["mts_cl"]["obmen"]["konv_val"+0].gotoAndStop("out");
					}
				}else if(int(list.child("convert")[0].child("conv")[i].attribute("money_a"))<0){
					root["polk_win"]["mts_cl"]["obmen"]["comm_tx"+1].text="Индивидуальный курс";
					root["polk_win"]["mts_cl"]["obmen"]["left_obm"+1]._step=Math.abs(int(list.child("convert")[0].child("conv")[i].attribute("money_a")));
					root["polk_win"]["mts_cl"]["obmen"]["right_obm"+1]._step=root["polk_win"]["mts_cl"]["obmen"]["left_obm"+1]._step;
					root["polk_win"]["mts_cl"]["obmen"]["right_obm"+1]._type=2;
					root["polk_win"]["mts_cl"]["obmen"]["left_obm"+1].gotoAndStop("out");
					root["polk_win"]["mts_cl"]["obmen"]["right_obm"+1].gotoAndStop("out");
					root["polk_win"]["mts_cl"]["obmen"]["konv_val"+1].ID=int(list.child("convert")[0].child("conv")[i].attribute("id"));
					root["polk_win"]["mts_cl"]["obmen"]["kurs_tx"+1].text=Math.abs(int(list.child("convert")[0].child("conv")[i].attribute("money_a")))+":"+Math.abs(int(list.child("convert")[0].child("conv")[i].attribute("money_i")));
					root["polk_win"]["mts_cl"]["obmen"]["num_tx"+1].text="0";
					root["polk_win"]["mts_cl"]["obmen"]["num1_tx"+1].text="0";
					if(int(list.child("convert")[0].child("conv")[i].attribute("hidden"))==0){
						root["polk_win"]["mts_cl"]["obmen"]["konv_val"+1].gotoAndStop("out");
					}
				}
			}
			
			root["polk_win"]["mts_cl"]["obmen"]["left_f"]._step=Math.abs(int(list.child("fuel")[0].attribute("money_m")));
			root["polk_win"]["mts_cl"]["obmen"]["right_f"]._step=root["polk_win"]["mts_cl"]["obmen"]["left_f"]._step;
			root["polk_win"]["mts_cl"]["obmen"]["right_f"]._type=0;
			root["polk_win"]["mts_cl"]["obmen"]["konv_f"].ID=int(list.child("fuel")[0].attribute("id"));
			//root["polk_win"]["mts_cl"]["obmen"]["kurs_tx"+1].text=Math.abs(int(list.child("fuel")[0].child("conv")[0].attribute("money_m")))+":"+Math.abs(int(list.child("fuel")[0].child("conv")[0].attribute("fuel")));
			root["polk_win"]["mts_cl"]["obmen"]["numf_tx"].text="0";
			root["polk_win"]["mts_cl"]["obmen"]["numf1_tx"].text="0";
			if(int(root["polk_win"]["mts_cl"]["obmen"]["left_f"]._step)>=stg_class.shop["exit"].getMoneys(0)){
				root["polk_win"]["mts_cl"]["obmen"]["konv_f"].gotoAndStop("out");
			}
			
			root["polk_win"]["mts_cl"]["obmen"].visible=true;
					
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function auto_no(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПодтверждение автовыбора боя.");
				stg_cl.erTestReq(3,12,str);
				return;
			}
			
			//trace("out_auto_bat\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			_auto=1;
					
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var _auto:int=0;
		
		public function auto_yes(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПодтверждение автовыбора боя.");
				stg_cl.erTestReq(3,12,str);
				return;
			}
			
			//trace("out_auto_bat\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			stg_class.warn_cl["big_win1"]["name_tx"].text=stg_class.warn_cl["big_wait"]["name_tx"].text;
			stg_class.warn_cl["big_win1"]["m_m_tx"].text=stg_class.warn_cl["big_wait"]["m_m_tx"].text;
			stg_class.warn_cl["big_win1"]["m_z_tx"].text=stg_class.warn_cl["big_wait"]["m_z_tx"].text;
			stg_class.warn_cl["big_win1"]["m_gs_tx"].text=stg_class.warn_cl["big_wait"]["m_gs_tx"].text;
			winStop(root["a_re_win"]);
			stg_cl.warn_f(18,"");
					
			//stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function out_auto_bat(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВыход из очереди на автовыбор боя.");
				stg_cl.erTestReq(3,9,str);
				return;
			}
			
			//trace("out_auto_bat\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			stg_class.panel["waiting_cl"].visible=false;
			winStop(root["a_re_win"]);
					
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function auto_battle(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nАвтовыбор боя.");
				stg_cl.erTestReq(3,9,str);
				return;
			}
			
			//trace("auto_battle\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			auto_type=0;
			root["auto_win"].visible=false;
			root["win_cl"].visible=false;
			root["a_re_win"]["name_tx"].text=list.child("err")[0].attribute("name");
			root["a_re_win"]["m_z_tx"].text=list.child("err")[0].attribute("w_money_z");
			root["a_re_win"]["m_m_tx"].text=list.child("err")[0].attribute("w_money_m");
			root["a_re_win"]["m_gs_tx"].text=list.child("err")[0].attribute("w_money_za");
			stg_class.panel["waiting_cl"].visible=true;
			winStart(root["a_re_win"]);
					
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function win_over(event:TimerEvent):void{
			winStop(winClip);
		}
		
		public function winStop(_cl:MovieClip):void{
			//trace(winClip.name+"   "+_cl.name);
			if(winClip==_cl){
				try{
					winTimer.stop();
				}catch(er:Error){}
				try{
					winClip.visible=false;
				}catch(er:Error){}
				winClip=null;
			}
		}
		
		public function winStart(_cl:MovieClip):void{
			try{
				winTimer.stop();
			}catch(er:Error){}
			try{
				winClip.visible=false;
			}catch(er:Error){}
			winClip=_cl;
			winClip.visible=true;
			winTimer=new Timer(5000, 1);
			winTimer.addEventListener(TimerEvent.TIMER_COMPLETE, win_over);
			winTimer.start();
		}
		
		public static var winTimer:Timer;
		public static var winClip:MovieClip;
		public static var auto_type:int=0;
		
		public function srch_gr_start(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПоиск боёв.");
				stg_cl.erTestReq(14,2,str);
				return;
			}
			
			//trace("auto_search\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			auto_type=1;
			root["auto_win"].visible=false;
			root["win_cl"].visible=false;
			root["au_gr_win1"]["bp_need_tx"].text=root["auto_win"]["win2"]["bp_need_tx"].text;
			root["au_gr_win1"]["bp_now_tx"].text=root["auto_win"]["win2"]["bp_now_tx"].text;
			root["au_gr_win1"]["num_tx"].text=root["auto_win"]["win2"]["num_tx"].text;
			stg_class.panel["waiting_cl"].visible=true;
			winStart(root["au_gr_win1"]);
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function stopAutoWait():void{
			if(auto_type==0){
				sendRequest(["query","action"],[["id"],["id","battle"]],[["3"],[9+"",0+""]]);
			}else if(auto_type==1){
				sendRequest(["query","action"],[["id"],["id"]],[["14"],["3"]]);
			}
		}
		
		public function srch_gr_ready(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПоиск боёв.");
				stg_cl.erTestReq(14,3,str);
				return;
			}
			
			//trace("auto_search\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function srch_gr_stop(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПоиск боёв.");
				stg_cl.erTestReq(14,3,str);
				return;
			}
			
			//trace("auto_search\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			stg_class.panel["waiting_cl"].visible=false;
			winStop(root["a_re_win"]);
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function auto_search1(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПоиск боёв.");
				stg_cl.erTestReq(14,1,str);
				return;
			}
			
			//trace("auto_search\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			root["auto_win"]["win2"]["bp_now_tx"].text=list.child("find_group")[0].attribute("myGS");
			root["auto_win"]["win2"]["bp_need_tx"].text=list.child("find_group")[0].attribute("minmax_gs");
			root["auto_win"]["win2"]["num_tx"].text=list.child("find_group")[0].attribute("eshelon");
			
			root["auto_win"]["win2"].visible=true;
			root["auto_win"]["win1"].visible=false;
			root["auto_win"]["search_b0"].gotoAndStop("press");
			root["auto_win"]["search_b1"].gotoAndStop("out");
			root["auto_win"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function auto_search(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПоиск боёв.");
				stg_cl.erTestReq(3,8,str);
				return;
			}
			
			//trace("auto_search\n"+list);
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			for(var j:int=0;j<list.child("battle").length();j++){
				if(int(list.child("battle")[j].attribute("hidden"))!=0){
					root["auto_win"]["win1"]["ready_tx"+j].text="Не доступно";
					root["auto_win"]["win1"]["ready_tx"+j].textColor=0xFF0000;
					root["auto_win"]["win1"]["auto_bat"+j].visible=false;
				}else{
					root["auto_win"]["win1"]["ready_tx"+j].text="Доступно";
					root["auto_win"]["win1"]["ready_tx"+j].textColor=0x003300;
					root["auto_win"]["win1"]["auto_bat"+j].visible=true;
				}
				root["auto_win"]["win1"]["BP_tx"+j].text=list.child("battle")[j].attribute("gs_need")+"";
				root["auto_win"]["win1"]["auto_info"+j].i_text=list.child("battle")[j].attribute("descr")+"";
				root["auto_win"]["win1"]["auto_bat"+j].ID=list.child("battle")[j].attribute("id")+"";
			}
			root["auto_win"]["win2"].visible=false;
			root["auto_win"]["win1"].visible=true;
			root["auto_win"]["search_b1"].gotoAndStop("press");
			root["auto_win"]["search_b0"].gotoAndStop("out");
			root["auto_win"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function Zn_rebuy(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВыкуп знамени.");
				stg_cl.erTestReq(9,22,str);
				return;
			}
			
			//trace("Zn_rebuy\n"+list);
			
			root["polk_win"]["znamja_win"]["buy_zn_win"].visible=false;
			
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					root["polk_win"]["znamja_win"]["zn_warn"]["mess_tx"].text=list.child("err")[0].attribute("comm");
					root["polk_win"]["znamja_win"]["zn_warn"].visible=true;
				}
			}catch(er:Error){
				
			}
					//root["polk_win"]["znamja_win"]["zn_warn"].visible=true;
					//root["polk_win"]["znamja_win"]["buy_zn_win"].visible=false;mess_tx
					
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getVip(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВоенторг.");
				erTestReq(1,20,str);
				return;
			}
			//trace("getVip\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			//trace("getVip\n"+list);
			
			vipReset();
			try{
				root["polk_win"]["v_torg"].removeChild(root["polk_win"]["v_torg"].weap);
			}catch(er:Error){
				
			}
			root["polk_win"]["v_torg"]["top_tx"].text="Репутация: "+list.child("mods")[0].attribute("polk_top");
			var _weap:MovieClip=stg_class.vip_cl["exit_cl"].weap_win();
			root["polk_win"]["v_torg"].weap=_weap;
			stg_class.vip_cl["exit_cl"].setVip(list,root["polk_win"]["v_torg"],_weap,299);
			_weap.x=2;
			_weap.y=24;
			_weap.sc_clip.x=_weap.scrollRect.width+_weap.x;
			_weap.sc_clip.y=_weap.y+1;
			root["polk_win"]["v_torg"]["help_cl"].visible=false;
			root["polk_win"]["v_torg"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function vipReset(){
			try{
				root["polk_win"]["v_torg"].removeChild(root["polk_win"]["v_torg"].weap);
			}catch(er:Error){
				
			}
			root["polk_win"]["v_torg"].visible=false;
		}
		
		public function newPict(_str:String,_cl:MovieClip,_i:int=0){
			var loader:Loader = new Loader();
			loader.name="us_ava";
			loader.x=3;
			loader.y=32;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event){
				//trace(event.currentTarget.content)
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
				}
				_cl.addChild(_clip);
				_cl.pict=event.currentTarget.content;
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, unLoadPict);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadPict);
			
			loader.load(new URLRequest(stg_class.res_url+"/"+_str));
		}
		
		public function unLoadPict(event:IOErrorEvent):void{
			stg_cl.warn_f(4,"Военторг, изображения");
		}
		
		public function Rangs(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nДолжности.");
				erTestReq(9,6,str);
				return;
			}
			//trace("Rangs\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			for(var i:int=0;i<list.child("polk_rangs")[0].child("polk_rang").length();i++){
				try{
					root["polk_win"]["set_rang"]["num"+list.child("polk_rangs")[0].child("polk_rang")[i].attribute("id")].text=list.child("polk_rangs")[0].child("polk_rang")[i].attribute("num")+"/"+list.child("polk_rangs")[0].child("polk_rang")[i].attribute("num_max");
				}catch(er:Error){
					trace(er);
				}
			}
			
			root["polk_win"]["set_rang"].visible=true;
			root["polk_win"]["reset_rang"].visible=false;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function delPolk(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: расформирование.");
				erTestReq(9,21,str);
				return;
			}
			//trace("delPolk\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["2"]]);
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getZnamja(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: знамя.");
				erTestReq(9,20,str);
				return;
			}
			//trace("getZnamja\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			resetPolkWin();
			for(var i:int=0;i<5;i++){
				if(i<int(list.child("flag")[0].attribute("lose_plan"))){
					root["polk_win"]["znamja_win"]["znamja"+i].gotoAndStop(2);
				}else{
					root["polk_win"]["znamja_win"]["znamja"+i].gotoAndStop(1);
				}
			}
			if(int(list.child("flag")[0].attribute("now"))==1){
				root["polk_win"]["znamja_win"]["buy_znamja"].gotoAndStop("empty");
			}else{
				root["polk_win"]["znamja_win"]["buy_znamja"].gotoAndStop("out");
			}
			root["polk_win"]["znamja_win"]["num_tx"].text=list.child("flag")[0].attribute("lose_plan");
			root["polk_win"]["znamja_win"]["mess_tx"].text=list.child("flag")[0].attribute("text");
			root["polk_win"]["znamja_win"]["buy_zn_win"].visible=false;
			root["polk_win"]["znamja_win"]["zn_warn"].visible=false;
			root["polk_win"]["znamja_win"]["buy_zn_win"]["m_m_tx"].text=list.child("flag")[0].attribute("money_m");
			root["polk_win"]["znamja_win"]["buy_zn_win"]["m_z_tx"].text=list.child("flag")[0].attribute("money_z");
			root["polk_win"]["znamja_win"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var rep_ar:Array=new Array();
		public static var rep_c:int=0;
		
		public function reputationP(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: репутация.");
				erTestReq(9,19,str);
				return;
			}
			//trace("reputationP\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			resetPolkWin();
			rep_ar=new Array();
			rep_c=0;
			for(var i:int=0;i<list.child("reputation")[0].child("user").length();i++){
				var ar:Array=new Array();
				ar[0]=(list.child("reputation")[0].child("user")[i].attribute("top"));
				ar[1]=(list.child("reputation")[0].child("user")[i].attribute("polk_top"));
				ar[2]=(list.child("reputation")[0].child("user")[i].attribute("name"));
				ar[3]=(list.child("reputation")[0].child("user")[i].attribute("rang"));
				ar[4]=(list.child("reputation")[0].child("user")[i].attribute("polk_rang"));
				ar[5]=(list.child("reputation")[0].child("user")[i].attribute("sn_id"));
				ar[6]=(list.child("reputation")[0].child("user")[i].attribute("sn_link"));
				rep_ar.push(ar);
			}
			repPage();
			root["polk_win"]["polk_rep"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function repPage(){
			for(var i:int=0;i<8;i++){
				if(int(rep_ar.length/5)>=i){
					root["polk_win"]["polk_rep"]["page"+i]["num_tx"].text=root["polk_win"]["polk_rep"]["page"+i]["now_cl"]["num_tx"].text=(i+1);
					root["polk_win"]["polk_rep"]["page"+i].visible=true;
					if(rep_c==i){
						root["polk_win"]["polk_rep"]["page"+i]["now_cl"].visible=true;
					}else{
						root["polk_win"]["polk_rep"]["page"+i]["now_cl"].visible=false;
					}
				}else{
					root["polk_win"]["polk_rep"]["page"+i].visible=false;
				}
			}
			for(var i:int=rep_c*5;i<rep_c*5+5;i++){
				if(i<rep_ar.length){
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["num_tx"].text=rep_ar[i][0];
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["point_tx"].text=rep_ar[i][1];
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["name_tx"].text=rep_ar[i][2];
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rang_tx"].text=rep_ar[i][3];
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["p_rang_tx"].text=rep_ar[i][4];
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rep_look"].visible=true;
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rep_link"].visible=true;
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rep_look"]._uid=rep_ar[i][5];
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rep_link"]._uid=rep_ar[i][6];
					if(stg_cl["v_id"]==rep_ar[i][5]){
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)].gotoAndStop(2);
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["num_tx"].textColor=0x9A0700;
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["point_tx"].textColor=0x9A0700;
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["name_tx"].textColor=0x9A0700;
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rang_tx"].textColor=0x9A0700;
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["p_rang_tx"].textColor=0x9A0700;
					}else{
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)].gotoAndStop(1);
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["num_tx"].textColor=0xFFFFFF;
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["point_tx"].textColor=0xFFFFFF;
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["name_tx"].textColor=0xFFFFFF;
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rang_tx"].textColor=0xFFFFFF;
						root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["p_rang_tx"].textColor=0xFFFFFF;
					}
				}else{
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["num_tx"].text="";
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["point_tx"].text="";
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["name_tx"].text="";
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rang_tx"].text="";
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["p_rang_tx"].text="";
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rep_look"].visible=false;
					root["polk_win"]["polk_rep"]["us"+(i-rep_c*5)]["rep_link"].visible=false;
				}
			}
		}
		
		public function calendarP(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: план.");
				erTestReq(9,18,str);
				return;
			}
			//trace("calendarP\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			resetPolkWin();
			var ar:Array=[new Array(),new Array()];
			for(var i:int=0;i<list.child("plans")[0].child("plan").length();i++){
				ar[list.child("plans")[0].child("plan")[i].attribute("type")].push([(list.child("plans")[0].child("plan")[i].attribute("name")),(list.child("plans")[0].child("plan")[i].attribute("num")),(list.child("plans")[0].child("plan")[i].attribute("num_max"))]);
			}
			root["polk_win"]["polk_plan"]["res_cl"].gotoAndStop(1);
			//trace(ar[0].join("|"));
			for(var i:int=0;i<3;i++){
				if(i<ar[0].length){
					root["polk_win"]["polk_plan"]["l_name_tx"+i].text=ar[0][i][0];
					root["polk_win"]["polk_plan"]["l_need_tx"+i].text=ar[0][i][2];
					root["polk_win"]["polk_plan"]["l_num_tx"+i].text=ar[0][i][1];
					if(int(ar[0][i][1])<int(ar[0][i][2])){
						root["polk_win"]["polk_plan"]["l_num_cl"+i].gotoAndStop(1);
						root["polk_win"]["polk_plan"]["res_cl"].gotoAndStop(2);
					}else{
						root["polk_win"]["polk_plan"]["l_num_cl"+i].gotoAndStop(2);
					}
				}else{
					root["polk_win"]["polk_plan"]["l_name_tx"+i].text="";
					root["polk_win"]["polk_plan"]["l_need_tx"+i].text="";
					root["polk_win"]["polk_plan"]["l_num_tx"+i].text="";
					root["polk_win"]["polk_plan"]["l_num_cl"+i].gotoAndStop(3);
				}
			}
			//trace(ar[1].join("|"));
			for(var i:int=0;i<4;i++){
				if(i<ar[1].length){
					root["polk_win"]["polk_plan"]["m_name_tx"+i].text=ar[1][i][0];
					root["polk_win"]["polk_plan"]["m_need_tx"+i].text=ar[1][i][2];
					root["polk_win"]["polk_plan"]["m_num_tx"+i].text=ar[1][i][1];
					if(int(ar[1][i][1])<int(ar[1][i][2])){
						root["polk_win"]["polk_plan"]["m_num_cl"+i].gotoAndStop(1);
						root["polk_win"]["polk_plan"]["res_cl"].gotoAndStop(2);
					}else{
						root["polk_win"]["polk_plan"]["m_num_cl"+i].gotoAndStop(2);
					}
				}else{
					root["polk_win"]["polk_plan"]["m_name_tx"+i].text="";
					root["polk_win"]["polk_plan"]["m_need_tx"+i].text="";
					root["polk_win"]["polk_plan"]["m_num_tx"+i].text="";
					root["polk_win"]["polk_plan"]["m_num_cl"+i].gotoAndStop(3);
				}
			}
			root["polk_win"]["polk_plan"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function callReid(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: рейд.");
				erTestReq(9,17,str);
				return;
			}
			//trace("callReid\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl.warn_f(9,"");
			resetPolkWin();
			if(list.child("reids").length()){
				for(var i:int=0;i<3;i++){
					if(list.child("reids")[0].child("reid")[i].attribute("hidden")>0){
						root["polk_win"]["reid_win"]["reid_tx"+i].visible=false;
						root["polk_win"]["reid_win"]["reid"+i].visible=false;
					}else{
						root["polk_win"]["reid_win"]["reid_tx"+i].text=list.child("reids")[0].child("reid")[i].attribute("name");
						root["polk_win"]["reid_win"]["reid"+i].r_type=list.child("reids")[0].child("reid")[i].attribute("type_r");
						root["polk_win"]["reid_win"]["reid_tx"+i].visible=true;
						root["polk_win"]["reid_win"]["reid"+i].visible=true;
						if(i>0){
							root["polk_win"]["reid_win"]["reid"+i]["press_cl"].visible=false;
						}else{
							root["polk_win"]["reid_win"]["reid"+i]["press_cl"].visible=true;
						}
					}
				}
				root["polk_win"]["reid_win"].visible=true;
			}else if(list.child("window").length()>0){
				var ar:Array=new Array();
				ar.push(int(list.child("window")[0].attribute("type")));
				ar.push(list.child("window")[0].attribute("sender"));
				ar.push(list.child("window")[0].attribute("from"));
				ar.push(int(list.child("window")[0].attribute("time")));
				ar.push(int(list.child("window")[0].attribute("time_max")));
				ar.push(int(list.child("window")[0].attribute("state")));
				//ar.push(int(list.child("window")[0].attribute("type")));
				//stg_cl.createMode(1);
				call_f(ar);
			}
			
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getPolkOtchet(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: отчёт.");
				erTestReq(9,15,str);
				return;
			}
			//trace("getPolkOtchet\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			resetPolkWin();
			mts_stat=new Array();
			for(var i:int=0;i<list.child("mts_stat")[0].child("user").length();i++){
				var _ar:Array=new Array();
				_ar.push(list.child("mts_stat")[0].child("user")[i].attribute("name"));
				_ar.push(list.child("mts_stat")[0].child("user")[i].attribute("polkRang"));
				_ar.push(list.child("mts_stat")[0].child("user")[i].attribute("fuel"));
				_ar.push(list.child("mts_stat")[0].child("user")[i].attribute("money_m"));
				_ar.push(list.child("mts_stat")[0].child("user")[i].attribute("money_z"));
				_ar.push(list.child("mts_stat")[0].child("user")[i].attribute("bonus1"));
				_ar.push(list.child("mts_stat")[0].child("user")[i].attribute("bonus2"));
				_ar.push(list.child("mts_stat")[0].child("user")[i].attribute("bonus3"));
				_ar.push(list.child("mts_stat")[0].child("user")[i].attribute("bonus4"));
				mts_stat.push(_ar);
			}
			mts_page=0;
			polkOtchet();
			root["polk_win"]["mts_cl"].visible=true;
			root["polk_win"]["mts_cl"]["otchet_win"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var mts_stat:Array=new Array();
		public static var mts_page:int=0;
		
		public function polkOtchet(){
			for(var i:int=0;i<4;i++){
				if(int(mts_stat.length/11)>=i){
					root["polk_win"]["mts_cl"]["otchet_win"]["page"+i]["num_tx"].text=root["polk_win"]["mts_cl"]["otchet_win"]["page"+i]["now_cl"]["num_tx"].text=(i+1);
					root["polk_win"]["mts_cl"]["otchet_win"]["page"+i].visible=true;
					if(mts_page==i){
						root["polk_win"]["mts_cl"]["otchet_win"]["page"+i]["now_cl"].visible=true;
					}else{
						root["polk_win"]["mts_cl"]["otchet_win"]["page"+i]["now_cl"].visible=false;
					}
				}else{
					root["polk_win"]["mts_cl"]["otchet_win"]["page"+i].visible=false;
				}
			}
			//trace(mts_stat.join("|")+"\npage   "+mts_page);
			for(var i:int=0;i<11;i++){
				try{
					for(var j:int=0;j<10;j++){
						root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fon"+j].gotoAndStop(1);
					}
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["num_tx"].text=(i+1+mts_page*11)+"";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["name_tx"].text=mts_stat[(i+mts_page*11)][0];
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["rang_tx"].text=mts_stat[(i+mts_page*11)][1];
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fuel_tx"].text=mts_stat[(i+mts_page*11)][2];
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["m_m_tx"].text=mts_stat[(i+mts_page*11)][3];
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["m_z_tx"].text=mts_stat[(i+mts_page*11)][4];
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["bon1_tx"].text=mts_stat[(i+mts_page*11)][5];
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["bon2_tx"].text=mts_stat[(i+mts_page*11)][6];
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["bon3_tx"].text=mts_stat[(i+mts_page*11)][7];
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["bon4_tx"].text=mts_stat[(i+mts_page*11)][8];
					if(mts_stat[(i+mts_page*11)][2]<0){
						for(var j:int=0;j<4;j++){
							root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fon"+j].gotoAndStop(2);
						}
					}else if(mts_stat[(i+mts_page*11)][3]<0){
						root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fon"+8].gotoAndStop(2);
					}else if(mts_stat[(i+mts_page*11)][4]<0){
						root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fon"+9].gotoAndStop(2);
					}else if(mts_stat[(i+mts_page*11)][5]<0){
						root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fon"+5].gotoAndStop(2);
					}else if(mts_stat[(i+mts_page*11)][6]<0){
						root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fon"+6].gotoAndStop(2);
					}else if(mts_stat[(i+mts_page*11)][7]<0){
						root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fon"+7].gotoAndStop(2);
					}else if(mts_stat[(i+mts_page*11)][8]<0){
						root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fon"+4].gotoAndStop(2);
					}
				}catch(er:Error){
					for(var j:int=0;j<10;j++){
						root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fon"+j].gotoAndStop(1);
					}
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["num_tx"].text=(i+1+mts_page*11)+"";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["name_tx"].text="";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["rang_tx"].text="";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["fuel_tx"].text="";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["m_m_tx"].text="";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["m_z_tx"].text="";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["bon1_tx"].text="";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["bon2_tx"].text="";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["bon3_tx"].text="";
					root["polk_win"]["mts_cl"]["otchet_win"]["us"+i]["bon4_tx"].text="";
				}
			}
		}
		
		public function setPolkOpt(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: управление полком 2.");
				erTestReq(9,14,str);
				return;
			}
			//trace("setPolkOpt\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			resetPolkWin();
			//root["polk_win"]["opt_win"].visible=false;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getPolkOpt(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: управление полком 1.");
				erTestReq(9,13,str);
				return;
			}
			//trace("getPolkOpt\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			resetPolkWin();
			for(var i:int=0;i<list.child("mts_raspred")[0].child("polk_rang").length();i++){
				if(list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")<41||list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")>79){
					for(var j:int=1;j<5;j++){
						for(var n:int=1;n<5;n++){
							//trace("up   "+i+"   "+j+"   "+n+"   "+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("bonus"+j)+"   "+"up_opt_b0"+j+""+n+"_u"+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id"));
							if(n==list.child("mts_raspred")[0].child("polk_rang")[i].attribute("bonus"+j)){
								root["polk_win"]["opt_win"]["up_opt_b0"+j+""+n+"_u"+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")]["press_cl"].visible=true;
							}else{
								root["polk_win"]["opt_win"]["up_opt_b0"+j+""+n+"_u"+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")]["press_cl"].visible=false;
							}
						}
					}
				}
			}
			
			for(var i:int=0;i<list.child("prava_raspred")[0].child("polk_rang").length();i++){
				if(list.child("prava_raspred")[0].child("polk_rang")[i].attribute("id")<41||list.child("prava_raspred")[0].child("polk_rang")[i].attribute("id")>79){
					for(var j:int=1;j<6;j++){
						try{
							//trace("dp   "+i+"   "+j+"   "+list.child("prava_raspred")[0].child("polk_rang")[i].attribute("pravo"+j)+"   "+"dp_opt_b0"+1+""+n+"_u"+list.child("prava_raspred")[0].child("polk_rang")[i].attribute("id"));
							if(list.child("prava_raspred")[0].child("polk_rang")[i].attribute("pravo"+j)>0){
								root["polk_win"]["opt_win"]["dp_opt_b0"+1+""+j+"_u"+list.child("prava_raspred")[0].child("polk_rang")[i].attribute("id")]["press_cl"].visible=true;
							}else{
								root["polk_win"]["opt_win"]["dp_opt_b0"+1+""+j+"_u"+list.child("prava_raspred")[0].child("polk_rang")[i].attribute("id")]["press_cl"].visible=false;
							}
						}catch(er:Error){
							
						}
					}
				}
			}
			
			sendPolkOpt(1);
			root["polk_win"]["opt_win"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function sendPolkOpt(_i:int=0){
			var _ar:Array  = new Array(100,99,80,70,60,50,40,30,0);
			var _ar_id:Array=new Array(100,99,80,80,80,80,40,30,0);
			var _mts_ar:Array=new Array();
			var _prava_ar:Array=new Array();
			for(var i:int=0;i<_ar_id.length;i++){
				var _bon_ar:Array=new Array();
				for(var j:int=1;j<5;j++){
					_bon_ar[j-1]=0;
					for(var n:int=1;n<5;n++){
						try{
							if(root["polk_win"]["opt_win"]["up_opt_b0"+j+""+n+"_u"+_ar_id[i]]["press_cl"].visible){
								_bon_ar[j-1]=n;
							}
						}catch(er:Error){
							
						}
					}
				}
				_mts_ar.push(_bon_ar.join(","));
			}
			_prava_ar.push("1,1,1,1,1");
			for(var i:int=1;i<_ar_id.length;i++){
				var _bon_ar:Array=new Array();
				for(var n:int=1;n<6;n++){
					_bon_ar[n-1]=0;
					try{
						if(root["polk_win"]["opt_win"]["dp_opt_b0"+1+""+n+"_u"+_ar_id[i]]["press_cl"].visible){
							_bon_ar[n-1]=1;
						}
					}catch(er:Error){
						
					}
				}
				_prava_ar.push(_bon_ar.join(","));
			}
			//var _str:String="<query id=\"9\"><action id=\"14\" dolznosty=\""+_ar.join("|")+"\" mts=\""+_mts_ar.join("|")+"\" prava=\""+_prava_ar.join("|")+"\" /></query>";
			//trace("sendPolkOpt   "+_str);
			if(_i==0){
				if(p_o_mem!=_ar.join("|")+"&"+_mts_ar.join("|")+"&"+_prava_ar.join("|")){
					sendRequest([["query"],["action"]],[["id"],["id","dolznosty","mts","prava"]],[["9"],["14",_ar.join("|"),_mts_ar.join("|"),_prava_ar.join("|")]]);
				}else{
					root["polk_win"]["opt_win"].visible=false;
				}
			}else{
				p_o_mem=_ar.join("|")+"&"+_mts_ar.join("|")+"&"+_prava_ar.join("|");
			}
		}
		
		public static var p_o_mem:String="";
		
		public function setMtsRes(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: отправка мтс.");
				erTestReq(9,12,str);
				return;
			}
			//trace("setMtsRes\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			root["polk_win"]["mts_cl"]["mts_res"]["m_m__all"].text=int(root["polk_win"]["mts_cl"]["mts_res"]["m_m__all"].text)-list.child("err")[0].attribute("money_m");
			root["polk_win"]["mts_cl"]["mts_res"]["m_z__all"].text=int(root["polk_win"]["mts_cl"]["mts_res"]["m_z__all"].text)-list.child("err")[0].attribute("money_z");
			root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text=int(root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text)-list.child("err")[0].attribute("fuel");
			for(var i:int=1;i<5;i++){
				if(root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon"+i]["self_id"]==list.child("err")[0].attribute("th_id")){
					root["polk_win"]["mts_cl"]["mts_res"]["bon"+i+"_all"].text=int(root["polk_win"]["mts_cl"]["mts_res"]["bon"+i+"_all"].text)-list.child("err")[0].attribute("th_qntty");
				}
			}
			
			mts_test();
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getMtsRes(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: пополнение мтс.");
				erTestReq(9,11,str);
				return;
			}
			//trace("getMtsRes\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			resetPolkWin();
			root["polk_win"]["mts_cl"]["mts_res"]["m_m__all"].text=list.child("bonuses")[0].attribute("money_m");
			root["polk_win"]["mts_cl"]["mts_res"]["m_z__all"].text=list.child("bonuses")[0].attribute("money_z");
			root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text=list.child("bonuses")[0].attribute("fuel");
			root["polk_win"]["mts_cl"]["mts_res"]["bon"+list.child("bonuses")[0].child("bonus")[0].attribute("bonus_num")+"_all"].text=list.child("bonuses")[0].child("bonus")[0].attribute("num");
			root["polk_win"]["mts_cl"]["mts_res"]["bon"+list.child("bonuses")[0].child("bonus")[1].attribute("bonus_num")+"_all"].text=list.child("bonuses")[0].child("bonus")[1].attribute("num");
			root["polk_win"]["mts_cl"]["mts_res"]["bon"+list.child("bonuses")[0].child("bonus")[2].attribute("bonus_num")+"_all"].text=list.child("bonuses")[0].child("bonus")[2].attribute("num");
			root["polk_win"]["mts_cl"]["mts_res"]["bon"+list.child("bonuses")[0].child("bonus")[3].attribute("bonus_num")+"_all"].text=list.child("bonuses")[0].child("bonus")[3].attribute("num");
			
			root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon"+list.child("bonuses")[0].child("bonus")[0].attribute("bonus_num")].self_id=list.child("bonuses")[0].child("bonus")[0].attribute("id");
			root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon"+list.child("bonuses")[0].child("bonus")[1].attribute("bonus_num")].self_id=list.child("bonuses")[0].child("bonus")[1].attribute("id");
			root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon"+list.child("bonuses")[0].child("bonus")[2].attribute("bonus_num")].self_id=list.child("bonuses")[0].child("bonus")[2].attribute("id");
			root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon"+list.child("bonuses")[0].child("bonus")[3].attribute("bonus_num")].self_id=list.child("bonuses")[0].child("bonus")[3].attribute("id");
			root["polk_win"]["mts_cl"].visible=true;
			root["polk_win"]["mts_cl"]["mts_res"].visible=true;
			
			mts_test();
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function mts_test(){
			if(root["polk_win"]["mts_cl"]["mts_res"]["m_m__all"].text=="0"){
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_m_m_"].gotoAndStop("empty");
				root["polk_win"]["mts_cl"]["mts_res"]["m_m__send"].text="0";
			}else{
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_m_m_"].gotoAndStop("out");
				if(int(root["polk_win"]["mts_cl"]["mts_res"]["m_m__all"].text)>=10){
					root["polk_win"]["mts_cl"]["mts_res"]["m_m__send"].text=10;
				}else{
					root["polk_win"]["mts_cl"]["mts_res"]["m_m__send"].text=root["polk_win"]["mts_cl"]["mts_res"]["m_m__all"].text;
				}
			}
			if(root["polk_win"]["mts_cl"]["mts_res"]["m_z__all"].text=="0"){
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_m_z_"].gotoAndStop("empty");
				root["polk_win"]["mts_cl"]["mts_res"]["m_z__send"].text="0";
			}else{
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_m_z_"].gotoAndStop("out");
				if(int(root["polk_win"]["mts_cl"]["mts_res"]["m_z__all"].text)>=2){
					root["polk_win"]["mts_cl"]["mts_res"]["m_z__send"].text=2;
				}else{
					root["polk_win"]["mts_cl"]["mts_res"]["m_z__send"].text=root["polk_win"]["mts_cl"]["mts_res"]["m_z__all"].text;
				}
			}
			if(root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text=="0"){
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_fuel"].gotoAndStop("empty");
				root["polk_win"]["mts_cl"]["mts_res"]["fuel_send"].text="0";
			}else{
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_fuel"].gotoAndStop("out");
				if(int(root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text)>=10){
					root["polk_win"]["mts_cl"]["mts_res"]["fuel_send"].text=10;
				}else{
					root["polk_win"]["mts_cl"]["mts_res"]["fuel_send"].text=root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text;
				}
			}
			if(root["polk_win"]["mts_cl"]["mts_res"]["bon1_all"].text=="0"){
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon1"].gotoAndStop("empty");
				root["polk_win"]["mts_cl"]["mts_res"]["bon1_send"].text="0";
			}else{
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon1"].gotoAndStop("out");
				if(int(root["polk_win"]["mts_cl"]["mts_res"]["bon1_all"].text)>=1){
					root["polk_win"]["mts_cl"]["mts_res"]["bon1_send"].text=1;
				}else{
					root["polk_win"]["mts_cl"]["mts_res"]["bon1_send"].text=root["polk_win"]["mts_cl"]["mts_res"]["bon1_all"].text;
				}
			}
			if(root["polk_win"]["mts_cl"]["mts_res"]["bon2_all"].text=="0"){
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon2"].gotoAndStop("empty");
				root["polk_win"]["mts_cl"]["mts_res"]["bon2_send"].text="0";
			}else{
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon2"].gotoAndStop("out");
				if(int(root["polk_win"]["mts_cl"]["mts_res"]["bon2_all"].text)>=1){
					root["polk_win"]["mts_cl"]["mts_res"]["bon2_send"].text=1;
				}else{
					root["polk_win"]["mts_cl"]["mts_res"]["bon2_send"].text=root["polk_win"]["mts_cl"]["mts_res"]["bon2_all"].text;
				}
			}
			if(root["polk_win"]["mts_cl"]["mts_res"]["bon3_all"].text=="0"){
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon3"].gotoAndStop("empty");
				root["polk_win"]["mts_cl"]["mts_res"]["bon3_send"].text="0";
			}else{
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon3"].gotoAndStop("out");
				if(int(root["polk_win"]["mts_cl"]["mts_res"]["bon3_all"].text)>=1){
					root["polk_win"]["mts_cl"]["mts_res"]["bon3_send"].text=1;
				}else{
					root["polk_win"]["mts_cl"]["mts_res"]["bon3_send"].text=root["polk_win"]["mts_cl"]["mts_res"]["bon3_all"].text;
				}
			}
			if(root["polk_win"]["mts_cl"]["mts_res"]["bon4_all"].text=="0"){
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon4"].gotoAndStop("empty");
				root["polk_win"]["mts_cl"]["mts_res"]["bon4_send"].text="0";
			}else{
				root["polk_win"]["mts_cl"]["mts_res"]["to_mts_bon4"].gotoAndStop("out");
				if(int(root["polk_win"]["mts_cl"]["mts_res"]["bon4_all"].text)>=1){
					root["polk_win"]["mts_cl"]["mts_res"]["bon4_send"].text=1;
				}else{
					root["polk_win"]["mts_cl"]["mts_res"]["bon4_send"].text=root["polk_win"]["mts_cl"]["mts_res"]["bon4_all"].text;
				}
			}
			stg_class.panel["money_tx"].text=root["polk_win"]["mts_cl"]["mts_res"]["m_m__all"].text;
			stg_class.panel["skills_tx"].text=root["polk_win"]["mts_cl"]["mts_res"]["m_z__all"].text;
			var radio1_cl:MovieClip=stg_class.panel["ammo0"].find_sl1(21);
			radio1_cl["quantity"]=int(root["polk_win"]["mts_cl"]["mts_res"]["bon1_all"].text);
			radio1_cl.ch_num();
			var radio2_cl:MovieClip=stg_class.panel["ammo0"].find_sl1(22);
			radio2_cl["quantity"]=int(root["polk_win"]["mts_cl"]["mts_res"]["bon2_all"].text);
			radio2_cl.ch_num();
			var radio3_cl:MovieClip=stg_class.panel["ammo0"].find_sl1(23);
			radio3_cl["quantity"]=int(root["polk_win"]["mts_cl"]["mts_res"]["bon3_all"].text);
			radio3_cl.ch_num();
			var remont4_cl:MovieClip=stg_class.panel["ammo0"].find_sl1(19);
			remont4_cl["quantity"]=int(root["polk_win"]["mts_cl"]["mts_res"]["bon4_all"].text);
			remont4_cl.ch_num();
			
			var f_ar:Array=stg_class.shop["fuel_win"]["fuel_tx"].text.split("/");
			
			stg_class.shop["exit"].setVar([int(root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text)]);
			stg_class.shop["fuel_win"]["fuel_tx"].text=root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text+"/"+f_ar[1];
			stg_class.shop["fuel_win"]["fill_cl"].height=(int(root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text)/int(f_ar[1]))*96;
			
			stg_class.panel["fuel_tx"].text=root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text+"/"+f_ar[1];
			stg_class.panel["fuel_bar"].graphics.clear();
			stg_class.panel["fuel_bar"].graphics.beginFill(0x00ff00);
			stg_class.panel["fuel_bar"].graphics.drawRect(.5,.5,(int(root["polk_win"]["mts_cl"]["mts_res"]["fuel_all"].text)/int(f_ar[1]))*87,3);
			
		}
		
		public function setRang(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: звание.");
				erTestReq(9,7,str);
				return;
			}
			//trace("setRang\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else{
					if(int(list.child("err")[0].attribute("onRang"))==0){
						root["polk_win"]["reset_rang"]._state=0;
						root["polk_win"]["reset_rang"].visible=true;
						root["polk_win"]["reset_rang"]["mess_tx"].text="СНЯТ С ДОЛЖНОСТИ!";
						root["polk_win"]["reset_rang"]["polk_out_yes"].visible=root["polk_win"]["reset_rang"]["polk_out_no"].visible=false;
						root["polk_win"]["reset_rang"]["to_rang"].visible=root["polk_win"]["reset_rang"]["inst_out"].visible=true;
					}else{
						//stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}
				}
			}catch(er:Error){
				
			}
			
			resetPolkWin();
			polk_us_id=list.child("err")[0].attribute("user_id");
			for(var i:int=0;i<polk_ar.length;i++){
				if(polk_ar[i]==null)break;
				if(polk_ar[i][6]==polk_us_id){
					polk_ar[i][2]=list.child("err")[0].attribute("polkRang");
					if(int(list.child("err")[0].attribute("onRang"))==0){
						root["polk_win"]["reset_rang"]["name_tx"].text=polk_ar[i][1]+" "+polk_ar[i][0];
						root["polk_win"]["reset_rang"]._state=0;
						root["polk_win"]["reset_rang"].visible=true;
						for(var j:int=0;j<10;j++){
							if(root["polk_win"]["us"+(j)].ava_url==polk_ar[i][3]){
								//trace(root["polk_win"]["us"+(j)].ava_url+"   "+root["polk_win"]["us"+(j)].getChildByName("us_ava").contentLoaderInfo.content);
								root["polk_win"]["reset_rang"]["ava_cl"].graphics.clear();
								root["polk_win"]["reset_rang"]["ava_cl"].graphics.beginBitmapFill(root["polk_win"]["us"+(j)].getChildByName("us_ava").contentLoaderInfo.content.bitmapData);
								root["polk_win"]["reset_rang"]["ava_cl"].graphics.drawRect(0, 0, root["polk_win"]["us"+(j)].getChildByName("us_ava").contentLoaderInfo.content.width, root["polk_win"]["us"+(j)].getChildByName("us_ava").contentLoaderInfo.content.height);
							}
						}
						polk_ar[i][11]=1;
						polk_ar[i][10]=0;
					}else{
						polk_ar[i][11]=0;
						polk_ar[i][10]=1;
					}
				}
			}
			polk_scroll();
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function listAmmo(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: отчисление.");
				erTestReq(9,8,str);
				return;
			}
			//trace("listAmmo\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			resetPolkWin();
			for(var i:int=0;i<list.child("mts_raspred")[0].child("polk_rang").length();i++){
				try{
					if(list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")!=80){
						root["polk_win"]["mts_cl"]["ammo_win"]["rang"+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")].text=list.child("mts_raspred")[0].child("polk_rang")[i].attribute("name");
					}else{
						root["polk_win"]["mts_cl"]["ammo_win"]["rang"+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")].text="Заместители";
					}
					root["polk_win"]["mts_cl"]["ammo_win"]["bon_"+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")+"_0"].text=list.child("mts_raspred")[0].child("polk_rang")[i].attribute("bonus1");
					root["polk_win"]["mts_cl"]["ammo_win"]["bon_"+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")+"_1"].text=list.child("mts_raspred")[0].child("polk_rang")[i].attribute("bonus2");
					root["polk_win"]["mts_cl"]["ammo_win"]["bon_"+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")+"_2"].text=list.child("mts_raspred")[0].child("polk_rang")[i].attribute("bonus3");
					root["polk_win"]["mts_cl"]["ammo_win"]["bon_"+list.child("mts_raspred")[0].child("polk_rang")[i].attribute("id")+"_3"].text=list.child("mts_raspred")[0].child("polk_rang")[i].attribute("bonus4");
				}catch(er:Error){}
			}
			root["polk_win"]["mts_cl"].visible=true;
			root["polk_win"]["mts_cl"]["ammo_win"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function outOfPolk(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: отчисление.");
				erTestReq(9,4,str);
				return;
			}
			//trace("outOfPolk\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["2"]]);
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function createPolk(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: создание.");
				erTestReq(9,1,str);
				return;
			}
			//trace("createPolk\n"+list);
			resetPolkWin();
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))==2){
						if(int(list.child("err")[0].attribute("sn_val_need"))!=0){
							stg_cl.warn_f(9,"");
							var _ar:Array=new Array();
							_ar[0]=function(){
								stg_cl.createMode(2);
							};
							_ar[1]=[function(){
								stg_cl.createMode(1);
							},"buy"];
							_ar[2]=[function(){
								stg_class.wind["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["9"],["2"]]);
							},"showWind1"];
							_ar[3]=[function(){
								stg_class.shop["exit"].clear_buy_ar();
							},"end"];
							_ar[4]=[function(){
								stg_class.wind["choise_cl"].sendRequest(["query","action"],[["id"],["id"]],[["9"],[1+""]]);
							},"re_try"];
							stg_class.shop["exit"].needMoney(_ar,int(list.child("err")[0].attribute("sn_val_need")));
						}
					}else{
						stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					}
					return;
				}else{
					root["set_polk"]["ready_win"]["num_tx"].text=""+list.child("err")[0].attribute("comm");
					root["set_polk"]["ready_win"]["text_tx"].text="Вы назначены командиром войсковой части № "+list.child("err")[0].attribute("comm")+".";
					root["set_polk"].visible=true;
					root["set_polk"]["vznos_cl"].visible=false;
					root["set_polk"]["ready_win"].visible=true;
				}
			}catch(er:Error){
				
			}
			stg_cl["buy_send"]=new Array();
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getPolk(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: главная.");
				erTestReq(9,2,str);
				return;
			}
			//trace("getPolk\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			resetPolkWin();
			if(int(list.child("polk")[0].attribute("id"))==0){
				root["set_polk"].visible=true;
				root["set_polk"]["vznos_cl"].visible=false;
				root["set_polk"]["ready_win"].visible=false;
				root["polk_win"].visible=false;
				stg_class.chat_cl.room_exit(2);
			}else{
				root["set_polk"].visible=false;
				root["set_polk"]["vznos_cl"].visible=false;
				root["set_polk"]["ready_win"].visible=false;
				stg_cl["polk_id"]=list.child("polk")[0].attribute("id");
				root["polk_win"]["num_tx"].text="В/Ч "+list.child("polk")[0].attribute("id")+" "+list.child("polk")[0].attribute("name");
				root["polk_win"].visible=true;
				polk_ar=new Array();
				for(var i:int=0;i<list.child("polk")[0].child("user").length();i++){
					var _p_ar:Array=new Array();
					_p_ar[0]=list.child("polk")[0].child("user")[i].attribute("name");
					_p_ar[1]=list.child("polk")[0].child("user")[i].attribute("rang");
					_p_ar[2]=list.child("polk")[0].child("user")[i].attribute("polk_rang");
					_p_ar[3]=list.child("polk")[0].child("user")[i].attribute("ava");
					_p_ar[4]=list.child("polk")[0].child("user")[i].attribute("sn_link");
					_p_ar[5]=list.child("polk")[0].child("user")[i].attribute("status");
					_p_ar[6]=list.child("polk")[0].child("user")[i].attribute("sn_id");
					_p_ar[7]=list.child("polk")[0].child("user")[i].attribute("fuel");
					_p_ar[8]=list.child("polk")[0].child("user")[i].attribute("fuel_max");
					_p_ar[9]=list.child("polk")[0].child("user")[i].attribute("mh1");
					_p_ar[10]=list.child("polk")[0].child("user")[i].attribute("mh2");
					_p_ar[11]=list.child("polk")[0].child("user")[i].attribute("mh3");
					_p_ar[12]=list.child("polk")[0].child("user")[i].attribute("mh4");
					_p_ar[13]=list.child("polk")[0].child("user")[i].attribute("me");
					_p_ar[14]=list.child("polk")[0].child("user")[i].attribute("reid");
					if(_p_ar[5]==0){
						polk_ar.push(_p_ar);
					}else{
						polk_ar.unshift(_p_ar);
					}
					if(stg_cl["v_id"]==_p_ar[6]){
						if(list.child("polk")[0].child("user")[i].attribute("boss")!=0){
							stg_class.chat_cl.polkSet(list.child("polk")[0].attribute("room"));
							root["polk_win"]["delete_polk"].visible=true;
							root["polk_win"]["leave_polk"].visible=false;
						}else{
							stg_class.chat_cl.polkSet(list.child("polk")[0].attribute("room"),1);
							root["polk_win"]["delete_polk"].visible=false;
							root["polk_win"]["leave_polk"].visible=true;
						}
						var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, unLoadGroup);
						loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
						loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadGroup);
						root["polk_win"]["reset_rang"].ldr_ava=loader;
						loader.load(new URLRequest(stg_class.res_url+"/"+_p_ar[3]));
					}
					//trace(polk_ar[i]);
				}
				polk_sc=0;
				root["polk_win"]["scroll_cl"]["sc"].y=root["polk_win"]["scroll_cl"]["rect"].y;
				/*root["polk_win"]["scroll_cl"]["up"].scaleX=root["polk_win"]["scroll_cl"]["up"].scaleY=1.5;
				root["polk_win"]["scroll_cl"]["down"].scaleX=root["polk_win"]["scroll_cl"]["down"].scaleY=1.5;
				root["polk_win"]["scroll_cl"]["up"].x-=5;
				root["polk_win"]["scroll_cl"]["up"].y-=5;
				root["polk_win"]["scroll_cl"]["down"].x-=5;
				//root["polk_win"]["scroll_cl"]["down"].y-=5;*/
				polk_scroll();
			}
			stg_cl.warn_f(9,"");
			try{stg_class.shop["exit"].buy_mem("re_try");}catch(er:Error){}
			try{stg_class.shop["exit"].buy_mem("end");}catch(er:Error){}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function getMts(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nПолк: мтс.");
				erTestReq(9,5,str);
				return;
			}
			//trace("getMts\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			
			resetPolkWin();
			root["polk_win"]["mts_cl"]["m_m_tx"].text=list.child("mts")[0].attribute("money_m");
			root["polk_win"]["mts_cl"]["m_z_tx"].text=list.child("mts")[0].attribute("money_z");
			for(var i:int=0;i<3;i++){
				if(list.child("mts")[0].attribute("fuel"+(i+1))>0){
					root["polk_win"]["mts_cl"]["bak"+i]["num_cl"]["num_tx"].text=list.child("mts")[0].attribute("fuel"+(i+1));
					root["polk_win"]["mts_cl"]["bak"+i]["num_cl"].visible=true;
				}else{
					root["polk_win"]["mts_cl"]["bak"+i]["num_cl"].visible=false;
				}
			}
			for(var i:int=0;i<4;i++){
				root["polk_win"]["mts_cl"]["ammo_tx"+i].text=list.child("mts")[0].attribute("bonus"+(i+1));
			}
			root["polk_win"]["mts_cl"]["fuel_tx"].text="В наличии: "+list.child("mts")[0].attribute("fuel")+"/"+list.child("mts")[0].attribute("fuel_max");
			root["polk_win"]["mts_cl"]["fill"].scaleX=list.child("mts")[0].attribute("fuel")/list.child("mts")[0].attribute("fuel_max");
			root["polk_win"]["mts_cl"].visible=true;
			
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function resetPolkWin(){
			root["polk_win"]["ustav_cl"].visible=false;
			root["polk_win"]["mts_cl"].visible=false;
			root["polk_win"]["mts_cl"]["ammo_win"].visible=false;
			root["polk_win"]["mts_cl"]["mts_res"].visible=false;
			root["polk_win"]["mts_cl"]["otchet_win"].visible=false;
			root["polk_win"]["mts_cl"]["obmen"].visible=false;
			root["polk_win"]["call_win"].visible=false;
			root["polk_win"]["set_rang"].visible=false;
			root["polk_win"]["reset_rang"].visible=false;
			root["polk_win"]["opt_win"].visible=false;
			root["polk_win"]["znamja_win"].visible=false;
			root["polk_win"]["znamja_win"]["buy_zn_win"].visible=false;
			root["polk_win"]["znamja_win"]["zn_warn"].visible=false;
			root["polk_win"]["reid_win"].visible=false;
			root["polk_win"]["polk_plan"].visible=false;
			root["polk_win"]["polk_rep"].visible=false;
			vipReset();
		}
		
		public function polk_scroll(){
			for(var i:int=0;i<10;i++){
				if(i+polk_sc*5<polk_ar.length&&polk_ar[i+polk_sc*5]!=null){
					//trace(root["polk_win"]["us"+(i)]+"   "+polk_ar[i+polk_sc][0]);
					root["polk_win"]["us"+(i)]["empty_cl"].visible=false;
					root["polk_win"]["us"+(i)]["rang_tx"].text=polk_ar[i+polk_sc*5][1];
					root["polk_win"]["us"+(i)]["name_tx"].text=polk_ar[i+polk_sc*5][0];
					root["polk_win"]["us"+(i)]["state_tx"].text=polk_ar[i+polk_sc*5][2];
					/*try{
						//trace(root["polk_win"]["us"+(i)].getChildByName("us_ava").loaderInfo.url);
						//trace(root["polk_win"]["us"+(i)].getChildByName("us_ava").loaderInfo.loaderURL);
					}catch(er:Error){}*/
					if(root["polk_win"]["us"+(i)].ava_url!=polk_ar[i+polk_sc*5][3]){
						try{
							root["polk_win"]["us"+(i)].removeChild(root["polk_win"]["us"+(i)].getChildByName("us_ava"));
							//root["polk_win"]["us"+(i)].getChildByName("us_ava")=null;
						}catch(er:Error){
							
						}
						try{
							root["polk_win"]["us"+(i)].removeChild(root["polk_win"]["us"+(i)].getChildByName("us_reid"));
							//root["polk_win"]["us"+(i)].getChildByName("us_ava")=null;
						}catch(er:Error){
							
						}
						var loader:Loader = new Loader();
						loader.name="us_ava";
						root["polk_win"]["us"+(i)].ava_url=polk_ar[i+polk_sc*5][3];
						loader.x=3;
						loader.y=32;
						root["polk_win"]["us"+(i)].addChild(loader);
						if(polk_ar[i+polk_sc*5][14]==1){
							var _mc:MovieClip=new MovieClip();
							_mc.name="us_reid";
							_mc.x=3;
							_mc.y=32;
							_mc.graphics.clear();
							_mc.graphics.lineStyle(3,0x009900);
							_mc.graphics.beginFill(0x009900,.3);
							_mc.graphics.drawRect(0,0,54,84);
							root["polk_win"]["us"+(i)].addChild(_mc);
						}
						//loader.contentLoaderInfo.addEventListener(Event.OPEN, openGroup );
						//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressGroup);
						//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event){trace(event.currentTarget.content)});
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, unLoadGroup);
						loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
						loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadGroup);
						
						loader.load(new URLRequest(stg_class.res_url+"/"+polk_ar[i+polk_sc*5][3]));
					}
					if(polk_ar[i+polk_sc*5][5]==0){
						try{
							root["polk_win"]["us"+(i)].getChildByName("us_ava").alpha=.5;
						}catch(er:Error){
							
						}
					}else{
						try{
							root["polk_win"]["us"+(i)].getChildByName("us_ava").alpha=1;
						}catch(er:Error){
							
						}
					}
				}else{
					try{
						root["polk_win"]["us"+(i)].removeChild(root["polk_win"]["us"+(i)].getChildByName("us_ava"));
						//root["polk_win"]["us"+(i)].getChildByName("us_ava")=null;
					}catch(er:Error){
						
					}
					try{
						root["polk_win"]["us"+(i)].removeChild(root["polk_win"]["us"+(i)].getChildByName("us_reid"));
						//root["polk_win"]["us"+(i)].getChildByName("us_ava")=null;
					}catch(er:Error){
						
					}
					root["polk_win"]["us"+(i)]["empty_cl"].visible=true;
					root["polk_win"]["us"+(i)].ava_url="";
				}
			}
		}
		
		public static var polk_ar:Array=new Array();
		public static var polk_sc:int=0;
		
		public static var f_choise:Boolean=false;
		public static var f_choise1:Boolean=false;
		
		public function erTestReq(a:int,b:int,c:String){
			//trace(uid+"   "+a+"   "+b+"   "+c);
			var reslt_s:String=c;
			var strXML:String="<query id=\"111\" id_u=\""+stg_cl["v_id"]+"\" query=\"\" log_query="+"\""+a+"\""+" log_action="+"\""+b+"\" />";
			var rqs:URLRequest=new URLRequest(serv_url+"?query="+111+"&action="+0);
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
		
		public static var myPattern:RegExp =  /\r\n/gi;
		public static var myPattern1:RegExp = /\r\r/gi;
		public static var myPattern2:RegExp = /\n\n/gi;
		public static var myPattern3:RegExp = /\n\r/gi;
		public static var myPattern4:RegExp = /\\n/gi;
		public static var myPattern5:RegExp = /~\s*</gi;
		public static var myPattern6:RegExp = />\s*~/gi;
		
		public function new_line_s(_s:String,_i:int=0):String{
			var _text:String=_s;
			//trace(_s);
			if(_i==0){
				_text=_text.substr(_text.search(">")+1);
				//_text=_text.replace(/>\S*~/gi, "");
				_text=_text.replace(myPattern5, "<");
				_text=_text.replace(myPattern6, ">");
			}
			_text=_text.replace(myPattern, "\n");
			_text=_text.replace(myPattern1,"\n");
			_text=_text.replace(myPattern2,"\n");
			_text=_text.replace(myPattern3,"\n");
			_text=_text.replace(myPattern4,"\n");
			if(_i==0){
				while(_text.charAt(0).search(/\s/gi)>=0){
					_text=_text.substr(1);
				}
			}
			return _text;
		}
		
		public function new_line_f(cl:MovieClip,_s:String):void{
			cl.i_text=new_line_s(_s,1);
		}
		
		public function listCombat(event:Event):void{
			if(stg_class.m_mode==3||root["ready_cl"].visible){
				stopCall();
				stopAr();
				stopStatus();
				return;
			}
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				try{
					mTimer.stop();
				}catch(e:Error){
					
				}
				t_count=0;
				t_over=true;
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nСписок боёв 1.");
				erTestReq(3,1,str);
				return;
			}
			//trace("listCombat=\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					try{
						mTimer.stop();
					}catch(e:Error){
						
					}
					w_time=0;
					t_count=0;
					t_over=true;
					if(int(list.child("err")[0].attribute("code"))==3){
						root["win_cl"].visible=false;
						root["win_cl1"].visible=false;
						root["ready_cl"].visible=false;
						root["wait_cl"].visible=false;
						root["warn_cl"].visible=false;
						root["empt_cl"].visible=false;
						root["diff_win"].visible=false;
						root["arena_cl"].visible=false;
						stg_cl.warn_f(9,"");
						return;
					}
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl.warn_f(9,"");
			var s1:String="battles";
			var s2:String="battle";
			root["empt_cl"].visible=false;
			w_time=0;
			if(int(list.child(s1)[0].attribute("fuel"))<int(list.child(s1)[0].attribute("fuel_need"))){
				root["warn_cl"].visible=true;
				root["win_cl"].visible=false;
				root["win_cl1"].visible=false;
				root["ready_cl"].visible=false;
				root["wait_cl"].visible=false;
				root["warn_cl"].visible=true;
				root["empt_cl"].visible=false;
				root["diff_win"].visible=false;
				root["arena_cl"].visible=false;
				stg_cl.warn_f(9,"");
				return;
			}
			//trace(list.child(s1)[0].attribute("fuel")+"   "+list.child(s1)[0].attribute("fuel_need"));
			//root["warn_cl"].visible=true;
			try{
				root["win_cl"]["ch_info"].i_text=list.child(s1)[0].attribute("descr");
				root["win_cl"]["ch1_info"].i_text=list.child(s1)[0].attribute("descr1");
				root["win_cl"]["ch2_info"].i_text=list.child(s1)[0].attribute("descr2");
				new_line_f(root["win_cl"]["ch_info"],root["win_cl"]["ch_info"].i_text);
				new_line_f(root["win_cl"]["ch1_info"],root["win_cl"]["ch1_info"].i_text);
				new_line_f(root["win_cl"]["ch2_info"],root["win_cl"]["ch2_info"].i_text);
				for(var i:int=1;i<9;i++){
					if(!f_choise){
						root["win_cl"]["b"+i]["press_cl"].visible=false;
					}
					if(i-1<list.child(s1)[0].child(s2).length()){
						root["win_cl"]["b"+i].visible=true;
						root["win_cl"]["b"+i+"_tx"].visible=true;
						root["win_cl"]["b"+i]["id"]=list.child(s1)[0].child(s2)[i-1].attribute("id");
						root["win_cl"]["b"+i+"_tx"].text=list.child(s1)[0].child(s2)[i-1].attribute("name");
						root["win_cl"]["bat_info"+i].i_text=list.child(s1)[0].child(s2)[i-1].attribute("descr");
						new_line_f(root["win_cl"]["bat_info"+i],root["win_cl"]["bat_info"+i].i_text);
						/*if(root["win_cl"]["b"+i+"_tx"].text=="Каждый за себя"){
							self_battle=true;
						}*/
					}else{
						//root["win_cl"]["b"+i]["press_cl"].visible=false;
						root["win_cl"]["b"+i].visible=false;
						root["win_cl"]["b"+i+"_tx"].visible=false;
					}
				}
			}catch(er:Error){
				
			}
			if(stg_class.help_on){
				if(stg_class.help_st==8){
					root["win_cl"].visible=true;
					for(var i:int=1;i<8;i++){
						root["win_cl"]["b"+i]["press_cl"].visible=false;
						//root["win_cl"]["b"+i]["id"]=-1;
					}
					root["win_cl"]["b8"]["press_cl"].visible=false;
				}else if(stg_class.help_st==9){
					root["win_cl"].visible=true;
					for(var i:int=1;i<8;i++){
						root["win_cl"]["b"+i]["press_cl"].visible=false;
						//root["win_cl"]["b"+i]["id"]=-1;
					}
					root["win_cl"]["b8"]["press_cl"].visible=true;
				}
			}
			f_choise=true;
			////trace(mTimer);
			try{
				mTimer.stop();
			}catch(e:Error){
				
			}
			t_count=0;
			t_over=true;
			//trace(t_over);
			root["wait_cl"].visible=false;
			root["win_cl"].visible=true;
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function listCombat1(event:Event):void{
			if(stg_class.m_mode==3||root["ready_cl"].visible){
				stopCall();
				stopAr();
				stopStatus();
				return;
			}
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nСписок боёв 2.");
				erTestReq(7,7,str);
				return;
			}
			//trace("listCombat1=\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl.warn_f(9,"");
			var s1:String="battles";
			var s2:String="battle";
			di_id=[new Array(),new Array(),new Array()];
			di_tx=[new Array(),new Array(),new Array()];
			root["empt_cl"].visible=false;
			if(int(list.child(s1)[0].attribute("fuel"))<int(list.child(s1)[0].attribute("fuel_need"))){
				root["warn_cl"].visible=true;
				root["win_cl"].visible=false;
				root["win_cl1"].visible=false;
				root["ready_cl"].visible=false;
				root["wait_cl"].visible=false;
				root["warn_cl"].visible=true;
				root["empt_cl"].visible=false;
				root["diff_win"].visible=false;
				root["arena_cl"].visible=false;
				stg_cl.warn_f(9,"");
				return;
			}
			for(var j:int=0;j<list.child(s1).length();j++){
				if(int(list.child(s1)[j].attribute("num"))==999){
					//try{
						for(var i:int=0;i<3;i++){
							if(i<list.child(s1)[j].child(s2).length()){
								root["win_cl1"]["gr_c"+i]["id"]=list.child(s1)[j].child(s2)[i].attribute("id");
								root["win_cl1"]["bat_gr_info"+i].i_text=list.child(s1)[j].child(s2)[i].attribute("descr");
								new_line_f(root["win_cl1"]["bat_gr_info"+i],root["win_cl1"]["bat_gr_info"+i].i_text);
								if(int(list.child(s1)[j].child(s2)[i].attribute("hidden"))==0){
									root["win_cl1"]["gr_c"+i].gotoAndStop("out");
								}else{
									root["win_cl1"]["gr_c"+i].gotoAndStop("empty");
								}
							}else{
								root["win_cl1"]["gr_c"+i].gotoAndStop("empty");
							}
						}
					//}catch(er:Error){
						
					//}
					root["win_cl1"].visible=true;
				}else if(int(list.child(s1)[j].attribute("num"))==2){
					try{
						for(var i:int=4;i<7;i++){
							if(i-4<list.child(s1)[j].child(s2).length()){
								root["win_cl1"]["b"+i+"_tx"].visible=true;
								root["win_cl1"]["gr_c"+i]["id"]=list.child(s1)[j].child(s2)[i-4].attribute("id");
								root["win_cl1"]["b"+i+"_tx"].text=list.child(s1)[j].child(s2)[i-4].attribute("name");
								root["win_cl1"]["bat_gr_info"+i].i_text=list.child(s1)[j].child(s2)[i-4].attribute("descr");
								new_line_f(root["win_cl1"]["bat_gr_info"+i],root["win_cl1"]["bat_gr_info"+i].i_text);
								if(int(list.child(s1)[j].child(s2)[i-4].attribute("hidden"))==0){
									root["win_cl1"]["gr_c"+i].visible=true;
									root["win_cl1"]["b"+i+"_tx"].textColor=0x9A0700;
									root["win_cl1"]["gray"+i].visible=false;
								}else{
									root["win_cl1"]["gr_c"+i].visible=false;
									root["win_cl1"]["b"+i+"_tx"].textColor=0x333333;
									root["win_cl1"]["gray"+i].visible=true;
								}
							}else{
								root["win_cl1"]["gr_c"+i].visible=false;
								root["win_cl1"]["b"+i+"_tx"].visible=false;
							}
						}
					}catch(er:Error){
						
					}
					root["win_cl1"].visible=true;
				}else if(int(list.child(s1)[j].attribute("num"))>3){
					if(int(list.child(s1)[j].attribute("num"))==4){
						for(var i:int=0;i<list.child(s1)[j].child(s2).length();i++){
							di_id[0].push(list.child(s1)[j].child(s2)[i].attribute("id"));
							di_tx[0].push(list.child(s1)[j].child(s2)[i].attribute("name"));
						}
					}else if(int(list.child(s1)[j].attribute("num"))==8){
						for(var i:int=0;i<list.child(s1)[j].child(s2).length();i++){
							di_id[1].push(list.child(s1)[j].child(s2)[i].attribute("id"));
							di_tx[1].push(list.child(s1)[j].child(s2)[i].attribute("name"));
						}
					}else if(int(list.child(s1)[j].attribute("num"))==9){
						for(var i:int=0;i<list.child(s1)[j].child(s2).length();i++){
							di_id[2].push(list.child(s1)[j].child(s2)[i].attribute("id"));
							di_tx[2].push(list.child(s1)[j].child(s2)[i].attribute("name"));
						}
					}
				}
				var diff_lev:int=0;
				for(var i:int=0;i<di_id.length;i++){
					if(di_id[i].length>0){
						root["diff_win"]["diff_vkl"+i].visible=true;
						root["diff_win"]["diff_vkl"+i].gotoAndStop("out");
						if(diff_lev==0){
							root["diff_win"]["diff_vkl"+i].gotoAndStop("empty");
							root["diff_win"]["scroll_cl"]["sc"].y=root["diff_win"]["scroll_cl"]["rect"].y;
							di_cnt=0;
							di_type=i;
							drawDiff();
							root["diff_win"].visible=true;
							diff_lev=1;
						}
					}else{
						root["diff_win"]["diff_vkl"+i].visible=false;
					}
				}
			}
			f_choise1=true;
			////trace(mTimer);
			try{
				mTimer.stop();
			}catch(e:Error){
				
			}
			t_count=0;
			t_over=true;
			//trace(t_over);
			root["wait_cl"].visible=false;
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var di_id:Array=new Array();
		public static var di_tx:Array=new Array();
		public static var di_type:int=0;
		
		public function drawDiff(){
			//trace(di_cnt+"   "+di_type+"   "+di_id[di_type].length);
			try{
				for(var i:int=0;i<13;i++){
					if(i+di_cnt<di_id[di_type].length){
						root["diff_win"]["tx"+i].visible=true;
						root["diff_win"]["go"+i].visible=true;
						root["diff_win"]["go"+i]["id"]=di_id[di_type][i+di_cnt];
						root["diff_win"]["tx"+i].text=di_tx[di_type][i+di_cnt];
					}else{
						root["diff_win"]["go"+i].visible=false;
						root["diff_win"]["tx"+i].visible=false;
					}
				}
			}catch(er:Error){
				
			}
		}
		
		public function listCombat2(event:Event):void{
			if(stg_class.m_mode==3||root["ready_cl"].visible){
				stopCall();
				stopAr();
				stopStatus();
				return;
			}
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nСписок боёв 3.");
				erTestReq(8,2,str);
				return;
			}
			//trace("listCombat2=\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl.warn_f(9,"");
			var s1:String="arena";
			root["empt_cl"].visible=false;
			if(!root["arena_cl"].visible){
				root["arena_cl"]["out_ar_ww"].visible=false;
			}
			/*if(int(list.child(s1)[0].attribute("fuel"))<int(list.child(s1)[0].attribute("fuel_need"))){
				root["warn_cl"].visible=true;
			}*/
			//root["arena_cl"].visible=false;
			//trace(new_line_s(list.child(s1)[0].child("raiting")[0].child("name")));
			root["arena_cl"]["arn_name0"].htmlText=new_line_s(list.child(s1)[0].child("raiting")[0].child("name"));
			root["arena_cl"]["arn_text0"].htmlText=new_line_s(list.child(s1)[0].child("raiting")[0].child("descr"));
			root["arena_cl"]["arn_info0"].i_text=list.child(s1)[0].child("raiting")[0].child("descr1");
			
			if(int(list.child(s1)[0].child("group")[0].attribute("hidden"))!=0){
				root["arena_cl"]["go_ar_b"].gotoAndStop("empty");
			}else{
				root["arena_cl"]["go_ar_b"].gotoAndStop("out");
			}
			root["arena_cl"]["arn_name1"].htmlText=new_line_s(list.child(s1)[0].child("group")[0].child("name"));
			root["arena_cl"]["arn_text1"].htmlText=new_line_s(list.child(s1)[0].child("group")[0].child("descr"));
			root["arena_cl"]["arn_info1"].i_text=list.child(s1)[0].child("group")[0].child("descr1");
			
			root["arena_cl"]["arn_name2"].htmlText=new_line_s(list.child(s1)[0].child("state")[0].child("name"));
			root["arena_cl"]["arn_text2"].htmlText=new_line_s(list.child(s1)[0].child("state")[0].child("descr"));
			root["arena_cl"]["arn_info2"].i_text=list.child(s1)[0].child("state")[0].child("descr1");
			
			root["arena_cl"]["time_tx"].htmlText=new_line_s(list.child(s1)[0].child("time_arena")[0].child("descr"));
			stg_class.chat_cl.time=root["arena_cl"]["time_tx"].text;
			root["arena_cl"]["arn_info3"].i_text=list.child(s1)[0].child("time_arena")[0].child("descr1");
			
			root["arena_cl"].visible=true;
			try{
				mTimer.stop();
			}catch(e:Error){
				
			}
			try{
				arTimer.stop();
			}catch(e:Error){
				
			}
			t_count=0;
			t_over=true;
			root["wait_cl"].visible=false;
			arTimer=new Timer(5000, 1);
			arTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ar_over);
			arTimer.start();
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function ar_over(event:TimerEvent):void{
			//trace("relist");
			sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["2"]]);
		}
		
		public function addCombat2(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВыбор боя 1.");
				erTestReq(7,9,str);
				return;
			}
			//trace("addCombat2="+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl.warn_f(9,"");
			var id_str:String="<query id=\"3\"><action id=\"2\">";
			var ready_pl:Boolean=false;
			for(var i:int=1;i<4;i++){
				if(root["win_cl1"]["gr_c"+i].visible){
					if(root["win_cl1"]["gr_c"+i]["press_cl"].visible){
						if(root["win_cl1"]["gr_c"+i]["id"]>-1){
							id_str+="<battle id=\""+root["win_cl1"]["gr_c"+i]["id"]+"\" />";
							ready_pl=true;
						}
					}
				}
			}
			if(!ready_pl){
				sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["3"]]);
				return;
			}
			id_str+="</action></query>";
			sendCombats(id_str,true,1);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function addCombat1(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВыбор боя 2.");
				erTestReq(7,9,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl.warn_f(9,"");
			sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["6"]]);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function addCombat(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nВыбор боя 3.");
				erTestReq(3,2,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					try{
						mTimer.stop();
					}catch(e:Error){
					
					}
					return;
				}
			}catch(er:Error){
				
			}
			stg_cl.warn_f(9,"");
			//trace("addCombat=\n"+list);
			//trace(t_over);
			
			if(list.child("rPanel").length()>0){
				var list1:XML=list.child("rPanel")[0];
				//trace("panel for battle:\n"+list1+"\n\n");
				stg_class.panel["ammo0"].parsePanel(list1);
			}
			
			var s1:String="battle";
			var s2:String="battle_now";
			////trace(list.child(s1).length());
			////trace(list.child(s2).length());
			if(list.child(s2).length()>0){
				//trace("listBattle=\n"+list);
				try{
					mTimer.stop();
				}catch(e:Error){
				
				}
				root["empt_cl"].visible=false;
				stg_class.panel["waiting_cl"].visible=false;
				root["arena_cl"].visible=false;
				stg_cl.createMode(1);
				stg_class.panel["buy_val"].gotoAndStop("empty");
				stg_class.panel["arsenal_b"].gotoAndStop("empty");
				stopCall();
				stopAr();
				stopStatus();
				stg_cl.warn_f(9,"");
				if(stg_class.help_on){
					try{
						stg_cl.removeChild(stg_class.help_cl);
					}catch(er:Error){
						
					}
					if(stg_class.help_st==9){
						stg_class.help_st=10;
					}
				}
				t_over=true;
				t_count=0;
				//stg_class.inv_cl["tank_sl"].sendRequest(["query","action"],[["id"],["id"]],[["1"],["15"]]);   // мини-профиль
				try{
					if(stg_cl["socket"]==null){
						//trace("connect");
						root["ready_cl"]["battle_tx"].text="Выбран сценарий: "+list.child(s2)[0].attribute("name");
						if(int(list.child(s2)[0].attribute("no_exit"))==0){
							stg_class.exit_on=true;
						}else{
							stg_class.exit_on=false;
						}
						root["ready_cl"]["w_znaki"].text=list.child(s2)[0].attribute("w_money_z");
						root["ready_cl"]["l_znaki"].text=list.child(s2)[0].attribute("l_money_z");
						root["ready_cl"]["w_money"].text=list.child(s2)[0].attribute("w_money_m");
						root["ready_cl"]["l_money"].text=list.child(s2)[0].attribute("l_money_m");
						root["ready_cl"]["podsk_cl"]["descr_tx"].text=list.child(s2)[0].attribute("message");
						root["ready_cl"].visible=true;
						root["win_cl"].visible=false;
						root["wait_cl"].visible=false;
						var map_num:int=int(list.child(s2)[0].attribute("id"));
						//trace("new metka1   "+list.child(s2)[0].attribute("id"));
						if(int(list.child(s2)[0].attribute("kill_am_all"))==1){
							stg_class.self_battle=true;
						}else{
							stg_class.self_battle=false;
						}
						stg_class.panel["ammo0"].setLevTime((int(list.child(s2)[0].attribute("time"))*40)/1000);
						stg_class.map_id[0]=int(map_num/(Math.pow(256,3)));
						stg_class.map_id[1]=int(map_num/(Math.pow(256,2)));
						stg_class.map_id[2]=int(map_num/256);
						stg_class.map_id[3]=int(map_num%256);
						for(var n:int=0;n<stg_class.map_id.length;n++){
							if(stg_class.map_id[n]>255){
								stg_class.map_id[n]=stg_class.map_id[n]%256;
							}
						}
						//trace("1   "+map_num+"   "+stg_class.map_id);
						stg_class.serv_url=list.child(s2)[0].attribute("host");
						stg_class.port_num=int(list.child(s2)[0].attribute("port"));
						stg_cl["f_num"]=int(list.child(s2)[0].attribute("num"));
						//stg_cl.createMode(3);
						stg_cl.LoadMap();
						try{
							stg_cl.playSound("begin",1);
						}catch(e:Error){
							//trace("Select combat error: "+e);
						}
					}else{
						//trace("double connect");
					}
				}catch(e:Error){
					//trace("Select combat error: "+e);
				}
			}else{
				try{
					stg_cl.removeChild(stg_class.help_cl);
				}catch(er:Error){
					
				}
				if(t_over){
					root["wait_cl"]["fill"].width=0;
					root["ready_cl"].visible=false;
					root["win_cl"].visible=false;
					root["win_cl1"].visible=false;
					root["wait_cl"].visible=true;
					if(!root["group_win"].visible){
						for(var i:int=0;i<8;i++){
							root["wait_cl"]["f"+i].visible=true;
							root["wait_cl"]["f"+i]["c_tx"].visible=true;
							root["wait_cl"]["f"+i]["f_tx"].text=list.child(s1)[i].attribute("name")+"";
							root["wait_cl"]["f"+i]["c_tx"].text="["+list.child(s1)[i].attribute("count")+"/"+list.child(s1)[i].attribute("count_max")+"]";
							root["wait_cl"]["f"+i]["w_flag"]["id"]=int(list.child(s1)[i].attribute("id"));
							for(var j:int=0;j<8;j++){
								if(int(list.child(s1)[j].attribute("id"))==root["win_cl"]["b"+(i+1)]["id"]){
									if(root["win_cl"]["b"+(i+1)].visible&&root["win_cl"]["b"+(i+1)]["press_cl"].visible&&root["win_cl"]["b"+(i+1)]["id"]>-1){
										root["wait_cl"]["f"+j]["do_now"].visible=true;
										root["wait_cl"]["f"+j]["w_flag"]["press_cl"].visible=true;
										var color_cl:ColorTransform=new ColorTransform();
										color_cl.color=0x00CC00;
										root["wait_cl"]["f"+j]["do_now"].transform.colorTransform = color_cl;
										root["wait_cl"]["f"+j]["f_tx"].textColor=0xffffff;
										root["wait_cl"]["f"+j]["c_tx"].textColor=0xffffff;
									}else{
										root["wait_cl"]["f"+j]["w_flag"]["press_cl"].visible=false;
										var color_cl:ColorTransform=new ColorTransform();
										color_cl.color=0x9A9A9A;
										root["wait_cl"]["f"+j]["do_now"].transform.colorTransform = color_cl;
										root["wait_cl"]["f"+j]["f_tx"].textColor=0xffffff;
										root["wait_cl"]["f"+j]["c_tx"].textColor=0xffffff;
									}
								}
							}
						}
					}else{
						for(var i:int=0;i<8;i++){
							root["wait_cl"]["f"+i]["w_flag"]["press_cl"].visible=false;
							var color_cl:ColorTransform=new ColorTransform();
							color_cl.color=0x9A9A9A;
							root["wait_cl"]["f"+i]["do_now"].transform.colorTransform = color_cl;
							root["wait_cl"]["f"+i]["f_tx"].textColor=0xffffff;
							root["wait_cl"]["f"+i]["c_tx"].textColor=0xffffff;
							root["wait_cl"]["f"+i].visible=true;
							root["wait_cl"]["f"+i]["c_tx"].visible=true;
							root["wait_cl"]["f"+i]["f_tx"].text=list.child(s1)[i].attribute("name")+"";
							root["wait_cl"]["f"+i]["c_tx"].text="["+list.child(s1)[i].attribute("count")+"/"+list.child(s1)[i].attribute("count_max")+"]";
							root["wait_cl"]["f"+i]["w_flag"]["id"]=int(list.child(s1)[i].attribute("id"));
						}
						/*for(var i:int=0;i<3;i++){
							for(var j:int=0;j<8;j++){
								if(int(list.child(s1)[j].attribute("id"))==root["win_cl1"]["gr_c"+(i+1)]["id"]){
									//trace(root["win_cl1"]["gr_c"+(i+1)]["id"]+"   "+root["win_cl1"]["gr_c"+(i+1)].visible+"   "+root["win_cl1"]["gr_c"+(i+1)]["press_cl"].visible);
									if(root["win_cl1"]["gr_c"+(i+1)].visible&&root["win_cl1"]["gr_c"+(i+1)]["press_cl"].visible&&root["win_cl1"]["gr_c"+(i+1)]["id"]>-1){
										root["wait_cl"]["f"+j]["do_now"].visible=true;
										root["wait_cl"]["f"+j]["w_flag"]["press_cl"].visible=true;
										var color_cl:ColorTransform=new ColorTransform();
										color_cl.color=0x00CC00;
										root["wait_cl"]["f"+j]["do_now"].transform.colorTransform = color_cl;
										root["wait_cl"]["f"+j]["f_tx"].textColor=0xffffff;
										root["wait_cl"]["f"+j]["c_tx"].textColor=0xffffff;
									}else{
										root["wait_cl"]["f"+j]["w_flag"]["press_cl"].visible=false;
										var color_cl:ColorTransform=new ColorTransform();
										color_cl.color=0x9A9A9A;
										root["wait_cl"]["f"+j]["do_now"].transform.colorTransform = color_cl;
										root["wait_cl"]["f"+j]["f_tx"].textColor=0xffffff;
										root["wait_cl"]["f"+j]["c_tx"].textColor=0xffffff;
									}
								}
							}
						}*/
					}
					/*if(new_inf){
						root["wait_cl"]["wt_info"].hideInfo();
						root["wait_cl"]["wt_info"].showInfo(wait_info);
					}*/
					m_time=30;
					if(m_time<1){
						m_time=1;
						root["wait_cl"]["fill"].width=201;
						root["wait_cl"]["wait_tx"].text=0+":"+0;
					}else{
						var t1:String=int((w_time)/60)+"";
						var t2:String=int((w_time)%60)+"";
						if(t1.length==1){
							t1="0"+t1;
						}
						if(t2.length==1){
							t2="0"+t2;
						}
						root["wait_cl"]["wait_tx"].text=t1+":"+t2;
					}
					try{
						mTimer.stop();
					}catch(e:Error){
					
					}
					t_count=0;
					mTimer=new Timer(1000, m_time);
					mTimer.addEventListener(TimerEvent.TIMER, waiting);
					mTimer.addEventListener(TimerEvent.TIMER_COMPLETE, time_over);
					mTimer.start();
				}else{
					if(!root["group_win"].visible){
						for(var i:int=0;i<8;i++){
							root["wait_cl"]["f"+i].visible=true;
							root["wait_cl"]["f"+i]["c_tx"].visible=true;
							root["wait_cl"]["f"+i]["f_tx"].text=list.child(s1)[i].attribute("name")+"";
							root["wait_cl"]["f"+i]["c_tx"].text="["+list.child(s1)[i].attribute("count")+"/"+list.child(s1)[i].attribute("count_max")+"]";
							root["wait_cl"]["f"+i]["w_flag"]["id"]=int(list.child(s1)[i].attribute("id"));
							for(var j:int=0;j<8;j++){
								if(int(list.child(s1)[j].attribute("id"))==root["win_cl"]["b"+(i+1)]["id"]){
									if(root["win_cl"]["b"+(i+1)].visible&&root["win_cl"]["b"+(i+1)]["press_cl"].visible&&root["win_cl"]["b"+(i+1)]["id"]>-1){
										root["wait_cl"]["f"+j]["do_now"].visible=true;
										root["wait_cl"]["f"+j]["w_flag"]["press_cl"].visible=true;
										var color_cl:ColorTransform=new ColorTransform();
										color_cl.color=0x00CC00;
										root["wait_cl"]["f"+j]["do_now"].transform.colorTransform = color_cl;
										root["wait_cl"]["f"+j]["f_tx"].textColor=0xffffff;
										root["wait_cl"]["f"+j]["c_tx"].textColor=0xffffff;
									}else{
										root["wait_cl"]["f"+j]["w_flag"]["press_cl"].visible=false;
										var color_cl:ColorTransform=new ColorTransform();
										color_cl.color=0x9A9A9A;
										root["wait_cl"]["f"+j]["do_now"].transform.colorTransform = color_cl;
										root["wait_cl"]["f"+j]["f_tx"].textColor=0xffffff;
										root["wait_cl"]["f"+j]["c_tx"].textColor=0xffffff;
									}
								}
							}
						}
					}else{
						for(var i:int=0;i<8;i++){
							root["wait_cl"]["f"+i]["w_flag"]["press_cl"].visible=false;
							var color_cl:ColorTransform=new ColorTransform();
							color_cl.color=0x9A9A9A;
							root["wait_cl"]["f"+i]["do_now"].transform.colorTransform = color_cl;
							root["wait_cl"]["f"+i]["f_tx"].textColor=0xffffff;
							root["wait_cl"]["f"+i]["c_tx"].textColor=0xffffff;
							root["wait_cl"]["f"+i].visible=true;
							root["wait_cl"]["f"+i]["c_tx"].visible=true;
							root["wait_cl"]["f"+i]["f_tx"].text=list.child(s1)[i].attribute("name")+"";
							root["wait_cl"]["f"+i]["c_tx"].text="["+list.child(s1)[i].attribute("count")+"/"+list.child(s1)[i].attribute("count_max")+"]";
							root["wait_cl"]["f"+i]["w_flag"]["id"]=int(list.child(s1)[i].attribute("id"));
						}
						/*for(var i:int=0;i<3;i++){
							for(var j:int=0;j<8;j++){
								if(int(list.child(s1)[j].attribute("id"))==root["win_cl1"]["gr_c"+(i+1)]["id"]){
									//trace(root["win_cl1"]["gr_c"+(i+1)]["id"]+"   "+root["win_cl1"]["gr_c"+(i+1)].visible+"   "+root["win_cl1"]["gr_c"+(i+1)]["press_cl"].visible);
									if(root["win_cl1"]["gr_c"+(i+1)].visible&&root["win_cl1"]["gr_c"+(i+1)]["press_cl"].visible&&root["win_cl1"]["gr_c"+(i+1)]["id"]>-1){
										root["wait_cl"]["f"+j]["do_now"].visible=true;
										root["wait_cl"]["f"+j]["w_flag"]["press_cl"].visible=true;
										var color_cl:ColorTransform=new ColorTransform();
										color_cl.color=0x00CC00;
										root["wait_cl"]["f"+j]["do_now"].transform.colorTransform = color_cl;
										root["wait_cl"]["f"+j]["f_tx"].textColor=0xffffff;
										root["wait_cl"]["f"+j]["c_tx"].textColor=0xffffff;
									}else{
										root["wait_cl"]["f"+j]["w_flag"]["press_cl"].visible=false;
										var color_cl:ColorTransform=new ColorTransform();
										color_cl.color=0x9A9A9A;
										root["wait_cl"]["f"+j]["do_now"].transform.colorTransform = color_cl;
										root["wait_cl"]["f"+j]["f_tx"].textColor=0xffffff;
										root["wait_cl"]["f"+j]["c_tx"].textColor=0xffffff;
									}
								}
							}
						}*/
					}
				}
			}
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var t_count:int=0;
		public static var t_over:Boolean=true;
		
		public function waiting(event:TimerEvent):void{
			if(stg_class.m_mode==3||root["ready_cl"].visible){
				stopCall();
				stopAr();
				stopStatus();
				return;
			}
			w_time++;
			t_over=false;
			//trace(t_over);
			if(t_count<3){
				t_count++;
			}else{
				//event.currentTarget.stop();
				t_count=0;
				var id_str:String="";
				var ready_pl:Boolean=false;
				if(!root["group_win"].visible){
					id_str="<query id=\"3\"><action id=\"2\">";
					for(var i:int=1;i<9;i++){
						if(root["win_cl"]["b"+i].visible){
							if(root["win_cl"]["b"+i]["press_cl"].visible){
								if(root["win_cl"]["b"+i]["id"]>-1){
									id_str+="<battle id=\""+root["win_cl"]["b"+i]["id"]+"\" />";
									ready_pl=true;
								}
							}
						}
					}
				}
				if(!ready_pl){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["3"]]);
					return;
				}
				id_str+="</action></query>";
				sendCombats(id_str,false,1);
				//return;
			}
			//trace(event.currentTarget.delay+"   "+event.currentTarget.repeatCount+"   "+event.currentTarget.currentCount);
			//trace(m_time+"   "+w_time);
			if(event.currentTarget.repeatCount>1){
				var t1:String=int((w_time)/60)+"";
				var t2:String=int((w_time)%60)+"";
				if(t1.length==1){
					t1="0"+t1;
				}
				if(t2.length==1){
					t2="0"+t2;
				}
				root["wait_cl"]["wait_tx"].text=t1+":"+t2;
				root["wait_cl"]["fill"].width=((w_time%30)/30)*201;
			}
			/*if((w_time/m_time)>1){
				event.currentTarget.stop();
				t_count=0;
				t_over=true;
				var id_str:String="";
				var ready_pl:Boolean=false;
				if(!root["group_win"].visible){
					id_str="<query id=\"3\"><action id=\"2\">";
					for(var i:int=1;i<9;i++){
						if(root["win_cl"]["b"+i].visible){
							if(root["win_cl"]["b"+i]["press_cl"].visible){
								if(root["win_cl"]["b"+i]["id"]>-1){
									id_str+="<battle id=\""+root["win_cl"]["b"+i]["id"]+"\" />";
									ready_pl=true;
								}
							}
						}
					}
				}else{
					id_str="<query id=\"3\"><action id=\"2\">";
					for(var i:int=1;i<4;i++){
						if(root["win_cl1"]["gr_c"+i].visible){
							if(root["win_cl1"]["gr_c"+i]["press_cl"].visible){
								if(root["win_cl1"]["gr_c"+i]["id"]>-1){
									id_str+="<battle id=\""+root["win_cl1"]["gr_c"+i]["id"]+"\" />";
									ready_pl=true;
								}
							}
						}
					}
				}
				if(!ready_pl){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["3"]]);
					return;
				}
				id_str+="</action></query>";
				sendCombats(id_str,false,1);
				return;
			}*/
		}
		
		public function time_over(event:TimerEvent):void{
			if(stg_class.m_mode==3||root["ready_cl"].visible){
				stopCall();
				stopAr();
				stopStatus();
				return;
			}
			//var id_str:String=id_map+"";
			//sendRequest([["query"],["action"],["battle"]],[["id"],["id"],["id"]],[["3"],["2"],[id_str]]);
			t_count=0;
			t_over=true;
			var id_str:String="";
			var ready_pl:Boolean=false;
			if(!root["group_win"].visible){
				id_str="<query id=\"3\"><action id=\"2\">";
				for(var i:int=1;i<9;i++){
					if(root["win_cl"]["b"+i].visible){
						if(root["win_cl"]["b"+i]["press_cl"].visible){
							if(root["win_cl"]["b"+i]["id"]>-1){
								id_str+="<battle id=\""+root["win_cl"]["b"+i]["id"]+"\" />";
								ready_pl=true;
							}
						}
					}
				}
			}
			if(!ready_pl){
				sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["3"]]);
				return;
			}
			id_str+="</action></query>";
			sendCombats(id_str,false,1);
		}
		
		public function startStatus(){
			//trace("start");
			try{
				sTimer.stop();
			}catch(e:Error){
				
			}
			sTimer=new Timer(1000, 15);
			sTimer.addEventListener(TimerEvent.TIMER, waiting2);
			sTimer.addEventListener(TimerEvent.TIMER_COMPLETE, time_over2);
			sTimer.start();
		}
		
		public function getStatSt():Boolean{
			var _b:Boolean=false
			if(sTimer!=null){
				//trace(sTimer.running);
				_b=sTimer.running;
			}
			return _b;
		}
		
		public function stopStatus(){
			//trace("stop");
			st_wait=0;
			try{
				sTimer.stop();
			}catch(e:Error){
				
			}
		}
		
		public function startCall(a:int,b:int){
			try{
				cTimer.stop();
			}catch(e:Error){
				
			}
			max_call=b;
			t_call=a;
			if(stg_class.warn_cl["call_cl"]["bar"]["fill"].visible){
				stg_class.warn_cl["call_cl"]["bar"]["fill"].width=(a/b)*306;
			}else if(stg_class.warn_cl["call_cl"]["bar"]["fill1"].visible){
				stg_class.warn_cl["call_cl"]["bar"]["fill1"].width=(a/b)*306;
			}
			if(a<1000000){
				stg_class.warn_cl["call_cl"]["bar"].visible=true;
				if((a/1000)<10){
					stg_class.warn_cl["call_cl"]["time_tx"].text="00:0"+(a/1000);
				}else{
					stg_class.warn_cl["call_cl"]["time_tx"].text="00:"+(a/1000);
				}
			}else{
				stg_class.warn_cl["call_cl"]["bar"].visible=false;
			}
			cTimer=new Timer(40, int((b-a)/40+1));
			cTimer.addEventListener(TimerEvent.TIMER, waiting3);
			cTimer.addEventListener(TimerEvent.TIMER_COMPLETE, time_over3);
			cTimer.start();
		}
		
		public function stopCall(){
			try{
				cTimer.stop();
			}catch(e:Error){
				
			}
		}
		
		public static var max_call:int=0;
		public static var t_call:int=0;
		public static var st_call:int=0;
		
		public function waiting3(event:TimerEvent):void{
			var c:int=event.currentTarget.currentCount*40+t_call;
			if(stg_class.warn_cl["call_cl"]["bar"]["fill"].visible){
				stg_class.warn_cl["call_cl"]["bar"]["fill"].width=(c/max_call)*306;
			}else if(stg_class.warn_cl["call_cl"]["bar"]["fill1"].visible){
				stg_class.warn_cl["call_cl"]["bar"]["fill1"].width=(c/max_call)*306;
			}
			if(c<1000000){
				if(c/1000<10){
					stg_class.warn_cl["call_cl"]["time_tx"].text="00:0"+int(c/1000);
				}else{
					stg_class.warn_cl["call_cl"]["time_tx"].text="00:"+int(c/1000);
				}
			}
		}
		
		public function time_over3(event:TimerEvent):void{
			stg_cl.warn_f(9,"");
			sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["6"]]);
		}
		
		public function waiting2(event:TimerEvent):void{
			//trace(sts_count+"   "+stg_class.help_on+"   "+stg_cl["wall_win"]+"   "+event.currentTarget.currentCount);
			if(sts_count==4){
				//trace(event.currentTarget.currentCount);
				if(!stg_cl["wall_win"]){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["6"]]);
				}
				sts_count=0;
			}
			sts_count++;
		}
		
		public static var sts_count:int=0;
		
		public function time_over2(event:TimerEvent):void{
			//sendRequest([["query"],["action"],["battle"]],[["id"],["id"],["id"]],[["3"],["2"],[id_str]]);
			startStatus();
		}
		
		public function conferm1(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nОтвет на приглашение1.");
				erTestReq(7,2,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else{
					stopCall();
					stg_cl.warn_f(9,"");
					sendRequest([["query"],["action"]],[["id"],["id"]],[["3"],["6"]]);
				}
			}catch(er:Error){
				
			}
			//stg_cl.warn_f(9,"");
			//trace("conferm1=\n"+list);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function conferm2(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nОтвет на приглашение2.");
				erTestReq(7,4,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else{
					stopCall();
					stg_cl.warn_f(9,"");
					sendRequest([["query"],["action"]],[["id"],["id"]],[["7"],["5"]]);
				}
			}catch(er:Error){
				
			}
			//stg_cl.warn_f(9,"");
			//trace("conferm1=\n"+list);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function conferm3(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nОтвет с арены 0.");
				erTestReq(8,1,str);
				return;
			}
			//trace("conferm3\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else{
					stopCall();
					stg_cl.warn_f(9,"");
					sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["2"]]);
				}
			}catch(er:Error){
				
			}
			//stg_cl.warn_f(9,"");
			//trace("conferm1=\n"+list);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function conferm4(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("conferm4   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nОтвет с арены 1.");
				erTestReq(8,3,str);
				return;
			}
			//trace("conferm4\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["1"]]);
					return;
				}else{
					stopCall();
					stopAr();
					stg_cl.warn_f(9,"");
					//stg_cl.warn_f(15,list.child("err")[0].attribute("comm")+"");
					root["arena_cl"]["out_ar_ww"].visible=true;
					root["arena_cl"]["out_ar_ww"]["bar"].width=1;
					root["arena_cl"]["out_ar_ww"].tm=0;
					//sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["2"]]);
				}
			}catch(er:Error){
				
			}
			//stg_cl.warn_f(9,"");
			//trace("conferm1=\n"+list);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function conferm5(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("conferm5   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nОтвет с арены 2.");
				erTestReq(8,4,str);
				return;
			}
			//trace("conferm5\n"+list);
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}else{
					stopCall();
					stopAr();
					arTimer=new Timer(5000, 1);
					arTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ar_over);
					arTimer.start();
					stg_cl.warn_f(9,"");
					root["arena_cl"]["out_ar_ww"].visible=false;
					//sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["2"]]);
				}
			}catch(er:Error){
				
			}
			//stg_cl.warn_f(9,"");
			//trace("conferm1=\n"+list);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var bl_init:Boolean=false;
		
		public function listGroup(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("listGroup   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nЛист группы.");
				erTestReq(7,5,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			//stg_cl.warn_f(9,"");
			//trace("listGroup=\n"+list);
			plks=new Array();
			pids=new Array();
			plkn=new Array();
			gr_ar=new Array();
			//lkns=new Array("","","","","");
			if(list.child("group")[0].child("user").length()==0){
				if(root["group_win"].visible){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["4"]]);
				}
				root["group_win"].visible=false;
				gr_us_c=0;
				stg_class.chat_cl.room_exit(1);
				return;
			}
			for(var j:int=0;j<5;j++){
				/*try{
					root["group_win"]["pr"+j].removeChild(avas[j]);
				}catch(er:Error){}*/
				root["group_win"]["pr"+j].visible=false;
			}
			var _int:int=gr_us_c+5;
			if(list.child("group")[0].child("user").length()<gr_us_c+5){
				_int=list.child("group")[0].child("user").length();
			}
			for(var i:int=0;i<list.child("group")[0].child("user").length();i++){
				if(int(list.child("group")[0].child("user")[i].attribute("type_on_group"))==1){
					ldid=list.child("group")[0].child("user")[i].attribute("sn_id");
				}
			}
			for(var i:int=0;i<list.child("group")[0].child("user").length();i++){
				if(int(list.child("group")[0].child("user")[i].attribute("type_on_group"))==1){
					ldid=list.child("group")[0].child("user")[i].attribute("sn_id");
					if(!root["group_win"].visible){
						root["group_win"].visible=true;
					}
					root["group_win"]["lider_tx"].text="Руководитель группы: "+list.child("group")[0].child("user")[i].attribute("rang")+" "+list.child("group")[0].child("user")[i].attribute("name");
					if(stg_cl["v_id"]==Number(list.child("group")[0].child("user")[i].attribute("sn_id"))){
						stg_class.chat_cl.reidSet(list.child("group")[0].attribute("room"));
						root["group_win"]["exit_gr_cl"].visible=false;
						root["group_win"]["del_group_cl"].visible=true;
						for(var j:int=0;j<5;j++){
							if((i-gr_us_c)!=j){
								root["group_win"]["pr"+j]["del_user"].gotoAndStop("out");
							}else{
								root["group_win"]["pr"+j]["del_user"].gotoAndStop("empty");
							}
						}
					}
				}else{
					if(stg_cl["v_id"]==Number(list.child("group")[0].child("user")[i].attribute("sn_id"))){
						stg_class.chat_cl.reidSet(list.child("group")[0].attribute("room"),1);
						root["group_win"]["exit_gr_cl"].visible=true;
						root["group_win"]["del_group_cl"].visible=false;
						for(var j:int=0;j<5;j++){
							root["group_win"]["pr"+j]["del_user"].gotoAndStop("empty");
						}
					}
				}
			}
			for(var i:int=gr_us_c;i<_int;i++){
				
				root["group_win"]["pr"+(i-gr_us_c)]["rang_tx"].text=list.child("group")[0].child("user")[i].attribute("rang")+"";
				root["group_win"]["pr"+(i-gr_us_c)]["name_tx"].text=list.child("group")[0].child("user")[i].attribute("name")+"";
				root["group_win"]["pr"+(i-gr_us_c)]["BP_tx"].text="Уровень БП: "+list.child("group")[0].child("user")[i].attribute("gs")+"";
				root["group_win"]["pr"+(i-gr_us_c)]["dov_tx"].text="Доверие: "+list.child("group")[0].child("user")[i].attribute("doverie")+"";
				if(int(list.child("group")[0].child("user")[i].attribute("vch"))==0){
					root["group_win"]["pr"+(i-gr_us_c)]["polk_tx"].text="не состоит в полку";
					root["group_win"]["pr"+(i-gr_us_c)]["polk_cl"].gotoAndStop("empty");
				}else{
					root["group_win"]["pr"+(i-gr_us_c)]["polk_tx"].text="В/Ч "+list.child("group")[0].child("user")[i].attribute("vch");
					root["group_win"]["pr"+(i-gr_us_c)]["polk_cl"].gotoAndStop("out");
				}
				plks.push(int(list.child("group")[0].child("user")[i].attribute("vch")));
				if((list.child("group")[0].child("user")[i].attribute("vch_rang")+"")==""){
					root["group_win"]["pr"+(i-gr_us_c)]["work_tx"].text="не имеет должности";
				}else{
					root["group_win"]["pr"+(i-gr_us_c)]["work_tx"].text=list.child("group")[0].child("user")[i].attribute("vch_rang")+"";
				}
				pids.push(list.child("group")[0].child("user")[i].attribute("sn_id"));
				plkn.push(list.child("group")[0].child("user")[i].attribute("sn_link"));
				//lkns.push(list.child("group")[0].child("user")[i].attribute("ava"));
				//LoadGroup((stg_class.res_url+"/"+list.child("group")[0].child("user")[i].attribute("ava")),root["group_win"]["pr"+i]);
				try{
					if((lkns[(i-gr_us_c)]+"")!=(list.child("group")[0].child("user")[i].attribute("ava")+"")){
						//trace(lkns);
						//trace(lkns[i]+"   "+list.child("group")[0].child("user")[i].attribute("ava"));
						try{
							root["group_win"]["pr"+(i-gr_us_c)].removeChild(avas[i]);
							avas.pop();
						}catch(er:Error){}
						lkns[(i-gr_us_c)]=list.child("group")[0].child("user")[i].attribute("ava");
						LoadGroup((stg_class.res_url+"/"+list.child("group")[0].child("user")[i].attribute("ava")),root["group_win"]["pr"+(i-gr_us_c)]);
					}
				}catch(er:Error){
					
				}
				root["group_win"]["pr"+(i-gr_us_c)].visible=true;
			}
			for(var i:int=0;i<list.child("group")[0].child("user").length();i++){
				gr_ar[i]=(new Array());
				gr_ar[i][0]=(list.child("group")[0].child("user")[i].attribute("type_on_group"));
				gr_ar[i][1]=(list.child("group")[0].child("user")[i].attribute("name"));
				gr_ar[i][2]=(list.child("group")[0].child("user")[i].attribute("status"));
				gr_ar[i][3]=(list.child("group")[0].child("user")[i].attribute("rang"));
				gr_ar[i][4]=(list.child("group")[0].child("user")[i].attribute("ava"));
				gr_ar[i][5]=(list.child("group")[0].child("user")[i].attribute("vch"));
				gr_ar[i][6]=(list.child("group")[0].child("user")[i].attribute("vch_rang"));
				gr_ar[i][7]=(list.child("group")[0].child("user")[i].attribute("sn_id"));
				gr_ar[i][8]=(list.child("group")[0].child("user")[i].attribute("sn_link"));
				gr_ar[i][9]=(list.child("group")[0].child("user")[i].attribute("fuel"));
				gr_ar[i][10]=(list.child("group")[0].child("user")[i].attribute("fuel_max"));
				gr_ar[i][11]=(list.child("group")[0].child("user")[i].attribute("gs"));
				gr_ar[i][12]=(list.child("group")[0].child("user")[i].attribute("doverie"));
			}
			root["group_win"]["text_cl0"].gotoAndStop(1);
			root["group_win"]["text_cl1"].gotoAndStop(1);
			try{
				if(int(list.child("group")[0].attribute("group_type"))>4){
					root["group_win"]["text_cl0"].gotoAndStop(2);
					root["group_win"]["text_cl1"].gotoAndStop(2);
				}
			}catch(er:Error){}
			if(gr_ar.length<6){
				root["group_win"]["gr_us_right"].visible=false;
				root["group_win"]["gr_us_left"].visible=false;
			}else{
				if(gr_us_c+5<gr_ar.length){
					if(root["group_win"]["gr_us_right"].currentFrameLabel!="over"&&root["group_win"]["gr_us_right"].currentFrameLabel!="press"){
						root["group_win"]["gr_us_right"].gotoAndStop("out");
					}
				}else{
					root["group_win"]["gr_us_right"].gotoAndStop("empty");
				}
				if(gr_us_c>0){
					if(root["group_win"]["gr_us_left"].currentFrameLabel!="over"&&root["group_win"]["gr_us_left"].currentFrameLabel!="press"){
						root["group_win"]["gr_us_left"].gotoAndStop("out");
					}
				}else{
					root["group_win"]["gr_us_left"].gotoAndStop("empty");
				}
			}
			bl_init=true;
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function LoadGroup(ur:String,cl:MovieClip){
			//hideNews();
			var loader:Loader = new Loader();
			//trace(loader+"   "+loader.contentLoaderInfo);
			/*var mc:MovieClip=new pre1();
			mc.x=11;
			mc.y=37+23;
			mc.gotoAndPlay(int(Math.random()*15)+1);
			mc.name="pre_cl";
			cl.addChild(mc);*/
			avas.push(loader);
			cl.addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, openGroup );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressGroup);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeGroup);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, unLoadGroup);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, accessError);
      loader.addEventListener(IOErrorEvent.IO_ERROR, unLoadGroup);
			
			loader.load(new URLRequest(ur));
		}
		
		public function openGroup(event:Event){
			
		}
		
		public function progressGroup(event:ProgressEvent){
			
		}
		
		public function completeGroup(event:Event){
			/*try{
				event.currentTarget.loader.parent.removeChild(event.currentTarget.loader.parent.getChildByName("pre_cl"));
			}catch(er:Error){}*/
			event.currentTarget.content.x=3;
			event.currentTarget.content.y=62;
			//event.currentTarget.content.name="pict";
		}
		
		public function unLoadGroup(event:IOErrorEvent){
			
		}
		
		public static var plks:Array=new Array();
		public static var pids:Array=new Array();
		public static var plkn:Array=new Array();
		public static var avas:Array=new Array();
		public static var lkns:Array=new Array("","","","","");
		
		public static var ldid:String="0";
		public static var st_wait:int=0;
		
		public static var gr_ar:Array=new Array();
		public static var gr_us_c:int=0;
		
		public function listStatus(event:Event):void{
			if(stg_class.m_mode==3||root["ready_cl"].visible){
				stopCall();
				stopAr();
				stopStatus();
				return;
			}
			st_wait--;
			if(stg_cl["wall_win"]){
				return;
			}
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nСтатус игрока.");
				erTestReq(3,6,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					if(int(list.child("err")[0].attribute("code"))>=100){
						stg_class.chat_cl.visible=false;
						try{stg_class.chat_cl.parent.removeChild(stg_class.chat_cl);}catch(er100:Error){}
						try{stg_cl.stage.focus=null;}catch(er101:Error){}
					}
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			//stg_cl.warn_f(9,"");
			//trace("listStatus=\n"+list);
			
			//<study step="1" />
			if(list.child("study").length()>0){
				stg_cl.initLesson(int(list.child("study")[0].attribute("step")));
			}
			
			if(list.child("rPanel").length()>0){
				var list1:XML=list.child("rPanel")[0];
				//trace("panel for battle:\n"+list1+"\n\n");
				stg_class.panel["ammo0"].parsePanel(list1);
			}
			
			var s2:String="battle_now";
			gr_ar=new Array();
			//lkns=new Array("","","","","");
				
			if(list.child(s2).length()>0){
				//trace("listStatus=\n"+list);
				try{
					mTimer.stop();
				}catch(e:Error){
				
				}
				try{
					autoT.stop();
				}catch(er:Error){}
				stg_class.chat_cl.closePochta();
				root["empt_cl"].visible=false;
				stg_class.panel["waiting_cl"].visible=false;
				root["arena_cl"].visible=false;
				root["win_cl"].visible=false;
				t_over=true;
				t_count=0;
				stg_cl.createMode(1);
				stg_class.panel["buy_val"].gotoAndStop("empty");
				stg_class.panel["arsenal_b"].gotoAndStop("empty");
				stopCall();
				stopStatus();
				stopAr();
				stg_cl.warn_f(9,"");
				if(stg_class.help_on){
					try{
						stg_cl.removeChild(stg_class.help_cl);
					}catch(er:Error){
						
					}
					if(stg_class.help_st==9){
						stg_class.help_st=10;
					}
				}
				//stg_class.inv_cl["tank_sl"].sendRequest(["query","action"],[["id"],["id"]],[["1"],["15"]]);   // мини-профиль
				try{
					if(stg_cl["socket"]==null){
						//trace("connect");
						root["ready_cl"]["battle_tx"].text="Выбран сценарий: "+list.child(s2)[0].attribute("name");
						if(int(list.child(s2)[0].attribute("no_exit"))==0){
							stg_class.exit_on=true;
						}else{
							stg_class.exit_on=false;
						}
						if(int(list.child(s2)[0].attribute("w_money_a"))==0){
							root["ready_cl"]["w_znaki"].text=list.child(s2)[0].attribute("w_money_z");
							root["ready_cl"]["w"].gotoAndStop(1);
						}else{
							root["ready_cl"]["w"].gotoAndStop(2);
							if(int(list.child(s2)[0].attribute("w_money_a"))<0){
								root["ready_cl"]["w_znaki"].text=0;
							}else{
								root["ready_cl"]["w_znaki"].text=list.child(s2)[0].attribute("w_money_a");
							}
						}
						if(int(list.child(s2)[0].attribute("l_money_a"))==0){
							root["ready_cl"]["l_znaki"].text=list.child(s2)[0].attribute("l_money_z");
							root["ready_cl"]["l"].gotoAndStop(1);
						}else{
							root["ready_cl"]["l"].gotoAndStop(2);
							if(int(list.child(s2)[0].attribute("l_money_a"))<0){
								root["ready_cl"]["l_znaki"].text=0;
							}else{
								root["ready_cl"]["l_znaki"].text=list.child(s2)[0].attribute("l_money_a");
							}
						}
						root["ready_cl"]["w_money"].text=list.child(s2)[0].attribute("w_money_m");
						root["ready_cl"]["l_money"].text=list.child(s2)[0].attribute("l_money_m");
						root["ready_cl"]["podsk_cl"]["descr_tx"].text=list.child(s2)[0].attribute("message");
						root["ready_cl"].visible=true;
						root["diff_win"].visible=false;
						root["win_cl1"].visible=false;
						root["win_cl"].visible=false;
						root["wait_cl"].visible=false;
						var map_num:int=int(list.child(s2)[0].attribute("id"));
						//trace("new metka1   "+list.child(s2)[0].attribute("id"));
						if(int(list.child(s2)[0].attribute("kill_am_all"))==1){
							stg_class.self_battle=true;
						}else{
							stg_class.self_battle=false;
						}
						stg_class.panel["ammo0"].setLevTime((int(list.child(s2)[0].attribute("time"))*40)/1000);
						stg_class.map_id[0]=int(map_num/(Math.pow(256,3)));
						stg_class.map_id[1]=int(map_num/(Math.pow(256,2)));
						stg_class.map_id[2]=int(map_num/256);
						stg_class.map_id[3]=int(map_num%256);
						for(var n:int=0;n<stg_class.map_id.length;n++){
							if(stg_class.map_id[n]>255){
								stg_class.map_id[n]=stg_class.map_id[n]%256;
							}
						}
						//trace("1   "+map_num+"   "+stg_class.map_id);
						stg_class.serv_url=list.child(s2)[0].attribute("host");
						stg_class.port_num=int(list.child(s2)[0].attribute("port"));
						stg_cl["f_num"]=int(list.child(s2)[0].attribute("num"));
						//stg_cl.createMode(3);
						stg_cl.LoadMap();
						try{
							stg_cl.playSound("begin",1);
						}catch(e:Error){
							//trace("Select combat error: "+e);
						}
						return;
					}else{
						//trace("double connect");
					}
				}catch(e:Error){
					//trace("Select combat error: "+e);
				}
				return;
			}
			
			if(list.child("time").length()!=0){
				root["arena_cl"]["time_tx"].text=list.child("time")[0].attribute("now")+"";
				stg_class.chat_cl.time=root["arena_cl"]["time_tx"].text;
				//stg_class.chat_cl["mainLayer"]["time_tx"].text="Время сервера: "+list.child("time")[0].attribute("now")+"";
			}
			if(list.child("ban").length()!=0){
				stg_class.chat_cl["ban_time"]=int(list.child("ban")[0].attribute("time"));
				stg_class.chat_cl["ban_text"]=list.child("ban")[0].attribute("text")+"";
				if(!stg_class.chat_cl["banned"]){
					stg_class.chat_cl["banned"]=true;
					stg_class.chat_cl.show_ban_mess();
				}
			}else{
				stg_class.chat_cl["banned"]=false;
				stg_class.chat_cl["ban_time"]=0;
				stg_class.chat_cl["ban_text"]="";
			}
			
			if(list.child("group").length()==0){
				if(root["group_win"].visible){
					sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["4"]]);
				}
				root["group_win"].visible=false;
				gr_us_c=0;
				stg_class.chat_cl.room_exit(1);
			}else{
				//trace("listStatus=\n"+list);
				if(list.child("group")[0].child("user").length()==0){
					if(root["group_win"].visible){
						sendRequest([["query"],["action"]],[["id"],["id"]],[["8"],["4"]]);
					}
					root["group_win"].visible=false;
					gr_us_c=0;
					stg_class.chat_cl.room_exit(1);
				}else{
					//var ldr:int=0;
					//root["group_win"].visible=true;
					//avas=new Array();
					for(var i:int=0;i<list.child("group")[0].child("user").length();i++){
						gr_ar[i]=(new Array());
						gr_ar[i][0]=(list.child("group")[0].child("user")[i].attribute("type_on_group"));
						gr_ar[i][1]=(list.child("group")[0].child("user")[i].attribute("name"));
						gr_ar[i][2]=(list.child("group")[0].child("user")[i].attribute("status"));
						gr_ar[i][3]=(list.child("group")[0].child("user")[i].attribute("rang"));
						gr_ar[i][4]=(list.child("group")[0].child("user")[i].attribute("ava"));
						gr_ar[i][5]=(list.child("group")[0].child("user")[i].attribute("vch"));
						gr_ar[i][6]=(list.child("group")[0].child("user")[i].attribute("vch_rang"));
						gr_ar[i][7]=(list.child("group")[0].child("user")[i].attribute("sn_id"));
						gr_ar[i][8]=(list.child("group")[0].child("user")[i].attribute("sn_link"));
						gr_ar[i][9]=(list.child("group")[0].child("user")[i].attribute("fuel"));
						gr_ar[i][10]=(list.child("group")[0].child("user")[i].attribute("fuel_max"));
						gr_ar[i][11]=(list.child("group")[0].child("user")[i].attribute("gs"));
						gr_ar[i][12]=(list.child("group")[0].child("user")[i].attribute("doverie"));
						if(int(gr_ar[i][0])==1){
							ldid=gr_ar[i][7];
						}
					}
					if(ldid==stg_cl["v_id"]){
						stg_class.chat_cl.reidSet(list.child("group")[0].attribute("room"));
					}else{
						stg_class.chat_cl.reidSet(list.child("group")[0].attribute("room"),1);
					}
					in_group();
					root["group_win"]["text_cl0"].gotoAndStop(1);
					root["group_win"]["text_cl1"].gotoAndStop(1);
					try{
						if(int(list.child("group")[0].attribute("group_type"))>4){
							root["group_win"]["text_cl0"].gotoAndStop(2);
							root["group_win"]["text_cl1"].gotoAndStop(2);
						}
					}catch(er:Error){}
				}
			}
			
			//var _unstat:int=0;
			if(list.child("gs_battle").length()>0){
				if(int(list.child("gs_battle")[0].attribute("state"))==2){
					stg_class.warn_cl["big_wait"]["name_tx"].text=list.child("gs_battle")[0].attribute("name");
					stg_class.warn_cl["big_wait"]["m_m_tx"].text=list.child("gs_battle")[0].attribute("w_money_m");
					stg_class.warn_cl["big_wait"]["m_z_tx"].text=list.child("gs_battle")[0].attribute("w_money_z");
					stg_class.warn_cl["big_wait"]["m_gs_tx"].text=list.child("gs_battle")[0].attribute("w_money_za");
					if(!stg_class.warn_cl["big_wait"].visible){
						stg_class.panel["waiting_cl"].visible=true;
						try{
							autoT.stop();
						}catch(er:Error){}
						autoT=new Timer(40,20*25);
						autoT.addEventListener(TimerEvent.TIMER, function(event:TimerEvent){
							stg_class.warn_cl["big_wait"]["fill"].graphics.clear();
							stg_class.warn_cl["big_wait"]["fill"].graphics.beginFill(0x00ff00);
							var _perc:Number=(autoT.currentCount/autoT.repeatCount);
							if(_perc<10){
								stg_class.warn_cl["big_wait"]["wait_tx"].text="00:0"+int(_perc*20);
							}else{
								stg_class.warn_cl["big_wait"]["wait_tx"].text="00:"+int(_perc*20);
							}
							stg_class.warn_cl["big_wait"]["fill"].graphics.drawRect(0,0,_perc*200,12);
						});
						autoT.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent){
							stg_class.warn_cl["big_wait"]["fill"].graphics.clear();
							stg_class.warn_cl["big_wait"]["fill"].graphics.beginFill(0x00ff00);
							stg_class.warn_cl["big_wait"]["fill"].graphics.drawRect(0,0,(autoT.currentCount/autoT.repeatCount)*200,12);
							sendRequest([["query"],["action"]],[["id"],["id","type"]],[["3"],["12",0+""]]);
						});
						autoT.start();
						stg_cl.playSound("message",1);
					}
					winStop(root["a_re_win"]);
					stg_cl.warn_f(17,"");
					try{System.disposeXML(list);}catch(er:Error){}
					return;
				}else if(int(list.child("gs_battle")[0].attribute("state"))==3){
					try{
						autoT.stop();
					}catch(er:Error){}
					stg_class.warn_cl["big_win1"]["name_tx"].text=list.child("gs_battle")[0].attribute("name");
					stg_class.warn_cl["big_win1"]["m_m_tx"].text=list.child("gs_battle")[0].attribute("w_money_m");
					stg_class.warn_cl["big_win1"]["m_z_tx"].text=list.child("gs_battle")[0].attribute("w_money_z");
					stg_class.warn_cl["big_win1"]["m_gs_tx"].text=list.child("gs_battle")[0].attribute("w_money_za");
					winStop(root["a_re_win"]);
					stg_cl.warn_f(18,"");
					try{System.disposeXML(list);}catch(er:Error){}
					return;
				}else if(int(list.child("gs_battle")[0].attribute("state"))==4){
					try{
						autoT.stop();
					}catch(er:Error){}
					stg_class.warn_cl["big_wait"].visible=false;
					if(_auto==0){
						root["empt_cl"].gotoAndStop(4);
						root["empt_cl"].visible=true;
					}
				}else if(int(list.child("gs_battle")[0].attribute("state"))==1){
					try{
						autoT.stop();
					}catch(er:Error){}
					stg_class.warn_cl["big_wait"].visible=false;
				}
				_auto=0;
				//_unstat=1;
			}else{
				if(auto_type==0){
					try{
						autoT.stop();
					}catch(er:Error){}
					stg_class.panel["waiting_cl"].visible=false;
				}
				_auto=0;
			}
			
			if(list.child("find").length()>0){
				if(int(list.child("find")[0].attribute("type"))==1){
					if(int(list.child("find")[0].attribute("inner_type"))==2){
						if(!stg_class.warn_cl["gr_win1"].visible){
							stg_class.panel["waiting_cl"].visible=true;
							try{
								autoT1.stop();
							}catch(er:Error){}
							autoT1=new Timer(40,20*25);
							autoT1.addEventListener(TimerEvent.TIMER, function(event:TimerEvent){
								stg_class.warn_cl["gr_win1"]["fill"].graphics.clear();
								stg_class.warn_cl["gr_win1"]["fill"].graphics.beginFill(0x00ff00);
								var _perc:Number=(autoT1.currentCount/autoT1.repeatCount);
								if(_perc<10){
									stg_class.warn_cl["gr_win1"]["wait_tx"].text="00:0"+int(_perc*20);
								}else{
									stg_class.warn_cl["gr_win1"]["wait_tx"].text="00:"+int(_perc*20);
								}
								stg_class.warn_cl["gr_win1"]["fill"].graphics.drawRect(0,0,_perc*250,7.5);
							});
							autoT1.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent){
								stg_class.warn_cl["gr_win1"]["fill"].graphics.clear();
								stg_class.warn_cl["gr_win1"]["fill"].graphics.beginFill(0x00ff00);
								stg_class.warn_cl["gr_win1"]["fill"].graphics.drawRect(0,0,(autoT1.currentCount/autoT1.repeatCount)*250,7.5);
								sendRequest([["query"],["action"]],[["id"],["id","type"]],[["3"],["12",0+""]]);
							});
							autoT1.start();
							stg_cl.playSound("message",1);
						}
						winStop(root["au_gr_win1"]);
						stg_cl.warn_f(19,"");
						try{System.disposeXML(list);}catch(er:Error){}
						return;
					}else if(int(list.child("find")[0].attribute("inner_type"))==1){
						try{
							autoT1.stop();
						}catch(er:Error){}
						stg_class.warn_cl["gr_win1"].visible=false;
						stg_class.panel["waiting_cl"].visible=true;
					}else if(int(list.child("find")[0].attribute("inner_type"))==3){
						try{
							autoT1.stop();
						}catch(er:Error){}
						stg_class.warn_cl["gr_win1"].visible=false;
						stg_class.panel["waiting_cl"].visible=true;
					}
				}
			}else{
				if(auto_type==1){
					try{
						autoT1.stop();
					}catch(er:Error){}
					stg_class.panel["waiting_cl"].visible=false;
				}
			}
			
			if(list.child("window").length()>0){
				var ar:Array=new Array();
				//if(int(list.child("window")[0].attribute("type"))==30||int(list.child("window")[0].attribute("type"))==31)trace("kontr+   "+list);
				ar.push(int(list.child("window")[0].attribute("type")));
				ar.push(list.child("window")[0].attribute("sender"));
				ar.push(list.child("window")[0].attribute("from"));
				ar.push(int(list.child("window")[0].attribute("time")));
				ar.push(int(list.child("window")[0].attribute("time_max")));
				ar.push(int(list.child("window")[0].attribute("state")));
				if(int(list.child("window")[0].attribute("type"))==3){
					ar.push(list.child("window")[0].attribute("message"));
				}else if(int(list.child("window")[0].attribute("type"))==5){
					ar.push(list.child("window")[0].attribute("message"));
					ar.push(list.child("window")[0].attribute("img"));
				}else if(int(list.child("window")[0].attribute("type"))>29){
					ar.push(list.child("window")[0].attribute("message"));
				}
				//trace(ar);
			}else{
				if((st_call>-1&&st_call<11)||st_call<-200){
					stopCall();
					stg_cl.warn_f(9,"");
					if(st_call==2){
						sendRequest([["query"],["action"]],[["id"],["id"]],[["7"],["5"]]);
					}
					id_str_num="0";
					st_call=0;
				}
				try{System.disposeXML(list);}catch(er:Error){}
				return;
			}
			
			/*try{
				stg_cl.createMode(1);
			}catch(er:Error){}*/
			root["choise_cl"].call_f(ar);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public static var autoT:Timer;
		public static var autoT1:Timer;
		
		public function in_group(){
			plks=new Array();
			pids=new Array();
			plkn=new Array();
			for(var j:int=0;j<5;j++){
				root["group_win"]["pr"+j].visible=false;
			}
			var _int:int=gr_us_c+5;
			if(gr_ar.length<gr_us_c+5){
				_int=gr_ar.length;
			}
			for(var i:int=0;i<gr_ar.length;i++){
				if(gr_ar[i][0]==1){
					ldid=gr_ar[i][7];
					if(!root["group_win"].visible){
						root["group_win"].visible=true;
					}
					root["group_win"]["lider_tx"].text="Руководитель группы: "+gr_ar[i][3]+" "+gr_ar[i][1];
					if(stg_cl["v_id"]==gr_ar[i][7]){
						root["group_win"]["exit_gr_cl"].visible=false;
						root["group_win"]["del_group_cl"].visible=true;
						for(var j:int=0;j<5;j++){
							if(i-gr_us_c!=j){
								root["group_win"]["pr"+j]["del_user"].gotoAndStop("out");
							}else{
								root["group_win"]["pr"+j]["del_user"].gotoAndStop("empty");
							}
						}
					}
				}else{
					if(stg_cl["v_id"]==Number(gr_ar[i][7])){
						root["group_win"]["exit_gr_cl"].visible=true;
						root["group_win"]["del_group_cl"].visible=false;
						for(var j:int=0;j<5;j++){
							root["group_win"]["pr"+j]["del_user"].gotoAndStop("empty");
						}
					}
				}
			}
			for(var i:int=gr_us_c;i<_int;i++){
				
				root["group_win"]["pr"+(i-gr_us_c)]["rang_tx"].text=gr_ar[i][3]+"";
				root["group_win"]["pr"+(i-gr_us_c)]["name_tx"].text=gr_ar[i][1]+"";
				root["group_win"]["pr"+(i-gr_us_c)]["BP_tx"].text="Уровень БП: "+gr_ar[i][11]+"";
				root["group_win"]["pr"+(i-gr_us_c)]["dov_tx"].text="Доверие: "+gr_ar[i][12]+"";
				if(int(gr_ar[i][5])==0){
					root["group_win"]["pr"+(i-gr_us_c)]["polk_tx"].text="не состоит в полку";
					root["group_win"]["pr"+(i-gr_us_c)]["polk_cl"].gotoAndStop("empty");
				}else{
					root["group_win"]["pr"+(i-gr_us_c)]["polk_tx"].text="В/Ч "+gr_ar[i][5];
					root["group_win"]["pr"+(i-gr_us_c)]["polk_cl"].gotoAndStop("out");
				}
				plks.push(gr_ar[i][5]);
				if((gr_ar[i][6]+"")==""){
					root["group_win"]["pr"+(i-gr_us_c)]["work_tx"].text="не имеет должности";
				}else{
					root["group_win"]["pr"+(i-gr_us_c)]["work_tx"].text=gr_ar[i][6]+"";
				}
				pids.push(gr_ar[i][7]);
				plkn.push(gr_ar[i][8]);
				root["group_win"]["pr"+(i-gr_us_c)].visible=true;
				try{
					if((lkns[(i-gr_us_c)]+"")!=(gr_ar[i][4]+"")){
						//trace(lkns);
						//trace(lkns[i]+"   "+list.child("group")[0].child("user")[i].attribute("ava"));
						try{
							root["group_win"]["pr"+(i-gr_us_c)].removeChild(avas[i]);
							avas.pop();
						}catch(er:Error){}
						lkns[(i-gr_us_c)]=gr_ar[i][4];
						LoadGroup((stg_class.res_url+"/"+gr_ar[i][4]),root["group_win"]["pr"+(i-gr_us_c)]);
					}
				}catch(er:Error){
					
				}
			}
			//trace(gr_us_c+"   "+gr_ar.length);
			if(gr_ar.length<6){
				root["group_win"]["gr_us_right"].visible=false;
				root["group_win"]["gr_us_left"].visible=false;
			}else{
				if(gr_us_c+5<gr_ar.length){
					if(root["group_win"]["gr_us_right"].currentFrameLabel!="over"&&root["group_win"]["gr_us_right"].currentFrameLabel!="press"){
						root["group_win"]["gr_us_right"].gotoAndStop("out");
					}
				}else{
					root["group_win"]["gr_us_right"].gotoAndStop("empty");
				}
				if(gr_us_c>0){
					if(root["group_win"]["gr_us_left"].currentFrameLabel!="over"&&root["group_win"]["gr_us_left"].currentFrameLabel!="press"){
						root["group_win"]["gr_us_left"].gotoAndStop("out");
					}
				}else{
					root["group_win"]["gr_us_left"].gotoAndStop("empty");
				}
			}
		}
		
		public function setSt(_st:Number){
			st_call=_st;
		}
		
		public function call_f(ar:Array){
			if(st_call==-13){
				return;
			}else if(st_call>29&&st_call<40){
				return;
			}
			st_call=ar[0];
			stg_class.warn_cl["call_cl"]["time_tx"].text="";
			stg_class.warn_cl["call_cl"]["cl_call"].visible=false;
			stg_class.warn_cl["call_cl"]["y_call"].visible=false;
			stg_class.warn_cl["call_cl"]["n_call"].visible=false;
			if(ar[0]==30){
				st_call=-ar[0];
				stg_class.warn_cl["kontrakt"]["tx0"].text="Вам присвоен статус \"Контрактник\"";
				stg_class.warn_cl["kontrakt"]["tx1"].text=""+ar[6];
				stg_cl.warn_f(16,"");
				return;
			}else if(ar[0]==31){
				st_call=-ar[0];
				stg_class.warn_cl["kontrakt"]["tx0"].text="Вы имеете статус \"Контрактник\"";
				stg_class.warn_cl["kontrakt"]["tx1"].text=""+ar[6];
				stg_cl.warn_f(16,"");
				return;
			}else if(ar[0]==1){
				stg_class.warn_cl["call_cl"]["bar"]["fill1"].visible=false;
				stg_class.warn_cl["call_cl"]["bar"]["fill"].visible=true;
				stg_class.warn_cl["call_cl"]["back"].gotoAndStop(1);
				stg_class.warn_cl["call_cl"]["back1"].gotoAndStop(1);
				if(ar[5]!=0){
					st_call=0;
					stg_class.warn_cl["call_cl"]["tx2"].text="Отказ!";
					if(ar[5]==1){
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" отказался от дуэли!";
					}else if(ar[5]==2){
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" сейчас недоступен!";
					}
					stg_class.warn_cl["call_cl"]["bar"].x=-173;
					stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=18;
					stg_class.warn_cl["call_cl"].gotoAndStop(1);
					startCall(1000000,1003000);
				}else{
					if(ar[1]==1){
						stg_class.warn_cl["call_cl"]["tx2"].text="Ожидайте ответа дуэлянта...";
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" вызван вами на дуэль!";
						stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=18;
						stg_class.warn_cl["call_cl"]["back"].y=-38;
						stg_class.warn_cl["call_cl"]["back1"].y=-11;
						stg_class.warn_cl["call_cl"].gotoAndStop(1);
					}else{
						stg_class.warn_cl["call_cl"]["tx2"].text="Вы должны дать ответ в течение "+int(ar[4]/1000)+" секунд...";
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" вызвал ВАС на дуэль!";
						stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=1;
						stg_class.warn_cl["call_cl"]["back"].y=-44;
						stg_class.warn_cl["call_cl"]["back1"].y=-21;
						stg_class.warn_cl["call_cl"]["y_call"].visible=true;
						stg_class.warn_cl["call_cl"]["n_call"].visible=true;
						stg_class.warn_cl["call_cl"].gotoAndStop(2);
						try{
							if(!stg_class.warn_cl["call_cl"].visible){
								stg_cl.playSound("message",1);
							}
						}catch(e:Error){
							//trace("Select combat error: "+e);
						}
					}
					startCall(ar[3],ar[4]);
				}
			}else if(ar[0]==2){
				stg_class.warn_cl["call_cl"]["bar"]["fill"].visible=false;
				stg_class.warn_cl["call_cl"]["bar"]["fill1"].visible=true;
				stg_class.warn_cl["call_cl"]["back"].gotoAndStop(2);
				stg_class.warn_cl["call_cl"]["back1"].gotoAndStop(2);
				if(ar[5]!=0){
					st_call=0;
					stg_class.warn_cl["call_cl"]["tx2"].text="Отказ!";
					if(ar[5]==1){
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" отказался от участия в группе!";
					}else if(ar[5]==2){
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" сейчас недоступен!";
					}
					stg_class.warn_cl["call_cl"]["bar"].x=-173;
					stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=18;
					stg_class.warn_cl["call_cl"].gotoAndStop(1);
					startCall(1000000,1003000);
				}else{
					if(ar[1]==1){
						stg_class.warn_cl["call_cl"]["tx2"].text="Ожидайте ответа ...";
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" приглашён вами в группу!";
						stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=18;
						stg_class.warn_cl["call_cl"]["back"].y=-38;
						stg_class.warn_cl["call_cl"]["back1"].y=-11;
						stg_class.warn_cl["call_cl"].gotoAndStop(1);
					}else{
						stg_class.warn_cl["call_cl"]["tx2"].text="Вы должны дать ответ в течение "+int(ar[4]/1000)+" секунд...";
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" пригласил ВАС в группу!";
						stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=1;
						stg_class.warn_cl["call_cl"]["back"].y=-44;
						stg_class.warn_cl["call_cl"]["back1"].y=-21;
						stg_class.warn_cl["call_cl"].gotoAndStop(2);
						stg_class.warn_cl["call_cl"]["y_call"].visible=true;
						stg_class.warn_cl["call_cl"]["n_call"].visible=true;
						try{
							if(!stg_class.warn_cl["call_cl"].visible){
								stg_cl.playSound("message",1);
							}
						}catch(e:Error){
							//trace("Select combat error: "+e);
						}
					}
					startCall(ar[3],ar[4]);
				}
			}else if(ar[0]==6){
				stg_class.warn_cl["call_cl"]["bar"]["fill"].visible=false;
				stg_class.warn_cl["call_cl"]["bar"]["fill1"].visible=true;
				stg_class.warn_cl["call_cl"]["back"].gotoAndStop(2);
				stg_class.warn_cl["call_cl"]["back1"].gotoAndStop(2);
				if(ar[5]!=0){
					st_call=0;
					stg_class.warn_cl["call_cl"]["tx2"].text="Отказ!";
					if(ar[5]==1){
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" отказался вступить в полк!";
					}else if(ar[5]==2){
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" сейчас недоступен!";
					}
					stg_class.warn_cl["call_cl"]["bar"].x=-173;
					stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=18;
					stg_class.warn_cl["call_cl"].gotoAndStop(1);
					startCall(1000000,1003000);
				}else{
					if(ar[1]==1){
						stg_class.warn_cl["call_cl"]["tx2"].text="Ожидайте ответа ...";
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" приглашён вами в полк!";
						stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=18;
						stg_class.warn_cl["call_cl"]["back"].y=-38;
						stg_class.warn_cl["call_cl"]["back1"].y=-11;
						stg_class.warn_cl["call_cl"].gotoAndStop(1);
					}else{
						stg_class.warn_cl["call_cl"]["tx2"].text="Вы должны дать ответ в течение "+int(ar[4]/1000)+" секунд...";
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" пригласил ВАС в полк!";
						stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=1;
						stg_class.warn_cl["call_cl"]["back"].y=-44;
						stg_class.warn_cl["call_cl"]["back1"].y=-21;
						stg_class.warn_cl["call_cl"].gotoAndStop(2);
						stg_class.warn_cl["call_cl"]["y_call"].visible=true;
						stg_class.warn_cl["call_cl"]["n_call"].visible=true;
						try{
							if(!stg_class.warn_cl["call_cl"].visible){
								stg_cl.playSound("message",1);
							}
						}catch(e:Error){
							//trace("Select combat error: "+e);
						}
					}
					startCall(ar[3],ar[4]);
				}
			}else if(ar[0]==3){
				stg_cl.warn_f(15,ar[6]+"");
				root["choise_cl"].sendRequest([["query"],["action"]],[["id"],["id"]],[["7"],["5"]]);
				try{
					if(!stg_class.warn_cl["call_cl"].visible){
						stg_cl.playSound("message",1);
					}
				}catch(e:Error){
					//trace("Select combat error: "+e);
				}
				return;
			}else if(ar[0]==5){
				//trace(ar);
				stg_class.cl_ar=new Array(0,"","","","");
				stg_class.cl_ar[0]=3;
				stg_class.cl_ar[3]=ar[7];
				var m:int=0;
				for(var n:int=0;n<(ar[6]+"").length;n++){
					if(ar[6].slice(n,n+1)!="&"){;
						if(m==0){
							stg_class.cl_ar[4]+=ar[6].slice(n,n+1);
						}else if(m==1){
							stg_class.cl_ar[1]+=ar[6].slice(n,n+1);
						}else if(m==2){
							stg_class.cl_ar[2]+=ar[6].slice(n,n+1);
						}
					}else{
						m++;
					}
				}
				stg_cl.warn_f(13,"");
				return;
			}else if(ar[0]==527){
				if(int(ar[1])>10){
					st_call=ar[1];
					id_str_num=ar[1];
				}else{
					st_call=-ar[1];
					id_str_num=ar[1];
				}
				stg_class.warn_cl["call_cl"]["tx2"].text="Подтвердите свое решение!";
				stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" будет исключен из группы!";
				stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=1;
				stg_class.warn_cl["call_cl"]["back"].y=-44;
				stg_class.warn_cl["call_cl"]["back1"].y=-21;
				stg_class.warn_cl["call_cl"]["y_call"].visible=true;
				stg_class.warn_cl["call_cl"]["n_call"].visible=true;
				stg_class.warn_cl["call_cl"].gotoAndStop(2);
				startCall(1000000,1300000);
			}else if(ar[0]==528){
				if(int(ar[1])>10){
					st_call=ar[1];
					id_str_num=ar[1];
				}else{
					st_call=-ar[1];
					id_str_num=ar[1];
				}
				stg_class.warn_cl["call_cl"]["tx2"].text="Подтвердите свое решение!";
				stg_class.warn_cl["call_cl"]["tx1"].text="Группа будет расcформирована!";
				stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=1;
				stg_class.warn_cl["call_cl"]["back"].y=-44;
				stg_class.warn_cl["call_cl"]["back1"].y=-21;
				stg_class.warn_cl["call_cl"]["y_call"].visible=true;
				stg_class.warn_cl["call_cl"]["n_call"].visible=true;
				stg_class.warn_cl["call_cl"].gotoAndStop(2);
				startCall(1000000,1300000);
			}else if(ar[0]==529){
				if(int(ar[1])>10){
					st_call=ar[1];
					id_str_num=ar[1];
				}else{
					st_call=-ar[1];
					id_str_num=ar[1];
				}
				stg_class.warn_cl["call_cl"]["tx2"].text="Подтвердите свое решение!";
				stg_class.warn_cl["call_cl"]["tx1"].text="Вы хотите покинуть группу?";
				stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=1;
				stg_class.warn_cl["call_cl"]["back"].y=-44;
				stg_class.warn_cl["call_cl"]["back1"].y=-21;
				stg_class.warn_cl["call_cl"]["y_call"].visible=true;
				stg_class.warn_cl["call_cl"]["n_call"].visible=true;
				stg_class.warn_cl["call_cl"].gotoAndStop(2);
				startCall(1000000,1300000);
			}else if(ar[0]==530){
				st_call=-11;
				stg_class.warn_cl["call_cl"]["tx2"].text="";
				stg_class.warn_cl["call_cl"]["tx1"].text="";
				stg_class.warn_cl["call_cl"]["cl_call"].visible=true;
				stg_class.warn_cl["call_cl"].gotoAndStop(3);
				startCall(1000000,1300000);
			}else if(ar[0]>200){
				stg_class.warn_cl["call_cl"]["bar"]["fill"].visible=false;
				stg_class.warn_cl["call_cl"]["bar"]["fill1"].visible=true;
				stg_class.warn_cl["call_cl"]["back"].gotoAndStop(2);
				stg_class.warn_cl["call_cl"]["back1"].gotoAndStop(2);
				if(ar[5]!=0){
					st_call=0;
					stg_class.warn_cl["call_cl"]["tx2"].text="Отказ!";
					if(ar[5]==1){
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" отказался от участия в рейде!";
					}else if(ar[5]==2){
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" сейчас недоступен!";
					}
					stg_class.warn_cl["call_cl"]["bar"].x=-173;
					stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=18;
					stg_class.warn_cl["call_cl"].gotoAndStop(1);
					startCall(1000000,1003000);
				}else{
					var size_s:String="";
					if(ar[0]<210){
						size_s="малый";
					}else if(ar[0]<215){
						size_s="средний";
					}else{
						size_s="большой";
					}
					if(ar[1]==1){
						stg_class.warn_cl["call_cl"]["tx2"].text="Ожидайте ответа ...";
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" приглашён вами в "+size_s+" рейд!";
						stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=18;
						stg_class.warn_cl["call_cl"]["back"].y=-38;
						stg_class.warn_cl["call_cl"]["back1"].y=-11;
						stg_class.warn_cl["call_cl"].gotoAndStop(1);
					}else{
						stg_class.warn_cl["call_cl"]["tx2"].text="Вы должны дать ответ в течение "+int(ar[4]/1000)+" секунд...";
						stg_class.warn_cl["call_cl"]["tx1"].text=ar[2]+" пригласил ВАС в "+size_s+" рейд!";
						stg_class.warn_cl["call_cl"]["bar"].y=stg_class.warn_cl["call_cl"]["time_tx"].y=1;
						stg_class.warn_cl["call_cl"]["back"].y=-44;
						stg_class.warn_cl["call_cl"]["back1"].y=-21;
						stg_class.warn_cl["call_cl"].gotoAndStop(2);
						stg_class.warn_cl["call_cl"]["y_call"].visible=true;
						stg_class.warn_cl["call_cl"]["n_call"].visible=true;
						try{
							if(!stg_class.warn_cl["call_cl"].visible){
								stg_cl.playSound("message",1);
							}
						}catch(e:Error){
							//trace("Select combat error: "+e);
						}
					}
					startCall(ar[3],ar[4]);
				}
				st_call=-ar[0];
			}
			stg_class.warn_cl["call_cl"]["tx2"].y=stg_class.warn_cl["call_cl"]["back1"].y-2;
			stg_class.warn_cl["call_cl"]["tx1"].y=stg_class.warn_cl["call_cl"]["back"].y;
			stg_class.warn_cl["call_cl"].visible=true;
			stg_cl.warn_f(14,"");
		}
	}
}