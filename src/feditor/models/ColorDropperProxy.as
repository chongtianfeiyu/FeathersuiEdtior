package feditor.models 
{
	import flash.display.BitmapData;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	/**
	 * ...
	 * @author gray
	 */
	public class ColorDropperProxy extends Proxy 
	{
		public static const NAME:String = "ColorDropperProxy";
		private var bmpdata:BitmapData;
		private var _color:uint;
		
		public function ColorDropperProxy() 
		{
			super(NAME);
		}
		
		public function clear():void
		{
			if (bmpdata) bmpdata.dispose();
		}
		
		public function setSource(source:BitmapData):void
		{
			if (bmpdata) bmpdata.dispose();
			bmpdata = source;
		}
		
		public function getSource():BitmapData
		{
			return bmpdata;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
		}
	}
}