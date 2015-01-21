package feditor.controllers 
{
    import flash.events.Event;
    import flash.net.navigateToURL;
    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class OpenConfigDirectoryCmd extends SimpleCommand 
    {
        
        public function OpenConfigDirectoryCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            var file:File = File.applicationDirectory;
            file.browse();
        }
    }

}