package feditor.views.pnl 
{
    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.controls.Panel;
    import feathers.core.PopUpManager;
    import feathers.layout.VerticalLayout;
    import feditor.views.cmp.FormItem;
    import feditor.vo.FieldVO;
    import feditor.vo.StageVO;
    import starling.events.Event;
    
    /**
     * ...
     * @author gray
     */
    public class CreateProjectPnl extends Panel 
    {
        public var button:Button;
        private var formItems:Array = [];
        private var _stageVO:StageVO = new StageVO();
        
        public function CreateProjectPnl() 
        {
            super();
            
            headerProperties.title = "Create Project";
            var boxLayout:VerticalLayout = new VerticalLayout();
            boxLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
            boxLayout.gap = 10;
            this.layout = boxLayout;
            
            var arr:Array = ["project","width", "height", "color"];
            
            
            var formBox:LayoutGroup = new LayoutGroup();
            var formBoxLayout:VerticalLayout = new VerticalLayout();
            formBoxLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
            formBoxLayout.gap = 10;
            formBox.layout = formBoxLayout;
            addChild(formBox);
            
            for (var i:int = 0; i < 4; i++) 
            {
                var fvo:FieldVO = new FieldVO();
                fvo.name = arr[i];
                if (arr[i] == "width")
                {
                    fvo.value = String(640);
                }
                else if (arr[i] == "height")
                {
                    fvo.value = String(960);
                }
                else if(arr[i] == "color")
                {
                    fvo.value = "0x333333";
                }
                var formItem:FormItem = new FormItem();
                formItem.data = fvo;
                formBox.addChild(formItem);
                formItems.push(formItem);
            }
            
            button = new Button();
            button.label = "create";
            
            button.addEventListener(Event.TRIGGERED, createHandler);
            addChild(button);
        }
        
        
        private function createHandler(e:Event):void 
        {
            if (verify())
            {
                _stageVO.projectName = String(FormItem(formItems[0]).data.value);
                _stageVO.width = parseInt(FormItem(formItems[1]).data.value);
                _stageVO.height = parseInt(FormItem(formItems[2]).data.value);
                _stageVO.color = parseInt(FormItem(formItems[3]).data.value, 16);
                dispatchEventWith(Event.CLOSE,false,_stageVO);
                hide();
            }
        }
        
        private function verify():Boolean
        {
            for each (var item:FormItem in formItems) 
            {
                if (!item.data.value) return false;
                
                switch (item.data.name) 
                {
                    case "color":
                        if (/^0x[0-9a-fA-F]/.test(item.data.value) == false)
                        {
                            return false;
                        }
                        break;
                    case "project":
                        if (/[^a-zA-Z0-9]/.test(item.data.value))
                        {
                            return false;
                        }
                        break;
                    default:
                        if (/[^0-9]/.test(item.data.value))
                        {
                            return false;
                        }
                }
            }
            
            return true;
        }
        
        public function show():void
        {
            PopUpManager.addPopUp(this);
        }
        
        public function sedDefault(w:int,h:int,color:int,project:String):void
        {
            var pvo:FieldVO = new FieldVO();
            pvo.name = "project";
            pvo.value = project;
            
            var wvo:FieldVO = new FieldVO();
            wvo.name = "width";
            wvo.value = w.toString();
            
            var hvo:FieldVO = new FieldVO();
            hvo.name = "height";
            hvo.value = h.toString();
            
            var cvo:FieldVO = new FieldVO();
            cvo.name = "color";
            cvo.value = "0x"+color.toString(16);
            
            var arr:Array = [pvo,wvo, hvo, cvo];
            for each (var item:FormItem in formItems) 
            {
                item.data = arr.shift();
            }
        }
        
        public function hide():void
        {
            if (PopUpManager.isPopUp(this))
            {
                PopUpManager.removePopUp(this);
            }
        }
        
        public function get stageVO():StageVO 
        {
            return _stageVO;
        }
        
    }

}