package feditor.views 
{
    import feditor.models.EStageProxy;
    import feditor.models.SelectElementsProxy;
    import feditor.NS;
    import feditor.utils.Builder;
    import feditor.views.pnl.EditorStage;
    import flash.geom.Point;
    import flash.ui.Keyboard;
    import flash.utils.setTimeout;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.KeyboardEvent;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    /**
     * ...
     * @author gray
     */
    public class EdiatorStageMediator extends Mediator 
    {
        public static const NAME:String = "EdiatorStageMediator";
        
        private var _isActive:Boolean = false;
        
        public function EdiatorStageMediator(viewComponent:Object=null) 
        {
            super(NAME, viewComponent);
        }
        
        override public function listNotificationInterests():Array 
        {
            return [
                NS.NOTE_IMPORT_XML_COMPLETE,
                NS.NOTE_PLACE_CONTROL_TO_STAGE,
                NS.NOTE_ESTAGE_REFRESH,
                NS.NOTE_CREATE_PORJECT,
                NS.NOTE_IMPORT_PICTURE,
                NS.NOTE_IMPORT_PICTURE_APLHA
            ];
        }
        
        override public function handleNotification(notification:INotification):void 
        {
            switch (notification.getName()) 
            {
                case NS.NOTE_IMPORT_XML_COMPLETE:
                    var xml:XML = notification.getBody() as XML;
                    if (xml)
                    {
                        pnl.clearStage();
                        Builder.build(pnl.childContainer,xml);
                    }
                    break;
                case NS.NOTE_PLACE_CONTROL_TO_STAGE:
                    pnl.placeControl(notification.getBody() as DisplayObject);
					selectProxy.clear();
                    selectProxy.addItem(notification.getBody() as DisplayObject);
                    break;
                case NS.NOTE_ESTAGE_REFRESH:
                    pnl.initEStage(estageProxy.witdth,estageProxy.height,estageProxy.color);
                    break;
                case NS.NOTE_CREATE_PORJECT:
                    pnl.clearStage();
                    break;
                case NS.NOTE_IMPORT_PICTURE:
                    (notification.getBody() as Image).alpha = estageProxy.designImageAlpha;
                    pnl.placeDesignImage(notification.getBody() as Image);
                    break;
                case NS.NOTE_IMPORT_PICTURE_APLHA:
                    estageProxy.designImageAlpha = Number(notification.getBody());
                    pnl.setDesignImageAlpha(Number(notification.getBody()));
                    break;
                default:
            }
        }
        
        override public function onRegister():void 
        {
            super.onRegister();
            Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, editorStageKeyDownHandler);
            Starling.current.stage.addEventListener(TouchEvent.TOUCH, editorStageTouchHandler);
        }
        
        private function editorStageTouchHandler(e:TouchEvent):void 
        {
            var touch:Touch = e.getTouch(Starling.current.stage);
            if (touch == null)
            {
                return;
            }
            
            switch (touch.phase) 
            {
                case TouchPhase.BEGAN:
                    touchBenginHandler(e);
                    break;
                case TouchPhase.ENDED:
                    touchEndHandler(e);
                    break;
                case TouchPhase.MOVED:
                    touchMoveHandler(e);
                    break;
                default:
            }
        }
        
        private function touchBenginHandler(e:TouchEvent):void
        {
            var touch:Touch = e.getTouch(pnl, TouchPhase.BEGAN);
            if (touch == null)
            {
                _isActive = false;
                return;
            }
            
            _isActive = true;
            
            pnl.validate();
            var touchObj:DisplayObject = touchChild(e);
            if (touchObj)
            {
                if (e.ctrlKey)
                {
                    //TODO
                    //touch begin 和其他选区的功能冲突。
                    //ctrl + mouse left 选取和取消选取，在touch end 中实现
                }
                else
                {
                    selectProxy.clear();
                    selectProxy.addItem(touchObj);
                }
            }
            else
            {
                if (e.getTouch(pnl.selectContainer)==null)
                {
                    selectProxy.clear();
                    sendNotification(NS.NOTE_RECT_CHECK,new Point(touch.globalX,touch.globalY));
                }
            }
        }
        
        private function touchMoveHandler(e:TouchEvent):void
        {
            
        }
        
        private function touchEndHandler(e:TouchEvent):void
        {
             var touchObj:DisplayObject = touchChild(e);
            if (touchObj)
            {
                if (e.ctrlKey)
                {
                    if (selectProxy.selectedItems.indexOf(touchObj) == -1)
                    {
                        selectProxy.addItem(touchObj);
                    }
                    else
                    {
                        //取消选中由于 RectSelect 对象给覆盖了无法点击到。此时touchObj 是空的
                        selectProxy.removeItem(touchObj);
                    }
                }
            }
        }
        
        private function editorStageKeyDownHandler(e:KeyboardEvent):void 
        {
            if (_isActive == false)
            {
                trace("shortcut is invalid outof eidtor stage");
                return;
            }
            
            switch (e.keyCode)
            {
                case Keyboard.DELETE:
                    if(selectProxy.hasData) sendNotification(NS.CMD_DELETE_SELECT);
                    break;
                case Keyboard.LEFT:
                case Keyboard.W:
                    if(selectProxy.hasData) sendNotification(NS.CMD_MOVE_LEFT);
                    break;
                case Keyboard.RIGHT:
                case Keyboard.D:
                    if(selectProxy.hasData) sendNotification(NS.CMD_MOVE_RIGHT);
                    break;
                case Keyboard.UP:
                case Keyboard.W:
                    if(selectProxy.hasData) sendNotification(NS.CMD_MOVE_UP);
                    break;
                case Keyboard.DOWN:
                case Keyboard.S:
                    if(selectProxy.hasData) sendNotification(NS.CMD_MOVE_DOWN);
                    break;
                case Keyboard.X:
                    if (e.ctrlKey) sendNotification(NS.CMD_CUT);
                    break;
                case Keyboard.A:
                    if (e.ctrlKey) sendNotification(NS.CMD_SELECT_ALL);
                    break;    
                case Keyboard.C:
                    if (e.ctrlKey) sendNotification(NS.CMD_COPY);
                    break;
                case Keyboard.V:
                    if (e.ctrlKey) sendNotification(NS.CMD_PASTE);
                    break;
                case Keyboard.B:
                    if (e.ctrlKey) sendNotification(NS.CMD_UN_GROUP_SELECT);
                    break;
                case Keyboard.G:
                    if (e.ctrlKey) sendNotification(NS.CMD_GROUP_SELECT);
                    break;
                case Keyboard.W:
                    if (e.ctrlKey) sendNotification(NS.CMD_LAYER_UP);
                    break;
                case Keyboard.S:
                    if (e.ctrlKey) sendNotification(NS.CMD_LAYER_DOWN);
                    break;
                case Keyboard.Z:
                    if (e.ctrlKey) trace("TODO:: undo command is not be implemented");
                    break;
                default:
            }
        }
        
        private function touchChild(e:TouchEvent):DisplayObject
        {
            var result:DisplayObject;
            for each (var item:DisplayObject in pnl.getChildrens()) 
            {
                if (e.getTouch(item))
                {
                    result = item;
                    break;
                }
            }
            return result;
        }
        
        public function get pnl():EditorStage
        {
            return viewComponent as EditorStage;
        }
        
        public function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
        
        public function get estageProxy():EStageProxy
        {
            return facade.retrieveProxy(EStageProxy.NAME) as EStageProxy;
        }
    }

}