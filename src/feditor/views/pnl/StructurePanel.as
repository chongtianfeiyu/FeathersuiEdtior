package feditor.views.pnl 
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Panel;
	import feathers.controls.ScrollContainer;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feditor.events.EventType;
	import feditor.views.cmp.Tree;
	import starling.core.Starling;
	import starling.display.Sprite3D;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author gray
	 */
	public class StructurePanel extends Panel 
	{
		private var structureContainer:ScrollContainer;
		private var buttonGroup:ButtonGroup;
		private var tree:Tree;
		
		public function StructurePanel() 
		{
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			this.headerProperties.title = "View Structure";
			
			
			layout = new VerticalLayout();
			
			structureContainer = new ScrollContainer();
			addChild(structureContainer);
			
			tree = new Tree();
			structureContainer.addChild(tree);
			
			buttonGroup = new ButtonGroup();			
			buttonGroup.dataProvider = new ListCollection(["refresh", "close"]);
			buttonGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			addChild(buttonGroup);
			buttonGroup.addEventListener(Event.TRIGGERED, buttonGroupChangeHandler);
		}
		
		private function buttonGroupChangeHandler(e:Event):void 
		{
			if (e.data == "close")
			{
				hide();
			}
			else
			{
				dispatchEventWith(EventType.REFRESH);
			}
		}
		
		override protected function viewPort_resizeHandler(event:Event):void 
		{
			super.viewPort_resizeHandler(event);
			
			var w:int = width - paddingLeft - paddingRight;
			var h:int = height - paddingBottom - paddingTop -50;			
			
			structureContainer.width = w;
			structureContainer.height = h;
			buttonGroup.width = w;
			buttonGroup.gap = 0;
		}
		
		private function closeHandler(e:Event):void 
		{
			hide();
		}
		
		public function show(xml:*):void
		{
			if (PopUpManager.isPopUp(this)==false)
			{
				PopUpManager.addPopUp(this, false, false);
				this.paddingLeft = 0;
				this.paddingRight = 0;
				this.padding = 0;
			}
			
			tree.dispose();
			tree.createTree(xml);
		}
		
		public function hide():void
		{
			if (PopUpManager.isPopUp(this))
			{
				PopUpManager.removePopUp(this);
			}
			
			tree.dispose();
		}
	}

}