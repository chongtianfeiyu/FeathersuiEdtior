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
			
			sendNotification(NS.CMD_CREATE_SNAPSHOT);
			
			var rect:Rectangle = Geom.getBound(displayList);
			var centerX:int = rect.x + rect.width * 0.5;
			var centerY:int = rect.y + rect.height * 0.5;
			var type:String = notification.getType();
			
			for each (var item:DisplayObject in displayList) 
			{
				switch (type) 
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
					case "horizontalCenter":
						item.x = centerX - item.width*0.5;
						break;
					case "verticalMiddle":
						item.y = centerY - item.height*0.5;
						break;
					default:
				}
			}
			
			sendNotification(NS.NOTE_RECT_FOCUS_UPDATE);
		}
		
	}

}