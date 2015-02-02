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
		private var tree:Tree;
		private var refreshBtn:Button;
		private var container:ScrollContainer;
		private var buttonGroup:ButtonGroup;
		
		public function StructurePanel() 
		{
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			this.headerProperties.title = "View Structure";
			
			
			layout = new VerticalLayout();		
			
			buttonGroup = new ButtonGroup();
			buttonGroup.direction = ButtonGroup.DIRECTION_HORIZONTAL;
			buttonGroup.dataProvider = new ListCollection(["refresh", "select all", "unselect all"]);
			buttonGroup.buttonProperties.styleName = Button.ALTERNATE_NAME_QUIET_BUTTON;
			buttonGroup.width = 260;
			addChild(buttonGroup);
			buttonGroup.addEventListener(Event.TRIGGERED, buttonGroupChangeHandler);
			
			container = new ScrollContainer();
			addChild(container);
			tree = new Tree();
			container.addChild(tree);
		}
		
		private function buttonGroupChangeHandler(e:Event):void 
		{	
			switch (e.data) 
			{
				case "refresh":
					dispatchEventWith(EventType.REFRESH);
					break;
				case "select all":
					tree.selectAll();
					break;
				case "unselect all":
					tree.unselectAll();
					break;
				default:
			}
		}
		
		override public function get height():Number 
		{
			return super.height;
		}
		
		override public function set height(value:Number):void 
		{
			super.height = value;
			container.height = value - paddingBottom - paddingTop - 50;
		}
		
		private function closeHandler(e:Event):void 
		{
			hide();
		}
		
		public function show(xml:*):void
		{
			tree.dispose();
			tree.createTree(xml);
		}
		
		public function hide():void
		{
			tree.dispose();
		}
	}

}