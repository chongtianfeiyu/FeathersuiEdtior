package feditor.views.cmp 
{
	import feathers.controls.Button;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feditor.events.EventType;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    /**
     * ...
     * @author gray
     */
    public class ControlListItenRenderer extends DefaultListItemRenderer 
    {
        
        public function ControlListItenRenderer() 
        {
            super();
            addEventListener(TouchEvent.TOUCH, touchHandler);
        }
		
		override protected function initializeInternal():void 
		{
			super.initializeInternal();
			this.horizontalAlign = Button.HORIZONTAL_ALIGN_RIGHT;
		}
        
        protected function touchHandler(event:TouchEvent):void 
        {
            var touch:Touch = event.getTouch(this, TouchPhase.HOVER);
            if (touch)
            {
                dispatchEventWith(EventType.PREVIEW,true,[_data,touch.globalX,touch.globalY]);
            }
        }
    }

}