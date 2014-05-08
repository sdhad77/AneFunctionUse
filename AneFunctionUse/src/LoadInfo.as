package
{
	public class LoadInfo
	{
		private var _path:String;
		private var _posX:int;
		private var _posY:int;
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _listener:Function;
		private var _resize:Boolean;

		public function LoadInfo()
		{
		}
		
		public function setLoadInfo(path:String, posX:int, posY:int, scaleX:Number, scaleY:Number, listener:Function, resize:Boolean):void
		{
			_path = path;
			_posX = posX;
			_posY = posY;
			_scaleX = scaleX;
			_scaleY = scaleY;
			_listener = listener;
			_resize = resize;
		}
		
		public function get path():String                 {   return _path;      }
		public function set path(value:String):void       {   _path = value;     }
		public function get posX():int                    {   return _posX;      }
		public function set posX(value:int):void          {   _posX = value;     }
		public function get posY():int                    {   return _posY;      }
		public function set posY(value:int):void          {   _posY = value;     }
		public function get scaleX():Number               {   return _scaleX;    }
		public function set scaleX(value:Number):void     {   _scaleX = value;   }
		public function get scaleY():Number               {   return _scaleY;    }
		public function set scaleY(value:Number):void     {   _scaleY = value;   }
		public function get listener():Function           {   return _listener;  }
		public function set listener(value:Function):void {   _listener = value; }
		public function get resize():Boolean              {   return _resize;    }
		public function set resize(value:Boolean):void    {   _resize = value;   }
	}
}