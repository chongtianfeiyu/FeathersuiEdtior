package feditor.views.pnl 
{
    import feathers.controls.ButtonGroup;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.Panel;
    import feathers.core.PopUpManager;
    import feathers.data.ListCollection;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    
    /**
     * ...
     * @author gray
     */
    public class WellcomePnl extends Panel 
    {
        
        public var menu:ButtonGroup;
        
        public function WellcomePnl() 
        {
            super();
        }
        
        override protected function initialize():void 
        {
            super.initialize();
            headerProperties.title = "Wellcome Feathersui Editor";
            
            
            
            var box:LayoutGroup = new LayoutGroup();
            box.layout = new VerticalLayout();
            box.layout["gap"] = 20;
            addChild(box);
            
            var info:Label = new Label();
            info.text = "This is a test version.More function is building.";
            box.addChild(info);
            
            menu = new ButtonGroup();
            menu.dataProvider = new ListCollection(["New Project", "Open Project"]);
            menu.buttonProperties.minHeight = 36;
            box.addChild(menu);
        }
        
        public function show():void
        {
            PopUpManager.addPopUp(this);
            menu.minWidth = width;
            padding = 20;
            paddingBottom = 50;
        }
        
        public function hide():void
        {
            if (PopUpManager.isPopUp(this))
            {
                PopUpManager.removePopUp(this);
            }
        }
    }
}