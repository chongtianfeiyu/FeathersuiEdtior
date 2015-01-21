package feditor.utils 
{
    import feathers.controls.LayoutGroup;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    
    public function describeView(view:DisplayObject):XML 
    {
        if (view == null) return null;
        var nodeName:String = getQualifiedClassName(view).split("::")[1];
        if (!nodeName) return null;
        
        var xml:XML = new XML("<"+nodeName+"/>");
        
        var properties:Object = Reflect.getFieldMap(view);
        for(var field:String in properties)
        {
            var value:* = properties[field];
            
            var validate:Boolean = false;
            switch (field) 
            {
                case "x":
                case "y":
                case "iconOffsetX":
                case "iconOffsetY":
                case "labelOffsetX":
                case "labelOffsetX":
                    validate = parseFloat(value) != 0;
                    break;
                case "alpha":
                    validate = parseFloat(value) != 1;
                    break;
                case "touchable":
                case "visible":
                    validate = (value==false) && value != "true";
                    break;
                case "isSelected":
                    validate = (value == true) && value != "false";
                    break;
                case "name":
                case "texture":
                case "label":
                case "text":
                case "defaultIcon":
                case "defaultSkin":
                case "downSkin":
                case "disabledSkin":
                case "backgroundSkin":
                    validate = Boolean(value);
                    break;
                case "maxWidth":
                case "maxHeight":
                case "minWidth":
                case "minHeight":
                    validate = (value !=Infinity) && Number(value)>0;//
                    break;
                default:
                    validate = true;
            }
            
            if (validate)
            {
                xml.@[field] = value;
            }
        }
        
        if (view is LayoutGroup)
        {
            for (var i:int = 0; i < LayoutGroup(view).numChildren; i++) 
            {
                var childXML:XML = describeView(LayoutGroup(view).getChildAt(i));
                if(childXML) xml.appendChild(childXML);
            }
        }
        
        return xml;
    }
}