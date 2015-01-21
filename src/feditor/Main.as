package feditor 
{
    import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.Check;
    import feathers.controls.Header;
    import feathers.controls.ImageLoader;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.NumericStepper;
    import feathers.controls.PageIndicator;
    import feathers.controls.Panel;
    import feathers.controls.PanelScreen;
    import feathers.controls.ProgressBar;
    import feathers.controls.Radio;
    import feathers.controls.Screen;
    import feathers.controls.ScreenNavigator;
    import feathers.controls.ScrollBar;
    import feathers.controls.Slider;
    import feathers.controls.TabBar;
    import feathers.controls.TextArea;
    import feathers.controls.TextInput;
    import feathers.controls.ToggleButton;
    import feathers.controls.ToggleSwitch;
    import feathers.display.Scale3Image;
    import feathers.display.Scale9Image;
    import feathers.display.TiledImage;
    import feathers.themes.MetalWorksDesktopTheme;
    import feditor.Root;
    import feditor.utils.Assets;
    import feditor.utils.Builder;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.geom.Rectangle;
    import starling.core.Starling;
    import starling.display.Image;
    
    /**
     * 
     * @author gray
     */
    public class Main extends Sprite 
    {
        private var starling:Starling;
        
        public function Main():void 
        {    
            //CONFIG::debug {
                ////new TestCase();
            //}
            stage.addEventListener(Event.RESIZE, resizeHandler);
            starling = new Starling(Root,stage,new Rectangle(0,0,stage.stageWidth,stage.stageHeight));
            starling.addEventListener("rootCreated", rootCreateHandler);
            starling.start();
            
            initializeTools();
        }
        
        private function initializeTools():void
        {
            //
            Builder.initialize({ 
                "Image":Image,
                "Scale3Image":Scale3Image,
                "Scale9Image":Scale9Image,
                "TiledImage":TiledImage,
                "ImageLoader":ImageLoader,
                "Label":Label,
                "Button":Button,
                "TextArea":TextArea,
                "TextInput":TextInput,
                "ToggleSwitch":ToggleSwitch,
                "ToggleButton":ToggleButton,
                "ButtonGroup":ButtonGroup,
                "TabBar":TabBar,
                "ProgressBar":ProgressBar,
                "Check":Check,
                "ImageLoader":ImageLoader,
                "Panel":Panel,
                "NumericStepper":NumericStepper,
                "Radio":Radio,
                "ScrollBar":ScrollBar,
                "ScreenNavigator":ScreenNavigator,
                "Screen":Screen,
                "Header":Header,
                "PageIndicator":PageIndicator,
                "PanelScreen":PanelScreen,
                "Slider":Slider,
                "LayoutGroup":LayoutGroup
            },true);
            
            //
            Assets.initialize(AppFacade.getInstance().assets, true);
            
        }
        
        private function resizeHandler(e:Event):void 
        {
            starling.stage.stageWidth = stage.stageWidth;
            starling.stage.stageHeight = stage.stageHeight;
            starling.viewPort.width = stage.stageWidth;
            starling.viewPort.height = stage.stageHeight;
            
            if (starling.root)
            {
                (starling.root as Root).setSize(stage.stageWidth,stage.stageHeight);
            }
        }
        
        private function rootCreateHandler(e:*):void
        {
            stage.nativeWindow.maximize();
            
            new MetalWorksDesktopTheme();
            (starling.root as Root).setSize(stage.stageWidth, stage.stageHeight);
            
            var dir:File = File.applicationDirectory;
            AppFacade.getInstance().assets.enqueue(
                dir.resolvePath("config"),
                dir.resolvePath("assets")
            );
            AppFacade.getInstance().assets.loadQueue(assetsCompleteHandler);
        }
        
        private function assetsCompleteHandler(ratio:Number):void
        {
            if (ratio == 1)
            {
                (starling.root as Root).startup();
                AppFacade.getInstance().startup(starling.root);
            }
        }
    }
}