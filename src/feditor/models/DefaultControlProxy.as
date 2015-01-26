package feditor.models 
{
    import feditor.AppFacade;
    import feditor.utils.ObjectUtil;
	import flash.filesystem.File;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    /**
     * ...
     * @author gray
     */
    public class DefaultControlProxy extends Proxy 
    {
		public static const LIB_SORT:String = "library_sort";
        public static const CONFIG:String = "config/library";
        public static const NAME:String = "DefaultControlProxy";
        
        private var _xml:XML;
        private var nameList:Array; 
        private var propertiesMap:Object = { };
        private var classMap:Object = { };
        
        public function DefaultControlProxy(data:Object=null) 
        {
            super(NAME, data);
        }
		
		public function updateXML():void
		{
			_xml = null;
			nameList = null;
			propertiesMap = { };
			classMap = { };
		}
        
        public function getNameList():Array
        {
            if (!nameList)
            {
				var sortArr:Array = [];
				var sorterXML:XML =  AppFacade(facade).assets.getXml(LIB_SORT);
				if (sorterXML)
				{
					for each (var item:* in sorterXML.children()) 
					{
						sortArr.push(String(item.name()));
					}
				}
				
				var file:File = File.applicationDirectory.resolvePath(CONFIG);
				var nameList:Array = file.getDirectoryListing().map(
					function(childFile:File, index:int, array:Array):String {
						return String(childFile.name).replace(".xml","");
				});
				
				nameList = nameList.sort(function(a:String, b:String):int {
					var indexA:int = sortArr.indexOf(a);
					var indexB:int = sortArr.indexOf(b);
					if (indexA == -1 || indexA > indexB) return 1;
					return -1;
				});
            }
            
            return nameList;
        }
        
        public function getControlXML(libName:String):*
        {
			var xml:XML = AppFacade(facade).assets.getXml(libName);
			var result:XMLList = xml?xml.children():null;
			if (result && !String(result.@libName))
			{
				result.@libName = libName;
			}
            return result
        }
        
        private function getDefaultProperties(libName:String):Object
        {
            var result:Object = propertiesMap[libName];
            if (!result)
            {
                result = { };
                var node:* = getControlXML(libName);
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
                var node:* = getControlXML(libName);
                result = String(node.name());
                classMap[libName] = result;
            }
            
            return result;
        }
    }

}