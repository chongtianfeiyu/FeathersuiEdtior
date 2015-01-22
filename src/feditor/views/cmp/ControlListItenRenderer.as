package feditor.views.cmp 
{
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