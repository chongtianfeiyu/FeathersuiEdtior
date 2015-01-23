package feditor.controllers 
{
    import feditor.NS;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class ImportProjectCmd extends SimpleCommand 
    {
        
        public function ImportProjectCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            sendNotification(NS.CMD_IMPORT_XML,ImportXMLCmd.IMPORT_PROJECT);
        }
    }

}