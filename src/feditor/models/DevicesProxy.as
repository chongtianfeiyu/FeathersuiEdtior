package feditor.models 
{
    import feditor.AppFacade;
    import feditor.vo.ProjectVO;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    /**
     * ...
     * @author gray
     */
    public class DevicesProxy extends Proxy 
    {
        public static const CONFIG:String = "device";
        public static const NAME:String = "DevicesProxy";
        public function DevicesProxy(data:Object=null) 
        {
            super(NAME, data);
        }
        
        public function getDevicesList():Array
        {
            var xml:XML = AppFacade(facade).assets.getXml(CONFIG);
            var result:Array = [];
            if (xml)
            {
                for each (var item:* in xml.children()) 
                {
                    var projectVO:ProjectVO = new ProjectVO();
                    projectVO.name = item.@name;
                    projectVO.width = item.@width;
                    projectVO.height = item.@height;
                    projectVO.color = item.@color;
                    result.push(projectVO);
                }
            }
            
            return result;
        }
    }

}