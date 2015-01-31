package feditor.controllers 
{
    import adobe.utils.CustomActions;
    import feditor.models.SelectElementsProxy;
    import feditor.NS;
    import feditor.utils.Geom;
    import feditor.views.EdiatorStageMediator;
    import feditor.views.pnl.EditorStage;
    import flash.geom.Rectangle;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.display.DisplayObject;
    
    /**
     * ...
     * @author gray
     */
    public class EStageRectCheckCmd extends SimpleCommand 
    {
        
        public function EStageRectCheckCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            var rect:Rectangle = Rectangle(notification.getBody());
            if (rect == null) return;
            
            var inRectElements:Array = [];
            var itemRect:Rectangle;
            
            for each (var item:DisplayObject in editorStage.getChildrens()) 
            {
				if (item.visible)
				{
					itemRect = new Rectangle(item.x, item.y, item.width, item.height);
					if(Geom.isCross(rect,itemRect))
					{
						inRectElements.push(item);
					}
				}
            }
            
            sendNotification(NS.NOTE_RESULT_RECT_CHECK, inRectElements);
            selectProxy.addItems(inRectElements);
        }
        
        public function get editorStage():EditorStage
        {
            return (facade.retrieveMediator(EdiatorStageMediator.NAME) as EdiatorStageMediator).pnl;
        }
        
        public function get selectProxy():SelectElementsProxy
        {
            return facade.retrieveProxy(SelectElementsProxy.NAME) as SelectElementsProxy;
        }
        
    }

}