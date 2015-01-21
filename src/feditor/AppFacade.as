package feditor 
{
    import feditor.controllers.StartupCmd;
    import org.puremvc.as3.multicore.patterns.facade.Facade;
    import starling.utils.AssetManager;
    
    /**
     * APP Facade
     * @author gray
     */
    public class AppFacade extends Facade 
    {
        public static const NAME:String = "AppFacade";
        public static const STARTUP:String = "startup";
        
        private static var _instance:AppFacade = null;
        private var _assets:AssetManager;
        
        public static function getInstance():AppFacade
        {
            _instance ||= new AppFacade();
            return _instance;
        }
        
        public function get assets():AssetManager 
        {
            return _assets;
        }
        
        public function AppFacade() 
        {
            super(NAME);
            _assets = new AssetManager();
        }
        
        public function startup(app:*):void
        {
            sendNotification(STARTUP, app);
            removeCommand(STARTUP);
        }
        
        override protected function initializeController():void 
        {
            super.initializeController();
            registerCommand(STARTUP, StartupCmd);
        }
    }

}