package feditor.utils 
{
    import feathers.controls.text.StageTextTextEditor;
    import feathers.controls.text.TextBlockTextRenderer;
    import feathers.core.FeathersControl;
    import flash.text.engine.CFFHinting;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
    import flash.text.engine.FontLookup;
    import flash.text.engine.FontPosture;
    import flash.text.engine.FontWeight;
    import flash.text.engine.RenderingMode;
    /**
     * ...
     * @author gray
     */
    public class FontWorker 
    {
        private static var _fontName:String;
        private static var _boldFont:Class;
        private static var _normalFont:Class;
        
        /**
         * 
         * @param    fontname
         * @param    normalClass
         * @param    boldClass
         */
        public function FontWorker(fontname:String,normalClass:Class,boldClass:Class)
        {
            if (_fontName || _boldFont || _normalFont)
            {
                throw new Error("Worker has be created");
            }
            
            _fontName = fontname;
            _boldFont = boldClass;
            _normalFont = normalClass;
        }
        
        static public function get defaultFontName():String 
        {
            return _fontName;
        }
        
        static public function get defaultBoldFont():Class 
        {
            return _boldFont;
        }
        
        static public function get defaultNormalFont():Class 
        {
            return _normalFont;
        }
        
        static public function textRendererFactory():TextBlockTextRenderer
        {
            return new TextBlockTextRenderer();
        }
        
        static public function textEditorFactory():StageTextTextEditor
        {
            return new StageTextTextEditor();
        }
        
        
        private static var _defaultNormalFontDescription:FontDescription;
        static public function get defaultNormalFontDescription():FontDescription
        {
            if (!_defaultNormalFontDescription)
            {
                _defaultNormalFontDescription = new FontDescription(_fontName, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
            }
            return _defaultNormalFontDescription;
        }
        
        private static var _defaultBoldFontDescription:FontDescription;
        static public function get defaultBoldFontDescription():FontDescription
        {
            if (!_defaultBoldFontDescription)
            {
                _defaultBoldFontDescription = new FontDescription(_fontName, FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
            }
            return _defaultBoldFontDescription;
        }
        
        static private var _defaultElement:ElementFormat;
        static public function get defaultElementFormat():ElementFormat
        {
            if (!_defaultElement)
            {
                _defaultElement = new ElementFormat(defaultBoldFontDescription,48,0xfffff);
            }
            
            return _defaultElement;
        }
        
        static public function getElementFormat(size:int,color:int,isBold:Boolean):ElementFormat
        {
            if (isBold)
            {
                return new ElementFormat(defaultBoldFontDescription,size,color);
            }
            
            return new ElementFormat(defaultNormalFontDescription,size,color);
        }
    }

}