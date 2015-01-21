package feditor.controllers 
{
    import feathers.controls.LayoutGroup;
    import feditor.models.ControlDescriptionProxy;
    import feditor.NS;
    import feditor.utils.FieldConst;
    import feditor.utils.Reflect;
    import feditor.vo.CreateVO;
    import feditor.vo.FieldVO;
    import flash.utils.getQualifiedClassName;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class CreateFormDataCmd extends SimpleCommand 
    {
        
        public function CreateFormDataCmd() 
        {
            super();
            
        }
        
        override public function execute(notification:INotification):void 
        {
            var cvo:CreateVO = notification.getBody() as CreateVO;
            if (cvo==null)
            {
                trace("need CreateVO");
                return;
            }
            
            var forLayoutGroup:String = "";
            
            if (cvo.target)
            {
                var ns:String = getQualifiedClassName(cvo.target);
                ns = ns.split("::")[1];
                
                if (descriptionProxy.isSurported(ns) && cvo.fields)
                {
                    var fieldOlder:Array = descriptionProxy.getProperitesOlder(ns) || [];
                    cvo.fields = cvo.fields.filter(function(item:FieldVO, index:int, array:Array):Boolean {
                        return fieldOlder.indexOf(item.name) != -1;
                    });
                    
                    cvo.fields = createFullFieldList(ns,cvo.fields);
                    
                    cvo.fields = cvo.fields.sort(function(a:FieldVO, b:FieldVO):int {
                        if (fieldOlder.indexOf(a.name) >= fieldOlder.indexOf(b.name))
                        {
                            return 1;
                        }
                        return -1;
                    });
                }
                
                if (cvo.target is LayoutGroup)
                {
                    var hasLayout:Boolean = false;
                    for each (var item:FieldVO in cvo.fields) 
                    {
                        if (item.name == FieldConst.LAYOUT)
                        {
                            if (item.value == FieldConst.LAYOUT_HORIZONTAL || item.value == FieldConst.LAYOUT_VERTICAL)
                            {
                                hasLayout = true;
                            }
                            break;
                        }
                    }
                    
                    for each (item in cvo.fields) 
                    {
                        switch (item.name) 
                        {
                            case FieldConst.LAYOUT_GAP:
                            case FieldConst.LAYOUT_PADDING:
                            case FieldConst.LAYOUT_PADDING_LEFT:
                            case FieldConst.LAYOUT_PADDING_RIGHT:
                            case FieldConst.LAYOUT_PADDING_TOP:
                            case FieldConst.LAYOUT_PADDING_BOTTOM:
                            case FieldConst.LAYOUT_HORIZONTAL_ALIGN:
                            case FieldConst.LAYOUT_VERTICAL_ALIGN:
                                item.editable = hasLayout;
                            break;
                            default:
                        }
                    }
                }
                
                var typeDes:FieldVO = new FieldVO();
                typeDes.name = "Control Type";
                typeDes.value = ns;
                typeDes.editable = false;
                
                cvo.fields.unshift(typeDes);
            }
            
            sendNotification(NS.NOTE_FORM_DATA_CREATED,cvo.fields);
        }
        
        public function createFullFieldList(ns:String,result:Array):Array
        {
            result ||= [];
            var child:Array = [];
            var map:Object = descriptionProxy.getDescription(ns);
            for (var name:String in map) 
            {
                var has:Boolean = false;
                for each (var item:FieldVO in result) 
                {
                    if (item.name == name)
                    {
                        has = true;
                        break;
                    }
                }
                
                if (has) continue;
                
                var fvo:FieldVO = new FieldVO();
                fvo.name = name;
                fvo.value = "";
                child.push(fvo);
                
                if (name == "color")
                {
                    trace(name);
                }
            }
            
            result.push.apply(null, child);
            
            return result;
        }
        
        public function get descriptionProxy():ControlDescriptionProxy
        {
            return facade.retrieveProxy(ControlDescriptionProxy.NAME) as ControlDescriptionProxy;
        }
    }
}