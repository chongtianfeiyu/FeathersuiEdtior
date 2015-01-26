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
			var file:File = File.applicationDirectory.resolvePath(DefaultControlProxy.CONFIG);
			if (file.exists)
			{
				for each (var item:File in file.getDirectoryListing()) 
				{
					AppFacade(facade).assets.removeXml(item.name.replace(".xml",""));
				}
				
				AppFacade(facade).assets.enqueue(file);
				AppFacade(facade).assets.loadQueue(
					function(ratio:Number):void {
						if (ratio == 1){
							defaultControlProxy.updateXML();
							sendNotification(NS.NOTE_CONTROL_LIBRARY_UPDATE);
					}
				});
			}
		}
		
		private function get defaultControlProxy():DefaultControlProxy
		{
			return facade.retrieveProxy(DefaultControlProxy.NAME) as DefaultControlProxy;
		}
		
	}

}