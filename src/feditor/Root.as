package feditor 
{
	import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.Check;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
	import feathers.controls.PickerList;
    import feathers.controls.Radio;
	import feathers.controls.ScrollBar;
    import feathers.controls.ScrollContainer;
    import feathers.controls.ToggleSwitch;
    import feathers.data.ListCollection;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
	import feditor.views.pnl.ColorDropper;
    import feditor.views.cmp.Form;
    import feditor.views.cmp.VirtualItemRenderer;
    import feditor.views.pnl.LibraryPanel;
    import feditor.views.pnl.EditorStage;
	import feditor.views.pnl.ToolPanel;
    import flash.display.NativeMenu;
	import flash.utils.setInterval;
    import starling.core.Starling;
	import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    
    /**
     * ...
     * @author gray
     */
    public class Root extends LayoutGroup 
    {
		public var refreshButton:Button;
        public var form:Form;
		public var toolBox:ToolPanel;
        public var libraryPanel:LibraryPanel;
        public var editorStage:EditorStage;
        public var stageContainer:ScrollContainer;
		public var colorDropper:ColorDropper;
        
        private var stageLayout:HorizontalLayout;
        private var hasStartup:Boolean = false;
		private var rightBox:LayoutGroup;
        
        public function Root() 
        {
            super();
        }
        
		override protected function refreshViewPortBounds():void 
		{
			if (hasStartup == false) return;
			
			if (form.height != height) form.height = height - toolBox.height;
            rightBox.x = width - form.width;
			//toolBox.width = 
			
            var w:int = width - libraryPanel.width - form.width;
            var h:int = height;
            
            libraryPanel.maxHeight = height - refreshButton.height;
            
            if(w != stageContainer.width) stageContainer.width = w;
            if(h != stageContainer.height) stageContainer.height = h;
            
            stageContainer.x = libraryPanel.width +  0.5 * (w - stageContainer.width);
			
			super.refreshViewPortBounds();
		}
        
        public function startup():void
        {
			rightBox = new LayoutGroup();
			rightBox.layout = new VerticalLayout();
			addChild(rightBox);
			
			toolBox = new ToolPanel();
			toolBox.width = 280;
			rightBox.addChild(toolBox);
            //panel of control properties.Right
            form = new Form();
            form.width = 280;
            form.minWidth = 280;
            rightBox.addChild(form);
            
            //left panel
            var leftBox:LayoutGroup = new LayoutGroup();
            leftBox.layout = new VerticalLayout();
            addChild(leftBox);
            
            libraryPanel = new LibraryPanel();
			libraryPanel.width = 240;
            leftBox.addChild(libraryPanel);
			
			refreshButton = new Button();
			refreshButton.width = 240;
			refreshButton.label = "refresh control library";
			refreshButton.styleName = Button.ALTERNATE_NAME_QUIET_BUTTON;
			leftBox.addChild(refreshButton);
            
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
			
			colorDropper = new ColorDropper();
			editorStage.addChild(colorDropper);
			
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