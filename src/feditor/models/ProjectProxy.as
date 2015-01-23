package feditor.models 
{
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    
    /**
     * ...
     * @author gray
     */
    public class ProjectProxy extends Proxy 
    {
        public static const NAME:String = "ProjectProxy";
        
        private var _projectName:String = "";
        public function ProjectProxy(data:Object=null) 
        {
            super(NAME, data);
        }
        
        public function get projectName():String 
        {
            return _projectName;
        }
        
        public function set projectName(value:String):void 
        {
            _projectName = value;
        }
        
    }

}