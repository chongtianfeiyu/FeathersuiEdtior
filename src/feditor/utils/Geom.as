package feditor.utils 
{
    import flash.geom.Rectangle;
    import starling.display.DisplayObject;
    /**
     * Geometry tools
     * @author gray
     */
    public class Geom 
    {
        public static function getBound(displayList:Array):Rectangle 
        {            
            var rect:Rectangle = null;
            for each (var item:DisplayObject in displayList) 
            {
                var childRect:Rectangle;
                if (item.parent)
                {
                    childRect = item.getBounds(item.parent);
                }
                else
                {
                    childRect = new Rectangle(item.x,item.y,item.height,item.width);
                }
                
                if (rect == null) rect = childRect;
                else rect = rect.union(childRect);
            }
            return rect||new Rectangle();
        }
        
        /**
         * 
         * @param    a
         * @param    b
         * @return
         */
        public static function isCross(a:Rectangle,b:Rectangle):Boolean
        {
            var isX:Boolean = false;
            var isY:Boolean = false;
            
            if (b.x + b.width > a.x && b.x<a.x + a.width)
            {
                isX = true;
            }
            else if (a.x + a.width > b.x && a.x<b.x + b.width)
            {
                isX = true;
            }
            
            if (b.y + b.height > a.y && b.y<a.y + a.height)
            {
                isY = true;
            }
            else if (a.y + a.height > b.y && a.y<b.y + b.height)
            {
                isY = true;
            }
            
            return isX && isY;
        }
        
        /** 
         * Parse a rect from strings
         * @param source
         * @param regexpString
         * @param split
         * @return
         */
        static public function parseRect(source:String,regexpString:String="(?<=\\[).*(?=\\])",split:String=","):Rectangle
        {
            if (!source) return null;
            
            var regexp:RegExp = new RegExp(regexpString);
            var match:Array = source.match(regexp);
            if (!match || match.length == 0) return null;
            
            var rectString:String = match[0];
            if (new RegExp("[^0-9" + split + "]").test(rectString))
            {
                return null;
            }
            
            var rectArr:Array = rectString.split(split);
            var len:int = rectArr.length;
            
            if (len == 1)   return new Rectangle(rectArr[0],NaN,NaN,NaN);
            else if (len == 2) return new Rectangle(rectArr[0], rectArr[1],NaN,NaN);
            else if (len == 3) return new Rectangle(rectArr[0], rectArr[1], rectArr[2],NaN);
            else if (len >= 4) return new Rectangle(rectArr[0], rectArr[1], rectArr[2], rectArr[3]);
            
            return null;
        }
    }

}