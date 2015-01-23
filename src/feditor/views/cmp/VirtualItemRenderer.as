package feditor.views.cmp 
{
    import feathers.controls.renderers.BaseDefaultItemRenderer;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feditor.AppFacade;
    import feditor.models.DefaultControlProxy;
    import feditor.utils.Assets;
    import feditor.utils.Builder;
    import flash.utils.setInterval;
    import starling.display.DisplayObject;
    
    /**
     * only for eidtor show.
     * @author gray
     */
    public class VirtualItemRenderer extends DefaultListItemRenderer 
    {
        private var _itemRenderBg:DisplayObject;
        private var libName:String;
        public function VirtualItemRenderer(libName:String) 
        {
            super();
            
            this.libName = libName;
        }
        
        override protected function initialize():void 
        {
            super.initialize();
            
            this.libName = libName;
            
            this.styleProvider = null;
            
            var xml:* = defaultControlProxy.getControlXML(libName);
            if (xml)
            {
                Builder.build(this, xml);
                var child:DisplayObject = getChildAt(0);
                child.x = 0;
                child.y = 0;
            }
        }
        
        override protected function commitData():void 
        {
            super.commitData();
            this.label = "";
        }
        
        private function get defaultControlProxy():DefaultControlProxy
        {
            return AppFacade.getInstance().retrieveProxy(DefaultControlProxy.NAME) as DefaultControlProxy;
        }
        
        public function get itemRenderBg():DisplayObject 
        {
            return _itemRenderBg;
        }
        
        public function set itemRenderBg(value:DisplayObject):void 
        {
            _itemRenderBg = value;
            defaultSkin = value;
            if (_itemRenderBg)
            {
                _itemRenderBg.x = 0;
                _itemRenderBg.y = 0;
            }
        }
    }

}