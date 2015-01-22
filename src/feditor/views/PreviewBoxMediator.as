package feditor.views 
{
	import feditor.events.EventType;
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
		
		override public function onRegister():void 
		{
			super.onRegister();
			pnl.addEventListener(EventType.ASSET_PLACE,assetPlaceHandler);
		}
		
		private function assetPlaceHandler(e:Event):void 
		{
			sendNotification(NS.NOTE_PLACE_CONTROL_TO_STAGE,e.data);
		}
        
        override public function handleNotification(notification:INotification):void 
        {
            switch (notification.getName()) 
            {
                case NS.NOTE_PREVIEW:
                    var arr:Array = notification.getBody() as Array;
					if (arr) 
					{
						if (arr[0] is XML || arr[0] is XMLList)
						{
							pnl.previewControl.apply(null,arr)
						}
						else
						{
							pnl.previewImage.apply(null, arr);
						}
					}
                break;
                default:
            }
        }
		
        public function get pnl():PreviewBox
        {
            return viewComponent as PreviewBox;
        }
    }

}