package feditor.controllers 
{
    import feditor.models.ClipBordProxy;
    import feditor.models.SelectElementsProxy;
    import feditor.utils.Builder;
    import feditor.utils.describeView;
    import feditor.views.EdiatorStageMediator;
    import feditor.views.pnl.EditorStage;
    import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObject;
	
    /**
     * ...
     * @author gray
     */
    public class CopyCmd extends SimpleCommand 
    {
        
        public function CopyCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            var defines:Array = [];
            for each (var item:DisplayObject in selectProxy.selectedItems) 
            {
                var xml:XML = describeView(item);
                defines.push(xml);
            }
            
            if (defines.length)
            {
                clipBordProxy.storeDefines(defines);
            }
        }
        
        private function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
        
        private function get clipBordProxy():ClipBordProxy
        {
            return facade.retrieveProxy(ClipBordProxy.NAME) as ClipBordProxy;
        }
        
        private function get container():EditorStage
        {
            return (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
        }
    }
}