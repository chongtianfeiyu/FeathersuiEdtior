package feditor.controllers 
{
    import feditor.AppFacade;
    import feditor.NS;
    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.display.StageDisplayState;
    import flash.events.Event;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    import starling.core.Starling;
    
    /**
     * ...
     * @author gray
     */
    public class CreateNativeMenuCmd extends SimpleCommand 
    {
        public function CreateNativeMenuCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            var menuTree:Array = [
                {
                    "name":"file", 
                    "sub":["New Project","open", "save","fullScreen","importPicture"] 
                },
                {
                    "name":"help",
                    "sub":["information","version 1.0.0"]
                }
            ];
            
            function menuHandler(e:Event):void
            {
                var item:NativeMenuItem = e.currentTarget as NativeMenuItem;
                switch (item.label) 
                {
                    case "New Project":
                        AppFacade.getInstance().sendNotification(NS.CMD_CREATE_PROJECT);
                        break;
                    case "open":
                        AppFacade.getInstance().sendNotification(NS.CMD_IMPORT_XML);
                        break;
                    case "save":
                        AppFacade.getInstance().sendNotification(NS.CMD_EXPORT_XML);
                        break;
                    case "fullScreen":
                        Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN;
                        break;
                    case "importPicture":
                        AppFacade.getInstance().sendNotification(NS.CMD_IMPORT_PICTURE);
                        break;
                    default:
                }
            }
            
            var menu:NativeMenu = new NativeMenu();
            
            for each (var item:Object in menuTree) 
            {
                var menuItem:NativeMenuItem = new NativeMenuItem(item.name);
                menu.addItem(menuItem);
                var subInfo:Array = item.sub;
                if (subInfo)
                {
                    var subMenu:NativeMenu = new NativeMenu();
                    menuItem.submenu = subMenu;
                    for each (var sub:String in subInfo) 
                    {
                        var subItem:NativeMenuItem = new NativeMenuItem(sub);
                        subMenu.addItem(subItem);
                        
                        subItem.addEventListener(Event.SELECT, menuHandler);
                    }
                }
            }
            
            Starling.current.nativeStage.nativeWindow.menu = menu;
            
            facade.removeCommand(NS.CMD_CREATE_NATIVE_MENU);
        }
    }

}