package feditor.models 
{
    import feditor.AppFacade;
    import feditor.utils.ObjectUtil;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    /**
     * ...
     * @author gray
     */
    public class DefaultControlProxy extends Proxy 
    {
        public static const LIB_NAME:String = "libName";
        public static const CONFIG:String = "default";
        public static const NAME:String = "DefaultControlProxy";
        
        private var _xml:XML;
        private var nameList:Array; 
        private var propertiesMap:Object = { };
        private var classMap:Object = { };
        
        public function DefaultControlProxy(data:Object=null) 
        {
            super(NAME, data);
        }
        
        public function getNameList():Array
        {
            if (!nameList)
            {
                nameList = [];
                for each (var item:XML in xml.children()) 
                {
                    var libName:String = String(item.@[LIB_NAME]);
                    if (libName)
                    {
                        nameList.push(libName);
                    }
                }
            }
            
            return nameList;
        }
        
        public function getControlXML(libName:String):*
        {
            var result:* = xml.children().(@[LIB_NAME] == libName);
            return result;
        }
        
        private function getDefaultProperties(libName:String):Object
        {
            var result:Object = propertiesMap[libName];
            if (!result)
            {
                result = { };
                var node:* = xml.children().(@[LIB_NAME] == libName);
                for each (var item:* in node.children()) 
                {
                    result[String(item.name())] = String(item);
                }
                propertiesMap[libName] = result;
            }
            
            return ObjectUtil.copy(result);
        }
        
        private function getClassName(libName:String):String
        {
            var result:String = classMap[libName];
            if (!result)
            {
                var node:* = xml.children().(@[LIB_NAME] == libName);
                result = String(node.name());
                classMap[libName] = result;
            }
            
            return result;
        }
        
        private function get xml():XML
        {
            if (!_xml)
            {
                _xml = AppFacade.getInstance().assets.getXml(CONFIG);
            }
            
            return _xml;
        }
    }

}