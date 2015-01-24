package feditor 
{
    import feathers.controls.ButtonGroup;
    import feathers.controls.Check;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
	import feathers.controls.PickerList;
    import feathers.controls.Radio;
    import feathers.controls.ScrollContainer;
    import feathers.controls.ToggleSwitch;
    import feathers.data.ListCollection;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
	import feditor.views.cmp.ColorDropper;
    import feditor.views.cmp.Form;
    import feditor.views.cmp.VirtualItemRenderer;
    import feditor.views.pnl.CmpPanel;
    import feditor.views.pnl.EditorStage;
    import flash.display.NativeMenu;
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    
    /**
     * ...
     * @author gray
     */
    public class Root extends LayoutGroup 
    {
        public var form:Form;
        public var cmpPanel:CmpPanel;
        public var editorStage:EditorStage;
        public var stageContainer:ScrollContainer;
		public var colorDropper:ColorDropper;
        
        private var stageLayout:HorizontalLayout;
        private var hasStartup:Boolean = false;
        
        public function Root() 
        {
            super();
        }
        
        override protected function validateChildren():void 
        {
            super.validateChildren();
            if (hasStartup == false) return;
            
            if (form.height != height) form.height = height;
            form.x = width - form.width;
            
            var w:int = width - cmpPanel.width - form.width;
            var h:int = height;
            
            cmpPanel.maxHeight = height-20;
            
            if(w != stageContainer.width) stageContainer.width = w;
            if(h != stageContainer.height) stageContainer.height = h;
            
            stageContainer.x = cmpPanel.width +  0.5 * (w - stageContainer.width);
        }
        
        public function startup():void
        {
			var rightBox:LayoutGroup = new LayoutGroup();
			rightBox.layout = new VerticalLayout();
			
            //panel of control properties.Right
            form = new Form();
            form.width = 280;
            form.minWidth = 280;
            addChild(form);
            
            //left panel
            var leftBox:LayoutGroup = new LayoutGroup();
            leftBox.layout = new VerticalLayout();
            addChild(leftBox);
            
            cmpPanel = new CmpPanel();
            leftBox.addChild(cmpPanel);
            
            //editor stage
            stageContainer = new ScrollContainer();
            stageLayout = new HorizontalLayout();
            stageLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
            stageLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
            stageContainer.layout = stageLayout;
            stageContainer.isFocusEnabled = false;
            addChild(stageContainer);
            
            editorStage = new EditorStage();
            stageContainer.addChild(editorStage);
			
			//colorDropper = new ColorDropper();
			//addChild(colorDropper);
            
            addEventListener(EditorStage.INIT_EDITOR, updateLayout);
            Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyDownHandler);
            
            hasStartup = true;
        }
        
        public function updateLayout():void
        {
            stageLayout.verticalAlign = editorStage.height > height?VerticalLayout.VERTICAL_ALIGN_TOP:VerticalLayout.VERTICAL_ALIGN_MIDDLE;
            stageLayout.horizontalAlign = editorStage.width > width?HorizontalLayout.HORIZONTAL_ALIGN_LEFT:HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
        }
        
        private function keyDownHandler(e:KeyboardEvent):void 
        {
            if (e.type == KeyboardEvent.KEY_UP)
            {
                stageContainer.verticalMouseWheelScrollDirection = ScrollContainer.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL;
            }
            else if (e.shiftKey)
            {
                stageContainer.verticalMouseWheelScrollDirection = ScrollContainer.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL;
            }
        }
    }

}