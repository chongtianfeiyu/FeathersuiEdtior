package feditor.controllers 
{
    import feditor.models.SelectElementsProxy;
    import feditor.NS;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObject;
    
    /**
     * ...
     * @author gray
     */
    public class MovieCmd extends SimpleCommand 
    {
        
        public function MovieCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            switch (notification.getName()) 
            {
                case NS.CMD_MOVE_LEFT:
                    move("x",-1);
                    break;
                case NS.CMD_MOVE_RIGHT:
                    move("x", 1);
                    break;
                case NS.CMD_MOVE_UP:
                    move("y", -1);
                    break;
                case NS.CMD_MOVE_DOWN:
                    move("y",1);
                    break;
                default:
            }
        }
        
        private function move(attr:String,d:int):void
        {
            for each (var item:DisplayObject in selectProxy.selectedItems) 
            {
                item[attr] += d;
            }
            
            if (selectProxy.selectedItems.length)
            {
                sendNotification(NS.NOTE_SELECT_ITEM_DATA_UPDATE,selectProxy.selectedItems);
            }
        }
        
        public function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
    }
}