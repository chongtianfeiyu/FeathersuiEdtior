package feditor.controllers 
{
    import feditor.models.EStageProxy;
    import feditor.NS;
    import feditor.vo.StageVO;
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
        
        private var fileRef:FileReference;
        
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
            
            var stageVO:StageVO = new StageVO();
            stageVO.width = parseInt(xml.@stageWidth);
            stageVO.height = parseInt(xml.@stageHeight);
            stageVO.color = parseInt(xml.@stageColor,16);
            
            sendNotification(NS.CMD_ESTAGE_INIT,stageVO);
            sendNotification(NS.NOTE_IMPORT_XML_COMPLETE, xml);
        }
    }
}