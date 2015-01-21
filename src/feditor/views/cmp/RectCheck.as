package feditor.views.cmp 
{
    import feditor.events.EventType;
    import flash.geom.Rectangle;
    import starling.display.DisplayObjectContainer;
    import starling.events.TouchEvent;
    
    /**
     * ...
     * @author gray
     */
    public class RectCheck extends DragClip 
    {
        
        public function RectCheck(container:DisplayObjectContainer) 
        {
            super(container);
            this.clip.alpha = 0.1;
            this.touchable = false;
            this.clip.touchable = false;
        }
        
        override protected function touchBeginHandler(e:TouchEvent):void 
        {
            clip.x = posStart.x;
            clip.y = posStart.y;
        }
        
        override protected function touchEndHandler(e:TouchEvent):void 
        {
            clip.width = Math.abs(posStart.x - posEnd.x);
            clip.height = Math.abs(posStart.y - posEnd.y);
            posEnd.x > posStart.x?clip.x = posStart.x:clip.x = posEnd.x;
            posEnd.y > posStart.y?clip.y = posStart.y:clip.y = posEnd.y;
            
            dispatchEventWith(EventType.DRAG_RECT,false, new Rectangle(clip.x, clip.y, clip.width, clip.height));
            
            clip.width = 1;
            clip.height = 1;
            
            if (parent) parent.removeChild(this);
            exitJob();
        }
        
        override protected function touchMoveHandler(e:TouchEvent):void 
        {
            clip.width = Math.abs(posStart.x - posEnd.x);
            clip.height = Math.abs(posStart.y - posEnd.y);
            posEnd.x > posStart.x?clip.x = posStart.x:clip.x = posEnd.x;
            posEnd.y > posStart.y?clip.y = posStart.y:clip.y = posEnd.y;
        }
        
    }

}