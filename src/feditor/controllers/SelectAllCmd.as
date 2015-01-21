package feditor.controllers 
{
    import feditor.models.SelectElementsProxy;
    import feditor.views.EdiatorStageMediator;
    import feditor.views.pnl.EditorStage;
    import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObject;
	
    /**
     * ...
     * @author gray
     */
    public class SelectAllCmd extends SimpleCommand 
    {
        
        public function SelectAllCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            selectProxy.clear();
            var arr:Array = [];
            for each (var item:DisplayObject in estage.getChildrens()) 
            {
                if (item)
                {
                    arr.push(item);
                }
            }
            
            if (arr.length)
            {
                selectProxy.addItems(arr);
            }
        }
        
        private function get estage():EditorStage
        {
            return (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
        }
        
        private function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
    }

}