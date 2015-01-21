package feditor.controllers 
{
    import feditor.NS;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class CreateProjectCmd extends SimpleCommand 
    {
        
        public function CreateProjectCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            //TODO
            sendNotification(NS.NOTE_CREATE_PORJECT);
        }
    }

}