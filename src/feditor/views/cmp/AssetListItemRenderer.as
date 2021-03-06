package feditor.views.cmp 
{
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feditor.events.EventType;
    import feditor.utils.Assets;
	import flash.events.MouseEvent;
	import flash.system.System;
	import starling.core.Starling;
	import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    /**
     * ...
     * @author gray
     */
    public class AssetListItemRenderer extends DefaultListItemRenderer 
    {
        
        private var iconSize:int = 40;
        private var image:DisplayObject;
        private var defaultTexture:Texture;
        private var w:int;
        
        public function AssetListItemRenderer() 
        {
            super();
            
            this.defaultTexture = Texture.empty(iconSize, iconSize);
            image = new Image(defaultTexture);
            defaultIcon = image;
            
            this.addEventListener(TouchEvent.TOUCH, touchHandler);
        }
        
        protected function touchHandler(event:TouchEvent):void 
        {
            var touch:Touch = event.getTouch(this, TouchPhase.HOVER);
            if (touch)
            {
                dispatchEventWith(EventType.PREVIEW,true,[_data,touch.globalX,touch.globalY]);
            }
        }
        
        override protected function commitData():void 
        {
            super.commitData();
			
			if (image)
			{
				image.removeFromParent(true);
			}
			
            image = Assets.getImage(String(data));
            if (image)
            {
                var w:int = image.width;
                var h:int = image.height;
                var scale:Number = w > h?(iconSize / w):(iconSize / h);
                image.width = scale * w;
                image.height = scale * h;
                defaultIcon = image;
            }
        }
    }

}