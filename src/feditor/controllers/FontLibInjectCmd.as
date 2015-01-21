package feditor.controllers 
{
    import feditor.AppFacade;
    import feditor.NS;
    import feditor.utils.Builder;
    import feditor.utils.FontWorker;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.system.Security;
    import flash.system.SecurityDomain;
    import flash.text.engine.FontDescription;
    import flash.text.Font;
    import flash.utils.ByteArray;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class FontLibInjectCmd extends SimpleCommand 
    {
        public static const LIB:String = "feditor.FontLib";
        
        
        public function FontLibInjectCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            var bytes:ByteArray = AppFacade(facade).assets.getByteArray("FontLib");
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void { 
                loader.contentLoaderInfo.removeEventListener(e.type, arguments.callee);
                var lib:* = ApplicationDomain.currentDomain.getDefinition(LIB);
                var fontName:String = lib.NAME;
                var fontNormal:Class = lib.NORMAL;
                var fontBold:Class = lib.BOLD;
                
                Font.registerFont(fontNormal);
                Font.registerFont(fontBold);
                
                new FontWorker(fontName,fontNormal,fontBold);
                
            } );
            
            var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
            lc.allowCodeImport = true;
            loader.loadBytes(bytes, lc);
            
            facade.removeCommand(NS.CMD_FONTLIB_INJECT);
        }
        
    }

}