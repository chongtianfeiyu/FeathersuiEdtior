package feditor.utils 
{
    import feathers.controls.text.StageTextTextEditor;
    import feathers.controls.text.TextBlockTextEditor;
    import feathers.controls.text.TextBlockTextRenderer;
    import feathers.core.FeathersControl;
    import flash.text.engine.CFFHinting;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
    import flash.text.engine.FontLookup;
    import flash.text.engine.FontPosture;
    import flash.text.engine.FontWeight;
    import flash.text.engine.RenderingMode;
	import flash.text.TextFormat;
    /**
     * ...
     * @author gray
     */
    public class FontWorker 
    {
        private static var _fontName:String;
        private static var _boldFont:Class;
        private static var _normalFont:Class;
		private static var _textRenderDef:Class;
		private static var _textEditorDef:Class;
		private static var _fontSize:int;
		private static var _fontColor:int;
		private static var _fontWeight:String;
		
		private static var _defaultNormalFontDescription:FontDescription;
		private static var _defaultBoldFontDescription:FontDescription;
		static private var _defaultElement:ElementFormat;
		static private var _defaultTextFormat:TextFormat;
        
        /**
         * 
         * @param	fontname
         * @param	normalClass
         * @param	boldClass
         * @param	defaultFontSize
         * @param	defaultFontColor
         * @param	defaultFontWeight
         * @param	textRendererDef
         * @param	textEditorDef
         */
        public function FontWorker(fontname:String,
			normalClass:Class,
			boldClass:Class,
			defaultFontSize:int = 30,
			defaultFontColor:int = 0xffffff,
			defaultFontWeight:String = "bold",
			textRendererDef:Class = null,
			textEditorDef:Class=null)
        {
            if (_fontName || _boldFont || _normalFont)
            {
                throw new Error("Worker has be created");
            }
            
            _fontName = fontname;
            _boldFont = boldClass;
            _normalFont = normalClass;
			_fontSize = defaultFontSize;
			_fontColor = defaultFontColor;
			_fontWeight = defaultFontWeight;
			_textEditorDef = textEditorDef || TextBlockTextRenderer;
			_textRenderDef = textRendererDef || TextBlockTextEditor;
			
			_defaultTextFormat = new TextFormat(_fontName,_fontSize,_fontColor,_fontWeight=="bold"?true:false);
        }
		
		static public function textRendererFactory():TextBlockTextRenderer
        {
            return new _textRenderDef();
        }
        
        static public function textEditorFactory():*
        {
            return new _textEditorDef();
        }
		
		static public function getElementFormat(size:int,color:int,isBold:Boolean):ElementFormat
        {
            if (isBold)
            {
                return new ElementFormat(defaultBoldFontDescription,size,color);
            }
            
            return new ElementFormat(defaultNormalFontDescription,size,color);
        }
        
        
        static public function get defaultNormalFontDescription():FontDescription
        {
            if (!_defaultNormalFontDescription)
            {
                _defaultNormalFontDescription = new FontDescription(_fontName, FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
            }
            return _defaultNormalFontDescription;
        }
        
        
        static public function get defaultBoldFontDescription():FontDescription
        {
            if (!_defaultBoldFontDescription)
            {
                _defaultBoldFontDescription = new FontDescription(_fontName, FontWeight.BOLD, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE);
            }
            return _defaultBoldFontDescription;
        }
        
        
        static public function get defaultElementFormat():ElementFormat
        {
            if (!_defaultElement)
            {
                _defaultElement = new ElementFormat(_fontWeight=="bold"?defaultBoldFontDescription:defaultNormalFontDescription,_fontSize, _fontColor);
                _defaultElement.locked = false;
            }
            
            return _defaultElement;
        }
		
		
		static public function get defaultTextFormat():TextFormat 
		{
			return _defaultTextFormat;
		}
		
		static public function get textRenderDef():Class 
		{
			return _textRenderDef;
		}
		
		static public function get textEditorDef():Class 
		{
			return _textEditorDef;
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
        
        
        
    }

}