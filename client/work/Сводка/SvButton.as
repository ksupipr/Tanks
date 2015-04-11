package{
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.*;
	import flash.net.*;
	import flash.text.*;
	
	public class SvButton extends MovieClip{
		
		public static var txt0:TextField=new TextField();
		public static var txt1:TextField=new TextField();
		public static var txt2:TextField=new TextField();
		public static var txt3:TextField=new TextField();
		public static var txt4:TextField=new TextField();
		public static var txt5:TextField=new TextField();
		public static var txt6:TextField=new TextField();
		public static var txt7:TextField=new TextField();
		public static var txt8:TextField=new TextField();
		public static var txt9:TextField=new TextField();
		public static var txt10:TextField=new TextField();
		public static var txt11:TextField=new TextField();
		public static var txt12:TextField=new TextField();
		public static var txt13:TextField=new TextField();
		public static var txt14:TextField=new TextField();
		public static var txt15:TextField=new TextField();
		public static var txt16:TextField=new TextField();
		public static var txt17:TextField=new TextField();
		public static var txt18:TextField=new TextField();
		public static var txt19:TextField=new TextField();
		public static var tf:TextFormat=new TextFormat("Verdana", 9, 0x195F1E, true, false);
		
		public static var pages:int=0;
		public static var page:int=0;
		
		public static var stg_cl:MovieClip;
		public static var serv_url:String="empty";
		public static var stg_class:Class;
		
		public static var ar:Array=new Array();
		public static var Y1:Array=new Array();
		public static var slgn:Array=new Array();
		public static var infs:Array=new Array();
		public static var link:Array=new Array();
		public static var idgm:Array=new Array();
		public static var Y:int=0;
		public var i_text:String="";
		
		public function urlInit(url:String,clip:MovieClip){
			serv_url=url;
			stg_cl=clip;
			stg_class=stg_cl.getClass(stg_cl);
		}
		
		public function SvButton(){
			super();
			Security.allowDomain("*");
			stop();
			
			addEventListener(MouseEvent.MOUSE_OVER, m_over);
			addEventListener(MouseEvent.MOUSE_OUT, m_out);
			addEventListener(MouseEvent.MOUSE_DOWN, m_press);
			addEventListener(MouseEvent.MOUSE_UP, m_release);
			if(name=="closer_cl"){
				for(var i:int=0;i<20;i++){
					try{
						SvButton["txt"+i].name="txt"+i;
						SvButton["txt"+i].addEventListener(MouseEvent.MOUSE_OVER, m_over);
						SvButton["txt"+i].addEventListener(MouseEvent.MOUSE_OUT, m_out);
						SvButton["txt"+i].addEventListener(MouseEvent.MOUSE_DOWN, m_press);
						SvButton["txt"+i].addEventListener(MouseEvent.MOUSE_UP, m_release);
						//wind2["scroll_cl"]["sc"].addEventListener(MouseEvent.MOUSE_MOVE, m_move);
					}catch(er:Error){
						
					}
				}
			}
		}
		
		public function sendRequest(names:Array, attr:Array, idies:Array){
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
					if(int(idies[1][0])==17){
						loader.addEventListener(Event.COMPLETE, reiting);
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
			stg_cl.warn_f(10,"");
			loader.load(rqs);
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function onError(event:IOErrorEvent):void{
			stg_cl.warn_f(4,"Сводка");
		}
		
		public function clearReit(){
			for(var i:int=0;i<22;i++){
				try{
					root["reit"]["rang"+i].text="";
					root["reit"]["name"+i].text="";
					root["reit"]["game"+i].text="";
					root["reit"]["num"+i].text="";
					root["reit"]["win"+i].text="";
					root["reit"]["lose"+i].text="";
					root["reit"]["frag"+i].text="";
					
					root["reit"]["rang"+i].textColor=0x990000;
					root["reit"]["name"+i].textColor=0x990000;
					root["reit"]["game"+i].textColor=0x990000;
					root["reit"]["num"+i].textColor=0x990000;
					root["reit"]["win"+i].textColor=0x990000;
					root["reit"]["lose"+i].textColor=0x990000;
					root["reit"]["frag"+i].textColor=0x990000;
					root["reit"]["accept"+i].visible=false;
				}catch(er:Error){
					trace("er "+i);
				}
			}
			for(var i:int=0;i<20;i++){
				try{
					SvButton["txt"+i].text="";
					root["reit"].removeChild(SvButton["txt"+i]);
				}catch(er:Error){
					continue;
				}
			}
		}
		
		public function reiting(event:Event):void{
			var str:String="<XML_wrapper>"+event.target.data+"</XML_wrapper>";
			//trace("overWind   "+str);
			try{
				var list:XML=new XML(str);
				list=list.child("result")[0];
			}catch(er:Error){
				stg_cl.warn_f(5,"Неверный формат полученных данных. \nРейтинг арены: страница.");
				stg_cl.erTestReq(2,5,str);
				return;
			}
			try{
				if(int(list.child("err")[0].attribute("code"))!=0){
					stg_cl.warn_f(5,list.child("err")[0].attribute("comm")+"");
					return;
				}
			}catch(er:Error){
				
			}
			//trace("Reiting   "+list);
			var s1:String="line";
			clearReit();
			for(var i:int=0;i<list.child("a_reiting").child(s1).length();i++){
				try{
					root["reit"]["rang"+i].text=list.child("a_reiting").child(s1)[i].attribute("rang")+"";
					root["reit"]["name"+i].text=list.child("a_reiting").child(s1)[i].attribute("name")+"";
					root["reit"]["game"+i].text=list.child("a_reiting").child(s1)[i].attribute("battle")+"";
					root["reit"]["num"+i].text=list.child("a_reiting").child(s1)[i].attribute("reiting")+"";
					root["reit"]["win"+i].text=list.child("a_reiting").child(s1)[i].attribute("win")+"";
					root["reit"]["lose"+i].text=list.child("a_reiting").child(s1)[i].attribute("lose")+"";
					root["reit"]["frag"+i].text=list.child("a_reiting").child(s1)[i].attribute("kill")+"";
					if(int(list.child("a_reiting").child(s1)[i].attribute("dopusk"))){
						root["reit"]["accept"+i].visible=true;
					}
					if(Number(list.child("a_reiting").child(s1)[i].attribute("sn_id"))==stg_cl["v_id"]){
						root["reit"]["rang"+i].textColor=0x003300;
						root["reit"]["name"+i].textColor=0x003300;
						root["reit"]["game"+i].textColor=0x003300;
						root["reit"]["num"+i].textColor=0x003300;
						root["reit"]["win"+i].textColor=0x003300;
						root["reit"]["lose"+i].textColor=0x003300;
						root["reit"]["frag"+i].textColor=0x003300;
					}
				}catch(er:Error){
					//trace(i);
					continue;
				}
			}
			var count:int=0;
			var count1:int=0;
			var count2:int=0;
			var w:int=0;
			var vect:int=0;
			pages=int(list.child("page")[0].attribute("max_page"));
			page=int(list.child("page")[0].attribute("now"));
			//pages=20;
			//page=10;
			//trace(pages+"   "+page);
			var cicle:int=10;
			if(page<5){
				cicle+=(5-page)*2;
			}
			for(var i:int=0;i<cicle;i++){
				//trace(page+"   "+pages+"   "+vect);
				if((page-vect)>0&&(page-vect)<=pages){
					if(vect==5){
						break;
					}
					count=5-vect;
					SvButton["txt"+count].embedFonts=true;
					SvButton["txt"+count].selectable=false;
					SvButton["txt"+count].multiline=false;
					SvButton["txt"+count].autoSize=TextFieldAutoSize.LEFT;
					SvButton["txt"+count].wordWrap=false;
					SvButton["txt"+count].antiAliasType=AntiAliasType.ADVANCED;
					SvButton["txt"+count].defaultTextFormat=tf;
					if(vect==0){
						SvButton["txt"+count].textColor=0x00ff00;
					}else{
						SvButton["txt"+count].textColor=0x195F1E;
					}
					SvButton["txt"+count].text=(page-vect)+"";
					SvButton["txt"+count].y=381;
					w+=SvButton["txt"+count].width+10;
					//trace(SvButton["txt"+count].text+"   "+count+"   "+vect+"   "+SvButton["txt"+count].width+"   "+w);
					if(w>175){
						//trace("count1   "+count);
						SvButton["txt"+count].text="";
						break;
					}
					if(vect<0){
						vect--;
					}else if(vect==0){
						vect=-1;
					}
					vect=-vect;
					count1=count;
					count2++;
				}else{
					if(vect<0){
						vect--;
					}else if(vect==0){
						vect=-1;
					}
					vect=-vect;
				}
			}
			count=0;
			for(var i:int=0;i<20;i++){
				if(SvButton["txt"+i].text!=""){
					if(count>0){
						//trace(SvButton["txt"+(i-1)].width+"   "+SvButton["txt"+(i-1)].height);
						SvButton["txt"+i].x=SvButton["txt"+(i-1)].x+SvButton["txt"+(i-1)].width+10;
					}else{
						//trace(SvButton["txt"+(i)].width+"   "+SvButton["txt"+(i)].height);
						SvButton["txt"+i].x=200;
					}
					//trace(i+"   "+SvButton["txt"+i].text+"   "+SvButton["txt"+i].x);
					root["reit"].addChild(SvButton["txt"+i]);
					count++;
				}
			}
			root["reit"].visible=true;
			stg_cl.warn_f(9,"");
			try{System.disposeXML(list);}catch(er:Error){}
		}
		
		public function newS(sv1:Array,sv2:Array){
			//stg_cl.errTest("Svodka-Parse   ",int(200));
			//trace("Svodka-Parse   ");
			try{
			Y=64;
			}catch(er:Error){
				stg_cl.errTest("Svodka-Error24   "+er+"   "+parent.parent,int(600/2));
			}
			for(var i:int=0;i<sv1.length;i++){
				try{
				slgn.push(0);
				infs.push(0);
				link.push(0);
				idgm.push("0");
				}catch(er:Error){
					stg_cl.errTest("Svodka-Error17   "+er+"   "+parent.parent,int(600/2));
				}
				try{
				ar.push(new date_cl());
				ar[ar.length-1]["d_cl"].visible=true;
				ar[ar.length-1]["st_cl"].visible=false;
				}catch(er:Error){
					stg_cl.errTest("Svodka-Error16   "+er+"   "+parent.parent,int(600/2));
				}
				try{
				ar[ar.length-1]["d_cl"]["date_tx"].text=sv1[i]+"";
				}catch(er:Error){
					stg_cl.errTest("Svodka-Error15   "+er+"   "+parent.parent,int(600/2));
				}
				try{
					ar[ar.length-1].y=Y;
					Y1.push(Y);
				}catch(er:Error){
					stg_cl.errTest("Svodka-Error14   "+er+"   "+parent.parent,int(600/2));
				}
				try{
					ar[ar.length-1].x=15;
					if(ar[ar.length-1].y<57||ar[ar.length-1].y>332){
						ar[ar.length-1].visible=false;
					}
				}catch(er:Error){
					stg_cl.errTest("Svodka-Error9   "+er+"   "+parent.parent,int(600/2));
				}
				try{
				Y+=16;
				}catch(er:Error){
					stg_cl.errTest("Svodka-Error18   "+er+"   "+parent.parent,int(600/2));
				}
				try{
					parent.parent.addChildAt(ar[ar.length-1],parent.parent.numChildren-5);
				}catch(er:Error){
					stg_cl.errTest("Svodka-Error5   "+er+"   "+parent.parent,int(600/2));
				}
				for(var j:int=0;j<sv2[i].length;j++){
					var clip:MovieClip;
					try{
					clip=new date_cl();
					ar.push(clip);
					ar[ar.length-1]["d_cl"].visible=false;
					ar[ar.length-1]["st_cl"].visible=true;
					ar[ar.length-1]["st_cl"]["look"].stop();
					ar[ar.length-1]["st_cl"]["link"].stop();
					ar[ar.length-1]["st_cl"]["link"].addEventListener(MouseEvent.MOUSE_OVER, m_over);
					ar[ar.length-1]["st_cl"]["link"].addEventListener(MouseEvent.MOUSE_OUT, m_out);
					ar[ar.length-1]["st_cl"]["link"].addEventListener(MouseEvent.MOUSE_DOWN, m_press);
					ar[ar.length-1]["st_cl"]["link"].addEventListener(MouseEvent.MOUSE_UP, m_release);
					
					ar[ar.length-1]["st_cl"]["look"].addEventListener(MouseEvent.MOUSE_OVER, m_over);
					ar[ar.length-1]["st_cl"]["look"].addEventListener(MouseEvent.MOUSE_OUT, m_out);
					ar[ar.length-1]["st_cl"]["look"].addEventListener(MouseEvent.MOUSE_DOWN, m_press);
					ar[ar.length-1]["st_cl"]["look"].addEventListener(MouseEvent.MOUSE_UP, m_release);
					
					ar[ar.length-1]["st_cl"]["red_slog"].addEventListener(MouseEvent.MOUSE_OVER, m_over);
					ar[ar.length-1]["st_cl"]["red_slog"].addEventListener(MouseEvent.MOUSE_OUT, m_out);
					ar[ar.length-1]["st_cl"]["red_slog"].addEventListener(MouseEvent.MOUSE_DOWN, m_press);
					ar[ar.length-1]["st_cl"]["red_slog"].addEventListener(MouseEvent.MOUSE_UP, m_release);
					
					ar[ar.length-1]["st_cl"]["red_inf"].addEventListener(MouseEvent.MOUSE_OVER, m_over);
					ar[ar.length-1]["st_cl"]["red_inf"].addEventListener(MouseEvent.MOUSE_OUT, m_out);
					ar[ar.length-1]["st_cl"]["red_inf"].addEventListener(MouseEvent.MOUSE_DOWN, m_press);
					ar[ar.length-1]["st_cl"]["red_inf"].addEventListener(MouseEvent.MOUSE_UP, m_release);
					}catch(er:Error){
						stg_cl.errTest("Svodka-Error19   "+er+"   "+ar+"   "+ar.length+"   "+sv2[i].length+"   "+j,int(100/2));
						stg_cl.errTest("Svodka-Error19   "+clip,int(200/2));
						clip=new date_cl();
						stg_cl.errTest("Svodka-Error19   "+clip,int(300/2));
					}
					try{
					if(Math.floor(j/2)*2==j){
						ar[ar.length-1]["st_cl"]["line_cl"].gotoAndStop(1);
					}else{
						ar[ar.length-1]["st_cl"]["line_cl"].gotoAndStop(2);
					}
					}catch(er:Error){
						stg_cl.errTest("Svodka-Error20   "+er+"   "+parent.parent,int(600/2));
					}
					try{
					ar[ar.length-1]["st_cl"]["stat_tx"].text=sv2[i][j][0];
					ar[ar.length-1]["st_cl"]["name_tx"].text=sv2[i][j][1];
					}catch(er:Error){
						stg_cl.errTest("Svodka-Error21   "+er+"   "+parent.parent,int(600/2));
					}
					//ar[ar.length-1]["red_inf"]["i_text"]=sv2[i][j][2];
					try{
					slgn.push(sv2[i][j][5]);
					infs.push(sv2[i][j][2]);
					link.push(sv2[i][j][4]);
					idgm.push(sv2[i][j][3]);
					}catch(er:Error){
						stg_cl.errTest("Svodka-Error22   "+er+"   "+parent.parent,int(600/2));
					}
					try{
						ar[ar.length-1].y=Y;
						Y1.push(Y);
					}catch(er:Error){
						stg_cl.errTest("Svodka-Error13   "+er+"   "+parent.parent,int(600/2));
					}
					try{
						ar[ar.length-1].x=15;
						if(ar[ar.length-1].y<57||ar[ar.length-1].y>332){
							ar[ar.length-1].visible=false;
						}
					}catch(er:Error){
						stg_cl.errTest("Svodka-Error12   "+er+"   "+parent.parent,int(600/2));
					}
					try{
					Y+=13;
					}catch(er:Error){
						stg_cl.errTest("Svodka-Error23   "+er+"   "+parent.parent,int(600/2));
					}
					try{
						ar[ar.length-1].name="s"+(ar.length-1);
					}catch(er:Error){
						stg_cl.errTest("Svodka-Error10   "+er+"   "+parent.parent,int(600/2));
					}
					try{
						parent.parent.addChildAt(ar[ar.length-1],parent.parent.numChildren-5);
					}catch(er:Error){
						stg_cl.errTest("Svodka-Error6   "+er+"   "+parent.parent,int(600/2));
					}
				}
			}
			try{
				root["scroll_cl"]["sc"].y=root["scroll_cl"]["rect"].y+1;
				root["scroll_cl"]["sc"].height=(root["scroll_cl"]["rect"].height/(ar.length-16))*2;
			}catch(er:Error){
				stg_cl.errTest("Svodka-Error7   "+er+"   "+parent.parent,int(600/2));
			}
			try{
				stg_cl.createMode(5);
			}catch(er:Error){
				stg_cl.errTest("Svodka-Error8   "+er+"   "+parent.parent,int(600/2));
			}
			root["reit"].visible=false;
		}
		
		public function m_over(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			//trace("name    "+event.currentTarget.name);
			//trace("name1   "+name);
			if(!stg_cl["warn_er"]){
				Mouse.cursor=MouseCursor.BUTTON;
				if(event.currentTarget.name=="red_inf"){
					showInfo(infs[int(event.currentTarget.parent.parent.name.slice(1,4))],event.currentTarget);
				}else if(event.currentTarget.name=="red_slog"){
					showInfo(slgn[int(event.currentTarget.parent.parent.name.slice(1,4))],event.currentTarget);
				}else if(event.currentTarget.name.slice(0,3)=="txt"){
					return;
				}
				event.currentTarget.gotoAndStop("over");
			}
		}
		
		public function m_out(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				Mouse.cursor=MouseCursor.AUTO;
				if(event.currentTarget.name=="red_inf"){
					hideInfo();
				}else if(event.currentTarget.name=="red_slog"){
					hideInfo();
				}else if(event.currentTarget.name.slice(0,3)=="txt"){
					return;
				}
				event.currentTarget.gotoAndStop("out");
			}
		}
		
		public function m_Release(event:MouseEvent){
			stage.removeEventListener(MouseEvent.MOUSE_UP, m_Release);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, m_move);
		}
		
		public function m_move(event:MouseEvent){
				m_scroll();
		}
		
		public function m_scroll(){
				var bgn:Number=root["scroll_cl"]["sc"].y;
				root["scroll_cl"]["sc"].y=root["scroll_cl"]["rect"].mouseY/*+root["scroll_cl"]["sc"].height/2*/;
				sc_coor();
				var lst:Number=root["scroll_cl"]["sc"].y;
				var diff:Number=(lst-bgn)/(root["scroll_cl"]["rect"].height-3-root["scroll_cl"]["sc"].height);
				all_coor(diff);
		}
		
		public function sc_coor(){
			if(root["scroll_cl"]["sc"].y<root["scroll_cl"]["rect"].y+1){
				root["scroll_cl"]["sc"].y=root["scroll_cl"]["rect"].y+1;
			}else if(root["scroll_cl"]["sc"].y>root["scroll_cl"]["rect"].y+(root["scroll_cl"]["rect"].height-root["scroll_cl"]["sc"].height)-2){
				root["scroll_cl"]["sc"].y=root["scroll_cl"]["rect"].y+(root["scroll_cl"]["rect"].height-root["scroll_cl"]["sc"].height)-2;
			}
		}
		
		public function all_coor(diff:Number){
			for(var i:int=0;i<ar.length;i++){
				Y1[i]-=(diff*(Y-316.9));
				ar[i].y=int(Y1[i]);
				if(ar[i].y<57||ar[i].y>332){
					ar[i].visible=false;
				}else{
					ar[i].visible=true;
				}
			}
		}
		
		public function m_press(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(event.currentTarget.name.slice(0,3)=="txt"){
					sendRequest([["query"],["action"]],[["id"],["id","page"]],[["2"],["17",event.currentTarget.text]]);
					return;
				}else if(event.currentTarget.name=="sc"){
					stage.addEventListener(MouseEvent.MOUSE_MOVE, m_move);
					stage.addEventListener(MouseEvent.MOUSE_UP, m_Release);
				}else if(event.currentTarget.name=="rect"){
					event.currentTarget.m_scroll();
					stage.addEventListener(MouseEvent.MOUSE_MOVE, m_move);
					stage.addEventListener(MouseEvent.MOUSE_UP, m_Release);
				}
				event.currentTarget.gotoAndStop("press");
			}
		}
		
		public function m_release(event:MouseEvent){
			if(stg_cl["drag_cl"]!=null){
				return;
			}
			if(!stg_cl["warn_er"]){
				if(event.currentTarget.name=="closer_cl"){
					for(var i:int=0;i<ar.length;i++){
						parent.parent.removeChild(ar[i]);
					}
					ar=new Array();
					Y1=new Array();
					slgn=new Array();
					infs=new Array();
					link=new Array();
					idgm=new Array();
					stg_cl.createMode(1);
				}else if(event.currentTarget.name=="link"){
					stg_cl.linkTo(new URLRequest(link[int(event.currentTarget.parent.parent.name.slice(1,4))]));
				}else if(event.currentTarget.name=="look"){
					stg_cl["sv_wall"]=true;
					stg_class.stat_cl["ch1"].setNamePl(event.currentTarget.parent["name_tx"].text);
					stg_class.stat_cl["ch1"].lookSv(idgm[int(event.currentTarget.parent.parent.name.slice(1,4))]);
				}else if(event.currentTarget.name=="up"){
					var bgn:Number=root["scroll_cl"]["sc"].y;
					root["scroll_cl"]["sc"].y-=root["scroll_cl"]["sc"].height/2;
					event.currentTarget.sc_coor();
					var lst:Number=root["scroll_cl"]["sc"].y;
					var diff:Number=(lst-bgn)/(root["scroll_cl"]["rect"].height-3-root["scroll_cl"]["sc"].height);
					event.currentTarget.all_coor(diff);
				}else if(event.currentTarget.name=="down"){
					var bgn:Number=root["scroll_cl"]["sc"].y;
					root["scroll_cl"]["sc"].y+=root["scroll_cl"]["sc"].height/2;
					event.currentTarget.sc_coor();
					var lst:Number=root["scroll_cl"]["sc"].y;
					var diff:Number=(lst-bgn)/(root["scroll_cl"]["rect"].height-3-root["scroll_cl"]["sc"].height);
					event.currentTarget.all_coor(diff);
				}else if(event.currentTarget.name=="cmd_cl"){
					event.currentTarget.sendRequest([["query"],["action"]],[["id"],["id","page"]],[["2"],["17",""+1]]);
				}else if(event.currentTarget.name=="find_self"){
					event.currentTarget.sendRequest([["query"],["action"]],[["id"],["id","page"]],[["2"],["17",""+0]]);
				}else if(event.currentTarget.name=="closer_cl1"){
					root["reit"].visible=false;
				}else if(name=="left1"){
					sendRequest([["query"],["action"]],[["id"],["id","page","offline"]],[["2"],["17","1"]]);
				}else if(name=="left2"){
					if((page-10)>0){
						sendRequest([["query"],["action"]],[["id"],["id","page"]],[["2"],["17",(page-10)+""]]);
					}else{
						sendRequest([["query"],["action"]],[["id"],["id","page"]],[["2"],["17","1"]]);
					}
				}else if(name=="right1"){
					sendRequest([["query"],["action"]],[["id"],["id","page"]],[["2"],["17",pages+""]]);
				}else if(name=="right2"){
					if((page+10)<pages){
						sendRequest([["query"],["action"]],[["id"],["id","page"]],[["2"],["17",(page+10)+""]]);
					}else{
						sendRequest([["query"],["action"]],[["id"],["id","page"]],[["2"],["17",pages+""]]);
					}
				}else if(event.currentTarget.name.slice(0,3)=="txt"){
					return;
				}
				event.currentTarget.gotoAndStop("over");
			}
		}
		
		public function showInfo(info:String,cl:Object){
			if(info==""){
				return;
			}
			root["info_tx"].selectable=false;
			root["info_tx"].multiline=true;
			root["info_tx"].autoSize=TextFieldAutoSize.LEFT;
			root["info_tx"].wordWrap=false;
			root["info_tx"].textColor=0xF0DB7D;
			root["info_tx"].text=info;
			root["info_tx"].x=cl.x+cl.parent.parent.x;
			root["info_tx"].y=cl.y-root["info_tx"].height-cl.height/2+cl.parent.parent.y;
			if(root["info_tx"].y<0){
				root["info_tx"].y=0;
				root["info_tx"].x=cl.x+cl.width+10;
			}
			var info_w:int=root["info_tx"].width;
			var info_h:int=root["info_tx"].height;
			var info_rw:int=10;
			var info_rh:int=10;
			St_clip.self.graphics.lineStyle(1, 0x000000, 1, true);
			St_clip.self.graphics.beginFill(0x990700,1);
			St_clip.self.graphics.drawRoundRect(root["info_tx"].x-3, root["info_tx"].y, info_w+10, info_h+2, info_rw, info_rh);
			St_clip.stg.setChildIndex(St_clip.self,St_clip.stg.numChildren-1);
			St_clip.stg.setChildIndex(root["info_tx"],St_clip.stg.numChildren-1);
			root["info_tx"].visible=true;
		}
		
		public function hideInfo(){
			root["info_tx"].visible=false;
			St_clip.self.graphics.clear();
		}
		
	}
}