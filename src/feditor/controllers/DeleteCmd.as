package feditor.controllers 
{
    import feditor.models.SelectElementsProxy;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObject;
    
    /**
     * ...
     * @author gray
     */
    public class DeleteCmd extends SimpleCommand 
    {
        
        public function DeleteCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            if (selectProxy.selectedItems.length)
            {
                for each (var item:DisplayObject in selectProxy.selectedItems) 
                {
                    if (item)
                    {
                        if (item.parent) item.parent.removeChild(item);
                    }
                }
                
                selectProxy.clear();
            }
        }
        
        private function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
        
    }

}