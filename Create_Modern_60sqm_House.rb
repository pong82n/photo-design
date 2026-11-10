# ==============================================================================
# MIRR Construction Services - Automated 3D Architectural Model Generator
# Project: Modern 2-Storey House Transformation (60 sqm Lot / 40 sqm Footprint)
# Features: Left-Side Firewall (PD 1096 Compliant), 2nd-Floor Terrace & Carport
# ==============================================================================

module MIRRConstruction
  def self.build_modern_60sqm_house
    model = Sketchup.active_model
    model.start_operation("Build Modern 60sqm 2-Storey House", true)

    entities = model.active_entities

    # 1. SETUP MATERIALS
    materials = model.materials

    mat_stucco = materials["MIRR_Stucco_OffWhite"] || materials.add("MIRR_Stucco_OffWhite")
    mat_stucco.color = Sketchup::Color.new(241, 245, 249)

    mat_charcoal = materials["MIRR_Charcoal_Accent"] || materials.add("MIRR_Charcoal_Accent")
    mat_charcoal.color = Sketchup::Color.new(30, 41, 59)

    mat_firewall = materials["MIRR_Firewall_Stucco"] || materials.add("MIRR_Firewall_Stucco")
    mat_firewall.color = Sketchup::Color.new(203, 213, 225)

    mat_teak = materials["MIRR_Teak_Wood"] || materials.add("MIRR_Teak_Wood")
    mat_teak.color = Sketchup::Color.new(180, 83, 9)

    mat_glass = materials["MIRR_Architectural_Glass"] || materials.add("MIRR_Architectural_Glass")
    mat_glass.color = Sketchup::Color.new(56, 189, 248)
    mat_glass.alpha = 0.35

    mat_black_metal = materials["MIRR_Black_Aluminum"] || materials.add("MIRR_Black_Aluminum")
    mat_black_metal.color = Sketchup::Color.new(15, 23, 42)

    mat_pavers = materials["MIRR_Carport_Pavers"] || materials.add("MIRR_Carport_Pavers")
    mat_pavers.color = Sketchup::Color.new(71, 85, 105)

    mat_grass = materials["MIRR_Garden_Grass"] || materials.add("MIRR_Garden_Grass")
    mat_grass.color = Sketchup::Color.new(22, 101, 52)

    mat_gold = materials["MIRR_Champagne_Gold"] || materials.add("MIRR_Champagne_Gold")
    mat_gold.color = Sketchup::Color.new(212, 175, 55)

    # 2. LOT BOUNDARY (6.0m x 10.0m = 60 sqm)
    lot_group = entities.add_group
    lot_pts = [
      Geom::Point3d.new(-3.0.m, -5.0.m, 0),
      Geom::Point3d.new( 3.0.m, -5.0.m, 0),
      Geom::Point3d.new( 3.0.m,  5.0.m, 0),
      Geom::Point3d.new(-3.0.m,  5.0.m, 0)
    ]
    lot_face = lot_group.entities.add_face(lot_pts)
    lot_face.pushpull(-0.15.m)
    lot_face.material = mat_charcoal

    # Right side 1.5m Garden Pathway
    garden_pts = [
      Geom::Point3d.new( 1.5.m, -5.0.m, 0.01.m),
      Geom::Point3d.new( 3.0.m, -5.0.m, 0.01.m),
      Geom::Point3d.new( 3.0.m,  5.0.m, 0.01.m),
      Geom::Point3d.new( 1.5.m,  5.0.m, 0.01.m)
    ]
    garden_face = lot_group.entities.add_face(garden_pts)
    garden_face.material = mat_grass

    # Front Carport Pavers
    carport_pts = [
      Geom::Point3d.new(-3.0.m, 0.5.m, 0.015.m),
      Geom::Point3d.new( 1.5.m, 0.5.m, 0.015.m),
      Geom::Point3d.new( 1.5.m, 4.8.m, 0.015.m),
      Geom::Point3d.new(-3.0.m, 4.8.m, 0.015.m)
    ]
    carport_face = lot_group.entities.add_face(carport_pts)
    carport_face.material = mat_pavers

    # 3. LEFT-SIDE FIREWALL (Solid 0.0m Setback Wall, 6.4m Height x 8.5m Depth)
    firewall_group = entities.add_group
    fw_pts = [
      Geom::Point3d.new(-3.0.m, -4.5.m, 0),
      Geom::Point3d.new(-2.78.m, -4.5.m, 0),
      Geom::Point3d.new(-2.78.m,  3.8.m, 0),
      Geom::Point3d.new(-3.0.m,  3.8.m, 0)
    ]
    fw_face = firewall_group.entities.add_face(fw_pts)
    fw_face.pushpull(6.4.m)
    firewall_group.material = mat_firewall

    # Firewall Top Capping
    fw_cap = firewall_group.entities.add_face([
      Geom::Point3d.new(-3.05.m, -4.55.m, 6.4.m),
      Geom::Point3d.new(-2.73.m, -4.55.m, 6.4.m),
      Geom::Point3d.new(-2.73.m,  3.85.m, 6.4.m),
      Geom::Point3d.new(-3.05.m,  3.85.m, 6.4.m)
    ])
    fw_cap.pushpull(0.08.m)
    fw_cap.material = mat_black_metal

    # 4. GROUND FLOOR RESIDENCE VOLUME (Living, Dining, Kitchen, Bath)
    # Footprint: 4.28m wide x 5.2m deep x 3.0m high
    gf_group = entities.add_group
    gf_pts = [
      Geom::Point3d.new(-2.78.m, -4.5.m, 0),
      Geom::Point3d.new( 1.5.m,  -4.5.m, 0),
      Geom::Point3d.new( 1.5.m,   0.7.m, 0),
      Geom::Point3d.new(-2.78.m,  0.7.m, 0)
    ]
    gf_face = gf_group.entities.add_face(gf_pts)
    gf_face.pushpull(3.0.m)
    gf_group.material = mat_stucco

    # Ground Floor Front Accent Panel & Pivot Door
    door_group = entities.add_group
    door_pts = [
      Geom::Point3d.new(-2.5.m, 0.72.m, 0),
      Geom::Point3d.new(-1.4.m, 0.72.m, 0),
      Geom::Point3d.new(-1.4.m, 0.72.m, 2.4.m),
      Geom::Point3d.new(-2.5.m, 0.72.m, 2.4.m)
    ]
    door_face = door_group.entities.add_face(door_pts)
    door_face.pushpull(0.06.m)
    door_group.material = mat_teak

    # Long Black Door Pull Bar
    pull_pts = [
      Geom::Point3d.new(-1.5.m, 0.8.m, 0.6.m),
      Geom::Point3d.new(-1.46.m, 0.8.m, 0.6.m),
      Geom::Point3d.new(-1.46.m, 0.8.m, 1.8.m),
      Geom::Point3d.new(-1.5.m, 0.8.m, 1.8.m)
    ]
    pull_face = entities.add_face(pull_pts)
    pull_face.pushpull(0.03.m)
    pull_face.material = mat_black_metal

    # Ground Floor Picture Window
    win_pts = [
      Geom::Point3d.new(-0.7.m, 0.72.m, 0.8.m),
      Geom::Point3d.new( 1.2.m, 0.72.m, 0.8.m),
      Geom::Point3d.new( 1.2.m, 0.72.m, 2.3.m),
      Geom::Point3d.new(-0.7.m, 0.72.m, 2.3.m)
    ]
    win_face = entities.add_face(win_pts)
    win_face.pushpull(0.04.m)
    win_face.material = mat_glass

    # 5. SECOND FLOOR ENCLOSED RESIDENCE (Master Suite & Bedroom 2)
    uf_group = entities.add_group
    uf_pts = [
      Geom::Point3d.new(-2.78.m, -4.5.m, 3.0.m),
      Geom::Point3d.new( 1.5.m,  -4.5.m, 3.0.m),
      Geom::Point3d.new( 1.5.m,   0.7.m, 3.0.m),
      Geom::Point3d.new(-2.78.m,  0.7.m, 3.0.m)
    ]
    uf_face = uf_group.entities.add_face(uf_pts)
    uf_face.pushpull(3.0.m)
    uf_group.material = mat_stucco

    # 6. CANTILEVERED SECOND-FLOOR TERRACE (BALCONY OVER CARPORT)
    # Extends 3.1m forward (from Y = 0.7m to 3.8m)
    terrace_group = entities.add_group
    t_slab_pts = [
      Geom::Point3d.new(-2.78.m, 0.7.m, 2.75.m),
      Geom::Point3d.new( 1.5.m,  0.7.m, 2.75.m),
      Geom::Point3d.new( 1.5.m,  3.8.m, 2.75.m),
      Geom::Point3d.new(-2.78.m, 3.8.m, 2.75.m)
    ]
    t_slab = terrace_group.entities.add_face(t_slab_pts)
    t_slab.pushpull(0.25.m)
    terrace_group.material = mat_charcoal

    # Teak Ceiling Soffit Under Terrace
    soffit_pts = [
      Geom::Point3d.new(-2.75.m, 0.72.m, 2.74.m),
      Geom::Point3d.new( 1.48.m, 0.72.m, 2.74.m),
      Geom::Point3d.new( 1.48.m, 3.78.m, 2.74.m),
      Geom::Point3d.new(-2.75.m, 3.78.m, 2.74.m)
    ]
    soffit_face = entities.add_face(soffit_pts)
    soffit_face.material = mat_teak

    # Terrace Slender Steel Support Column at Outer Corner
    col_pts = [
      Geom::Point3d.new(1.35.m, 3.65.m, 0),
      Geom::Point3d.new(1.5.m,  3.65.m, 0),
      Geom::Point3d.new(1.5.m,  3.8.m,  0),
      Geom::Point3d.new(1.35.m, 3.8.m,  0)
    ]
    col_face = entities.add_face(col_pts)
    col_face.pushpull(2.75.m)
    col_face.material = mat_black_metal

    # Terrace Front Frameless Glass Balustrade
    t_glass_pts = [
      Geom::Point3d.new(-2.75.m, 3.75.m, 3.0.m),
      Geom::Point3d.new( 1.48.m, 3.75.m, 3.0.m),
      Geom::Point3d.new( 1.48.m, 3.75.m, 4.05.m),
      Geom::Point3d.new(-2.75.m, 3.75.m, 4.05.m)
    ]
    t_glass = entities.add_face(t_glass_pts)
    t_glass.pushpull(0.02.m)
    t_glass.material = mat_glass

    # Terrace Right Side Glass Balustrade
    t_glass_r_pts = [
      Geom::Point3d.new(1.48.m, 0.75.m, 3.0.m),
      Geom::Point3d.new(1.48.m, 3.75.m, 3.0.m),
      Geom::Point3d.new(1.48.m, 3.75.m, 4.05.m),
      Geom::Point3d.new(1.48.m, 0.75.m, 4.05.m)
    ]
    t_glass_r = entities.add_face(t_glass_r_pts)
    t_glass_r.pushpull(0.02.m)
    t_glass_r.material = mat_glass

    # Second Floor Sliding Glass Wall Opening to Terrace
    slider_pts = [
      Geom::Point3d.new(-2.5.m, 0.72.m, 3.0.m),
      Geom::Point3d.new( 0.3.m, 0.72.m, 3.0.m),
      Geom::Point3d.new( 0.3.m, 0.72.m, 5.4.m),
      Geom::Point3d.new(-2.5.m, 0.72.m, 5.4.m)
    ]
    slider_face = entities.add_face(slider_pts)
    slider_face.pushpull(0.05.m)
    slider_face.material = mat_glass

    # Architectural Vertical Teak Louvers on Second-Floor Facade
    louver_x = 0.5.m
    while louver_x <= 1.4.m
      l_pts = [
        Geom::Point3d.new(louver_x, 0.74.m, 3.0.m),
        Geom::Point3d.new(louver_x + 0.05.m, 0.74.m, 3.0.m),
        Geom::Point3d.new(louver_x + 0.05.m, 0.74.m, 5.7.m),
        Geom::Point3d.new(louver_x, 0.74.m, 5.7.m)
      ]
      l_face = entities.add_face(l_pts)
      l_face.pushpull(0.08.m)
      l_face.material = mat_teak
      louver_x += 0.12.m
    end

    # 7. MODERN FLAT ROOF PARAPET & CANTILEVER OVERHANG
    roof_group = entities.add_group
    roof_pts = [
      Geom::Point3d.new(-2.9.m, -4.6.m, 6.0.m),
      Geom::Point3d.new( 1.6.m, -4.6.m, 6.0.m),
      Geom::Point3d.new( 1.6.m,  1.8.m, 6.0.m),
      Geom::Point3d.new(-2.9.m,  1.8.m, 6.0.m)
    ]
    roof_face = roof_group.entities.add_face(roof_pts)
    roof_face.pushpull(0.35.m)
    roof_group.material = mat_charcoal

    # Teak Eave Soffit Trim
    roof_soffit_pts = [
      Geom::Point3d.new(-2.85.m, 0.7.m, 5.98.m),
      Geom::Point3d.new( 1.55.m, 0.7.m, 5.98.m),
      Geom::Point3d.new( 1.55.m, 1.78.m, 5.98.m),
      Geom::Point3d.new(-2.85.m, 1.78.m, 5.98.m)
    ]
    roof_soffit = entities.add_face(roof_soffit_pts)
    roof_soffit.material = mat_teak

    # Champagne Gold Accent Line on Roof Fascia
    gold_pts = [
      Geom::Point3d.new(-2.9.m, 1.81.m, 6.1.m),
      Geom::Point3d.new( 1.6.m, 1.81.m, 6.1.m),
      Geom::Point3d.new( 1.6.m, 1.81.m, 6.15.m),
      Geom::Point3d.new(-2.9.m, 1.81.m, 6.15.m)
    ]
    gold_face = entities.add_face(gold_pts)
    gold_face.pushpull(0.02.m)
    gold_face.material = mat_gold

    # 8. SETUP ARCHITECTURAL CAMERA SCENES / PAGES
    pages = model.pages

    # Scene 1: Street Perspective
    cam1 = Sketchup::Camera.new(
      Geom::Point3d.new(5.5.m, 8.5.m, 2.2.m), # Eye position
      Geom::Point3d.new(-0.8.m, 0.5.m, 2.8.m), # Target
      Geom::Vector3d.new(0, 0, 1)              # Up
    )
    cam1.fov = 45.0
    pages.add("01 - Street Perspective").camera = cam1

    # Scene 2: Terrace Balcony Close-Up
    cam2 = Sketchup::Camera.new(
      Geom::Point3d.new(2.2.m, 5.2.m, 4.2.m),
      Geom::Point3d.new(-0.8.m, 2.2.m, 3.6.m),
      Geom::Vector3d.new(0, 0, 1)
    )
    cam2.fov = 50.0
    pages.add("02 - Terrace Balcony").camera = cam2

    # Scene 3: Left Firewall Elevation
    cam3 = Sketchup::Camera.new(
      Geom::Point3d.new(-9.0.m, -0.5.m, 3.2.m),
      Geom::Point3d.new(-2.8.m, -0.5.m, 3.2.m),
      Geom::Vector3d.new(0, 0, 1)
    )
    cam3.fov = 35.0
    pages.add("03 - Left Firewall").camera = cam3

    # Scene 4: Axonometric 3D
    cam4 = Sketchup::Camera.new(
      Geom::Point3d.new(12.0.m, 12.0.m, 12.0.m),
      Geom::Point3d.new(-0.5.m, 0, 2.5.m),
      Geom::Vector3d.new(0, 0, 1)
    )
    cam4.fov = 40.0
    pages.add("04 - Axonometric 3D").camera = cam4

    # Select Scene 1 by default
    pages.selected_page = pages["01 - Street Perspective"]

    # 9. SAVE MODEL AUTOMATICALLY
    output_skp = "D:/PHOTO DESIGNING/Modern_60sqm_House_Model.skp"
    model.save(output_skp)

    model.commit_operation
    puts "SUCCESS: Modern 60sqm House Model generated and saved to #{output_skp}!"
  end
end

# Auto-run if executed directly
MIRRConstruction.build_modern_60sqm_house if defined?(Sketchup)
