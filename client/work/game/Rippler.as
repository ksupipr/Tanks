package{
    
		import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.filters.ConvolutionFilter;
    import flash.filters.DisplacementMapFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    public class Rippler{
        private var _source : DisplayObject;
        
        private var _buffer1 : BitmapData;
        private var _buffer2 : BitmapData;
        
        private var _defData : BitmapData;
        
        private var _fullRect : Rectangle;
        private var _drawRect : Rectangle;
        private var _origin : Point = new Point();
        
        private var _filter : DisplacementMapFilter;
        private var _expandFilter : ConvolutionFilter;
        
        private var _colourTransform : ColorTransform;
        
        private var _matrix : Matrix;
        
        private var _scaleInv : Number;
        
				private var pos : int;
				
        public function Rippler(source : DisplayObject, X, Y,_ar:Array, _pos:int){
            var correctedScaleX : Number;
            var correctedScaleY : Number;
            
						pos=_pos;
						
            _source = source;
            _scaleInv = 1/_ar[0][1];
            
            _buffer1 = new BitmapData(source.width*_scaleInv, source.height*_scaleInv, false, 0x000000);
            _buffer2 = new BitmapData(_buffer1.width, _buffer1.height, false, 0x000000);
            _defData = new BitmapData(source.width, source.height, false, 0x7f7f7f);
            
            correctedScaleX = _defData.width/_buffer1.width;
            correctedScaleY = _defData.height/_buffer1.height;
            
            _fullRect = new Rectangle(0, 0, _buffer1.width, _buffer1.height);
            _drawRect = new Rectangle();
            
            _filter = new DisplacementMapFilter(_defData, _origin, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE, _ar[0][0], _ar[0][0], "wrap");
            
            _expandFilter = new ConvolutionFilter(_ar[3][0], _ar[3][1], _ar[3][2], _ar[3][3]);
						
            _colourTransform = new ColorTransform(_ar[2][0], _ar[2][1], _ar[2][2], _ar[2][3], _ar[2][4], _ar[2][5], _ar[2][6]);
            
            _matrix = new Matrix(correctedScaleX, 0, 0, correctedScaleY);
            drawRipple(X+12,Y+12,_ar[1][0],_ar[1][1]);
        }
        
        public function drawRipple(x : int, y : int, size : int, alpha : Number) : void{
        	var half : int = size >> 1;
          var intensity : int = (alpha*0xff & 0xff)*alpha;
          
          _drawRect.x = int((-half+x)*_scaleInv);	
          _drawRect.y = int((-half+y)*_scaleInv);
          _drawRect.width = _drawRect.height = int(size*_scaleInv);
          _buffer1.fillRect(_drawRect, intensity);
					
					try{
						_source.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
					}catch(er:Error){}
					_source.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
        }
        
       	public function getRippleImage():BitmapData{
        	return _defData;
        }
        
        public function destroy():void{
            _source.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
            _buffer1.dispose();
            _buffer2.dispose();
            _defData.dispose();
						_source=null;
        }
        
				public var _count:int=0;
        
        private function handleEnterFrame(event : Event) : void{
        	var temp : BitmapData = _buffer2.clone();
          _buffer2.applyFilter(_buffer1, _fullRect, _origin, _expandFilter);
          _buffer2.draw(temp, null, null, BlendMode.SUBTRACT, null, false);
          _defData.draw(_buffer2, _matrix, _colourTransform, null, null, true);
          _filter.mapBitmap = _defData;
					_source.filters = [_filter];
          temp.dispose();
          switchBuffers();
        }
        
        private function switchBuffers():void{
          if(_buffer1.compare(_buffer2)==0){
						destroy();
						return;
					}
					var temp:BitmapData=_buffer1;
          _buffer1 = _buffer2;
          _buffer2 = temp;
        }
    }
}