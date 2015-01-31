package feditor.controllers 
{
	import feditor.utils.describeView;
	import feditor.views.EdiatorStageMediator;
	import feditor.views.pnl.EditorStage;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import starling.display.DisplayObjectContainer;
	import starling.utils.formatString;
	
	/**
	 * ...
	 * @author gray
	 */
	public class ExportAsCodeCmd extends SimpleCommand 
	{
		
		public function ExportAsCodeCmd() 
		{
			super();
		}
		
		override public function execute(notification:INotification):void 
		{
			var xml:* = describeView(editorRoot);
			var code:String = ceateCode(xml);
			if (code)
			{
				var file:File = new File();
				file.save(code,"code.as");
			}
		}
		
		private function ceateCode(xml:*):String
		{
			var result:String = "";
			if (String(xml.@name))
			{
				result += formatString("public var {0}:{1};\n", String(xml.@name), String(xml.name()));
			}
			
			for each (var item:* in xml.children()) 
			{
				result += ceateCode(item);
			}
			
			return result;
		}
		
		private function get editorRoot():DisplayObjectContainer
        {
            var editor:EditorStage = (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
            return editor.childContainer; 
        }
		
	}

}