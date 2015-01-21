package feditor.utils 
{
    import starling.textures.Texture;
    /**
     * Editor Only
     * @author gray
     */
    public class TextureMap 
    {
        static private var textureMap:Object = { };
        /**
         * Editor的控件纹理都只能从此处获取。以便于纹理名字查询
         * 获取纹理
         * @param name
         * @return
         */
        static public function getTexture(name:String):Texture
        {
            var result:Texture = textureMap[name];
            if (!result)
            {
                result = Assets.assets.getTexture(name);
                textureMap[name] = result;
            }
            
            return result;
        }
        
        /**
         * 获取纹理名字
         * @param texture
         * @return
         */
        static public function getTextureName(texture:Texture):String
        {
            for (var name:String in textureMap) 
            {
                if (textureMap[name] == texture)
                {
                    return name;
                }
            }
            
            return "";
        }
        
    }

}