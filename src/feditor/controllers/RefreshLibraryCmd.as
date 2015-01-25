package feditor.controllers 
{
	import feditor.AppFacade;
	import feditor.models.DefaultControlProxy;
	import feditor.NS;
	import flash.events.Event;
	import flash.filesystem.File;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author gray
	 */
	public class RefreshLibraryCmd extends SimpleCommand 
	{
		
		public function RefreshLibraryCmd() 
		{
			super();
		}
		
		override public function execute(notification:INotification):void 
		{
			var file:File = File.applicationDirectory.resolvePath("config/" + DefaultControlProxy.CONFIG + ".xml");
			if (file.exists)
			{
				file.load();
				file.addEventListener(Event.COMPLETE, fileLoadCompleteHandler);
			}
		}
		
		private function fileLoadCompleteHandler(e:Event):void 
		{
			var file:File = e.currentTarget as File;
			var xml:XML = new XML(file.data);
			if (xml)
			{
				defaultControlProxy.updateXML();
				AppFacade(facade).assets.addXml(DefaultControlProxy.CONFIG, xml);
				sendNotification(NS.NOTE_CONTROL_LIBRARY_UPDATE);
			}
		}
		
		private function get defaultControlProxy():DefaultControlProxy
		{
			return facade.retrieveProxy(DefaultControlProxy.NAME) as DefaultControlProxy;
		}
		
	}

}