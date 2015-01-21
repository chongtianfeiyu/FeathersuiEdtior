package feditor.views 
{
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
        
        private function closeHandler(e:Event):void 
        {
            pnl.removeEventListener(Event.CLOSE, closeHandler);
            sendNotification(NS.CMD_ESTAGE_INIT,pnl.stageVO);
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
                    pnl.sedDefault(estageProxy.witdth,estageProxy.height,estageProxy.color,estageProxy.projectName);
                    pnl.addEventListener(Event.CLOSE, closeHandler);
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
    }

}