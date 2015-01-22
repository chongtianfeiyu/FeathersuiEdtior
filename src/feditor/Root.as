package feditor 
{
    import feathers.controls.ButtonGroup;
	import feathers.controls.Check;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
	import feathers.controls.Radio;
    import feathers.controls.ScrollContainer;
	import feathers.controls.ToggleSwitch;
    import feathers.data.ListCollection;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    import feditor.views.cmp.Form;
    import feditor.views.cmp.VirtualItemRenderer;
    import feditor.views.pnl.CmpPanel;
    import feditor.views.pnl.EditorStage;
    import flash.display.NativeMenu;
    import starling.display.Sprite;
    import starling.events.Event;
    
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
        private var stageLayout:HorizontalLayout;
        
        private var hasStartup:Boolean = false;
        
        
        public function Root() 
        {
            super();
        }
        
        override protected function initialize():void 
        {
            super.initialize();
        }
        
        public function startup():void
        {
            //panel of control properties.Right
            form = new Form();
            form.width = 280;
            form.minWidth = 280;
            addChild(form);
            
            //left panel
            var vbox:LayoutGroup = new LayoutGroup();
            vbox.layout = new VerticalLayout();
            addChild(vbox);
            
            cmpPanel = new CmpPanel();
            vbox.addChild(cmpPanel);
            
            //editor stage
            editorStage = new EditorStage();
            stageContainer = new ScrollContainer();
            
            stageContainer.addChild(editorStage);
            stageLayout = new HorizontalLayout();
            stageLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
            stageLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
            stageContainer.layout = stageLayout;
            addChild(stageContainer);
            
            hasStartup = true;
            
            addEventListener(EditorStage.INIT_EDITOR, updateLayout);
        }
        
        public function updateLayout():void
        {
            stageLayout.verticalAlign = editorStage.height > height?VerticalLayout.VERTICAL_ALIGN_TOP:VerticalLayout.VERTICAL_ALIGN_MIDDLE;
            stageLayout.horizontalAlign = editorStage.width > width?HorizontalLayout.HORIZONTAL_ALIGN_LEFT:HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
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
    }

}