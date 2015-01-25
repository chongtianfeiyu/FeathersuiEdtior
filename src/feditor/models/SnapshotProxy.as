package feditor.models 
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	/**
	 * ...
	 * @author gray
	 */
	public class SnapshotProxy extends Proxy 
	{
		public static const NAME:String = "SnapshotProxy";
		private var _snapshotArr:Array;
		private var max:uint;
		private var postion:int;
		private var _len:int = 0;
		private var _lastSnaphot:Object;
		
		public function SnapshotProxy(maxLength:uint=20) 
		{
			super(NAME, data);
			_snapshotArr = [];
			max = maxLength;
		}
		
		public function clearSnapshot():void
		{
			_snapshotArr.length = 0;
		}
		
		public function setLastSnapshot(data:Object):void
		{
			_lastSnaphot = data;
		}
		
		public function storeSnapshot(data:Object):void
		{
			_len = _snapshotArr.push(data);
			if (_len >= max)
			{
				_snapshotArr.shift();
				_len -= 1;
			}
			
			postion = len -1;
		}
		
		public function getUndoSnaphot():Object
		{
			var result:Object;
			if (postion >= 0)
			{
				if (postion >= _len) postion = _len -1;
				result = _snapshotArr[postion--];
			}
			return result;
		}
		
		public function getRedoSnaphot():Object
		{
			var result:Object;
			if (postion<_len)
			{
				if (postion < 0) postion = 0;
				result = _snapshotArr[postion++];
			}
			else if (lastSnaphot)
			{
				result = _lastSnaphot;
				_lastSnaphot = null;
			}
			return result;
		}
		
		public function get lastSnaphot():Object 
		{
			return _lastSnaphot;
		}
		
		public function get len():int 
		{
			return _len;
		}
	}

}