package feditor.views 
{
    import feathers.data.ListCollection;
    import feditor.models.DefaultControlProxy;
    import feditor.views.pnl.LibraryPanel;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    
    /**
     * ...
     * @author gray
     */
    public class LibraryMediator extends Mediator 
    {
        public static const NAME:String = "LibraryMediator";
        
        public function LibraryMediator(viewComponent:Object=null) 
        {
            super(NAME, viewComponent);
        }
        
        override public function onRegister():void 
        {
            super.onRegister();
            pnl.cmpList.dataProvider = new ListCollection(defaultControlProxy.getNameList());
        }
        
        public function get pnl():LibraryPanel
        {
            return viewComponent as LibraryPanel;
        }
        
        public function get defaultControlProxy():DefaultControlProxy
        {
            return facade.retrieveProxy(DefaultControlProxy.NAME) as DefaultControlProxy;
        }
    }

}