package feditor.controllers 
{
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ToggleButton;
    import feditor.models.EStageProxy;
    import feditor.models.ProjectProxy;
    import feditor.utils.Builder;
    import feditor.utils.describeView;
	import feditor.utils.parseString;
    import feditor.utils.Reflect;
    import feditor.views.EdiatorStageMediator;
    import feditor.views.pnl.EditorStage;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObjectContainer;
	import starling.display.Image;
    
    /**
     * ...
     * @author gray
     */
    public class ExprotXMLCmd extends SimpleCommand 
    {
        
        public function ExprotXMLCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {    
            var xml:XML = describeView(editorRoot);
            delete xml.@* ;
            
            
            if (!projectProxy.projectName)
            {
                projectProxy.projectName = String(new Date().time);
            }
            
            xml.setName(Builder.XMLROOT);
            xml.@stageWidth = estageProxy.witdth;
            xml.@stageHeight = estageProxy.height;
            xml.@stageColor = "0x" + estageProxy.color.toString(16);
			
			//xml filter
			xmlFilter(xml);
			
			xml.normalize();
            
            var fileRef:FileReference = new FileReference();
			fileRef.addEventListener(Event.SELECT, function(e:*):void {
				fileRef.removeEventListener(Event.OPEN, arguments.callee);
				projectProxy.projectName = (fileRef.name || projectProxy.projectName).split(".")[0];
			} );
			fileRef.save(xml, (projectProxy.projectName) + ".xml");
        }
		
		private function xmlFilter(xml:*):void
		{	
			for each (var attr:* in xml.attributes()) 
			{
				var attrName:String = String(attr.name());
				var attrValue:* = parseString(String(attr));
				var isDelete:Boolean = false;
				
				switch (attrName) 
				{
					case "x":
					case "y":
					case "pivotX":
					case "pivotY":
					case "iconOffsetX":
					case "iconOffsetY":
					case "labelOffsetX":
					case "labelOffsetY":
					case "padding":
					case "paddingLeft":
					case "paddingRight":
					case "paddingTop":
					case "paddingBottom":
					case "rotation":
					case "gap":
						isDelete = (attrValue == 0);
						break;
					case "alpha":
					case "scaleX":
					case "scaleY":
						isDelete = (attrValue == 1);
						break;
					case "visible":
					case "touchable":
					case "isEnabled":
					case "hasLabelTextRenderer":
						isDelete = (attrValue == true);
						break;
					case "touchGroup":
					case "wordWrap":
						isDelete = (attrValue == false);
						break;
					case "texture":
						isDelete = (attrValue == "" || attrValue == null || attrValue == undefined);
						break;
					case "name":
					case "label":
					case "text":
					case "script":
						isDelete = (attrValue == "" || attrValue == null || attrValue == undefined);
						break;
					case "minWidth":
					case "minHeight":
						isDelete = (attrValue == 0);
						break;
					case "maxWidth":
					case "maxHeight":
						isDelete = (attrValue == Infinity);
						break;
					default:
				}
				
				if ((/Skin$/.test(attrName) || /Icon$/.test(attrName)) && 
					(attrValue == "" || attrValue==null || attrValue == undefined))
				{
					isDelete = true;
				}
				
				if (isDelete)
				{
					delete xml.@[attrName];
				}
			}
			
			for each (var child:* in xml.children()) 
			{
				xmlFilter(child);
			}
		}
        
        private function get editorRoot():DisplayObjectContainer
        {
            var editor:EditorStage = (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
            return editor.childContainer; 
        }
        
        private function get projectProxy():ProjectProxy
        {
            return facade.retrieveProxy(ProjectProxy.NAME) as ProjectProxy;
        }
        
        private function get estageProxy():EStageProxy
        {
            return facade.retrieveProxy(EStageProxy.NAME) as EStageProxy;
        }
    }

}