package feditor.views.pnl 
{
    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.ScrollContainer;
    import feathers.controls.TabBar;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;
    import feditor.AppFacade;
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
        public static const PREVIEW:String = "preview";
        public static const SELECT_CMP:String = "select_cmp";
        
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
            box.addChild(cmpList);
            
            var textureNames:* = AppFacade.getInstance().assets.getTextureNames();
            assetsList = new List();
            assetsList.dataProvider = new ListCollection(textureNames);
            box.addChild(assetsList);
            assetsList.visible = false;
            
            //evts
            tabBar.addEventListener(Event.CHANGE, tabChangeHandler);
            Starling.current.stage.addEventListener(TouchEvent.TOUCH, touchHandler);
            
            cmpList.addEventListener(Event.CHANGE, cmpSelectHandler);
            assetsList.addEventListener(Event.CHANGE, assetsSelectHandler);
        }
        
        private function assetsSelectHandler(e:Event):void 
        {
            var selectedAsset:String = String(assetsList.selectedItem)||"";
            dispatchEventWith(PREVIEW,false,selectedAsset);
            Starling.current.nativeStage.addEventListener(MouseEvent.CLICK, function(e:*):void {
                System.setClipboard(selectedAsset);
                Starling.current.nativeStage.removeEventListener(e.type, arguments.callee);
                });
        }
        
        private function cmpSelectHandler(e:Event):void 
        {
            dispatchEventWith(SELECT_CMP, false, cmpList.selectedItem);
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