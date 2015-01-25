package feditor.utils 
{
    import feathers.controls.Button;
    import feathers.controls.ImageLoader;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.ProgressBar;
    import feathers.controls.text.StageTextTextEditor;
    import feathers.controls.text.TextBlockTextEditor;
    import feathers.controls.text.TextBlockTextRenderer;
    import feathers.controls.text.TextFieldTextEditor;
    import feathers.controls.text.TextFieldTextRenderer;
    import feathers.controls.TextInput;
    import feathers.controls.ToggleButton;
    import feathers.display.Scale3Image;
    import feathers.display.Scale9Image;
    import feathers.display.TiledImage;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    import feathers.textures.Scale3Textures;
    import feathers.textures.Scale9Textures;
    import feditor.vo.FieldVO;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import starling.display.DisplayObject;
    import starling.display.Image;
    /**
     * Editor Only
     * @author gray
     */
    public class Reflect 
    {
        public static var fieldMethodMap:Dictionary;
        
        /**
         * 返回Builder 支持的属性表
         * @param obj
         * @return
         */
        public static function getFieldMap(obj:Object):Object
        {   
            if (!fieldMethodMap)
            {
                fieldMethodMap = new Dictionary();
                fieldMethodMap[ElementFormat] = getElementFormatProperties;
                fieldMethodMap[DisplayObject] = getDisplayObjectProperties;
                fieldMethodMap[Image] = getImageProperties;
                fieldMethodMap[Scale3Image] = getImageProperties;
                fieldMethodMap[Scale9Image] = getImageProperties;
                fieldMethodMap[TiledImage] = getImageProperties;
                fieldMethodMap[Label] = getLabelProperties;
                fieldMethodMap[TextInput] = getTextInputProperties;
                fieldMethodMap[Button] = getButtonProperties;
                fieldMethodMap[ToggleButton] = getToggleButtonProperties;
                fieldMethodMap[LayoutGroup] = getLayoutGroupProperties;
                fieldMethodMap[ProgressBar] = getProgressbarProerties;
                fieldMethodMap[ImageLoader] = getImageLoaderProperties;
                fieldMethodMap[List] = getListProperties;
            }
            
            var result:Object = { };
            var def:Class = getDefinition(obj);
            if (def && fieldMethodMap[def])
            {
                fieldMethodMap[def](obj,result);
            }
            
            if (DisplayObject(obj))
            {
                getDisplayObjectProperties(DisplayObject(obj),result);
            }
            
            return result;
        }
        
        public static function getDefinition(obj:Object):*
        {
            var ns:String = getQualifiedClassName(obj).replace("::", ".");
            return getDefinitionByName(ns);
        }
        
        private static function getDisplayObjectProperties(display:DisplayObject,result:Object=null):Object
        {
            result ||= { };
            if (display)
            {
                result.x = display.x;
                result.y = display.y;
                result.width = display.width;
                result.height = display.height;
                result.alpha = display.alpha;
                result.name = display.name;
                result.touchable = display.touchable;
                result.visible = display.visible;
            }
            
            return result;
        }
        
        private static function getLayoutGroupProperties(box:LayoutGroup,result:Object=null):Object
        {
            result ||= { };
            if (box)
            {
                result.touchGroup = box.touchGroup;
                result.maxWidth = box.maxWidth;
                result.maxHeight = box.maxHeight;
                result.minWidth = box.minWidth;
                result.minHeight = box.minHeight;
                result.backgroundSkin = getImageProperties(box.backgroundSkin)[FieldConst.IMAGE_TEXTURE] || "";
                
                if (box.layout)
                {
                    getLayoutProperties(box.layout, result);
                }
            }
            return result;
        }
        
        private static function getLayoutProperties(layout:*,result:Object=null):Object
        {
            result ||= { };
            if (layout is HorizontalLayout)
            {
                result[FieldConst.LAYOUT] = FieldConst.LAYOUT_HORIZONTAL;
                result.gap = HorizontalLayout(layout).gap;
                result.padding = HorizontalLayout(layout).padding;
                result.paddingLeft = HorizontalLayout(layout).paddingLeft;
                result.paddingRight = HorizontalLayout(layout).paddingRight;
                result.paddingTop = HorizontalLayout(layout).paddingTop;
                result.paddingBottom = HorizontalLayout(layout).paddingBottom;
                result.horizontalAlign = HorizontalLayout(layout).horizontalAlign;
                result.verticalAlign = HorizontalLayout(layout).verticalAlign;
            }
            else if (layout is VerticalLayout)
            {
                result[FieldConst.LAYOUT] = FieldConst.LAYOUT_VERTICAL;
                result.gap = VerticalLayout(layout).gap;
                result.padding = VerticalLayout(layout).padding;
                result.paddingLeft = VerticalLayout(layout).paddingLeft;
                result.paddingRight = VerticalLayout(layout).paddingRight;
                result.paddingTop = VerticalLayout(layout).paddingTop;
                result.paddingBottom = VerticalLayout(layout).paddingBottom;
                result.horizontalAlign = VerticalLayout(layout).horizontalAlign;
                result.verticalAlign = VerticalLayout(layout).verticalAlign;
            }
            return result;
        }
        
        private static function getLabelProperties(label:Label,result:Object=null):Object
        {
            result ||= { };
            if (label)
            {
                result = getElementFormatProperties(label.textRendererProperties.elementFormat,result);
                result.text = label.text;
                result.touchable = label.touchable;
            }
            return result;
        }
        
        private static function getElementFormatProperties(elementFormat:ElementFormat,result:Object=null):Object
        {
            result ||= { };
            if (elementFormat)
            {
                var fmt:ElementFormat = elementFormat;
                if (fmt == null) return result;
                
                var des:FontDescription = fmt.fontDescription;
                if (des)
                {
                    result.fontName = des.fontName;
                    result.fontWeight = des.fontWeight;
                }
                
                result.fontSize = fmt.fontSize;
                result.color = fmt.color;
            }
            
            return result;
        }
        
        private static function getButtonProperties(button:Button,result:Object=null):Object
        {
            result ||= { };
            if (button)
            {
                result = getElementFormatProperties(button.defaultLabelProperties.elementFormat, result);
                result = getDisplayObjectProperties(button, result);
                result.label = button.label;
                result.gap = button.gap;
                result.iconOffsetX = button.iconOffsetX;
                result.iconOffsetY = button.iconOffsetY;
                result.iconPosition = button.iconPosition;
                result.minWidth = button.minWidth;
                result.minHeight = button.minHeight;
                result.maxWidth = button.maxWidth;
                result.maxHeight = button.maxHeight;
                result.padding = button.padding;
                result.paddingLeft = button.paddingLeft;
                result.paddingRight = button.paddingRight;
                result.paddingTop = button.paddingTop;
                result.paddingBottom = button.paddingBottom;
                
                var skins:Array = [FieldConst.BUTTON_DEFAULT_ICON,FieldConst.BUTTON_DEFAULT_SKIN,FieldConst.BUTTON_DOWN_SKIN,FieldConst.BUTTON_DISABLED_SKIN];
                for each (var skinName:String in skins) 
                {
                    var skinProperties:Object = getImageProperties(button[skinName]);
                    result[skinName] = skinProperties?skinProperties[FieldConst.IMAGE_TEXTURE]:"";
                }
            }
            
            return result;
        }
        
        private static function getToggleButtonProperties(toggleButton:ToggleButton,result:Object=null):Object
        {
            result ||= { };
            if (toggleButton)
            {
                getButtonProperties(toggleButton, result);
                result.isSelected = toggleButton.isSelected;
                
                var skins:Array = [FieldConst.TOGGLE_BUTTON_DEFAULT_SELECTED_ICON,FieldConst.TOGGLE_BUTTON_DEFAULT_SELECTED_SKIN];
                for each (var skinName:String in skins) 
                {
                    var skinProperties:Object = getImageProperties(toggleButton[skinName]);
                    result[skinName] = skinProperties?skinProperties[FieldConst.IMAGE_TEXTURE]:"";
                }
            }
            
            return result;
        }
        
        /**
         * Get Image base property
         * @param image
         * @param result
         * @return
         */
        private static function getImageProperties(image:*,result:Object=null):Object
        {   
            result ||= { };
            if (image is Image)
            {
                var img:Image = image as Image;
                result[FieldConst.IMAGE_TEXTURE] = TextureMap.getTextureName(img.texture);
            }
            else if (image is Scale3Image)
            {
                var img3:Scale3Image = image as Scale3Image;
                var texture3:Scale3Textures = img3.textures;
                result[FieldConst.IMAGE_TEXTURE] = TextureMap.getTextureName(texture3.texture);
            }
            else if (image is Scale9Image)
            {
                var img9:Scale9Image = image as Scale9Image;
                var texture9:Scale9Textures = img9.textures;
                result[FieldConst.IMAGE_TEXTURE] = TextureMap.getTextureName(texture9.texture);
            }
            else if (image is TiledImage)
            {
                var tile:TiledImage = image as TiledImage;
                result[FieldConst.IMAGE_TEXTURE] = TextureMap.getTextureName(tile.texture);
            }
            
            return result;
        }
        
        private static function getImageLoaderProperties(imageLoader:ImageLoader,result:Object):Object
        {
            result ||= { };
            if (imageLoader)
            {
                result.source = imageLoader.source;
                result.errorTexture = TextureMap.getTextureName(imageLoader.errorTexture);
                result.loadingTexture = TextureMap.getTextureName(imageLoader.loadingTexture);
                result.maintainAspectRatio = imageLoader.maintainAspectRatio;
            }
            return result;
        }
        
        private static function getTextInputProperties(textInput:TextInput,result:Object):Object
        {
            result ||= { };
            if (textInput)
            {
                var skins:Array = [FieldConst.TEXT_INPUT_BACKGROUND_SKIN,FieldConst.TEXT_INPUT_BACKGROUND_SKIN];
                for each (var skinName:String in skins) 
                {
                    var skinProperties:Object = getImageProperties(textInput[skinName]);
                    result[skinName] = skinProperties?skinProperties[FieldConst.IMAGE_TEXTURE]:"";
                }
				
                getElementFormatProperties(textInput.textEditorProperties.elementFormat, result);
                var promptProperties:Object = getElementFormatProperties(textInput.promptProperties.elementFormat);
                result[FieldConst.TEXT_INPUT_PROMPT_COLOR] = promptProperties.color;
                
                result.text = textInput.text;
                result.prompt = textInput.prompt;
                result.displayAsPassword = textInput.displayAsPassword;
                result.isEditable = textInput.isEditable;
                result.gap = textInput.gap;
                result.padding = textInput.padding;
                result.paddingLeft = textInput.paddingLeft;
                result.paddingRight = textInput.paddingRight;
                result.paddingTop = textInput.paddingTop;
                result.paddingBottom = textInput.paddingBottom;
            }
            return result;
        }
        
        private static function getTextProperties(txt:*,result:Object):Object
        {
            result ||= { };
            if (txt)
            {
                if (txt is StageTextTextEditor)
                {
                    var stageText:StageTextTextEditor = StageTextTextEditor(txt);
                    result.fontFamily = stageText.fontFamily;
                    result.fontSize = stageText.fontSize;
                    result.fontWeight = stageText.fontWeight;
                    result.color = stageText.color;
                }
                else if (txt is TextFieldTextEditor || txt is TextFieldTextRenderer)
                {
                    var textFormat:TextFormat = txt.textFormat;
                    result.color = textFormat.color;
                    result.fontSize = textFormat.size;
                    result.fontName = textFormat.font;
                    result.fontWeight = textFormat.bold?"bold":"normal";
                }
                else if (txt is TextBlockTextEditor || txt is TextBlockTextRenderer)
                {
                    getElementFormatProperties(txt.elementFormat, result);
                }
            }
            return result;
        }
        
        /**
         * 
         * @param progressBar
         * @param result
         * @return
         */
        private static function getProgressbarProerties(progressBar:ProgressBar,result:Object=null):Object
        {
            result ||= { };
            if (progressBar)
            {
                var skins:Array = [FieldConst.PROGRESS_FILL_SKIN,FieldConst.PROGRESS_BACKGROUND_SKIN];
                for each (var skinName:String in skins) 
                {
                    var skinProperties:Object = getImageProperties(progressBar[skinName]);
                    result[skinName] = skinProperties?skinProperties[FieldConst.IMAGE_TEXTURE]:"";
                }
            }
            return result;
        }
        
        private static function getListProperties(list:List,result:Object):Object
        {
            result ||= { };
            if (list)
            {
                var skinProperties:Object = getImageProperties(list.backgroundSkin);
                result.backgroundSkin = skinProperties?skinProperties[FieldConst.IMAGE_TEXTURE]:"";
                getLayoutProperties(list.layout, result);
                result.padding = list.padding;
                result.paddingLeft = list.paddingLeft;
                result.paddingRight = list.paddingRight;
                result.paddingTop = list.paddingTop;
                result.paddingBottom = list.paddingBottom;
                
                result[FieldConst.LIST_ITEM_RENDERER] = list.itemRendererProperties.name;
            }
            
            return result;
        }
    }
}