package feditor.views 
{
    import feditor.events.EventType;
    import feditor.NS;
    import feditor.views.cmp.RectCheck;
    import flash.geom.Rectangle;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import starling.events.Event;
    
    /**
     * ...
     * @author gray
     */
    public class RectCheckMediator extends Mediator 
    {
        public static const NAME:String = "RectCheckMediator";
        public function RectCheckMediator(viewComponent:Object=null) 
        {
            super(NAME, viewComponent);
        }
        
        override public function onRegister():void 
        {
            super.onRegister();
            pnl.addEventListener(EventType.DRAG_RECT,dragRectHandler);
        }
        
        private function dragRectHandler(e:Event):void 
        {
            var rect:Rectangle = Rectangle(e.data);
            sendNotification(NS.CMD_CALC_RECT_CHECK, rect);
        }
        
        override public function listNotificationInterests():Array 
        {
            return [
                NS.NOTE_RECT_CHECK,
            ];
        }
        
        override public function handleNotification(notification:INotification):void 
        {
            switch (notification.getName()) 
            {
                case NS.NOTE_RECT_CHECK:
                    pnl.startJob();
                break;
                default:
            }
        }
        
        public function get pnl():RectCheck
        {
            return viewComponent as RectCheck;
        }
    }

}