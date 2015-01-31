package feditor.views.cmp 
{
	import feathers.controls.Check;
	import feathers.controls.LayoutGroup;
	import feathers.layout.VerticalLayout;
	import feditor.utils.parseString;
	import feditor.vo.TreeNodeVO;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author gray
	 */
	public class Tree extends LayoutGroup 
	{
		public static const LEFT:int = 20;
		public static const GAP:int = 0;
		
		private var nodes:Array;
		
		public function Tree() 
		{
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			layout = new VerticalLayout();
			VerticalLayout(layout).paddingLeft = LEFT;
			VerticalLayout(layout).gap = GAP;			
			nodes = [];
		}
		
		override public function dispose():void 
		{
			nodes.length = 0;
			for (var i:int = 0; i < numChildren; i++) 
			{
				getChildAt(i).dispose();
			}
			removeChildren();
		}
		
		public function createTree(node:*):void
		{
			if (!node) return;		
			
			for each (var item:* in node.children()) 
			{
				var check:Check = new Check();
				check.label = item.name() +"   " + (parseString(item.@name)?"name=" + String(item.@name):"");
				check.isSelected = parseString(item.@visible) == false;
				addChild(check);
				
				
				var nodeVO:TreeNodeVO = new TreeNodeVO();
				nodeVO.handler = check;
				nodeVO.xml = item;
				nodes.push(nodeVO);
				
				check.addEventListener(Event.CHANGE,changeHandler);
				
				if (item.children().length()>0)
				{
					var childTree:Tree = new Tree();
					addChild(childTree);
					childTree.createTree(item);
				}
			}
		}
		
		private function changeHandler(e:Event):void 
		{
			var i:int = 0;
			for each (var item:TreeNodeVO in nodes) 
			{
				if (item.handler == e.currentTarget)
				{
					item.path ||= [];
					item.path.length = 0;
					item.path.unshift(i);
					
					var pNode:Tree = parent as Tree;
					var self:Tree = this;
					var nodePlace:int = 1;
					
					while (pNode)
					{
						item.path.unshift(pNode.getChildIndex(self)-nodePlace);
						self = pNode;
						pNode = pNode.parent as Tree;
					}
					
					item.isSelected = Check(e.currentTarget).isSelected;
					dispatchEventWith(Event.CHANGE, true, item);
				}
				
				i++;
			}
		}
	}

}