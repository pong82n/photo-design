Add-Type -AssemblyName System.Drawing

$code = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;

public class VideoOverlayGenerator {
    public static void GenerateOverlays(string outputDir) {
        int width = 1920;
        int height = 1080;

        // 1. Intro Card
        using (Bitmap bmp = new Bitmap(width, height, PixelFormat.Format32bppArgb))
        using (Graphics g = Graphics.FromImage(bmp)) {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.TextRenderingHint = TextRenderingHint.AntiAliasGridFit;

            // Deep luxury background
            using (LinearGradientBrush bg = new LinearGradientBrush(new Point(0, 0), new Point(0, height),
                Color.FromArgb(255, 8, 12, 20), Color.FromArgb(255, 15, 23, 42))) {
                g.FillRectangle(bg, 0, 0, width, height);
            }

            // Subtle gold framing lines
            using (Pen goldPen = new Pen(Color.FromArgb(160, 212, 175, 55), 1.5f)) {
                g.DrawRectangle(goldPen, 80, 80, width - 160, height - 160);
                g.DrawRectangle(goldPen, 90, 90, width - 180, height - 180);
            }

            // Badge
            using (SolidBrush badgeBrush = new SolidBrush(Color.FromArgb(255, 212, 175, 55))) {
                g.FillRectangle(badgeBrush, width / 2 - 60, 360, 120, 32);
            }
            using (Font badgeFont = new Font("Arial", 14, FontStyle.Bold))
            using (SolidBrush textDark = new SolidBrush(Color.FromArgb(255, 11, 15, 23))) {
                StringFormat sfCenter = new StringFormat { Alignment = StringAlignment.Center, LineAlignment = StringAlignment.Center };
                g.DrawString("MIRR", badgeFont, textDark, new RectangleF(width / 2 - 60, 360, 120, 32), sfCenter);
            }

            // Main Title
            using (Font titleFont = new Font("Georgia", 52, FontStyle.Bold))
            using (SolidBrush whiteBrush = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
                StringFormat sfCenter = new StringFormat { Alignment = StringAlignment.Center, LineAlignment = StringAlignment.Center };
                g.DrawString("THE LUMINA PAVILION", titleFont, whiteBrush, new RectangleF(0, 420, width, 80), sfCenter);
            }

            // Subtitle
            using (Font subFont = new Font("Arial", 20, FontStyle.Regular))
            using (SolidBrush goldText = new SolidBrush(Color.FromArgb(255, 243, 229, 171))) {
                StringFormat sfCenter = new StringFormat { Alignment = StringAlignment.Center, LineAlignment = StringAlignment.Center };
                g.DrawString("A MODERN LUXURY 3-STOREY RESIDENTIAL ARCHITECTURAL TOUR", subFont, goldText, new RectangleF(0, 520, width, 40), sfCenter);
            }

            // Spec line
            using (Font descFont = new Font("Arial", 14, FontStyle.Regular))
            using (SolidBrush mutedText = new SolidBrush(Color.FromArgb(255, 148, 163, 184))) {
                StringFormat sfCenter = new StringFormat { Alignment = StringAlignment.Center, LineAlignment = StringAlignment.Center };
                g.DrawString("685 SQM GFA  •  3 LEVELS  •  INFINITY SKY SPA  •  2026 ARCHITECTURAL COLLECTION", descFont, mutedText, new RectangleF(0, 580, width, 40), sfCenter);
            }

            bmp.Save(System.IO.Path.Combine(outputDir, "card_intro.png"), ImageFormat.Png);
        }

        // 2. Outro Card
        using (Bitmap bmp = new Bitmap(width, height, PixelFormat.Format32bppArgb))
        using (Graphics g = Graphics.FromImage(bmp)) {
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.TextRenderingHint = TextRenderingHint.AntiAliasGridFit;

            using (LinearGradientBrush bg = new LinearGradientBrush(new Point(0, 0), new Point(0, height),
                Color.FromArgb(255, 8, 12, 20), Color.FromArgb(255, 15, 23, 42))) {
                g.FillRectangle(bg, 0, 0, width, height);
            }

            using (Pen goldPen = new Pen(Color.FromArgb(160, 212, 175, 55), 1.5f)) {
                g.DrawRectangle(goldPen, 80, 80, width - 160, height - 160);
            }

            using (Font titleFont = new Font("Georgia", 48, FontStyle.Bold))
            using (SolidBrush whiteBrush = new SolidBrush(Color.White)) {
                StringFormat sfCenter = new StringFormat { Alignment = StringAlignment.Center, LineAlignment = StringAlignment.Center };
                g.DrawString("THE LUMINA PAVILION", titleFont, whiteBrush, new RectangleF(0, 420, width, 70), sfCenter);
            }

            using (Font subFont = new Font("Arial", 18, FontStyle.Bold))
            using (SolidBrush goldText = new SolidBrush(Color.FromArgb(255, 212, 175, 55))) {
                StringFormat sfCenter = new StringFormat { Alignment = StringAlignment.Center, LineAlignment = StringAlignment.Center };
                g.DrawString("MIRR CONSTRUCTION SERVICES", subFont, goldText, new RectangleF(0, 510, width, 40), sfCenter);
            }

            using (Font descFont = new Font("Arial", 14, FontStyle.Regular))
            using (SolidBrush mutedText = new SolidBrush(Color.FromArgb(255, 148, 163, 184))) {
                StringFormat sfCenter = new StringFormat { Alignment = StringAlignment.Center, LineAlignment = StringAlignment.Center };
                g.DrawString("Site Operations & Civil Engineering  •  Raffy T. Soguilon, Project In-Charge", descFont, mutedText, new RectangleF(0, 560, width, 30), sfCenter);
            }

            bmp.Save(System.IO.Path.Combine(outputDir, "card_outro.png"), ImageFormat.Png);
        }

        // 3. Lower-Third Overlays (Transparent PNGs)
        string[] tags = {
            "01 // ARRIVAL & EXTERIOR FACADE",
            "02 // GROUND FLOOR GREAT ROOM",
            "03 // LEVEL TWO MASTER SANCTUARY",
            "04 // LEVEL THREE ROOFTOP SKY LOUNGE",
            "05 // NIGHTFALL ARCHITECTURAL ILLUMINATION"
        };
        string[] titles = {
            "Geometric Cantilevers & Teak Wood Facade",
            "Double-Height Atrium & Calacatta Marble Fireplace",
            "Master Suite Sanctuary & Cantilevered Terrace",
            "Penthouse Sunken Firepit & Sunset Plunge Spa",
            "Twilight Illumination & Water Caustics"
        };
        string[] subs = {
            "685 sqm GFA  •  White Concrete Cantilevers  •  Tropical Reflection Pool",
            "6.0m Ceiling Height  •  Linear Ethanol Fireplace  •  Infinity Pool Lanai",
            "White Oak Herringbone Flooring  •  Acoustic Walnut Fluting  •  Spa Ensuite",
            "Motorized Louvered Pergola  •  Quartz Cocktail Bar  •  Sunken Gas Firepit",
            "3000K Linear LED Grazers  •  Turquoise Pool Underglow  •  Atmospheric Blue Hour"
        };

        for (int i = 0; i < 5; i++) {
            using (Bitmap bmp = new Bitmap(width, height, PixelFormat.Format32bppArgb))
            using (Graphics g = Graphics.FromImage(bmp)) {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.TextRenderingHint = TextRenderingHint.AntiAliasGridFit;

                // Lower third container box
                float boxX = 70;
                float boxY = height - 210;
                float boxW = 820;
                float boxH = 135;

                using (SolidBrush boxBg = new SolidBrush(Color.FromArgb(215, 11, 16, 27))) {
                    g.FillRectangle(boxBg, boxX, boxY, boxW, boxH);
                }
                using (Pen borderPen = new Pen(Color.FromArgb(100, 255, 255, 255), 1.0f)) {
                    g.DrawRectangle(borderPen, boxX, boxY, boxW, boxH);
                }
                // Gold accent bar on left
                using (SolidBrush goldBar = new SolidBrush(Color.FromArgb(255, 212, 175, 55))) {
                    g.FillRectangle(goldBar, boxX, boxY, 6, boxH);
                }

                // Tag
                using (Font tagFont = new Font("Arial", 11, FontStyle.Bold))
                using (SolidBrush goldText = new SolidBrush(Color.FromArgb(255, 212, 175, 55))) {
                    g.DrawString(tags[i], tagFont, goldText, boxX + 24, boxY + 16);
                }

                // Title
                using (Font titleFont = new Font("Georgia", 22, FontStyle.Bold))
                using (SolidBrush whiteText = new SolidBrush(Color.White)) {
                    g.DrawString(titles[i], titleFont, whiteText, boxX + 24, boxY + 38);
                }

                // Sub
                using (Font subFont = new Font("Arial", 13, FontStyle.Regular))
                using (SolidBrush mutedText = new SolidBrush(Color.FromArgb(255, 203, 213, 225))) {
                    g.DrawString(subs[i], subFont, mutedText, boxX + 24, boxY + 84);
                }

                bmp.Save(System.IO.Path.Combine(outputDir, string.Format("overlay_scene_{0}.png", i + 1)), ImageFormat.Png);
            }
        }
    }
}
"@

Add-Type -TypeDefinition $code -ReferencedAssemblies "System.Drawing"

$outDir = "D:\PHOTO DESIGNING\scratch"
[VideoOverlayGenerator]::GenerateOverlays($outDir)
Write-Host "Overlays generated successfully in $outDir"
