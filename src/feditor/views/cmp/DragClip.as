package feditor.views.cmp 
{
    import flash.geom.Point;
    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    /**
     * ...
     * @author gray
     */
    public class DragClip extends Sprite 
    {
        protected var isValid:Boolean = false;
        protected var container:DisplayObjectContainer;
        protected var clip:Image;
        protected var posStart:Point = new Point(NaN,NaN);
        protected var posEnd:Point = new Point(NaN,NaN);
        
        public function DragClip(container:DisplayObjectContainer) 
        {
            super();
            
            clip = new Image(Texture.fromColor(1, 1));
            addChild(clip);
            
            this.container = container;
        }
        
        public function startJob():void
        {
            if (isValid) return;
            container.addChild(this);
            Starling.current.stage.addEventListener(TouchEvent.TOUCH, touchHandler);
            isValid = true;
        }
        
        public function startWith(posx:int,posy:int):void
        {
            posStart.x = posx;
            posStart.y = posy;
        }
        
        public function exitJob():void
        {
            if (isValid == false) return;
            isValid = false;
            Starling.current.stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
            posStart.x = NaN;
            posStart.y = NaN;
        }
        
        protected function touchHandler(e:TouchEvent):void 
        {
            var touch:Touch = e.getTouch(Starling.current.stage);
            if (touch == null)
            {
                touchError(e);
                return;
            }
            
            switch (touch.phase) 
            {
                case TouchPhase.BEGAN:
                    container.globalToLocal(new Point(touch.globalX, touch.globalY), posStart);
                    touchBeginHandler(e);
                    break;
                case TouchPhase.ENDED:
                    container.globalToLocal(new Point(touch.globalX, touch.globalY), posEnd);
                    if (isNaN(posStart.x) || isNaN(posStart.y))
                    {
                        posStart.x = posEnd.x;
                        posStart.y = posEnd.y;
                    }
                    touchEndHandler(e);
                    break;
                case TouchPhase.MOVED:
                    if (isNaN(posStart.x) || isNaN(posStart.y))
                    {
                        container.globalToLocal(new Point(touch.globalX, touch.globalY), posStart);
                    }
                    else
                    {
                        container.globalToLocal(new Point(touch.globalX, touch.globalY), posEnd);
                        touchMoveHandler(e);
                    }
                    break;
                default:
            }
        }
        
        protected function touchError(e:TouchEvent):void
        {
            exitJob();
        }
        
        protected function touchBeginHandler(e:TouchEvent):void
        {
            
        }
        
        protected function touchEndHandler(e:TouchEvent):void
        {
            
        }
        
        protected function touchMoveHandler(e:TouchEvent):void
        {
            
        }
    }

}