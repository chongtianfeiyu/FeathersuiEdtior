package feditor.controllers 
{
    import feditor.models.SelectElementsProxy;
    import feditor.utils.Builder;
    import feditor.vo.FieldVO;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class FieldUpdateCmd extends SimpleCommand 
    {
        
        public function FieldUpdateCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            var control:* = selectProxy.getSelectedControl();
            var fvo:FieldVO = notification.getBody() as FieldVO;
            if (control && fvo)
            {
                var valueMap:Object = { };
                valueMap[fvo.name] = fvo.value;
                Builder.setFields(control,valueMap);
            }
            else
            {
                trace("FieldUpdateCmd - field update error");
            }
        }
        
        public function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
    }

}