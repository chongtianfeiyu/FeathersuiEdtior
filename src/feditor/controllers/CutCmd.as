package feditor.controllers 
{
    import feditor.models.ClipBordProxy;
    import feditor.models.SelectElementsProxy;
    import feditor.utils.describeView;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObject;
    
    /**
     * ...
     * @author gray
     */
    public class CutCmd extends SimpleCommand 
    {
        
        public function CutCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            var arr:Array = [];
            for each (var item:DisplayObject in selectProxy.selectedItems) 
            {
                if (item)
                {
                    try 
                    {
                        var xml:XML = describeView(item);
                        arr.push(xml);
                    }
                    catch (err:Error)
                    {
                        trace("CUT Error");
                    }
                    
                    if(item.parent) item.parent.removeChild(item);
                }
            }
            
            if (arr && arr.length)
            {
                clipBordProxy.storeDefines(arr);
            }
            
            selectProxy.clear();
        }
        
        private function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
        
        private function get clipBordProxy():ClipBordProxy
        {
            return facade.retrieveProxy(ClipBordProxy.NAME) as ClipBordProxy;
        }
    }
}