package feditor.models 
{
    import feditor.AppFacade;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    /**
     * ...
     * @author gray
     */
    public class EStageProxy extends Proxy 
    {
        public static const CONFIG:String   = "stage";
        
        public static const NAME:String = "EStageProxy";
        
        private var _width:Number = NaN;
        private var _height:Number = NaN;
        private var _color:Number = NaN;
        private var _projectName:String = "View";
        private var _designImageAlpha:Number = 0.5;
        
        public function EStageProxy(data:Object=null) 
        {
            super(NAME, data);
        }
        
        private function initializeByXML():void
        {
            var xml:XML = AppFacade.getInstance().assets.getXml(CONFIG);
            _width = parseInt(xml.stage.@width);
            _height = parseInt(xml.stage.@height);
            _color = parseInt(xml.stage.@color);
        }
        
        public function setSize(w:int,h:int):void
        {
            _width = w;
            _height = h;
        }
        
        public function setBackgroundColor(rgb:int):void
        {
            _color = rgb;
        }
        
        public function setProjectName(projName:String):void
        {
            _projectName = projName || _projectName;
        }
        
        public function get witdth():int
        {
            if (isNaN(_width)) initializeByXML();
            return _width;
        }
        
        public function get height():int
        {
            if (isNaN(_width)) initializeByXML();
            return _height;
        }
        
        public function get color():int
        {
            if (isNaN(_width)) initializeByXML();
            return _color;
        }
        
        public function get projectName():String 
        {
            return _projectName;
        }
        
        public function get designImageAlpha():Number 
        {
            return _designImageAlpha;
        }
        
        public function set designImageAlpha(value:Number):void 
        {
            _designImageAlpha = value;
        }
    }

}