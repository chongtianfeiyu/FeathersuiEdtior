package feditor.views.pnl 
{
	import adobe.utils.CustomActions;
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.layout.HorizontalLayout;
	import feditor.events.EventType;
	import feditor.views.EmbedAssets;
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author gray
	 */
	public class ToolPanel extends LayoutGroup 
	{	
		private var buttonArr:Array;
		
		public function ToolPanel() 
		{
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			var boxLayout:HorizontalLayout = new HorizontalLayout();
			boxLayout.gap = 5;
			boxLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			boxLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			this.layout = boxLayout;
			
			buttonArr = [EmbedAssets.ICON_DROPPER];
				
			var img:Image;
			for (var i:int = 0; i < buttonArr.length; i++) 
			{
				var def:* = buttonArr[i];
				img = new Image(Texture.fromBitmap(new def()));
				img.color = 0xffffffff;
				var btn:Button = new Button();
				buttonArr[i] = btn;
				btn.width = 20;
				btn.height = 20;
				btn.defaultIcon = img;
				
				addChild(btn);
				btn.addEventListener(Event.TRIGGERED, toolTriggeredHandler);
			}
			
			backgroundSkin = new Quad(20, 20, 0xff262626);
			
			var dropperCursor:MouseCursorData = new MouseCursorData();
			var cursorData:Vector.<BitmapData> = new Vector.<BitmapData>();
			cursorData.push(new EmbedAssets.ICON_DROPPER().bitmapData);
			dropperCursor.data = cursorData;
			Mouse.registerCursor("dropper", dropperCursor);
		}
		
		private function toolTriggeredHandler(e:Event):void 
		{
			switch (buttonArr.indexOf(e.currentTarget)) 
			{
				case 0:
					dispatchEventWith(EventType.DROPPER);
				break;
				default:
			}
		}
		
	}

}