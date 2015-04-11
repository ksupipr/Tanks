package utils{
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import json.JSON;
	
	public class xFormat{
		
		public static var _class:Class;
		public static var _clip:MovieClip;
		
		public function xFormat(){
			
		}
		
		public static function initFormat(_cl:MovieClip,_cls:Class){
			_clip=_cl;
			_class=_cls;
		}
		
		public static function parseVars(_xml:XML):Object{
			var _obj:Object=new Object();
			var _str:String;
			var line_ar:Array;
			var _name:String;
			var _var:String;
			
			_str=_xml.child("main_btn")[0];
			//_clip.output1("main_btn");
			line_ar=_str.split(/ ^ \s* :: /msgix);
			for(var j:int=0;j<line_ar.length;j++){
				line_ar[j]=line_ar[j].split("=");
				line_ar[j][1]=line_ar[j].slice(1);
				_name=line_ar[j][0];
				_var=line_ar[j][1].join("=");
				_var=_var.split(/\s+\n\s+/g).join("\n");
				_var=_var.split(/[\n\r]/g).join("");
				_var="[font=\"Arial Black\" size=\"12\"]"+_var;
				if(_obj[_name]!=null&&_name!=""){
					_clip.output("<b><font color=\"#ff0000\" size=\"11\">DUPLICATE VAR:	</font></b> NAME:"+_name+" LAST:"+_obj[_name]+" NEW:"+_var+"\n");
				}
				_obj[_name]=_var;
				//_clip.output1(_name+"="+_var);
			}
			
			_str=_xml.child("text")[0];
			//_clip.output1("text");
			line_ar=_str.split(/ ^ \s* :: /msgix);
			for(var j:int=0;j<line_ar.length;j++){
				line_ar[j]=line_ar[j].split("=");
				line_ar[j][1]=line_ar[j].slice(1);
				_name=line_ar[j][0];
				_var=line_ar[j][1].join("=");
				_var=_var.split(/\s+\n\s+/g).join("\n");
				_var=_var.split(/[\n\r]/g).join("");
				if(_obj[_name]!=null&&_name!=""){
					_clip.output("<b><font color=\"#ff0000\" size=\"11\">DUPLICATE VAR:	</font></b> NAME:"+_name+" LAST:"+_obj[_name]+" NEW:"+_var+"\n");
				}
				_obj[_name]=_var;
				//_clip.output1(_name+"="+_var);
			}
			
			return _obj;
		}
		
		public static function format(_str:String,_txtf:TextField,_cl:MovieClip=null):void{
			var _stsh:StyleSheet = new StyleSheet();
			if(_txtf.styleSheet!=null){
				_stsh=_txtf.styleSheet;
			}
			
			var _place:Object=new Object();
			var _embed:Boolean=true;
			var close_tegs:Object=new Object();
			var _obj:Object=new Object();
			_obj["url"]=new Object();
			_obj["font"]=new Object();
			_obj["bold"]=new Object();
			_obj["italic"]=new Object();
			_obj["bold_i"]=new Object();
			_obj["under"]=new Object();
			_obj["br"]=new Object();
			_obj["li"]=new Object();
			_obj["html"]=new Object();
			_obj["any"]=new Object();
			_obj["img"]=new Object();
			_obj["tx_place"]=new Object();
			_obj["url"].count=0;
			_obj["font"].count=0;
			_obj["bold"].count=0;
			_obj["italic"].count=0;
			_obj["bold_i"].count=0;
			_obj["under"].count=0;
			_obj["br"].count=0;
			_obj["li"].count=0;
			_obj["html"].count=0;
			_obj["any"].count=0;
			_obj["img"].count=0;
			_obj["tx_place"].count=0;
			_str=_str.split(/\s+\n\s+/g).join("\n");
			var code_ar:Array=_str.match(/ \[{1} [^\[\]]* \]{1}/sgix);
			for(var i:int=0;i<code_ar.length;i++){
				var _teg:String=code_ar[i];
				code_ar[i]=code_ar[i].split(/ \s* \[ \s* /gx).join("");
				code_ar[i]=code_ar[i].split(/ \s* \] \s* /gx).join("");
				code_ar[i]=code_ar[i].split(/ \s*  = \s* /gx).join("=");
				var _param:Object=new Object();
				_param.source=_teg;
				if(code_ar[i].toLowerCase()=="b"){
					_param.bold="<b>";
				}else if(code_ar[i].toLowerCase()=="/b"){
					_param.bold="</b>";
				}else if(code_ar[i].toLowerCase()=="i"){
					_param.italic="<i>";
				}else if(code_ar[i].toLowerCase()=="/i"){
					_param.italic="</i>";
				}else if(code_ar[i].toLowerCase()=="u"){
					_param.under="<u>";
				}else if(code_ar[i].toLowerCase()=="/u"){
					_param.under="</u>";
				}else if(code_ar[i].toLowerCase()=="br"){
					_param.br="<br>";
				}else if(code_ar[i].toLowerCase()=="li"){
					_param.li="<li>";
				}else if(code_ar[i].toLowerCase()=="/li"){
					_param.li="</li>";
				}else if(code_ar[i]=="("){
					_param.html="&lt;";
				}else if(code_ar[i]==")"){
					_param.html="&gt;";
				}else if(code_ar[i]=="|"){
					_param.html="&amp;";
				}else{
					code_ar[i]=" "+code_ar[i];
					var _ar:Array=code_ar[i].match(/ \s+ [^\s]* = \"{1} [^\"]* \"{1} /sgix);
					for(var j:int=0;j<_ar.length;j++){
						if(_ar[j]==""){
							continue;
						}
						_ar[j]=_ar[j].split("=");
						var _var:String=_ar[j][0].toLowerCase();
						_var=_var.split(/ \s+ /gx).join("");
						var _value:String=_ar[j].slice(1).join("=");
						_value=_value.split("\"").join("");
						_value=_value.split("\'").join("\"");
						_param[_var]=_value;
					}
				}
				var _in:String="any";
				if(_param["url"]!=null){
					_in="url";
				}else if(_param["update"]!=null){
					_in="font";
				}else if(_param["font"]!=null){
					_in="font";
				}else if(_param["bold"]!=null){
					_in="bold";
				}else if(_param["italic"]!=null){
					_in="italic";
				}else if(_param["under"]!=null){
					_in="under";
				}else if(_param["br"]!=null){
					_in="br";
				}else if(_param["li"]!=null){
					_in="li";
				}else if(_param["html"]!=null){
					_in="html";
				}else if(_param["img"]!=null){
					_in="img";
				}else if(_param["tx_place"]!=null){
					_in="tx_place";
				}
				_obj[_in]["teg"+_obj[_in]["count"]]=_param;
				_obj[_in]["count"]++;
			}
			for(var _s:String in _obj["url"]){
				if(_s=="count"){
					continue;
				}
				if(_obj["url"][_s]["text"]==null){
					_obj["url"][_s]["text"]=_obj["url"][_s]["url"];
				}
				if(_obj["url"][_s]["target"]==null){
					_obj["url"][_s]["target"]="_blank";
				}
				var _change:String="<a target=\""+_obj["url"][_s]["target"]+"\" href=\""+_obj["url"][_s]["url"]+"\">"+_obj["url"][_s]["text"]+"</a>";
				_str=_str.split(_obj["url"][_s]["source"]).join(_change);
				close_tegs.url="";
			}
			var _sort:Array=new Array();
			for(var _s:String in _obj["font"]){
				if(_s=="count"){
					continue;
				}
				var _num:int=int(_s.slice(3));
				var s_num:String="spaced"+_num;
				if(_num<10){
					s_num="000"+_num;
				}else if(_num<100){
					s_num="00"+_num;
				}else if(_num<1000){
					s_num="0"+_num;
				}else{
					s_num=_num+"";
				}
				_sort.push("teg"+s_num);
			}
			_sort.sort();
			var styles_obj:Object=new Object();
			for(var i:int=0;i<_sort.length;i++){
				var _s:String=_sort[i];
				var _num:int=int(_s.slice(3));
				_s="teg"+_num;
				var _spac_c:int=0;
				var _spaced:String="spaced"+_spac_c;
				while(_stsh.getStyle(_spaced)!=null&&_stsh.getStyle(_spaced).fontFamily!=null){
					_spac_c++;
					_spaced="spaced"+_spac_c;
				}
				var _update:String="false";
				if(_obj["font"][_s]["update"]!=null){
					_update=_obj["font"][_s]["update"];
				}
				var _last:Object;
				if(_update!="false"){
					if(_spac_c>0){
						_last=_stsh.getStyle("spaced"+(_spac_c-1));
					}else{
						_spaced="spaced"+_spac_c;
						_update="false";
					}
				}
				var _stl_obg:Object=new Object();
				if(_obj["font"][_s]["size"]!=null){
					_stl_obg.fontSize=_obj["font"][_s]["size"];
				}else if(_update!="false"&&_last.fontSize!=null){
					_stl_obg.fontSize=_last.fontSize;
				}
				if(_obj["font"][_s]["color"]!=null){
					_stl_obg.color=_obj["font"][_s]["color"];
				}else if(_update!="false"&&_last.color!=null){
					_stl_obg.color=_last.color;
				}
				if(_obj["font"][_s]["font"]!=null){
					_obj["font"][_s]["font"]=_clip.getFont(_obj["font"][_s]["font"],_cl);
					_stl_obg.fontFamily=_obj["font"][_s]["font"];
				}else if(_update!="false"&&_last.fontFamily!=null){
					_stl_obg.fontFamily=_last.fontFamily;
				}else{
					_stl_obg.fontFamily="Verdana";
				}
				if(_stl_obg.fontFamily=="_sans"){
					_embed=false;
				}else{
					_embed=true;
				}
				if(_obj["font"][_s]["textindent"]!=null){
					_stl_obg.textIndent=_obj["font"][_s]["textindent"];
				}else if(_update!="false"&&_last.textIndent!=null){
					_stl_obg.textIndent=_last.textIndent;
				}
				if(_obj["font"][_s]["leading"]!=null){
					_stl_obg.leading=_obj["font"][_s]["leading"];
				}else if(_update!="false"&&_last.leading!=null){
					_stl_obg.leading=_last.leading;
				}
				if(_obj["font"][_s]["marginleft"]!=null){
					_stl_obg.marginLeft=_obj["font"][_s]["marginleft"];
				}else if(_update!="false"&&_last.marginLeft!=null){
					_stl_obg.marginLeft=_last.marginLeft;
				}
				if(_obj["font"][_s]["marginright"]!=null){
					_stl_obg.marginRight=_obj["font"][_s]["marginright"];
				}else if(_update!="false"&&_last.marginRight!=null){
					_stl_obg.marginRight=_last.marginRight;
				}
				if(_obj["font"][_s]["letterspacing"]!=null){
					_stl_obg.letterSpacing=_obj["font"][_s]["letterspacing"];
				}else if(_update!="false"&&_last.letterSpacing!=null){
					_stl_obg.letterSpacing=_last.letterSpacing;
				}
				if(_obj["font"][_s]["display"]!=null){
					_stl_obg.display=_obj["font"][_s]["display"];
				}else if(_update!="false"&&_last.display!=null){
					_stl_obg.display=_last.display;
				}else{
					_stl_obg.display="inline";
				}
				if(_obj["font"][_s]["textalign"]!=null){
					_stl_obg.textAlign=_obj["font"][_s]["textalign"];
				}else if(_update!="false"&&_last.textAlign!=null){
					_stl_obg.textAlign=_last.textAlign;
				}
				_stsh.setStyle(_spaced, _stl_obg);
				_stl_obg.update=_update;
				styles_obj[_spaced]=_stl_obg;
				var _letter:String="<"+_spaced+">";
				close_tegs.font="</"+_spaced+">";
				
				var _pre:String="";
				if(_spac_c>0){
					_pre="</"+_spaced.substr(0,_spaced.length-1)+""+(_spac_c-1)+">";
				}
				var _change:String=_pre+_letter;
				_str=_str.split(_obj["font"][_s]["source"]).join(_change);
			}
			for(var _s:String in _obj["img"]){
				if(_s=="count"){
						continue;
					}
				var _letter:String="";
				if(_obj["img"][_s]["img"]!=null){
					_letter+="src=\""+_obj["img"][_s]["img"]+"\" ";
				}else if(_update!="false"){
					_letter+="src=\"\" ";
				}
				if(_obj["img"][_s]["w"]!=null){
					_letter+="width=\""+_obj["img"][_s]["w"]+"\" ";
				}
				if(_obj["img"][_s]["h"]!=null){
					_letter+="height=\""+_obj["img"][_s]["h"]+"\" ";
				}
				if(_obj["img"][_s]["align"]!=null){
					_letter+="align=\""+_obj["img"][_s]["align"]+"\" ";
				}
				if(_obj["img"][_s]["hsp"]!=null){
					_letter+="hspace=\""+_obj["img"][_s]["hsp"]+"\" ";
				}
				if(_obj["img"][_s]["vsp"]!=null){
					_letter+="vspace=\""+_obj["img"][_s]["vsp"]+"\" ";
				}
				if(_obj["img"][_s]["id"]!=null){
					_letter+="id=\""+_obj["img"][_s]["id"]+"\" ";
				}
				if(_obj["img"][_s]["plc"]!=null){
					_letter+="checkPolicyFile=\""+_obj["img"][_s]["plc"]+"\" ";
				}
				var _change:String="<img "+_letter+" />";
				_str=_str.split(_obj["img"][_s]["source"]).join(_change);
				close_tegs.img="";
			}
			var _sort:Array=new Array();
			for(var _s:String in _obj["tx_place"]){
				if(_s=="count"){
						continue;
					}
				var _num:int=int(_s.slice(3));
				var s_num:String="";
				if(_num<10){
					s_num="000"+_num;
				}else if(_num<100){
					s_num="00"+_num;
				}else if(_num<1000){
					s_num="0"+_num;
				}else{
					s_num=_num+"";
				}
				_sort.push("teg"+s_num);
			}
			_sort.sort();
			//_clip.output1(_sort);
			for(var i:int=0;i<_sort.length;i++){
				var _s:String=_sort[i];
				var _num:int=int(_s.slice(3));
				_s="teg"+_num;
				var s_var:String=_obj["tx_place"][_s]["tx_place"];
				s_var.split(/\s+/xgis).join("");
				var _vars:Array=s_var.split(",");
				var tx_pl:Object=new Object();
				for(var _v:int=0;_v<_vars.length;_v++){
					var var_ar:Array=_vars[_v].split(":");
					tx_pl[var_ar[0].toLowerCase()]=Number(var_ar[1]);
				}
				if(tx_pl["x"]!=null){
					_place.x=tx_pl["x"];
				}
				if(tx_pl["y"]!=null){
					_place.y=tx_pl["y"];
				}
				if(tx_pl["w"]!=null){
					_place.width=tx_pl["w"];
				}
				if(tx_pl["h"]!=null){
					_place.height=tx_pl["h"];
				}
				if(tx_pl["r"]!=null){
					_place.rotation=tx_pl["r"];
				}
				if(tx_pl["sx"]!=null){
					_place.scaleX=tx_pl["sx"];
				}
				if(tx_pl["sy"]!=null){
					_place.scaleY=tx_pl["sy"];
				}
				_str=_str.split(_obj["tx_place"][_s]["source"]).join("");
				close_tegs.tx_place="";
			}
			for(var _s:String in _obj["bold"]){
				if(_s=="count"){
					continue;
				}
				var _change:String=_obj["bold"][_s]["bold"];
				_str=_str.split(_obj["bold"][_s]["source"]).join(_change);
				if(_change=="<b>"){
					close_tegs.bold="</b>";
				}else{
					close_tegs.bold="";
				}
			}
			for(var _s:String in _obj["italic"]){
				if(_s=="count"){
					continue;
				}
				var _change:String=_obj["italic"][_s]["italic"];
				_str=_str.split(_obj["italic"][_s]["source"]).join(_change);
				if(_change=="<i>"){
					close_tegs.italic="</i>";
				}else{
					close_tegs.italic="";
				}
			}
			for(var _s:String in _obj["under"]){
				if(_s=="count"){
					continue;
				}
				var _change:String=_obj["under"][_s]["under"];
				_str=_str.split(_obj["under"][_s]["source"]).join(_change);
				if(_change=="<u>"){
					close_tegs.under="</u>";
				}else{
					close_tegs.under="";
				}
			}
			for(var _s:String in _obj["html"]){
				if(_s=="count"){
					continue;
				}
				var _change:String=_obj["html"][_s]["html"];
				_str=_str.split(_obj["html"][_s]["source"]).join(_change);
				close_tegs.html="";
			}
			for(var _s:String in _obj["br"]){
				if(_s=="count"){
					continue;
				}
				var _change:String=_obj["br"][_s]["br"];
				_str=_str.split(_obj["br"][_s]["source"]).join(_change);
				close_tegs.br="";
			}
			for(var _s:String in _obj["li"]){
				if(_s=="count"){
						continue;
					}
				var _change:String=_obj["li"][_s]["li"];
				_str=_str.split(_obj["li"][_s]["source"]).join(_change);
				close_tegs.li="";
			}
			for(var i:int=0;i<_str.length;i++){
				if(_str.charAt(i)=="\s"){
					_str=_str.substr(i+1);
				}else{
					break;
				}
			}
			for(var i:int=_str.length-1;i>-1;i++){
				if(_str.charAt(i)=="\s"){
					_str=_str.substr(0,i);
				}else{
					break;
				}
			}
			var _spaces:Array=_str.match(/ \[ \s* x \d+  \s* \] /gx);
			for(var i:int=0;i<_spaces.length;i++){
				var num_s:String=_spaces[i];
				num_s=num_s.split(/ \s* \[ \s* /gx).join("");
				num_s=num_s.split(/ \s* \] \s* /gx).join("");
				var _num:int=int(num_s.substr(1));
				var _sp_s:String="";
				for(var j:int=0;j<_num;j++){
					_sp_s+="&nbsp;";
				}
				_str=_str.split(_spaces[i]).join(_sp_s);
			}
			for(var _s:String in close_tegs){
				_str+=close_tegs[_s];
			}
			/*var new_td:TextField=new TextField();
			new_td.name=_txtf.name;
			new_td.x=_txtf.x;
			new_td.y=_txtf.y;
			new_td.width=_txtf.width;
			new_td.height=_txtf.height;
			new_td.embedFonts=true;
			new_td.styleSheet = _stsh;
			new_td.condenseWhite=true;
			new_td.htmlText=_str;
			_clip.addChild(new_td);*/
			/*var _prnt:MovieClip=_txtf.parent as MovieClip;
			_prnt.removeChild(_txtf);
			_prnt.addChild(new_td);*/
			//_clip.output1(_txtf+"   "+_stsh);
			_txtf.restrict="";
			_txtf.embedFonts=_embed;
			_txtf.styleSheet = _stsh;
			_txtf.condenseWhite=true;
			_txtf.wordWrap=false;
			_txtf.antiAliasType=AntiAliasType.ADVANCED;
			_txtf.gridFitType=GridFitType.SUBPIXEL;
			if(_place["rotation"]!=0){
				_txtf.scaleX=_txtf.width/(_txtf.width+1);
				_txtf.scaleY=_txtf.height/(_txtf.height+1);
				_txtf.z=0;
			}
			for(var _s:String in _place){
				_txtf[_s]=_place[_s];
			}
			var place_str:String="<tx_place ";
			if(_place["x"]!=null){
				place_str+="x=\""+_place["x"]+"\" ";
			}else{
				place_str+="x=\""+_txtf.x+"\" ";
			}
			if(_place["y"]!=null){
				place_str+="y=\""+_place["y"]+"\" ";
			}else{
				place_str+="y=\""+_txtf.y+"\" ";
			}
			if(_place["w"]!=null){
				place_str+="w=\""+_place["w"]+"\" ";
			}else{
				place_str+="w=\""+_txtf.width+"\" ";
			}
			if(_place["h"]!=null){
				place_str+="h=\""+_place["h"]+"\" ";
			}else{
				place_str+="h=\""+_txtf.height+"\" ";
			}
			if(_place["r"]!=null){
				place_str+="r=\""+_place["r"]+"\" ";
			}else{
				place_str+="r=\""+_txtf.rotation+"\" ";
			}
			if(_place["sx"]!=null){
				place_str+="sx=\""+_place["sx"]+"\" ";
			}else{
				place_str+="sx=\""+_txtf.scaleX+"\" ";
			}
			if(_place["sy"]!=null){
				place_str+="sy=\""+_place["sy"]+"\" ";
			}else{
				place_str+="sy=\""+_txtf.scaleY+"\" ";
			}
			place_str+="/>";
			var html_str:String=place_str+"\n"+_txtf.htmlText+_str;
			html_str=html_str.split(/ \r /xgis).join("\n");
			//trace("\n\nhtml_str   \n"+html_str);
			_str=_str.split(/\s+/g).join(" ");
			_txtf.htmlText=place_str+"\n"+_txtf.htmlText+_str;
			//trace(_txtf.htmlText);
			_txtf.useRichTextClipboard=true;
			
			_txtf.mouseEnabled=true;
			//_txtf.selectable=true;
			_txtf.contextMenu = new ContextMenu();
			_txtf.contextMenu.hideBuiltInItems();
			var cnt_str:String=("[COPY] "+_txtf.text).split(/\s+/xgis).join(" ");
			if(cnt_str.length>90){
				cnt_str=cnt_str.substr(0,90)+"...";
			}
			var _copyItem:ContextMenuItem = new ContextMenuItem(cnt_str);
			_copyItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void{ 
				if(int(_clip["br"])==1){
					_clip.lib.swf.utils.copyField(_txtf,styles_obj,html_str);
				}
			});
			_txtf.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, function(e:ContextMenuEvent):void{ 
				var _ind:int=_txtf.contextMenu.customItems.indexOf(_copyItem);
				if(int(_clip["br"])!=1){
					if(_ind>=0){
						_txtf.contextMenu.customItems.splice(_ind,1);
					}
				}else{
					if(_ind<0){
						_txtf.contextMenu.customItems.push(_copyItem);
					}
				}
			});
			/*for(var i:int=0;i<_txtf.styleSheet.styleNames.length;i++){
				_clip.output1("style "+_txtf.styleSheet.styleNames[i]);
				var _obj:Object=_txtf.styleSheet.getStyle(_txtf.styleSheet.styleNames[i]);
				for(var _s:String in _obj){
					_clip.output1("param "+_s+"="+_obj[_s]);
				}
			}*/
			
			//_clip.output1("["+_txtf.name+"]=\n"+_txtf.htmlText);
			//return _str;
		}
		
	}
	
}