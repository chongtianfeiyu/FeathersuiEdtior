package feditor.utils 
{
    import feathers.controls.Button;
    import feathers.controls.ImageLoader;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
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
    import feathers.layout.ILayout;
    import feathers.layout.VerticalLayout;
    import feathers.text.StageTextField;
    import feathers.textures.Scale3Textures;
    import feathers.textures.Scale9Textures;
    import feditor.Root;
    import flash.geom.Rectangle;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.textures.Texture;
    /**
     * ...
     * @author gray
     */
    public class Builder 
    {
        //default
        public static const XMLROOT:String = "View";
        private static var surportClassPool:Object;
        private static var fieldsMethod:Dictionary;
        private static var isEditor:Boolean;
        private static var building:Boolean;
        
        /**
         * Initialize Class Map
         * @param surportClassPool {"ClassName":Class}
         */
        public static function initialize(surportClassPool:Object,isEditor:Boolean=false):void
        {
            Builder.surportClassPool = surportClassPool;
            
            fieldsMethod = new Dictionary(true);
            fieldsMethod[Label] = setLabelFields;
            fieldsMethod[TextInput] = setTextInputFields;
            fieldsMethod[Image] = setImageFields;
            fieldsMethod[Scale3Image] = setImageFields;
            fieldsMethod[Scale9Image] = setImageFields;
            fieldsMethod[TiledImage] = setImageFields;
            fieldsMethod[ImageLoader] = setImageLoaderFields;
            fieldsMethod[Button] = setButtonFields;
            fieldsMethod[ToggleButton] = setToggleButtonFields;
            fieldsMethod[LayoutGroup] = setLayoutGroupFields;
            fieldsMethod[ProgressBar] = setProgressBarFields;
            Builder.isEditor = isEditor;
        }
        
        public static function getSurportClass(className:String):Class
        {
            return surportClassPool[className] as Class;
        }
        
        public static function build(container:DisplayObjectContainer, xml:*):DisplayObject
        {
            building = true;
            var result:* = createView(container, xml, container);
            building = false;
            return result;
        }
        
        private static function createView(container:DisplayObjectContainer, xml:*,root:DisplayObjectContainer):DisplayObject
        {
            var son:*;
            
            //self ns
            if (xml.name() != XMLROOT)
            {
                var def:Class = getSurportClass(String(xml.name()));
                var properties:Object = { };
                
                var inject:String;
                //self attributes
                for each (var attr:XML in xml.attributes()) 
                {
                    var fieldName:String = String(attr.name());
                    properties[fieldName] = String(attr);
                    if (fieldName == "name")
                    {
                        inject = fieldName;
                    }
                }
                
                son = createInstance(def, properties);
                container.addChild(son);
            }
            
            if (!son) son = container;
            
            if (inject && root.hasOwnProperty(inject) && typeof(root[inject])=="object" && !(root[inject]))
            {
                try 
                {
                    root[inject] = son;
                }
                catch (e:Error)
                {
                    trace("Builder.build - inject error");
                }
            }
            
            //grandson nodes
            for each (var grandson:* in xml.children()) 
            {
                DisplayObjectContainer(son).addChild(build(son,grandson));
            }
            return son;
        }
        
        public static function createInstance(def:Class,args:Object):*
        {   
            var result:*;
            switch (def) 
            {
                case Image:
                case Scale3Image:
                case Scale9Image:
                case TiledImage:
                    result = Assets.getImage(args[FieldConst.IMAGE_TEXTURE]);
                    delete args[FieldConst.IMAGE_TEXTURE];
                    break;
                default:
                    result =  new def();
                    break;
            }
            
            if(result) setFields(result,args);
            
            return result;
        }
        
        public static function setFields(obj:*,propertiesMap:Object):*
        {
            if (obj == null) return null;
            var method:Function = fieldsMethod[Reflect.getDefinition(obj)] as Function;
            if (method!=null) method(obj,propertiesMap);
            return obj;
        }
        
        /**
         * clone
         * @param obj
         * @return
         */
        public static function clone(obj:*):*
        {
            var def:Class = Reflect.getDefinition(obj) as Class;
            
            if (obj == null || def == null) return null;
            
            var properties:Object = Reflect.getFieldMap(obj);
            
            for (var name:String in properties) 
            {
                properties[name] = obj[name];
            }
            
            var instance:* = createInstance(obj, properties);
            
            return instance;
        }
        
        public static function getFontDescription(properties:Object):FontDescription
        {
            return new FontDescription(
                properties.fontName, 
                properties.fontWeight,
                properties.fontPosture, 
                properties.fontLookup,
                properties.renderingMode,
                properties.cffHinting
            );
        }
        
        public static function getElementFormat(des:FontDescription,properties:Object):ElementFormat
        {    
            return new ElementFormat(
                des,
                properties.fontSize, 
                properties.color,
                properties.alpha, 
                properties.textRotation, 
                properties.dominantBaseline,
                properties.alignmentBaseline, 
                properties.baselineShift, 
                properties.kerning,
                properties.trackingRight,
                properties.trackingLeft,
                properties.locale,
                properties.breakOpportunity,
                properties.digitCase,
                properties.digitWidth,
                properties.ligatureLevel,
                properties.typographicCase
            );
        }
        
        private static function setProgressBarFields(progressBar:ProgressBar,valueMap:Object):ProgressBar
        {
            if (isEditor)
            {
                progressBar.styleProvider = null;
            }
            
            if (FieldConst.PROGRESS_BACKGROUND_SKIN in valueMap)
            {
                progressBar.backgroundSkin = Assets.getImage(valueMap[FieldConst.PROGRESS_BACKGROUND_SKIN]);
                progressBar.width = progressBar.backgroundSkin.width;
                progressBar.height = progressBar.backgroundSkin.height;
                delete valueMap[FieldConst.PROGRESS_BACKGROUND_SKIN];
            }
            
            if (FieldConst.PROGRESS_FILL_SKIN in valueMap)
            {
                progressBar.fillSkin = Assets.getImage(valueMap[FieldConst.PROGRESS_FILL_SKIN]);
                delete valueMap[FieldConst.PROGRESS_FILL_SKIN];
            }
            
            
            setDisplayObjectFields(progressBar, valueMap);
            return progressBar;
        }
        
        private static function setLabelFields(label:Label,valueMap:Object):Label
        {
            if (!label.textRendererProperties.elementFormat)
            {
                label.styleProvider = null;
                label.textRendererProperties.elementFormat = FontWorker.defaultElementFormat;
            }
            
            if (FieldConst.FONT_COLOR in valueMap || 
                FieldConst.FONT_SIZE in valueMap ||
                FieldConst.FONT_NAME in valueMap ||
                FieldConst.FONT_WEIGHT in valueMap
            )
            {
                var fmt:Object = ObjectUtil.copy(label.textRendererProperties.elementFormat);
                var des:Object = fmt?ObjectUtil.copy(label.textRendererProperties.elementFormat.fontDescription):null;
                if (fmt) ObjectUtil.mapping(valueMap, fmt);
                if (des) ObjectUtil.mapping(valueMap,des);
                if (fmt) label.textRendererProperties.elementFormat = getElementFormat(getFontDescription(des), fmt);
                
                delete valueMap[FieldConst.FONT_COLOR];
                delete valueMap[FieldConst.FONT_SIZE];
                delete valueMap[FieldConst.FONT_NAME];
                delete valueMap[FieldConst.FONT_WEIGHT];
            }
            
            setDisplayObjectFields(label,valueMap);
            
            return label;
        }
        
        private static function setTextInputFields(textInput:TextInput,valueMap:Object):TextInput
        {   
            if (!textInput.textEditorProperties.elementFormat)
            {
                textInput.styleProvider = null;
                textInput.textEditorProperties.elementFormat = FontWorker.defaultElementFormat;
            }
            
            if (!textInput.promptProperties.elementFormat)
            {
                textInput.promptProperties.elementFormat = FontWorker.defaultElementFormat;
            }
            
            if (FieldConst.FONT_COLOR in valueMap || 
                FieldConst.FONT_SIZE in valueMap ||
                FieldConst.FONT_NAME in valueMap ||
                FieldConst.FONT_WEIGHT in valueMap
            )
            {
                var fmt:Object = ObjectUtil.copy(textInput.textEditorProperties.elementFormat);
                var des:Object = fmt?ObjectUtil.copy(textInput.textEditorProperties.elementFormat.fontDescription):null;
                if (fmt) ObjectUtil.mapping(valueMap, fmt);
                if (des) ObjectUtil.mapping(valueMap,des);
                if (fmt) 
                {
                    var pColor:int = textInput.promptProperties.elementFormat.color;
                    var elmentFormat:ElementFormat = getElementFormat(getFontDescription(des), fmt);
                    
                    textInput.promptProperties.elementFormat = elmentFormat;
                    textInput.textEditorProperties.elementFormat = elmentFormat;
                }
                
                delete valueMap[FieldConst.FONT_COLOR];
                delete valueMap[FieldConst.FONT_SIZE];
                delete valueMap[FieldConst.FONT_NAME];
                delete valueMap[FieldConst.FONT_WEIGHT];
            }
            
            if (FieldConst.TEXT_INPUT_PROMPT_COLOR in valueMap)
            {
                trace("Build.setTextInputFields - > TextInput 的文本属性映射不成功")
                //trace(textInput.promptProperties.elmentFormat);
                //textInput.promptProperties.elmentFormat.color = parseInt(valueMap[FieldConst.TEXT_INPUT_PROMPT_COLOR],16);
                delete valueMap[FieldConst.TEXT_INPUT_PROMPT_COLOR];
            }
            
            //try 
            //{
                //textInput.textEditorProperties[FieldConst.FONT_WEIGHT] = valueMap[FieldConst.FONT_WEIGHT];
                //textInput.textEditorProperties[FieldConst.FONT_NAME] = valueMap[FieldConst.FONT_NAME];
                //textInput.textEditorProperties[FieldConst.FONT_COLOR] = valueMap[FieldConst.FONT_COLOR];
                //textInput.textEditorProperties[FieldConst.FONT_SIZE] = valueMap[FieldConst.FONT_SIZE];
                //
                //textInput.textEditorProperties.
            //}
            //catch (err:Error)
            //{
                //trace("TextInput setField error");
            //}
            
            
            if (FieldConst.TEXT_INPUT_BACKGROUND_SKIN in valueMap)
            {
                textInput.backgroundSkin = Assets.getImage(valueMap[FieldConst.TEXT_INPUT_BACKGROUND_SKIN]);
            }
            
            if (FieldConst.TEXT_INPUT_DEFAULT_ICON in valueMap)
            {
                textInput.defaultIcon = Assets.getImage(valueMap[FieldConst.TEXT_INPUT_DEFAULT_ICON]);
            }
            
            delete valueMap[FieldConst.TEXT_INPUT_BACKGROUND_SKIN];
            delete valueMap[FieldConst.TEXT_INPUT_DEFAULT_ICON];
            
            
            //textInput.prompt
            //others
            setDisplayObjectFields(textInput, valueMap);
            return textInput;
        }
        
        private static function setTxtFields(txt:*,valueMap:Object):*
        {
            if (txt is StageTextTextEditor || txt is StageTextField)
            {
                if (FieldConst.FONT_COLOR in valueMap) txt.color = valueMap[FieldConst.FONT_COLOR];
                if (FieldConst.FONT_NAME in valueMap) txt.fontFamily = valueMap[FieldConst.FONT_NAME];
                if (FieldConst.FONT_SIZE in valueMap) txt.fontSize = valueMap[FieldConst.FONT_SIZE];
                if (FieldConst.FONT_WEIGHT in valueMap) txt.fontWeight = valueMap[FieldConst.FONT_WEIGHT];
            }
            else if(txt is TextBlockTextEditor || txt is TextBlockTextRenderer)
            {
                var elment:ElementFormat = txt.elementFormat || FontWorker.defaultElementFormat;
                txt.elementFormat = getElementFormat(elment.fontDescription, valueMap);
            }
            else if (txt is TextFieldTextEditor || txt is TextFieldTextRenderer)
            {
                var fmt:TextFormat = txt.textFormat;
                if (FieldConst.FONT_WEIGHT in valueMap) fmt.bold = valueMap[FieldConst.FONT_WEIGHT] == FieldConst.FONT_BOLD;
                if (FieldConst.FONT_NAME in valueMap) fmt.font = valueMap[FieldConst.FONT_NAME];
                if (FieldConst.FONT_SIZE in valueMap) fmt.size = valueMap[FieldConst.FONT_SIZE];
                if (FieldConst.FONT_COLOR in valueMap) fmt.color = valueMap[FieldConst.FONT_COLOR];
                txt.textFormat = fmt;
            }
            
            delete valueMap[FieldConst.FONT_WEIGHT];
            delete valueMap[FieldConst.FONT_SIZE];
            delete valueMap[FieldConst.FONT_NAME];
            delete valueMap[FieldConst.FONT_COLOR];
            
            return txt;
        }
        
        private static function setDisplayObjectFields(display:DisplayObject,valueMap:Object):DisplayObject
        {
            for (var name:String in valueMap) 
            {
                try 
                {    
                    if (name == "visible")
                    {
                        display[name] = valueMap[name]=="false"?false:true;
                    }
                    else if (name == "color")
                    {
                        display[name] = parseInt(valueMap[name],16);
                    }
                    else
                    {
                        display[name] = valueMap[name];
                    }
                }
                catch (err:Error)
                {
                    trace("Builder.setDisplayObjectFields ::Set Fields Error - " + name);
                }
            }
            
            return display;
        }
        
        private static function setImageFields(image:*,valueMap:Object):*
        {
            if (FieldConst.IMAGE_TEXTURE in valueMap)
            {
                var texture:* = Assets.getTexture(valueMap[FieldConst.IMAGE_TEXTURE]);
                
                if (texture)
                {
                    if (texture.hasOwnProperty(FieldConst.TILE))
                    {
                        TiledImage(image).texture = texture[FieldConst.TILE];
                    }
                    else if (texture is Texture && image is Image)
                    {
                        Image(image).texture = texture;
                    }
                    else if (texture is Scale3Textures && image is Scale3Image)
                    {
                        Scale3Image(image).textures = texture;
                    }
                    else if (texture is Scale9Textures && image is Scale9Image)
                    {
                        Scale9Image(image).textures = texture;
                    }
                    else
                    {
                        if (image is Image)
                        {
                            if (texture is Scale3Textures)
                            {
                                Image(image).texture = Scale3Textures(texture).texture;
                            }
                            else if (texture is Scale9Textures)
                            {
                                Image(image).texture = Scale9Textures(texture).texture;
                            }
                            else if (texture is Texture)
                            {
                                Image(image).texture = texture;
                            }
                        }
                        else if (image is Scale3Image)
                        {
                            if (texture is Scale3Textures)
                            {
                                Scale3Image(image).textures = texture;
                            }
                            else if (texture is Scale9Textures)
                            {
                                Scale3Image(image).textures = new Scale3Textures(Scale9Textures(texture).texture,0,0);
                            }
                            else if (texture is Texture)
                            {
                                Scale3Image(image).textures = new Scale3Textures(texture,0,0);
                            }
                        }
                        else if (image is Scale9Image)
                        {
                            if (texture is Scale3Textures)
                            {
                                Scale9Image(image).textures = new Scale9Textures(Scale3Textures(texture).texture,new Rectangle(1,1,1,1));
                            }
                            else if (texture is Scale9Textures)
                            {
                                Scale9Image(image).textures = texture;
                            }
                            else if (texture is Texture)
                            {
                                Scale9Image(image).textures = new Scale9Textures(texture,new Rectangle(1,1,1,1));
                            }
                        }
                    }
                }
                
                delete valueMap[FieldConst.IMAGE_TEXTURE];
            }
            
            setDisplayObjectFields(image,valueMap);
            return image;
        }
        
        private static function setImageLoaderFields(imageLoader:ImageLoader,valueMap:Object):ImageLoader
        {
            if (FieldConst.IMAGE_LOADER_MAINTAIN_ASPECT_RATIO in valueMap)
            {
                imageLoader.maintainAspectRatio = valueMap[FieldConst.IMAGE_LOADER_MAINTAIN_ASPECT_RATIO];
                delete valueMap[FieldConst.IMAGE_LOADER_MAINTAIN_ASPECT_RATIO];
            }
            
            if (FieldConst.IMAGE_LOADER_SOURCE in valueMap)
            {
                imageLoader.source = valueMap[FieldConst.IMAGE_LOADER_SOURCE];
                delete valueMap[FieldConst.IMAGE_LOADER_SOURCE];
            }
            
            if (FieldConst.IMAGE_LOADER_ERROR_TEXTURE in valueMap)
            {
                var errorTexture:Texture = Assets.assets.getTexture(valueMap[FieldConst.IMAGE_LOADER_ERROR_TEXTURE]);
                if (errorTexture) imageLoader.errorTexture = errorTexture;
                delete valueMap[FieldConst.IMAGE_LOADER_ERROR_TEXTURE];
            }
            
            if (FieldConst.IMAGE_LOADER_LOADING_TEXTURE in valueMap)
            {
                var loadingTexture:Texture = Assets.assets.getTexture(valueMap[FieldConst.IMAGE_LOADER_ERROR_TEXTURE]);
                if(loadingTexture) imageLoader.loadingTexture = loadingTexture;
                delete valueMap[FieldConst.IMAGE_LOADER_LOADING_TEXTURE];
            }
            
            
            setDisplayObjectFields(imageLoader,valueMap);
            return imageLoader;
        }
        
        private static function setButtonFields(button:Button,valueMap:Object):Button
        {
            if (isEditor || building)
            {
                button.styleProvider = null;
                button.stateToSkinFunction = null;
                button.stateToLabelPropertiesFunction = null;
                button.stateToIconFunction = null;
            }
            
            if (FieldConst.FONT_COLOR in valueMap || 
                FieldConst.FONT_SIZE in valueMap ||
                FieldConst.FONT_NAME in valueMap ||
                FieldConst.FONT_WEIGHT in valueMap
            )
            {
                if (!button.defaultLabelProperties.elementFormat) 
                {
                    button.defaultLabelProperties.elementFormat = FontWorker.defaultElementFormat;
                }
                
                var fmt:Object = ObjectUtil.copy(button.defaultLabelProperties.elementFormat);
                var des:Object = fmt?ObjectUtil.copy(button.defaultLabelProperties.elementFormat.fontDescription):null;
                if(fmt) ObjectUtil.mapping(valueMap,fmt);
                if(des) ObjectUtil.mapping(valueMap,des);
                if(fmt) button.defaultLabelProperties.elementFormat = getElementFormat(getFontDescription(des), fmt);
                delete valueMap[FieldConst.FONT_COLOR];
                delete valueMap[FieldConst.FONT_SIZE];
                delete valueMap[FieldConst.FONT_NAME];
                delete valueMap[FieldConst.FONT_WEIGHT];
            }
            
            var image:DisplayObject;
            var isIcon:Boolean = false;
            if (FieldConst.BUTTON_DEFAULT_ICON in valueMap)
            {
                image = Assets.getImage(valueMap[FieldConst.BUTTON_DEFAULT_ICON]);
                button.defaultIcon = image;
                isIcon = true;
                delete valueMap[FieldConst.BUTTON_DEFAULT_ICON];
            }
            
            if (FieldConst.BUTTON_DEFAULT_SKIN in valueMap)
            {
                image = Assets.getImage(valueMap[FieldConst.BUTTON_DEFAULT_SKIN]);
                button.defaultSkin = image;
                delete valueMap[FieldConst.BUTTON_DEFAULT_SKIN];
            }
            
            if (FieldConst.BUTTON_DOWN_SKIN in valueMap)
            {
                image = Assets.getImage(valueMap[FieldConst.BUTTON_DOWN_SKIN]);
                button.downSkin = image;
                delete valueMap[FieldConst.BUTTON_DOWN_SKIN];
            }
            
            if (FieldConst.BUTTON_DISABLED_SKIN in valueMap)
            {
                image = Assets.getImage(valueMap[FieldConst.BUTTON_DISABLED_SKIN]);
                button.disabledSkin = image;
                delete valueMap[FieldConst.BUTTON_DISABLED_SKIN];
            }
            
            setDisplayObjectFields(button, valueMap);
            
            if (isEditor && building==false)
            {
                if (image)
                {
                    if (image.width > button.width)
                    {
                        button.width = image.width;
                    }
                    else if (image.height > button.height)
                    {
                        image.height = image.height;
                    }
                }
            }
            
            return button;
        }
        
        private static function setToggleButtonFields(toggleButton:ToggleButton,valueMap:Object):ToggleButton
        {
            setButtonFields(toggleButton, valueMap);
            
            if (FieldConst.TOGGLE_BUTTON_DEFAULT_SELECTED_ICON in valueMap)
            {
                toggleButton.defaultSelectedIcon = Assets.getImage(valueMap[FieldConst.TOGGLE_BUTTON_DEFAULT_SELECTED_ICON]);
                delete valueMap[FieldConst.TOGGLE_BUTTON_DEFAULT_SELECTED_ICON];
            }
            
            if (FieldConst.TOGGLE_BUTTON_DEFAULT_SELECTED_SKIN in valueMap)
            {
                toggleButton.defaultSelectedSkin = Assets.getImage(valueMap[FieldConst.TOGGLE_BUTTON_DEFAULT_SELECTED_SKIN]);
                delete valueMap[FieldConst.TOGGLE_BUTTON_DEFAULT_SELECTED_SKIN];
            }
            
            if (FieldConst.TOGGLE_BUTTON_IS_SELECTED in valueMap)
            {
                var boo:Boolean = (valueMap[FieldConst.TOGGLE_BUTTON_IS_SELECTED] == true) || valueMap[FieldConst.TOGGLE_BUTTON_IS_SELECTED] == "true";
                if (toggleButton.isSelected != boo)
                {
                    toggleButton.isSelected = boo;
                }
                
                delete valueMap[FieldConst.TOGGLE_BUTTON_IS_SELECTED];
            }
            
            return toggleButton;
        }
        
        private static function setLayoutGroupFields(layoutGroup:LayoutGroup,valueMap:Object):LayoutGroup
        {
            if (isEditor || building)
            {
                layoutGroup.styleProvider = null;
            }
            
            if (FieldConst.LAYOUT in valueMap ||
                FieldConst.LAYOUT_GAP in valueMap ||
                FieldConst.LAYOUT_PADDING in valueMap ||
                FieldConst.LAYOUT_PADDING_LEFT in valueMap ||
                FieldConst.LAYOUT_PADDING_RIGHT in valueMap ||
                FieldConst.LAYOUT_PADDING_TOP in valueMap ||
                FieldConst.LAYOUT_PADDING_BOTTOM in valueMap ||
                FieldConst.LAYOUT_HORIZONTAL_ALIGN in valueMap ||
                FieldConst.LAYOUT_VERTICAL_ALIGN in valueMap
            )
            {
                var layout:*=layoutGroup.layout;
                if (valueMap[FieldConst.LAYOUT] == FieldConst.LAYOUT_HORIZONTAL)
                {
                    layout = (layoutGroup.layout is HorizontalLayout)?layoutGroup.layout:new HorizontalLayout();
                }
                else if(valueMap[FieldConst.LAYOUT] == FieldConst.LAYOUT_VERTICAL)
                {
                    layout = (layoutGroup.layout is VerticalLayout)?layoutGroup.layout:new VerticalLayout();
                }
                
                if (layout)
                {
                    layoutGroup.layout = setLayoutFields(layout, valueMap);
                }
                
                delete valueMap[FieldConst.LAYOUT];
            }
            
            return layoutGroup;
        }
        
        private static function setLayoutFields(layout:*,valueMap:Object):ILayout
        {
            if (FieldConst.LAYOUT_GAP in valueMap)
            {
                layout.gap = valueMap[FieldConst.LAYOUT_GAP];
                delete valueMap[FieldConst.LAYOUT_GAP];
            }
            
            if (FieldConst.LAYOUT_PADDING in valueMap)
            {
                layout.padding = valueMap[FieldConst.LAYOUT_PADDING];
                delete valueMap[FieldConst.LAYOUT_PADDING];
            }
            
            if (FieldConst.LAYOUT_PADDING_LEFT in valueMap)
            {
                layout.paddingLeft = valueMap[FieldConst.LAYOUT_PADDING_LEFT];
                delete valueMap[FieldConst.LAYOUT_PADDING_LEFT];
            }
            
            if (FieldConst.LAYOUT_PADDING_RIGHT in valueMap)
            {
                layout.paddingRight = valueMap[FieldConst.LAYOUT_PADDING_RIGHT];
                delete valueMap[FieldConst.LAYOUT_PADDING_RIGHT];
            }
            
            if (FieldConst.LAYOUT_PADDING_TOP in valueMap)
            {
                layout.paddingTop = valueMap[FieldConst.LAYOUT_PADDING_TOP];
                delete valueMap[FieldConst.LAYOUT_PADDING_TOP];
            }
            
            if (FieldConst.LAYOUT_PADDING_BOTTOM in valueMap)
            {
                layout.paddingBottom = valueMap[FieldConst.LAYOUT_PADDING_BOTTOM];
                delete valueMap[FieldConst.LAYOUT_PADDING_BOTTOM];
            }
            
            if (FieldConst.LAYOUT_PADDING_BOTTOM in valueMap)
            {
                layout.paddingBottom = valueMap[FieldConst.LAYOUT_PADDING_BOTTOM];
                delete valueMap[FieldConst.LAYOUT_PADDING_BOTTOM];
            }
            
            if (FieldConst.LAYOUT_HORIZONTAL_ALIGN in valueMap)
            {
                layout.horizontalAlign = valueMap[FieldConst.LAYOUT_HORIZONTAL_ALIGN];
                delete valueMap[FieldConst.LAYOUT_HORIZONTAL_ALIGN];
            }
            
            if (FieldConst.LAYOUT_VERTICAL_ALIGN in valueMap)
            {
                layout.verticalAlign = valueMap[FieldConst.LAYOUT_VERTICAL_ALIGN];
                delete valueMap[FieldConst.LAYOUT_VERTICAL_ALIGN];
            }
            
            return layout as ILayout;
        }
    }
}