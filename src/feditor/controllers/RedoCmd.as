package feditor.controllers 
{
	import feditor.models.ClipBordProxy;
	import feditor.models.SelectElementsProxy;
	import feditor.models.SnapshotProxy;
	import feditor.utils.Builder;
	import feditor.views.EdiatorStageMediator;
	import feditor.views.pnl.EditorStage;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	/**
	 * ...
	 * @author gray
	 */
	public class RedoCmd extends SimpleCommand 
	{
		
		public function RedoCmd() 
		{
			super();
		}
		
		override public function execute(notification:INotification):void 
		{
			var xml:* = snapshotProxy.getRedoSnaphot();
			if (xml)
			{
				clipBordProxy.clearAll();
				selectProxy.clear();
				estage.childContainer.removeChildren();
				Builder.build(estage.childContainer, xml);
			}
		}
		
		private function get snapshotProxy():SnapshotProxy
		{
			return facade.retrieveProxy(SnapshotProxy.NAME) as SnapshotProxy;
		}
		
		private function get estage():EditorStage
		{
			return (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
		}
		
		private function get selectProxy():SelectElementsProxy
		{
			return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
		}
		
		private function get clipBordProxy():ClipBordProxy
		{
			return facade.retrieveProxy(ClipBordProxy.NAME) as ClipBordProxy;
		}
	}

}