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
	import feathers.core.FeathersControl;
    import feathers.data.ListCollection;
    import feathers.display.Scale3Image;
    import feathers.display.Scale9Image;
    import feathers.display.TiledImage;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.ILayout;
    import feathers.layout.VerticalLayout;
    import feathers.skins.StyleNameFunctionStyleProvider;
    import feathers.text.StageTextField;
    import feathers.textures.Scale3Textures;
    import feathers.textures.Scale9Textures;
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
        public static const INJECT_FLAG:String = "name";
        public static const SCRIPT_FLAG:String = "script";
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
            fieldsMethod[List] = setListFields;
            Builder.isEditor = isEditor;
        }
        
        public static function getSurportClass(className:String):Class
        {
            return surportClassPool[className] as Class;
        }
        
        public static function build(container:DisplayObjectContainer, xml:*,scriptOwner:Object=null):DisplayObject
        {
            building = true;
            var result:* = createView(container, xml, container,scriptOwner);
            building = false;            
            return result;
        }
        
        private static function createView(container:DisplayObjectContainer, xml:*,root:DisplayObjectContainer,scriptOwner:Object):DisplayObject
        {
            var son:*;
            
            //self ns
            if (xml.name() != XMLROOT)
            {
                var def:Class = getSurportClass(String(xml.name()));
                var properties:Object = { };
                
                var inject:String;
				var sciptParser:ScriptParser;
                //self attributes
                for each (var attr:XML in xml.attributes()) 
                {
                    var fieldName:String = String(attr.name());
                    
                    switch (fieldName) 
                    {
                        case INJECT_FLAG:
                            inject = String(attr);
                            properties[fieldName] = parseString(String(attr));
                            break;
                        case SCRIPT_FLAG:
                            if (scriptOwner) sciptParser = ScriptParser.parse(String(attr));
                            break;
                        default:
							properties[fieldName] = parseString(String(attr));
                    }
                }
                son = createInstance(def, properties);
				
				//execute script
				if (sciptParser)
				{
					sciptParser.execute(scriptOwner,son);
				}
				
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
                DisplayObjectContainer(son).addChild(createView(son,grandson,root,scriptOwner));
            }
            return son;
        }
        
        public static function createInstance(def:Class,args:Object):*
        {   
            var result:*;
            switch (def) 
            {
                case Image:
					if (args[FieldConst.IMAGE_TEXTURE] == FieldConst.EMPTY)
					{
						result = new Image(Texture.fromColor(args["width"], args["height"], isEditor?0x1fff0000:0));
						delete args['width'];
						delete args['height'];
						delete args['scaleX'];
						delete args['scaleY'];
						//result = Assets.getImage(args[FieldConst.IMAGE_TEXTURE]);
					}
					else
					{
						result = Assets.getImage(args[FieldConst.IMAGE_TEXTURE]);
					}
                    delete args[FieldConst.IMAGE_TEXTURE];
					break;
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
            
			if (isEditor && def == Label)
			{
                if (args["maxWidth"] && args["maxWidth"] != Infinity)
                {
                    args["width"] = args["maxWidth"];
                }
                
                if(args["maxHeight"] && args["maxHeight"] != Infinity)
                {
                    args["height"] = args["maxHeight"];
                }
			}
			
			if (def == Label)
			{
				Label(result).styleProvider = null;				
				setTxtRenderDefaultProperties(Label(result).textRendererProperties,FontWorker.textRenderDef);
			}
			else if (def == TextInput)
			{
				TextInput(result).styleProvider = null;
				setTxtRenderDefaultProperties(TextInput(result).textEditorProperties, FontWorker.textEditorDef);
				
				TextInput(result).promptProperties.elementFormat = FontWorker.defaultElementFormat;
				setTxtRenderDefaultProperties(TextInput(result).promptProperties, FontWorker.textRenderDef);
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
                properties.color
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
				if (progressBar.backgroundSkin)
				{
					progressBar.width = progressBar.backgroundSkin.width;
					progressBar.height = progressBar.backgroundSkin.height;
				}
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
			setTxtFields(label.textRendererProperties,valueMap,FontWorker.textRenderDef);
            setDisplayObjectFields(label, valueMap);
			if (FieldConst.WORD_WRAP in valueMap)
			{
				label.wordWrap = valueMap[FieldConst.WORD_WRAP];
				delete valueMap[FieldConst.WORD_WRAP];
			}
            return label;
        }
        
        private static function setTextInputFields(textInput:TextInput,valueMap:Object):TextInput
        {   
            if (FieldConst.FONT_COLOR in valueMap || 
                FieldConst.FONT_SIZE in valueMap ||
                FieldConst.FONT_NAME in valueMap ||
                FieldConst.FONT_WEIGHT in valueMap
            )
            {
				setTxtFields(textInput.textEditorProperties, valueMap,FontWorker.textEditorDef);
				setTxtFields(textInput.promptProperties, valueMap, FontWorker.textRenderDef);
                delete valueMap[FieldConst.FONT_COLOR];
                delete valueMap[FieldConst.FONT_SIZE];
                delete valueMap[FieldConst.FONT_NAME];
                delete valueMap[FieldConst.FONT_WEIGHT];
            }
            
            if (FieldConst.TEXT_INPUT_PROMPT_COLOR in valueMap)
            {
				var valueMapForPromp:Object = { };
				valueMapForPromp[FieldConst.FONT_COLOR] = valueMap[FieldConst.TEXT_INPUT_PROMPT_COLOR];
				setTxtFields(textInput.promptProperties, valueMapForPromp,FontWorker.textRenderDef);				
                delete valueMap[FieldConst.TEXT_INPUT_PROMPT_COLOR];
            }
			
			//
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
		
		private static function buildElementFormat(elementFormat:ElementFormat,valueMap:Object):ElementFormat
		{
			elementFormat ||= FontWorker.defaultElementFormat;			
			var fmt:Object = ObjectUtil.copy(elementFormat);
			var des:Object = ObjectUtil.copy(elementFormat.fontDescription);
			ObjectUtil.mapping(valueMap, fmt);
			ObjectUtil.mapping(valueMap,des);
			return getElementFormat(getFontDescription(des), fmt);
		}
		
		private static function setTxtRenderDefaultProperties(propertiesHandler:*,type:Class):void
		{
			if (type == TextBlockTextEditor || type == TextBlockTextRenderer)
			{
				propertiesHandler.elementFormat = FontWorker.defaultElementFormat;
			}
			else if (type == TextFieldTextRenderer || TextFieldTextEditor)
			{
				propertiesHandler.textFormat = FontWorker.defaultTextFormat;
			}
			else if (type == StageTextField || type == StageTextTextEditor)
			{
				propertiesHandler.fontFamily = FontWorker.defaultTextFormat.font;
				propertiesHandler.fontSize = FontWorker.defaultTextFormat.size;
				propertiesHandler.fontWeight = FontWorker.defaultTextFormat.bold?"bold":"normal";
			}
		}
        
        private static function setTxtFields(textProperties:*,valueMap:Object,type:Class):*
        {
            if (type == StageTextTextEditor || type == StageTextField)
            {
                if (FieldConst.FONT_COLOR in valueMap) textProperties.color = valueMap[FieldConst.FONT_COLOR];
                if (FieldConst.FONT_NAME in valueMap) textProperties.fontFamily = valueMap[FieldConst.FONT_NAME];
                if (FieldConst.FONT_SIZE in valueMap) textProperties.fontSize = valueMap[FieldConst.FONT_SIZE];
                if (FieldConst.FONT_WEIGHT in valueMap) textProperties.fontWeight = valueMap[FieldConst.FONT_WEIGHT];
            }
            else if(type == TextBlockTextEditor || type == TextBlockTextRenderer)
            {
				var elment:Object = ObjectUtil.copy(textProperties.elementFormat);
                var des:Object = elment?ObjectUtil.copy(textProperties.elementFormat.fontDescription):null;
                if (elment) ObjectUtil.mapping(valueMap, elment);
                if (des) ObjectUtil.mapping(valueMap,des);
                if (elment) textProperties.elementFormat = getElementFormat(getFontDescription(des), elment);
				
            }
            else if (type == TextFieldTextEditor || type == TextFieldTextRenderer)
            {
                var fmt:TextFormat = textProperties.textFormat;
                if (FieldConst.FONT_WEIGHT in valueMap) fmt.bold = valueMap[FieldConst.FONT_WEIGHT] == FieldConst.FONT_BOLD;
                if (FieldConst.FONT_NAME in valueMap) fmt.font = valueMap[FieldConst.FONT_NAME];
                if (FieldConst.FONT_SIZE in valueMap) fmt.size = valueMap[FieldConst.FONT_SIZE];
                if (FieldConst.FONT_COLOR in valueMap) fmt.color = valueMap[FieldConst.FONT_COLOR];
                textProperties.textFormat = fmt;
            }
            
            delete valueMap[FieldConst.FONT_WEIGHT];
            delete valueMap[FieldConst.FONT_SIZE];
            delete valueMap[FieldConst.FONT_NAME];
            delete valueMap[FieldConst.FONT_COLOR];
            
            return textProperties;
        }
        
        private static function setDisplayObjectFields(display:DisplayObject,valueMap:Object):DisplayObject
        {	
            for (var name:String in valueMap) 
            {
                try 
                {
					display[name] = valueMap[name];
                }
                catch (err:Error)
                {
                    trace("Builder.setDisplayObjectFields ::Set Fields Error - " + name);
                }
            }
			
			if (valueMap)
			{
				try 
				{
					if ("scaleX" in valueMap["scaleX"] && valueMap["scaleX"] < 0)
					{
						display.scaleX = valueMap.scaleX;
					}
					
					if ("scaleY" in valueMap["scaleY"]  && valueMap["scaleY"] < 0)
					{
						display.scaleY = valueMap.scaleY;
					}
				}
				catch (err:Error)
				{
					trace("scalex scaley set error");
				}
				
				if (isEditor && FieldConst.SCRIPT in valueMap && display as FeathersControl)
				{
					FeathersControl(display).styleName = valueMap[FieldConst.SCRIPT];
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
                    
					if (image.height > button.height)
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
            
            setDisplayObjectFields(layoutGroup, valueMap);
            
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
        
        private static function setListFields(list:List,valueMap:Object):List
        {
            if ((isEditor || building))// && list.itemRendererProperties.name != valueMap[FieldConst.LIST_ITEM_RENDERER]
            {
                list.styleProvider = null;
            }
            
            if (FieldConst.LIST_ITEM_RENDERER in valueMap)
            {
                list.itemRendererFactory = ItemRendererBuilder.getItemRendererFactory(valueMap[FieldConst.LIST_ITEM_RENDERER]);
                list.itemRendererProperties.name = valueMap[FieldConst.LIST_ITEM_RENDERER];
                delete valueMap[FieldConst.LIST_ITEM_RENDERER];
            }
            
            if (isEditor)
            {
                var arr:Array = [];
                for (var i:int = 0; i < (valueMap[FieldConst.LIST_DATA_NUM]||3); i++) 
                {
                    //this is very import
                    arr.push({"label":String(i)+"?????"});
                }
                list.dataProvider = new ListCollection(arr);
                delete valueMap[FieldConst.LIST_DATA_NUM];
            }
            
            if (FieldConst.LIST_BACKGROUND_SKIN in valueMap)
            {
                list.backgroundSkin = Assets.getImage(valueMap[FieldConst.LIST_BACKGROUND_SKIN]);
                delete valueMap[FieldConst.LIST_BACKGROUND_SKIN];
            }
            
            if (FieldConst.LAYOUT_PADDING in valueMap)
            {
                list.padding = valueMap[FieldConst.LAYOUT_PADDING];
                delete valueMap[FieldConst.LAYOUT_PADDING];
            }
            
            if (FieldConst.LAYOUT_PADDING_LEFT in valueMap)
            {
                list.paddingLeft = valueMap[FieldConst.LAYOUT_PADDING_LEFT];
                delete valueMap[FieldConst.LAYOUT_PADDING_LEFT];
            }
            
            if (FieldConst.LAYOUT_PADDING_RIGHT in valueMap)
            {
                list.paddingRight = valueMap[FieldConst.LAYOUT_PADDING_RIGHT];
                delete valueMap[FieldConst.LAYOUT_PADDING_RIGHT];
            }
            
            if (FieldConst.LAYOUT_PADDING_TOP in valueMap)
            {
                list.paddingTop = valueMap[FieldConst.LAYOUT_PADDING_TOP];
                delete valueMap[FieldConst.LAYOUT_PADDING_TOP];
            }
            
            if (FieldConst.LAYOUT_PADDING_BOTTOM in valueMap)
            {
                list.paddingBottom = valueMap[FieldConst.LAYOUT_PADDING_BOTTOM];
                delete valueMap[FieldConst.LAYOUT_PADDING_BOTTOM];
            }
            
            if (FieldConst.LAYOUT in valueMap)
            {
                var layout:*= list.layout;
                if (valueMap[FieldConst.LAYOUT] == FieldConst.LAYOUT_HORIZONTAL)
                {
                    layout = (list.layout is HorizontalLayout)?list.layout:new HorizontalLayout();
                }
                else
                {
                    layout = (list.layout is VerticalLayout)?list.layout:new VerticalLayout();
                }
                
                list.layout = layout;
                delete valueMap[FieldConst.LAYOUT];
            }
            
            if (FieldConst.LAYOUT_GAP in valueMap ||
                FieldConst.LAYOUT_HORIZONTAL_ALIGN in valueMap ||
                FieldConst.LAYOUT_VERTICAL_ALIGN in valueMap
            )
            {
                list.layout = setLayoutFields(list.layout||new VerticalLayout(), valueMap);
            }
            
            setDisplayObjectFields(list, valueMap);
            
            return list;
        }
    }
}