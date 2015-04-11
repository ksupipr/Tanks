package crypto{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import utils.loadObject;

	public class CryptEvent extends Event{
		public static const PROGRESS:String = "progress";
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		private var _bytesParsed:int=0;
		private var _bytesTotal:int=0;
		private var _inProcess:int=0;
		private var _code:int=0;
		private var _id:int=0;
		private var _text:String="";
		private var _data:ByteArray=null;
		private var _dataObject:loadObject=null;
		
		public function CryptEvent(type:String, ev_obj:loadObject, ID:int = 0, BytesParsed:Number = 0, BytesTotal:Number = 0, Text:String = "", Data:ByteArray = null, Code:int=0, InProcess:int=0):void{
			super(type);
			_bytesTotal=BytesTotal;
			_bytesParsed=BytesParsed;
			_dataObject=ev_obj;
			_id=ID;
			_text=Text;
			_data=Data;
			_code=Code;
			_inProcess=InProcess;
		}
		
		public override function toString():String {
			if(type==PROGRESS){
				return formatToString("CryptEvent","type","bytesParsed","bytesTotal","dataName","id");
			}else if(type==COMPLETE){
				return formatToString("CryptEvent","type","dataObject","id");
			}
			return formatToString("CryptEvent","type","dataObject","id","text");
		}
		
		public function get bytesParsed():int{
			return _bytesParsed;
		}
		
		public function get bytesTotal():int{
			return _bytesTotal;
		}
		
		public function get dataObject():loadObject{
			return _dataObject;
		}
		
		public function get id():int{
			return _id;
		}
		
		public function get text():String{
			return _text;
		}
		
		public function get data():ByteArray{
			return _data;
		}
		
		public function get code():int{
			return _code;
		}
		
		public function get inProcess():int{
			return _inProcess;
		}
	}
}