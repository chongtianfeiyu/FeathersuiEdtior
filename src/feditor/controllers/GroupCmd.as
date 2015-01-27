package feditor.controllers 
{
    import feathers.controls.LayoutGroup;
    import feditor.models.SelectElementsProxy;
    import feditor.NS;
    import feditor.utils.Geom;
    import feditor.utils.GroupUtil;
    import flash.geom.Rectangle;
    import flash.utils.setTimeout;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    
    /**
     * ...
     * @author gray
     */
    public class GroupCmd extends SimpleCommand 
    {
        
        public function GroupCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            if (selectProxy.selectedItems.length < 1)
            {
                trace("GroupCmd -> select item less than 1.");
                return;
            }
            
            var first:DisplayObject = selectProxy.selectedItems[0];
            if (first == null && first.parent == null) return;
            
            var parent:DisplayObjectContainer = first.parent;
			
			var index:int = parent.getChildIndex(selectProxy.selectedItems[0]);
            
            
            var box:LayoutGroup = GroupUtil.group(selectProxy.selectedItems, LayoutGroup) as LayoutGroup;
            if (parent)
            {
                parent.addChildAt(box,index);
            }
            
            selectProxy.selectedItems.length = 0;
            selectProxy.addItem(box);
            
            //UI 不会立即重绘。延时20ms 再次发送更新命令
            setTimeout(sendNotification, 20, NS.NOTE_RECT_FOCUS_UPDATE);
        }
        
        private function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
        
    }

}