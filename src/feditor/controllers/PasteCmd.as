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
    import starling.display.DisplayObjectContainer;
    
    /**
     * ...
     * @author gray
     */
    public class PasteCmd extends SimpleCommand 
    {
        
        public function PasteCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            for each (var xml:XML in clipBordProxy.defines) 
            {
                if (xml) 
                {
                    try 
                    {
                        Builder.build(container.childContainer, xml);
                    }
                    catch (err:Error)
                    {
                        trace("PasteCmd - Paste Error");
                        clipBordProxy.clearAll();
                    }
                }
            }
            
            //clipBordProxy.clearAll();
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
        
        private function get container():EditorStage
        {
            return (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
        }
    }

}