package
{
	import com.sdh.AneFunctionExtension;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.desktop.NativeApplication;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
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
			
			var label:TextField;
			var labelText:String = _aneFunction.deviceInfo("DEVICE");
			
			initTextField(label, labelText);
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
	}
}