package feditor.views.pnl 
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.Panel;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import feditor.AppFacade;
	import feditor.events.EventType;
	import feditor.views.cmp.AssetListItemRenderer;
	import feditor.views.cmp.ControlListItenRenderer;
	import flash.events.MouseEvent;
	import flash.system.System;
	import starling.core.Starling;
	import starling.events.Event;
    
    /**
     * ...
     * @author gray
     */
    public class CmpPanel extends LayoutGroup 
    {
        public var cmpList:List;
        public var tabBar:TabBar;
        public var assetsList:List;
		
		private var assetName:Object;
        private var box:ScrollContainer;
		private var header:Header;
        
        public function CmpPanel() 
        {
            super();
        }
        
        override protected function initialize():void 
        {
            super.initialize();
			
            var boxLayout:VerticalLayout = new VerticalLayout();
            layout = boxLayout;
			
			header = new Header();
			header.title = "Library";
			addChild(header);
            
            tabBar = new TabBar();
            tabBar.dataProvider = new ListCollection([ { "label":"Controls" }, { "label":"Assets" } ]);
            addChild(tabBar);
            
            box = new ScrollContainer();
            addChild(box);
            
            cmpList = new List();
            cmpList.itemRendererFactory = function():*{ return new ControlListItenRenderer() };
            cmpList.itemRendererProperties.minHeight = 30;
            box.addChild(cmpList);
            
            var textureNames:* = AppFacade.getInstance().assets.getTextureNames();
            assetsList = new List();
            assetsList.itemRendererFactory = function():*{ return new AssetListItemRenderer()};
            assetsList.dataProvider = new ListCollection(textureNames);
            box.addChild(assetsList);
            assetsList.visible = false;
            
            //evts
			assetsList.addEventListener(EventType.PREVIEW,previewHandler);
            tabBar.addEventListener(Event.CHANGE, tabChangeHandler);
			Starling.current.nativeStage.addEventListener(MouseEvent.CLICK, nativeStageClickHandler);
        }
		
		private function previewHandler(e:Event):void 
		{
			assetName = String((e.data as Array || [])[0]);
		}
		
		private function nativeStageClickHandler(e:MouseEvent):void 
		{
			if (assetsList.visible && 
				e.stageX > assetsList.x &&
				e.stageX < assetsList.x + assetsList.width && 
				e.stageY > assetsList.y &&
				e.stageY < assetsList.y + assetsList.height
				)
			{
				System.setClipboard(String(assetName));
			}
		}
		
		override public function validate():void 
		{
			super.validate();
			header.width = width;
			cmpList.height = height - tabBar.height - header.height;
			assetsList.height = height - tabBar.height - header.height;
			cmpList.width = width;
			assetsList.width = width;
			
		}
		
        private function tabChangeHandler(e:Event):void 
        {
            switch(tabBar.selectedIndex)
            {
                case 0:
                    cmpList.visible = true;
                    cmpList.selectedItem = null;
                    assetsList.visible = false;
                    break;
                case 1:
                    cmpList.visible = false;
                    assetsList.visible = true;
                    break;
                default:
            }
        }
    }

}