package feditor {
    import feditor.utils.Geom;
    import flash.utils.describeType;
    /**
     * ...
     * @author gray
     */
    public class TestCase 
    {
        
        public function TestCase() 
        {
            trace("*****************************************************");
            trace("start test case *************************************");
            trace("*****************************************************");
            var xml:XML = describeType(this);
            for each (var item:XML in xml.method) 
            {
                var funcName:String = item.@name;
                trace(funcName+" ->");
                this[funcName]();
            }
            trace("*****************************************************");
            trace("end test case ***************************************");
            trace("*****************************************************");
        }
        
        public function Geom_parseRect():void
        {
            trace(Geom.parseRect("button-up-10-10-20-20]"));
            trace(Geom.parseRect("button-up-[10,10-20-20]"));
            trace(Geom.parseRect("button-up-[10-10-20-20]"));
            trace(Geom.parseRect("button-up-[10]"));
            trace(Geom.parseRect("button-up-[10-10]"));
            trace(Geom.parseRect("button-up-[10-10-20]"));
            trace(Geom.parseRect("button-up-[10-10-20-10]"));
            trace(Geom.parseRect("button-up-[10-10-20-10-10]"));
        }
        
    }

}