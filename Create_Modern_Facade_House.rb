# ==============================================================================
# MIRR Construction Services - Automated 3D Architectural Model Generator
# Project: Modern 2-Storey Townhouse Facade (Exact Image Recreation)
# Features:
#   - Exposed Architectural Concrete Portal Frame
#   - Floor-to-Ceiling Ground Floor Glazing with Modern White Entry Door
#   - Front Boundary Wall with Base Concrete, Integrated LEDs, and Grid Trellis
#   - Modern Black Grid Pedestrian Gate with Decorative Welcome Tile Landing
#   - 2nd Floor Spacious Balcony with Seamless Tempered Glass Balustrade
#   - Multi-Tiered Cantilevered Roof Overhangs with Teak Wood Slatted Soffits
#   - Integrated Geometric Linear LED Light Strips in Soffits
#   - Preset Architectural Camera Views (Elevation, Perspective, Balcony, Axo)
# ==============================================================================

require 'sketchup.rb'

module MIRRModernFacade
  def self.build_facade_model
    model = Sketchup.active_model
    model.start_operation("Build Modern 2-Storey Facade Model", true)

    entities = model.active_entities

    # Clear existing entities if desired or create in fresh group
    main_group = entities.add_group
    m_ent = main_group.entities

    # --------------------------------------------------------------------------
    # 1. SETUP MATERIALS & COLORS
    # --------------------------------------------------------------------------
    materials = model.materials

    # Concrete - Smooth Board-Formed Architectural Concrete
    mat_concrete = materials["MIRR_Architectural_Concrete"] || materials.add("MIRR_Architectural_Concrete")
    mat_concrete.color = Sketchup::Color.new(185, 192, 198)

    # Dark Metal / Aluminum Frames
    mat_black_metal = materials["MIRR_Matte_Black_Metal"] || materials.add("MIRR_Matte_Black_Metal")
    mat_black_metal.color = Sketchup::Color.new(28, 30, 33)

    # Teak / Walnut Wood Slats for Soffit
    mat_wood_soffit = materials["MIRR_Teak_Wood_Soffit"] || materials.add("MIRR_Teak_Wood_Soffit")
    mat_wood_soffit.color = Sketchup::Color.new(166, 107, 60)

    # Roof Metal Fascia / Flashing
    mat_roof_metal = materials["MIRR_Dark_Bronze_Fascia"] || materials.add("MIRR_Dark_Bronze_Fascia")
    mat_roof_metal.color = Sketchup::Color.new(65, 58, 52)

    # Exterior Warm Stucco Walls (Side & Rear)
    mat_stucco_warm = materials["MIRR_Warm_Sand_Stucco"] || materials.add("MIRR_Warm_Sand_Stucco")
    mat_stucco_warm.color = Sketchup::Color.new(222, 185, 154)

    # Architectural Clear Glass (Balcony & Transoms)
    mat_glass_clear = materials["MIRR_Clear_Glass"] || materials.add("MIRR_Clear_Glass")
    mat_glass_clear.color = Sketchup::Color.new(215, 235, 245)
    mat_glass_clear.alpha = 0.25

    # Ground Floor Interior Glass
    mat_glass_tint = materials["MIRR_Reflective_Glass"] || materials.add("MIRR_Reflective_Glass")
    mat_glass_tint.color = Sketchup::Color.new(190, 210, 220)
    mat_glass_tint.alpha = 0.40

    # Linear LED Light Strips (Warm Glowing Emissive)
    mat_led_warm = materials["MIRR_Warm_LED_Light"] || materials.add("MIRR_Warm_LED_Light")
    mat_led_warm.color = Sketchup::Color.new(255, 244, 214)

    # White Front Entry Door
    mat_white_door = materials["MIRR_Door_Pure_White"] || materials.add("MIRR_Door_Pure_White")
    mat_white_door.color = Sketchup::Color.new(250, 250, 250)

    # Sidewalk Concrete
    mat_sidewalk = materials["MIRR_Sidewalk_Concrete"] || materials.add("MIRR_Sidewalk_Concrete")
    mat_sidewalk.color = Sketchup::Color.new(210, 213, 216)

    # Welcome Tile Mat
    mat_tile_pattern = materials["MIRR_Patterned_Tile"] || materials.add("MIRR_Patterned_Tile")
    mat_tile_pattern.color = Sketchup::Color.new(140, 165, 175)

    # Foliage / Greenery
    mat_greenery = materials["MIRR_Olive_Greenery"] || materials.add("MIRR_Olive_Greenery")
    mat_greenery.color = Sketchup::Color.new(78, 105, 71)

    # --------------------------------------------------------------------------
    # 2. SITE, SIDEWALK, & ROAD
    # --------------------------------------------------------------------------
    site_grp = m_ent.add_group
    s_ent = site_grp.entities

    # Road Pavement
    road_pts = [
      Geom::Point3d.new(-4.5.m, 5.0.m, -0.15.m),
      Geom::Point3d.new( 4.5.m, 5.0.m, -0.15.m),
      Geom::Point3d.new( 4.5.m, 7.5.m, -0.15.m),
      Geom::Point3d.new(-4.5.m, 7.5.m, -0.15.m)
    ]
    rf = s_ent.add_face(road_pts)
    rf.material = mat_roof_metal

    # Curb
    curb_pts = [
      Geom::Point3d.new(-4.5.m, 4.85.m, -0.15.m),
      Geom::Point3d.new( 4.5.m, 4.85.m, -0.15.m),
      Geom::Point3d.new( 4.5.m, 5.0.m, -0.15.m),
      Geom::Point3d.new(-4.5.m, 5.0.m, -0.15.m)
    ]
    cf = s_ent.add_face(curb_pts)
    cf.pushpull(0.15.m)
    cf.material = mat_concrete

    # Sidewalk
    sw_pts = [
      Geom::Point3d.new(-4.5.m, 3.6.m, 0),
      Geom::Point3d.new( 4.5.m, 3.6.m, 0),
      Geom::Point3d.new( 4.5.m, 4.85.m, 0),
      Geom::Point3d.new(-4.5.m, 4.85.m, 0)
    ]
    swf = s_ent.add_face(sw_pts)
    swf.material = mat_sidewalk

    # Patterned Welcome Mat in front of gate
    mat_landing_pts = [
      Geom::Point3d.new(-0.65.m, 3.7.m, 0.005.m),
      Geom::Point3d.new( 0.45.m, 3.7.m, 0.005.m),
      Geom::Point3d.new( 0.45.m, 4.7.m, 0.005.m),
      Geom::Point3d.new(-0.65.m, 4.7.m, 0.005.m)
    ]
    tlf = s_ent.add_face(mat_landing_pts)
    tlf.material = mat_tile_pattern

    # Succulent Landscape Strip on Left Sidewalk
    succ_pts = [
      Geom::Point3d.new(-3.1.m, 3.7.m, 0.01.m),
      Geom::Point3d.new(-0.9.m, 3.7.m, 0.01.m),
      Geom::Point3d.new(-0.9.m, 4.4.m, 0.01.m),
      Geom::Point3d.new(-3.1.m, 4.4.m, 0.01.m)
    ]
    scf = s_ent.add_face(succ_pts)
    scf.material = mat_greenery

    # --------------------------------------------------------------------------
    # 3. FRONT BOUNDARY WALL & GATE
    # --------------------------------------------------------------------------
    wall_grp = m_ent.add_group
    w_ent = wall_grp.entities

    # Lower Concrete Wall - Left Section
    cw_l_pts = [
      Geom::Point3d.new(-3.1.m, 3.45.m, 0),
      Geom::Point3d.new(-0.6.m, 3.45.m, 0),
      Geom::Point3d.new(-0.6.m, 3.65.m, 0),
      Geom::Point3d.new(-3.1.m, 3.65.m, 0)
    ]
    cw_lf = w_ent.add_face(cw_l_pts)
    cw_lf.pushpull(0.85.m)
    wall_grp.material = mat_concrete

    # Lower Concrete Wall - Right Section (With Mailbox & House Number '7')
    cw_r_pts = [
      Geom::Point3d.new( 0.5.m, 3.45.m, 0),
      Geom::Point3d.new( 3.1.m, 3.45.m, 0),
      Geom::Point3d.new( 3.1.m, 3.65.m, 0),
      Geom::Point3d.new( 0.5.m, 3.65.m, 0)
    ]
    cw_rf = w_ent.add_face(cw_r_pts)
    cw_rf.pushpull(0.85.m)

    # Right Wall Pier Extends Up to 1.55m
    pier_r_pts = [
      Geom::Point3d.new( 2.45.m, 3.45.m, 0.85.m),
      Geom::Point3d.new( 3.10.m, 3.45.m, 0.85.m),
      Geom::Point3d.new( 3.10.m, 3.65.m, 0.85.m),
      Geom::Point3d.new( 2.45.m, 3.65.m, 0.85.m)
    ]
    prf = w_ent.add_face(pier_r_pts)
    prf.pushpull(0.70.m)

    # Mail slot in right pier
    slot_pts = [
      Geom::Point3d.new( 2.60.m, 3.655.m, 1.15.m),
      Geom::Point3d.new( 2.95.m, 3.655.m, 1.15.m),
      Geom::Point3d.new( 2.95.m, 3.655.m, 1.25.m),
      Geom::Point3d.new( 2.60.m, 3.655.m, 1.25.m)
    ]
    slf = w_ent.add_face(slot_pts)
    slf.pushpull(0.015.m)
    slf.material = mat_roof_metal

    # Parcel Drop Box (Black) on middle wall
    box_pts = [
      Geom::Point3d.new( 0.65.m, 3.655.m, 0.35.m),
      Geom::Point3d.new( 1.15.m, 3.655.m, 0.35.m),
      Geom::Point3d.new( 1.15.m, 3.655.m, 0.70.m),
      Geom::Point3d.new( 0.65.m, 3.655.m, 0.70.m)
    ]
    bxf = w_ent.add_face(box_pts)
    bxf.pushpull(0.02.m)
    bxf.material = mat_black_metal

    # Vertical Metal Accent Inlays on Concrete Wall Face
    [-2.6.m, -2.0.m, -1.4.m, 1.45.m, 2.0.m].each do |vx|
      vf_pts = [
        Geom::Point3d.new(vx - 0.015.m, 3.655.m, 0.05.m),
        Geom::Point3d.new(vx + 0.015.m, 3.655.m, 0.05.m),
        Geom::Point3d.new(vx + 0.015.m, 3.655.m, 0.85.m),
        Geom::Point3d.new(vx - 0.015.m, 3.655.m, 0.85.m)
      ]
      vff = w_ent.add_face(vf_pts)
      vff.material = mat_black_metal
    end

    # LED Strip Light Under Base of Concrete Wall (Warm Wash on Sidewalk)
    led_wall_pts = [
      Geom::Point3d.new(-3.1.m, 3.66.m, 0.02.m),
      Geom::Point3d.new( 3.1.m, 3.66.m, 0.02.m),
      Geom::Point3d.new( 3.1.m, 3.66.m, 0.06.m),
      Geom::Point3d.new(-3.1.m, 3.66.m, 0.06.m)
    ]
    lwf = w_ent.add_face(led_wall_pts)
    lwf.material = mat_led_warm

    # Black Square-Grid Trellis Upper Fence (Left: -3.1m to -0.6m, Right: 0.5m to 2.45m)
    grid_grp = m_ent.add_group
    g_ent = grid_grp.entities

    draw_grid_panel = lambda do |x1, x2, z1, z2, y_pos|
      # Perimeter frame
      # Top Rail
      tr = g_ent.add_face([
        Geom::Point3d.new(x1, y_pos, z2),
        Geom::Point3d.new(x2, y_pos, z2),
        Geom::Point3d.new(x2, y_pos, z2 - 0.04.m),
        Geom::Point3d.new(x1, y_pos, z2 - 0.04.m)
      ])
      tr.pushpull(0.04.m)
      # Horizontal grid wires
      (1..4).each do |i|
        hz = z1 + (z2 - z1) * (i / 5.0)
        hwire = g_ent.add_face([
          Geom::Point3d.new(x1, y_pos + 0.01.m, hz - 0.01.m),
          Geom::Point3d.new(x2, y_pos + 0.01.m, hz - 0.01.m),
          Geom::Point3d.new(x2, y_pos + 0.01.m, hz + 0.01.m),
          Geom::Point3d.new(x1, y_pos + 0.01.m, hz + 0.01.m)
        ])
        hwire.pushpull(0.02.m)
      end
      # Vertical grid wires
      count = ((x2 - x1).abs / 0.16.m).floor
      (1..count).each do |j|
        vx = x1 + j * 0.16.m
        next if vx >= x2 - 0.02.m
        vwire = g_ent.add_face([
          Geom::Point3d.new(vx - 0.01.m, y_pos + 0.01.m, z1),
          Geom::Point3d.new(vx + 0.01.m, y_pos + 0.01.m, z1),
          Geom::Point3d.new(vx + 0.01.m, y_pos + 0.01.m, z2),
          Geom::Point3d.new(vx - 0.01.m, y_pos + 0.01.m, z2)
        ])
        vwire.pushpull(0.02.m)
      end
    end

    draw_grid_panel.call(-3.1.m, -0.6.m, 0.85.m, 1.55.m, 3.52.m)
    draw_grid_panel.call( 0.5.m,  2.45.m, 0.85.m, 1.55.m, 3.52.m)

    # Central Pedestrian Gate (X: -0.6m to 0.5m, Height: 0.05m to 1.55m)
    gate_grp = m_ent.add_group
    gt_ent = gate_grp.entities
    draw_grid_panel.call(-0.58.m, 0.48.m, 0.05.m, 1.55.m, 3.52.m)
    # Gate Frame border
    gframe = gt_ent.add_face([
      Geom::Point3d.new(-0.58.m, 3.50.m, 0.05.m),
      Geom::Point3d.new(-0.58.m, 3.50.m, 1.55.m),
      Geom::Point3d.new(-0.54.m, 3.50.m, 1.55.m),
      Geom::Point3d.new(-0.54.m, 3.50.m, 0.05.m)
    ])
    gframe.pushpull(0.05.m)
    grid_grp.material = mat_black_metal
    gate_grp.material = mat_black_metal

    # --------------------------------------------------------------------------
    # 4. GROUND FLOOR EXPOSED CONCRETE PORTAL FRAME
    # --------------------------------------------------------------------------
    portal_grp = m_ent.add_group
    p_ent = portal_grp.entities

    # Left Column
    col_l = p_ent.add_face([
      Geom::Point3d.new(-3.1.m, 1.6.m, 0),
      Geom::Point3d.new(-2.75.m, 1.6.m, 0),
      Geom::Point3d.new(-2.75.m, 2.1.m, 0),
      Geom::Point3d.new(-3.1.m, 2.1.m, 0)
    ])
    col_l.pushpull(3.2.m)

    # Right Column
    col_r = p_ent.add_face([
      Geom::Point3d.new( 2.75.m, 1.6.m, 0),
      Geom::Point3d.new( 3.1.m, 1.6.m, 0),
      Geom::Point3d.new( 3.1.m, 2.1.m, 0),
      Geom::Point3d.new( 2.75.m, 2.1.m, 0)
    ])
    col_r.pushpull(3.2.m)

    # Massive Concrete Lintel Beam
    beam_pts = [
      Geom::Point3d.new(-3.1.m, 1.6.m, 2.85.m),
      Geom::Point3d.new( 3.1.m, 1.6.m, 2.85.m),
      Geom::Point3d.new( 3.1.m, 2.1.m, 2.85.m),
      Geom::Point3d.new(-3.1.m, 2.1.m, 2.85.m)
    ]
    bm = p_ent.add_face(beam_pts)
    bm.pushpull(0.35.m)
    portal_grp.material = mat_concrete

    # --------------------------------------------------------------------------
    # 5. GROUND FLOOR GLASS STOREFRONT CURTAIN WALL & ENTRANCE DOOR
    # --------------------------------------------------------------------------
    gf_glazing_grp = m_ent.add_group
    gfg_ent = gf_glazing_grp.entities

    # Glass Panes (Spanning inside the frame from -2.75m to 2.75m, Y = 1.9m)
    gl_panel = gfg_ent.add_face([
      Geom::Point3d.new(-2.75.m, 1.9.m, 0.15.m),
      Geom::Point3d.new( 2.75.m, 1.9.m, 0.15.m),
      Geom::Point3d.new( 2.75.m, 1.9.m, 2.85.m),
      Geom::Point3d.new(-2.75.m, 1.9.m, 2.85.m)
    ])
    gl_panel.material = mat_glass_tint

    # Black Aluminum Mullions & Transoms
    mullion_pts = [
      # Transom bar across entire width at Z = 2.35m
      [[-2.75.m, 1.88.m, 2.35.m], [2.75.m, 1.88.m, 2.35.m], [2.75.m, 1.88.m, 2.40.m], [-2.75.m, 1.88.m, 2.40.m]],
      # Left Vertical Mullion 1
      [[-1.85.m, 1.88.m, 0.15.m], [-1.80.m, 1.88.m, 0.15.m], [-1.80.m, 1.88.m, 2.85.m], [-1.85.m, 1.88.m, 2.85.m]],
      # Left Vertical Mullion 2 (Door Left)
      [[-0.60.m, 1.88.m, 0.15.m], [-0.55.m, 1.88.m, 0.15.m], [-0.55.m, 1.88.m, 2.85.m], [-0.60.m, 1.88.m, 2.85.m]],
      # Door Right Mullion
      [[ 0.40.m, 1.88.m, 0.15.m], [ 0.45.m, 1.88.m, 0.15.m], [ 0.45.m, 1.88.m, 2.85.m], [ 0.40.m, 1.88.m, 2.85.m]],
      # Right Vertical Mullion
      [[ 1.60.m, 1.88.m, 0.15.m], [ 1.65.m, 1.88.m, 0.15.m], [ 1.65.m, 1.88.m, 2.85.m], [ 1.60.m, 1.88.m, 2.85.m]]
    ]
    mullion_pts.each do |pts|
      pts_3d = pts.map { |p| Geom::Point3d.new(p[0], p[1], p[2]) }
      mf = gfg_ent.add_face(pts_3d)
      mf.pushpull(0.04.m)
      mf.material = mat_black_metal
    end

    # Modern White Front Entry Door with Wreath
    door_pts = [
      Geom::Point3d.new(-0.55.m, 1.89.m, 0.15.m),
      Geom::Point3d.new( 0.40.m, 1.89.m, 0.15.m),
      Geom::Point3d.new( 0.40.m, 1.89.m, 2.35.m),
      Geom::Point3d.new(-0.55.m, 1.89.m, 2.35.m)
    ]
    df = gfg_ent.add_face(door_pts)
    df.pushpull(0.05.m)
    df.material = mat_white_door

    # Door Handle
    handle = gfg_ent.add_face([
      Geom::Point3d.new(0.32.m, 1.945.m, 1.15.m),
      Geom::Point3d.new(0.35.m, 1.945.m, 1.15.m),
      Geom::Point3d.new(0.35.m, 1.945.m, 1.35.m),
      Geom::Point3d.new(0.32.m, 1.945.m, 1.35.m)
    ])
    handle.pushpull(0.03.m)
    handle.material = mat_black_metal

    # --------------------------------------------------------------------------
    # 6. SECOND FLOOR BALCONY DECK & FRAMELESS GLASS RAILING
    # --------------------------------------------------------------------------
    balcony_grp = m_ent.add_group
    b_ent = balcony_grp.entities

    # Balcony Floor Slab
    bf_pts = [
      Geom::Point3d.new(-3.1.m, -1.0.m, 3.2.m),
      Geom::Point3d.new( 3.1.m, -1.0.m, 3.2.m),
      Geom::Point3d.new( 3.1.m,  2.1.m, 3.2.m),
      Geom::Point3d.new(-3.1.m,  2.1.m, 3.2.m)
    ]
    bff = b_ent.add_face(bf_pts)
    bff.pushpull(0.12.m)
    bff.material = mat_concrete

    # Seamless Frameless Glass Balustrade (Front Edge)
    rail_front_pts = [
      Geom::Point3d.new(-3.05.m, 2.08.m, 3.32.m),
      Geom::Point3d.new( 3.05.m, 2.08.m, 3.32.m),
      Geom::Point3d.new( 3.05.m, 2.08.m, 4.37.m), # 1.05m railing height
      Geom::Point3d.new(-3.05.m, 2.08.m, 4.37.m)
    ]
    rf_face = b_ent.add_face(rail_front_pts)
    rf_face.pushpull(0.015.m)
    rf_face.material = mat_glass_clear

    # Balcony Return Railing (Left & Right)
    rail_l_pts = [
      Geom::Point3d.new(-3.05.m, 0.4.m, 3.32.m),
      Geom::Point3d.new(-3.05.m, 2.08.m, 3.32.m),
      Geom::Point3d.new(-3.05.m, 2.08.m, 4.37.m),
      Geom::Point3d.new(-3.05.m, 0.4.m, 4.37.m)
    ]
    rl_face = b_ent.add_face(rail_l_pts)
    rl_face.pushpull(0.015.m)
    rl_face.material = mat_glass_clear

    rail_r_pts = [
      Geom::Point3d.new(3.05.m, 0.4.m, 3.32.m),
      Geom::Point3d.new(3.05.m, 2.08.m, 3.32.m),
      Geom::Point3d.new(3.05.m, 2.08.m, 4.37.m),
      Geom::Point3d.new(3.05.m, 0.4.m, 4.37.m)
    ]
    rr_face = b_ent.add_face(rail_r_pts)
    rr_face.pushpull(-0.015.m)
    rr_face.material = mat_glass_clear

    # Shoe Base Mount (Slim Dark Metal Base Track)
    track_pts = [
      Geom::Point3d.new(-3.06.m, 2.05.m, 3.32.m),
      Geom::Point3d.new( 3.06.m, 2.05.m, 3.32.m),
      Geom::Point3d.new( 3.06.m, 2.11.m, 3.32.m),
      Geom::Point3d.new(-3.06.m, 2.11.m, 3.32.m)
    ]
    tk = b_ent.add_face(track_pts)
    tk.pushpull(0.06.m)
    tk.material = mat_black_metal

    # Planters on Balcony
    # Left Olive Planter (Cylindrical)
    p_left_base = b_ent.add_face([
      Geom::Point3d.new(-2.6.m, 1.3.m, 3.32.m),
      Geom::Point3d.new(-2.0.m, 1.3.m, 3.32.m),
      Geom::Point3d.new(-2.0.m, 1.9.m, 3.32.m),
      Geom::Point3d.new(-2.6.m, 1.9.m, 3.32.m)
    ])
    p_left_base.pushpull(0.65.m)
    p_left_base.material = mat_concrete

    # Right Agave Planter
    p_right_base = b_ent.add_face([
      Geom::Point3d.new( 2.0.m, 1.3.m, 3.32.m),
      Geom::Point3d.new( 2.6.m, 1.3.m, 3.32.m),
      Geom::Point3d.new( 2.6.m, 1.9.m, 3.32.m),
      Geom::Point3d.new( 2.0.m, 1.9.m, 3.32.m)
    ])
    p_right_base.pushpull(0.55.m)
    p_right_base.material = mat_concrete

    # --------------------------------------------------------------------------
    # 7. SECOND FLOOR RESIDENCE WALLS & CURTAIN WALL
    # --------------------------------------------------------------------------
    l2_grp = m_ent.add_group
    l2_ent = l2_grp.entities

    # Recessed Second Floor Enclosure (Y = 0.2m)
    # Floor to Ceiling Master Bedroom Glazing (X: -1.7m to 1.5m, Z: 3.32m to 5.75m)
    l2_glass = l2_ent.add_face([
      Geom::Point3d.new(-1.7.m, 0.2.m, 3.32.m),
      Geom::Point3d.new( 1.5.m, 0.2.m, 3.32.m),
      Geom::Point3d.new( 1.5.m, 0.2.m, 5.75.m),
      Geom::Point3d.new(-1.7.m, 0.2.m, 5.75.m)
    ])
    l2_glass.material = mat_glass_clear

    # L2 Glazing Frame (Black Aluminum)
    l2_mullion = l2_ent.add_face([
      Geom::Point3d.new(-0.1.m, 0.18.m, 3.32.m),
      Geom::Point3d.new( 0.0.m, 0.18.m, 3.32.m),
      Geom::Point3d.new( 0.0.m, 0.18.m, 5.75.m),
      Geom::Point3d.new(-0.1.m, 0.18.m, 5.75.m)
    ])
    l2_mullion.pushpull(0.04.m)
    l2_mullion.material = mat_black_metal

    # Side Stucco Walls (Warm Sand / Terracotta)
    # Left Wall
    l2_wall_l = l2_ent.add_face([
      Geom::Point3d.new(-3.1.m, -2.5.m, 3.32.m),
      Geom::Point3d.new(-1.7.m, -2.5.m, 3.32.m),
      Geom::Point3d.new(-1.7.m,  0.2.m, 3.32.m),
      Geom::Point3d.new(-3.1.m,  0.2.m, 3.32.m)
    ])
    l2_wall_l.pushpull(2.6.m)
    l2_wall_l.material = mat_stucco_warm

    # Right Wall
    l2_wall_r = l2_ent.add_face([
      Geom::Point3d.new( 1.5.m, -2.5.m, 3.32.m),
      Geom::Point3d.new( 3.1.m, -2.5.m, 3.32.m),
      Geom::Point3d.new( 3.1.m,  0.2.m, 3.32.m),
      Geom::Point3d.new( 1.5.m,  0.2.m, 3.32.m)
    ])
    l2_wall_r.pushpull(2.6.m)
    l2_wall_r.material = mat_stucco_warm

    # --------------------------------------------------------------------------
    # 8. MULTI-TIERED ANGULAR MODERN CANTILEVERED ROOF & SOFFIT
    # --------------------------------------------------------------------------
    roof_grp = m_ent.add_group
    r_ent = roof_grp.entities

    # Lower Cantilevered Floating Canopy (Extends over the 2nd-floor balcony)
    # Width: X = -2.2m to 2.0m, Length: Y = -0.5m to 1.85m, Elevation: Z = 5.8m to 6.1m
    canopy_pts = [
      Geom::Point3d.new(-2.2.m, -0.5.m, 5.85.m),
      Geom::Point3d.new( 2.0.m, -0.5.m, 5.85.m),
      Geom::Point3d.new( 2.0.m,  1.85.m, 5.85.m),
      Geom::Point3d.new(-2.2.m,  1.85.m, 5.85.m)
    ]
    canopy_face = r_ent.add_face(canopy_pts)
    canopy_face.material = mat_wood_soffit

    # Canopy Fascia (Dark Bronze / Charcoal Metal Edge)
    canopy_top = canopy_face.pushpull(0.25.m)
    canopy_grp.material = mat_roof_metal

    # Integrated Geometric LED Light Strips on Canopy Underside
    # L-Shape Linear LED Strip: runs along front edge and turns right
    led_canopy_pts1 = [
      Geom::Point3d.new(-1.6.m, 1.5.m, 5.845.m),
      Geom::Point3d.new( 1.2.m, 1.5.m, 5.845.m),
      Geom::Point3d.new( 1.2.m, 1.55.m, 5.845.m),
      Geom::Point3d.new(-1.6.m, 1.55.m, 5.845.m)
    ]
    lcf1 = r_ent.add_face(led_canopy_pts1)
    lcf1.material = mat_led_warm

    led_canopy_pts2 = [
      Geom::Point3d.new( 1.15.m, 0.4.m, 5.845.m),
      Geom::Point3d.new( 1.2.m,  0.4.m, 5.845.m),
      Geom::Point3d.new( 1.2.m,  1.55.m, 5.845.m),
      Geom::Point3d.new( 1.15.m, 1.55.m, 5.845.m)
    ]
    lcf2 = r_ent.add_face(led_canopy_pts2)
    lcf2.material = mat_led_warm

    # Upper Slanted Modern Roof Structure (Slopes up towards left)
    # Left edge Z = 7.15m, Right edge Z = 6.45m
    up_pts = [
      Geom::Point3d.new(-3.3.m, -2.8.m, 7.15.m),
      Geom::Point3d.new( 1.8.m, -2.8.m, 6.45.m),
      Geom::Point3d.new( 1.8.m,  1.3.m, 6.45.m),
      Geom::Point3d.new(-3.3.m,  1.3.m, 7.15.m)
    ]
    up_face = r_ent.add_face(up_pts)
    up_face.material = mat_wood_soffit

    # Roof Thickness / Fascia
    up_face.pushpull(0.28.m)

    # Angular Left Parapet Wing Wall (Architectural Feature on Left Boundary)
    wing_l = r_ent.add_face([
      Geom::Point3d.new(-3.3.m, -2.8.m, 5.5.m),
      Geom::Point3d.new(-3.1.m, -2.8.m, 5.5.m),
      Geom::Point3d.new(-3.1.m,  1.3.m, 5.5.m),
      Geom::Point3d.new(-3.3.m,  1.3.m, 5.5.m)
    ])
    wing_l.pushpull(2.0.m)
    wing_l.material = mat_stucco_warm

    # Right Parapet Return Wall
    wing_r = r_ent.add_face([
      Geom::Point3d.new( 2.9.m, -2.8.m, 5.5.m),
      Geom::Point3d.new( 3.1.m, -2.8.m, 5.5.m),
      Geom::Point3d.new( 3.1.m,  0.5.m, 5.5.m),
      Geom::Point3d.new( 2.9.m,  0.5.m, 5.5.m)
    ])
    wing_r.pushpull(1.6.m)
    wing_r.material = mat_stucco_warm

    # --------------------------------------------------------------------------
    # 9. CONFIGURE ARCHITECTURAL CAMERA SCENES / VIEWS
    # --------------------------------------------------------------------------
    pages = model.pages

    # Remove default untitled page if present
    pages.each { |p| pages.erase(p) } rescue nil

    # Scene 1: Street Perspective (Exact Image Match Angle)
    cam1 = Sketchup::Camera.new(
      Geom::Point3d.new(0.2.m, 7.6.m, 2.2.m),
      Geom::Point3d.new(0.0.m, 0.5.m, 3.6.m),
      Geom::Vector3d.new(0, 0, 1)
    )
    cam1.fov = 48.0
    pages.add("01 - Image Perspective Match").camera = cam1

    # Scene 2: Front Architectural Elevation (Orthographic / 2D)
    cam2 = Sketchup::Camera.new(
      Geom::Point3d.new(0, 12.0.m, 3.8.m),
      Geom::Point3d.new(0, 0, 3.8.m),
      Geom::Vector3d.new(0, 0, 1)
    )
    cam2.fov = 30.0
    pages.add("02 - Front Elevation View").camera = cam2

    # Scene 3: Upper Balcony & Cantilevered Soffit Close-up
    cam3 = Sketchup::Camera.new(
      Geom::Point3d.new(1.8.m, 4.2.m, 4.5.m),
      Geom::Point3d.new(0.0.m, 0.8.m, 4.8.m),
      Geom::Vector3d.new(0, 0, 1)
    )
    cam3.fov = 50.0
    pages.add("03 - Balcony & Timber Soffit").camera = cam3

    # Scene 4: Axonometric 3D Isometric View
    cam4 = Sketchup::Camera.new(
      Geom::Point3d.new(9.0.m, 9.0.m, 9.0.m),
      Geom::Point3d.new(0, 0, 3.0.m),
      Geom::Vector3d.new(0, 0, 1)
    )
    cam4.fov = 35.0
    pages.add("04 - Axonometric 3D").camera = cam4

    # Set active page to Perspective Match
    pages.selected_page = pages["01 - Image Perspective Match"]

    # --------------------------------------------------------------------------
    # 10. SAVE SKETCHUP MODEL FILE
    # --------------------------------------------------------------------------
    out_path = "D:/PHOTO DESIGNING/Modern_Facade_House_Model.skp"
    model.save(out_path)

    model.commit_operation
    UI.messagebox("MIRR Construction Services:\nModern 2-Storey Facade Model built and saved successfully to:\n#{out_path}")
  end
end

# Register Menu & Toolbar in SketchUp Extensions
unless file_loaded?(__FILE__)
  menu = UI.menu("Plugins")
  menu = UI.menu("Extensions") unless menu
  submenu = menu.add_submenu("MIRR Construction Services")
  cmd = UI::Command.new("Generate Modern Facade House") {
    MIRRModernFacade.build_facade_model
  }
  cmd.tooltip = "Generate Modern 2-Storey Facade House (Exact Image Model)"
  cmd.status_bar_text = "Constructs the full 3D architectural facade model with concrete portal frame, balcony, and timber soffit"
  submenu.add_item(cmd)

  toolbar = UI::Toolbar.new("MIRR Facade")
  toolbar.add_item(cmd)
  toolbar.restore

  file_loaded(__FILE__)
end
