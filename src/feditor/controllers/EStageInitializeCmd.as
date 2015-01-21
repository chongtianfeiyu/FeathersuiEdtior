package feditor.controllers 
{
    import feditor.models.EStageProxy;
    import feditor.NS;
    import feditor.vo.StageVO;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class EStageInitializeCmd extends SimpleCommand 
    {
        
        public function EStageInitializeCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            var stageVO:StageVO = notification.getBody() as StageVO;
            stageProxy.setSize(stageVO.width, stageVO.height);
            stageProxy.setBackgroundColor(stageVO.color);
            stageProxy.setProjectName(stageVO.projectName);
            
            sendNotification(NS.NOTE_ESTAGE_REFRESH, stageVO);
        }
        
        public function get stageProxy():EStageProxy
        {
            return facade.retrieveProxy(EStageProxy.NAME) as EStageProxy;
        }
        
    }

}