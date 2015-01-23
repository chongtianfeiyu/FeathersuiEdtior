package feditor.controllers 
{
    import feditor.models.EStageProxy;
    import feditor.models.ProjectProxy;
    import feditor.utils.Builder;
    import feditor.utils.describeView;
    import feditor.utils.Reflect;
    import feditor.views.EdiatorStageMediator;
    import feditor.views.pnl.EditorStage;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObjectContainer;
    
    /**
     * ...
     * @author gray
     */
    public class ExprotXMLCmd extends SimpleCommand 
    {
        
        public function ExprotXMLCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {    
            var xml:XML = describeView(editorRoot);
            delete xml.@* ;
            
            
            if (!projectProxy.projectName)
            {
                projectProxy.projectName = String(new Date().time);
            }
            
            xml.setName(Builder.XMLROOT);
            xml.@stageWidth = estageProxy.witdth;
            xml.@stageHeight = estageProxy.height;
            xml.@stageColor = "0x" + estageProxy.color.toString(16);
            xml.@projectName = projectProxy.projectName;
            
            var fileRef:FileReference = new FileReference();
            fileRef.save(xml,(projectProxy.projectName)+".xml");
        }
        
        private function get editorRoot():DisplayObjectContainer
        {
            var editor:EditorStage = (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
            return editor.childContainer; 
        }
        
        private function get projectProxy():ProjectProxy
        {
            return facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
        }
        
        private function get estageProxy():EStageProxy
        {
            return facade.retrieveProxy(EStageProxy.NAME) as EStageProxy;
        }
    }

}