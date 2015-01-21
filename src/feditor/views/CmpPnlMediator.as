package feditor.views 
{
    import feathers.data.ListCollection;
    import feditor.models.DefaultControlProxy;
    import feditor.views.pnl.CmpPanel;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    
    /**
     * ...
     * @author gray
     */
    public class CmpPnlMediator extends Mediator 
    {
        public static const NAME:String = "CmpPnlMediator";
        
        public function CmpPnlMediator(viewComponent:Object=null) 
        {
            super(NAME, viewComponent);
        }
        
        override public function onRegister():void 
        {
            super.onRegister();
            pnl.cmpList.dataProvider = new ListCollection(defaultControlProxy.getNameList());
        }
        
        public function get pnl():CmpPanel
        {
            return viewComponent as CmpPanel;
        }
        
        public function get defaultControlProxy():DefaultControlProxy
        {
            return facade.retrieveProxy(DefaultControlProxy.NAME) as DefaultControlProxy;
        }
    }

}