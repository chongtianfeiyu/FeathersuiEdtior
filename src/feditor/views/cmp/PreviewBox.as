package feditor.views.cmp 
{
    import feathers.controls.Button;
    import feathers.controls.Check;
    import feathers.controls.LayoutGroup;
    import feathers.controls.Panel;
    import feathers.core.PopUpManager;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    import feditor.events.EventType;
    import feditor.utils.Assets;
    import feditor.utils.Builder;
    import feditor.utils.TextureMap;
    import flash.utils.setTimeout;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Quad;
	import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    /**
     * ...
     * @author gray
     */
    public class PreviewBox extends LayoutGroup 
    {
        private var image:Image;
        private var xmlDefine:*;
        private var control:DisplayObject;
		private var childX:int;
		private var childY:int;
        
        public function PreviewBox()
        {
            super();
        }
        
        public function previewControl(xmlDefine:*,posx:int,posy:int):void
        {
			childX = posx;
			childY = posy;
			
            if (image)
            {
                image.dispose();
                removeChild(image);
            }
            
            if (this.xmlDefine && String(xmlDefine.@libName) == String(this.xmlDefine.@libName))
            {
                return;
            }
            
            if (xmlDefine)
            {
                if (control && contains(control))
                {
                    removeChild(control);
                    control.dispose();
                    control = null;
                }
                
                this.xmlDefine = xmlDefine;
                Builder.build(this, xmlDefine);
                control = getChildAt(0);
                control.x = posx;
				control.y = posy;
            }
            else
            {
                return;
            }
            
            if (PopUpManager.isPopUp(this)==false)
            {
                PopUpManager.addPopUp(this, false, false);
                Starling.current.stage.addEventListener(TouchEvent.TOUCH,touchHandler);
            }
        }
		
		override protected function child_resizeHandler(event:Event):void 
		{
			super.child_resizeHandler(event);
			if (control)
			{
				control.y = childY - control.height * 0.5;
				if (control.y < 0) control.y = 0;
			}
		}
        
        public function previewImage(imageName:String,posx:int=0,posy:int=0):void
        {
            var textrue:Texture = Assets.assets.getTexture(imageName);
            if (!textrue) 
            {
                hide();
                return;
            }
            
            if (image && image.texture == textrue)
            {
                return;
            }
            
            if (control && contains(control))
            {
                control.dispose();
                removeChild(control);
                control = null;
            }
            
            if (!image)
            {
                if (textrue)
                {
                    image = new Image(textrue);
                    addChild(image);
                }
            }
            else
            {
                image.texture = textrue;
                if (contains(image) == false)
                {
                    addChild(image);
                }
            }
            
            image.x = posx;
            image.y = posy - image.height*0.5;
            image.name = imageName;
            image.width = textrue.width;
            image.height = textrue.height;
            
            if (image.y + image.height > Starling.current.stage.stageHeight)
            {
                image.y = Starling.current.stage.stageHeight - image.height;
            }
            
            if (PopUpManager.isPopUp(this)==false)
            {
                PopUpManager.addPopUp(this, false, false);
                Starling.current.stage.addEventListener(TouchEvent.TOUCH,touchHandler);
            }
        }
        
        private function touchHandler(e:TouchEvent):void 
        {
            if (e.getTouch(this,TouchPhase.BEGAN) == null && e.getTouch(stage,TouchPhase.BEGAN))
            {
                hide();
            }
            else if (image && e.getTouch(image, TouchPhase.BEGAN))
            {
                removeChild(image);
                
                var img:* = Assets.getImage(image.name);
                if (img)
                {
                    img.x = 0;
                    img.y = image.y;
                    image.dispose();
                    dispatchEventWith(EventType.ASSET_PLACE, false, img);
                }
                hide();
            }
            else if (control && e.getTouch(control, TouchPhase.BEGAN))
            {
                control.x = 0;
                dispatchEventWith(EventType.ASSET_PLACE, false, control);
                control = null;
                hide();
            }
        }
        
        public function hide():void
        {
            if (image && contains(image))
            {
                removeChild(image);
            }
            
            xmlDefine = null;
            if (control)
            {
                if (contains(control))
                {
                    removeChild(control);
                }
                control.dispose();
            }
            
            if (PopUpManager.isPopUp(this))
            {
                PopUpManager.removePopUp(this);
            }
            
            Starling.current.stage.removeEventListener(TouchEvent.TOUCH,touchHandler);
        }
    }
}