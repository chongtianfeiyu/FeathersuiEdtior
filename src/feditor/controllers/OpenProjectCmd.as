package feditor.controllers 
{
    import feditor.NS;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class OpenProjectCmd extends SimpleCommand 
    {
        
        public function OpenProjectCmd() 
        {
            super();
        }
        
        
        override public function execute(notification:INotification):void 
        {
            //TODO Other
            
            sendNotification(NS.NOTE_CLEAR_EDITOR_STAGE);
            sendNotification(NS.CMD_IMPORT_XML,ImportXMLCmd.OPEN_PROJECT);
        }
    }

}