package feditor.controllers 
{
	import feathers.controls.Label;
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
				
				if (cvo.target is Label)
				{
					for each (var item:FieldVO in cvo.fields) 
					{
						if (item.name == "width" || item.name == "height")
						{
							item.editable = false;
						}
					}
				}
                
                var typeDes:FieldVO = new FieldVO();
                typeDes.name = FieldConst.THE_TYPE;
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
            var map:Object = descriptionProxy.getDescriptionMap(ns);
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
                child.push(fvo);
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