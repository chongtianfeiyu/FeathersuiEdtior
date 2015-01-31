package feditor.utils 
{
    import feathers.controls.LayoutGroup;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
    
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
			xml.@[field] = properties[field];
        }
        
        if (nodeName == "LayoutGroup" || nodeName == "Sprite")
        {
            for (var i:int = 0; i < Sprite(view).numChildren; i++) 
            {
                var childXML:XML = describeView(Sprite(view).getChildAt(i));
                if(childXML) xml.appendChild(childXML);
            }
        }
        
        return xml;
    }
}