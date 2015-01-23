package feditor.views.pnl 
{
    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;
    import feditor.utils.Assets;
    import feditor.utils.Builder;
    import feditor.utils.describeView;
    import feditor.utils.GroupUtil;
    import feditor.utils.ObjectUtil;
    import feditor.utils.Reflect;
    import feditor.vo.FieldVO;
    import flash.geom.Point;
    import flash.ui.Keyboard;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import flash.utils.getQualifiedClassName;
    
    /**
     * ...
     * @author gray
     */
    public class EditorStage extends LayoutGroup 
    {    
        public static const INIT_EDITOR:String = "initEditor";
        private var _backgroundColor:uint;
        private var childrens:Vector.<DisplayObject> = new Vector.<DisplayObject>();;
        private var offset:Point = new Point();
        private var active:Boolean = false;
        private var _selectContainer:Sprite;
        private var _childContainer:LayoutGroup;
        //private var bg:Quad;
        private var designImage:Image;
        
        public function EditorStage() 
        {
            super();
        }
        
        override protected function initialize():void 
        {
            super.initialize();
            _childContainer = new LayoutGroup();
            
            addChild(_childContainer);
            addChild(selectContainer);
        }
        
        public function getChildrens():Vector.<DisplayObject>
        {
            childrens.length = 0;
            for (var i:int = 0; i < childContainer.numChildren; i++) 
            {
                var displayObject:DisplayObject = childContainer.getChildAt(i);
                childrens[i] = displayObject;
            }
            return childrens;
        }
        
        public function clearStage():void
        {
            childrens.length = 0;
            for (var i:int = 0; i < childContainer.numChildren; i++) 
            {
                childContainer.removeChildren();
            }
            
            if (designImage)
            {
                if (contains(designImage)) removeChild(designImage);
                designImage.texture.dispose();
                designImage.dispose();
            }
        }
        
        public function placeDesignImage(img:Image):void
        {
            if (designImage)
            {
                if (contains(designImage)) removeChild(designImage);
                designImage.texture.dispose();
                designImage.dispose();
            }
            
            if (img)
            {
                designImage = img;
                designImage.touchable = false;
                addChildAt(designImage, 0);
                designImage.width = backgroundSkin.width;
                designImage.height = backgroundSkin.height;
            }
        }
        
        public function setDesignImageAlpha(value:Number):void
        {
            if (designImage)
            {
                designImage.alpha = value;
            }
        }
        
        public function placeControl(displayObject:DisplayObject):void
        {
            if (displayObject)
            {
                if (parent)
                {
                    if(parent.x <0) displayObject.x -= int(parent.x);
                    if(parent.y <0) displayObject.y -= int(parent.y);
                }
                childContainer.addChild(displayObject);
            }
        }
        
        public function initEStage(w:int,h:int,rgb:int):void
        {   
            backgroundSkin = new Quad(100, 100, rgb | 0xff000000);
            width = w;
            height = h;
            minWidth = w;
            minWidth = h;
            maxWidth = w;
            maxHeight = h;

            _childContainer.y = 0;
            selectContainer.y = 0;
            _childContainer.x = 0;
            selectContainer.x = 0;
            
            dispatchEventWith(INIT_EDITOR,true);
        }
        
        public function get selectContainer():Sprite 
        {
            if (!_selectContainer)
            {
                _selectContainer = new Sprite();
                addChild(_selectContainer);
            }
            return _selectContainer;
        }
        
        public function get childContainer():Sprite 
        {
            return _childContainer;
        }
    }

}