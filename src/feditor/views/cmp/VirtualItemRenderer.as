package feditor.views.cmp 
{
    import feathers.controls.renderers.BaseDefaultItemRenderer;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.display.Scale3Image;
    import feathers.display.Scale9Image;
    import feathers.skins.SmartDisplayObjectStateValueSelector;
    import feathers.skins.StyleNameFunctionStyleProvider;
    import feditor.AppFacade;
    import feditor.models.DefaultControlProxy;
	import feditor.NS;
    import feditor.utils.Assets;
    import feditor.utils.Builder;
    import flash.utils.setInterval;
    import starling.display.DisplayObject;
    import starling.display.Quad;
    
    /**
     * only for eidtor show.
     * @author gray
     */
    public class VirtualItemRenderer extends DefaultListItemRenderer 
    {
        private var libName:String;
        public function VirtualItemRenderer(libName:String) 
        {
            super();
            hasLabelTextRenderer = false;
            this.libName = libName;
        }
        
        override protected function initialize():void 
        {
            super.initialize();
            
            this.libName = libName;
            
            styleProvider = null;
            
			try 
			{
				var xml:* = defaultControlProxy.getControlXML(libName);
				if (xml)
				{
					xml = new XML(xml);
					xml.setName(Builder.XMLROOT);
					this.width = xml.@width;
					this.height = xml.@height;
					Builder.build(this, xml);
				}
			}
			catch (err:Error)
			{
				AppFacade.getInstance().sendNotification(NS.NOTE_ERROR_NOTIFICATION,"Your ItemRenderer xml is invalid");
			}
        }
        
        private function get defaultControlProxy():DefaultControlProxy
        {
            return AppFacade.getInstance().retrieveProxy(DefaultControlProxy.NAME) as DefaultControlProxy;
        }
    }

}