package feditor.views 
{
	import feathers.controls.ScrollContainer;
	import feathers.controls.supportClasses.LayoutViewPort;
	import feditor.models.ColorDropperProxy;
	import feditor.models.EStageProxy;
	import feditor.NS;
	import feditor.utils.FieldConst;
	import feditor.views.pnl.ColorDropper;
	import feditor.vo.FieldVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author gray
	 */
	public class ColorDropperMediator extends Mediator 
	{
		public static const NAME:String = "ColorDropperMediator";
		public function ColorDropperMediator(viewComponent:Object=null) 
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void 
		{
			super.onRegister();
			pnl.addEventListener(Event.SELECT,colorSelectHandler);
		}
		
		private function colorSelectHandler(e:Event):void 
		{
			var fieldVO:FieldVO = new FieldVO();
			fieldVO.name = FieldConst.FONT_COLOR;
			fieldVO.value = String(e.data);
			sendNotification(NS.CMD_FIELD_UPDATE, fieldVO);
			estageProxy.isDrop = false;
		}
		
		override public function listNotificationInterests():Array 
		{
			return [
				NS.NOTE_SHOW_COLOR_DROPPER,
				NS.NOTE_HIDE_COLOR_DROPPER
			];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch (notification.getName()) 
			{
				case NS.NOTE_HIDE_COLOR_DROPPER:
					pnl.hide();
					colorDropperProxy.color = pnl.color;
					estageProxy.isDrop = false;
					break;
				case NS.NOTE_SHOW_COLOR_DROPPER:
					pnl.show(colorDropperProxy.getSource(), estageProxy.witdth, estageProxy.height);
					estageProxy.isDrop = true;
					break;
				default:
			}
		}
		
		public function get pnl():ColorDropper
		{
			return viewComponent as ColorDropper;
		}
		
		private function get colorDropperProxy():ColorDropperProxy
		{
			return facade.retrieveProxy(ColorDropperProxy.NAME) as ColorDropperProxy;
		}
		
		private function get estageProxy():EStageProxy
		{
			return facade.retrieveProxy(EStageProxy.NAME) as EStageProxy;
		}
	}

}