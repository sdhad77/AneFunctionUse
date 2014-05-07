package
{
	import com.sdh.AneFunctionExtension;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class AneFunctionUse extends Sprite
	{
		private var t:AneFunctionExtension;
		
		public function AneFunctionUse()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			t = new AneFunctionExtension();
			t.toast("토스트 등장");
			t.vibration(1000);
			t.deviceInfo("그냥..");
		}
		
		/**
		 * 화면에서 어플리케이션이 사라질 경우 자동으로 종료.
		 * @param e : 이벤트
		 */
		private function deactivate(e:Event):void   
		{  
			NativeApplication.nativeApplication.exit();  
		} 
	}
}