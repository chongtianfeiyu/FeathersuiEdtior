package feditor 
{
    import flash.display.Sprite;
    
    /**
     * ...
     * @author gray
     */
    public class FontLib extends Sprite 
    {
        //[Embed(source = "../../bin/assets/fonts/COMIC.TTF", fontFamily = "ComicSansMS", fontWeight = "normal", mimeType = "application/x-font", embedAsCFF = "true")]
        
        [Embed(source = "../../bin/embed/BRLNSR.TTF", fontFamily = "BRLN", fontWeight = "normal", mimeType = "application/x-font", embedAsCFF = "true")]
        public static const NORMAL:Class;
        
        [Embed(source = "../../bin/embed/BRLNSDB.TTF", fontFamily = "BRLN", fontWeight = "bold", mimeType = "application/x-font", embedAsCFF = "true")]
        public static const BOLD:Class;
        
        public static const NAME:String = "BRLN";
        
        public function FontLib() 
        {
            super();
        }
        
    }

}