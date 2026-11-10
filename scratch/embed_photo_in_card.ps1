Add-Type -AssemblyName System.Drawing

$csharpEmbedder = @"
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public class CardPhotoEmbedder {
    public static void EmbedUserPhoto(string cardPath, string photoPath, string outputPath) {
        using (Bitmap cardBmp = new Bitmap(cardPath))
        using (Bitmap photoBmp = new Bitmap(photoPath)) {
            int cardW = cardBmp.Width;
            int cardH = cardBmp.Height;

            using (Bitmap result = new Bitmap(cardW, cardH, PixelFormat.Format24bppRgb)) {
                result.SetResolution(cardBmp.HorizontalResolution, cardBmp.VerticalResolution);

                using (Graphics g = Graphics.FromImage(result)) {
                    g.SmoothingMode = SmoothingMode.AntiAlias;
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;

                    // 1. Draw base card image
                    g.DrawImage(cardBmp, 0, 0, cardW, cardH);

                    // 2. Exact photo frame target rectangle on the card
                    // From previous scan: X ~ 292 to 556 (W=264), Y ~ 358 to 642 (H=284)
                    float frameX = 290f;
                    float frameY = 356f;
                    float frameW = 268f;
                    float frameH = 286f;
                    float cornerRadius = 18f;

                    // Create rounded rectangle path for the photo
                    GraphicsPath photoClipPath = GetRoundedRect(new RectangleF(frameX, frameY, frameW, frameH), cornerRadius);

                    // Save state before clipping
                    GraphicsState gState = g.Save();
                    g.SetClip(photoClipPath);

                    // Draw the user's exact ID photo inside the frame (centered and cropped to fill)
                    // Photo aspect ratio is 896x1200 (approx 3:4). Target is 268x286.
                    float srcW = photoBmp.Width;
                    float srcH = photoBmp.Height;

                    // Calculate scale to cover
                    float scale = Math.Max(frameW / srcW, frameH / srcH);
                    float drawW = srcW * scale;
                    float drawH = srcH * scale;
                    float drawX = frameX + (frameW - drawW) * 0.5f;
                    float drawY = frameY; // align top for headshot

                    g.DrawImage(photoBmp, drawX, drawY, drawW, drawH);

                    // Restore state after clipping
                    g.Restore(gState);

                    // 3. Draw clean modern frame border with subtle neon accent
                    using (Pen framePen = new Pen(Color.FromArgb(220, 255, 87, 34), 2.2f)) {
                        g.DrawPath(framePen, photoClipPath);
                    }
                    using (Pen glowPen = new Pen(Color.FromArgb(50, 56, 189, 248), 1.0f)) {
                        RectangleF glowRect = new RectangleF(frameX - 1, frameY - 1, frameW + 2, frameH + 2);
                        using (GraphicsPath glowPath = GetRoundedRect(glowRect, cornerRadius + 1)) {
                            g.DrawPath(glowPen, glowPath);
                        }
                    }

                    // 4. Draw Gold Smart Chip Icon at bottom right of the photo frame
                    float chipW = 46f;
                    float chipH = 36f;
                    float chipX = frameX + frameW - chipW + 8f;
                    float chipY = frameY + frameH - chipH + 6f;
                    RectangleF chipRect = new RectangleF(chipX, chipY, chipW, chipH);

                    using (GraphicsPath chipPath = GetRoundedRect(chipRect, 6f)) {
                        // Chip shadow
                        Matrix m = new Matrix();
                        m.Translate(1, 2);
                        GraphicsPath chipShadow = (GraphicsPath)chipPath.Clone();
                        chipShadow.Transform(m);
                        g.FillPath(new SolidBrush(Color.FromArgb(100, 0, 0, 0)), chipShadow);

                        // Gold gradient fill
                        using (LinearGradientBrush chipBrush = new LinearGradientBrush(
                            new PointF(chipX, chipY),
                            new PointF(chipX + chipW, chipY + chipH),
                            Color.FromArgb(255, 245, 158, 11),  // gold
                            Color.FromArgb(255, 180, 83, 9)     // deep bronze
                        )) {
                            g.FillPath(chipBrush, chipPath);
                        }

                        // Gold border
                        using (Pen goldPen = new Pen(Color.FromArgb(255, 251, 191, 36), 1.5f)) {
                            g.DrawPath(goldPen, chipPath);
                        }

                        // Smart chip contact grid lines
                        using (Pen gridPen = new Pen(Color.FromArgb(160, 255, 255, 255), 1.0f)) {
                            g.DrawLine(gridPen, chipX + (chipW * 0.35f), chipY + 4, chipX + (chipW * 0.35f), chipY + chipH - 4);
                            g.DrawLine(gridPen, chipX + (chipW * 0.65f), chipY + 4, chipX + (chipW * 0.65f), chipY + chipH - 4);
                            g.DrawLine(gridPen, chipX + 4, chipY + (chipH * 0.5f), chipX + chipW - 4, chipY + (chipH * 0.5f));
                        }
                    }
                }

                // Save result with high quality JPEG
                ImageCodecInfo jpgEncoder = GetEncoder(ImageFormat.Jpeg);
                EncoderParameters myEncoderParameters = new EncoderParameters(1);
                myEncoderParameters.Param[0] = new EncoderParameter(Encoder.Quality, 96L);

                result.Save(outputPath, jpgEncoder, myEncoderParameters);
            }
        }
    }

    private static GraphicsPath GetRoundedRect(RectangleF rect, float radius) {
        GraphicsPath path = new GraphicsPath();
        float d = radius * 2f;
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

Add-Type -TypeDefinition $csharpEmbedder -ReferencedAssemblies "System.Drawing"

$cardPath = "D:\PHOTO DESIGNING\MIRR_Modern_ID_Front.jpg"
$photoPath = "D:\PHOTO DESIGNING\Professional_ID_Photo.jpg"
$outputPath = "D:\PHOTO DESIGNING\MIRR_Modern_ID_Front.jpg"
$outputBackup = "D:\PHOTO DESIGNING\MIRR_Modern_ID_Front_WithExactPhoto.jpg"
$outputArtifact = "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Modern_ID_Front.jpg"

[CardPhotoEmbedder]::EmbedUserPhoto($cardPath, $photoPath, $outputBackup)
Copy-Item $outputBackup $outputPath -Force
Copy-Item $outputBackup $outputArtifact -Force
Copy-Item $outputBackup "D:\PHOTO DESIGNING\MIRR_Employee_ID_Front.jpg" -Force
Copy-Item $outputBackup "C:\Users\MIRR\.gemini\antigravity\brain\fb929fa1-f8b6-473d-90ea-cdcebdf42efd\MIRR_Employee_ID_Front.jpg" -Force

Write-Host "Exact ID photo embedded into ID card successfully!"
