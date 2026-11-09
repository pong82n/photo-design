Add-Type -AssemblyName System.Drawing

$csharpCode = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class BusinessCardGenerator {

    public static void GenerateFront(string logoPath, string bgPath, string outputPath) {
        int width = 2100;
        int height = 1200;

        using (Bitmap bmp = new Bitmap(width, height, PixelFormat.Format24bppRgb)) {
            bmp.SetResolution(300, 300);

            using (Graphics g = Graphics.FromImage(bmp)) {
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                // 1. Draw Construction Site Background (Vibrant & High Visibility)
                if (System.IO.File.Exists(bgPath)) {
                    using (Bitmap bgBmp = new Bitmap(bgPath)) {
                        g.DrawImage(bgBmp, 0, 0, width, height);
                    }
                } else {
                    using (SolidBrush fallback = new SolidBrush(Color.FromArgb(12, 18, 30))) {
                        g.FillRectangle(fallback, 0, 0, width, height);
                    }
                }

                // 2. Lightened Architectural Tint (Vivid construction backdrop)
                using (LinearGradientBrush darkGrad = new LinearGradientBrush(
                    new Point(0, 0), new Point(width, height),
                    Color.FromArgb(120, 6, 10, 20), Color.FromArgb(70, 10, 16, 28))) {
                    g.FillRectangle(darkGrad, 0, 0, width, height);
                }

                // Localized text backing under the name zone for crisp contrast
                using (GraphicsPath nameGlow = new GraphicsPath()) {
                    nameGlow.AddEllipse(-50, 420, 1100, 450);
                    using (PathGradientBrush pgb = new PathGradientBrush(nameGlow)) {
                        pgb.CenterColor = Color.FromArgb(150, 4, 7, 14);
                        pgb.SurroundColors = new Color[] { Color.Transparent };
                        g.FillPath(pgb, nameGlow);
                    }
                }

                // 3. Technical Blueprint CAD Overlay Lines (Cyan & Gold Civil Engineering Grid)
                using (Pen cadPen = new Pen(Color.FromArgb(45, 56, 189, 248), 1.2f)) {
                    cadPen.DashStyle = DashStyle.Dash;
                    for (int x = 200; x < width; x += 300) {
                        g.DrawLine(cadPen, x, 0, x, height);
                    }
                    for (int y = 200; y < height; y += 250) {
                        g.DrawLine(cadPen, 0, y, width, y);
                    }
                }

                // Diagonal Construction Trusses
                using (Pen trussPen = new Pen(Color.FromArgb(35, 212, 175, 55), 1.8f)) {
                    g.DrawLine(trussPen, 1350, 0, 900, height);
                    g.DrawLine(trussPen, 1650, 0, 1200, height);
                }

                // Outer Card Hairline Border with Inner Margin
                float margin = 45f;
                using (Pen goldBorder = new Pen(Color.FromArgb(180, 212, 175, 55), 2.5f)) {
                    using (GraphicsPath bPath = GetRoundedRect(new RectangleF(margin, margin, width - margin * 2, height - margin * 2), 24f)) {
                        g.DrawPath(goldBorder, bPath);
                    }
                }

                // 4. Logo & Company Identity (Top Left Zone)
                float logoX = 130f;
                float logoY = 120f;
                float logoSize = 175f;

                // Backing plate for top brand identity
                using (Brush topPlaque = new SolidBrush(Color.FromArgb(180, 8, 12, 22))) {
                    using (GraphicsPath tp = GetRoundedRect(new RectangleF(logoX - 15, logoY - 15, 1020, logoSize + 30), 16f)) {
                        g.FillPath(topPlaque, tp);
                    }
                }
                using (Pen topBorder = new Pen(Color.FromArgb(80, 212, 175, 55), 1.4f)) {
                    using (GraphicsPath tp = GetRoundedRect(new RectangleF(logoX - 15, logoY - 15, 1020, logoSize + 30), 16f)) {
                        g.DrawPath(topBorder, tp);
                    }
                }

                // --- PERFECT CIRCLE LOGO (STRICT CIRCULAR CLIPPING) ---
                RectangleF circleRect = new RectangleF(logoX, logoY, logoSize, logoSize);

                // Outer subtle glow ring
                using (Brush glowBrush = new SolidBrush(Color.FromArgb(40, 212, 175, 55))) {
                    g.FillEllipse(glowBrush, logoX - 6, logoY - 6, logoSize + 12, logoSize + 12);
                }

                // Circle Background (Clean Pearl White Medallion)
                using (Brush circleBg = new SolidBrush(Color.FromArgb(250, 250, 252))) {
                    g.FillEllipse(circleBg, circleRect);
                }

                // Strictly clip logo inside the circle
                if (System.IO.File.Exists(logoPath)) {
                    using (Bitmap logoBmp = new Bitmap(logoPath)) {
                        GraphicsState gState = g.Save();
                        using (GraphicsPath clipPath = new GraphicsPath()) {
                            clipPath.AddEllipse(circleRect);
                            g.SetClip(clipPath);

                            // Draw logo neatly centered with balanced padding inside the circle
                            float pad = 10f;
                            g.DrawImage(logoBmp, circleRect.X + pad, circleRect.Y + pad, logoSize - pad * 2, logoSize - pad * 2);
                        }
                        g.Restore(gState);
                    }
                }

                // Metallic Gold Bezel Rings around the circle
                using (Pen goldRing = new Pen(Color.FromArgb(234, 190, 63), 3.5f)) {
                    g.DrawEllipse(goldRing, circleRect);
                }
                using (Pen innerGoldRing = new Pen(Color.FromArgb(180, 212, 175, 55), 1.2f)) {
                    g.DrawEllipse(innerGoldRing, circleRect.X + 4, circleRect.Y + 4, logoSize - 8, logoSize - 8);
                }

                // Company Name Typography
                using (Font brandFont = new Font("Arial", 42, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font subBrandFont = new Font("Arial", 19, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                using (Brush goldBrush = new SolidBrush(Color.FromArgb(234, 190, 63)))
                using (Brush slateBrush = new SolidBrush(Color.FromArgb(180, 195, 215))) {
                    float textStartX = logoX + logoSize + 35f;
                    g.DrawString("MIRR", brandFont, whiteBrush, textStartX, logoY + 15);
                    float mirrWidth = g.MeasureString("MIRR ", brandFont).Width;
                    g.DrawString("CONSTRUCTION", brandFont, goldBrush, textStartX + mirrWidth - 8, logoY + 15);
                    g.DrawString("S E R V I C E S", subBrandFont, slateBrush, textStartX, logoY + 75);

                    // Tagline
                    g.DrawString("ARCHITECTURAL DESIGN  •  GENERAL CONTRACTING  •  CIVIL ENGINEERING",
                        new Font("Arial", 15, FontStyle.Bold, GraphicsUnit.Pixel),
                        new SolidBrush(Color.FromArgb(210, 225, 240)),
                        textStartX, logoY + 120);
                }

                // 5. Employee Name & Designation (Left-Center Zone with drop shadow for extreme sharpness)
                float personY = 485f;
                using (Font nameFont = new Font("Arial", 62, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font roleFont = new Font("Arial", 26, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font divFont = new Font("Arial", 21, FontStyle.Regular, GraphicsUnit.Pixel))
                using (Brush shadowBrush = new SolidBrush(Color.FromArgb(220, 0, 0, 0)))
                using (Brush nameBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                using (Brush goldRoleBrush = new SolidBrush(Color.FromArgb(245, 198, 68)))
                using (Brush divBrush = new SolidBrush(Color.FromArgb(200, 215, 235))) {

                    // Drop shadows behind text
                    g.DrawString("RAFFY T. SOGUILON", nameFont, shadowBrush, 132f, personY + 2);
                    g.DrawString("RAFFY T. SOGUILON", nameFont, nameBrush, 130f, personY);

                    // Metallic Gold Accent Bar under Name
                    using (Brush barBrush = new LinearGradientBrush(
                        new PointF(130f, personY + 80), new PointF(480f, personY + 80),
                        Color.FromArgb(245, 198, 68), Color.Transparent)) {
                        g.FillRectangle(barBrush, 130f, personY + 82, 440f, 4.5f);
                    }

                    g.DrawString("PROJECT IN-CHARGE", roleFont, shadowBrush, 132f, personY + 107);
                    g.DrawString("PROJECT IN-CHARGE", roleFont, goldRoleBrush, 130f, personY + 105);

                    g.DrawString("Site Operations & Structural Engineering Division", divFont, shadowBrush, 132f, personY + 150);
                    g.DrawString("Site Operations & Structural Engineering Division", divFont, divBrush, 130f, personY + 148);
                }

                // 6. Contact Details Block (Right Column with Semi-Translucent Glass Plaque)
                float contactX = 1240f;
                float contactY = 465f;
                float lineSpacing = 82f;

                // Translucent Architectural Plaque for Contact Info
                using (Brush plaqueBg = new SolidBrush(Color.FromArgb(185, 8, 12, 22))) {
                    using (GraphicsPath pPath = GetRoundedRect(new RectangleF(contactX - 25, contactY - 20, 720, 360), 16f)) {
                        g.FillPath(plaqueBg, pPath);
                    }
                }
                using (Pen plaqueBorder = new Pen(Color.FromArgb(120, 212, 175, 55), 1.8f)) {
                    using (GraphicsPath pPath = GetRoundedRect(new RectangleF(contactX - 25, contactY - 20, 720, 360), 16f)) {
                        g.DrawPath(plaqueBorder, pPath);
                    }
                }

                using (Font contactFont = new Font("Arial", 23, FontStyle.Regular, GraphicsUnit.Pixel))
                using (Font labelFont = new Font("Arial", 15, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush labelBrush = new SolidBrush(Color.FromArgb(234, 190, 63)))
                using (Brush valBrush = new SolidBrush(Color.FromArgb(250, 252, 255)))
                using (Brush iconBg = new SolidBrush(Color.FromArgb(230, 18, 27, 44)))
                using (Pen iconBorder = new Pen(Color.FromArgb(180, 212, 175, 55), 1.5f)) {

                    string[] labels = { "PHONE / MOBILE", "OFFICIAL EMAIL", "WEB PORTFOLIO", "OFFICE HEADQUARTERS" };
                    string[] values = {
                        "+63 (917) 800-MIRR  /  (02) 8800-6477",
                        "raffy.soguilon@mirrconstruction.ph",
                        "www.mirrconstruction.ph",
                        "Kalibo, Aklan  •  Metro Manila, PH"
                    };
                    string[] glyphs = { "P", "@", "W", "A" };

                    for (int i = 0; i < 4; i++) {
                        float curY = contactY + (i * lineSpacing);

                        // Icon badge
                        g.FillEllipse(iconBg, contactX, curY - 4, 46, 46);
                        g.DrawEllipse(iconBorder, contactX, curY - 4, 46, 46);
                        
                        using (Font glyphFont = new Font("Arial", 18, FontStyle.Bold, GraphicsUnit.Pixel))
                        using (StringFormat sf = new StringFormat() { Alignment = StringAlignment.Center, LineAlignment = StringAlignment.Center }) {
                            g.DrawString(glyphs[i], glyphFont, labelBrush, new RectangleF(contactX, curY - 4, 46, 46), sf);
                        }

                        // Labels & Values
                        g.DrawString(labels[i], labelFont, labelBrush, contactX + 66, curY - 6);
                        g.DrawString(values[i], contactFont, valBrush, contactX + 66, curY + 16);
                    }
                }

                // 7. Bottom Construction Status Strip
                float botY = height - 120f;
                using (Brush stripBg = new SolidBrush(Color.FromArgb(200, 8, 12, 22))) {
                    g.FillRectangle(stripBg, 130f, botY, width - 260f, 50f);
                }
                using (Pen stripBorder = new Pen(Color.FromArgb(120, 212, 175, 55), 1.2f)) {
                    g.DrawRectangle(stripBorder, 130f, botY, width - 260f, 50f);
                }

                using (Font footFont = new Font("Arial", 16, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush footBrush = new SolidBrush(Color.FromArgb(180, 195, 215)))
                using (Brush greenDot = new SolidBrush(Color.FromArgb(34, 197, 94))) {
                    g.FillEllipse(greenDot, 155f, botY + 19, 12, 12);
                    g.DrawString("OFFICIAL CREDENTIAL  •  MIRR CONSTRUCTION SERVICES  •  PROJECT OPERATIONS", footFont, footBrush, 180f, botY + 15);
                    
                    using (Brush goldTag = new SolidBrush(Color.FromArgb(234, 190, 63))) {
                        string regText = "PCAB LICENSED  |  SEC REG. 2026";
                        float regW = g.MeasureString(regText, footFont).Width;
                        g.DrawString(regText, footFont, goldTag, width - 130f - regW - 25f, botY + 15);
                    }
                }
            }

            SaveJpeg(bmp, outputPath, 98L);
        }
    }

    public static void GenerateBack(string logoPath, string bgPath, string outputPath) {
        int width = 2100;
        int height = 1200;

        using (Bitmap bmp = new Bitmap(width, height, PixelFormat.Format24bppRgb)) {
            bmp.SetResolution(300, 300);

            using (Graphics g = Graphics.FromImage(bmp)) {
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                // 1. Draw Construction Background (High Visibility)
                if (System.IO.File.Exists(bgPath)) {
                    using (Bitmap bgBmp = new Bitmap(bgPath)) {
                        bgBmp.RotateFlip(RotateFlipType.RotateNoneFlipX);
                        g.DrawImage(bgBmp, 0, 0, width, height);
                    }
                } else {
                    using (SolidBrush fallback = new SolidBrush(Color.FromArgb(12, 18, 30))) {
                        g.FillRectangle(fallback, 0, 0, width, height);
                    }
                }

                // Lightened Dark Overlay so the construction background is vividly clear
                using (LinearGradientBrush bgOverlay = new LinearGradientBrush(
                    new Point(0, 0), new Point(width, height),
                    Color.FromArgb(130, 6, 10, 20), Color.FromArgb(90, 10, 16, 28))) {
                    g.FillRectangle(bgOverlay, 0, 0, width, height);
                }

                // Geometric architectural isometric lines
                using (Pen geoPen = new Pen(Color.FromArgb(30, 212, 175, 55), 1.5f)) {
                    for (int i = -width; i < width * 2; i += 130) {
                        g.DrawLine(geoPen, i, 0, i + height, height);
                    }
                }

                // Outer Card Hairline Border
                float margin = 45f;
                using (Pen goldBorder = new Pen(Color.FromArgb(180, 212, 175, 55), 2.5f)) {
                    using (GraphicsPath bPath = GetRoundedRect(new RectangleF(margin, margin, width - margin * 2, height - margin * 2), 24f)) {
                        g.DrawPath(goldBorder, bPath);
                    }
                }

                // 2. Left Zone: Large Logo & Identity with Backing Glass Plaque
                float leftCenterX = 560f;
                float logoSize = 250f;

                using (Brush leftPlaque = new SolidBrush(Color.FromArgb(180, 8, 12, 22))) {
                    using (GraphicsPath lp = GetRoundedRect(new RectangleF(leftCenterX - 380, 140f, 760f, 750f), 18f)) {
                        g.FillPath(leftPlaque, lp);
                    }
                }
                using (Pen leftBorder = new Pen(Color.FromArgb(100, 212, 175, 55), 1.5f)) {
                    using (GraphicsPath lp = GetRoundedRect(new RectangleF(leftCenterX - 380, 140f, 760f, 750f), 18f)) {
                        g.DrawPath(leftBorder, lp);
                    }
                }

                // --- PERFECT CIRCLE LOGO (STRICT CIRCULAR CLIPPING FOR BACK) ---
                float ly = 230f;
                RectangleF circleRectBack = new RectangleF(leftCenterX - logoSize / 2f, ly, logoSize, logoSize);

                // Subtle outer gold glow
                using (Brush logoGlow = new SolidBrush(Color.FromArgb(50, 212, 175, 55))) {
                    g.FillEllipse(logoGlow, circleRectBack.X - 8, circleRectBack.Y - 8, logoSize + 16, logoSize + 16);
                }

                // Circle Background (Clean Pearl White Medallion)
                using (Brush circleBg = new SolidBrush(Color.FromArgb(250, 250, 252))) {
                    g.FillEllipse(circleBg, circleRectBack);
                }

                // Strictly clip logo inside the circle
                if (System.IO.File.Exists(logoPath)) {
                    using (Bitmap logoBmp = new Bitmap(logoPath)) {
                        GraphicsState gState = g.Save();
                        using (GraphicsPath clipPath = new GraphicsPath()) {
                            clipPath.AddEllipse(circleRectBack);
                            g.SetClip(clipPath);

                            float pad = 14f;
                            g.DrawImage(logoBmp, circleRectBack.X + pad, circleRectBack.Y + pad, logoSize - pad * 2, logoSize - pad * 2);
                        }
                        g.Restore(gState);
                    }
                }

                // Metallic Gold Bezel Rings around the circle
                using (Pen logoBorder = new Pen(Color.FromArgb(234, 190, 63), 4f)) {
                    g.DrawEllipse(logoBorder, circleRectBack);
                }
                using (Pen innerGoldRing = new Pen(Color.FromArgb(180, 212, 175, 55), 1.5f)) {
                    g.DrawEllipse(innerGoldRing, circleRectBack.X + 5, circleRectBack.Y + 5, logoSize - 10, logoSize - 10);
                }

                // Typography under logo
                using (Font brandFont = new Font("Arial", 46, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font subFont = new Font("Arial", 20, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font tagFont = new Font("Arial", 16, FontStyle.Regular, GraphicsUnit.Pixel))
                using (Brush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                using (Brush goldBrush = new SolidBrush(Color.FromArgb(234, 190, 63)))
                using (Brush slateBrush = new SolidBrush(Color.FromArgb(180, 195, 215)))
                using (StringFormat sfCenter = new StringFormat() { Alignment = StringAlignment.Center }) {
                    g.DrawString("MIRR CONSTRUCTION", brandFont, whiteBrush, leftCenterX, 550f, sfCenter);
                    g.DrawString("S E R V I C E S", subFont, goldBrush, leftCenterX, 610f, sfCenter);
                    g.DrawString("ENGINEERING & ARCHITECTURAL SOLUTIONS", tagFont, slateBrush, leftCenterX, 655f, sfCenter);
                }

                // Vertical Divider Line
                using (Pen divPen = new Pen(Color.FromArgb(120, 212, 175, 55), 2f)) {
                    g.DrawLine(divPen, 1050f, 160f, 1050f, height - 160f);
                }

                // 3. Right Zone: Core Capabilities (Inside Translucent Architectural Plaque)
                float rightStartX = 1140f;
                using (Brush plaqueBg = new SolidBrush(Color.FromArgb(180, 8, 12, 22))) {
                    using (GraphicsPath pPath = GetRoundedRect(new RectangleF(rightStartX - 30, 140f, 860f, 750f), 18f)) {
                        g.FillPath(plaqueBg, pPath);
                    }
                }
                using (Pen plaqueBorder = new Pen(Color.FromArgb(100, 212, 175, 55), 1.5f)) {
                    using (GraphicsPath pPath = GetRoundedRect(new RectangleF(rightStartX - 30, 140f, 860f, 750f), 18f)) {
                        g.DrawPath(plaqueBorder, pPath);
                    }
                }

                using (Font titleFont = new Font("Arial", 30, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font itemFont = new Font("Arial", 22, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font descFont = new Font("Arial", 17, FontStyle.Regular, GraphicsUnit.Pixel))
                using (Brush goldTitle = new SolidBrush(Color.FromArgb(234, 190, 63)))
                using (Brush itemWhite = new SolidBrush(Color.FromArgb(255, 255, 255)))
                using (Brush itemDesc = new SolidBrush(Color.FromArgb(180, 195, 215))) {
                    g.DrawString("CORE CAPABILITIES & SERVICES", titleFont, goldTitle, rightStartX, 175f);

                    string[,] services = {
                        { "Architectural & 3D Visualization", "Concept design, isometric cutaways, 8K rendering & walkthroughs" },
                        { "General Building Construction", "Residential luxury villas, commercial structures, post-tensioned builds" },
                        { "Civil & Structural Engineering", "Site supervision, structural design, BOQ & cost estimation" },
                        { "Interior Architecture & Fit-Out", "Custom joinery, luxury stone finishing & turn-key handover" }
                    };

                    float sy = 240f;
                    for (int i = 0; i < 4; i++) {
                        // Diamond bullet
                        using (Brush bulletBrush = new SolidBrush(Color.FromArgb(234, 190, 63))) {
                            PointF[] diamond = {
                                new PointF(rightStartX + 10, sy + 10),
                                new PointF(rightStartX + 20, sy),
                                new PointF(rightStartX + 30, sy + 10),
                                new PointF(rightStartX + 20, sy + 20)
                            };
                            g.FillPolygon(bulletBrush, diamond);
                        }

                        g.DrawString(services[i, 0], itemFont, itemWhite, rightStartX + 45, sy);
                        g.DrawString(services[i, 1], descFont, itemDesc, rightStartX + 45, sy + 30);
                        sy += 90f;
                    }
                }

                // Modern QR Code Mockup in Bottom Right
                float qrX = width - 400f;
                float qrY = height - 440f;
                float qrSize = 220f;

                using (Brush qrBg = new SolidBrush(Color.FromArgb(255, 255, 255))) {
                    using (GraphicsPath qPath = GetRoundedRect(new RectangleF(qrX, qrY, qrSize, qrSize), 16f)) {
                        g.FillPath(qrBg, qPath);
                    }
                }
                using (Pen qrBorder = new Pen(Color.FromArgb(212, 175, 55), 3f)) {
                    using (GraphicsPath qPath = GetRoundedRect(new RectangleF(qrX, qrY, qrSize, qrSize), 16f)) {
                        g.DrawPath(qrBorder, qPath);
                    }
                }

                using (Brush qrPixel = new SolidBrush(Color.FromArgb(15, 23, 42))) {
                    DrawQRMarker(g, qrPixel, qrX + 16, qrY + 16, 46);
                    DrawQRMarker(g, qrPixel, qrX + qrSize - 62, qrY + 16, 46);
                    DrawQRMarker(g, qrPixel, qrX + 16, qrY + qrSize - 62, 46);

                    Random rnd = new Random(42);
                    for (int r = 0; r < 14; r++) {
                        for (int c = 0; c < 14; c++) {
                            float px = qrX + 22 + c * 13;
                            float py = qrY + 22 + r * 13;
                            bool inM1 = c < 6 && r < 6;
                            bool inM2 = c > 7 && r < 6;
                            bool inM3 = c < 6 && r > 7;
                            if (!inM1 && !inM2 && !inM3 && rnd.Next(10) > 4) {
                                g.FillRectangle(qrPixel, px, py, 9, 9);
                            }
                        }
                    }

                    g.FillRectangle(new SolidBrush(Color.FromArgb(212, 175, 55)), qrX + qrSize / 2 - 13, qrY + qrSize / 2 - 13, 26, 26);
                }

                using (Font qrLabelFont = new Font("Arial", 14, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush qrLabelBrush = new SolidBrush(Color.FromArgb(212, 175, 55)))
                using (StringFormat sfQr = new StringFormat() { Alignment = StringAlignment.Center }) {
                    g.DrawString("SCAN FOR DIGITAL VCARD", qrLabelFont, qrLabelBrush, qrX + qrSize / 2, qrY + qrSize + 12, sfQr);
                }

                // Bottom Tagline
                using (Font footFont = new Font("Arial", 16, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush footBrush = new SolidBrush(Color.FromArgb(140, 160, 190))) {
                    g.DrawString("WWW.MIRRCONSTRUCTION.PH  •  VERIFY@MIRRCONSTRUCTION.PH  •  ALL RIGHTS RESERVED", footFont, footBrush, 130f, height - 90f);
                }
            }

            SaveJpeg(bmp, outputPath, 98L);
        }
    }

    private static void DrawQRMarker(Graphics g, Brush b, float x, float y, float size) {
        g.FillRectangle(b, x, y, size, size);
        g.FillRectangle(Brushes.White, x + 7, y + 7, size - 14, size - 14);
        g.FillRectangle(b, x + 14, y + 14, size - 28, size - 28);
    }

    private static GraphicsPath GetRoundedRect(RectangleF rect, float radius) {
        GraphicsPath path = new GraphicsPath();
        float d = radius * 2.0f;
        path.AddArc(rect.X, rect.Y, d, d, 180, 90);
        path.AddArc(rect.Right - d, rect.Y, d, d, 270, 90);
        path.AddArc(rect.Right - d, rect.Bottom - d, d, d, 0, 90);
        path.AddArc(rect.X, rect.Bottom - d, d, d, 90, 90);
        path.CloseFigure();
        return path;
    }

    private static void SaveJpeg(Bitmap bmp, string path, long quality) {
        if (System.IO.File.Exists(path)) {
            System.IO.File.Delete(path);
        }
        ImageCodecInfo jpgEncoder = null;
        foreach (ImageCodecInfo codec in ImageCodecInfo.GetImageDecoders()) {
            if (codec.FormatID == ImageFormat.Jpeg.Guid) {
                jpgEncoder = codec;
                break;
            }
        }
        EncoderParameters encParams = new EncoderParameters(1);
        encParams.Param[0] = new EncoderParameter(Encoder.Quality, quality);
        bmp.Save(path, jpgEncoder, encParams);
        Console.WriteLine("Successfully created: " + path);
    }
}
"@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Drawing"

$logo = "D:\PHOTO DESIGNING\MIRR_Official_Logo.jpg"
$bg = "D:\PHOTO DESIGNING\construction_background_texture.jpg"
$frontOut = "D:\PHOTO DESIGNING\MIRR_Business_Card_Front.jpg"
$backOut = "D:\PHOTO DESIGNING\MIRR_Business_Card_Back.jpg"
$brainFront = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Business_Card_Front.jpg"
$brainBack = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Business_Card_Back.jpg"

[BusinessCardGenerator]::GenerateFront($logo, $bg, $frontOut)
[BusinessCardGenerator]::GenerateBack($logo, $bg, $backOut)

Copy-Item $frontOut $brainFront -Force
Copy-Item $backOut $brainBack -Force

Write-Host "Business cards with perfectly circular-framed logo generated successfully!"
