package
{
	import com.sdh.AneFunctionExtension;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.desktop.NativeApplication;
	
	public class AneFunctionUse extends Sprite
	{
		private var _aneFunction:AneFunctionExtension;
		
		public function AneFunctionUse()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPress);
			
			_aneFunction = new AneFunctionExtension();
			_aneFunction.toast("토스트 등장");
			_aneFunction.vibration(1000);
			_aneFunction.deviceInfo("그냥..");
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
	}
}