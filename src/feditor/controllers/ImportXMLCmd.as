package feditor.controllers 
{
    import feditor.models.EStageProxy;
    import feditor.models.ProjectProxy;
    import feditor.NS;
    import feditor.vo.ProjectVO;
    import flash.events.Event;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class ImportXMLCmd extends SimpleCommand 
    {
        public static const IMPORT_PROJECT:String = "importProject";
        public static const OPEN_PROJECT:String = "open_project";
        
        private var fileRef:FileReference;
        private var type:String;
        
        public function ImportXMLCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            fileRef = new FileReference();
            fileRef.browse([new FileFilter("XML(*.xml)", "*.xml")]);
            fileRef.addEventListener(Event.SELECT, fileSelectHandler);
            fileRef.addEventListener(Event.COMPLETE, fileCompleteHandler);
            type = notification.getBody() as String;
        }
        
        private function fileSelectHandler(e:Event):void 
        {
            fileRef.removeEventListener(Event.SELECT, fileSelectHandler);
            fileRef.load();
        }
        
        private function fileCompleteHandler(e:Event):void 
        {
            fileRef.removeEventListener(Event.COMPLETE, fileCompleteHandler);
            var byte:ByteArray = fileRef.data;
            var xml:XML = new XML(byte);
            
            if (type == OPEN_PROJECT)
            {
                var projectVO:ProjectVO = new ProjectVO();
                projectVO.width = parseInt(xml.@stageWidth);
                projectVO.height = parseInt(xml.@stageHeight);
                projectVO.color = parseInt(xml.@stageColor, 16);
                //projectVO.projectName = xml.@projectName;
				projectVO.projectName = fileRef.name.split(".")[0];
                
                (facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy).projectName = xml.@projectName;
                sendNotification(NS.CMD_ESTAGE_INIT,projectVO);
            }
            
            sendNotification(NS.NOTE_IMPORT_XML_COMPLETE, xml);
        }
    }
}