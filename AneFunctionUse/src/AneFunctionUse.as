package
{
	import com.sdh.AneFunctionExtension;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class AneFunctionUse extends Sprite
	{
		private var _aneFunction:AneFunctionExtension;
		private var _label:TextField;
		private var _loader:Loader = new Loader();
		private var _loadInfoVector:Vector.<LoadInfo> =  new Vector.<LoadInfo>();
		private var _currentLoadImageIdx:int = 0;
		private var _galleryTouchCnt:int = 0;
		private var _pathData:Object;
		
		public function AneFunctionUse()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPress);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT; 
			
			_aneFunction = new AneFunctionExtension();

			var labelText:String = _aneFunction.deviceInfo("DEVICE");

			initTextField(_label, labelText);
			
			_pathData = _aneFunction.mediaStoreImageLoadFunction("11");
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			
			initLoadInfo();
			imageLoad();
		}
		
		/**
		 * 눌린 키가 무엇인지 확인하고 해당하는 함수 작동시킴
		 * @param event 키보드 이벤트
		 */
		private function keyPress(event:KeyboardEvent):void 
		{ 
			if(event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				if(_aneFunction.backPress("그냥..") == true) NativeApplication.nativeApplication.exit();
			}
		} 
		
		private function initTextField(label:TextField, str:String):void
		{
			label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.background = true;
			label.border = true;
			
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0xFF0000;
			format.size = 40;
			format.underline = true;
			
			label.defaultTextFormat = format;
			label.text = str;
			addChild(label);
		}
		
		private function initLoadInfo():void
		{
			var loadInfo:LoadInfo = new LoadInfo();
			loadInfo.setLoadInfo("./resource/Button_Vibration.png", 100, 100, 1, 1, Vibration, false);
			_loadInfoVector.push(loadInfo);
			
			loadInfo = new LoadInfo();
			loadInfo.setLoadInfo("./resource/Button_Toast.png", 400, 100, 1, 1, Toast, false);
			_loadInfoVector.push(loadInfo);
			
			loadInfo = new LoadInfo();
			loadInfo.setLoadInfo("./resource/Button_Image.png", 700, 100, 1, 1, Gallery, false);
			_loadInfoVector.push(loadInfo);
		}
		
		private function imageLoad():void
		{
			if(_currentLoadImageIdx < _loadInfoVector.length) _loader.load(new URLRequest(_loadInfoVector[_currentLoadImageIdx].path));
		}
		
		private function loaderCompleteHandler(event:Event):void 
		{
			var img:Bitmap = new Bitmap;
			img = event.target.content as Bitmap;
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(img);
			
			sprite.x = _loadInfoVector[_currentLoadImageIdx].posX;
			sprite.y = _loadInfoVector[_currentLoadImageIdx].posY;
			
			if(_loadInfoVector[_currentLoadImageIdx].resize)
			{
				sprite.width = 300;
				sprite.height = 300;
			}
			
			sprite.addEventListener(TouchEvent.TOUCH_BEGIN, _loadInfoVector[_currentLoadImageIdx].listener);
			
			addChild(sprite);
			
			_currentLoadImageIdx++;
			
			imageLoad();
		}
		
		private function loaderErrorHandler(event:IOErrorEvent):void
		{
			_aneFunction.toast("Error loading image! Here's the error:\n" + event);
		}
		
		private function Vibration(event:TouchEvent):void
		{
			_aneFunction.vibration(1000);
		}
		
		private function Toast(event:TouchEvent):void
		{
			_aneFunction.toast("Toast");
		}
		
		private function Gallery(event:TouchEvent):void
		{
			var loadInfo:LoadInfo;
			
			for(var j:int = 0; j < 4; j++)
			{
				for(var i:int = 0; i < 3; i++)
				{
					loadInfo = new LoadInfo();
					loadInfo.setLoadInfo("file://" + (_pathData)["img" + (i + (j*3) + (_galleryTouchCnt*12)).toString()], 100 + (i*320), 350 + (j*320), 0, 0, ImageTouch, true);
					_loadInfoVector.push(loadInfo);
				}
			}
			
			_galleryTouchCnt++;
			
			imageLoad();
		}
		
		private function ImageTouch(event:TouchEvent):void
		{
			_aneFunction.toast("이미지 터치");
		}
	}
}