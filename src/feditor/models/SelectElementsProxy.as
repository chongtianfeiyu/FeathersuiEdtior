package feditor.models 
{
    import feditor.NS;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
    import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
    
    /**
     * ...
     * @author gray
     */
    public class SelectElementsProxy extends Proxy 
    {
        public static const NAME:String = "SelectElementsProxy";
        
        private var _selectedItems:Array = [];
        
        public function SelectElementsProxy(data:Object=null) 
        {
            super(NAME, data);
        }
        
        public function clear():void
        {
            _selectedItems.length = 0;
            sendNotification(NS.NOTE_SELECT_ITEM_DATA_UPDATE,_selectedItems);
        }
        
        public function addItems(arr:Array):void
        {
            var changed:Boolean = false;
            for each (var item:DisplayObject in arr) 
            {
                if (item && _selectedItems.indexOf(item)==-1)
                {
                    _selectedItems.push(item);
                    changed = true;
                }
            }
            sort();
            if(changed) sendNotification(NS.NOTE_SELECT_ITEM_DATA_UPDATE,_selectedItems);
        }
        
        public function addItem(display:DisplayObject):void
        {
            if (_selectedItems.indexOf(display)==-1)
            {
                _selectedItems.push(display);
				sort();
                sendNotification(NS.NOTE_SELECT_ITEM_DATA_UPDATE,_selectedItems);
            }
        }
        
        public function removeItem(display:DisplayObject):void
        {
            var index:int = _selectedItems.indexOf(display);
            if (index !=-1)
            {
                _selectedItems.splice(index, 1);
                sendNotification(NS.NOTE_SELECT_ITEM_DATA_UPDATE,_selectedItems);
            }
        }
		
		private function sort():void
		{
			if (_selectedItems.length)
			{
				var item:DisplayObject = _selectedItems[0];
				var parent:DisplayObjectContainer = item.parent;
				if (parent)
				{
					_selectedItems.sort(function(a:*, b:*):int {
						return parent.getChildIndex(a) > parent.getChildIndex(b)?1: -1;
					});
				}
			}
		}
        
        public function getSelectedControl():*
        {
            if (_selectedItems.length == 1)
            {
                return _selectedItems[0];
            }
            return null;
        }
        
        public function get selectedItems():Array
        {
            return _selectedItems;
        }
        
        public function get hasData():Boolean
        {
            return _selectedItems.length > 0;
        }
    }

}