package feditor.models 
{
    import feditor.AppFacade;
    import feditor.utils.ObjectUtil;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    /**
     * 解析默认支持控件配置文件
     * @author gray
     */
    public class ControlDescriptionProxy extends Proxy 
    {
        public static const NAME:String = "ControlDescriptionProxy";
        public static const CONFIG:String = "control_description";
        
        private var _xml:XML;
        private var surportedList:Array;
        private var propertiesMap:Object = { };
        private var orlderMap:Object = { };
        private var libList:Array;
        
        public function ControlDescriptionProxy() 
        {
            super(NAME);
        }
        
        public function isSurported(name:String):Boolean
        {
            return getSurportedList().indexOf(name) != -1;
        }
        
        public function getSurportedList():Array
        {
            if (surportedList) return surportedList;
            if (xml)
            {
                surportedList = [];
                for each (var node:* in xml.children()) 
                {
                    if (surportedList.indexOf(node.name().toString())==-1)
                    {
                        surportedList.push(node.name().toString());
                    }
                }
            }
            
            return surportedList;
        }
        
        public function getDescriptionMap(name:String):Object
        {
            var result:Object = propertiesMap[name];
            if (!result && xml)
            {
                result = { };
                var node:* = xml[name];
                for each (var field:* in node.children()) 
                {
                    result[String(field.name().toString())] = String(field);
                }
                propertiesMap[name] = result;
            }
            
            return ObjectUtil.copy(result);
        }
        
        public function getProperitesOlder(name:String):Array
        {
            var result:Array = orlderMap[name];
            if (!result)
            {
                result = [];
                var node:* = xml[name];
                for each (var item:* in node.children()) 
                {
                    result.push(item.name().toString());
                }
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