package feditor.views.cmp 
{
    import feathers.controls.Panel;
    import feathers.layout.VerticalLayout;
	import flash.geom.Rectangle;
    
    /**
     * ...
     * @author gray
     */
    public class Form extends Panel 
    {
        private var formItems:Vector.<FormItem>;
        private var p:int;
        
        
        public function Form() 
        {
            super();
        }
        
        override protected function initialize():void 
        {
            super.initialize();
            formItems = new Vector.<FormItem>();
            
            headerProperties.title = "Property Panel";
            layout = new VerticalLayout();
            layout['gap'] = 5;
        }
        
        public function setPropertyList(data:Array):void
        {
            clear();
            for each (var item:* in data) 
            {
                var formItem:FormItem = getFormItem();
                addChild(formItem);
                formItem.data = item;
            }
        }
        
        public function clear():void
        {
            p = 0;
            for each (var item:FormItem in formItems) 
            {
                if (contains(item))
                {
                    removeChild(item);
                }
            }
        }
		
        private function getFormItem():FormItem
        {
            var result:FormItem;
            if (formItems.length > p)
            {
                result = formItems[p];
            }
            else
            {
                result = new FormItem();
                formItems.push(result);
				result.maxWidth = width - 40;
				result.width = width - 40;
            }
            
            p++;
            
            return result;
        }
    }

}