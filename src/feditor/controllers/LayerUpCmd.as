package feditor.controllers 
{
    import feditor.models.SelectElementsProxy;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    
    /**
     * ...
     * @author gray
     */
    public class LayerUpCmd extends SimpleCommand 
    {
        
        public function LayerUpCmd() 
        {
            super();
            
        }
        
        override public function execute(notification:INotification):void 
        {
            var control:DisplayObject = selectProxy.getSelectedControl();
            if (control && control.parent)
            {
                var parent:DisplayObjectContainer = control.parent;
                
                var index:int = parent.getChildIndex(control);
                if (parent.numChildren > index + 1)
                {
                    parent.swapChildrenAt(index,index+1);
                }
            }
        }
        
        private function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
    }

}