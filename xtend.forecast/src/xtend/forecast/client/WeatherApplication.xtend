package xtend.forecast.client

import javafx.application.Application
import javafx.geometry.Insets
import javafx.geometry.Pos
import javafx.scene.Node
import javafx.scene.Parent
import javafx.scene.Scene
import javafx.scene.control.Button
import javafx.scene.control.TextField
import javafx.scene.layout.BorderPane
import javafx.scene.layout.HBox
import javafx.scene.layout.Pane
import javafx.scene.web.WebEngine
import javafx.scene.web.WebView
import javafx.stage.Stage
import javafx.util.Callback
import org.vertx.java.core.buffer.Buffer
import org.vertx.java.core.json.JsonObject

import static javafx.application.Application.*
import static xtend.forecast.client.HTMLGenerator.*

import static extension xtend.forecast.client.WeatherApplication.*
import javafx.application.Platform
import javafx.scene.input.KeyCode
/**
 * @author Dennis Huebner
 *
 */
class WeatherApplication extends Application implements Callback<Buffer,Boolean> {
	static IForecastProvider fcProvider
	WebEngine webEngine
	
	override start(Stage stage) throws Exception {
		stage.title = "Weather forecast"
		stage.scene = new Scene(createPane, 315, 330)
		stage.show
		stage.setOnCloseRequest[fcProvider.unsubscribe]
	}

	def static void setForecastProvider(IForecastProvider provider) {
		fcProvider = provider;
	}
	
	def Parent createPane() {
		val browser = new WebView()
		webEngine = browser.getEngine()
		val textField = new TextField => [
			text = "Test"
			setOnKeyTyped [event | if (event.code == KeyCode::ENTER || event.character=='\r') subscribe(text)]
		]
		val button = new Button  => [text = "Search"]
		button.setOnAction([subscribe(textField.text)])
		val searchPane = new HBox() => [
			alignment = Pos::CENTER
			spacing = 10
			padding = new Insets(10,10,10,10)
			addChild(textField)
			addChild(button)
		]
		webEngine.loadContent(emptyPage)
//		Platform::runLater[|subscribe("Test")]
		return new BorderPane => [ top = searchPane center = browser style = "-fx-background-color: "+FORECAST_BLUE]
	}
	
	override call(Buffer jSonObject) {
		Platform::runLater[|webEngine.loadContent(createHTML(new JsonObject(jSonObject.toString)))]
		true
	}
	
	def private void subscribe(String city) { 
		fcProvider.subscribeForecast(city, this)
	}
	
	def private addChild(Pane pane, Node node) {
		pane.children.add(node)
	}
}