package feditor.utils 
{
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    /**
     * 
     * @author gray
     */
    public class ObjectUtil 
    {
        private static var byte:ByteArray = new ByteArray();
        
        /**
         * copy an object without type
         * @param obj
         * @return
         */
        public static function copy(obj:Object):Object
        {
            byte.clear();
            byte.writeObject(obj);
            byte.position = 0;
            return byte.readObject();
        }
        
        /**
         * set object fields with a fields object
         * @param fieldsTree
         * @param result
         * @return
         */
        public static function mapping(fieldsTree:Object,result:Object):*
        {
            if (result == null) return result;
            for (var name:String in fieldsTree) 
            {
                if (result.hasOwnProperty(name))
                {
                    try 
                    {
                        result[name] = fieldsTree[name];
                    }
                    catch (err:Error)
                    {
						trace(err);
                    }
                }
            }
            return result;
        }
    }

}