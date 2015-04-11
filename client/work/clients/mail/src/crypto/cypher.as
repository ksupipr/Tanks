package crypto{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import utils.loadObject;
	
	public class cypher{
		
		public static const formats:Object={
			xlab:"swf",
			xsnd:"mp3",
			xart0:"png",
			xart1:"jpg",
			xword:"txt",
			xinfo:"xml",
			xdata:""
		};
		
		private static var limit:int=1000;
		private static var _correct:int=0;
		private static var _self:MovieClip;
		public function cypher(_target:MovieClip){
			_self=_target;
		}
		
		public static function reactivate(){
			de_buffer=new Object();
			try{
				_self.removeEventListener(Event.ENTER_FRAME, decrypt_process);
			}catch(er:Error){}
			_self.addEventListener(Event.ENTER_FRAME, decrypt_process);
		}
		
		public static function deactivate(){
			try{
				_self.removeEventListener(Event.ENTER_FRAME, decrypt_process);
			}catch(er:Error){}
			for(var _name in de_buffer){
				de_buffer[_name]=null;
				delete de_buffer[_name];
			}
			de_buffer=new Object();
			for(var _name in de_crypted){
				de_crypted[_name]=null;
				delete de_crypted[_name];
			}
			de_crypted=new Object();
			_self.output("<b>DEACTIVATE ENCRIPTOR</b>\n");
		}
		
		public static function decode(_data:ByteArray,_name:String,_id:int,_obj:loadObject):void{
			//_self.dispatchEvent(new CryptEvent(CryptEvent.PROGRESS,_name,_id,-1,-1));
			var _input:ByteArray=new ByteArray();
			_input.writeBytes(_data,0,_data.length);
			decrypt(_input,_name,_id,_obj);
		}
		
		private static var _trace:String="";
		
		private static function de_ready(_name:String):void{
			//trace("decode");
			var _obj:Object=de_buffer[_name];
			
			/*_self.stage.addEventListener("click", function(event:Event){
				try{
					var _save:FileReference=new FileReference();
					_save.save(_trace,"log");
					trace("File was saved...");
				}catch(er:Error){
					trace(er.toString());
				}
			});*/
			
			try{
				_obj._mix1.uncompress();
			}catch(er:Error){
				_self.dispatchEvent(new CryptEvent(CryptEvent.ERROR,_obj.ev_obj,_obj.id,0,0,"DECODE ERROR: incorrect file"));
				if(Break(_name)){
					return;
				}
				if(de_buffer.count>1){
					de_buffer.count--;
				}
				de_buffer[_name]=null;
				delete de_buffer[_name];
				return;
			}
			_self.dispatchEvent(new CryptEvent(CryptEvent.COMPLETE,_obj.ev_obj,_obj.id,_obj.ready,_obj.full,"",_obj._mix1));
			if(Break(_name)){
				return;
			}
			try{
				if(de_buffer.count>1){
					de_crypted[_name].ready=_obj.full;
					de_crypted[_name].full=_obj.full;
					de_buffer.count--;
				}else{
					de_crypted[_name].ready=_obj.full;
					de_crypted[_name].full=_obj.full;
					//deactivate();
				}
			}catch(er:Error){}
			try{
				de_buffer[_name]=null;
				delete de_buffer[_name];
			}catch(er:Error){}
		}
		
		private static var _time:Number=0;
		private static var _now:Number=0;
		
		private static function decrypt_process(event:Event):void{
			_now = new Date().time;
			if(_now>_time&&(_now-_time)<1000/_self.stage.frameRate){
				_correct=1;
			}else if(_now>_time&&(_now-_time)>1000/_self.stage.frameRate+10){
				_correct=-1;
			}else{
				_correct=0;
			}
			_time=_now;
			var _cnte:Boolean=false;
			var de_c:uint=de_buffer.count;
			for(var _name in de_buffer){
				if(_name=="count"){
					continue;
				}else if(_cnte){
					_cnte=false;
					continue;
				}
				var _obj:Object=de_buffer[_name];
				var _rand:Vector.<uint>=_obj._rand;
				var _input:Vector.<uint>=_obj._input;
				var _mix:Vector.<uint>=_obj._mix;
				var _mix1:ByteArray=_obj._mix1;
				var _changed:int=_obj.changed;
				var _len:uint=_obj._len;
				var _lim:uint=_obj.limit;
				var _many:uint=_lim/de_c;
				
				if(_correct!=0){
					_lim+=(_lim/10)*_correct;
					if(_lim<150){
						_lim=150;
					}
					_obj.limit=_lim;
				}
				var _limit:int=0;
				if(_changed<1){
					var _data:ByteArray=_obj._data;
					var _jump:uint=_obj._jump;
					var last_i:uint=_obj.i;
					for(var i:uint=last_i;i<_len;i++){
						if(_rand[0]==0&&i==int(_len*.2)+1+_jump){
							var _num:int=_data[i]+1;
							var _s:String="";
							for(var j:uint=1;j<_num;j++){
								_s+=_data[i+j];
							}
							_jump+=j;
							_obj._jump=_jump;
							_rand[0]=uint(_s);
							i--;
						}else if(_rand[1]==0&&i==int(_len*.25)+1+_jump){
							var _num:int=_data[i]+1;
							var _s:String="";
							for(var j:uint=1;j<_num;j++){
								_s+=_data[i+j];
							}
							_jump+=j;
							_obj._jump=_jump;
							_rand[1]=uint(_s);
							i-=_jump-j+1;
						}else if(_rand[2]==0&&i==int(_len/3)+1+_jump){
							var _num:int=_data[i]+1;
							var _s:String="";
							for(var j:uint=1;j<_num;j++){
								_s+=_data[i+j];
							}
							_jump+=j;
							_obj._jump=_jump;
							_rand[2]=uint(_s);
							i-=_jump-j+1;
						}else{
							var _pos:uint=i+_jump;
							_input[i]=_data[_pos];
						}
						_obj.ready++;
						if(i+_jump==_len-1){
							break;
						}else if(i-last_i>_many){
							_obj.i=i+1;
							//de_buffer[_name]=_obj;
							if(_obj==_self){
								//over
								_input[i]=percents();
							}
							_self.dispatchEvent(new CryptEvent(CryptEvent.PROGRESS,_obj.ev_obj,_obj.id,_obj.ready,_obj.full,"",null,1,de_c));
							if(Break(_name)){
								continue;
							}
							_cnte=true;
							break;
						}
					}
					if(_cnte){
						_cnte=false;
						continue;
					}
					_len=_obj._len=i+1;
					_obj.ready=_data.length;
					
					/*_trace=("[_len] = "+_input.length+"\n");
					for(var i:int=0;i<_input.length;i++){
						_trace+=("["+i+"] = "+_input[i]+"\n");
					}*/
					/*if(_len==_obj.geter_int){
						//over
						delete de_crypted[_name];
						return;
					}*/
					_limit=i;
					_obj.i=i;
					_obj.changed=_changed=1;
					de_buffer[_name]=_obj;
					_self.dispatchEvent(new CryptEvent(CryptEvent.PROGRESS,_obj.ev_obj,_obj.id,_obj.ready,_obj.full,"",null,3,de_c));
					if(Break(_name)){
						continue;
					}
				}
				
				if(_changed<2){
					var j:uint=_obj.j;
					var rand2:uint=_rand[2];
					for(var i:uint=j;i<_len;i++){
						var _pos:uint=(i+rand2 >= _len) ? i+rand2-_len : i+rand2;
						_mix[i]=_input[_pos];
						_obj.ready++;
						if((_limit+i)-j>_many){
							_obj.j=i+1;
							//de_buffer[_name]=_obj;
							_self.dispatchEvent(new CryptEvent(CryptEvent.PROGRESS,_obj.ev_obj,_obj.id,_obj.ready,_obj.full,"",null,4,de_c));
							if(Break(_name)){
								continue;
							}
							_cnte=true;
							break;
						}
					}
					if(_cnte){
						_cnte=false;
						continue;
					}
					
					/*_trace+=("[_len] = "+_input.length+"\n");
					for(var i:int=0;i<_input.length;i++){
						_trace+=("["+i+"] = "+_mix[i]+"\n");
					}*/
					
					_limit+=i;
					_obj.j=i;
					_obj.changed=_changed=2;
					//de_buffer[_name]=_obj;
					_self.dispatchEvent(new CryptEvent(CryptEvent.PROGRESS,_obj.ev_obj,_obj.id,_obj.ready,_obj.full,"",null,5,de_c));
					if(Break(_name)){
						continue;
					}
				}
				if(_changed<4){
					var _c:uint=_len/2;
					if(_changed<3){
						var _a:uint=_rand[1];
						_obj.k=_a;
						_obj.changed=_changed=3;
						_obj.ready+=_a<<1;
					}
					var k:uint=_obj.k;
					if(_obj.ready==_obj.to_parse_over){
						//over
						_obj.ev_obj=_self.reserve_la_bin;
						return;
					}
					for(var i:uint=k;i<_c;i++){
						var _pos:uint=_len-i;
						
						/*var _buff:uint=_mix[i];
						_mix[i]=_mix[_pos];
						_mix[_pos]=_buff;*/
						
						_mix[i] ^= _mix[_pos];
						_mix[_pos] ^= _mix[i];
						_mix[i] ^= _mix[_pos];
						
						_obj.ready++;
						if((_limit+i)-k>_many){
							_obj.k=i+1;
							//de_buffer[_name]=_obj;
							_self.dispatchEvent(new CryptEvent(CryptEvent.PROGRESS,_obj.ev_obj,_obj.id,_obj.ready,_obj.full,"",null,6,de_c));
							if(Break(_name)){
								continue;
							}
							_cnte=true;
							break;
						}
					}
					if(_cnte){
						_cnte=false;
						continue;
					}
					
					/*_trace+=("[_len] = "+_input.length+"\n");
					for(var i:int=0;i<_input.length;i++){
						_trace+=("["+i+"] = "+_mix[i]+"\n");
					}*/
					
					_obj.changed=_changed=4;
				}
				if(_changed<5){
					_limit+=i;
					_obj.k=i;
					_obj.changed=_changed=5;
					//de_buffer[_name]=_obj;
					_self.dispatchEvent(new CryptEvent(CryptEvent.PROGRESS,_obj.ev_obj,_obj.id,_obj.ready,_obj.full,"",null,7,de_c));
					if(Break(_name)){
						continue;
					}
				}
				if(_changed<6){
					var m:uint=_obj.m;
					var rand0:uint=_rand[0];
					for(var i:uint=m;i<_len;i++){
						var _pos:uint=(i+rand0 >= _len) ? i+rand0-_len : i+rand0;
						_mix1[i]=_mix[_pos];
						_obj.ready++;
						if((_limit+i)-m>_many){
							_obj.m=i+1;
							//de_buffer[_name]=_obj;
							_self.dispatchEvent(new CryptEvent(CryptEvent.PROGRESS,_obj.ev_obj,_obj.id,_obj.ready,_obj.full,"",null,8,de_c));
							if(Break(_name)){
								continue;
							}
							_cnte=true;
							break;
						}
					}
					if(_cnte){
						_cnte=false;
						continue;
					}
					
					/*_trace+=("[_len] = "+_mix1.length+"\n");
					for(var i:int=0;i<_mix1.length;i++){
						_trace+=("["+i+"] = "+_mix1[i]+"\n");
					}*/
					
					_obj.m=i;
					//de_buffer[_name]=_obj;
					//_self.dispatchEvent(new CryptEvent(CryptEvent.PROGRESS,_name,_obj.id,_obj.ready,_obj.full,"",null,9,de_c));
					_obj.changed=_changed=6;
				}
				
				de_ready(_name);
			}
		}
		
		private static function decrypt(_data:ByteArray,_name:String,_id:int,ev_obj:loadObject):void{
			/*if(de_buffer[_name]!=null){
				_self.dispatchEvent(new CryptEvent(CryptEvent.ERROR,ev_obj,_id,0,0,"DECODE ERROR: file in process"));
				return;
			}*/
			var _name_c:int=0;
			while(de_buffer[_name]!=null){
				_name=_name+_name_c;
				_name_c++;
			}
			
			var _obj:Object=new Object;
			_obj.ev_obj=ev_obj;
			_obj._data=_data;
			_obj._len=_data.length;
			_obj.limit=_obj._len/10+limit;
			_obj._input=new Vector.<uint>(_obj._len);
			_obj._mix=new Vector.<uint>(_obj._len);
			_obj._mix1=new ByteArray();
			_obj._rand=new Vector.<uint>(4);
			_obj.id=_id;
			_obj.jump=0;
			_obj.changed=0;
			_obj.ready=0;
			_obj._jump=0;
			_obj.full=_obj._len*4;
			_obj.i=0;
			_obj.j=0;
			_obj.k=0;
			_obj.m=0;
			_obj.n=0;
			
			de_crypted[_name]=new Object();
			de_crypted[_name].ready=0;
			de_crypted[_name].full=_obj._len*4;
			
			de_buffer[_name]=_obj;
			if(de_buffer.count==null){
				_self.addEventListener(Event.ENTER_FRAME, decrypt_process);
				de_buffer.count=0;
				_self.output("<b>ACTIVATE ENCRIPTOR</b>\n");
			}
			de_buffer.count++;
			
		}
		
		private static var de_buffer:Object=new Object();
		private static var de_crypted:Object=new Object();
		private static var _break:String="";
		private static function Break(_br_obj:String):Boolean{
			if(_br_obj==_break){
				_break="";
				return true;
			}
			return false;
		}
		public static function clearObject(_name:String):void{
			try{
				de_buffer[_name]=null;
				delete de_buffer[_name];
			}catch(er:Error){}
			/*try{
				de_crypted[_name]=null;
				delete de_crypted[_name];
			}catch(er:Error){}*/
		}
		public static function percents():Number{
			var A:Number=0;
			for(var _name:String in de_crypted){
				var _obj:Object;
				if(de_buffer[_name]!=null){
					_obj=de_buffer[_name];
				}else{
					_obj=de_crypted[_name];
				}
				var _perc:Number=_obj.ready/_obj.full;
				if(_perc>1){
					_perc=1;
				}
				A+=Number(_perc);
			}
			return A;
		}
	}
	
}