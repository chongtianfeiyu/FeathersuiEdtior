package feditor.views 
{
	import feditor.models.SelectElementsProxy;
	import feditor.NS;
	import feditor.views.pnl.ToolPanel;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author gray
	 */
	public class ToolPanelMeditor extends Mediator 
	{
		public static const NAME:String = "ToolPanelMeditor";
		public function ToolPanelMeditor(viewComponent:Object=null) 
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void 
		{
			super.onRegister();
			pnl.addEventListener(Event.SELECT,selectHandler);
		}
		
		private function selectHandler(e:Event):void 
		{
			switch (e.data) 
			{
				case 0:
					sendNotification(NS.NOTE_SHOW_COLOR_DROPPER);
					break;
				case 1:
					sendNotification(NS.CMD_ALIGN, selectProxy.selectedItems, "left");
					break;
				case 2:
					sendNotification(NS.CMD_ALIGN,selectProxy.selectedItems,"right");
					break;
				case 3:
					sendNotification(NS.CMD_ALIGN,selectProxy.selectedItems,"top");
					break;
				case 4:
					sendNotification(NS.CMD_ALIGN,selectProxy.selectedItems,"bottom");
					break;
				case 5:
					sendNotification(NS.CMD_ALIGN,selectProxy.selectedItems, "horizontalCenter");
					break;
				case 6:
					sendNotification(NS.CMD_ALIGN, selectProxy.selectedItems, "verticalMiddle");
					break;
				case 7:
					sendNotification(NS.NOTE_STRUCTURE_SHOW);
					break;
				default:
			}
		}
		
		public function get pnl():ToolPanel
		{
			return viewComponent as ToolPanel;
		}
		
		private function get selectProxy():SelectElementsProxy
		{
			return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
		}
		
	}

}