package xtend.forecast

import android.graphics.Color
import android.graphics.drawable.Drawable
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

import static android.view.ViewGroup$LayoutParams.*
import static android.view.animation.Animation.*
import static xtend.forecast.Library.*
import org.json.JSONObject
import org.json.JSONArray


class Library {
	// UI
	 def static row(ViewGroup view, (LinearLayout)=>void initializer) {
		val layout = new LinearLayout(view.context)
		initializer.apply(layout)
		view.addView(layout, FILL_PARENT, WRAP_CONTENT)
		return layout
	}
	
	def static textField(ViewGroup view, (EditText)=>void initializer) {
		val comp = new EditText(view.context)
		initializer.apply(comp)
		addView(view,comp)
		return comp
	}
    
    def static button(ViewGroup view, (Button)=>void initializer) {
		val comp = new Button(view.context)
		initializer.apply(comp)
		addView(view,comp)
		return comp
	}
    def static label(ViewGroup view, (TextView)=>void initializer) {
		val comp = new TextView(view.context) => [
			textSize = 36
			gravity = Gravity::CENTER
		]
		initializer.apply(comp)
		addView(view,comp)
		weight(comp,1)
		return comp
	}
   
    def static image(ViewGroup view, (ImageView)=>void initializer) {
		val comp = new ImageView(view.context) => [
			backgroundColor = Color::WHITE
			scaleType = ImageView$ScaleType::CENTER_CROP
		]
		initializer.apply(comp)
		addView(view,comp)
		return comp
	}
	
	def static <T extends View> T weight(T view, float weightToSet) {
		view.layoutParams = new LinearLayout$LayoutParams(view.layoutParams)=>[weight = weightToSet]
		return view
	}
	
	def private static addView(ViewGroup vg, View v) {
		vg.addView(v, WRAP_CONTENT, WRAP_CONTENT)
	}
	
	def static  createDrawable(URL imageUrl) {
		val InputStream content =  typeof(InputStream).cast(imageUrl.getContent())
		Drawable::createFromStream(content , imageUrl.path) 
	}
	
	def static rotate(ImageView imageView, Integer degree) { 
		imageView.startAnimation(new AnimationSet(true) => [
			interpolator = new DecelerateInterpolator()
			fillAfter = true
			fillEnabled = true
			addAnimation(new RotateAnimation(180, degree, RELATIVE_TO_SELF, 0.5f, RELATIVE_TO_SELF, 0.5f) => [
				duration = 1500
				fillAfter = true
			])
		])
	}
	
	//JSon
	def static JSONObject jsonObj(JSONObject parent, String name, (JSONObject)=>void initializer) {
		val jSonObj = new JSONObject()
		parent?.put(name,jSonObj)
		initializer.apply(jSonObj)
		return jSonObj
	}
	
	def static JSONObject firstEntry(JSONObject jsonObj, String step) {
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