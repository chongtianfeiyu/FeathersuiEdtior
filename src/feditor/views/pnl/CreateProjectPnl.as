package feditor.views.pnl 
{
    import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.Callout;
    import feathers.controls.Check;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.Panel;
    import feathers.controls.Radio;
    import feathers.controls.TextInput;
    import feathers.core.PopUpManager;
    import feathers.data.ListCollection;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    import feditor.views.cmp.FormItem;
    import feditor.vo.ProjectVO;
    import feditor.vo.FieldVO;
    import starling.events.Event;
    import starling.utils.formatString;
    
    /**
     * ...
     * @author gray
     */
    public class CreateProjectPnl extends Panel 
    {
        private var _hasData:Boolean;
        private var deviceList:ButtonGroup;
        private var inputArr:Array;
        private var projInput:TextInput;
        private var listDataSource:Array;
        
        public function CreateProjectPnl() 
        {
            super();
        }
        
        override protected function initialize():void 
        {
            super.initialize();
            const W:int = 400;
            var desLabel:Label;
            
            headerProperties.title = "Create Project";
            
            var boxLayout:VerticalLayout = new VerticalLayout();
            boxLayout.gap = 10;
            boxLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
            layout = boxLayout;
            
            //project name box
            var projBox:LayoutGroup = new LayoutGroup();
            var projBoxLayout:HorizontalLayout = new HorizontalLayout();
            projBoxLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
            projBox.layout = projBoxLayout;
            projBoxLayout.paddingBottom = 20;
            addChild(projBox);
            
            var projTitle:Label = new Label();
            projTitle.text = "Project Name";
            projTitle.width = 100;
            projBox.addChild(projTitle);
            
            projInput = new TextInput();
            projInput.width = W - 100;
            projInput.text = "NewProject";
            projBox.addChild(projInput);
            
            desLabel = new Label();
            //desLabel.la
            desLabel.text = "Popular devices";
            addChild(desLabel);
            
            deviceList = new ButtonGroup();            
            deviceList.width = W;
            addChild(deviceList);
            if (listDataSource) deviceList.dataProvider = new ListCollection(listDataSource);
            deviceList.addEventListener(Event.TRIGGERED, listSelectHandler);
            deviceList.buttonProperties.minHeight = 40;
            deviceList.buttonProperties.paddingLeft = 60;
            deviceList.buttonProperties.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
            deviceList.paddingBottom = 20;
            
            desLabel = new Label();
            desLabel.text = "Customize stage size";
            addChild(desLabel);
            
            inputArr = [];
            var strArr:Array = ["width","height","color",1080,1920,"0x333333"];
            for (var i:int = 0; i < 3; i++) 
            {
                var box:LayoutGroup = new LayoutGroup();
                var layout:HorizontalLayout = new HorizontalLayout();
                layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
                box.layout = layout;
                addChild(box);
                
                var label:Label = new Label();
                label.text = strArr[i];
                label.width = 50;
                box.addChild(label);
                
                var input:TextInput = new TextInput();
                box.addChild(input);
                input.width = W - 50;
                input.text = String(strArr[i + 3]);
                input.maxChars = 8;
                inputArr[i] = input;
            }
            
            var button:Button = new Button();
            button.width = W / 2;
            button.height = 30;
            button.label = "create";
            addChild(button);
            button.addEventListener(Event.TRIGGERED,buttonHanlder);
        }
        
        public function setDeviceList(arr:Array):void
        {
            listDataSource  = [];
            for each (var item:ProjectVO in arr) 
            {
                listDataSource.push({"label":formatString("{0} {1}*{2}",item.name,item.width,item.height),"data":item});
            }
            
            if (deviceList)
            {
                deviceList.dataProvider = new ListCollection(listDataSource);
            }
            
            _hasData = true;
        }
        
        public function show():void
        {
            PopUpManager.addPopUp(this);
        }
        
        public function hide():void
        {
            if (PopUpManager.isPopUp(this))
            {
                PopUpManager.removePopUp(this);
            }
        }
        
        private function buttonHanlder(e:Event):void 
        {
            var tip:Label;
            
            if (!projInput.text || /[^0-9a-zA-Z]/.test(projInput.text))
            {
                tip = new Label();
                tip.text = "Must fill.And numbers and English letters only";
                Callout.show(tip, projInput);
                return;
            }
            
            
            var valid:Boolean = true;
            var str:String;
            for each (var item:TextInput in inputArr) 
            {
                if (!item.text)
                {
                    valid = false;
                    str = "Not filled";
                }
                else if (item != inputArr[2] && /[^0-9]/.test(item.text))
                {
                    valid = false;
                    str = "numbers only";
                }
                else if (item == inputArr[2] && isNaN(parseInt(item.text,16)))
                {
                    valid = false;
                    str = "hexadecimal number only";
                }
                
                if (valid == false)
                {
                    tip = new Label();
                    tip.text = "Error Input!";
                    Callout.show(tip, item);
                    return;
                }
            }
            
            var projectVO:ProjectVO = new ProjectVO();
            projectVO.projectName = projInput.text;
            projectVO.width = parseInt(inputArr[0].text);
            projectVO.height = parseInt(inputArr[1].text);
            projectVO.color = parseInt(inputArr[2].text,16);
            dispatchEventWith(Event.SELECT, false, projectVO);
        }
        
        private function listSelectHandler(e:Event):void 
        {    
            var tip:Label;
            
            if (!projInput.text || /[^0-9a-zA-Z]/.test(projInput.text))
            {
                tip = new Label();
                tip.text = "Must fill.And numbers and English letters only";
                Callout.show(tip, projInput);
                return;
            }
            
            var projectVO:ProjectVO = new ProjectVO();
            projectVO.projectName = projInput.text;
            projectVO.width = e.data.data.width;
            projectVO.height = e.data.data.height;
            projectVO.color = e.data.data.color;
            
            dispatchEventWith(Event.SELECT, false, projectVO);
        }
        
        
        public function get hasData():Boolean 
        {
            return _hasData;
        }
    }
}