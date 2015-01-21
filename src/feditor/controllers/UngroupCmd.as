package feditor.controllers 
{
    import feathers.controls.LayoutGroup;
    import feditor.models.SelectElementsProxy;
    import feditor.utils.GroupUtil;
    import feditor.views.EdiatorStageMediator;
    import feditor.views.pnl.EditorStage;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObject;
    
    /**
     * ...
     * @author gray
     */
    public class UngroupCmd extends SimpleCommand 
    {
        
        public function UngroupCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            if (selectProxy.selectedItems.length!=1)
            {
                trace("UngroupCmd -> can not ungroup");
                return;
            }
            
            var box:LayoutGroup = selectProxy.selectedItems[0] as LayoutGroup;
            if (box == null) return;
            
            selectProxy.clear();
            
            var index:int = -1;
            if (box.parent)
            {
                index = box.parent.getChildIndex(box);
            }
            
            var childrens:Array = GroupUtil.upgroup(box)||[];
            for (var i:int = childrens.length -1; i >=0 ; i--) 
            {
                var item:DisplayObject = childrens[i];
                if (item)
                {
                    if (index < 0)
                    {
                        box.parent.addChild(item);
                    }
                    else
                    {
                        box.parent.addChildAt(item,index);
                    }
                }
            }
            
            if(box.parent) box.parent.removeChild(box);
        }
        
        private function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
    }

}