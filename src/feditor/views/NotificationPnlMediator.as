package feditor.views 
{
	import feditor.NS;
	import feditor.views.pnl.NotificationPanel;
    import flash.utils.getTimer;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author gray
	 */
	public class NotificationPnlMediator extends Mediator 
	{
		public static const NAME:String = "NotificationPnlMediator";
		
		public function NotificationPnlMediator(viewComponent:Object=null) 
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array 
		{
			return [
				NS.NOTE_ERROR_NOTIFICATION
			];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch (notification.getName()) 
			{
				case NS.NOTE_ERROR_NOTIFICATION:
					pnl.showNotification(notification.getBody()+"-"+getTimer());
				break;
				default:
			}
		}
		
		public function get pnl():NotificationPanel
		{
			return viewComponent as NotificationPanel;
		}
		
	}

}