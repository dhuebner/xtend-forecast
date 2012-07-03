package xtend.forecast.client;

import com.google.common.base.Objects;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Pane;
import javafx.scene.web.WebEngine;
import javafx.scene.web.WebView;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;
import javafx.util.Callback;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure0;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.vertx.java.core.buffer.Buffer;
import org.vertx.java.core.json.JsonObject;
import xtend.forecast.client.HTMLGenerator;
import xtend.forecast.client.IForecastProvider;

/**
 * @author Dennis Huebner
 */
@SuppressWarnings("all")
public class WeatherApplication extends Application implements Callback<Buffer,Boolean> {
  private static IForecastProvider fcProvider;
  
  private WebEngine webEngine;
  
  public void start(final Stage stage) throws Exception {
    stage.setTitle("Weather forecast");
    Parent _createPane = this.createPane();
    Scene _scene = new Scene(_createPane, 315, 330);
    stage.setScene(_scene);
    stage.show();
    final Procedure1<WindowEvent> _function = new Procedure1<WindowEvent>() {
        public void apply(final WindowEvent it) {
          WeatherApplication.fcProvider.unsubscribe();
        }
      };
    stage.setOnCloseRequest(new EventHandler<WindowEvent>() {
        public void handle(WindowEvent arg0) {
          _function.apply(arg0);
        }
    });
  }
  
  public static void setForecastProvider(final IForecastProvider provider) {
    WeatherApplication.fcProvider = provider;
  }
  
  public Parent createPane() {
    WebView _webView = new WebView();
    final WebView browser = _webView;
    WebEngine _engine = browser.getEngine();
    this.webEngine = _engine;
    TextField _textField = new TextField();
    final Procedure1<TextField> _function = new Procedure1<TextField>() {
        public void apply(final TextField it) {
          it.setText("Test");
          final Procedure1<KeyEvent> _function = new Procedure1<KeyEvent>() {
              public void apply(final KeyEvent event) {
                boolean _or = false;
                KeyCode _code = event.getCode();
                boolean _equals = Objects.equal(_code, KeyCode.ENTER);
                if (_equals) {
                  _or = true;
                } else {
                  String _character = event.getCharacter();
                  boolean _equals_1 = Objects.equal(_character, "\r");
                  _or = (_equals || _equals_1);
                }
                if (_or) {
                  String _text = it.getText();
                  WeatherApplication.this.subscribe(_text);
                }
              }
            };
          it.setOnKeyTyped(new EventHandler<KeyEvent>() {
              public void handle(KeyEvent arg0) {
                _function.apply(arg0);
              }
          });
        }
      };
    final TextField textField = ObjectExtensions.<TextField>operator_doubleArrow(_textField, _function);
    Button _button = new Button();
    final Procedure1<Button> _function_1 = new Procedure1<Button>() {
        public void apply(final Button it) {
          it.setText("Search");
        }
      };
    final Button button = ObjectExtensions.<Button>operator_doubleArrow(_button, _function_1);
    final Procedure1<ActionEvent> _function_2 = new Procedure1<ActionEvent>() {
        public void apply(final ActionEvent it) {
          String _text = textField.getText();
          WeatherApplication.this.subscribe(_text);
        }
      };
    button.setOnAction(new EventHandler<ActionEvent>() {
        public void handle(ActionEvent arg0) {
          _function_2.apply(arg0);
        }
    });
    HBox _hBox = new HBox();
    final Procedure1<HBox> _function_3 = new Procedure1<HBox>() {
        public void apply(final HBox it) {
          it.setAlignment(Pos.CENTER);
          it.setSpacing(10);
          Insets _insets = new Insets(10, 10, 10, 10);
          it.setPadding(_insets);
          WeatherApplication.this.addChild(it, textField);
          WeatherApplication.this.addChild(it, button);
        }
      };
    final HBox searchPane = ObjectExtensions.<HBox>operator_doubleArrow(_hBox, _function_3);
    String _emptyPage = HTMLGenerator.emptyPage();
    this.webEngine.loadContent(_emptyPage);
    BorderPane _borderPane = new BorderPane();
    final Procedure1<BorderPane> _function_4 = new Procedure1<BorderPane>() {
        public void apply(final BorderPane it) {
          it.setTop(searchPane);
          it.setCenter(browser);
          String _plus = ("-fx-background-color: " + HTMLGenerator.FORECAST_BLUE);
          it.setStyle(_plus);
        }
      };
    return ObjectExtensions.<BorderPane>operator_doubleArrow(_borderPane, _function_4);
  }
  
  public Boolean call(final Buffer jSonObject) {
    boolean _xblockexpression = false;
    {
      final Procedure0 _function = new Procedure0() {
          public void apply() {
            String _string = jSonObject.toString();
            JsonObject _jsonObject = new JsonObject(_string);
            String _createHTML = HTMLGenerator.createHTML(_jsonObject);
            WeatherApplication.this.webEngine.loadContent(_createHTML);
          }
        };
      Platform.runLater(new Runnable() {
          public void run() {
            _function.apply();
          }
      });
      _xblockexpression = (true);
    }
    return Boolean.valueOf(_xblockexpression);
  }
  
  private void subscribe(final String city) {
    WeatherApplication.fcProvider.subscribeForecast(city, this);
  }
  
  private boolean addChild(final Pane pane, final Node node) {
    ObservableList<Node> _children = pane.getChildren();
    boolean _add = _children.add(node);
    return _add;
  }
}
