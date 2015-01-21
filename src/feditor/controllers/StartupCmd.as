package feditor.controllers 
{
    import feditor.models.ClipBordProxy;
    import feditor.models.DefaultControlProxy;
    import feditor.models.EStageProxy;
    import feditor.models.SelectElementsProxy;
    import feditor.models.ControlDescriptionProxy;
    import feditor.NS;
    import feditor.Root;
    import feditor.views.cmp.RectCheck;
    import feditor.views.cmp.RectSelect;
    import feditor.views.CmpPnlMediator;
    import feditor.views.CreateProjectPnlMediator;
    import feditor.views.EdiatorStageMediator;
    import feditor.views.pnl.CreateProjectPnl;
    import feditor.views.pnl.WellcomePnl;
    import feditor.views.PreviewBoxMediator;
    import feditor.views.RectCheckMediator;
    import feditor.views.RectSelectMediator;
    import feditor.views.RootMediator;
    import feditor.views.WellcomPnlMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    /**
     * ...
     * @author gray
     */
    public class StartupCmd extends SimpleCommand 
    {
        private var root:Root;
        
        public function StartupCmd() 
        {
            super();
        }
        
        override public function execute(notification:INotification):void 
        {
            root = notification.getBody() as Root;
             
            registerCommand();
            regiseterProxy();
            registerMediator();
            
            sendNotification(NS.CMD_FONTLIB_INJECT);
            sendNotification(NS.APP_INITIALIZED);
            sendNotification(NS.NOTE_WELLECOM);
        }
        
        private function registerCommand():void
        {
            facade.registerCommand(NS.CMD_CALC_RECT_CHECK, EStageRectCheckCmd);
            facade.registerCommand(NS.CMD_CREATE_NATIVE_MENU, CreateNativeMenuCmd);
            facade.registerCommand(NS.CMD_COPY, CopyCmd);
            facade.registerCommand(NS.CMD_SELECT_ALL, SelectAllCmd);
            facade.registerCommand(NS.CMD_CUT, CutCmd);
            facade.registerCommand(NS.CMD_PASTE, PasteCmd);
            facade.registerCommand(NS.CMD_DELETE_SELECT, DeleteCmd);
            facade.registerCommand(NS.CMD_GROUP_SELECT, GroupCmd);
            facade.registerCommand(NS.CMD_UN_GROUP_SELECT, UngroupCmd);
            facade.registerCommand(NS.CMD_FORM_DATA_CREATE, CreateFormDataCmd);
            facade.registerCommand(NS.CMD_FIELD_UPDATE, FieldUpdateCmd);
            facade.registerCommand(NS.CMD_EXPORT_XML, ExprotXMLCmd);
            facade.registerCommand(NS.CMD_IMPORT_XML, ImportXMLCmd);
            facade.registerCommand(NS.CMD_MOVE_LEFT, MovieCmd);
            facade.registerCommand(NS.CMD_MOVE_RIGHT, MovieCmd);
            facade.registerCommand(NS.CMD_MOVE_UP, MovieCmd);
            facade.registerCommand(NS.CMD_MOVE_DOWN, MovieCmd);
            facade.registerCommand(NS.CMD_CREATE_PROJECT, CreateProjectCmd);
            facade.registerCommand(NS.CMD_OPEN_PROJECT, OpenProjectCmd);
            facade.registerCommand(NS.CMD_ESTAGE_INIT, EStageInitializeCmd);
            facade.registerCommand(NS.CMD_LAYER_UP, LayerUpCmd);
            facade.registerCommand(NS.CMD_LAYER_DOWN, LayerDownCmd);
            facade.registerCommand(NS.CMD_FONTLIB_INJECT, FontLibInjectCmd);
            facade.registerCommand(NS.CMD_IMPORT_PICTURE, ImportPictureCmd);
        }
        
        private function regiseterProxy():void
        {
            facade.registerProxy(new ControlDescriptionProxy());
            facade.registerProxy(new DefaultControlProxy());
            facade.registerProxy(new ClipBordProxy());
            facade.registerProxy(new SelectElementsProxy());
            facade.registerProxy(new EStageProxy());
        }
        
        private function registerMediator():void
        {
            facade.registerMediator(new PreviewBoxMediator());
            facade.registerMediator(new RootMediator(root));
            facade.registerMediator(new CreateProjectPnlMediator(new CreateProjectPnl()));
            facade.registerMediator(new WellcomPnlMediator(new WellcomePnl()));
            facade.registerMediator(new CmpPnlMediator(root.cmpPanel));
            facade.registerMediator(new EdiatorStageMediator(root.editorStage));
            facade.registerMediator(new RectCheckMediator(new RectCheck(root.editorStage.selectContainer)));
            facade.registerMediator(new RectSelectMediator(new RectSelect(root.editorStage.selectContainer)));
        }
        
    }

}