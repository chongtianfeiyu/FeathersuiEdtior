package feditor.views 
{
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author gray
	 */
	public class ToolPanelMeditor extends Mediator 
	{
		public static const NAME:String = "ToolPanelMeditor";
		public function ToolPanelMeditor(viewComponent:Object=null) 
		{
			super(NAME, viewComponent);
		}
		
	}

}