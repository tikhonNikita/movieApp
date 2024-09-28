package com.movielist

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.MovieListViewManagerInterface
import com.facebook.react.viewmanagers.MovieListViewManagerDelegate

@ReactModule(name = MovieListViewManager.NAME)
class MovieListViewManager : SimpleViewManager<MovieListView>(),
  MovieListViewManagerInterface<MovieListView> {
  private val mDelegate: ViewManagerDelegate<MovieListView>

  init {
    mDelegate = MovieListViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<MovieListView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): MovieListView {
    return MovieListView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: MovieListView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "MovieListView"
  }
}
