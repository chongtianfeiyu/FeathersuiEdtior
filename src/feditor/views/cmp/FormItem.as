package feditor.views.cmp 
{
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.TextInput;
    import feathers.events.FeathersEventType;
    import feathers.layout.HorizontalLayout;
    import feditor.vo.FieldVO;
    import starling.events.Event;
    
    /**
     * ...
     * @author gray
     */
    public class FormItem extends LayoutGroup 
    {
        private var title:Label;
        private var input:TextInput;
        private var _data:FieldVO;
        private const GAP:int = 5;
		
        public function FormItem() 
        {
            super();
        }
        
        override protected function initialize():void 
        {
            super.initialize();
            
            var hlayout:HorizontalLayout = new HorizontalLayout();
            hlayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			hlayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_RIGHT;
            layout = hlayout;
            layout["gap"] = GAP;
            
            title = new Label();
            title.text = "title";
            input = new TextInput();
            
            addChild(title);
            addChild(input);
            
            input.addEventListener(FeathersEventType.FOCUS_OUT, changeHanlder);
            input.addEventListener(FeathersEventType.ENTER, changeHanlder);
            
            if (_data) data = _data;
        }
        
        private function changeHanlder(e:Event):void 
        {
            if (_data == null) return;
            
            if ((input.text == _data.value && !input.text)) return;
            
            if (input.text != _data.value)
            {
                if (_data.name == "color" || _data.name == "promptColor")
                {
                    if (parseInt(_data.value) != parseInt(input.text, 16))
                    {
                        _data.value = input.text;
                        dispatchEventWith(Event.CHANGE, true, _data);
                    }
                }
                else
                {
                    _data.value = input.text;
                    dispatchEventWith(Event.CHANGE, true, _data);
                }
            }
        }
        
        private function typeCheck(type:Class,value:String):Boolean
        {
            switch (type) 
            {
                case int:
                case uint:
                case Number:
                    return value == parseFloat(value).toString();
                break;
                default:
            }
            
            return true;
        }
        
        public function get data():FieldVO 
        {
            return _data;
        }
        
        public function set data(value:FieldVO):void 
        {
            _data = value;
            if (title && input)
            {
                title.text = value.name;
                switch (value.name) 
                {
                    case "promptColor":
                    case "color":
                        if (/0x/.test(value.value) == false)
                        {
                            if (value.value)
                            {
                                input.text ="0x"+parseInt(value.value).toString(16);
                            }
                            else
                            {
                                input.text = "";
                            }
                        }
                        else
                        {
                            input.text = value.value;
                        }
                        break;
                    default:
                        input.text = value.value;
                }
                
                input.touchable = value.editable;
				input.isEnabled = value.editable;
            }
        }
    }

}