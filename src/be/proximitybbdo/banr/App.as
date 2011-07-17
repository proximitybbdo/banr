﻿package be.proximitybbdo.banr {  import be.proximity.framework.events.FrameworkEventDispatcher;  import be.proximitybbdo.banr.data.BannerManager;  import be.proximitybbdo.banr.events.BanrEvent;  import be.proximitybbdo.banr.ui.Row;  import be.proximitybbdo.banr.ui.Settings;    import com.adobe.images.JPGEncoder;  import com.adobe.images.PNGEncoder;    import flash.desktop.ClipboardFormats;  import flash.desktop.NativeDragActions;  import flash.desktop.NativeDragManager;  import flash.display.BitmapData;  import flash.display.Loader;  import flash.display.MovieClip;  import flash.display.Sprite;  import flash.errors.IllegalOperationError;  import flash.errors.MemoryError;  import flash.events.Event;  import flash.events.IOErrorEvent;  import flash.events.MouseEvent;  import flash.events.NativeDragEvent;  import flash.events.TimerEvent;  import flash.filesystem.File;  import flash.filesystem.FileMode;  import flash.filesystem.FileStream;  import flash.net.FileReference;  import flash.net.URLRequest;  import flash.utils.ByteArray;  import flash.utils.Timer;  import flash.utils.setTimeout;     public class App extends Sprite {	public var container:MovieClip;	public var rowscontainer:Sprite;	public var settings:Settings;	public var btnStart:MovieClip;	public var btnClear:MovieClip;	public var processor:MovieClip;		private var containercontent:MovieClip;	private var containermask:MovieClip;		private var imageByteArray:ByteArray;	private var saveFileType:String;	private var saveFileRef:File;	private var loadr:Loader;	private var activeFile:File;		private var w:Number;	private var h:Number;	    public function App() {		this.addEventListener(Event.ADDED_TO_STAGE, run);				stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);		stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDrop);		stage.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, onDragExit);    }	private function run(e:Event):void {		BannerManager.getInstance().init(rowscontainer);				// TODO: add window resizing/scrollbar						// TODO: enable/disable controls when there are no bannres		// TODO: add hover state for buttons		btnStart.addEventListener(MouseEvent.CLICK, processBanners);		btnClear.addEventListener(MouseEvent.CLICK, clear);				FrameworkEventDispatcher.getInstance().addEventListener(BanrEvent.PROCESSING_START, onBannerStarted);		FrameworkEventDispatcher.getInstance().addEventListener(BanrEvent.PROCESSING_ALL_FINISHED, onBannerProcessingAllFinished);				processor.alpha = 0;		btnStart.enabled = false;	}		private function processBanners(e:MouseEvent):void {		FrameworkEventDispatcher.getInstance().dispatchEvent(new BanrEvent(BanrEvent.PROCESSING_START));		BannerManager.getInstance().process(settings.quality, settings.timeout);	}	private function clear(e:MouseEvent):void {		BannerManager.getInstance().clear();	}	    public function onDragIn(event:NativeDragEvent):void{		NativeDragManager.acceptDragDrop(stage);    }    public function onDrop(event:NativeDragEvent):void{     	NativeDragManager.dropAction = NativeDragActions.COPY;		      	var dropfiles:Object = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT); //.dataForFormat(transfa.FILE_LIST_FORMAT) as Array;      	for each (var file:File in dropfiles) {			if(file.extension == "swf") {				BannerManager.getInstance().addBanner(file);			} else {				trace("wrong filetype, choose swf");			}		}    }    public function onDragExit(event:NativeDragEvent):void{      trace("Drag exit event.");    }		private function onBannerStarted(e:BanrEvent):void {		processor.alpha = 1;		rowscontainer.alpha = .5;	}		private function onBannerProcessingAllFinished(e:BanrEvent):void {		processor.alpha = 0;		rowscontainer.alpha = 1;	}  }}