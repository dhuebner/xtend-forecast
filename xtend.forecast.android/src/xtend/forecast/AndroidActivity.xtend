package xtend.forecast

import android.app.Activity
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnimationSet
import android.view.animation.DecelerateInterpolator
import android.view.animation.RotateAnimation
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.ImageView$ScaleType
import android.widget.LinearLayout
import android.widget.LinearLayout$LayoutParams
import android.widget.TextView
import java.io.InputStream
import java.net.URL
import org.json.JSONArray
import org.json.JSONObject

import static android.view.ViewGroup$LayoutParams.*
import static android.view.animation.Animation.*
import static android.widget.LinearLayout.*

class AndroidActivity extends Activity {
	
	EditText searchField
	ImageView weatherImage
	TextView infoText
	TextView forecastText
	TextView tempText
	TextView windText
	ImageView windImage
	
	 /** Called when the activity is first created. */
   override void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState)
        contentView = new LinearLayout(this) => [
        	orientation = VERTICAL
        	row[
        		text[ searchField = it text = "Kiel"].weight(1)
        		button[ 
        			text = "Search"
        			onClickListener = [
        				val jsonScript = Forecaster::forecast(searchField.text.toString).toString
        				val data = new JSONObject(jsonScript).firstEntry("data")
        				val error = data.firstEntry("error")
        				print(error)
        				if (error != null) {
        					infoText.text = error.getString("msg")
        					return
        				}
        				loadValues(data)
        			]
        		]
        	]
        	
        	row[
        		label[ infoText = it text = "Enter a city" ]
        	]
        	
        	row[
        		image[ weatherImage = it]
        		label[ forecastText = it text = "... and hit search" textColor = Color::WHITE]
        		backgroundColor = Color::parseColor("#93B7E4")
        	]
        	
        	row[
        		image[ imageDrawable = resources.getDrawable(R$drawable::ic_temp_2) ]
        		label[ tempText = it text = "?¡ - ?¡ C" ]
        		backgroundColor = Color::WHITE
        	]
        	
        	row[
        		windImage = image[ imageDrawable = resources.getDrawable(R$drawable::ic_wind) ]
        		windText = label[ text = "?km/h - ?" ]
        		backgroundColor = Color::WHITE
        	]
        ]
        
    }
	
	def private void loadValues(JSONObject data) {
		val weather = data.firstEntry("weather")
		// Info
		infoText.text = '''Tomorrow in Çdata.firstEntry("request").getString("query")È'''
		// Image
		val imageUrl = weather.firstEntry("weatherIconUrl").getString("value")
		weatherImage.setImageDrawable(new URL(imageUrl).asDrawable)
		weatherImage.layoutParams = new LinearLayout$LayoutParams(windImage.width,windImage.height)
		// Weather
		forecastText.text =  weather.firstEntry("weatherDesc").getString("value")
		// Temperature
		tempText.text = '''Çweather.getString("tempMinC")È¡ - Çweather.getString("tempMaxC")È¡ C'''
		// Wind
		windText.text = '''Çweather.getString("windspeedKmph")Èkm/h - Çweather.getString("winddir16Point")È'''
		windImage.rotate(weather.getInt("winddirDegree"))
	}
	
	
    def row(ViewGroup view, (LinearLayout)=>void initializer) {
		val layout = new LinearLayout(view.context)
		initializer.apply(layout)
		view.addView(layout, FILL_PARENT, WRAP_CONTENT)
		return layout
	}
	def text(ViewGroup view, (EditText)=>void initializer) {
		val comp = new EditText(view.context)
		initializer.apply(comp)
		view.addView(comp)
		return comp
	}
    def button(ViewGroup view, (Button)=>void initializer) {
		val comp = new Button(view.context)
		initializer.apply(comp)
		view.addView(comp)
		return comp
	}
    def label(ViewGroup view, (TextView)=>void initializer) {
		val comp = new TextView(view.context) => [
			textSize = 36
			gravity = Gravity::CENTER
		]
		initializer.apply(comp)
		view.addView(comp)
		comp.weight(1)
		return comp
	}
   
    def image(ViewGroup view, (ImageView)=>void initializer) {
		val comp = new ImageView(view.context) => [
			backgroundColor = Color::WHITE
			scaleType = ImageView$ScaleType::CENTER_CROP
		]
		initializer.apply(comp)
		view.addView(comp)
		return comp
	}
	
	def private <T extends View> T weight(T view, float weightToSet) {
		view.layoutParams = new LinearLayout$LayoutParams(view.layoutParams)=>[weight = weightToSet]
		return view
	}
	
	def private addView(ViewGroup vg, View v) {
		vg.addView(v, WRAP_CONTENT, WRAP_CONTENT)
	}
	
	def private asDrawable(URL imageUrl) {
		val InputStream content =  typeof(InputStream).cast(imageUrl.getContent())
		Drawable::createFromStream(content , imageUrl.path) 
	}
	
	def private rotate(ImageView imageView, Integer degree) { 
		imageView.startAnimation(new AnimationSet(true) => [
			interpolator = new DecelerateInterpolator()
			fillAfter = true
			fillEnabled = true
			addAnimation(new RotateAnimation(0, degree, RELATIVE_TO_SELF, 0.5f, RELATIVE_TO_SELF, 0.5f) => [
				duration = 1500
				fillAfter = true
			])
		])
	}
	
	def JSONObject firstEntry(JSONObject jsonObj, String step) {
		var Object retVal = null
		var Object temp = jsonObj.opt(step)
		switch temp {
			JSONObject: retVal = temp
			JSONArray: retVal = temp.get(0)
		}
		if(! (retVal instanceof JSONObject)) {
			return null
		}
		return typeof(JSONObject).cast(retVal)
	}
}
