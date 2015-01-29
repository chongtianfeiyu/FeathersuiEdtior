package feditor.views.pnl 
{
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.Panel;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author gray
	 */
	public class NotificationPanel extends Panel 
	{
		private var notificationList:List;
		private var confirmButton:Button;
		public function NotificationPanel() 
		{
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			this.headerProperties.title = "Notification";
			var boxLayout:VerticalLayout = new VerticalLayout();
			boxLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			this.layout = boxLayout;
			
			notificationList = new List();
			notificationList.maxHeight = 500;
			addChild(notificationList);
			
			confirmButton = new Button();
			confirmButton.styleName = Button.ALTERNATE_NAME_DANGER_BUTTON;
			confirmButton.label = "close";
            addChild(confirmButton);
			
			this.minWidth = 500;
			
			confirmButton.addEventListener(Event.TRIGGERED,closeHandler);
		}
		
		public function showNotification(note:Object,clearHistory:Boolean=false):void
		{
			if (PopUpManager.isPopUp(this) == false)
			{
				PopUpManager.addPopUp(this);
			}
			
			if (clearHistory)
			{
				notificationList.dataProvider = null;
			}
			
			if (notificationList.dataProvider)
			{
				notificationList.dataProvider.addItemAt(note,0)
			}
			else
			{
				notificationList.dataProvider = new ListCollection([note]);
			}
		}
		
		private function closeHandler(e:Event):void 
		{
			if (PopUpManager.isPopUp(this))
			{
				PopUpManager.removePopUp(this);
			}
		}
		
	}

}