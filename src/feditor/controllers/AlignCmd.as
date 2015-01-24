package feditor.controllers 
{
	import feditor.NS;
	import feditor.utils.Geom;
	import flash.geom.Rectangle;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author gray
	 */
	public class AlignCmd extends SimpleCommand 
	{
		
		public function AlignCmd()
		{
			super();
		}
		
		override public function execute(notification:INotification):void 
		{
			var displayList:Array = notification.getBody() as Array;
			if (!displayList || displayList.length == 0) return;
			
			var rect:Rectangle = Geom.getBound(displayList);
			for each (var item:DisplayObject in displayList) 
			{
				switch (notification.getType) 
				{
					case "left":
						item.x = rect.x;
						break;
					case "top":
						item.y = rect.y;
						break;
					case "right":
						item.x = rect.x + rect.width - item.width;
						break;
					case "bottom":
						item.y = rect.y + rect.height - item.height;
						break;
					default:
				}
			}
		}
		
	}

}