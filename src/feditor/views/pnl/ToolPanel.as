package feditor.views.pnl 
{
	import adobe.utils.CustomActions;
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Panel;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledColumnsLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feditor.events.EventType;
	import feditor.views.EmbedAssets;
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author gray
	 */
	public class ToolPanel extends Panel 
	{	
		private var buttonArr:Array;
		
		public function ToolPanel() 
		{
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			this.headerProperties.title = "Tool Box";
			
			buttonArr = ["Dropper","╞","╡","╤","╧","║","═"];
			this.layout = new HorizontalLayout();
			for (var i:int = 0; i < buttonArr.length; i++) 
			{
				var btn:Button = new Button();
				btn.label = buttonArr[i];
				btn.addEventListener(Event.TRIGGERED, toolTriggeredHandler);
				btn.styleName = Button.ALTERNATE_NAME_QUIET_BUTTON;
				btn.width = 32;
				btn.height = 32;
				addChild(btn);
				
				switch (buttonArr[i]) 
				{
					case "Dropper":
						btn.defaultIcon = new Image(Texture.fromBitmap(new EmbedAssets.ICON_DROPPER()));
						break;
					case "layer":
						btn.width = NaN;
						break;
					default:
				}
				buttonArr[i] = btn;
			}
		}
		
		override public function validate():void 
		{
			padding = 5;
			super.validate();
		}
		
		private function toolTriggeredHandler(e:Event):void 
		{
			var index:int = buttonArr.indexOf(e.currentTarget);
			dispatchEventWith(Event.SELECT, false, index);
		}
		
	}

}