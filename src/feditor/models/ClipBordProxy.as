package feditor.models 
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import starling.display.DisplayObject;
    
    /**
     * ...
     * @author gray
     */
    public class ClipBordProxy extends Proxy 
    {
        public static const NAME:String = "ClipBordProxy";
        private var _string:String;
        private var _controls:Array = [];
        private var _defines:Array = [];
        
        public function ClipBordProxy(data:Object=null) 
        {
            super(NAME, data);
        }
        
        private function storeControls(arr:Array):void
        {
            _controls.length = 0;
            if (arr) 
            {
                _controls.push.apply(this, arr);
            }
        }
        
        public function storeDefines(arr:Array):void
        {
            _defines.length = 0;
            if (arr)
            {
                _defines.push.apply(null, arr);
            }
        }
        
        public function clearAll():void
        {
            _defines.length = 0;
            _controls.length = 0;;
            _string = "";
        }
        
        public function storeString(string:String):void
        {
            _string = string;
        }
        
        public function get string():String 
        {
            return _string||"";
        }
        
        public function get controls():Array 
        {
            return _controls;
        }
        
        public function get defines():Array 
        {
            return _defines;
        }
    }
}