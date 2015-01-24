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
		
		public function SnapshotProxy(maxLength:uint=20) 
		{
			super(NAME, data);
			_snapshotArr = [];
			max = maxLength;
		}
		
		public function storeSnapshot(data:Object):void
		{
			_snapshotArr.push(data);
			if (_snapshotArr.length > max)
			{
				_snapshotArr.shift();
			}
		}
		
		public function getPrevSnaphot():Object
		{
			return _snapshotArr.pop();
		}
	}

}