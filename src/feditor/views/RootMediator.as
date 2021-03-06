package feditor.views 
{
    import feditor.events.EventType;
    import feditor.models.ClipBordProxy;
    import feditor.models.ControlDescriptionProxy;
    import feditor.models.DefaultControlProxy;
    import feditor.NS;
    import feditor.Root;
    import feditor.utils.Assets;
    import feditor.utils.Builder;
	import feditor.utils.FieldConst;
    import feditor.utils.ObjectUtil;
    import feditor.utils.Reflect;
    import feditor.views.pnl.LibraryPanel;
    import feditor.views.pnl.EditorStage;
    import feditor.vo.FieldVO;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import starling.display.DisplayObject;
    import starling.events.Event;
    import flash.utils.getQualifiedClassName;
    
    /**
     * ...
     * @author gray
     */
    public class RootMediator extends Mediator 
    {
        public static const NAME:String = "RootMediator";
        
        public function RootMediator(viewComponent:Object=null) 
        {
            super(NAME, viewComponent);
        }
        
        override public function onRegister():void 
        {
            super.onRegister();
            
            pnl.libraryPanel.addEventListener(EventType.SELECT_CMP, cmpChangeHandler);
            pnl.libraryPanel.addEventListener(EventType.PREVIEW, previewHandler);
            pnl.refreshButton.addEventListener(Event.TRIGGERED,refreshButtonHandler);
            pnl.form.addEventListener(Event.CHANGE, propertyChangeHandler);
        }
		
		private function refreshButtonHandler(e:Event):void 
		{
			sendNotification(NS.CMD_CONTROL_LIBRARY_REFRESH);
		}
        
        private function previewHandler(e:Event):void 
        {
            var arr:Array = e.data as Array;
            arr[1] = pnl.stageContainer.x;
            
            if (defaultControlProxy.getNameList().indexOf(arr[0])!=-1)
            {
                arr[0] = defaultControlProxy.getControlXML(arr[0]);
                sendNotification(NS.NOTE_PREVIEW,arr);
            }
            else
            {
                sendNotification(NS.NOTE_PREVIEW,arr);
            }
        }
        
        private function cmpChangeHandler(e:Event):void 
        {
            var data:String = e.data as String;
            if (data)
            {
                var xml:* = defaultControlProxy.getControlXML(data);
                Builder.build(pnl.editorStage.childContainer, xml);
                sendNotification(NS.NOTE_PREVIEW_HIDE);
            }
        }
        
        private function propertyChangeHandler(e:Event):void 
        {
            var fvo:FieldVO = e.data as FieldVO;
            if (fvo.name == FieldConst.BG_ALPHA)
            {
                sendNotification(NS.NOTE_IMPORT_PICTURE_APLHA,parseFloat(fvo.value));
            }
            else
            {
                sendNotification(NS.CMD_FIELD_UPDATE,e.data);
            }
        }
        
        override public function listNotificationInterests():Array 
        {
            return [
                NS.NOTE_FORM_DATA_CREATED
            ];
        }
        
        override public function handleNotification(notification:INotification):void 
        {
            switch (notification.getName()) 
            {
                case NS.NOTE_FORM_DATA_CREATED:
                    pnl.form.setPropertyList(notification.getBody() as Array);
                    break;
                default:
            }
        }
        
        public function get pnl():Root
        {
            return viewComponent as Root;
        }
        
        public function get descriptionProxy():ControlDescriptionProxy
        {
            return facade.retrieveProxy(ControlDescriptionProxy.NAME) as ControlDescriptionProxy;
        }
        
        public function get defaultControlProxy():DefaultControlProxy
        {
            return facade.retrieveProxy(DefaultControlProxy.NAME) as DefaultControlProxy;
        }
        
        public function get clipBordProxy():ClipBordProxy
        {
            return facade.retrieveProxy(ClipBordProxy.NAME) as ClipBordProxy;
        }
    }
}