package feditor.controllers 
{
    import feditor.models.DefaultControlProxy;
    import feditor.NS;
    import feditor.utils.ItemRendererBuilder;
    import feditor.views.cmp.VirtualItemRenderer;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class ItemRendererBuilderInitCmd extends SimpleCommand 
    {
        
        public function ItemRendererBuilderInitCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            var map:Object = { };
            var arr:Array = defaultControlProxy.getNameList();
            for each (var item:String in arr) 
            {
                if (item.indexOf("ItemRenderer") != -1 || 
                    item.indexOf("ItemRender") != -1 || 
                    item.indexOf("renderer") != -1 || 
                    item.indexOf("Renderer") != -1 ||
                    item.indexOf("Render") != -1 ||
                    item.indexOf("render") != -1
                )
                {
                    map[item] = item;
                }
            }
            
            ItemRendererBuilder.initialize( map, VirtualItemRenderer);
            
            facade.removeCommand(NS.CMD_RENER_BUILDER_INIT);
        }
        
        private function get defaultControlProxy():DefaultControlProxy
        {
            return facade.retrieveProxy(DefaultControlProxy.NAME) as DefaultControlProxy;
        }
    }

}