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
		private var _loader:Loader;
		private var _loadInfoVector:Vector.<LoadInfo>;
		private var _currentLoadImageIdx:int;
		private var _galleryTouchCnt:int;
		private var _pathData:Object;
		private var _buttonNum:int;
		
		public function AneFunctionUse()
		{
			super();
			
			//초기화
			init();
			
			//이미지 불러오기, 버튼 이미지 불러와서 등록
			imageLoad();
		}
		
		/** 
		 * 초기화 하는 함수
		 */
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT; 
			
			_aneFunction = new AneFunctionExtension();
			_loader = new Loader();
			_loadInfoVector =  new Vector.<LoadInfo>();
			_currentLoadImageIdx = 0;
			_galleryTouchCnt = 0;
			_pathData = _aneFunction.mediaStoreImageLoadFunction("Null");
			_buttonNum = 0;
			
			initAddEventListener();
			initButtonLoadInfo();
		}
		
		/** 
		 * 어플리케이션이 처음 실행 됐을 때 추가 되어야 하는 이벤트 리스너들을 추가하는 함수
		 */
		private function initAddEventListener():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPress);
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
		}
		
		private function initButtonLoadInfo():void
		{
			var loadInfo:LoadInfo = new LoadInfo();
			loadInfo.setLoadInfo("./resource/Button_Vibration.png", 20, 100, 1, 1, vibration, false);
			_loadInfoVector.push(loadInfo);
			
			loadInfo = new LoadInfo();
			loadInfo.setLoadInfo("./resource/Button_Toast.png", 300, 100, 1, 1, toast, false);
			_loadInfoVector.push(loadInfo);
			
			loadInfo = new LoadInfo();
			loadInfo.setLoadInfo("./resource/Button_Gallery.png", 580, 100, 1, 1, gallery, false);
			_loadInfoVector.push(loadInfo);
			
			loadInfo = new LoadInfo();
			loadInfo.setLoadInfo("./resource/Button_DeviceInfo.png", 860, 100, 1, 1, deviceInfo, false);
			_loadInfoVector.push(loadInfo);
			
			loadInfo = new LoadInfo();
			loadInfo.setLoadInfo("./resource/Button_DisplayClear.png", 20, 340, 1, 1, displayClear, false);
			_loadInfoVector.push(loadInfo);
			
			_buttonNum = 5;
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
		
		/**
		 * 눌린 키가 무엇인지 확인하고 해당하는 함수 작동시킴
		 * @param event 키보드 이벤트
		 */
		private function keyPress(event:KeyboardEvent):void 
		{ 
			if(event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				if(_aneFunction.backPress("Null") == true) NativeApplication.nativeApplication.exit();
			}
		} 
		
		private function vibration(event:TouchEvent):void
		{
			_aneFunction.vibration(500);
		}
		
		private function toast(event:TouchEvent):void
		{
			_aneFunction.toast("Toast");
		}
		
		private function gallery(event:TouchEvent):void
		{
			removeDisplayChild(_buttonNum);
			
			var loadInfo:LoadInfo;
			
			for(var j:int = 0; j < 3; j++)
			{
				for(var i:int = 0; i < 3; i++)
				{
					loadInfo = new LoadInfo();
					loadInfo.setLoadInfo((_pathData)["img" + (i + (j*3) + (_galleryTouchCnt*9)).toString()], 45 + (i*345), 620 + (j*320), 0, 0, imageTouch, true);
					_loadInfoVector.push(loadInfo);
				}
			}
			
			_galleryTouchCnt++;
			
			imageLoad();
		}
		
		private function imageTouch(event:TouchEvent):void
		{
			_aneFunction.toast("이미지 터치");
		}
		
		private function deviceInfo(event:TouchEvent):void
		{
			initTextField(_label, _aneFunction.deviceInfo("Null"));
		}
		
		private function initTextField(label:TextField, str:String):void
		{
			removeDisplayChild(_buttonNum);
			
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0x000000;
			format.size = 25;
			format.underline = true;
			
			label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.background = true;
			label.border = true;
			label.x = 80;
			label.y = 620;
			label.defaultTextFormat = format;
			label.text = str;
			label.name = "DeviceInfo";
			
			addChild(label);
		}
		
		private function displayClear(event:TouchEvent):void
		{
			removeDisplayChild(_buttonNum);
		}
		
		
		private function removeDisplayChild(buttonNum:int):void
		{
			while(numChildren > buttonNum) removeChildAt(buttonNum);
		}
	}
}