package feditor.views.pnl {
    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
	import feditor.events.EventType;
    import feditor.utils.Geom;
	import feditor.views.cmp.DragClip;
    import flash.geom.Rectangle;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
	import starling.events.TouchPhase;
    
    /**
     * ...
     * @author gray
     */
    public class RectSelect extends DragClip 
    {
        protected var childrens:Array;
        protected var controls:Array;
        protected var handObj:DisplayObject;
        protected var oldx:int;
        protected var oldy:int;
        protected var oldW:int;
        protected var oldH:int;
		protected var hasChanged:Boolean = false;
        
        public function RectSelect(container:DisplayObjectContainer) 
        {
            super(container);
            this.clip.alpha = 0.05;
            
            childrens = [];
            controls = [];
            
            for (var i:int = 0; i < 8; i++) 
            {
                var button:Button = new Button();
                button.label = "";
                button.padding = 0;
                button.setSize(10, 10);
                addChild(button);
                controls[i] = button;
            }
        }
        
        public function joinFocus(display:DisplayObject):void
        {
            if (childrens.indexOf(display) == -1 && display!=this)
            {
                childrens.push(display);
                refreshFocusByChildren();
            }
        }
        
        public function leaveFocus(display:DisplayObject):void
        {
            var index:int = childrens.indexOf(display);
            if (index != -1)
            {
                childrens.splice(index,1);
                refreshFocusByChildren();
            }
            
            if (childrens.length == 0)
            {
                clearFocus();
            }
        }
        
        public function clearFocus():void
        {
            clip.width = 1;
            clip.height = 1;
            childrens.length = 0;
            clip.x = 0;
            clip.y = 0;
            if (parent) parent.removeChild(this);
            isValid = false;
            refreshControlsByClip();
			hasChanged = false;
        }
		
		public function updateFocus():void
		{
			refreshFocusByChildren();
		}
        
        protected function getActiveControl(e:TouchEvent):Button
        {
            var result:Button;
            var touch:Touch;
            for each (var item:Button in controls) 
            {
                touch = e.getTouch(item);
                if (touch) return item;
            }
            return result;
        }
        
        override protected function touchBeginHandler(e:TouchEvent):void 
        {
            super.touchBeginHandler(e);
            if (e.getTouch(clip))
            {
                if(childrens.length>0) handObj = clip;
            }
            else if(childrens.length == 1)
            {
                handObj = getActiveControl(e);
            }
            else
            {
                //clearFocus();
            }
            
            if (handObj)
            {
                oldx = handObj.x;
                oldy = handObj.y;
            }
            
            oldW = clip.width;
            oldH = clip.height;
			hasChanged = false;
			
			dispatchEventWith(TouchPhase.BEGAN);
        }
        
        override protected function touchError(e:TouchEvent):void 
        {
            //not todo super's method
			hasChanged = false;
        }
        
        override protected function touchEndHandler(e:TouchEvent):void 
        {
            super.touchEndHandler(e);
            handObj = null;
			
			if (e.getTouch(this) && hasChanged)
			{
				dispatchEventWith(TouchPhase.ENDED);
			}
			
			hasChanged = false;
        }
        
        override protected function touchMoveHandler(e:TouchEvent):void 
        {
            super.touchMoveHandler(e);
            
            var moveX:int = posEnd.x - posStart.x;
            var moveY:int = posEnd.y - posStart.y;
			
			if (e.getTouch(this))
			{
				hasChanged = true;
			}
            
            if (handObj is Image)
            {
                var dx:int = oldx + moveX - handObj.x;
                var dy:int = oldy + moveY - handObj.y;
                
                handObj.x = oldx + moveX;
                handObj.y = oldy + moveY;
                
                for each (var item:DisplayObject in childrens) 
                {
                    item.x += dx;
                    item.y += dy;
                }
                refreshControlsByClip();
            }
            else if (handObj is Button )
            {
                if ((childrens.length = 1))// && !(childrens[0] is LayoutGroup)
                {
                    if (handObj == controls[1] || handObj == controls[5])
                    {
                        handObj.y = oldy + moveY;
                    }
                    else if (handObj == controls[3] || handObj == controls[7])
                    {
                        handObj.x = oldx + moveX;
                    }
                    else
                    {
                        handObj.x = oldx + moveX;
                        handObj.y = oldy + moveY;
                    }
                    
                    var rect:Rectangle = measuseControlsOnChange(handObj as Button);
                    clip.x = rect.x;
                    clip.y = rect.y;
                    clip.width = rect.width;
                    clip.height = rect.height;
                    
                    refreshControlsByClip();
                    resizeChildren();
                }
            }
            
            if (childrens.length == 1)
            {
                dispatchEventWith(Event.CHANGE,false,childrens[0]);
            }
        }
        
        protected function measuseControlsOnChange(button:Button):Rectangle
        {
            //0-1-2
            //7   3
            //6-5-4
            const w:int = button.width;
            const h:int = button.height;
            
            var index:int = controls.indexOf(button);
            var rect:Rectangle = new Rectangle();
            switch (index) 
            {
                case 0://4-0
                    rect.x = Button(controls[0]).x;
                    rect.y = Button(controls[0]).y;
                    rect.width = Button(controls[4]).x - Button(controls[0]).x;
                    rect.height = Button(controls[4]).y - Button(controls[0]).y;
                    break;
                case 1://5-1
                    rect.x = Button(controls[0]).x;
                    rect.y = Button(controls[1]).y;
                    rect.width = Button(controls[2]).x - Button(controls[0]).x;
                    rect.height = Button(controls[5]).y - Button(controls[1]).y;
                    break;
                case 2://2-6
                    rect.x = Button(controls[0]).x;
                    rect.y = Button(controls[2]).y;
                    rect.width = Button(controls[2]).x - Button(controls[0]).x;
                    rect.height = Button(controls[6]).y - Button(controls[2]).y;
                    break;
                case 3://3-7
                    rect.x = Button(controls[0]).x;
                    rect.y = Button(controls[0]).y;
                    rect.width = Button(controls[3]).x - Button(controls[0]).x;
                    rect.height = Button(controls[4]).y - Button(controls[0]).y;
                    break;
                case 4://4-0
                    rect.x = Button(controls[0]).x;
                    rect.y = Button(controls[0]).y;
                    rect.width = Button(controls[4]).x - Button(controls[0]).x;
                    rect.height = Button(controls[4]).y - Button(controls[0]).y;
                    break;
                case 5:
                    rect.x = Button(controls[0]).x;
                    rect.y = Button(controls[0]).y;
                    rect.width = Button(controls[2]).x - Button(controls[0]).x;
                    rect.height = Button(controls[5]).y - Button(controls[0]).y;
                    break;
                case 6:
                    rect.x = Button(controls[6]).x;
                    rect.y = Button(controls[0]).y;
                    rect.width = Button(controls[2]).x - Button(controls[6]).x;
                    rect.height = Button(controls[6]).y - Button(controls[2]).y;
                    break;
                case 7:
                    rect.x = Button(controls[7]).x;
                    rect.y = Button(controls[0]).y;
                    rect.width = Button(controls[4]).x - Button(controls[7]).x;
                    rect.height = Button(controls[4]).y - Button(controls[0]).y;
                    break;
                default:
            }
            
            rect.x += w;
            rect.y += h;
            rect.width -= w;
            rect.height -= h;
            
            if (rect.width < 0) rect.width = 0;
            if (rect.height < 0) rect.height = 0;
            
            return rect;
        }
        
        protected function refreshControlsByClip():void
        {
            var left:int = clip.x;
            var top:int = clip.y;
            var w:int = clip.width;
            var h:int = clip.height;
            //update position of controls
            for (var i:int = 0; i < controls.length; i++) 
            {
                var button:Button = controls[i];
                switch (i) 
                {
                    case 0://top left
                        button.x = left - button.width;
                        button.y = top - button.height;
                    break;
                    case 1://top center
                        button.x = left + 0.5*(w - button.width);
                        button.y = top - button.height;
                    break;
                    case 2://top right
                        button.x = left + w;
                        button.y = top - button.height;
                    break;
                    case 3://right
                        button.x = left + w;
                        button.y = top + 0.5*(h - button.height);
                    break;
                    case 4://bottom right
                        button.x = w + left;
                        button.y = h + top;
                    break;
                    case 5://bottom
                        button.x = left + 0.5*(w - button.width);
                        button.y = top + h;
                    break;
                    case 6://botton left
                        button.x = left - button.width;
                        button.y = top + h;
                    break;
                    case 7:
                        button.x = left - button.width;
                        button.y = top + 0.5*(h - button.height);
                    break;
                    default:
                }
            }
        }
        
        protected function refreshFocusByChildren():void
        {
            var rect:Rectangle = Geom.getBound(childrens);
            
            clip.x = rect.x;
            clip.y = rect.y;
            clip.width = rect.width;
            clip.height = rect.height;
            
            refreshControlsByClip();
        }
        
        private function resizeChildren():void
        {
            if (childrens.length == 1 )//&& !(childrens[0] is LayoutGroup)
            {
                var display:DisplayObject = childrens[0];
                display.width = clip.width;
                display.height = clip.height;
                display.x = clip.x;
                display.y = clip.y;
            }
        }
        
        private function getTouchChild(e:TouchEvent):DisplayObject
        {
            var result:DisplayObject;
            for each (var item:DisplayObject in childrens) 
            {
                if (item && e.getTouch(item))
                {
                    return item;
                }
            }
            return result;
        }
        
        public function getClip():Image
        {
            return clip;
        }
        
        public function getHandObj():DisplayObject
        {
            return childrens.length == 1?childrens[0]:null;
        }
    }

}