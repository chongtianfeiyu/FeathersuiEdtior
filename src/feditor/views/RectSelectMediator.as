package feditor.views 
{
	import feditor.events.EventType;
    import feditor.models.EStageProxy;
    import feditor.models.SelectElementsProxy;
    import feditor.NS;
    import feditor.utils.Builder;
    import feditor.utils.Geom;
    import feditor.utils.ObjectUtil;
    import feditor.utils.Reflect;
    import feditor.views.pnl.RectSelect;
    import feditor.vo.CreateVO;
    import feditor.vo.FieldVO;
    import flash.geom.Rectangle;
    import flash.utils.getQualifiedClassName;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import starling.display.DisplayObject;
    import starling.events.Event;
	import starling.events.TouchPhase;
    
    /**
     * ...
     * @author gray
     */
    public class RectSelectMediator extends Mediator 
    {
        public static const NMAE:String = "RectSelectMediator";
		private var isChanged:Boolean = false;
		
        public function RectSelectMediator(viewComponent:Object=null) 
        {
            super(NMAE, viewComponent);
        }
        
        override public function onRegister():void 
        {
            super.onRegister();
            pnl.addEventListener(Event.CHANGE, changeHandler);
			pnl.addEventListener(TouchPhase.ENDED, touchEndHandler);
			pnl.addEventListener(TouchPhase.BEGAN, touchBegnHandler);
        }
		
		private function touchBegnHandler(e:Event):void 
		{
			isChanged = false;
		}
		
		private function touchEndHandler(e:Event):void 
		{
			isChanged = false;
		}
        
        private function changeHandler(e:Event):void 
        {
			if (isChanged == false)
			{
				isChanged = true;
				sendNotification(NS.CMD_CREATE_SNAPSHOT);
			}
            formDataReady();
        }
        
        override public function listNotificationInterests():Array 
        {
            return [
                NS.NOTE_RECT_SELECT,
                NS.NOTE_UN_RECT_SELECT,
                NS.NOTE_SELECT_ITEM_DATA_UPDATE,
                NS.NOTE_CREATE_PORJECT,
				NS.NOTE_RECT_FOCUS_UPDATE
            ];
        }
		
        override public function handleNotification(notification:INotification):void 
        {
            switch (notification.getName()) 
            {
                case NS.NOTE_CREATE_PORJECT:
                    selectProxy.clear();
					break;
				case NS.NOTE_RECT_FOCUS_UPDATE:
					pnl.updateFocus();
					break;
                case NS.NOTE_RECT_SELECT:
                    break;
                case NS.NOTE_SELECT_ITEM_DATA_UPDATE:
                    pnl.clearFocus();
                    for each (var item:DisplayObject in selectProxy.selectedItems) 
                    {
                        if (item) pnl.joinFocus(item);
                    }
                    if (selectProxy.selectedItems.length > 0)
                    {
                        pnl.startJob();
                    }
                    formDataReady();
					isChanged = false;
                    break;
                default:
            }
        }
        
        private function formDataReady():void
        {
            var cvo:CreateVO = new CreateVO();
            
            if (selectProxy.selectedItems.length==1)
            {
                cvo.target = selectProxy.getSelectedControl();
                cvo.fields = getFieldVOListOf(cvo.target);
            }
            else if(selectProxy.selectedItems.length>1)
            {
                cvo.target == "group";
                var fvo:FieldVO = new FieldVO();
                fvo.name = "many elements";
                fvo.value = "TODO....";
                fvo.editable = false;
                cvo.fields = [fvo];
                //
                var rect:Rectangle = Geom.getBound(selectProxy.selectedItems);
                for (var key:String in ObjectUtil.copy(rect))
                {
                    switch (key) 
                    {
                        case "width":
                        case "height":
                            var rvo:FieldVO = new FieldVO();
                            rvo.editable = false;
                            rvo.name = key;
                            rvo.value = rect[key];
                            cvo.fields.push(rvo);
                        break;
                        default:
                    }
                }
            }
            else if(selectProxy.selectedItems.length==0)
            {
                cvo.fields = [];
                var tvo:FieldVO = new FieldVO();
                tvo.name = "Control Type";
                tvo.value = "stage";
                tvo.editable = false;
                cvo.fields.push(tvo);
                
                //w
                var w:FieldVO = new FieldVO();
                w.name = "witdh";
                w.value = String(estageoProxy.witdth);
                w.editable = false;
                cvo.fields.push(w);
                
                var h:FieldVO = new FieldVO();
                h.name = "height";
                h.value = String(estageoProxy.height);
                h.editable = false;
                cvo.fields.push(h);
                
                var c:FieldVO = new FieldVO();
                c.name = "color";
                c.value = String(estageoProxy.color);
                c.editable = false;
                cvo.fields.push(c);
                
                var p:FieldVO = new FieldVO();
                p.name = "img alpha";
                p.value = String(estageoProxy.designImageAlpha);
                cvo.fields.push(p);
            }
            
            sendNotification(NS.CMD_FORM_DATA_CREATE,cvo);
        }
        
        private function getFieldVOListOf(displayObject:DisplayObject):Array
        {
            var fields:Array = getFieldVOList(displayObject) || [];
            var ns:String = getQualifiedClassName(displayObject);
            return fields;
        }
        
        /**
         * 返回Builder 支持的属性数组 [FieldVO]
         * @param obj
         * @return
         */
        private function getFieldVOList(obj:Object):Array
        {
            var result:Array = [];
            
            var properties:Object = Reflect.getFieldMap(obj);
            
            for (var name:String in properties) 
            {
                var field:FieldVO = new FieldVO();
                field.name = name;
                field.value = properties[name]?String(properties[name]):"";
                result.push(field);
            }
            
            return result;
        }
        
        public function get pnl():RectSelect
        {
            return viewComponent as RectSelect;
        }
        
        public function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
        
        public function get estageoProxy():EStageProxy
        {
            return facade.retrieveProxy(EStageProxy.NAME) as EStageProxy;
        }
    }

}