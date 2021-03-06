package feditor.views 
{
	import feditor.events.EventType;
	import feditor.NS;
	import feditor.Root;
	import feditor.utils.describeView;
	import feditor.utils.Reflect;
	import feditor.views.pnl.EditorStage;
	import feditor.views.pnl.StructurePanel;
	import feditor.vo.TreeNodeVO;
	import flash.utils.getQualifiedClassName;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	

	
	/**
	 * ...
	 * @author gray
	 */
	public class StructurePnlMediator extends Mediator 
	{
		public static const NAME:String = "StructurePnlMediator";
		public function StructurePnlMediator(viewComponent:Object=null) 
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void 
		{
			super.onRegister();
			pnl.addEventListener(EventType.REFRESH, refreshHandler);
			pnl.addEventListener(Event.CHANGE,changeHandler);
		}
		
		private function changeHandler(e:Event):void 
		{
			var nodeVO:TreeNodeVO = e.data as TreeNodeVO;
			var path:Array = nodeVO.path;
			var target:DisplayObject;
			var pNode:DisplayObjectContainer = editorRoot;
			for each (var id:int in path) 
			{
				if (pNode==null || pNode.numChildren <= id) return;				
				target = pNode.getChildAt(id);
				pNode = target as DisplayObjectContainer;
			}
			
			if (target)
			{
				target.visible = !nodeVO.isSelected;
			}
		}
		
		private function refreshHandler(e:Event):void 
		{
			pnl.show(describeView2(editorRoot));
		}
		
		override public function listNotificationInterests():Array 
		{
			return [
				NS.NOTE_STRUCTURE_SHOW,
				NS.NOTE_STRUCTURE_HIDE
			];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch (notification.getName()) 
			{
				case NS.NOTE_STRUCTURE_SHOW:					
					pnl.show(describeView2(editorRoot));
					break;
				case NS.NOTE_STRUCTURE_HIDE:
					pnl.hide();
				break;
				default:
			}
		}
		
		private function describeView2(view:DisplayObjectContainer):XML 
		{	
			var xml:XML = <View/>;
			
			for (var i:int = 0; i < view.numChildren; i++) 
			{
				var child:DisplayObject = view.getChildAt(i);
				var childXml:XML = new XML("<"+getQualifiedClassName(child).split("::")[1]+"/>");
				var properties:Object = Reflect.getFieldMap(child);
				for(var field:String in properties)
				{
					childXml.@[field] = properties[field];
				}
				
				xml.appendChild(childXml);
			}
			
			return xml;
		}
		
		public function get pnl():StructurePanel
		{
			return viewComponent as StructurePanel;
		}
		
		private function get editorRoot():DisplayObjectContainer
        {
            var editor:EditorStage = (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
            return editor.childContainer; 
        }
		
		private function get rootPnl():Root
        {
            return (facade.retrieveMediator(RootMediator.NAME) as RootMediator).pnl;
        }
	}
}