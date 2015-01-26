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
			
			var button:Button = new Button();
			button.defaultIcon = new Image(Texture.fromBitmap(new EmbedAssets.ICON_DROPPER()));
			button.width = 32;
			button.height = 32;
			button.addEventListener(Event.TRIGGERED, toolTriggeredHandler);
			button.styleName = Button.ALTERNATE_NAME_QUIET_BUTTON;
			addChild(button);
			
			buttonArr = ["╞","╡","╤","╧","║","═"];
			var tileLayout:TiledRowsLayout = new TiledRowsLayout();
			tileLayout.requestedColumnCount = 2;
			tileLayout.gap = 0;
			//this.layout = tileLayout;
			this.layout = new HorizontalLayout();
			tileLayout.padding = 0;
			for (var i:int = 0; i < buttonArr.length; i++) 
			{
				var btn:Button = new Button();
				btn.label = buttonArr[i];
				btn.addEventListener(Event.TRIGGERED, toolTriggeredHandler);
				btn.styleName = Button.ALTERNATE_NAME_QUIET_BUTTON;
				btn.width = 32;
				btn.height = 32;
				addChild(btn);
				buttonArr[i] = btn;
			}
			
			buttonArr.unshift(button);
		}
		
		private function toolTriggeredHandler(e:Event):void 
		{
			var index:int = buttonArr.indexOf(e.currentTarget);
			dispatchEventWith(Event.SELECT, false, index);
			
			if (index == 0)
			{
				var tip:Label = new Label();
				tip.text = "background picture only";
				Callout.show(tip, e.currentTarget as DisplayObject);
			}
		}
		
	}

}