package feditor.views.pnl 
{
    import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.ScrollContainer;
    import feathers.controls.TabBar;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;
    import feditor.AppFacade;
	import feditor.events.EventType;
	import feditor.views.cmp.AssetListItemRenderer;
	import feditor.views.cmp.ControlListItenRenderer;
    import flash.events.MouseEvent;
    import starling.core.Starling;
    import starling.events.Event;
    import starling.events.TouchEvent;
    import flash.system.System;
    
    /**
     * ...
     * @author gray
     */
    public class CmpPanel extends LayoutGroup 
    {
        public var cmpList:List;
        public var tabBar:TabBar;
        public var assetsList:List;
        
        
        private var handle:Button;
        private var box:ScrollContainer;
        
        public function CmpPanel() 
        {
            super();
        }
        
        override protected function initialize():void 
        {
            super.initialize();
            
            var l:VerticalLayout = new VerticalLayout();
            layout = l;            
            
            tabBar = new TabBar();
            tabBar.dataProvider = new ListCollection([ { "label":"Controls" }, { "label":"Assets" } ]);
            addChild(tabBar);
            
            box = new ScrollContainer();
            addChild(box);
            
            cmpList = new List();
			cmpList.itemRendererFactory = function():*{ return new ControlListItenRenderer()};
            box.addChild(cmpList);
            
            var textureNames:* = AppFacade.getInstance().assets.getTextureNames();
            assetsList = new List();
			assetsList.itemRendererFactory = function():*{ return new AssetListItemRenderer()};
            assetsList.dataProvider = new ListCollection(textureNames);
            box.addChild(assetsList);
            assetsList.visible = false;
            
            //evts
            tabBar.addEventListener(Event.CHANGE, tabChangeHandler);
            Starling.current.stage.addEventListener(TouchEvent.TOUCH, touchHandler);
            
            cmpList.addEventListener(Event.CHANGE, cmpSelectHandler);
            //assetsList.addEventListener(Event.CHANGE, assetsSelectHandler);
        }
        
        //private function assetsSelectHandler(e:Event):void 
        //{
            //var selectedAsset:String = String(assetsList.selectedItem)||"";
            //Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, nativeStageClickHandler);
        //}
		//
		//private function nativeStageClickHandler(e:*):void
		//{
			//System.setClipboard(String(assetsList.selectedItem));
			//var lbl:Label = new Label();
			//lbl.text = "copy:" + assetsList.selectedItem;
			//Callout.show(lbl,this);
			//Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, nativeStageClickHandler);
		//}
        
        private function cmpSelectHandler(e:Event):void 
        {
            dispatchEventWith(EventType.SELECT_CMP, false, cmpList.selectedItem);
        }
        
        private function touchHandler(e:TouchEvent):void 
        {
            var isTouchCmp:Boolean = e.getTouch(cmpList) == null;
            if (isTouchCmp) cmpList.selectedItem = null;
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
        
        override protected function validateChildren():void 
        {
            super.validateChildren();
            cmpList.minWidth = width;
            assetsList.minWidth = width;
            cmpList.height = height;
            assetsList.height = height;
        }
        
    }

}