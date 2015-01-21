package feditor.utils 
{
    import feathers.display.Scale3Image;
    import feathers.display.Scale9Image;
    import feathers.display.TiledImage;
    import feathers.textures.Scale3Textures;
    import feathers.textures.Scale9Textures;
    import flash.geom.Rectangle;
    import starling.display.Image;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
    
    /**
     * Assets Facade
     * @author gray
     */
    public class Assets 
    {
        static private var _assets:AssetManager;
        static private var _isEditor:Boolean;
        /**
         * Starling native AssetsManager
         */
        static public function get assets():AssetManager 
        {
            return _assets;
        }
        
        /**
         * Initialize AssetManager for Builder
         * @param assets
         */
        static public function initialize(assets:AssetManager,isEditor:Boolean=false):void
        {
            if (_assets) throw new Error("Assets has been intialized");
            _assets = assets
            _isEditor = isEditor;
        }
        
        /**
         * Get Image by texture name.Return Scale3Image or Scale9Image if texture name has rectangle info.
         * @param textureName
         * @return
         */
        public static function getImage(textureName:String):*
        {
            var result:*;
            var texture:* = getTexture(textureName);
            
            if (texture is Texture)
            {
                result = new Image(texture);
            }
            else if (texture is Scale3Textures)
            {
                result = new Scale3Image(texture);
            }
            else if (texture is Scale9Textures)
            {
                result = new Scale9Image(texture);
            }
            else if ( texture && texture.hasOwnProperty(FieldConst.TILE))
            {
                result = new TiledImage(texture[FieldConst.TILE]);
            }
            
            return result;
        }
        
        /**
         * Get Texture by texture name.Return Scale3Texture or Scale9Texture if texture name has rectangle info.
         * scale9->name:button-up-[5,10,10,30]
         * scale3->name:button-up-[5,10]
         * scale3->name:button-up-[0,0,5,10]
         * Tile->name:button-up-[0,0,0,0]
         * @param textureName
         * @return
         */
        public static function getTexture(textureName:String):*
        {
            var result:*;
            var texture:Texture = _isEditor?TextureMap.getTexture(textureName):_assets.getTexture(textureName);
            
            var rect:Rectangle = Geom.parseRect(textureName);
            if (rect == null) return texture;
            
            if (!isNaN(rect.x) && !isNaN(rect.y) && isNaN(rect.width) && isNaN(rect.height))
            {
                result = new Scale3Textures(texture,rect.x,rect.y);
            }
            else if (rect.x==0 && rect.y==0 && !isNaN(rect.width) && !isNaN(rect.height) && rect.width != 0 && rect.height != 0)
            {
                result = new Scale3Textures(texture,rect.width,rect.height,Scale3Textures.DIRECTION_VERTICAL);
            }
            else if (!isNaN(rect.x) && !isNaN(rect.y) && !isNaN(rect.width) && !isNaN(rect.height))
            {
                if (rect.x == 0 && rect.y == 0 && rect.width == 0 && rect.height == 0)
                {
                    result = { };
                    result[FieldConst.TILE] = texture;
                }
                else
                {
                    result = new Scale9Textures(texture, rect);
                }
                
            }
            
            return result||texture;
        }
    }

}