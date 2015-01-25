package feditor.views 
{
    import feathers.data.ListCollection;
    import feditor.models.DefaultControlProxy;
	import feditor.NS;
    import feditor.views.pnl.LibraryPanel;
	import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    
    /**
     * ...
     * @author gray
     */
    public class LibraryMediator extends Mediator 
    {
        public static const NAME:String = "LibraryMediator";
        
        public function LibraryMediator(viewComponent:Object=null) 
        {
            super(NAME, viewComponent);
        }
        
        override public function onRegister():void 
        {
            super.onRegister();
            pnl.cmpList.dataProvider = new ListCollection(defaultControlProxy.getNameList());
        }
		
		override public function listNotificationInterests():Array 
		{
			return [NS.NOTE_CONTROL_LIBRARY_UPDATE];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch (notification.getName()) 
			{
				case NS.NOTE_CONTROL_LIBRARY_UPDATE:
					pnl.cmpList.dataProvider = new ListCollection(defaultControlProxy.getNameList());
				break;
				default:
			}
		}
        
        public function get pnl():LibraryPanel
        {
            return viewComponent as LibraryPanel;
        }
        
        public function get defaultControlProxy():DefaultControlProxy
        {
            return facade.retrieveProxy(DefaultControlProxy.NAME) as DefaultControlProxy;
        }
    }

}