package feditor.views 
{
    import feditor.NS;
    import feditor.views.cmp.PreviewBox;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import starling.display.DisplayObject;
    import starling.events.Event;
    
    /**
     * ...
     * @author gray
     */
    public class PreviewBoxMediator extends Mediator 
    {
        public static const NAME:String = "PreviewBoxMediator";
        public function PreviewBoxMediator(viewComponent:Object=null) 
        {
            super(NAME, viewComponent||new PreviewBox());
        }
        
        override public function listNotificationInterests():Array 
        {
            return [
                NS.NOTE_PREVIEW
            ];
        }
        
        override public function handleNotification(notification:INotification):void 
        {
            switch (notification.getName()) 
            {
                case NS.NOTE_PREVIEW:
                    var arr:Array = notification.getBody() as Array;
                    if (arr && arr[0] as DisplayObject)
                    {
                        pnl.showBox.apply(null, arr);
                        validateAddAction();
                    }
                break;
                default:
            }
        }
        
        private function validateAddAction():void
        {
            pnl.addButton.addEventListener(Event.TRIGGERED,addButtonHandler);
        }
        
        private function addButtonHandler():void
        {
            var display:DisplayObject = pnl.getPreviewObject();
            pnl.addButton.removeEventListener(Event.TRIGGERED, addButtonHandler);
            pnl.hideBox();
            
            if (display)
            {
                sendNotification(NS.NOTE_PLACE_CONTROL_TO_STAGE,display);
            }
        }
        
        
        public function get pnl():PreviewBox
        {
            return viewComponent as PreviewBox;
        }
    }

}