package feditor.controllers 
{
    import feditor.models.SelectElementsProxy;
	import feditor.NS;
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
				try 
				{
					Builder.setFields(control,valueMap);
				}
				catch (err:Error)
				{
					sendNotification(NS.NOTE_ERROR_NOTIFICATION,"FieldUpdateCmd-"+err.message);
				}
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