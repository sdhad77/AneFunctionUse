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
		private var _pathNum:int;
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
			loadInfo.setLoadInfo("./resource/Button_Vibration.png", 20, 100, 1, 1, FaceBookLogin, false);
			_loadInfoVector.push(loadInfo);
			_buttonNum++;
			
			loadInfo = new LoadInfo();
			loadInfo.setLoadInfo("./resource/Button_Toast.png", 300, 100, 1, 1, FaceBookLogout, false);
			_loadInfoVector.push(loadInfo);
			_buttonNum++;
            
            loadInfo = new LoadInfo();
            loadInfo.setLoadInfo("./resource/Button_DisplayClear.png", 580, 100, 1, 1, FaceBookStatusUpdate, false);
            _loadInfoVector.push(loadInfo);
            _buttonNum++;
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
        
        private function FaceBookLogin(event:TouchEvent):void
        {
            _aneFunction.login("530743543715374");
        }
        
        private function FaceBookLogout(event:TouchEvent):void
        {
            _aneFunction.logout(null);
        }
        
        private function FaceBookStatusUpdate(event:TouchEvent):void
        {
            _aneFunction.statusupdate("Ane 테스트 두번째//");
        }
	}
}