
define [
  "underscore",
  "renderer/properties",
  "./glyph",
], (_, Properties, Glyph) ->

  class RayView extends Glyph.View

    _fields: ['x', 'y', 'angle', 'length']
    _properties: ['line']

    _map_data: () ->
      [@sx, @sy] = @plot_view.map_to_screen(@x, @glyph_props.x.units, @y, @glyph_props.y.units)
      width = @plot_view.view_state.get('width')
      height = @plot_view.view_state.get('height')
      inf_len = 2 * (width + height)
      for i in [0..@length.length-1]
        if @length[i] == 0 then @length[i] = inf_len

    _render: (ctx, glyph_props, use_selection) ->
      if glyph_props.line_properties.do_stroke
        for i in [0..@sx.length-1]
          if isNaN(@sx[i] + @sy[i] + @angle[i] + @length[i])
            continue

          ctx.translate(@sx[i], @sy[i])
          ctx.rotate(@angle[i])

          ctx.beginPath()
          ctx.moveTo(0, 0)
          ctx.lineTo(@length[i], 0)

          glyph_props.line_properties.set_vectorize(ctx, i)
          ctx.stroke()

          ctx.rotate(-@angle[i])
          ctx.translate(-@sx[i], -@sy[i])

    draw_legend: (ctx, x1, x2, y1, y2) ->
      glyph_props = @glyph_props
      line_props = glyph_props.line_properties
      reference_point = @get_reference_point()
      if reference_point?
        glyph_settings = reference_point
      else
        glyph_settings = glyph_props
      angle = - @glyph_props.select('angle', glyph_settings)
      r = _.min([Math.abs(x2-x1), Math.abs(y2-y1)]) / 2
      sx = (x1+x2)/2
      sy = (y1+y2)/2
      ctx.beginPath()
      ctx.translate(sx, sy)
      ctx.rotate(angle)
      ctx.moveTo(0,  0)
      ctx.lineTo(r, 0) # TODO handle @length in data units?
      ctx.rotate(-angle)
      ctx.translate(-sx, -sy)
      if line_props.do_stroke
        line_props.set(ctx, glyph_settings)
        ctx.stroke()
      ctx.restore()


  class Ray extends Glyph.Model
    default_view: RayView
    type: 'Glyph'

    display_defaults: () ->
      return _.extend(super(), {
        line_color: 'red'
        line_width: 1
        line_alpha: 1.0
        line_join: 'miter'
        line_cap: 'butt'
        line_dash: []
        line_dash_offset: 0
      })

  return {
    "Model": Ray,
    "View": RayView
  }
