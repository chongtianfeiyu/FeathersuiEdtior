package feditor.views 
{
	import feditor.models.DevicesProxy;
    import feditor.models.EStageProxy;
    import feditor.NS;
    import feditor.views.pnl.CreateProjectPnl;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import starling.events.Event;
    
    /**
     * ...
     * @author gray
     */
    public class CreateProjectPnlMediator extends Mediator 
    {
        public static const NAME:String = "CreateProjectPnlMediator";
        public function CreateProjectPnlMediator(viewComponent:Object=null) 
        {
            super(NAME, viewComponent);
        }
        
        private function deviceSelectHandler(e:Event):void 
        {
			pnl.removeEventListener(Event.SELECT, deviceSelectHandler);
			pnl.hide();
            sendNotification(NS.CMD_ESTAGE_INIT,e.data);
        }
        
        override public function listNotificationInterests():Array 
        {
            return [
                NS.NOTE_CREATE_PORJECT
            ];
        }
        
        override public function handleNotification(notification:INotification):void 
        {
            switch (notification.getName()) 
            {
                case NS.NOTE_CREATE_PORJECT:
                    pnl.show();
					if (!pnl.hasData) pnl.setDeviceList(deviceProxy.getDevicesList());
                    pnl.addEventListener(Event.SELECT, deviceSelectHandler);
                break;
                default:
            }
        }
        
        public function get pnl():CreateProjectPnl
        {
            return viewComponent as CreateProjectPnl;
        }
        
        private function get estageProxy():EStageProxy
        {
            return facade.retrieveProxy(EStageProxy.NAME) as EStageProxy;
        }
		
		private function get deviceProxy():DevicesProxy
		{
			return facade.retrieveProxy(DevicesProxy.NAME) as DevicesProxy;
		}
    }

}