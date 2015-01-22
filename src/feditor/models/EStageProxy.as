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
        public static const NAME:String = "EStageProxy";
        
        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _color:Number = 0;
        private var _designImageAlpha:Number = 0.5;
        
        public function EStageProxy(data:Object=null) 
        {
            super(NAME, data);
        }
        
        private function initializeByXML():void
        {
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