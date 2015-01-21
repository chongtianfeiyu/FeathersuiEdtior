package feditor.views.cmp 
{
    import feathers.controls.Button;
    import feathers.controls.Check;
    import feathers.controls.LayoutGroup;
    import feathers.controls.Panel;
    import feathers.core.PopUpManager;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    import flash.utils.setTimeout;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    /**
     * ...
     * @author gray
     */
    public class PreviewBox extends Panel 
    {
        public var addButton:Button;
        private var previewObject:DisplayObject;
        private var p:*;
        public function PreviewBox()
        {
            super();
            p = this;
        }
        
        override protected function initialize():void 
        {
            super.initialize();
            
            var hlayout:VerticalLayout = new VerticalLayout();
            layout = hlayout;
            
            addButton = new Button();
            addButton.label = "add to stage";
            addChild(addButton);
            headerProperties.title = "preview";
        }
        
        public function showBox(display:DisplayObject,posx:int=0,posy:int=0):void
        {
            
            for (var i:int = numChildren-1; i >=0 ; i--) 
            {
                var child:DisplayObject = getChildAt(i);
                if (child && child != backgroundSkin && child!=addButton)
                {
                    removeChild(child);
                }
            }
            
            if (display)
            {
                addChildAt(display, 0);
                previewObject = display;
            }
            
            x = posx;
            y = posy;
            if (PopUpManager.isPopUp(p) == false)
            {
                PopUpManager.addPopUp(p, true, false);
                setTimeout(Starling.current.stage.addEventListener, 5, TouchEvent.TOUCH, onTouch);
            }
        }
        
        private function onTouch(e:TouchEvent):void 
        {
            if (e.getTouch(Starling.current.stage,TouchPhase.ENDED) && e.getTouch(this, TouchPhase.ENDED) == null)
            {
                hideBox();
                Starling.current.stage.removeEventListener(TouchEvent.TOUCH, onTouch);
            }
        }
        
        public function hideBox():void
        {
            if (previewObject && contains(previewObject))
            {
                removeChild(previewObject);
            }
            
            previewObject = null;
            
            if (PopUpManager.isPopUp(this))
            {
                PopUpManager.removePopUp(this);
            }
        }
        
        public function getPreviewObject():DisplayObject
        {
            return previewObject;
        }
    }
}