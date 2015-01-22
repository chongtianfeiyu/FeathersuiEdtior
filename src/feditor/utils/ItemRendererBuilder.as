package feditor.utils 
{
    /**
     * ...
     * @author gray
     */
    public class ItemRendererBuilder 
    {
        private static var defineMap:Object;
        private static var virtualItemRendererClass:Class;
        
        public static function initialize(itemRenderDefineMap:Object,virtualItemRendererClass:Class):void
        {
            defineMap = itemRenderDefineMap;
            ItemRendererBuilder.virtualItemRendererClass = virtualItemRendererClass;
        }
        
        public static function getItemRendererFactory(itemRenderDefineName:String):Function
        {
            if (!defineMap) trace("ItemRendererBuilder has not be initialized");
            
            var define:* = defineMap[itemRenderDefineName];
            if (define is String)
            {
                return function():*{ return new virtualItemRendererClass(define);};
            }
            else if (define is Class)
            {
                return function():*{ return new define(); };
            }
            
            return null;
        }
        
        public function ItemRendererBuilder() 
        {
            
        }
        
    }

}