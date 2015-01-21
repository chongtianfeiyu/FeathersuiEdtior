package feditor.views 
{
    import feditor.NS;
    import feditor.views.pnl.WellcomePnl;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import starling.events.Event;
    
    /**
     * ...
     * @author gray
     */
    public class WellcomPnlMediator extends Mediator 
    {
        public static const NAME:String = "WellcomPnlMediator";
        public function WellcomPnlMediator(viewComponent:Object=null) 
        {
            super(NAME, viewComponent);
        }
        
        override public function listNotificationInterests():Array 
        {
            return [
                NS.NOTE_WELLECOM
            ];
        }
        
        override public function handleNotification(notification:INotification):void 
        {
            switch (notification.getName()) 
            {
                case NS.NOTE_WELLECOM:
                    pnl.show();
                    pnl.menu.addEventListener(Event.TRIGGERED,menuHandler);
                break;
                default:
            }
        }
        
        private function menuHandler(e:Event):void
        {
            pnl.menu.addEventListener(Event.TRIGGERED, menuHandler);
            
            switch (e.data) 
            {
                case "New Project":
                    sendNotification(NS.CMD_CREATE_PROJECT);
                    break;
                case "Open Project":
                    sendNotification(NS.CMD_OPEN_PROJECT);
                    break;
                default:
            }
            
            pnl.hide();
            sendNotification(NS.CMD_CREATE_NATIVE_MENU);
        }
        
        public function get pnl():WellcomePnl
        {
            return viewComponent as WellcomePnl;
        }
        
    }

}