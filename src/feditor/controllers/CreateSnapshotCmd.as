package feditor.controllers 
{
	import feditor.models.SnapshotProxy;
	import feditor.utils.Builder;
	import feditor.utils.describeView;
	import feditor.views.EdiatorStageMediator;
	import feditor.views.pnl.EditorStage;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author gray
	 */
	public class CreateSnapshotCmd extends SimpleCommand 
	{
		
		public function CreateSnapshotCmd() 
		{
			super();
		}
		
		override public function execute(notification:INotification):void 
		{
			var xml:XML = describeView(estage.childContainer);
			delete xml.@ * ;
			xml.setName(Builder.XMLROOT);
			snapshotProxy.storeSnapshot(xml);
		}
		
		private function get snapshotProxy():SnapshotProxy
		{
			return facade.retrieveProxy(SnapshotProxy.NAME) as SnapshotProxy;
		}
		
		private function get estage():EditorStage
		{
			return (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
		}
	}

}