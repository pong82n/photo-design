Add-Type -AssemblyName System.Drawing

$csharpCode = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class PerfectCardEmbedder {
    public static void GenerateFittedSmoothCurvedCard(string baseCardPath, string photoPath, string[] outputPaths) {
        using (Bitmap cardBmp = new Bitmap(baseCardPath))
        using (Bitmap photoBmp = new Bitmap(photoPath))
        using (Bitmap result = new Bitmap(cardBmp.Width, cardBmp.Height, PixelFormat.Format24bppRgb)) {
            result.SetResolution(cardBmp.HorizontalResolution, cardBmp.VerticalResolution);

            using (Graphics g = Graphics.FromImage(result)) {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;

                // 1. Draw base card image
                g.DrawImage(cardBmp, 0, 0, cardBmp.Width, cardBmp.Height);

                // 2. Exact line boundary coordinates of the card's ID picture frame
                // Center X = 424. Left = 284.5, Right = 563.5 (W = 279.0)
                // Top = 345.5, Bottom = 665.5 (H = 320.0)
                float frameX = 284.5f;
                float frameY = 345.5f;
                float frameW = 279.0f;
                float frameH = 320.0f;
                float cornerRadius = 30.0f; // Smooth curved corners matching the card frame

                using (GraphicsPath path = GetRoundedRect(new RectangleF(frameX, frameY, frameW, frameH), cornerRadius)) {
                    // Save state and clip to the smooth curved boundary line
                    GraphicsState state = g.Save();
                    g.SetClip(path);

                    // Scale photo to fit the line boundary with balanced head & chest positioning
                    float srcW = photoBmp.Width;
                    float srcH = photoBmp.Height;
                    float scale = Math.Max(frameW / srcW, frameH / srcH) * 1.02f; // subtle 2% scale for perfect edge coverage
                    float drawW = srcW * scale;
                    float drawH = srcH * scale;
                    float drawX = frameX + (frameW - drawW) * 0.5f;
                    float drawY = frameY - 8.0f; // slight upward nudge for chest logo visibility

                    g.DrawImage(photoBmp, drawX, drawY, drawW, drawH);
                    g.Restore(state);

                    // 3. Draw a crisp, smooth curved cyan/titanium boundary line
                    // Dark bevel line behind for deep contrast against background
                    using (Pen darkPen = new Pen(Color.FromArgb(140, 15, 23, 42), 3.5f)) {
                        g.DrawPath(darkPen, path);
                    }
                    // Crisp light cyan/silver line (flush with card wireframe boundary)
                    using (Pen cyanPen = new Pen(Color.FromArgb(240, 186, 216, 232), 2.2f)) {
                        g.DrawPath(cyanPen, path);
                    }
                }
            }

            // Save high quality JPEG to all designated outputs
            ImageCodecInfo encoder = GetEncoder(ImageFormat.Jpeg);
            EncoderParameters encParams = new EncoderParameters(1);
            encParams.Param[0] = new EncoderParameter(Encoder.Quality, 98L);

            foreach (string outPath in outputPaths) {
                if (System.IO.File.Exists(outPath)) {
                    System.IO.File.Delete(outPath);
                }
                result.Save(outPath, encoder, encParams);
                Console.WriteLine("Saved: " + outPath);
            }
        }
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

    private static ImageCodecInfo GetEncoder(ImageFormat format) {
        ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
        foreach (ImageCodecInfo codec in codecs) {
            if (codec.FormatID == format.Guid) {
                return codec;
            }
        }
        return null;
    }
}
"@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Drawing"

$baseCard = "D:\PHOTO DESIGNING\MIRR_Modern_ID_Front_RaffySoguilon.jpg"
$photo = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"

$outputs = @(
    "D:\PHOTO DESIGNING\MIRR_Modern_ID_Front.jpg",
    "D:\PHOTO DESIGNING\MIRR_Employee_ID_Front.jpg",
    "D:\PHOTO DESIGNING\MIRR_Modern_ID_Front_WithExactPhoto.jpg",
    "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Modern_ID_Front.jpg",
    "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Employee_ID_Front.jpg",
    "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Modern_ID_Front_WithExactPhoto.jpg"
)

[PerfectCardEmbedder]::GenerateFittedSmoothCurvedCard($baseCard, $photo, $outputs)
Write-Host "All cards regenerated with smooth curved corners fitted to line boundary!"
