Add-Type -AssemblyName System.Drawing

$csharpCode = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class BusinessCardGenerator {

    public static void GenerateFront(string logoPath, string outputPath) {
        int width = 2100;
        int height = 1200;

        using (Bitmap bmp = new Bitmap(width, height, PixelFormat.Format24bppRgb)) {
            bmp.SetResolution(300, 300);

            using (Graphics g = Graphics.FromImage(bmp)) {
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                // 1. Background Gradient (Deep Architectural Slate/Navy)
                using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                    new Point(0, 0), new Point(width, height),
                    Color.FromArgb(10, 15, 26), Color.FromArgb(18, 27, 44))) {
                    g.FillRectangle(bgBrush, 0, 0, width, height);
                }

                // Subtle Radial Glow behind logo
                using (GraphicsPath radialPath = new GraphicsPath()) {
                    radialPath.AddEllipse(-100, -100, 900, 900);
                    using (PathGradientBrush pgb = new PathGradientBrush(radialPath)) {
                        pgb.CenterColor = Color.FromArgb(35, 212, 175, 55); // Warm gold glow
                        pgb.SurroundColors = new Color[] { Color.Transparent };
                        g.FillPath(pgb, radialPath);
                    }
                }

                // Subtle Architectural Grid Lines
                using (Pen gridPen = new Pen(Color.FromArgb(18, 255, 255, 255), 1.5f)) {
                    for (int x = 100; x < width; x += 150) {
                        g.DrawLine(gridPen, x, 0, x, height);
                    }
                    for (int y = 100; y < height; y += 150) {
                        g.DrawLine(gridPen, 0, y, width, y);
                    }
                }

                // Diagonal Architectural Accent Line
                using (Pen accentLine = new Pen(Color.FromArgb(50, 212, 175, 55), 2.0f)) {
                    g.DrawLine(accentLine, 1300, 0, 950, height);
                }
                using (Pen accentGlow = new Pen(Color.FromArgb(30, 56, 189, 248), 1.5f)) {
                    g.DrawLine(accentGlow, 1315, 0, 965, height);
                }

                // Outer Card Hairline Border with Inner Margin
                float margin = 50f;
                using (Pen goldBorder = new Pen(Color.FromArgb(90, 212, 175, 55), 2.5f)) {
                    using (GraphicsPath bPath = GetRoundedRect(new RectangleF(margin, margin, width - margin * 2, height - margin * 2), 24f)) {
                        g.DrawPath(goldBorder, bPath);
                    }
                }

                // 2. Logo & Company Name (Top Left Zone)
                float logoX = 130f;
                float logoY = 130f;
                float logoSize = 180f;

                if (System.IO.File.Exists(logoPath)) {
                    using (Bitmap logoBmp = new Bitmap(logoPath)) {
                        // Circular badge background for logo
                        using (Brush badgeBg = new SolidBrush(Color.FromArgb(24, 33, 52))) {
                            g.FillEllipse(badgeBg, logoX - 10, logoY - 10, logoSize + 20, logoSize + 20);
                        }
                        using (Pen badgeBorder = new Pen(Color.FromArgb(200, 212, 175, 55), 3f)) {
                            g.DrawEllipse(badgeBorder, logoX - 10, logoY - 10, logoSize + 20, logoSize + 20);
                        }
                        g.DrawImage(logoBmp, logoX, logoY, logoSize, logoSize);
                    }
                }

                // Company Name Typography
                using (Font brandFont = new Font("Arial", 42, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font subBrandFont = new Font("Arial", 19, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                using (Brush goldBrush = new SolidBrush(Color.FromArgb(220, 180, 60)))
                using (Brush slateBrush = new SolidBrush(Color.FromArgb(148, 163, 184))) {
                    float textStartX = logoX + logoSize + 45f;
                    g.DrawString("MIRR", brandFont, whiteBrush, textStartX, logoY + 15);
                    float mirrWidth = g.MeasureString("MIRR ", brandFont).Width;
                    g.DrawString("CONSTRUCTION", brandFont, goldBrush, textStartX + mirrWidth - 8, logoY + 15);
                    g.DrawString("S E R V I C E S", subBrandFont, slateBrush, textStartX, logoY + 75);

                    // Tagline pill
                    g.DrawString("ARCHITECTURAL DESIGN  •  GENERAL CONTRACTING  •  PROJECT MANAGEMENT",
                        new Font("Arial", 15, FontStyle.Bold, GraphicsUnit.Pixel),
                        new SolidBrush(Color.FromArgb(180, 203, 213, 225)),
                        textStartX, logoY + 120);
                }

                // 3. Employee Name & Designation (Left-Center Zone)
                float personY = 490f;
                using (Font nameFont = new Font("Arial", 62, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font roleFont = new Font("Arial", 26, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font divFont = new Font("Arial", 21, FontStyle.Regular, GraphicsUnit.Pixel))
                using (Brush nameBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                using (Brush goldRoleBrush = new SolidBrush(Color.FromArgb(234, 190, 63)))
                using (Brush divBrush = new SolidBrush(Color.FromArgb(160, 175, 200))) {
                    g.DrawString("RAFFY T. SOGUILON", nameFont, nameBrush, 130f, personY);

                    // Accent Bar under Name
                    using (Brush barBrush = new LinearGradientBrush(
                        new PointF(130f, personY + 80), new PointF(400f, personY + 80),
                        Color.FromArgb(234, 190, 63), Color.Transparent)) {
                        g.FillRectangle(barBrush, 130f, personY + 82, 380f, 4f);
                    }

                    g.DrawString("PROJECT IN-CHARGE", roleFont, goldRoleBrush, 130f, personY + 105);
                    g.DrawString("Site Operations & Civil Engineering Division", divFont, divBrush, 130f, personY + 148);
                }

                // 4. Contact Details Block (Right Column)
                float contactX = 1260f;
                float contactY = 480f;
                float lineSpacing = 82f;

                using (Font contactFont = new Font("Arial", 24, FontStyle.Regular, GraphicsUnit.Pixel))
                using (Font labelFont = new Font("Arial", 16, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush labelBrush = new SolidBrush(Color.FromArgb(212, 175, 55)))
                using (Brush valBrush = new SolidBrush(Color.FromArgb(240, 245, 250)))
                using (Brush iconBg = new SolidBrush(Color.FromArgb(25, 36, 56)))
                using (Pen iconBorder = new Pen(Color.FromArgb(80, 212, 175, 55), 1.5f)) {

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

                // 5. Bottom Status Strip
                float botY = height - 120f;
                using (Brush stripBg = new SolidBrush(Color.FromArgb(15, 22, 36))) {
                    g.FillRectangle(stripBg, 130f, botY, width - 260f, 50f);
                }
                using (Pen stripBorder = new Pen(Color.FromArgb(40, 255, 255, 255), 1f)) {
                    g.DrawRectangle(stripBorder, 130f, botY, width - 260f, 50f);
                }

                using (Font footFont = new Font("Arial", 16, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush footBrush = new SolidBrush(Color.FromArgb(148, 163, 184)))
                using (Brush greenDot = new SolidBrush(Color.FromArgb(34, 197, 94))) {
                    g.FillEllipse(greenDot, 155f, botY + 19, 12, 12);
                    g.DrawString("OFFICIAL CREDENTIAL  •  MIRR CONSTRUCTION SERVICES  •  PROJECT OPERATIONS", footFont, footBrush, 180f, botY + 15);
                    
                    using (Brush goldTag = new SolidBrush(Color.FromArgb(212, 175, 55))) {
                        string regText = "PCAB LICENSED  |  SEC REG. 2026";
                        float regW = g.MeasureString(regText, footFont).Width;
                        g.DrawString(regText, footFont, goldTag, width - 130f - regW - 25f, botY + 15);
                    }
                }
            }

            SaveJpeg(bmp, outputPath, 98L);
        }
    }

    public static void GenerateBack(string logoPath, string outputPath) {
        int width = 2100;
        int height = 1200;

        using (Bitmap bmp = new Bitmap(width, height, PixelFormat.Format24bppRgb)) {
            bmp.SetResolution(300, 300);

            using (Graphics g = Graphics.FromImage(bmp)) {
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;

                // 1. Background
                using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                    new Point(0, 0), new Point(width, height),
                    Color.FromArgb(12, 18, 30), Color.FromArgb(7, 10, 18))) {
                    g.FillRectangle(bgBrush, 0, 0, width, height);
                }

                // Geometric architectural isometric lines
                using (Pen geoPen = new Pen(Color.FromArgb(16, 212, 175, 55), 1.5f)) {
                    for (int i = -width; i < width * 2; i += 120) {
                        g.DrawLine(geoPen, i, 0, i + height, height);
                    }
                }

                // Outer Card Hairline Border
                float margin = 50f;
                using (Pen goldBorder = new Pen(Color.FromArgb(90, 212, 175, 55), 2.5f)) {
                    using (GraphicsPath bPath = GetRoundedRect(new RectangleF(margin, margin, width - margin * 2, height - margin * 2), 24f)) {
                        g.DrawPath(goldBorder, bPath);
                    }
                }

                // 2. Left Zone: Large Logo & Identity
                float leftCenterX = 560f;
                float logoSize = 240f;

                if (System.IO.File.Exists(logoPath)) {
                    using (Bitmap logoBmp = new Bitmap(logoPath)) {
                        float lx = leftCenterX - logoSize / 2f;
                        float ly = 320f;
                        
                        using (Brush logoGlow = new SolidBrush(Color.FromArgb(20, 212, 175, 55))) {
                            g.FillEllipse(logoGlow, lx - 30, ly - 30, logoSize + 60, logoSize + 60);
                        }
                        using (Brush logoBg = new SolidBrush(Color.FromArgb(20, 30, 48))) {
                            g.FillEllipse(logoBg, lx - 10, ly - 10, logoSize + 20, logoSize + 20);
                        }
                        using (Pen logoBorder = new Pen(Color.FromArgb(212, 175, 55), 3.5f)) {
                            g.DrawEllipse(logoBorder, lx - 10, ly - 10, logoSize + 20, logoSize + 20);
                        }
                        g.DrawImage(logoBmp, lx, ly, logoSize, logoSize);
                    }
                }

                using (Font brandFont = new Font("Arial", 46, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font subFont = new Font("Arial", 20, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font tagFont = new Font("Arial", 16, FontStyle.Regular, GraphicsUnit.Pixel))
                using (Brush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255)))
                using (Brush goldBrush = new SolidBrush(Color.FromArgb(220, 180, 60)))
                using (Brush slateBrush = new SolidBrush(Color.FromArgb(148, 163, 184)))
                using (StringFormat sfCenter = new StringFormat() { Alignment = StringAlignment.Center }) {
                    g.DrawString("MIRR CONSTRUCTION", brandFont, whiteBrush, leftCenterX, 620f, sfCenter);
                    g.DrawString("S E R V I C E S", subFont, goldBrush, leftCenterX, 680f, sfCenter);
                    g.DrawString("ENGINEERING & ARCHITECTURAL SOLUTIONS", tagFont, slateBrush, leftCenterX, 725f, sfCenter);
                }

                // Vertical Divider Line
                using (Pen divPen = new Pen(Color.FromArgb(60, 212, 175, 55), 2f)) {
                    g.DrawLine(divPen, 1050f, 180f, 1050f, height - 180f);
                }

                // 3. Right Zone: Core Capabilities & Scannable QR Code Box
                float rightStartX = 1140f;
                using (Font titleFont = new Font("Arial", 30, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font itemFont = new Font("Arial", 22, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Font descFont = new Font("Arial", 18, FontStyle.Regular, GraphicsUnit.Pixel))
                using (Brush goldTitle = new SolidBrush(Color.FromArgb(234, 190, 63)))
                using (Brush itemWhite = new SolidBrush(Color.FromArgb(255, 255, 255)))
                using (Brush itemDesc = new SolidBrush(Color.FromArgb(148, 163, 184))) {
                    g.DrawString("CORE CAPABILITIES & SERVICES", titleFont, goldTitle, rightStartX, 180f);

                    string[,] services = {
                        { "Architectural & 3D Visualization", "Concept design, isometric cutaways, 8K rendering & walkthroughs" },
                        { "General Building Construction", "Residential luxury villas, commercial structures, post-tensioned builds" },
                        { "Civil & Structural Engineering", "Site supervision, structural design, BOQ & cost estimation" },
                        { "Interior Architecture & Fit-Out", "Custom joinery, luxury stone finishing & turn-key handover" }
                    };

                    float sy = 250f;
                    for (int i = 0; i < 4; i++) {
                        // Diamond bullet
                        using (Brush bulletBrush = new SolidBrush(Color.FromArgb(212, 175, 55))) {
                            PointF[] diamond = {
                                new PointF(rightStartX + 10, sy + 10),
                                new PointF(rightStartX + 20, sy),
                                new PointF(rightStartX + 30, sy + 10),
                                new PointF(rightStartX + 20, sy + 20)
                            };
                            g.FillPolygon(bulletBrush, diamond);
                        }

                        g.DrawString(services[i, 0], itemFont, itemWhite, rightStartX + 45, sy);
                        g.DrawString(services[i, 1], descFont, itemDesc, rightStartX + 45, sy + 32);
                        sy += 95f;
                    }
                }

                // Modern QR Code Mockup in Bottom Right
                float qrX = width - 420f;
                float qrY = height - 420f;
                float qrSize = 240f;

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

                // Draw realistic QR pattern
                using (Brush qrPixel = new SolidBrush(Color.FromArgb(15, 23, 42))) {
                    // Position corners (3 large markers)
                    DrawQRMarker(g, qrPixel, qrX + 20, qrY + 20, 50);
                    DrawQRMarker(g, qrPixel, qrX + qrSize - 70, qrY + 20, 50);
                    DrawQRMarker(g, qrPixel, qrX + 20, qrY + qrSize - 70, 50);

                    // Stylized data grid
                    Random rnd = new Random(42);
                    for (int r = 0; r < 14; r++) {
                        for (int c = 0; c < 14; c++) {
                            float px = qrX + 24 + c * 14;
                            float py = qrY + 24 + r * 14;
                            // avoid corner markers
                            bool inM1 = c < 6 && r < 6;
                            bool inM2 = c > 7 && r < 6;
                            bool inM3 = c < 6 && r > 7;
                            if (!inM1 && !inM2 && !inM3 && rnd.Next(10) > 4) {
                                g.FillRectangle(qrPixel, px, py, 10, 10);
                            }
                        }
                    }

                    // Center Logo micro-dot
                    g.FillRectangle(new SolidBrush(Color.FromArgb(212, 175, 55)), qrX + qrSize / 2 - 14, qrY + qrSize / 2 - 14, 28, 28);
                }

                using (Font qrLabelFont = new Font("Arial", 14, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush qrLabelBrush = new SolidBrush(Color.FromArgb(212, 175, 55)))
                using (StringFormat sfQr = new StringFormat() { Alignment = StringAlignment.Center }) {
                    g.DrawString("SCAN FOR DIGITAL VCARD", qrLabelFont, qrLabelBrush, qrX + qrSize / 2, qrY + qrSize + 12, sfQr);
                }

                // Bottom Tagline
                using (Font footFont = new Font("Arial", 16, FontStyle.Bold, GraphicsUnit.Pixel))
                using (Brush footBrush = new SolidBrush(Color.FromArgb(110, 130, 160))) {
                    g.DrawString("WWW.MIRRCONSTRUCTION.PH  •  VERIFY@MIRRCONSTRUCTION.PH  •  ALL RIGHTS RESERVED", footFont, footBrush, 130f, height - 100f);
                }
            }

            SaveJpeg(bmp, outputPath, 98L);
        }
    }

    private static void DrawQRMarker(Graphics g, Brush b, float x, float y, float size) {
        g.FillRectangle(b, x, y, size, size);
        g.FillRectangle(Brushes.White, x + 8, y + 8, size - 16, size - 16);
        g.FillRectangle(b, x + 16, y + 16, size - 32, size - 32);
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
$frontOut = "D:\PHOTO DESIGNING\MIRR_Business_Card_Front.jpg"
$backOut = "D:\PHOTO DESIGNING\MIRR_Business_Card_Back.jpg"
$brainFront = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Business_Card_Front.jpg"
$brainBack = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Business_Card_Back.jpg"

[BusinessCardGenerator]::GenerateFront($logo, $frontOut)
[BusinessCardGenerator]::GenerateBack($logo, $backOut)

Copy-Item $frontOut $brainFront -Force
Copy-Item $backOut $brainBack -Force

Write-Host "Business cards generated successfully!"
