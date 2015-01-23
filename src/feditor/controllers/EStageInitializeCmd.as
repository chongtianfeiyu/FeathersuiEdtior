package feditor.controllers 
{
    import feathers.controls.PickerList;
    import feditor.models.EStageProxy;
    import feditor.models.ProjectProxy;
    import feditor.NS;
    import feditor.vo.ProjectVO;
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
            var projectVO:ProjectVO = notification.getBody() as ProjectVO;
            
            stageProxy.setSize(projectVO.width, projectVO.height);
            stageProxy.setBackgroundColor(projectVO.color);
            projectProxy.projectName = projectVO.projectName;
            
            sendNotification(NS.NOTE_ESTAGE_REFRESH, projectVO);
        }
        
        public function get stageProxy():EStageProxy
        {
            return facade.retrieveProxy(EStageProxy.NAME) as EStageProxy;
        }
        
        public function get projectProxy():ProjectProxy
        {
            return facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
        }
        
    }

}