package feditor.utils 
{
    import flash.geom.Rectangle;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    
    /**
     * ...
     * @author gray
     */
    public class GroupUtil 
    {
        public static function group(arr:Array,groupClass:Class):DisplayObjectContainer
        {
            if (groupClass == null) throw new Error("groupClass must be a container definition");;
            var result:DisplayObjectContainer = new groupClass() as DisplayObjectContainer;
            if (result  == null) throw new Error("groupClass must be a container definition");
            
            var bound:Rectangle = Geom.getBound(arr);
            result.x = bound.x;
            result.y = bound.y;
            
            for each (var item:DisplayObject in arr) 
            {
                if (item)
                {
                    item.x -= bound.x;
                    item.y -= bound.y;
                    result.addChild(item);
                }
            }
            return result;
        }
        
        public static function upgroup(group:DisplayObjectContainer):Array
        {
            if (group == null) return null;
            var result:Array = [];
            var len:int = group.numChildren;
            for (var i:int = 0; i < len; i++) 
            {
                var child:DisplayObject = group.removeChildAt(0);
                child.x += group.x;
                child.y += group.y;
                result.push(child);
            }
            return result;
        }
    }

}