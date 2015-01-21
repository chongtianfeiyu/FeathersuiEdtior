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
            var left:int = int.MAX_VALUE;
            var top:int = int.MAX_VALUE;
            var right:int = int.MIN_VALUE;
            var bottom:int = int.MIN_VALUE;
            
            for each (var item:DisplayObject in displayList) 
            {
                if (item == null) continue;
                left = left > item.x?item.x:left;
                top = top > item.y?item.y:top;
                right = right < (item.x + item.width)?(item.x + item.width):right;
                bottom = bottom < (item.y +item.height)?(item.y +item.height):bottom;
            }
            
            var w:int = right - left;
            var h:int = bottom - top;
            
            return  new Rectangle(left,top,w,h);
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